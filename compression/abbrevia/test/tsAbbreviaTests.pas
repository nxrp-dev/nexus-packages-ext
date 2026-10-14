// Tests adapted from the supplied Abbrevia cases; original notices remain in each unit.
unit tsAbbreviaTests;

{$mode delphi}{$H+}

interface
uses obNXTestRegistry, obNXTestContext;
procedure RegisterAbbreviaTests(ARegistry: TNXTestRegistry);

implementation
uses
  obNXTestSuite, obAbTestFixture, Abbrevia.Utilities, Abbrevia.Zip,
  tsAbArchiveSplitTests,
  tsAbArcTypTests,
  tsAbBrowseTests,
  tsAbBzip2Tests,
  tsAbBzip2TypTests,
  {$IFDEF MSWINDOWS}tsAbCabExtTests,{$ENDIF}
  {$IFDEF MSWINDOWS}tsAbCabKitTests,{$ENDIF}
  {$IFDEF MSWINDOWS}tsAbCabMakTests,{$ENDIF}
  {$IFDEF MSWINDOWS}tsAbCabTypTests,{$ENDIF}
  {$IFDEF MSWINDOWS}tsAbCBrowsTests,{$ENDIF}
  tsAbGzTypTests,
  tsAbLZMATests, tsAbLZMAStreamTests,
  tsAbSelfExTests,
  tsAbTarTypTests,
  tsAbUnzperTests,
  tsAbUnzPrcTests,
  tsAbVMStrmTests,
  tsAbZBrowsTests,
  tsAbZipKitTests,
  tsAbZipperTests,
  tsAbZipPrcTests,
  tsAbZipTypTests,
  tsAbCodecTests, tsAbCabinetAPITests, tsAbDecompressionTests, tsAbZipFileNameTests;

procedure TestSelfExTestsTestDefaultStreaming(AContext: TNXTestContext);
var
  lFixture: TAbSelfExTests;
begin
  lFixture := TAbSelfExTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDefaultStreaming);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipKitTestsTestDefaultStreaming(AContext: TNXTestContext);
var
  lFixture: TAbZipKitTests;
begin
  lFixture := TAbZipKitTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDefaultStreaming);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipKitTestsTestComponentLinks(AContext: TNXTestContext);
var
  lFixture: TAbZipKitTests;
begin
  lFixture := TAbZipKitTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestComponentLinks);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipKitTestsTestAddThenExtract(AContext: TNXTestContext);
var
  lFixture: TAbZipKitTests;
begin
  lFixture := TAbZipKitTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAddThenExtract);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipKitTestsTestTaggedFiles(AContext: TNXTestContext);
var
  lFixture: TAbZipKitTests;
begin
  lFixture := TAbZipKitTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestTaggedFiles);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipKitTestsFreshenTest(AContext: TNXTestContext);
var
  lFixture: TAbZipKitTests;
begin
  lFixture := TAbZipKitTests.Create(AContext);
  try
    lFixture.Run(lFixture.FreshenTest);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipKitTestsFreshenBaseDir(AContext: TNXTestContext);
var
  lFixture: TAbZipKitTests;
begin
  lFixture := TAbZipKitTests.Create(AContext);
  try
    lFixture.Run(lFixture.FreshenBaseDir);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipKitTestsTestComment(AContext: TNXTestContext);
var
  lFixture: TAbZipKitTests;
begin
  lFixture := TAbZipKitTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestComment);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipKitTestsTestRenameCollision(AContext: TNXTestContext);
var
  lFixture: TAbZipKitTests;
begin
  lFixture := TAbZipKitTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestRenameCollision);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzip2TestsTestDecompressionStream(AContext: TNXTestContext);
var
  lFixture: TAbBzip2Tests;
begin
  lFixture := TAbBzip2Tests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDecompressionStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzip2TestsTestCompressionStream(AContext: TNXTestContext);
var
  lFixture: TAbBzip2Tests;
begin
  lFixture := TAbBzip2Tests.Create(AContext);
  try
    lFixture.Run(lFixture.TestCompressionStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsTestDefaultStreaming(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDefaultStreaming);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsTestComponentLinks(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestComponentLinks);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsBasicZipFile(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.BasicZipFile);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsCreateAndTestBasicZipFile(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.CreateAndTestBasicZipFile);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsCreateAndTestBasicZipFile2(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.CreateAndTestBasicZipFile2);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsCreateAndTestBasicZipFile3(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.CreateAndTestBasicZipFile3);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsCreateAndTestBasicZipFile4(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.CreateAndTestBasicZipFile4);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsBasicGZipTarFile(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.BasicGZipTarFile);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsBasicGZipTarFile2(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.BasicGZipTarFile2);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsTestBasicForceTypeZip(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBasicForceTypeZip);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsTestBasicForceTypeGZipTar(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBasicForceTypeGZipTar);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsCreatePasswordProtectedAddedByStream(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.CreatePasswordProtectedAddedByStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsGZipInputStreamClearTest(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.GZipInputStreamClearTest);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsCreateSimplePWZip(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.CreateSimplePWZip);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsCreateMultiple(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.CreateMultiple);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsTestLocale1(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestLocale1);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsTestLocale2(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestLocale2);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsTestLocale3(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestLocale3);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipperTestsTestLocale4(AContext: TNXTestContext);
var
  lFixture: TAbZipperTests;
begin
  lFixture := TAbZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestLocale4);
  finally
    lFixture.Free;
  end;
end;

procedure TestCabinetArchiveTestsTestExtract(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetArchiveTests;
begin
  lFixture := TAbCabinetArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtract);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetArchiveTestsTestExtractToStream(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetArchiveTests;
begin
  lFixture := TAbCabinetArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtractToStream);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetArchiveTestsTestAdd(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetArchiveTests;
begin
  lFixture := TAbCabinetArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAdd);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetArchiveTestsTestAddFromStream(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetArchiveTests;
begin
  lFixture := TAbCabinetArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAddFromStream);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetArchiveTestsTestVerify(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetArchiveTests;
begin
  lFixture := TAbCabinetArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestVerify);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetArchiveTestsTestBug3201728(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetArchiveTests;
begin
  lFixture := TAbCabinetArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBug3201728);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetArchiveTestsTestIncompleteSpan(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetArchiveTests;
begin
  lFixture := TAbCabinetArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestIncompleteSpan);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetArchiveTestsTestNoSpan(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetArchiveTests;
begin
  lFixture := TAbCabinetArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestNoSpan);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetExtractorTestsTestDefaultStreaming(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetExtractorTests;
begin
  lFixture := TAbCabinetExtractorTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDefaultStreaming);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetExtractorTestsTestComponentLinks(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetExtractorTests;
begin
  lFixture := TAbCabinetExtractorTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestComponentLinks);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestZipBrowserTestsTestDefaultStreaming(AContext: TNXTestContext);
var
  lFixture: TAbZipBrowserTests;
begin
  lFixture := TAbZipBrowserTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDefaultStreaming);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipBrowserTestsTestComponentLinks(AContext: TNXTestContext);
var
  lFixture: TAbZipBrowserTests;
begin
  lFixture := TAbZipBrowserTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestComponentLinks);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipArchiveTestsTestExtract(AContext: TNXTestContext);
var
  lFixture: TAbZipArchiveTests;
begin
  lFixture := TAbZipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtract);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipArchiveTestsTestExtractToStream(AContext: TNXTestContext);
var
  lFixture: TAbZipArchiveTests;
begin
  lFixture := TAbZipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtractToStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipArchiveTestsTestAdd(AContext: TNXTestContext);
var
  lFixture: TAbZipArchiveTests;
begin
  lFixture := TAbZipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAdd);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipArchiveTestsTestAddFromStream(AContext: TNXTestContext);
var
  lFixture: TAbZipArchiveTests;
begin
  lFixture := TAbZipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAddFromStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipArchiveTestsTestVerify(AContext: TNXTestContext);
var
  lFixture: TAbZipArchiveTests;
begin
  lFixture := TAbZipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestVerify);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipArchiveTestsTestBug3201728(AContext: TNXTestContext);
var
  lFixture: TAbZipArchiveTests;
begin
  lFixture := TAbZipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBug3201728);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipArchiveTestsTestTestItemAt(AContext: TNXTestContext);
var
  lFixture: TAbZipArchiveTests;
begin
  lFixture := TAbZipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestTestItemAt);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipArchiveTestsTestTestItemAtCorrupt(AContext: TNXTestContext);
var
  lFixture: TAbZipArchiveTests;
begin
  lFixture := TAbZipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestTestItemAtCorrupt);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveSplitTestsDecompressSplitArchive(AContext: TNXTestContext);
var
  lFixture: TAbArchiveSplitTests;
begin
  lFixture := TAbArchiveSplitTests.Create(AContext);
  try
    lFixture.Run(lFixture.DecompressSplitArchive);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveSplitTestsCreateSplitArchive(AContext: TNXTestContext);
var
  lFixture: TAbArchiveSplitTests;
begin
  lFixture := TAbArchiveSplitTests.Create(AContext);
  try
    lFixture.Run(lFixture.CreateSplitArchive);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveSplitTestsAbortOnImageRequest(AContext: TNXTestContext);
var
  lFixture: TAbArchiveSplitTests;
begin
  lFixture := TAbArchiveSplitTests.Create(AContext);
  try
    lFixture.Run(lFixture.AbortOnImageRequest);
  finally
    lFixture.Free;
  end;
end;

procedure TestVMStrmTestsTestReadWrite(AContext: TNXTestContext);
var
  lFixture: TAbVMStrmTests;
begin
  lFixture := TAbVMStrmTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestReadWrite);
  finally
    lFixture.Free;
  end;
end;

procedure TestVMStrmTestsTestEmptyStream(AContext: TNXTestContext);
var
  lFixture: TAbVMStrmTests;
begin
  lFixture := TAbVMStrmTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestEmptyStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestDefaultStreaming(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDefaultStreaming);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestComponentLinks(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestComponentLinks);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestBasicUnzip(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBasicUnzip);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestBasicUnGzip(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBasicUnGzip);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestBasicUnGzipTar(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBasicUnGzipTar);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestUserAbort(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestUserAbort);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestGZipDecompress(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestGZipDecompress);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestZeroByteZipFile(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestZeroByteZipFile);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestIncompleteZipFile(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestIncompleteZipFile);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestArchiveNotFound(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestArchiveNotFound);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestZipCopiedFromFloppy(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestZipCopiedFromFloppy);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsDecompressSimplePW(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.DecompressSimplePW);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsDecompressPasswordTries(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.DecompressPasswordTries);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsCheckBadPWOverwrite(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.CheckBadPWOverwrite);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestLocale1(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestLocale1);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestLocale2(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestLocale2);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestLocale3(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestLocale3);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestLocale4(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestLocale4);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnZipperTestsTestFindCentralDirTail(AContext: TNXTestContext);
var
  lFixture: TAbUnZipperTests;
begin
  lFixture := TAbUnZipperTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestFindCentralDirTail);
  finally
    lFixture.Free;
  end;
end;

procedure TestCabinetBuilderTestsTestDefaultStreaming(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetBuilderTests;
begin
  lFixture := TAbCabinetBuilderTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDefaultStreaming);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetBuilderTestsTestComponentLinks(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetBuilderTests;
begin
  lFixture := TAbCabinetBuilderTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestComponentLinks);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestLZMATestsTestDecodeStream(AContext: TNXTestContext);
var
  lFixture: TAbLZMATests;
begin
  lFixture := TAbLZMATests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDecodeStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestLZMATestsTestEncodeStream(AContext: TNXTestContext);
var
  lFixture: TAbLZMATests;
begin
  lFixture := TAbLZMATests.Create(AContext);
  try
    lFixture.Run(lFixture.TestEncodeStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestLZMATestsTestDecompressionStream(AContext: TNXTestContext);
var
  lFixture: TAbLZMATests;
begin
  lFixture := TAbLZMATests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDecompressionStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestLZMATestsTestCompressionStream(AContext: TNXTestContext);
var
  lFixture: TAbLZMATests;
begin
  lFixture := TAbLZMATests.Create(AContext);
  try
    lFixture.Run(lFixture.TestCompressionStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestCabinetBrowserTestsTestDefaultStreaming(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetBrowserTests;
begin
  lFixture := TAbCabinetBrowserTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDefaultStreaming);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetBrowserTestsTestComponentLinks(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetBrowserTests;
begin
  lFixture := TAbCabinetBrowserTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestComponentLinks);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestZipPrcTestsDeflateStreamSimpleTest1(AContext: TNXTestContext);
var
  lFixture: TAbZipPrcTests;
begin
  lFixture := TAbZipPrcTests.Create(AContext);
  try
    lFixture.Run(lFixture.DeflateStreamSimpleTest1);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipPrcTestsDeflateStreamSimpleTest2(AContext: TNXTestContext);
var
  lFixture: TAbZipPrcTests;
begin
  lFixture := TAbZipPrcTests.Create(AContext);
  try
    lFixture.Run(lFixture.DeflateStreamSimpleTest2);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipPrcTestsDeflateStreamFileTest(AContext: TNXTestContext);
var
  lFixture: TAbZipPrcTests;
begin
  lFixture := TAbZipPrcTests.Create(AContext);
  try
    lFixture.Run(lFixture.DeflateStreamFileTest);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipPrcTestsDeflateStreamInflateStreamTest(AContext: TNXTestContext);
var
  lFixture: TAbZipPrcTests;
begin
  lFixture := TAbZipPrcTests.Create(AContext);
  try
    lFixture.Run(lFixture.DeflateStreamInflateStreamTest);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveListTestsTestEnumerator(AContext: TNXTestContext);
var
  lFixture: TAbArchiveListTests;
begin
  lFixture := TAbArchiveListTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestEnumerator);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveListTestsTestGenerateHash(AContext: TNXTestContext);
var
  lFixture: TAbArchiveListTests;
begin
  lFixture := TAbArchiveListTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestGenerateHash);
  finally
    lFixture.Free;
  end;
end;

procedure TestCabinetKitTestsTestDefaultStreaming(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetKitTests;
begin
  lFixture := TAbCabinetKitTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDefaultStreaming);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetKitTestsTestComponentLinks(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbCabinetKitTests;
begin
  lFixture := TAbCabinetKitTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestComponentLinks);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestTarArchiveTestsTestExtract(AContext: TNXTestContext);
var
  lFixture: TAbTarArchiveTests;
begin
  lFixture := TAbTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtract);
  finally
    lFixture.Free;
  end;
end;

procedure TestTarArchiveTestsTestExtractToStream(AContext: TNXTestContext);
var
  lFixture: TAbTarArchiveTests;
begin
  lFixture := TAbTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtractToStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestTarArchiveTestsTestAdd(AContext: TNXTestContext);
var
  lFixture: TAbTarArchiveTests;
begin
  lFixture := TAbTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAdd);
  finally
    lFixture.Free;
  end;
end;

procedure TestTarArchiveTestsTestAddFromStream(AContext: TNXTestContext);
var
  lFixture: TAbTarArchiveTests;
begin
  lFixture := TAbTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAddFromStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestTarArchiveTestsTestVerify(AContext: TNXTestContext);
var
  lFixture: TAbTarArchiveTests;
begin
  lFixture := TAbTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestVerify);
  finally
    lFixture.Free;
  end;
end;

procedure TestTarArchiveTestsTestBug3201728(AContext: TNXTestContext);
var
  lFixture: TAbTarArchiveTests;
begin
  lFixture := TAbTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBug3201728);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnzPrcTestsInflateStreamSimpleTest1(AContext: TNXTestContext);
var
  lFixture: TAbUnzPrcTests;
begin
  lFixture := TAbUnzPrcTests.Create(AContext);
  try
    lFixture.Run(lFixture.InflateStreamSimpleTest1);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnzPrcTestsInflateStreamSimpleTest2(AContext: TNXTestContext);
var
  lFixture: TAbUnzPrcTests;
begin
  lFixture := TAbUnzPrcTests.Create(AContext);
  try
    lFixture.Run(lFixture.InflateStreamSimpleTest2);
  finally
    lFixture.Free;
  end;
end;

procedure TestUnzPrcTestsInflateStreamFileTest(AContext: TNXTestContext);
var
  lFixture: TAbUnzPrcTests;
begin
  lFixture := TAbUnzPrcTests.Create(AContext);
  try
    lFixture.Run(lFixture.InflateStreamFileTest);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzip2ArchiveTestsTestExtract(AContext: TNXTestContext);
var
  lFixture: TAbBzip2ArchiveTests;
begin
  lFixture := TAbBzip2ArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtract);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzip2ArchiveTestsTestExtractToStream(AContext: TNXTestContext);
var
  lFixture: TAbBzip2ArchiveTests;
begin
  lFixture := TAbBzip2ArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtractToStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzip2ArchiveTestsTestAdd(AContext: TNXTestContext);
var
  lFixture: TAbBzip2ArchiveTests;
begin
  lFixture := TAbBzip2ArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAdd);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzip2ArchiveTestsTestAddFromStream(AContext: TNXTestContext);
var
  lFixture: TAbBzip2ArchiveTests;
begin
  lFixture := TAbBzip2ArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAddFromStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzip2ArchiveTestsTestVerify(AContext: TNXTestContext);
var
  lFixture: TAbBzip2ArchiveTests;
begin
  lFixture := TAbBzip2ArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestVerify);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzip2ArchiveTestsTestBug3201728(AContext: TNXTestContext);
var
  lFixture: TAbBzip2ArchiveTests;
begin
  lFixture := TAbBzip2ArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBug3201728);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzippedTarArchiveTestsTestExtract(AContext: TNXTestContext);
var
  lFixture: TAbBzippedTarArchiveTests;
begin
  lFixture := TAbBzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtract);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzippedTarArchiveTestsTestExtractToStream(AContext: TNXTestContext);
var
  lFixture: TAbBzippedTarArchiveTests;
begin
  lFixture := TAbBzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtractToStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzippedTarArchiveTestsTestAdd(AContext: TNXTestContext);
var
  lFixture: TAbBzippedTarArchiveTests;
begin
  lFixture := TAbBzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAdd);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzippedTarArchiveTestsTestAddFromStream(AContext: TNXTestContext);
var
  lFixture: TAbBzippedTarArchiveTests;
begin
  lFixture := TAbBzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAddFromStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzippedTarArchiveTestsTestVerify(AContext: TNXTestContext);
var
  lFixture: TAbBzippedTarArchiveTests;
begin
  lFixture := TAbBzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestVerify);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzippedTarArchiveTestsTestBug3201728(AContext: TNXTestContext);
var
  lFixture: TAbBzippedTarArchiveTests;
begin
  lFixture := TAbBzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBug3201728);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipExtraFieldTestsTextEmptyField(AContext: TNXTestContext);
var
  lFixture: TAbGzipExtraFieldTests;
begin
  lFixture := TAbGzipExtraFieldTests.Create(AContext);
  try
    lFixture.Run(lFixture.TextEmptyField);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipExtraFieldTestsTestAddZeroLengthAttr(AContext: TNXTestContext);
var
  lFixture: TAbGzipExtraFieldTests;
begin
  lFixture := TAbGzipExtraFieldTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAddZeroLengthAttr);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipExtraFieldTestsTestAddAttr(AContext: TNXTestContext);
var
  lFixture: TAbGzipExtraFieldTests;
begin
  lFixture := TAbGzipExtraFieldTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAddAttr);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipExtraFieldTestsTestAddTwoAttr(AContext: TNXTestContext);
var
  lFixture: TAbGzipExtraFieldTests;
begin
  lFixture := TAbGzipExtraFieldTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAddTwoAttr);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipExtraFieldTestsTestDeleteFirstSubfield(AContext: TNXTestContext);
var
  lFixture: TAbGzipExtraFieldTests;
begin
  lFixture := TAbGzipExtraFieldTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDeleteFirstSubfield);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipExtraFieldTestsTestDeleteLastSubfield(AContext: TNXTestContext);
var
  lFixture: TAbGzipExtraFieldTests;
begin
  lFixture := TAbGzipExtraFieldTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDeleteLastSubfield);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipExtraFieldTestsTestDeleteMiddleSubfield(AContext: TNXTestContext);
var
  lFixture: TAbGzipExtraFieldTests;
begin
  lFixture := TAbGzipExtraFieldTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDeleteMiddleSubfield);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipExtraFieldTestsTestDeleteAllSubfields(AContext: TNXTestContext);
var
  lFixture: TAbGzipExtraFieldTests;
begin
  lFixture := TAbGzipExtraFieldTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestDeleteAllSubfields);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipExtraFieldTestsTestReplaceSameSize(AContext: TNXTestContext);
var
  lFixture: TAbGzipExtraFieldTests;
begin
  lFixture := TAbGzipExtraFieldTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestReplaceSameSize);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipExtraFieldTestsTestReplaceDiffSize(AContext: TNXTestContext);
var
  lFixture: TAbGzipExtraFieldTests;
begin
  lFixture := TAbGzipExtraFieldTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestReplaceDiffSize);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipArchiveTestsTestExtract(AContext: TNXTestContext);
var
  lFixture: TAbGzipArchiveTests;
begin
  lFixture := TAbGzipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtract);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipArchiveTestsTestExtractToStream(AContext: TNXTestContext);
var
  lFixture: TAbGzipArchiveTests;
begin
  lFixture := TAbGzipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtractToStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipArchiveTestsTestAdd(AContext: TNXTestContext);
var
  lFixture: TAbGzipArchiveTests;
begin
  lFixture := TAbGzipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAdd);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipArchiveTestsTestAddFromStream(AContext: TNXTestContext);
var
  lFixture: TAbGzipArchiveTests;
begin
  lFixture := TAbGzipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAddFromStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipArchiveTestsTestVerify(AContext: TNXTestContext);
var
  lFixture: TAbGzipArchiveTests;
begin
  lFixture := TAbGzipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestVerify);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipArchiveTestsTestBug3201728(AContext: TNXTestContext);
var
  lFixture: TAbGzipArchiveTests;
begin
  lFixture := TAbGzipArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBug3201728);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzippedTarArchiveTestsTestExtract(AContext: TNXTestContext);
var
  lFixture: TAbGzippedTarArchiveTests;
begin
  lFixture := TAbGzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtract);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzippedTarArchiveTestsTestExtractToStream(AContext: TNXTestContext);
var
  lFixture: TAbGzippedTarArchiveTests;
begin
  lFixture := TAbGzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestExtractToStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzippedTarArchiveTestsTestAdd(AContext: TNXTestContext);
var
  lFixture: TAbGzippedTarArchiveTests;
begin
  lFixture := TAbGzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAdd);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzippedTarArchiveTestsTestAddFromStream(AContext: TNXTestContext);
var
  lFixture: TAbGzippedTarArchiveTests;
begin
  lFixture := TAbGzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestAddFromStream);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzippedTarArchiveTestsTestVerify(AContext: TNXTestContext);
var
  lFixture: TAbGzippedTarArchiveTests;
begin
  lFixture := TAbGzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestVerify);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzippedTarArchiveTestsTestBug3201728(AContext: TNXTestContext);
var
  lFixture: TAbGzippedTarArchiveTests;
begin
  lFixture := TAbGzippedTarArchiveTests.Create(AContext);
  try
    lFixture.Run(lFixture.TestBug3201728);
  finally
    lFixture.Free;
  end;
end;

procedure TestZip64SaveLargeListing(AContext: TNXTestContext);
var
  lFixture: TAbZip64Tests;
begin
  lFixture := TAbZip64Tests.Create(AContext);
  try
    lFixture.Run(lFixture.TestSaveLargeListing);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipArchiveTestsANSIEncodings(AContext: TNXTestContext);
var
  lFixture: TAbArchiveANSIEncodingsTest;
begin
  lFixture := TAbArchiveANSIEncodingsTest.Create(AContext, TAbZipArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipArchiveTestsCompressEmptyFolders(AContext: TNXTestContext);
var
  lFixture: TAbArchiveCompressEmptyFoldersTest;
begin
  lFixture := TAbArchiveCompressEmptyFoldersTest.Create(AContext, TAbZipArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipArchiveTestsDecompressEmptyFolders(AContext: TNXTestContext);
var
  lFixture: TAbArchiveDecompressEmptyFoldersTest;
begin
  lFixture := TAbArchiveDecompressEmptyFoldersTest.Create(AContext, TAbZipArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionBzip2(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'Bzip2.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionDeflate(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'Deflate.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionDeflate64(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'Deflate64.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionDeflateP(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'DeflateP.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionImplode(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'Implode.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionImplodeP(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'ImplodeP.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionLZMA(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'LZMA.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionPPMd(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'PPMd.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionReduce1(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'Reduce1.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionReduce2(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'Reduce2.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionReduce3(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'Reduce3.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionReduce4(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'Reduce4.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionShrink(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'Shrink.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionShrinkP(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'ShrinkP.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionStore(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'Store.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionStoreP(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburyDir + 'StoreP.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipCompressionStore(AContext: TNXTestContext);
var
  lFixture: TAbZipCompressTest;
begin
  lFixture := TAbZipCompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburySourceDir, smStored, '');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipCompressionDeflate(AContext: TNXTestContext);
var
  lFixture: TAbZipCompressTest;
begin
  lFixture := TAbZipCompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburySourceDir, smDeflated, '');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipCompressionStoreP(AContext: TNXTestContext);
var
  lFixture: TAbZipCompressTest;
begin
  lFixture := TAbZipCompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburySourceDir, smStored, 'password');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipCompressionDeflateP(AContext: TNXTestContext);
var
  lFixture: TAbZipCompressTest;
begin
  lFixture := TAbZipCompressTest.Create(AContext, TAbZipArchiveTests, TAbTestCase.CanterburySourceDir, smDeflated, 'password');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestTarArchiveTestsANSIEncodings(AContext: TNXTestContext);
var
  lFixture: TAbArchiveANSIEncodingsTest;
begin
  lFixture := TAbArchiveANSIEncodingsTest.Create(AContext, TAbTarArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestTarArchiveTestsCompressEmptyFolders(AContext: TNXTestContext);
var
  lFixture: TAbArchiveCompressEmptyFoldersTest;
begin
  lFixture := TAbArchiveCompressEmptyFoldersTest.Create(AContext, TAbTarArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestTarArchiveTestsDecompressEmptyFolders(AContext: TNXTestContext);
var
  lFixture: TAbArchiveDecompressEmptyFoldersTest;
begin
  lFixture := TAbArchiveDecompressEmptyFoldersTest.Create(AContext, TAbTarArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestTarArchiveTestsDecompressCanterbury(AContext: TNXTestContext);
var
  lFixture: TAbArchiveDecompressTest;
begin
  lFixture := TAbArchiveDecompressTest.Create(AContext, TAbTarArchiveTests, TAbTestCase.CanterburyDir + 'Canterbury.tar');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestTarArchiveTestsCompressCanterbury(AContext: TNXTestContext);
var
  lFixture: TAbArchiveCompressTest;
begin
  lFixture := TAbArchiveCompressTest.Create(AContext, TAbTarArchiveTests, TAbTestCase.CanterburySourceDir);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzipArchiveTestsANSIEncodings(AContext: TNXTestContext);
var
  lFixture: TAbArchiveANSIEncodingsTest;
begin
  lFixture := TAbArchiveANSIEncodingsTest.Create(AContext, TAbGzipArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzippedTarArchiveTestsCompressEmptyFolders(AContext: TNXTestContext);
var
  lFixture: TAbArchiveCompressEmptyFoldersTest;
begin
  lFixture := TAbArchiveCompressEmptyFoldersTest.Create(AContext, TAbGzippedTarArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzippedTarArchiveTestsDecompressEmptyFolders(AContext: TNXTestContext);
var
  lFixture: TAbArchiveDecompressEmptyFoldersTest;
begin
  lFixture := TAbArchiveDecompressEmptyFoldersTest.Create(AContext, TAbGzippedTarArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzippedTarArchiveTestsDecompressCanterbury(AContext: TNXTestContext);
var
  lFixture: TAbArchiveDecompressTest;
begin
  lFixture := TAbArchiveDecompressTest.Create(AContext, TAbGzippedTarArchiveTests, TAbTestCase.CanterburyDir + 'Canterbury.tgz');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestGzippedTarArchiveTestsCompressCanterbury(AContext: TNXTestContext);
var
  lFixture: TAbArchiveCompressTest;
begin
  lFixture := TAbArchiveCompressTest.Create(AContext, TAbGzippedTarArchiveTests, TAbTestCase.CanterburySourceDir);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzippedTarArchiveTestsCompressEmptyFolders(AContext: TNXTestContext);
var
  lFixture: TAbArchiveCompressEmptyFoldersTest;
begin
  lFixture := TAbArchiveCompressEmptyFoldersTest.Create(AContext, TAbBzippedTarArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzippedTarArchiveTestsDecompressEmptyFolders(AContext: TNXTestContext);
var
  lFixture: TAbArchiveDecompressEmptyFoldersTest;
begin
  lFixture := TAbArchiveDecompressEmptyFoldersTest.Create(AContext, TAbBzippedTarArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzippedTarArchiveTestsDecompressCanterbury(AContext: TNXTestContext);
var
  lFixture: TAbArchiveDecompressTest;
begin
  lFixture := TAbArchiveDecompressTest.Create(AContext, TAbBzippedTarArchiveTests, TAbTestCase.CanterburyDir + 'Canterbury.tbz');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestBzippedTarArchiveTestsCompressCanterbury(AContext: TNXTestContext);
var
  lFixture: TAbArchiveCompressTest;
begin
  lFixture := TAbArchiveCompressTest.Create(AContext, TAbBzippedTarArchiveTests, TAbTestCase.CanterburySourceDir);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure TestCabinetArchiveTestsANSIEncodings(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbArchiveANSIEncodingsTest;
begin
  lFixture := TAbArchiveANSIEncodingsTest.Create(AContext, TAbCabinetArchiveTests);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetArchiveTestsDecompressCanterbury(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbArchiveDecompressTest;
begin
  lFixture := TAbArchiveDecompressTest.Create(AContext, TAbCabinetArchiveTests, TAbTestCase.CanterburyDir + 'Canterbury.cab');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetArchiveTestsCompressCanterbury(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lFixture: TAbArchiveCompressTest;
begin
  lFixture := TAbArchiveCompressTest.Create(AContext, TAbCabinetArchiveTests, TAbTestCase.CanterburySourceDir);
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestArchiveDetectionMPLcab(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.MPLDir + 'MPL.cab', atCab);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionMPLtbz(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.MPLDir + 'MPL.tbz', atBzippedTar);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionMPLbz2(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.MPLDir + 'MPL.bz2', atBzip2);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionMPLgz(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.MPLDir + 'MPL.gz', atGzip);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionMPL11txt(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.MPLDir + 'MPL-1_1.txt', atUnknown);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionMPLtgz(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.MPLDir + 'MPL.tgz', atGzippedTar);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionMPLzip(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.MPLDir + 'MPL.zip', atZip);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionMPLexe(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.MPLDir + 'MPL.exe', atSelfExtZip);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionMPLlnx(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.MPLDir + 'MPL.lnx', atSelfExtZip);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionMPLtar(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.MPLDir + 'MPL.tar', atTar);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionSplitz01(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.CanterburyDir + 'Split/Split.z01', atSpannedZip);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionSplitzip(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.CanterburyDir + 'Split/Split.zip', atSpannedZip);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestArchiveDetectionTest0001cab(AContext: TNXTestContext);
var
  lFixture: TAbDetermineArcTypeTest;
begin
  lFixture := TAbDetermineArcTypeTest.Create(AContext, TAbTestCase.TestFileDir + 'Test0001.cab', atCab);
  try
    lFixture.Run(lFixture.TestDetermineArcType);
  finally
    lFixture.Free;
  end;
end;

procedure TestZipDecompressionDCLImpl(AContext: TNXTestContext);
var
  lFixture: TAbZipDecompressTest;
begin
  lFixture := TAbZipDecompressTest.Create(AContext, TAbZipArchiveTests,
    TAbTestCase.CanterburyDir + 'DCLImpl.zip');
  try
    lFixture.Run(lFixture.Execute);
  finally
    lFixture.Free;
  end;
end;

procedure RegisterAbbreviaTests(ARegistry: TNXTestRegistry);
var
  lSuite: TNXTestSuite;
begin
  lSuite := ARegistry.AddSuite('Abbrevia.SelfExTests');
  lSuite.AddTest('TestDefaultStreaming', TestSelfExTestsTestDefaultStreaming);
  lSuite := ARegistry.AddSuite('Abbrevia.ZipKitTests');
  lSuite.AddTest('TestDefaultStreaming', TestZipKitTestsTestDefaultStreaming);
  lSuite.AddTest('TestComponentLinks', TestZipKitTestsTestComponentLinks);
  lSuite.AddTest('TestAddThenExtract', TestZipKitTestsTestAddThenExtract);
  lSuite.AddTest('TestTaggedFiles', TestZipKitTestsTestTaggedFiles);
  lSuite.AddTest('FreshenTest', TestZipKitTestsFreshenTest);
  lSuite.AddTest('FreshenBaseDir', TestZipKitTestsFreshenBaseDir);
  lSuite.AddTest('TestComment', TestZipKitTestsTestComment);
  lSuite.AddTest('TestRenameCollision', TestZipKitTestsTestRenameCollision);
  lSuite := ARegistry.AddSuite('Abbrevia.Bzip2Tests');
  lSuite.AddTest('TestDecompressionStream', TestBzip2TestsTestDecompressionStream);
  lSuite.AddTest('TestCompressionStream', TestBzip2TestsTestCompressionStream);
  lSuite := ARegistry.AddSuite('Abbrevia.ZipperTests');
  lSuite.AddTest('TestDefaultStreaming', TestZipperTestsTestDefaultStreaming);
  lSuite.AddTest('TestComponentLinks', TestZipperTestsTestComponentLinks);
  lSuite.AddTest('BasicZipFile', TestZipperTestsBasicZipFile);
  lSuite.AddTest('CreateAndTestBasicZipFile', TestZipperTestsCreateAndTestBasicZipFile);
  lSuite.AddTest('CreateAndTestBasicZipFile2', TestZipperTestsCreateAndTestBasicZipFile2);
  lSuite.AddTest('CreateAndTestBasicZipFile3', TestZipperTestsCreateAndTestBasicZipFile3);
  lSuite.AddTest('CreateAndTestBasicZipFile4', TestZipperTestsCreateAndTestBasicZipFile4);
  lSuite.AddTest('BasicGZipTarFile', TestZipperTestsBasicGZipTarFile);
  lSuite.AddTest('BasicGZipTarFile2', TestZipperTestsBasicGZipTarFile2);
  lSuite.AddTest('TestBasicForceTypeZip', TestZipperTestsTestBasicForceTypeZip);
  lSuite.AddTest('TestBasicForceTypeGZipTar', TestZipperTestsTestBasicForceTypeGZipTar);
  lSuite.AddTest('CreatePasswordProtectedAddedByStream', TestZipperTestsCreatePasswordProtectedAddedByStream);
  lSuite.AddTest('GZipInputStreamClearTest', TestZipperTestsGZipInputStreamClearTest);
  lSuite.AddTest('CreateSimplePWZip', TestZipperTestsCreateSimplePWZip);
  lSuite.AddTest('CreateMultiple', TestZipperTestsCreateMultiple);
  lSuite.AddTest('TestLocale1', TestZipperTestsTestLocale1);
  lSuite.AddTest('TestLocale2', TestZipperTestsTestLocale2);
  lSuite.AddTest('TestLocale3', TestZipperTestsTestLocale3);
  lSuite.AddTest('TestLocale4', TestZipperTestsTestLocale4);
  lSuite := ARegistry.AddSuite('Abbrevia.CabinetArchiveTests');
  lSuite.AddTest('TestExtract', TestCabinetArchiveTestsTestExtract);
  lSuite.AddTest('TestExtractToStream', TestCabinetArchiveTestsTestExtractToStream);
  lSuite.AddTest('TestAdd', TestCabinetArchiveTestsTestAdd);
  lSuite.AddTest('TestAddFromStream', TestCabinetArchiveTestsTestAddFromStream);
  lSuite.AddTest('TestVerify', TestCabinetArchiveTestsTestVerify);
  lSuite.AddTest('TestBug3201728', TestCabinetArchiveTestsTestBug3201728);
  lSuite.AddTest('TestIncompleteSpan', TestCabinetArchiveTestsTestIncompleteSpan);
  lSuite.AddTest('TestNoSpan', TestCabinetArchiveTestsTestNoSpan);
  lSuite.AddTest('ANSIEncodings', TestCabinetArchiveTestsANSIEncodings);
  lSuite.AddTest('DecompressCanterbury', TestCabinetArchiveTestsDecompressCanterbury);
  lSuite.AddTest('CompressCanterbury', TestCabinetArchiveTestsCompressCanterbury);
  lSuite := ARegistry.AddSuite('Abbrevia.CabinetExtractorTests');
  lSuite.AddTest('TestDefaultStreaming', TestCabinetExtractorTestsTestDefaultStreaming);
  lSuite.AddTest('TestComponentLinks', TestCabinetExtractorTestsTestComponentLinks);
  lSuite := ARegistry.AddSuite('Abbrevia.ZipBrowserTests');
  lSuite.AddTest('TestDefaultStreaming', TestZipBrowserTestsTestDefaultStreaming);
  lSuite.AddTest('TestComponentLinks', TestZipBrowserTestsTestComponentLinks);
  lSuite := ARegistry.AddSuite('Abbrevia.ZipArchiveTests');
  lSuite.AddTest('TestExtract', TestZipArchiveTestsTestExtract);
  lSuite.AddTest('TestExtractToStream', TestZipArchiveTestsTestExtractToStream);
  lSuite.AddTest('TestAdd', TestZipArchiveTestsTestAdd);
  lSuite.AddTest('TestAddFromStream', TestZipArchiveTestsTestAddFromStream);
  lSuite.AddTest('TestVerify', TestZipArchiveTestsTestVerify);
  lSuite.AddTest('TestBug3201728', TestZipArchiveTestsTestBug3201728);
  lSuite.AddTest('TestTestItemAt', TestZipArchiveTestsTestTestItemAt);
  lSuite.AddTest('TestTestItemAtCorrupt', TestZipArchiveTestsTestTestItemAtCorrupt);
  lSuite.AddTest('ANSIEncodings', TestZipArchiveTestsANSIEncodings);
  lSuite.AddTest('CompressEmptyFolders', TestZipArchiveTestsCompressEmptyFolders);
  lSuite.AddTest('DecompressEmptyFolders', TestZipArchiveTestsDecompressEmptyFolders);
  lSuite := ARegistry.AddSuite('Abbrevia.ArchiveSplitTests');
  lSuite.AddTest('DecompressSplitArchive', TestArchiveSplitTestsDecompressSplitArchive);
  lSuite.AddTest('CreateSplitArchive', TestArchiveSplitTestsCreateSplitArchive);
  lSuite.AddTest('AbortOnImageRequest', TestArchiveSplitTestsAbortOnImageRequest);
  lSuite := ARegistry.AddSuite('Abbrevia.VMStrmTests');
  lSuite.AddTest('TestReadWrite', TestVMStrmTestsTestReadWrite);
  lSuite.AddTest('TestEmptyStream', TestVMStrmTestsTestEmptyStream);
  lSuite := ARegistry.AddSuite('Abbrevia.UnZipperTests');
  lSuite.AddTest('TestDefaultStreaming', TestUnZipperTestsTestDefaultStreaming);
  lSuite.AddTest('TestComponentLinks', TestUnZipperTestsTestComponentLinks);
  lSuite.AddTest('TestBasicUnzip', TestUnZipperTestsTestBasicUnzip);
  lSuite.AddTest('TestBasicUnGzip', TestUnZipperTestsTestBasicUnGzip);
  lSuite.AddTest('TestBasicUnGzipTar', TestUnZipperTestsTestBasicUnGzipTar);
  lSuite.AddTest('TestUserAbort', TestUnZipperTestsTestUserAbort);
  lSuite.AddTest('TestGZipDecompress', TestUnZipperTestsTestGZipDecompress);
  lSuite.AddTest('TestZeroByteZipFile', TestUnZipperTestsTestZeroByteZipFile);
  lSuite.AddTest('TestIncompleteZipFile', TestUnZipperTestsTestIncompleteZipFile);
  lSuite.AddTest('TestArchiveNotFound', TestUnZipperTestsTestArchiveNotFound);
  lSuite.AddTest('TestZipCopiedFromFloppy', TestUnZipperTestsTestZipCopiedFromFloppy);
  lSuite.AddTest('DecompressSimplePW', TestUnZipperTestsDecompressSimplePW);
  lSuite.AddTest('DecompressPasswordTries', TestUnZipperTestsDecompressPasswordTries);
  lSuite.AddTest('CheckBadPWOverwrite', TestUnZipperTestsCheckBadPWOverwrite);
  lSuite.AddTest('TestLocale1', TestUnZipperTestsTestLocale1);
  lSuite.AddTest('TestLocale2', TestUnZipperTestsTestLocale2);
  lSuite.AddTest('TestLocale3', TestUnZipperTestsTestLocale3);
  lSuite.AddTest('TestLocale4', TestUnZipperTestsTestLocale4);
  lSuite.AddTest('TestFindCentralDirTail', TestUnZipperTestsTestFindCentralDirTail);
  lSuite := ARegistry.AddSuite('Abbrevia.CabinetBuilderTests');
  lSuite.AddTest('TestDefaultStreaming', TestCabinetBuilderTestsTestDefaultStreaming);
  lSuite.AddTest('TestComponentLinks', TestCabinetBuilderTestsTestComponentLinks);
  lSuite := ARegistry.AddSuite('Abbrevia.LZMATests');
  lSuite.AddTest('TestDecodeStream', TestLZMATestsTestDecodeStream);
  lSuite.AddTest('TestEncodeStream', TestLZMATestsTestEncodeStream);
  lSuite.AddTest('TestDecompressionStream', TestLZMATestsTestDecompressionStream);
  lSuite.AddTest('TestCompressionStream', TestLZMATestsTestCompressionStream);
  lSuite := ARegistry.AddSuite('Abbrevia.CabinetBrowserTests');
  lSuite.AddTest('TestDefaultStreaming', TestCabinetBrowserTestsTestDefaultStreaming);
  lSuite.AddTest('TestComponentLinks', TestCabinetBrowserTestsTestComponentLinks);
  lSuite := ARegistry.AddSuite('Abbrevia.ZipPrcTests');
  lSuite.AddTest('DeflateStreamSimpleTest1', TestZipPrcTestsDeflateStreamSimpleTest1);
  lSuite.AddTest('DeflateStreamSimpleTest2', TestZipPrcTestsDeflateStreamSimpleTest2);
  lSuite.AddTest('DeflateStreamFileTest', TestZipPrcTestsDeflateStreamFileTest);
  lSuite.AddTest('DeflateStreamInflateStreamTest', TestZipPrcTestsDeflateStreamInflateStreamTest);
  lSuite := ARegistry.AddSuite('Abbrevia.ArchiveListTests');
  lSuite.AddTest('TestEnumerator', TestArchiveListTestsTestEnumerator);
  lSuite.AddTest('TestGenerateHash', TestArchiveListTestsTestGenerateHash);
  lSuite := ARegistry.AddSuite('Abbrevia.CabinetKitTests');
  lSuite.AddTest('TestDefaultStreaming', TestCabinetKitTestsTestDefaultStreaming);
  lSuite.AddTest('TestComponentLinks', TestCabinetKitTestsTestComponentLinks);
  lSuite := ARegistry.AddSuite('Abbrevia.TarArchiveTests');
  lSuite.AddTest('TestExtract', TestTarArchiveTestsTestExtract);
  lSuite.AddTest('TestExtractToStream', TestTarArchiveTestsTestExtractToStream);
  lSuite.AddTest('TestAdd', TestTarArchiveTestsTestAdd);
  lSuite.AddTest('TestAddFromStream', TestTarArchiveTestsTestAddFromStream);
  lSuite.AddTest('TestVerify', TestTarArchiveTestsTestVerify);
  lSuite.AddTest('TestBug3201728', TestTarArchiveTestsTestBug3201728);
  lSuite.AddTest('ANSIEncodings', TestTarArchiveTestsANSIEncodings);
  lSuite.AddTest('CompressEmptyFolders', TestTarArchiveTestsCompressEmptyFolders);
  lSuite.AddTest('DecompressEmptyFolders', TestTarArchiveTestsDecompressEmptyFolders);
  lSuite.AddTest('DecompressCanterbury', TestTarArchiveTestsDecompressCanterbury);
  lSuite.AddTest('CompressCanterbury', TestTarArchiveTestsCompressCanterbury);
  lSuite := ARegistry.AddSuite('Abbrevia.UnzPrcTests');
  lSuite.AddTest('InflateStreamSimpleTest1', TestUnzPrcTestsInflateStreamSimpleTest1);
  lSuite.AddTest('InflateStreamSimpleTest2', TestUnzPrcTestsInflateStreamSimpleTest2);
  lSuite.AddTest('InflateStreamFileTest', TestUnzPrcTestsInflateStreamFileTest);
  lSuite := ARegistry.AddSuite('Abbrevia.Bzip2ArchiveTests');
  lSuite.AddTest('TestExtract', TestBzip2ArchiveTestsTestExtract);
  lSuite.AddTest('TestExtractToStream', TestBzip2ArchiveTestsTestExtractToStream);
  lSuite.AddTest('TestAdd', TestBzip2ArchiveTestsTestAdd);
  lSuite.AddTest('TestAddFromStream', TestBzip2ArchiveTestsTestAddFromStream);
  lSuite.AddTest('TestVerify', TestBzip2ArchiveTestsTestVerify);
  lSuite.AddTest('TestBug3201728', TestBzip2ArchiveTestsTestBug3201728);
  lSuite := ARegistry.AddSuite('Abbrevia.BzippedTarArchiveTests');
  lSuite.AddTest('TestExtract', TestBzippedTarArchiveTestsTestExtract);
  lSuite.AddTest('TestExtractToStream', TestBzippedTarArchiveTestsTestExtractToStream);
  lSuite.AddTest('TestAdd', TestBzippedTarArchiveTestsTestAdd);
  lSuite.AddTest('TestAddFromStream', TestBzippedTarArchiveTestsTestAddFromStream);
  lSuite.AddTest('TestVerify', TestBzippedTarArchiveTestsTestVerify);
  lSuite.AddTest('TestBug3201728', TestBzippedTarArchiveTestsTestBug3201728);
  lSuite.AddTest('CompressEmptyFolders', TestBzippedTarArchiveTestsCompressEmptyFolders);
  lSuite.AddTest('DecompressEmptyFolders', TestBzippedTarArchiveTestsDecompressEmptyFolders);
  lSuite.AddTest('DecompressCanterbury', TestBzippedTarArchiveTestsDecompressCanterbury);
  lSuite.AddTest('CompressCanterbury', TestBzippedTarArchiveTestsCompressCanterbury);
  lSuite := ARegistry.AddSuite('Abbrevia.GzipExtraFieldTests');
  lSuite.AddTest('TextEmptyField', TestGzipExtraFieldTestsTextEmptyField);
  lSuite.AddTest('TestAddZeroLengthAttr', TestGzipExtraFieldTestsTestAddZeroLengthAttr);
  lSuite.AddTest('TestAddAttr', TestGzipExtraFieldTestsTestAddAttr);
  lSuite.AddTest('TestAddTwoAttr', TestGzipExtraFieldTestsTestAddTwoAttr);
  lSuite.AddTest('TestDeleteFirstSubfield', TestGzipExtraFieldTestsTestDeleteFirstSubfield);
  lSuite.AddTest('TestDeleteLastSubfield', TestGzipExtraFieldTestsTestDeleteLastSubfield);
  lSuite.AddTest('TestDeleteMiddleSubfield', TestGzipExtraFieldTestsTestDeleteMiddleSubfield);
  lSuite.AddTest('TestDeleteAllSubfields', TestGzipExtraFieldTestsTestDeleteAllSubfields);
  lSuite.AddTest('TestReplaceSameSize', TestGzipExtraFieldTestsTestReplaceSameSize);
  lSuite.AddTest('TestReplaceDiffSize', TestGzipExtraFieldTestsTestReplaceDiffSize);
  lSuite := ARegistry.AddSuite('Abbrevia.GzipArchiveTests');
  lSuite.AddTest('TestExtract', TestGzipArchiveTestsTestExtract);
  lSuite.AddTest('TestExtractToStream', TestGzipArchiveTestsTestExtractToStream);
  lSuite.AddTest('TestAdd', TestGzipArchiveTestsTestAdd);
  lSuite.AddTest('TestAddFromStream', TestGzipArchiveTestsTestAddFromStream);
  lSuite.AddTest('TestVerify', TestGzipArchiveTestsTestVerify);
  lSuite.AddTest('TestBug3201728', TestGzipArchiveTestsTestBug3201728);
  lSuite.AddTest('ANSIEncodings', TestGzipArchiveTestsANSIEncodings);
  lSuite := ARegistry.AddSuite('Abbrevia.GzippedTarArchiveTests');
  lSuite.AddTest('TestExtract', TestGzippedTarArchiveTestsTestExtract);
  lSuite.AddTest('TestExtractToStream', TestGzippedTarArchiveTestsTestExtractToStream);
  lSuite.AddTest('TestAdd', TestGzippedTarArchiveTestsTestAdd);
  lSuite.AddTest('TestAddFromStream', TestGzippedTarArchiveTestsTestAddFromStream);
  lSuite.AddTest('TestVerify', TestGzippedTarArchiveTestsTestVerify);
  lSuite.AddTest('TestBug3201728', TestGzippedTarArchiveTestsTestBug3201728);
  lSuite.AddTest('CompressEmptyFolders', TestGzippedTarArchiveTestsCompressEmptyFolders);
  lSuite.AddTest('DecompressEmptyFolders', TestGzippedTarArchiveTestsDecompressEmptyFolders);
  lSuite.AddTest('DecompressCanterbury', TestGzippedTarArchiveTestsDecompressCanterbury);
  lSuite.AddTest('CompressCanterbury', TestGzippedTarArchiveTestsCompressCanterbury);
  lSuite := ARegistry.AddSuite('Abbrevia.Zip64');
  lSuite.AddTest('SaveLargeListing', TestZip64SaveLargeListing);
  lSuite := ARegistry.AddSuite('Abbrevia.ZipDecompression');
  lSuite.AddTest('Bzip2', TestZipDecompressionBzip2);
  lSuite.AddTest('DCLImpl', TestZipDecompressionDCLImpl);
  lSuite.AddTest('Deflate', TestZipDecompressionDeflate);
  lSuite.AddTest('Deflate64', TestZipDecompressionDeflate64);
  lSuite.AddTest('DeflateP', TestZipDecompressionDeflateP);
  lSuite.AddTest('Implode', TestZipDecompressionImplode);
  lSuite.AddTest('ImplodeP', TestZipDecompressionImplodeP);
  lSuite.AddTest('LZMA', TestZipDecompressionLZMA);
  lSuite.AddTest('PPMd', TestZipDecompressionPPMd);
  lSuite.AddTest('Reduce1', TestZipDecompressionReduce1);
  lSuite.AddTest('Reduce2', TestZipDecompressionReduce2);
  lSuite.AddTest('Reduce3', TestZipDecompressionReduce3);
  lSuite.AddTest('Reduce4', TestZipDecompressionReduce4);
  lSuite.AddTest('Shrink', TestZipDecompressionShrink);
  lSuite.AddTest('ShrinkP', TestZipDecompressionShrinkP);
  lSuite.AddTest('Store', TestZipDecompressionStore);
  lSuite.AddTest('StoreP', TestZipDecompressionStoreP);
  lSuite := ARegistry.AddSuite('Abbrevia.ZipCompression');
  lSuite.AddTest('Store', TestZipCompressionStore);
  lSuite.AddTest('Deflate', TestZipCompressionDeflate);
  lSuite.AddTest('StoreP', TestZipCompressionStoreP);
  lSuite.AddTest('DeflateP', TestZipCompressionDeflateP);
  lSuite := ARegistry.AddSuite('Abbrevia.ArchiveDetection');
  lSuite.AddTest('MPL.cab', TestArchiveDetectionMPLcab);
  lSuite.AddTest('MPL.tbz', TestArchiveDetectionMPLtbz);
  lSuite.AddTest('MPL.bz2', TestArchiveDetectionMPLbz2);
  lSuite.AddTest('MPL.gz', TestArchiveDetectionMPLgz);
  lSuite.AddTest('MPL-1_1.txt', TestArchiveDetectionMPL11txt);
  lSuite.AddTest('MPL.tgz', TestArchiveDetectionMPLtgz);
  lSuite.AddTest('MPL.zip', TestArchiveDetectionMPLzip);
  lSuite.AddTest('MPL.exe', TestArchiveDetectionMPLexe);
  lSuite.AddTest('MPL.lnx', TestArchiveDetectionMPLlnx);
  lSuite.AddTest('MPL.tar', TestArchiveDetectionMPLtar);
  lSuite.AddTest('Split.z01', TestArchiveDetectionSplitz01);
  lSuite.AddTest('Split.zip', TestArchiveDetectionSplitzip);
  lSuite.AddTest('Test0001.cab', TestArchiveDetectionTest0001cab);
  RegisterAbCodecTests(ARegistry);
  RegisterAbCabinetAPITests(ARegistry);
  RegisterAbDecompressionTests(ARegistry);
  RegisterAbZipFileNameTests(ARegistry);
  RegisterAbLZMAStreamTests(ARegistry);
end;
end.
