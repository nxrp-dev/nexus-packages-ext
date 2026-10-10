# Abbrevia

Package identity: `NXRP.Compression.Abbrevia`.

`external/abbrevia` is maintained directly by `nexus-packages-ext`, including its
NexusFPC corrections. It is an ordinary tracked directory, with no separate Git
repository or fork required. The import originated at
`https://github.com/TurboPack/Abbrevia.git`, revision
`805915396d0cc597e7c55df9fbb36057e65748df` (2026-09-23). That revision records
provenance; future maintenance belongs to this repository.

All 627 files from the former submodule are retained at the same paths, including
the corrected working contents of 15 Pascal files, test archives, resources,
bundled objects and C codec sources. Original MPL 1.1 and third-party notices are
intact. The original README and Delphi IDE packages remain as supplied material;
Nexus consumes runtime units directly.

The retained local corrections cover FPC unit/directive compatibility, stream
and byte-buffer handling, archive metadata conversions, path operations, TAR
processing, CRT helpers, and WavPack helpers. The default FPC bzip2 configuration
remains runtime DLL loading. This ownership conversion changes no Pascal or C
source bytes and does not introduce a new runtime or threading design.

## LLVM codec build

[Build-AbbreviaLLVM.ps1](scripts/Build-AbbreviaLLVM.ps1) preserves the successful
Win64 build recipe recovered from the original temporary LLVM probe. It builds
all 37 bundled C translation units: LZMA (7), PPMd (3), WavPack (20), bzip2 (7).
It checks that every output is COFF x86-64, then creates a private Pascal source
overlay with those objects under the names required by the existing `$L`
directives. Original bundled binaries remain untouched.

Run from this package directory, choosing a new or empty output directory:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\Build-AbbreviaLLVM.ps1 -OutputRoot C:\build\abbrevia-llvm -FPCSourceRoot C:\gitdev\tools\nexus-fpc
```

The optional `FPCSourceRoot` must contain a matched native compiler and RTL build.
It enables the combined Pascal link/startup probe using the LLVM LZMA, PPMd and
WavPack objects, with the existing runtime-loaded bzip2 configuration. Omit that
parameter to build and inspect only the C objects. When compiling applications
with these generated objects, use the generated `source` overlay for `-Fu`,
`-Fi` and `-Fo`, and the four SDK/CRT import libraries recorded in the build log.
`objects.json` records source and object hashes; `logs/steps.json` records exact
commands, versions and results.

The known toolchain is LLVM/Clang 23.1.2, MSVC headers/import libraries
14.29.30133, and Windows SDK 10.0.19041.0. Override `LLVMRoot`, `VCToolsRoot`,
`WindowsSDKRoot`, and `WindowsSDKVersion` for a different installation. Clang's
resource headers must precede the MSVC headers. The script locates that resource
directory through Clang, sets the Win64 target explicitly, uses `BZ_NO_STDIO` for
bzip2, and supplies `kernel32.lib`, `ucrt.lib`, `vcruntime.lib` and `msvcrt.lib`
for the Pascal link. MSBuild and `cl.exe` are not used.

The existing Forge integration remains owned by the main Nexus repository:

- `projects/forge/examples/AbbreviaLLVM.Forge.nxscript`
- `projects/forge/examples/Clang.mustache` and `LLVMAr.mustache`
- `projects/forge/test/fixtures/llvm/AbbreviaRoundTrip.cpp`

From the Nexus root, the established commands build the seven bzip2 objects,
create their COFF library, link the C++ fixture with LLD, and verify restored bytes:

```powershell
output/NexusForge-next/x86_64-win64/nxforge.exe /input=projects/forge/examples/AbbreviaLLVM.Forge.nxscript
output/AbbreviaLLVM-roundtrip.exe
```

## Validation and retained limits

The ownership migration preserves all original source and object hashes. The
37-source C rebuild, COFF-header inspection, combined Pascal runtime link/startup,
and existing Forge round trip have passed. The Pascal check used the matched
NexusFPC 3.3.1 bootstrap in `C:\gitdev\npuid`, including the Nexus artifact identity
change. The Forge round trip compresses 4096 bytes to 100 and restores all 4096
bytes identically.

A checkout recreated from the Git index reproduced the same complete build and
Pascal startup test without the former submodule or temporary probe. All 627
imported files matched their pre-conversion bytes exactly in both the working
directory and that checkout. The successful recipe recorded 41 build/check steps.

The recovered probe notes describe a successful combined Pascal link/startup
test with runtime-loaded bzip2, not a complete codec or archive regression suite.
A new static-bzip2 Pascal check with the current compiler reaches LLD but lacks
`bz_internal_error`, `BZ2_rNums`, and `BZ2_crc32Table`. That integration path is
not changed here. The original probe also stopped the full Delphi runtime unit
list at `AbCabTyp`'s missing `AnsiStrings`; the complete Delphi/IDE package is
outside the preserved core-runtime build.

The pre-conversion sources, Git history, fixes, original LLVM objects, scripts,
and logs were backed up under
`C:\gitdev\nexus\output\AbbreviaOwnership-20261010`. This local backup supplements
the directly tracked sources and reproducible recipe; commit and push this
repository before relying on a new-machine checkout.

`abbrevia-ready-to-commit.zip` in that backup directory is a complete export of
the staged Abbrevia package, including C sources, object files and archive test
fixtures. `originals.zip` preserves the pre-conversion working tree and temporary
LLVM work; `abbrevia-history.bundle` preserves the original Git history.
