# Abbrevia

Package identity: `NXRP.Compression.Abbrevia`.

`external/abbrevia` is maintained directly by `nexus-packages-ext`, including its
NexusFPC corrections. It is an ordinary tracked directory; no separate fork is
required. Nexus consumes runtime units directly. The default FPC bzip2
configuration loads its library at runtime.

Upstream history, authors, preserved corrections, and license indicators are in
the [central attribution record](https://github.com/nxrp-dev/nexus/blob/main/ATTRIBUTIONS.md#abbrevia).
Original notices, codec sources, and archive fixtures remain with the runtime.

## Unit names

Pascal units use two-part names: `Abbrevia.` followed by a descriptive unit name,
such as `Abbrevia.Zip`, `Abbrevia.ZipCompression`, or `Abbrevia.DeflateStreams`. Unit
declarations, filenames, uses clauses, qualified references, test cases, and
localization alternatives use the same names. Classes and exceptions retain the `TAb` and `EAb` prefixes to avoid name
collisions, with cryptic abbreviations expanded. Consumers must update their uses
clauses and renamed identifiers; no compatibility aliases are supplied.

| Previous unit | Current unit |
| --- | --- |
| `AbArcTyp` | `Abbrevia.Archive` |
| `AbBase` | `Abbrevia.Base` |
| `AbBitBkt` | `Abbrevia.BitBucket` |
| `AbBrowse` | `Abbrevia.Browser` |
| `AbBytes` | `Abbrevia.Bytes` |
| `AbBzip2` | `Abbrevia.BZip2` |
| `AbBzip2Typ` | `Abbrevia.BZip2Archive` |
| `AbCBrows` | `Abbrevia.CabinetBrowser` |
| `AbCabExt` | `Abbrevia.CabinetExtractor` |
| `AbCabKit` | `Abbrevia.CabinetKit` |
| `AbCabMak` | `Abbrevia.CabinetBuilder` |
| `AbCabTyp` | `Abbrevia.Cabinet` |
| `AbCharset` | `Abbrevia.Charset` |
| `AbCompnd` | `Abbrevia.CompoundFile` |
| `AbConst` | `Abbrevia.Constants` |
| `AbCrtl` | `Abbrevia.CRuntime` |
| `AbDfBase` | `Abbrevia.DeflateBase` |
| `AbDfCryS` | `Abbrevia.DeflateCryptoStream` |
| `AbDfDec` | `Abbrevia.DeflateDecoder` |
| `AbDfEnc` | `Abbrevia.DeflateEncoder` |
| `AbDfHufD` | `Abbrevia.DeflateHuffmanDecoder` |
| `AbDfInW` | `Abbrevia.DeflateInputWindow` |
| `AbDfOutW` | `Abbrevia.DeflateOutputWindow` |
| `AbDfPkMg` | `Abbrevia.DeflatePackageMerge` |
| `AbDfStrm` | `Abbrevia.DeflateStreams` |
| `AbDfXlat` | `Abbrevia.DeflateTranslation` |
| `AbExcept` | `Abbrevia.Exceptions` |
| `AbFciFdi` | `Abbrevia.CabinetAPI` |
| `AbGzTyp` | `Abbrevia.GZip` |
| `AbLZMA` | `Abbrevia.LZMA` |
| `AbLZMAStream` | `Abbrevia.LZMAStream` |
| `AbPPMd` | `Abbrevia.PPMd` |
| `AbResString` | `Abbrevia.ResourceStrings` |
| `AbSWStm` | `Abbrevia.SlidingWindowStream` |
| `AbSelfEx` | `Abbrevia.SelfExtractor` |
| `AbSpanSt` | `Abbrevia.SpanningStream` |
| `AbTarTyp` | `Abbrevia.Tar` |
| `AbUnzOutStm` | `Abbrevia.UnzipOutputStream` |
| `AbUnzPrc` | `Abbrevia.ZipExtraction` |
| `AbUnzper` | `Abbrevia.Unzipper` |
| `AbUtils` | `Abbrevia.Utilities` |
| `AbVMStrm` | `Abbrevia.VirtualMemoryStream` |
| `AbWavPack` | `Abbrevia.WavPack` |
| `AbZBrows` | `Abbrevia.ZipBrowser` |
| `AbZLTyp` | `Abbrevia.ZLib` |
| `AbZipExt` | `Abbrevia.ZipExtractor` |
| `AbZipKit` | `Abbrevia.ZipKit` |
| `AbZipPrc` | `Abbrevia.ZipCompression` |
| `AbZipTyp` | `Abbrevia.Zip` |
| `AbZipper` | `Abbrevia.Zipper` |

Examples of the class and exception names:

| Previous name | Current name |
| --- | --- |
| `TAbDfInBitStream` | `TAbDeflateInputBitStream` |
| `TAbDfCodeLenStream` | `TAbDeflateCodeLengthTokenStream` |
| `TAbDfLZStream` | `TAbDeflateLZ77TokenStream` |
| `TAbMakeCab` | `TAbCabinetBuilder` |
| `TAbCabBrowser` | `TAbCabinetBrowser` |
| `TAbMakeSelfExe` | `TAbSelfExtractorBuilder` |
| `TBZCompressionStream` | `TAbBZip2CompressionStream` |
| `EAbVMSSeekFail` | `EAbVirtualMemoryStreamSeekFailed` |
| `EAbZipInvalidLFH` | `EAbZipInvalidLocalFileHeader` |

The two-part unit names and expanded class names were verified with a clean Win64
Forge build and all 33 archive extraction checks described below. The Delphi-only distribution material has since been retired as described below.

## Retired toolchain material

The maintained package targets NexusFPC. Delphi/C++Builder package projects,
VCL/CLX/FireMonkey controls, property editors, registration code and icons,
the Delphi COM automation wrapper, IDE test runners, and Borland OMF/ELF codec
binaries were removed on 2026-10-12 (376 files). Native codec linker directives
now use the LLVM object names on both Windows architectures; the Forge recipe supplies
Win64 objects. Win32 still requires its own native codec build.

Nonvisual archive components, Windows CAB support, self-extractor construction,
and compound-file storage remain. The compound-file classes no longer expose
VCL tree-view population methods. Runtime units use FPC string/file helpers;
Unix code uses `BaseUnix` instead of Delphi's `Posix.*` bindings. Compiler-version
workarounds and Borland-only C header branches are gone.

The supplied Pascal cases and native codec checks have been migrated to [nxtest](test/README.md) in the package test folder. See [current results](test/RESULTS.md) for verified coverage and failures.

The Forge `Mode: delphi` setting selects NexusFPC's Object Pascal language mode;
it does not require or invoke the Delphi compiler.

## Tests

Build and run the native nxtest suite using [test/README.md](test/README.md).
The package build no longer runs the superseded standalone linkage probe.

## Historical Forge build

`Package.nxscript` owns the Win64 build through ordered children. Its first child,
the `NativeCodecs` group, prepares `output/forge` and compiles all 37 bundled C
sources with **one Clang invocation**: LZMA (7), PPMd (3), WavPack (20), bzip2 (7).
There is no PowerShell build script or helper executable.

The group copies Pascal sources into `output/forge/source`,
excluding prebuilt objects and compiled units. Clang writes its objects directly
to `output/forge/source/Win64`. Win64 Pascal linker directives use these generated
`.o` filenames, without a WavPack prefix or a renaming step. Native objects are
generated from the retained C sources.

Subsequent children stage the four SDK/CRT import libraries, compile the existing
Pascal runtime units. Run tests separately through the nxtest project. `Outputs.Objects` exports the actual object
directory. UnitPaths,
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

The Win64 PPMd binding was corrected on 2026-10-12: imported records use C
alignment, internal references occupy 32 bits, and the small packed records match
`Ppmd.h`. Before this correction, extracting the bundled `Canterbury/PPMd.zip`
raised an access violation. After a clean Forge rebuild, all 11 files from each
of `Deflate.zip`, `LZMA.zip`, and `PPMd.zip` matched the original bytes (33 checks).

Regression case for nxtest: extract every entry in
`test/testfiles/Canterbury/PPMd.zip` through
`Abbrevia.ZipExtraction.AbUnzipToStream` and compare it with the corresponding
entry in the bundled `Store.zip`. Use the stored archive as the byte reference;
Git can convert line endings in the checked-out `Canterbury/source` text files.
This behavioral check is separate from the package's existing startup probe.

The previously identified static-bzip2 Pascal linkage gap remains: that path
lacks `bz_internal_error`, `BZ2_rNums`, and `BZ2_crc32Table`. The runtime now uses
FPC's string routines in place of `AnsiStrings`. The recipe currently targets Win64.

After retiring the Delphi-specific material, the clean Forge build again passed
with all 37 LLVM object files, and all 33 archive extraction checks passed. All
50 retained runtime units compiled and linked together on Win64 and passed the
startup check, including the nonvisual components and compound-file classes.
Their compilation also passed with the existing x86-64 Linux cross compiler;
that check did not link or execute a Linux program, and Windows-only codec/CAB
implementations are excluded by their platform guards. Win32 was not rebuilt.
All 87 archive-fixture files were verified byte-for-byte unchanged. The only C
source/header changes removed Borland-only preprocessor branches in three headers.
