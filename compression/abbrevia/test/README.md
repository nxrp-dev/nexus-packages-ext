# Abbrevia nxtest suite

The active suite is `AbbreviaTests.lpr`, registered through `tsAbbreviaTests` and
`tsAbCodecTests`. It uses the NexusTest registry, suites, contexts, assertions,
result objects, failure handling, and skip reporting. This is the same executable
runner pattern used by the existing SQLite and nxbuild tests. No DUnit dependency
or compatibility layer is used by the active suite.

There are 232 registered cases across 33 logical suites. Six supplied disabled
cases with unavailable reference inputs were removed. The custom codec checks retain all 52
previous byte comparisons/round trips plus the C layout and library checks.
A shared-RTL regression also checks inline Trim/encoding references and checked
Int64 arithmetic while consuming the compiled packages.
See [RESULTS.md](RESULTS.md) for the latest results and remaining limitations.

## Build and run

`AbbreviaSourceTests.nxproject` requires the Abbrevia source/native provider and
NexusTest. nxbuild builds the codecs first and inherits their directories; this
source consumer requires no compiler package SDK. From the Nexus repository:

```sh
"$NXBUILD" /action=build /project=packages/nexus-packages-ext/compression/abbrevia/test/AbbreviaSourceTests.nxproject
```

Configure the external output root in the shared nxbuild environment. For an
output root `$NX_OUT`, native Linux execution is:

```sh
export LD_LIBRARY_PATH="$NX_OUT/abbrevia/x86_64-linux/libraries"
export NX_ABBREVIA_EXPECTED_BZIP2_LIBRARY="$LD_LIBRARY_PATH/libbz2.so.1"
"$NX_OUT/abbrevia-source-tests/x86_64-linux/AbbreviaTests" "$TEST_DATA"
```

`$TEST_DATA` is an untouched copy of `test/testfiles` under the external worktree.
The library identity test compares the loaded module with the explicitly expected
producer artifact. It rejects a system library or any other path. Without an
explicit expectation, it checks beside the executable, which remains useful for
deployments that place their runtime libraries there.

`AbbreviaTests.nxproject` separately retains `RequiredPackages: [nxrtl, Abbrevia]`
for compiler-native runtime-package consumption. It requires the ordinary
`AbbreviaRuntime` project, which in turn requires the source/native provider.
Configure the matching installed compiler package SDK and identity before using
that test project. Provide `nxrtl.nxpl` and `Abbrevia.nxpl` on the native runtime
loader path, as well as the bzip2 library, and set the same explicit bzip2
expectation for its actual producer location.

The executable returns nonzero for failures/errors or when no case passes. Skips
are counted separately. An optional second argument filters test IDs by substring,
for example `Abbrevia.NativeCodecs`. Fixtures own temporary directories and remove
them on completion, including failure paths. Build outputs remain outside source.

## Focused Win32 / Win64 core checks

AbbreviaCoreTests.lpr runs the same eleven focused nxtest cases registered in the
full suite: three Cabinet API/layout/file/stream cases, six DCL/gzip cases, and
two ZIP filename cases. It has no dependency on the LLVM codecs. Both Windows
architectures can validate these features independently. The source and cases
remain here under test.

This is the verified Win32 invocation from the Nexus root; use the compiler and
matching RTL from the same build. Build products stay under output:

```powershell
$cross = "$PWD/output/ForgeComposition/workspace/tools/nexus-fpc/build/forge-bootstrap/cross/i386-win32"
$abbrevia = "$PWD/packages/nexus-packages-ext/compression/abbrevia"
$out = "$PWD/output/nxbuild-abbrevia/i386-win32/core-tests"
New-Item -ItemType Directory -Force -Path $out | Out-Null
& "$cross/ppcross386.exe" -n -B -Mdelphi -Ratt -gl -Twin32 `
    "-Fu$cross/rtl" "-Fu$abbrevia/test" `
    "-Fu$abbrevia/external/abbrevia/source" "-Fi$abbrevia/external/abbrevia/source" `
    "-Fu$PWD/packages/nexus-packages/nxtest/src" `
    "-Fu$PWD/../tools/nexus-fpc/packages/rtl-objpas/src/inc" `
    "-Fu$PWD/../tools/nexus-fpc/packages/rtl-generics/src" `
    "-Fu$PWD/packages/nexus-packages/fcl-base/src" `
    "-Fi$PWD/../tools/nexus-fpc/packages/rtl-objpas/src/win" `
    "-FU$out" "-FE$out" "$abbrevia/test/AbbreviaCoreTests.lpr"
if ($LASTEXITCODE -ne 0) { throw 'Core test build failed' }
& "$out/AbbreviaCoreTests.exe"
```

The Win64 full-suite run above also executes these cases. The standalone entry
point returns nonzero on errors, failed assertions, or no passing tests.

## LZMA stream completion and ownership

Both wrappers support Windows and Linux. Decompression is synchronous. Compression
retains the existing worker so the encoder can wait for future input while the
caller continues supplying writes. Its additional input queue is bounded to 1 MiB;
a write waits when that queue is full. Codec dictionary/workspace allocations and
the SDK's existing internal threading settings are unchanged.

One caller owns producer operations. The destination stream is borrowed: keep it
alive, and do not access it until the worker has joined. Streams requiring all
access on their creating thread are unsuitable destinations for this worker.
Linux applications must initialize the thread manager with cthreads; the supplied
test entry points already do so.

Check explicit completion before accepting compressed output:

~~~pascal
lCompressor := TAbLZMACompressionStream.Create(lOutput);
try
  lCompressor.WriteBuffer(lData[0], Length(lData));
  LzmaCheck(lCompressor.WaitForCompressionToFinish);
finally
  lCompressor.Free;
end;
~~~

Completion closes input, joins the worker, and finalizes the size header before
returning. It returns the first error and may be called repeatedly. Writes raise
detected encoder errors. Destruction finishes and joins for cleanup, but does not
raise compression errors; this preserves any caller exception already unwinding.
IsBusy is only status, not a substitute for checked completion.

The twelve generated-data regressions in tsAbLZMAStreamTests.pas exercise chunked
and oversized input, queue wrap, empty input, output/header failures, blocked
writer failure, constructor cleanup, exception unwinding, and truncated input.
The full suite includes them. AbbreviaLZMAStreamTests.lpr runs those same cases
independently, including on Win32, without other codecs or external fixtures.
See RESULTS.md for the verified Win32 native build settings.

## Coverage and fixtures

The supplied cases cover archive lists, ZIP/TAR/GZip/Bzip2 archives, archive type
detection, ANSI filenames, spanning, compression/decompression streams, ZIP64's
90,000-entry save/reload case, virtual-memory streams, component streaming and
notifications, password/error handling, and Windows Cabinet APIs.

The native codec cases cover:

- Eight bzip2 buffer/stream round trips at 0, 1, 4096, and 1048576 bytes, plus
  C record size and verification that the generated sibling library was loaded.
- All 11 entries in each Canterbury Deflate, LZMA, and PPMd ZIP compared with
  Store.zip: 33 byte comparisons.
- Eight LZMA buffer/stream round trips at those four sizes.
- Three complete WavPack decodes for 8-, 16-, and 24-bit PCM.
- The shared C size_t type's unsigned range and pointer-sized storage.

All inputs live under `testfiles`. The Canterbury source files must match the
archived corpus byte for byte. Five checked-out files had CRLF expansion; their
original bytes were recovered from the supplied Store.zip after confirming that
line endings were the only differences. `.gitattributes` prevents future newline
conversion throughout testfiles. `.gitignore` explicitly includes archive and
executable fixtures so a normal check-in preserves them.

The six small generated WAV/WavPack files are in `testfiles/WavPack`. They contain
256 mono samples at 8 kHz: unsigned sample i at 8 bits, or signed
(i - 128) * 2^(bits - 8) at 16/24 bits. The WavPack 5.9.0 reference encoder produced
the lossless fixtures; it is not a build or runtime dependency.

## Platform skips

Windows has no skipped cases. Linux skips only the 22 cases that use Abbrevia's
Windows Cabinet API/classes. Both LZMA TStream wrappers and their supplied cases
now run on Linux, alongside the portable functions and ZIP LZMA extraction.

The six unavailable-fixture placeholders were removed: Unicode ZIP/TAR extraction,
WavPack-in-ZIP, and three ZIP64 cases needing external archives. Active filename
tests, three standalone WavPack decodes, and the generated 90,000-entry ZIP64
save/reload case remain. Supplied reference material remains under reference.

DCL Implode, gzip regression 822243, and CAB AddFromStream are active passing
regressions. DCL and gzip also pass on Linux. RESULTS.md records the root causes,
fixes, malformed-input and stream-ownership checks, and the corrected Linux
locale-filename decoding. ZIP filename regressions cover legacy and UTF-8 header
names plus Unicode Path checksums. The Windows-1252 fallback on UTF-8 hosts does
not identify arbitrary untagged legacy codepages. Gzip TestItemAt validates every
member; CRC/ISIZE checks
during ordinary extraction still follow the existing STRICTGZIP setting.

The gzip reference dataland.txt was restored to its original LF bytes after
verifying that its only difference from GNU gzip's decoded payload was CRLF
expansion. The test still compares exact bytes.

## Migration notes

Each converted supplied unit retains its original license and author notices.
The former Check/CheckEquals assertions now use nxtest contexts and a fixture
helper for Int64 comparisons. Expected exceptions are asserted explicitly in the
case body. Registration is explicit, including inherited and parameterized tests.

The shared fixture helper now restores the working directory, cleans only its own
temporary tree, releases the component it creates for streaming comparisons, and
uses the correct matched directory-entry index. Gzip subfield diagnostic strings
now display both bytes instead of attempting to cast a two-byte array to Char.
The original CP1252 filename literals in two supplied test units now use explicit
Unicode constants, preserving the intended characters in the native filename encoding.
The add-then-extract test uses the supplied MPL archive and requires a nonempty
file list instead of relying on ZIP files being present in the Windows directory.

Original test sources and superseded probes are preserved under `reference` and
excluded from the active build. Automatic approval review rejected deleting them;
they were moved here intact for review. Only the nxtest suite is built or run by
the current test project. The old Forge recipe now compiles runtime units without
its superseded linkage test executable.

A loadable nxtest module was also attempted, but was not retained as a broken
build path. The Windows compiler reports internal error 200506041 compiling
fcl-json/src/fpjson.pp at the vtCurrency CreateJSON call (line 2976). The Linux
module link rejects the selected RTL's si_dll.o with R_X86_64_32S: that RTL object
was not built as position-independent code. These are recorded separately from
the test results; this migration does not change the compiler or RTL.

Package attribution remains in the Nexus root [ATTRIBUTIONS.md](../../../../../ATTRIBUTIONS.md).
