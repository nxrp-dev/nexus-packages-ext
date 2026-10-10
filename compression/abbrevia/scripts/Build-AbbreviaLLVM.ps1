# Copyright (c) 2026 Kevin Collins.
# SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
<#
.SYNOPSIS
Rebuild Abbrevia's 37 Win64 C codec objects using LLVM, with optional Pascal validation.
.DESCRIPTION
Creates an isolated source overlay containing the LLVM objects under the names
used by Abbrevia's Pascal linker directives. Original package files are never
overwritten. Toolchain roots are explicit so the build survives machine changes.
#>
[CmdletBinding()]
param(
    [string]$OutputRoot,
    [string]$LLVMRoot = 'C:\Program Files\LLVM',
    [string]$VCToolsRoot = 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.29.30133',
    [string]$WindowsSDKRoot = 'C:\Program Files (x86)\Windows Kits\10',
    [string]$WindowsSDKVersion = '10.0.19041.0',
    [string]$FPCSourceRoot
)
$ErrorActionPreference = 'Stop'
$packageRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$sourceRoot = Join-Path $packageRoot 'external\abbrevia'
if (-not $OutputRoot) {
    $OutputRoot = Join-Path $packageRoot ('output\llvm-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
}
$OutputRoot = [IO.Path]::GetFullPath($OutputRoot)
if ((Test-Path -LiteralPath $OutputRoot) -and @(Get-ChildItem -LiteralPath $OutputRoot -Force).Count) {
    throw 'OutputRoot must be new or empty; builds must not reuse old objects.'
}
if ($FPCSourceRoot) {
    $FPCSourceRoot = (Resolve-Path -LiteralPath $FPCSourceRoot).Path
    if ($OutputRoot -match '\s' -or $FPCSourceRoot -match '\s') {
        throw 'The Pascal linker requires OutputRoot and FPCSourceRoot without whitespace.'
    }
}
$clang = Join-Path $LLVMRoot 'bin\clang.exe'
$readobj = Join-Path $LLVMRoot 'bin\llvm-readobj.exe'
$libraries = @(
    (Join-Path $WindowsSDKRoot "Lib\$WindowsSDKVersion\um\x64\kernel32.lib"),
    (Join-Path $WindowsSDKRoot "Lib\$WindowsSDKVersion\ucrt\x64\ucrt.lib"),
    (Join-Path $VCToolsRoot 'lib\x64\vcruntime.lib'),
    (Join-Path $VCToolsRoot 'lib\x64\msvcrt.lib')
)
$required = @($clang, $readobj, "$VCToolsRoot\include\vcruntime.h",
              "$WindowsSDKRoot\Include\$WindowsSDKVersion\ucrt\stdio.h")
if ($FPCSourceRoot) {
    $required += $libraries
    $required += @("$FPCSourceRoot\compiler\ppcx64.exe", "$FPCSourceRoot\rtl\units\x86_64-win64\system.ppu")
}
foreach ($path in $required) {
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing toolchain input: $path" }
}
$resourceDirectory = & $clang -print-resource-dir
if ($LASTEXITCODE -ne 0) { throw 'Clang could not report its resource directory.' }
$resourceHeaders = Join-Path ($resourceDirectory.Trim()) 'include'
if (-not (Test-Path -LiteralPath $resourceHeaders)) { throw "Missing Clang headers: $resourceHeaders" }
$logs = Join-Path $OutputRoot 'logs'
New-Item -ItemType Directory -Force -Path $logs | Out-Null
$steps = [Collections.Generic.List[object]]::new()
function Invoke-Step([string]$Name, [string]$Executable, [string[]]$Arguments) {
    $log = Join-Path $logs ($Name + '.log')
    Push-Location -LiteralPath $OutputRoot
    try {
        $ErrorActionPreference = 'Continue'
        & $Executable @Arguments *> $log
        $code = $LASTEXITCODE
    } finally { Pop-Location; $ErrorActionPreference = 'Stop' }
    $steps.Add([pscustomobject]@{Name=$Name;Executable=$Executable;Arguments=$Arguments;ExitCode=$code;Log=$log})
    $steps.ToArray() | ConvertTo-Json -Depth 6 | Set-Content "$logs\steps.json" -Encoding UTF8
    if ($code -ne 0) { throw "$Name failed ($code). Details: $log" }
    Write-Host "PASS $Name"
}
Invoke-Step 'clang-version' $clang @('--version')
$overlay = Join-Path $OutputRoot 'source'
Copy-Item -LiteralPath "$sourceRoot\source" -Destination $overlay -Recurse
$objects = [Collections.Generic.List[string]]::new()
$records = [Collections.Generic.List[object]]::new()
foreach ($codec in @('lzma','ppmd','wavpack','bzip2')) {
    $objectDirectory = Join-Path $OutputRoot $codec
    New-Item -ItemType Directory -Path $objectDirectory | Out-Null
    foreach ($file in Get-ChildItem -LiteralPath "$sourceRoot\thirdparty\$codec" -Filter '*.c' | Sort-Object Name) {
        $object = Join-Path $objectDirectory ($file.BaseName + '.obj')
        # Keep Clang's intrinsic headers ahead of MSVC's, as in the original build.
        $arguments = @('--target=x86_64-pc-windows-msvc','-O2','-fno-stack-protector',
                       '-isystem',$resourceHeaders,'-isystem',"$VCToolsRoot\include")
        foreach ($part in @('ucrt','shared','um')) {
            $arguments += @('-isystem',"$WindowsSDKRoot\Include\$WindowsSDKVersion\$part")
        }
        if ($codec -eq 'bzip2') { $arguments += '-DBZ_NO_STDIO' }
        $arguments += @('-c',$file.FullName,'-o',$object)
        Invoke-Step "$codec-$($file.BaseName)" $clang $arguments
        $objects.Add($object)
        $stem = $file.BaseName
        $extension = '.obj'
        if ($codec -in @('lzma','ppmd')) { $extension = '.o' }
        if ($codec -eq 'wavpack') { $stem = 'WavPack_' + $stem }
        $relativeObject = "Win64\$stem$extension"
        Copy-Item -LiteralPath $object -Destination (Join-Path $overlay $relativeObject)
        $records.Add([pscustomobject]@{Codec=$codec;Source=$file.Name;
            SourceSHA256=(Get-FileHash -LiteralPath $file.FullName).Hash;
            Object=$relativeObject;ObjectSHA256=(Get-FileHash -LiteralPath $object).Hash})
    }
}
if ($objects.Count -ne 37) { throw "Expected the preserved 37-source codec inventory, found $($objects.Count)." }
Invoke-Step 'object-headers' $readobj (@('--file-headers') + $objects.ToArray())
$headers = Get-Content -LiteralPath "$logs\object-headers.log" -Raw
if ([regex]::Matches($headers,'Format: COFF-x86-64').Count -ne 37) {
    throw 'Not every generated object is Win64 COFF.'
}
$records.ToArray() | ConvertTo-Json -Depth 5 | Set-Content "$OutputRoot\objects.json" -Encoding UTF8

if ($FPCSourceRoot) {
    $compiler = Join-Path $FPCSourceRoot 'compiler\ppcx64.exe'
    if ((& $compiler -iTP) -ne 'x86_64' -or (& $compiler -iTO) -ne 'win64') {
        throw 'Pascal validation requires a matching native Win64 compiler and RTL.'
    }
    $units = Join-Path $OutputRoot 'units'
    $runtimeLibraries = Join-Path $OutputRoot 'runtime-libs'
    New-Item -ItemType Directory -Path $units,$runtimeLibraries | Out-Null
    foreach ($library in $libraries) { Copy-Item -LiteralPath $library -Destination $runtimeLibraries }
    Copy-Item -LiteralPath "$packageRoot\test\AbbreviaLLVMRuntime.pas" -Destination $OutputRoot
    # Preserve the successful probe's default Bzip2Runtime configuration.
    # Static bzip2 Pascal linkage is a separate, incomplete integration path.
    $arguments = @('-n','-Mdelphi','-B',"-Fu$FPCSourceRoot\rtl\units\x86_64-win64",
        "-Fu$FPCSourceRoot\packages\rtl-objpas\units\x86_64-win64",
        "-Fu$FPCSourceRoot\packages\rtl-generics\units\x86_64-win64",
        "-Fu$overlay","-Fi$overlay","-Fo$overlay","-FU$units","-FE$OutputRoot","-FD$LLVMRoot\bin")
    foreach ($library in $libraries) { $arguments += '-k' + (Join-Path $runtimeLibraries (Split-Path $library -Leaf)) }
    Invoke-Step 'pascal-runtime-build' $compiler ($arguments + @("$OutputRoot\AbbreviaLLVMRuntime.pas"))
    Invoke-Step 'pascal-runtime-run' "$OutputRoot\AbbreviaLLVMRuntime.exe" @()
}
Write-Host "Built all 37 LLVM codec objects. Pascal source overlay: $overlay"
