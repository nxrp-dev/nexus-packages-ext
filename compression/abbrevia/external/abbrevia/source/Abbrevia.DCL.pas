{ Pascal adaptation of blast 1.3 (zlib 1.3.1 contrib/blast/blast.c).
  Original algorithm and tables: Copyright (C) 2003, 2012, 2013 Mark Adler.
  Altered version: Pascal stream decoder for Nexus, 2026-10-13.
  SPDX-License-Identifier: Zlib

  This software is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

  Mark Adler madler@alumni.caltech.edu
}
unit Abbrevia.DCL;

{$I AbDefine.inc}

interface

uses Classes;

// PKWARE DCL Implode (ZIP method 10), distinct from ZIP method 6.
// Streams remain owned by the caller. ASource must be limited to the member.
procedure AbDecompressDCL(ASource, ADestination: TStream; AExpectedSize: Int64);

implementation

uses Abbrevia.DeflateBase;

type
  TAbDCLHuffman = record
    Counts: array[0..13] of Integer;
    Symbols: array[0..255] of Integer;
  end;

  TAbDCLDecoder = class
  private
    FSource, FDestination: TStream;
    FBits: Cardinal;
    FBitCount: Integer;
    FWindow: array[0..4095] of Byte;
    FNext: Integer;
    FProduced, FExpectedSize: Int64;
    function ReadBits(ACount: Integer): Integer;
    function Decode(const ATable: TAbDCLHuffman): Integer;
    procedure Emit(AValue: Byte);
  public
    procedure Execute(ASource, ADestination: TStream; AExpectedSize: Int64);
  end;

procedure BuildTable(out ATable: TAbDCLHuffman; const ARepeats: array of Byte);
var
  lLengths: array[0..255] of Integer;
  lOffsets: array[0..13] of Integer;
  lIndex, lRepeat, lCount, lLength: Integer;
begin
  FillChar(ATable, SizeOf(ATable), 0);
  lCount := 0;
  for lIndex := 0 to High(ARepeats) do
    for lRepeat := 0 to ARepeats[lIndex] shr 4 do
    begin
      lLength := ARepeats[lIndex] and 15;
      lLengths[lCount] := lLength;
      Inc(lCount);
      Inc(ATable.Counts[lLength]);
    end;
  lOffsets[1] := 0;
  for lLength := 1 to 12 do
    lOffsets[lLength + 1] := lOffsets[lLength] + ATable.Counts[lLength];
  for lIndex := 0 to lCount - 1 do
    if lLengths[lIndex] <> 0 then
    begin
      lLength := lLengths[lIndex];
      ATable.Symbols[lOffsets[lLength]] := lIndex;
      Inc(lOffsets[lLength]);
    end;
end;

function TAbDCLDecoder.ReadBits(ACount: Integer): Integer;
var
  lByte: Byte;
begin
  while FBitCount < ACount do
  begin
    if FSource.Read(lByte, 1) <> 1 then
      raise EAbInflateError.Create('Truncated DCL Implode data');
    FBits := FBits or (Cardinal(lByte) shl FBitCount);
    Inc(FBitCount, 8);
  end;
  Result := FBits and ((1 shl ACount) - 1);
  FBits := FBits shr ACount;
  Dec(FBitCount, ACount);
end;

function TAbDCLDecoder.Decode(const ATable: TAbDCLHuffman): Integer;
var
  lCode, lFirst, lIndex, lLength, lCount: Integer;
begin
  lCode := 0;
  lFirst := 0;
  lIndex := 0;
  for lLength := 1 to 13 do
  begin
    lCode := lCode or (ReadBits(1) xor 1);
    lCount := ATable.Counts[lLength];
    if lCode < lFirst + lCount then
      Exit(ATable.Symbols[lIndex + lCode - lFirst]);
    Inc(lIndex, lCount);
    lFirst := (lFirst + lCount) shl 1;
    lCode := lCode shl 1;
  end;
  raise EAbInflateError.Create('Invalid DCL Implode Huffman code');
end;

procedure TAbDCLDecoder.Emit(AValue: Byte);
begin
  if FProduced >= FExpectedSize then
    raise EAbInflateError.Create('DCL Implode output exceeds declared size');
  FWindow[FNext] := AValue;
  Inc(FNext);
  Inc(FProduced);
  if FNext = Length(FWindow) then
  begin
    FDestination.WriteBuffer(FWindow, Length(FWindow));
    FNext := 0;
  end;
end;

procedure TAbDCLDecoder.Execute(ASource, ADestination: TStream; AExpectedSize: Int64);
const
  cLiteralLengths: array[0..97] of Byte = (
    11,124,8,7,28,7,188,13,76,4,10,8,12,10,12,10,8,23,8,
    9,7,6,7,8,7,6,55,8,23,24,12,11,7,9,11,12,6,7,22,5,
    7,24,6,11,9,6,7,22,7,11,38,7,9,8,25,11,8,11,9,12,
    8,12,5,38,5,38,5,11,7,5,6,21,6,10,53,8,7,24,10,27,
    44,253,253,253,252,252,252,13,12,45,12,45,12,61,12,45,
    44,173);
  cLengthLengths: array[0..5] of Byte = (2,35,36,53,38,23);
  cDistanceLengths: array[0..6] of Byte = (2,20,53,230,247,151,248);
  cBase: array[0..15] of Integer = (3,2,4,5,6,7,8,9,10,12,16,24,40,72,136,264);
  cExtra: array[0..15] of Integer = (0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8);
var
  lLiterals, lLengths, lDistances: TAbDCLHuffman;
  lCoded, lDictionary, lSymbol, lLength, lBits, lDistance: Integer;
begin
  FSource := ASource;
  FDestination := ADestination;
  FExpectedSize := AExpectedSize;
  lCoded := ReadBits(8);
  lDictionary := ReadBits(8);
  if (lCoded > 1) or (lDictionary < 4) or (lDictionary > 6) then
    raise EAbInflateError.Create('Invalid DCL Implode header');
  BuildTable(lLiterals, cLiteralLengths);
  BuildTable(lLengths, cLengthLengths);
  BuildTable(lDistances, cDistanceLengths);
  while True do
    if ReadBits(1) = 0 then
    begin
      if lCoded <> 0 then
        lSymbol := Decode(lLiterals)
      else
        lSymbol := ReadBits(8);
      Emit(Byte(lSymbol));
    end
    else
    begin
      lSymbol := Decode(lLengths);
      lLength := cBase[lSymbol] + ReadBits(cExtra[lSymbol]);
      if lLength = 519 then
        Break;
      if lLength = 2 then lBits := 2 else lBits := lDictionary;
      lDistance := (Decode(lDistances) shl lBits) + ReadBits(lBits) + 1;
      if lDistance > FProduced then
        raise EAbInflateError.Create('Invalid DCL Implode distance');
      while lLength > 0 do
      begin
        Emit(FWindow[(FNext - lDistance) and 4095]);
        Dec(lLength);
      end;
    end;
  if FProduced <> FExpectedSize then
    raise EAbInflateError.Create('DCL Implode output does not match declared size');
  if FNext <> 0 then
    FDestination.WriteBuffer(FWindow, FNext);
end;

procedure AbDecompressDCL(ASource, ADestination: TStream; AExpectedSize: Int64);
var
  lDecoder: TAbDCLDecoder;
begin
  lDecoder := TAbDCLDecoder.Create;
  try
    lDecoder.Execute(ASource, ADestination, AExpectedSize);
  finally
    lDecoder.Free;
  end;
end;

end.
