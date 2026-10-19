// Copyright (c) 2026 Kevin Collins.
// SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
unit tsAbCodecTests;
{$mode objfpc}{$H+}
interface
uses obNXTestRegistry;
procedure RegisterAbCodecTests(ARegistry: TNXTestRegistry);
implementation
uses
  Classes, SysUtils, {$IFDEF MSWINDOWS}Windows,{$ENDIF}
  obNXTestContext, obNXTestSuite, obAbTestFixture,
  Abbrevia.Zip, Abbrevia.ZipExtraction, Abbrevia.CRuntime,
  Abbrevia.LZMA, Abbrevia.PPMd, Abbrevia.WavPack, Abbrevia.BZip2;

function MakeData(ASize: Integer): TBytes;
var
  lIndex: Integer;
begin
  Result := nil;
  SetLength(Result, ASize);
  for lIndex := 0 to ASize - 1 do
    Result[lIndex] := (lIndex * 37 xor (lIndex shr 8)) and $FF;
end;

{$PUSH}{$Q+}
function CheckedIncrement(AValue: Int64): Int64;
begin
  Result := AValue + 1;
end;
{$POP}

procedure CheckSharedRTLReferences(AContext: TNXTestContext);
var
  lCaught: Boolean;
begin
  AContext.AssertEquals('package', Trim(' package '));
  AContext.AssertTrue(TEncoding.ANSI <> nil, 'Shared ANSI encoding factory');
  AContext.AssertTrue(TEncoding.ASCII <> nil, 'Shared ASCII encoding factory');
  AContext.AssertTrue(TEncoding.UTF8 <> nil, 'Shared UTF8 encoding factory');
  lCaught := False;
  try
    CheckedIncrement(High(Int64));
  except
    on E: EIntOverflow do lCaught := True;
  end;
  AContext.AssertTrue(lCaught, 'Shared overflow helper and exception identity');
end;
procedure CheckCLayout(AContext: TNXTestContext);
begin
  AContext.AssertTrue(SizeOf(size_t) = SizeOf(Pointer), 'C size_t must be pointer-sized');
  AContext.AssertTrue(Low(size_t) = 0, 'C size_t must be unsigned');
  AContext.AssertTrue(SizeOf(TBZStreamRec) = 80, '64-bit bz_stream must use C record alignment');
end;

procedure CheckArchives(AContext: TNXTestContext; const AFolder, AName: string);
var
  lReference, lArchive: TAbZipArchive;
  lActual, lExpected: TMemoryStream;
  lName: string;
  lIndex, lReferenceIndex: Integer;
begin
  lReference := TAbZipArchive.Create(AFolder + '/Store.zip', fmOpenRead);
  lExpected := TMemoryStream.Create;
  lActual := TMemoryStream.Create;
  try
    lReference.Load;
    AContext.AssertTrue(lReference.Count = 11, 'Expected 11 reference files');
    lName := AName;
    begin
      lArchive := TAbZipArchive.Create(AFolder + '/' + lName + '.zip', fmOpenRead);
      try
        lArchive.Load;
        AContext.AssertTrue(lArchive.Count = lReference.Count, lName + ': file count mismatch');
        for lIndex := 0 to lArchive.Count - 1 do
        begin
          lReferenceIndex := lReference.FindFile(lArchive.Items[lIndex].FileName);
          AContext.AssertTrue(lReferenceIndex >= 0, 'Missing reference entry');
          lExpected.Clear;
          lActual.Clear;
          AbUnzipToStream(lReference, lReference.Items[lReferenceIndex], lExpected);
          AbUnzipToStream(lArchive, lArchive.Items[lIndex], lActual);
          AContext.AssertTrue((lActual.Size = lExpected.Size) and
            CompareMem(lActual.Memory, lExpected.Memory, lExpected.Size),
            lName + ': different bytes for ' + lArchive.Items[lIndex].FileName);
        end;
      finally
        lArchive.Free;
      end;
    end;
  finally
    lActual.Free;
    lExpected.Free;
    lReference.Free;
  end;
end;

procedure CheckLZMA(AContext: TNXTestContext; ASize: Integer);
var
  lData, lPacked, lRestored: TBytes;
  lInput, lCompressed, lOutput: TMemoryStream;
  lSize, lIndex, lPackedSize: Integer;
begin
  lInput := TMemoryStream.Create;
  lCompressed := TMemoryStream.Create;
  lOutput := TMemoryStream.Create;
  try
    lSize := ASize;
    begin
      SetLength(lData, lSize + 1);
      SetLength(lRestored, lSize + 1);
      SetLength(lPacked, lSize + 1024);
      for lIndex := 0 to lSize - 1 do
        lData[lIndex] := (lIndex * 37 xor (lIndex shr 8)) and $FF;
      lPackedSize := LzmaEncodeBuffer(@lData[0], lSize, @lPacked[0], Length(lPacked));
      AContext.AssertTrue(LzmaGetUncompressedSize(@lPacked[0], lPackedSize) = lSize, 'LZMA header length');
      LzmaDecodeBuffer(@lPacked[0], lPackedSize, @lRestored[0]);
      AContext.AssertTrue(CompareMem(@lData[0], @lRestored[0], lSize), 'LZMA buffer bytes');
      lInput.Clear;
      lCompressed.Clear;
      lOutput.Clear;
      lInput.WriteBuffer(lData[0], lSize);
      lInput.Position := 0;
      LzmaEncodeStream(lInput, lCompressed, lSize);
      lCompressed.Position := 0;
      LzmaDecodeStream(lCompressed, lOutput);
      AContext.AssertTrue((lOutput.Size = lSize) and
        CompareMem(@lData[0], lOutput.Memory, lSize), 'LZMA stream bytes');
    end;
  finally
    lOutput.Free;
    lCompressed.Free;
    lInput.Free;
  end;
end;

procedure CheckWavPack(AContext: TNXTestContext; const AFolder, AName: string);
var
  lSource: TFileStream;
  lActual, lExpected: TMemoryStream;
  lName: string;
begin
  lActual := TMemoryStream.Create;
  lExpected := TMemoryStream.Create;
  try
    lName := AName;
    begin
      lSource := TFileStream.Create(AFolder + '/' + lName + '.wv', fmOpenRead);
      try
        lActual.Clear;
        lExpected.LoadFromFile(AFolder + '/' + lName + '.wav');
        DecompressWavPack(lSource, lActual);
        AContext.AssertTrue((lActual.Size = lExpected.Size) and
          CompareMem(lActual.Memory, lExpected.Memory, lExpected.Size),
          lName + ': WavPack decoded bytes differ');
      finally
        lSource.Free;
      end;
    end;
  finally
    lExpected.Free;
    lActual.Free;
  end;
end;

procedure CheckBuffer(AContext: TNXTestContext; const AData: TBytes); forward;

function ExpectedBZip2Library(const AFileName: string): string;
begin
  Result := GetEnvironmentVariable('NX_ABBREVIA_EXPECTED_BZIP2_LIBRARY');
  if Result = '' then Result := ExtractFilePath(ParamStr(0)) + AFileName;
  Result := ExpandFileName(Result);
end;

procedure CheckLoadedLibrary(AContext: TNXTestContext);
{$IFDEF MSWINDOWS}
var
  lName: array[0..32767] of AnsiChar;
  lLength: DWORD;
  lExpected: string;
begin
  CheckBuffer(AContext, MakeData(1));
  lLength := GetModuleFileNameA(GetModuleHandleA('libbz2.dll'), lName, Length(lName));
  AContext.AssertTrue((lLength > 0) and (lLength < Length(lName)), 'Cannot identify loaded bzip2 DLL');
  lExpected := ExpectedBZip2Library('libbz2.dll');
  AContext.AssertTrue(SameFileName(StrPas(lName), lExpected), 'Loaded a different bzip2 DLL: ' + StrPas(lName));
{$ELSEIF DEFINED(LINUX)}
var
  lMaps: TStringList;
  lLine, lExpected, lLoaded: string;
  lPathStart: Integer;
  lFound: Boolean;
begin
  CheckBuffer(AContext, MakeData(1));
  lExpected := ExpectedBZip2Library('libbz2.so.1');
  lMaps := TStringList.Create;
  try
    lMaps.LoadFromFile('/proc/self/maps');
    lFound := False;
    for lLine in lMaps do
      if Pos('/libbz2.so.1', lLine) > 0 then
      begin
        lPathStart := Pos(' /', lLine);
        AContext.AssertTrue(lPathStart > 0, 'Cannot parse loaded library path: ' + lLine);
        lLoaded := Trim(Copy(lLine, lPathStart + 1, MaxInt));
        AContext.AssertTrue(SameFileName(lExpected, lLoaded),
          'Loaded a different bzip2 library: ' + lLoaded + '; expected ' + lExpected);
        lFound := True;
      end;
    AContext.AssertTrue(lFound, 'Cannot identify loaded bzip2 library');
  finally
    lMaps.Free;
  end;
{$ENDIF}
end;

procedure CheckBuffer(AContext: TNXTestContext; const AData: TBytes);
var
  lInput, lCompressed, lRestored: Pointer;
  lCompressedSize, lRestoredSize: Integer;
  lEmpty: Byte;
begin
  lEmpty := 0;
  if Length(AData) = 0 then lInput := @lEmpty else lInput := @AData[0];
  BZCompressBuf(lInput, Length(AData), lCompressed, lCompressedSize);
  try
    BZDecompressBuf(lCompressed, lCompressedSize, 0, lRestored, lRestoredSize);
    try
      AContext.AssertTrue(lRestoredSize = Length(AData), 'Buffer round-trip length mismatch');
      if Length(AData) > 0 then
        AContext.AssertTrue(CompareMem(lInput, lRestored, Length(AData)), 'Buffer round-trip data mismatch');
    finally
      FreeMem(lRestored);
    end;
  finally
    FreeMem(lCompressed);
  end;
end;

procedure CheckStream(AContext: TNXTestContext; const AData: TBytes);
var
  lCompressed: TMemoryStream;
  lWriter: TAbBZip2CompressionStream;
  lReader: TAbBZip2DecompressionStream;
  lRestored: TBytes;
  lOffset, lCount: Integer;
  lExtra: Byte;
begin
  lCompressed := TMemoryStream.Create;
  try
    lWriter := TAbBZip2CompressionStream.Create(bs1, lCompressed);
    try
      lOffset := 0;
      while lOffset < Length(AData) do
      begin
        lCount := Length(AData) - lOffset;
        if lCount > 137 then lCount := 137;
        lWriter.WriteBuffer(AData[lOffset], lCount);
        Inc(lOffset, lCount);
      end;
    finally
      lWriter.Free;
    end;
    lCompressed.Position := 0;
    lReader := TAbBZip2DecompressionStream.Create(lCompressed);
    try
      SetLength(lRestored, Length(AData));
      lOffset := 0;
      while lOffset < Length(lRestored) do
      begin
        lCount := Length(lRestored) - lOffset;
        if lCount > 509 then lCount := 509;
        lReader.ReadBuffer(lRestored[lOffset], lCount);
        Inc(lOffset, lCount);
      end;
      AContext.AssertTrue(lReader.Read(lExtra, 1) = 0, 'Unexpected data after stream round-trip');
      if Length(AData) > 0 then
        AContext.AssertTrue(CompareMem(@AData[0], @lRestored[0], Length(AData)), 'Stream round-trip data mismatch');
    finally
      lReader.Free;
    end;
  finally
    lCompressed.Free;
  end;
end;

procedure Buffer0(AContext: TNXTestContext);
begin
  CheckBuffer(AContext, MakeData(0));
end;

procedure Stream0(AContext: TNXTestContext);
begin
  CheckStream(AContext, MakeData(0));
end;

procedure LZMA0(AContext: TNXTestContext);
begin
  CheckLZMA(AContext, 0);
end;

procedure Buffer1(AContext: TNXTestContext);
begin
  CheckBuffer(AContext, MakeData(1));
end;

procedure Stream1(AContext: TNXTestContext);
begin
  CheckStream(AContext, MakeData(1));
end;

procedure LZMA1(AContext: TNXTestContext);
begin
  CheckLZMA(AContext, 1);
end;

procedure Buffer4096(AContext: TNXTestContext);
begin
  CheckBuffer(AContext, MakeData(4096));
end;

procedure Stream4096(AContext: TNXTestContext);
begin
  CheckStream(AContext, MakeData(4096));
end;

procedure LZMA4096(AContext: TNXTestContext);
begin
  CheckLZMA(AContext, 4096);
end;

procedure Buffer1048576(AContext: TNXTestContext);
begin
  CheckBuffer(AContext, MakeData(1048576));
end;

procedure Stream1048576(AContext: TNXTestContext);
begin
  CheckStream(AContext, MakeData(1048576));
end;

procedure LZMA1048576(AContext: TNXTestContext);
begin
  CheckLZMA(AContext, 1048576);
end;

procedure ZipDeflate(AContext: TNXTestContext);
begin
  CheckArchives(AContext, TAbTestCase.CanterburyDir, 'Deflate');
end;

procedure ZipLZMA(AContext: TNXTestContext);
begin
  CheckArchives(AContext, TAbTestCase.CanterburyDir, 'LZMA');
end;

procedure ZipPPMd(AContext: TNXTestContext);
begin
  CheckArchives(AContext, TAbTestCase.CanterburyDir, 'PPMd');
end;

procedure WavPackpcm8(AContext: TNXTestContext);
begin
  CheckWavPack(AContext, TAbTestCase.TestFileDir + 'WavPack', 'pcm8');
end;

procedure WavPackpcm16(AContext: TNXTestContext);
begin
  CheckWavPack(AContext, TAbTestCase.TestFileDir + 'WavPack', 'pcm16');
end;

procedure WavPackpcm24(AContext: TNXTestContext);
begin
  CheckWavPack(AContext, TAbTestCase.TestFileDir + 'WavPack', 'pcm24');
end;

procedure RegisterAbCodecTests(ARegistry: TNXTestRegistry);
var
  lSuite: TNXTestSuite;
begin
  lSuite := ARegistry.AddSuite('Abbrevia.NativeCodecs');
  lSuite.AddTest('CLayout', @CheckCLayout);
  lSuite.AddTest('SharedRTLReferences', @CheckSharedRTLReferences);
  lSuite.AddTest('GeneratedBzip2Library', @CheckLoadedLibrary);
  lSuite.AddTest('Buffer0', @Buffer0);
  lSuite.AddTest('Stream0', @Stream0);
  lSuite.AddTest('LZMA0', @LZMA0);
  lSuite.AddTest('Buffer1', @Buffer1);
  lSuite.AddTest('Stream1', @Stream1);
  lSuite.AddTest('LZMA1', @LZMA1);
  lSuite.AddTest('Buffer4096', @Buffer4096);
  lSuite.AddTest('Stream4096', @Stream4096);
  lSuite.AddTest('LZMA4096', @LZMA4096);
  lSuite.AddTest('Buffer1048576', @Buffer1048576);
  lSuite.AddTest('Stream1048576', @Stream1048576);
  lSuite.AddTest('LZMA1048576', @LZMA1048576);
  lSuite.AddTest('ZipDeflate', @ZipDeflate);
  lSuite.AddTest('ZipLZMA', @ZipLZMA);
  lSuite.AddTest('ZipPPMd', @ZipPPMd);
  lSuite.AddTest('WavPackpcm8', @WavPackpcm8);
  lSuite.AddTest('WavPackpcm16', @WavPackpcm16);
  lSuite.AddTest('WavPackpcm24', @WavPackpcm24);
end;
end.
