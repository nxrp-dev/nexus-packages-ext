// Copyright (c) 2026 Kevin Collins.
// SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
unit tsAbZipFileNameTests;

{$mode delphi}{$H+}

interface
uses obNXTestRegistry;
procedure RegisterAbZipFileNameTests(ARegistry: TNXTestRegistry);

implementation
uses Classes, SysUtils, obNXTestContext, obNXTestSuite,
  Abbrevia.Zip, Abbrevia.Utilities;

const
  cLegacyName: UnicodeString = 'caf'#$00E9#$20AC'.txt';
  cUnicodeName: UnicodeString = 'renamed-'#$017D'.txt';

function LegacyNameBytes: TBytes;
const
  cBytes: array[0..8] of Byte = ($63, $61, $66, $E9, $80, $2E, $74, $78, $74);
begin
  SetLength(Result, SizeOf(cBytes));
  Move(cBytes, Result[0], SizeOf(cBytes));
end;

// Construct the wire header explicitly so the test cannot accidentally encode
// the legacy filename using the host's current codepage when writing the input.
procedure WriteHeader(AStream: TStream; ALocal: Boolean;
  const AName, AExtra: TBytes; AFlags: Word);
var
  lHeader: array[0..45] of Byte;
  lSignature: UInt32;
  lSize, lFlagsOffset, lNameOffset: Integer;
  lLength: Word;
begin
  FillChar(lHeader, SizeOf(lHeader), 0);
  if ALocal then
  begin
    lSignature := $04034B50;
    lSize := 30;
    lFlagsOffset := 6;
    lNameOffset := 26;
    lHeader[4] := 20;
  end
  else
  begin
    lSignature := $02014B50;
    lSize := 46;
    lFlagsOffset := 8;
    lNameOffset := 28;
    lHeader[4] := 20;
    lHeader[5] := 11; // Windows NT origin, as in localetests.zip.
    lHeader[6] := 20;
  end;
  Move(lSignature, lHeader[0], SizeOf(lSignature));
  Move(AFlags, lHeader[lFlagsOffset], SizeOf(AFlags));
  lLength := Length(AName);
  Move(lLength, lHeader[lNameOffset], SizeOf(lLength));
  lLength := Length(AExtra);
  Move(lLength, lHeader[lNameOffset + 2], SizeOf(lLength));
  AStream.WriteBuffer(lHeader, lSize);
  if Length(AName) <> 0 then AStream.WriteBuffer(AName[0], Length(AName));
  if Length(AExtra) <> 0 then AStream.WriteBuffer(AExtra[0], Length(AExtra));
  AStream.Position := 0;
end;

procedure TestHeaderEncodings(AContext: TNXTestContext);
var
  lStream: TMemoryStream;
  lLocal: TAbZipLocalFileHeader;
  lDirectory: TAbZipDirectoryFileHeader;
  lItem: TAbZipItem;

  procedure CheckName(const ABytes: TBytes; AFlags: Word;
    const AExpected: UnicodeString);
  begin
    lStream.Clear;
    WriteHeader(lStream, True, ABytes, nil, AFlags);
    lLocal.LoadFromStream(lStream);
    AContext.AssertEquals(string(AExpected), lLocal.FileName, 'Local filename');
    lStream.Clear;
    WriteHeader(lStream, False, ABytes, nil, AFlags);
    lDirectory.LoadFromStream(lStream);
    AContext.AssertEquals(string(AExpected), lDirectory.FileName, 'Directory filename');
    lStream.Position := 0;
    lItem.LoadFromStream(lStream);
    AContext.AssertEquals(string(AExpected), lItem.FileName, 'Public item filename');
  end;

begin
  lStream := TMemoryStream.Create;
  lLocal := TAbZipLocalFileHeader.Create;
  lDirectory := TAbZipDirectoryFileHeader.Create;
  lItem := TAbZipItem.Create;
  try
    CheckName(TEncoding.ASCII.GetBytes('plain.txt'), 0, 'plain.txt');
    CheckName(LegacyNameBytes, 0, cLegacyName);
    CheckName(TEncoding.UTF8.GetBytes(cLegacyName), $0800, cLegacyName);
    CheckName(TEncoding.UTF8.GetBytes(cLegacyName), 0, cLegacyName);
  finally
    lItem.Free;
    lDirectory.Free;
    lLocal.Free;
    lStream.Free;
  end;
end;

procedure TestUnicodePathCRC(AContext: TNXTestContext);
var
  lStream: TMemoryStream;
  lItem: TAbZipItem;
  lRawName, lUnicodeBytes, lExtra: TBytes;
  lCRC: Integer;
  lLength: Word;
begin
  lRawName := LegacyNameBytes;
  lUnicodeBytes := TEncoding.UTF8.GetBytes(cUnicodeName);
  SetLength(lExtra, 9 + Length(lUnicodeBytes));
  lExtra[0] := $75;
  lExtra[1] := $70;
  lLength := 5 + Length(lUnicodeBytes);
  Move(lLength, lExtra[2], SizeOf(lLength));
  lExtra[4] := 1;
  lCRC := AbCRC32Of(lRawName);
  Move(lCRC, lExtra[5], SizeOf(lCRC));
  Move(lUnicodeBytes[0], lExtra[9], Length(lUnicodeBytes));
  lStream := TMemoryStream.Create;
  lItem := TAbZipItem.Create;
  try
    WriteHeader(lStream, False, lRawName, lExtra, 0);
    lItem.LoadFromStream(lStream);
    AContext.AssertEquals(string(cUnicodeName), lItem.FileName,
      'Valid Unicode path CRC covers original CP1252 bytes');
    lExtra[5] := lExtra[5] xor 1;
    lStream.Clear;
    WriteHeader(lStream, False, lRawName, lExtra, 0);
    lItem.LoadFromStream(lStream);
    AContext.AssertEquals(string(cLegacyName), lItem.FileName,
      'Invalid Unicode path CRC falls back to the header filename');
  finally
    lItem.Free;
    lStream.Free;
  end;
end;

procedure RegisterAbZipFileNameTests(ARegistry: TNXTestRegistry);
var
  lSuite: TNXTestSuite;
begin
  lSuite := ARegistry.AddSuite('Abbrevia.ZipFileNames');
  lSuite.AddTest('HeaderEncodings', TestHeaderEncodings);
  lSuite.AddTest('UnicodePathCRC', TestUnicodePathCRC);
end;

end.
