// Copyright (c) 2026 Kevin Collins.
// SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
unit tsAbCabinetAPITests;

{$mode delphi}{$H+}

interface

uses obNXTestRegistry;

procedure RegisterAbCabinetAPITests(ARegistry: TNXTestRegistry);

implementation

uses
  Classes, SysUtils, obNXTestContext, obNXTestSuite
  {$IFDEF MSWINDOWS}, Abbrevia.Cabinet, Abbrevia.CabinetAPI{$ENDIF};

procedure TestSDKLayout(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
const
  // Windows SDK fdi.h: Win32 uses pack(4); Win64 uses native C alignment.
  {$IFDEF WIN64}
  cNotificationSize = 64;
  cNameOffset = 8;
  cArchiveOffset = 32;
  cHandleOffset = 40;
  cErrorOffset = 60;
  {$ELSE}
  cNotificationSize = 40;
  cNameOffset = 4;
  cArchiveOffset = 16;
  cHandleOffset = 20;
  cErrorOffset = 36;
  {$ENDIF}
var
  lNotification: FDINotification;

  procedure CheckOffset(AExpected: Integer; AField: Pointer; const AName: string);
  begin
    AContext.AssertEquals(AExpected,
      Integer(PtrUInt(AField) - PtrUInt(@lNotification)), AName);
  end;

begin
  AContext.AssertEquals(4, SizeOf(FDIError), 'FDIERROR size');
  AContext.AssertEquals(4, SizeOf(FCIError), 'FCIERROR size');
  AContext.AssertEquals(4, SizeOf(FDINotificationType), 'FDINOTIFICATIONTYPE size');
  AContext.AssertEquals(12, SizeOf(CabErrorRecord), 'ERF size');
  AContext.AssertEquals(24, SizeOf(FDICabInfo), 'FDICABINETINFO size');
  AContext.AssertEquals(804, SizeOf(FCICabInfo), 'CCAB size');
  AContext.AssertEquals(cNotificationSize, SizeOf(lNotification), 'FDINOTIFICATION size');
  CheckOffset(cNameOffset, @lNotification.psz1, 'psz1 offset');
  CheckOffset(cArchiveOffset, @lNotification.pv, 'pv offset');
  CheckOffset(cHandleOffset, @lNotification.hf, 'hf offset');
  CheckOffset(cErrorOffset, @lNotification.fdie, 'fdie offset');
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetRoundTrip(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
const
  cPayload: AnsiString = 'Cabinet callback round trip'#13#10#0#$80#$FF;
var
  lDirectory, lSourceName, lCabinetName, lExtractedName: string;
  lGUID: TGUID;
  lArchive: TAbCabinetArchive;
  lFile: TFileStream;
  lStream: TMemoryStream;

  procedure CheckContents;
  begin
    AContext.AssertEquals(Length(cPayload), lStream.Size, 'Extracted size');
    AContext.AssertTrue(CompareMem(lStream.Memory, @cPayload[1], Length(cPayload)),
      'Extracted contents');
  end;

begin
  CreateGUID(lGUID);
  lDirectory := IncludeTrailingPathDelimiter(GetTempDir) + 'abbrevia-cab-' + GUIDToString(lGUID);
  AContext.AssertTrue(CreateDir(lDirectory), 'Create test directory');
  lDirectory := IncludeTrailingPathDelimiter(lDirectory);
  lSourceName := lDirectory + 'source.bin';
  lCabinetName := lDirectory + 'roundtrip.cab';
  lExtractedName := lDirectory + 'extracted.bin';
  try
    lFile := TFileStream.Create(lSourceName, fmCreate);
    try
      lFile.WriteBuffer(cPayload[1], Length(cPayload));
    finally
      lFile.Free;
    end;
    lArchive := TAbCabinetArchive.Create(lCabinetName, fmCreate);
    try
      lArchive.Load;
      lArchive.BaseDirectory := lDirectory;
      lArchive.AddFiles('source.bin', faAnyFile);
      lStream := TMemoryStream.Create;
      try
        lStream.WriteBuffer(cPayload[1], Length(cPayload));
        lStream.Position := 0;
        lArchive.AddFromStream('stream.bin', lStream);
      finally
        lStream.Free;
      end;
      lArchive.Save;
    finally
      lArchive.Free;
    end;
    lArchive := TAbCabinetArchive.Create(lCabinetName, fmOpenRead);
    try
      lArchive.Load;
      AContext.AssertEquals(2, lArchive.ItemList.Count, 'Reopened mixed file/stream item count');
      lStream := TMemoryStream.Create;
      try
        lArchive.ExtractToStream(lArchive.ItemList[0].FileName, lStream);
        CheckContents;
        lArchive.ExtractAt(0, lExtractedName);
        lStream.LoadFromFile(lExtractedName);
        CheckContents;
        lStream.Clear;
        lArchive.ExtractToStream('stream.bin', lStream);
        CheckContents;
      finally
        lStream.Free;
      end;
    finally
      lArchive.Free;
    end;
  finally
    DeleteFile(lExtractedName);
    DeleteFile(lCabinetName);
    DeleteFile(lSourceName);
    RemoveDir(lDirectory);
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;

procedure TestCabinetStreamRoundTrip(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lCabinetName: string;
  lGUID: TGUID;
  lArchive: TAbCabinetArchive;
  lInput, lOutput: TMemoryStream;
  lPayload: AnsiString;
  lIndex: Integer;
begin
  CreateGUID(lGUID);
  lCabinetName := IncludeTrailingPathDelimiter(GetTempDir) +
    'abbrevia-stream-' + GUIDToString(lGUID) + '.cab';
  SetLength(lPayload, 65537);
  for lIndex := 1 to Length(lPayload) do
    lPayload[lIndex] := AnsiChar(lIndex and $FF);
  try
    lArchive := TAbCabinetArchive.Create(lCabinetName, fmCreate);
    try
      lArchive.Load;
      lInput := TMemoryStream.Create;
      try
        lInput.WriteBuffer(lPayload[1], Length(lPayload));
        lInput.Position := 7;
        lArchive.AddFromStream('first.bin', lInput);
        AContext.AssertEquals(Length(lPayload), lInput.Size, 'Caller still owns first input');
        lInput.Position := 31;
        lArchive.AddFromStream('second.bin', lInput);
        lInput.Clear;
        lArchive.AddFromStream('empty.bin', lInput);
        AContext.AssertEquals(0, lInput.Size, 'Caller still owns empty input');
      finally
        // FCI must have consumed the borrowed inputs before AddFromStream returns.
        lInput.Free;
      end;
      lArchive.Save;
    finally
      lArchive.Free;
    end;
    lArchive := TAbCabinetArchive.Create(lCabinetName, fmOpenRead);
    try
      lArchive.Load;
      AContext.AssertEquals(3, lArchive.ItemList.Count, 'Three stream-backed entries');
      lOutput := TMemoryStream.Create;
      try
        lArchive.ExtractToStream('first.bin', lOutput);
        AContext.AssertEquals(Length(lPayload) - 7, lOutput.Size, 'First input starts at current position');
        AContext.AssertTrue(CompareMem(lOutput.Memory, @lPayload[8], lOutput.Size), 'First payload');
        lOutput.Clear;
        lArchive.ExtractToStream('second.bin', lOutput);
        AContext.AssertEquals(Length(lPayload) - 31, lOutput.Size, 'Reused input starts at current position');
        AContext.AssertTrue(CompareMem(lOutput.Memory, @lPayload[32], lOutput.Size), 'Second payload');
        lOutput.Clear;
        lArchive.ExtractToStream('empty.bin', lOutput);
        AContext.AssertEquals(0, lOutput.Size, 'Empty payload');
      finally
        lOutput.Free;
      end;
    finally
      lArchive.Free;
    end;
  finally
    DeleteFile(lCabinetName);
  end;
{$ELSE}
begin
  AContext.Skip('Microsoft Cabinet API is Windows-only in Abbrevia.');
{$ENDIF}
end;
procedure RegisterAbCabinetAPITests(ARegistry: TNXTestRegistry);
var
  lSuite: TNXTestSuite;
begin
  lSuite := ARegistry.AddSuite('Abbrevia.CabinetAPI');
  lSuite.AddTest('SDKLayout', TestSDKLayout);
  lSuite.AddTest('RoundTrip', TestCabinetRoundTrip);
  lSuite.AddTest('StreamRoundTrip', TestCabinetStreamRoundTrip);
end;

end.
