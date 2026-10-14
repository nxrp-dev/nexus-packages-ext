# Abbrevia nxtest results - 2026-10-14

## Runtime package run

The Win64 suite now builds against `Abbrevia.nxpl` and `nxrtl.nxpl`, using the
new `Abbrevia.nxpk` declaration containing all 51 runtime units. The executable's
native import table confirms both package dependencies. It no longer compiles
Abbrevia source units into the executable.

**232 passed; 0 failed; 0 errors; 0 skipped.** This retains all 231 existing cases
and adds `Abbrevia.NativeCodecs.SharedRTLReferences`, covering inline Trim and
encoding factories plus checked Int64 overflow and shared exception identity.
The existing LZMA worker/stream cases pass through the package boundary unchanged.

The compiler/RTL package fixes and validation are recorded in NexusFPC's
`nexusfpc-package-storage.md`. The normal nxbuild executable and matching package
SDK were updated; its two self-hosted compiler generations are byte-identical.
No commits were made. Linux and Win32 were not rerun for this package conversion;
the earlier platform results below remain historical executable-suite evidence.

## Previous executable-suite verification

The original migration registered 214 cases. At that checkpoint the complete suite contained
231 cases across 33 logical suites: the retained supplied cases, 20 native-codec
cases, three Cabinet API cases, six focused decompression cases, two ZIP filename
cases, and twelve LZMA stream regressions. Both formerly skipped Linux LZMA stream
cases now pass.
Nothing was committed.

| Platform / run | Passed | Failed assertions | Errors | Skipped | Total |
|---|---:|---:|---:|---:|---:|
| x86-64 Windows, complete suite | 231 | 0 | 0 | 0 | 231 |
| i386 Windows, focused Cabinet/DCL/gzip/filename suite | 11 | 0 | 0 | 0 | 11 |
| i386 Windows, focused native LZMA stream suite | 12 | 0 | 0 | 0 | 12 |
| x86-64 Ubuntu/glibc under WSL, complete suite | 209 | 0 | 0 | 22 | 231 |

Both complete suites were rebuilt through AbbreviaTests.nxproject. The final Linux
run used a native-filesystem fixture copy under /var/tmp; that owned copy was
removed after the run. Both complete executable suites passed without assertion
failures or errors. The separate module-packaging blockers below remain outside
this correction.

## Portable LZMA streams

The two Linux skips came from a Windows guard around the entire LZMAStream unit.
The decoder itself was already synchronous and portable. Its existing algorithm
is now enabled on Linux.

Compression retains incremental Write and its existing worker. LzmaEnc_Encode
pulls input until EOF and can block awaiting later writes; that operation cannot
run on the producer while allowing the producer to supply those writes. The
stream owns no other available worker. Windows API synchronization was replaced
with the common RTL critical-section/event primitives, used directly without a
SyncObjs dependency. The SDK's existing internal threading settings remain.

The unbounded linked input queue and intermediate copying machinery were replaced
with one 1 MiB ring buffer. Producer writes wait for space, callback reads wait
for data, and a latched failure wakes both sides. The bound covers queued input;
it does not limit the encoder dictionary/workspace or caller-owned output.

The first failure is retained. Native callbacks catch Pascal exceptions and
return SDK errors. Completion closes input, joins the worker, and patches the
uncompressed-size header before reporting success. Short output writes,
exceptions, and header failures are observable through the existing completion
result and ErrorCode. Writes raise detected encoder failures. A borrowed output
stream remains exclusively available to the worker until completion joins it;
multiple simultaneous producers and thread-affine destinations are not supported.

Destruction joins and frees resources without raising compression errors. Callers
must check WaitForCompressionToFinish (for example, with LzmaCheck) before
accepting output. Win32 validation demonstrated that ExceptObject does not report
the caller's pending exception inside its unwinding finally block, so attempting
to conditionally raise from destruction could mask that exception. Keeping
cleanup non-throwing preserves the original exception on all three tested
targets, with no compiler/RTL changes.

Twelve shared nxtest cases cover finalization before destruction, repeated
completion, rejection of writes after closure, ring-buffer wrap, a single write
larger than the queue, empty input, short writes, output exceptions, header
failure, waking a blocked writer on failure, partial constructor cleanup, caller
exception preservation, and truncated compressed input. Inputs are generated in
memory; all twelve pass on Win64, Linux, and Win32.

The Win32 runner uses the same Nexus ppcross386 and matching RTL documented for
AbbreviaCoreTests in README.md, with -Ratt and the same Pascal unit/include paths.
Its entry point is test/AbbreviaLZMAStreamTests.lpr. Seven LZMA SDK objects
(CpuArch, LzFind, LzFindMt, LzFindOpt, LzmaDec, LzmaEnc, Threads) were compiled by
Clang 23 for i686-pc-windows-msvc with -O2 -fno-stack-protector and the installed
MSVC 14.29.30133 / Windows SDK 10.0.19041.0 headers. Clang's own include directory
precedes the MSVC and SDK headers. Objects are under
output/nxbuild-abbrevia/i386-win32/native/Win32; FPC receives the native parent
through -Fo and C:/Program Files/LLVM/bin through -FD.

The linker receives kernel32.lib, ucrt.lib, vcruntime.lib, and msvcrt.lib through
individual -k options. Process-local LIB supplies the SDK um/x86 and ucrt/x86
and MSVC lib/x86 paths; this avoids the available cross compiler's malformed
quoting of space-containing -Fl paths. No compiler or build-tool fix was made.
The native executable, build log, and results are under
output/nxbuild-abbrevia/i386-win32/lzma-stream-tests. All twelve cases were
executed on Windows; this is runtime verification, not only a cross-build.

## Restored supplied tests: causes and corrections

| Case | Cause | Correction and verification |
|---|---|---|
| Abbrevia.ZipDecompression.DCLImpl | ZIP method 10 had no decoder or dispatch. Ordinary Implode (method 6) is a different format. | Added Abbrevia.DCL, a Pascal adaptation of Mark Adler's blast decoder, and dispatched method 10 through the existing bounded-input, CRC-checking ZIP extraction path. All 11 supplied Canterbury entries compare exactly on Windows and Linux. |
| Abbrevia.UnZipperTests.TestGZipDecompress | Only the first member was decoded. The fixture starts with an empty member. | ExtractItemData now loops over headers, deflate streams, and trailers, summing actual decoded sizes. The supplied six-member fixture extracts all 132,506 bytes on both platforms. |
| Abbrevia.CabinetArchiveTests.TestAddFromStream | The base class queued aaStreamAdd, but Cabinet.SaveArchive never submitted it to FCI. | SaveArchive now submits the input. FCI uses stream-backed handles for both files and borrowed input views. The caller keeps ownership of its stream. The supplied case passes on Win64; focused file/stream cases pass on Win32 and Win64. |

DCL's focused cases cover the upstream overlapping-match reference vector,
all 256 coded literals with dictionary headers 4/5/6, truncated input, invalid
headers/distances, and incorrect declared output sizes. The coded-literal vector
was independently decoded with upstream blast before being embedded in the test.
The decoder adds no native dependency or shared mutable decoder state. Original
copyright, complete Zlib license, and the altered-source notice remain in the
unit; provenance is in the Nexus root ATTRIBUTIONS.md.

Gzip's focused cases cover empty first/middle/last members, output appended after
existing bytes, test-only byte counts, invalid later headers, truncated later
headers/trailers, and corrupt middle-member CRC/ISIZE values. TestItemAt validates
each member; ordinary extraction retains the existing STRICTGZIP policy for CRC
and ISIZE checking. ExtractItemData now consumes all member trailers itself.
ReadTail is still used independently when reading archive metadata.

The existing fast gzip listing still reads size/CRC hints from the final trailer;
it does not inflate the entire file merely to list it. Extraction and testing
update the item's uncompressed size with the actual combined member size. Gzip
CRCs belong to individual members, not to one combined trailer.

CAB's focused checks include a cabinet mixing disk and stream inputs, reused
input streams starting at nonzero positions, a 65,537-byte binary input, and an
empty entry. Inputs are freed by the caller before cabinet finalization, then all
entries are reopened and compared byte-for-byte. No temporary input file or
thread was added.

The expanded Win32 build exposed an existing assembler-dialect assumption in
Abbrevia's i386 deflate blocks. AbDefine.inc now explicitly selects Intel syntax
for CPU386. The algorithms and Win64/Pascal branches are unchanged; no compiler
or RTL changes were made.

The gzip reference dataland.txt had 762 extra CR bytes from checkout newline
conversion. Restoring only CRLF to LF matched GNU gzip's independently extracted
132,506-byte output exactly, SHA-256
`16fc957f46367e81448257345454d0c2c12f2e00f3a0d635c5df46fd26ddc66c`.
The six member sizes are 0, 2,082, 21,696, 44,420, 45,022 and 19,286 bytes.
Existing testfiles/** -text attributes now protect those restored bytes.

## Corrected Windows Cabinet binding

All eight original CAB access violations stopped at the same instruction in
FDI_EnumerateFiles, assigning FSetID (Abbrevia.Cabinet.pas:417). AbDefine.inc sets
four-byte record packing with {$A+}. The Win64 SDK notification uses eight-byte
alignment, so Abbrevia read its archive pointer at byte 28 instead of byte 32.
The debugger confirmed the resulting corrupt pointer in every failing case.

Abbrevia.CabinetAPI now scopes {$PACKRECORDS C} and {$PACKENUM 4} around its API
types with {$PUSH}/{$POP}. This also matches the SDK's four-byte packing on Win32;
no global packing setting was changed. All eight cases now pass: TestExtract,
TestExtractToStream, TestAdd, TestIncompleteSpan, TestNoSpan, ANSIEncodings,
DecompressCanterbury, and CompressCanterbury.

The shared Abbrevia.CabinetAPI nxtest suite checks enum/record sizes and key
notification field offsets, then creates a CAB and verifies extraction to both
a memory stream and a disk file, including zero and high-bit bytes. It runs in
the full suite and through the focused AbbreviaCoreTests.lpr entry point.

| SDK layout | Win32 | Win64 |
|---|---:|---:|
| FDINOTIFICATION size | 40 | 64 |
| psz1 offset | 4 | 8 |
| pv offset | 16 | 32 |
| hf offset | 20 | 40 |
| fdie offset | 36 | 60 |
| FDIERROR / FCIERROR / FDINOTIFICATIONTYPE size | 4 | 4 |

The expected layouts were independently verified with Clang static assertions
against installed Windows SDK 10.0.19041.0 fdi.h/fci.h for both i686-pc-windows-msvc
and x86_64-pc-windows-msvc. The focused Win32 executable was built using Nexus
ppcross386 and its matching RTL under output/ForgeComposition. Its RTTI dependency
requires the existing compiler's -Ratt setting. The binary is COFF-i386; all eleven
focused cases passed when executed on Windows.
No compiler or RTL source was changed.

## Corrected Linux ZIP filenames

The supplied localetests.zip stores three Windows NT filenames with CP1252 bytes
E3 EB ED F5 FA (U+00E3/U+00EB/U+00ED/U+00F5/U+00FA), no UTF-8 flag, and no Unicode
extra field. Both ZIP header readers decoded those legacy bytes using the host's
ANSI encoding, which is UTF-8 on this Linux installation. The filenames were
therefore damaged before extraction, causing UnZipperTests.TestLocale4 to fail.

Both local and central headers now use the same filename decoder. Explicit or
detected UTF-8 remains UTF-8. For legacy bytes, an existing non-UTF-8 system
codepage is retained; a UTF-8 host uses Windows-1252. The supplied test now checks
all three decoded archive names before retaining its existing extraction checks.
All eight locale cases pass on Windows and Linux.

The focused tests also exposed two related filename problems. Info-ZIP Unicode
Path checksums now use the original stored filename bytes, as required by
[PKWARE APPNOTE section 4.6.9](https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT),
instead of bytes reconstructed from decoded text. On Windows, the OEM heuristic
no longer overrides a Windows NT archive's ANSI filename; the DOS path remains.

The two new nxtest cases cover ASCII, CP1252 accented/Euro characters, flagged
and unflagged UTF-8 in local and central headers and public item names, plus
accepted and rejected Unicode Path checksums. They pass in both complete suites
and the focused Win32 executable. No fixture bytes, public API, compiler, or RTL
were changed for this fix.

Untagged legacy ZIP filenames do not identify a unique encoding. Windows-1252 is
the fallback on UTF-8 hosts; this does not detect every legacy codepage. Archives
using other legacy codepages without Unicode metadata can still be ambiguous.

## Passing coverage and skips

All 20 native-codec cases pass on both platforms, preserving the earlier 52
compression/decompression byte comparisons and round trips plus ABI/library checks.
The wider supplied tests exercise 17 Canterbury ZIP variants (all pass), archive
compression, TAR/GZip/Bzip2, component streaming, spanning, and the generated
90,000-entry ZIP64 case. Read the per-case output for the complete status list.

The six unavailable-fixture cases were removed at the owner's request on
2026-10-14: UnicodeZIP, UnicodeTAR, WavPackZIP, Zip64LoadLargeListing,
Zip64LoadLargeSize, and Zip64ExtractLargeSize. Their skip-only callbacks and empty
suite were deleted, along with the three unused ZIP64 fixture methods and path
helper. Original supplied sources and fixture material remain preserved.

Windows has no skips. Linux skips only the 22 Windows Cabinet cases. Both supplied
LZMA stream cases and all twelve stream regressions now pass on both hosts;
portable LZMA functions and ZIP LZMA extraction remain active.

## Test-port corrections made

- Restored five Canterbury files from Store.zip after proving that CRLF expansion
  was their only difference. Assertions still compare exact bytes. Git attributes
  now preserve fixture bytes, and ignored archive/executable inputs are included.
- Preserved the CP1252 source characters of the supplied locale tests using
  explicit Unicode constants and initialized Linux's existing wide-string manager.
- Corrected the add-then-extract case to use the supplied MPL ZIP, require that a
  file was added, and compare extracted bytes against that input.
- Replaced DUnit assertions, exception expectations, and registration with nxtest.
  Inherited and parameterized cases remain individually visible.
- Corrected a directory-comparison index, released the streamed component created
  by the test helper, confined cleanup to owned temporary directories, and fixed
  the supplied two-byte gzip subfield diagnostic so it compiles under FPC.
- Converted disabled no-op checks into explicit skips initially. The DCL, gzip and
  CAB stream-add cases are now restored and pass after the runtime corrections.

## Separate module-packaging blockers

Building a loadable nxtest module exposed two independent infrastructure issues:

1. The selected Win64 compiler fails with internal error 200506041 at
   `packages/fcl-json/src/fpjson.pp:2976`, the vtCurrency CreateJSON call.
2. The selected Linux RTL's si_dll.o cannot be linked into a shared object because
   of a non-PIC R_X86_64_32S relocation against its sysinit entry data.

The completed suite uses the existing executable nxtest registry pattern used by
SQLite and nxbuild tests. A broken alternate module build was not retained. Fixing
these compiler/RTL packaging blockers is outside this conversion.

See [README.md](README.md) for build/run/filter commands and fixture requirements.
Raw final run output is copied beside each generated executable as
AbbreviaTests.results.txt; this document preserves the findings if output is deleted.
Original sources were verified against git HEAD and are retained under reference.
