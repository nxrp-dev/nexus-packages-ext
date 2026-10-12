Retained Abbrevia regression cases
=================================

The Delphi IDE/GUI runner, visual-control tests, and WinZip/SysTools runner
were retired on 2026-10-12. The remaining Pascal test cases and helper code
are retained as references for migration to nxtest. They are not a runnable
Nexus test suite and have not been counted as passing in current validation.
The archive fixtures under testfiles remain unchanged.

Coverage includes archive lists and ownership, browser/component properties,
ZIP creation/extraction, Deflate streams, Bzip2, LZMA, TAR/GZip, CAB, archive
splitting, self-extractor construction, virtual-memory streams, filenames,
Unicode, metadata, and failure handling. Preserve the assertions when porting.
GUI rendering/property tests refer to removed controls and need no migration.
The removed floppy/WinZip integration cases covered spanned-archive media
changes and external-tool interoperability; any replacement belongs in nxtest.

Historical fixture notes (not current test instructions):

- The WavPack data is too large to include in the repository, and is available 
as a separate download from the SourceForge project.  After downloading, 
extract the outer zip into "testfiles/WavPack".  This is relatively slow test, 
and is generally only needed if you're changing the WavPack support or adding 
new compilers/platforms.

- The Zip64 data is also available as a separate download from SourceForge.
Download any files in the "Test Files/Zip64" folder and copy them into the
"testfiles/Zip64" directory without extracting them.

- To test Unicode filename support, open "testfiles/Unicode" and extract one of 
the "OEM & ANSI" zips using WinZip or PowerArchiver into the "source" 
subdirectory.  The readme there includes original filenames for verification.

Historical reported failures (not reverified):

TAbUnZipperTests/TestGZipDecompress
    This is a failure in the deflate engine (bug 822243).


Historical limitations (not reverified):

Keep these cases and their expected behavior explicit when migrating to nxtest.

TAbZipArchiveTests/Decompress Canterbury/DCLImpl
    The "DCL Implode" compression algorithm is an optional algorithm available
    in PKZip.  Abbrevia doesn't currently support it.

TAbZipArchiveTests/Decompress Unicode/OSX
    OS X stores accented Unicode characters differently than Windows.  For 
    proper handling the filenames should converted when storing and extracting.

TAbCabinetArchiveTests/TestAddFromStream
    TAbCabinetArchive.AddFromStream is not supported.  Cabs are solid archives, so
    adding a single stream will require decompressing the cab and recreating it.
