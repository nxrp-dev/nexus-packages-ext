# Abbrevia

Package identity: `NXRP.Compression.Abbrevia`.

`external/abbrevia` is maintained directly by `nexus-packages-ext`, including its
NexusFPC corrections. It is an ordinary tracked directory; no separate fork is
required. Nexus consumes runtime units directly. The default FPC bzip2
configuration loads its library at runtime.

Upstream history, authors, preserved corrections, and license indicators are in
the [central attribution record](https://github.com/nxrp-dev/nexus/blob/main/ATTRIBUTIONS.md#abbrevia).
Original notices, codec sources, bundled binaries, and archive fixtures remain
with the imported material.

## Unit names

Pascal units use descriptive dotted names beginning with `Abbrevia.`. Unit
declarations, filenames, uses clauses, qualified references, package manifests,
examples, tests, localization alternatives, and companion resources use the same
names. Classes and other public identifiers retain their upstream names.
Consumers must update their uses clauses; no legacy alias units are supplied.

| Previous unit | Current unit |
| --- | --- |
| `AbArcTyp` | `Abbrevia.Archive.Types` |
| `AbBase` | `Abbrevia.Base` |
| `AbBitBkt` | `Abbrevia.BitBucket` |
| `AbBrowse` | `Abbrevia.Browser` |
| `AbBseCLX` | `Abbrevia.CLX.Base` |
| `AbBseVCL` | `Abbrevia.VCL.Base` |
| `AbBytes` | `Abbrevia.Bytes` |
| `AbBzip2` | `Abbrevia.BZip2` |
| `AbBzip2Typ` | `Abbrevia.BZip2.Types` |
| `AbCBrows` | `Abbrevia.Cabinet.Browser` |
| `AbCView` | `Abbrevia.Cabinet.View` |
| `AbCabExt` | `Abbrevia.Cabinet.Extractor` |
| `AbCabKit` | `Abbrevia.Cabinet.Kit` |
| `AbCabMak` | `Abbrevia.Cabinet.Builder` |
| `AbCabTyp` | `Abbrevia.Cabinet.Types` |
| `AbCharset` | `Abbrevia.Charset` |
| `AbComCtrls` | `Abbrevia.CommonControls` |
| `AbCompnd` | `Abbrevia.CompoundFile` |
| `AbConst` | `Abbrevia.Constants` |
| `AbCrtl` | `Abbrevia.CRuntime` |
| `AbDfBase` | `Abbrevia.Deflate.Base` |
| `AbDfCryS` | `Abbrevia.Deflate.CryptoStream` |
| `AbDfDec` | `Abbrevia.Deflate.Decoder` |
| `AbDfEnc` | `Abbrevia.Deflate.Encoder` |
| `AbDfHufD` | `Abbrevia.Deflate.HuffmanDecoder` |
| `AbDfInW` | `Abbrevia.Deflate.InputWindow` |
| `AbDfOutW` | `Abbrevia.Deflate.OutputWindow` |
| `AbDfPkMg` | `Abbrevia.Deflate.PackageMerge` |
| `AbDfStrm` | `Abbrevia.Deflate.Stream` |
| `AbDfXlat` | `Abbrevia.Deflate.Translation` |
| `AbDlgDir` | `Abbrevia.Dialogs.Directory` |
| `AbExcept` | `Abbrevia.Exceptions` |
| `AbFciFdi` | `Abbrevia.Cabinet.API` |
| `AbGzTyp` | `Abbrevia.GZip.Types` |
| `AbHexVw` | `Abbrevia.HexView` |
| `AbLZMA` | `Abbrevia.LZMA` |
| `AbLZMAStream` | `Abbrevia.LZMA.Stream` |
| `AbMeter` | `Abbrevia.Meter` |
| `AbPPMd` | `Abbrevia.PPMd` |
| `AbPeCol` | `Abbrevia.Editors.Collection` |
| `AbReg` | `Abbrevia.Registration` |
| `AbResString` | `Abbrevia.ResourceStrings` |
| `AbSWStm` | `Abbrevia.SlidingWindowStream` |
| `AbSelfEx` | `Abbrevia.SelfExtractor` |
| `AbSpanSt` | `Abbrevia.SpanningStream` |
| `AbTarTyp` | `Abbrevia.Tar.Types` |
| `AbUnzOutStm` | `Abbrevia.Unzip.OutputStream` |
| `AbUnzPrc` | `Abbrevia.Unzip.Procedures` |
| `AbUnzper` | `Abbrevia.Unzipper` |
| `AbUtils` | `Abbrevia.Utilities` |
| `AbVMStrm` | `Abbrevia.VirtualMemoryStream` |
| `AbView` | `Abbrevia.View` |
| `AbWavPack` | `Abbrevia.WavPack` |
| `AbZBrows` | `Abbrevia.Zip.Browser` |
| `AbZLTyp` | `Abbrevia.ZLib.Types` |
| `AbZView` | `Abbrevia.Zip.View` |
| `AbZipExt` | `Abbrevia.Zip.Extractor` |
| `AbZipKit` | `Abbrevia.Zip.Kit` |
| `AbZipOut` | `Abbrevia.Zip.Output` |
| `AbZipPrc` | `Abbrevia.Zip.Procedures` |
| `AbZipTyp` | `Abbrevia.Zip.Types` |
| `AbZipper` | `Abbrevia.Zipper` |
| `Abbrevia_TLB` | `Abbrevia.COM.TypeLibrary` |
| `FMX.AbDlgPwd` | `Abbrevia.FMX.Dialogs.Password` |
| `FMX.AbPeDir` | `Abbrevia.FMX.Editors.Directory` |
| `FMX.AbPeFn` | `Abbrevia.FMX.Editors.FileName` |
| `FMX.AbPePass` | `Abbrevia.FMX.Editors.Password` |
| `FMX.AbPeVer` | `Abbrevia.FMX.Editors.Version` |
| `FMX.AbReg` | `Abbrevia.FMX.Registration` |
| `Vcl.AbDlgPwd` | `Abbrevia.VCL.Dialogs.Password` |
| `Vcl.AbPeDir` | `Abbrevia.VCL.Editors.Directory` |
| `Vcl.AbPeFn` | `Abbrevia.VCL.Editors.FileName` |
| `Vcl.AbPePass` | `Abbrevia.VCL.Editors.Password` |
| `Vcl.AbPeVer` | `Abbrevia.VCL.Editors.Version` |
| `Vcl.AbReg` | `Abbrevia.VCL.Registration` |
| `_GZipItem` | `Abbrevia.COM.GZipItem` |
| `_TarItem` | `Abbrevia.COM.TarItem` |
| `_ZipItem` | `Abbrevia.COM.ZipItem` |
| `_ZipKit` | `Abbrevia.COM.ZipKit` |

## Forge build

`Package.nxscript` owns the Win64 build through ordered children. Its first child,
the `NativeCodecs` group, prepares `output/forge` and compiles all 37 bundled C
sources with **one Clang invocation**: LZMA (7), PPMd (3), WavPack (20), bzip2 (7).
There is no PowerShell build script or helper executable.

The group copies Pascal sources and resources into `output/forge/source`,
excluding prebuilt objects and compiled units. Clang writes its objects directly
to `output/forge/source/Win64`. Win64 Pascal linker directives use these generated
`.o` filenames, without a WavPack prefix or a renaming step. Imported C sources
and bundled binaries are not overwritten.

Subsequent children stage the four SDK/CRT import libraries, compile the existing
Pascal runtime probe, and run it. `Outputs.Objects` exports the actual object
directory. `Outputs.RuntimeCheck` identifies the probe executable; UnitPaths,
IncludePaths, and LibraryPaths expose the corresponding build directories.

From the Nexus root, after building Forge and the native NexusFPC bootstrap:

```text
output/NexusForge/x86_64-win64/nxforge.exe /input=packages/nexus-packages-ext/compression/abbrevia/Package.nxscript
```

The compiler and RTL come from the sibling NexusFPC checkout's
`build/forge-bootstrap/cycle3`. Required `rtl-objpas` and `rtl-generics` units
compile from that checkout's package sources into this package's output tree.
The recipe does not rely on binaries in `compiler` or `rtl/units`.

The recipe explicitly names the installed LLVM 23 resource headers, MSVC
14.29.30133 headers/import libraries, and Windows SDK 10.0.19041.0. Adjust those
paths in the descriptor for another installation. Clang's intrinsic headers
precede the MSVC headers. The resource-header directory is now an explicit
setting; the retired script queried Clang for that path. The build uses the
Win64 MSVC target, optimization level 2, disabled stack protection, and
`BZ_NO_STDIO`. The latter is only
inspected by the bzip2 sources. Pascal linkage includes `kernel32.lib`,
`ucrt.lib`, `vcruntime.lib`, and `msvcrt.lib`.

An importing consumer can inspect the contract without building. An explicit
composed Package child executes the ordered build at that position.

## Validation and limits

The direct Forge recipe was verified on 2026-10-12 using the existing isolated
Forge-built NexusFPC compiler and matching RTL. Its single Clang command selected
all 37 sources; all 37 outputs were inspected as COFF x86-64. The Pascal runtime
probe compiled, linked, and ran successfully. No PowerShell command was launched
by the package. The former PowerShell recovery recipe has been removed.

The Pascal probe verifies linkage/startup of the core runtime with LLVM LZMA,
PPMd and WavPack objects. It does not exercise every codec or archive operation.
Bzip2 still uses runtime DLL loading; this object build does not create that DLL.
The separately retained C/C++ bzip2 round-trip project is
`projects/forge/examples/AbbreviaLLVM.Forge.nxscript` in the Nexus repository.

The previously identified static-bzip2 Pascal linkage gap remains: that path
lacks `bz_internal_error`, `BZ2_rNums`, and `BZ2_crc32Table`. The full Delphi/IDE
unit list also previously stopped at `Abbrevia.Cabinet.Types`'s missing `AnsiStrings` unit.
Neither path is part of this build migration. The recipe currently targets Win64.
