// Copyright (c) 2026 Kevin Collins.
// SPDX-License-Identifier: MPL-2.0-no-copyleft-exception

program AbbreviaBZip2RoundTrip;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, {$IFDEF MSWINDOWS}Windows,{$ENDIF} Abbrevia.BZip2;

procedure Check(ACondition: Boolean; const AMessage: string);
begin
  if not ACondition then
    raise Exception.Create(AMessage);
end;

procedure CheckLoadedLibrary;
{$IFDEF MSWINDOWS}
var
  lName: array[0..32767] of AnsiChar;
  lLength: DWORD;
  lExpected: string;
begin
  lLength := GetModuleFileNameA(GetModuleHandleA('libbz2.dll'), lName, Length(lName));
  Check((lLength > 0) and (lLength < Length(lName)), 'Cannot identify loaded bzip2 DLL');
  lExpected := ExpandFileName(ExtractFilePath(ParamStr(0)) + 'libbz2.dll');
  Check(SameFileName(StrPas(lName), lExpected), 'Loaded a different bzip2 DLL: ' + StrPas(lName));
  WriteLn('Library: ', StrPas(lName));
{$ELSE}
var
  lMaps: TStringList;
  lLine, lExpected: string;
  lFound: Boolean;
begin
  lExpected := ExpandFileName(ExtractFilePath(ParamStr(0)) + 'libbz2.so.1');
  lMaps := TStringList.Create;
  try
    lMaps.LoadFromFile('/proc/self/maps');
    lFound := False;
    for lLine in lMaps do
      if Pos('/libbz2.so.1', lLine) > 0 then
      begin
        Check(Pos(lExpected, lLine) > 0, 'Loaded a different bzip2 library: ' + lLine);
        lFound := True;
      end;
    Check(lFound, 'Cannot identify loaded bzip2 library');
    WriteLn('Library: ', lExpected);
  finally
    lMaps.Free;
  end;
{$ENDIF}
end;

procedure CheckBuffer(const AData: TBytes);
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
      Check(lRestoredSize = Length(AData), 'Buffer round-trip length mismatch');
      if Length(AData) > 0 then
        Check(CompareMem(lInput, lRestored, Length(AData)), 'Buffer round-trip data mismatch');
    finally
      FreeMem(lRestored);
    end;
  finally
    FreeMem(lCompressed);
  end;
end;

procedure CheckStream(const AData: TBytes);
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
      Check(lReader.Read(lExtra, 1) = 0, 'Unexpected data after stream round-trip');
      if Length(AData) > 0 then
        Check(CompareMem(@AData[0], @lRestored[0], Length(AData)), 'Stream round-trip data mismatch');
    finally
      lReader.Free;
    end;
  finally
    lCompressed.Free;
  end;
end;

procedure RunChecks;
const
  cSizes: array[0..3] of Integer = (0, 1, 4096, 1048576);
var
  lData: TBytes;
  lSize, lIndex: Integer;
begin
  Check(SizeOf(TBZStreamRec) = 80, '64-bit bz_stream must use C record alignment');
  for lSize in cSizes do
  begin
    SetLength(lData, lSize);
    for lIndex := 0 to lSize - 1 do
      lData[lIndex] := (lIndex * 37 xor (lIndex shr 8)) and $FF;
    CheckBuffer(lData);
    CheckStream(lData);
    WriteLn('PASS buffer and stream round-trip: ', lSize, ' bytes');
  end;
  CheckLoadedLibrary;
  WriteLn('PASS Abbrevia bzip2: 8 round-trips through the generated bzip2 library');
end;

begin
  try
    RunChecks;
  except
    on E: Exception do
    begin
      WriteLn(StdErr, E.Message);
      ExitCode := 1;
    end;
  end;
end.
