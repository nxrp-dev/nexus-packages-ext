// Copyright (c) 2026 Kevin Collins.
// SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
unit tsAbDecompressionTests;

{$mode delphi}{$H+}

interface
uses obNXTestRegistry;
procedure RegisterAbDecompressionTests(ARegistry: TNXTestRegistry);

implementation
uses Classes, SysUtils, obNXTestContext, obNXTestSuite,
  Abbrevia.DCL, Abbrevia.DeflateBase, Abbrevia.GZip, Abbrevia.BitBucket,
  Abbrevia.Exceptions;

const
  // Mark Adler's blast reference vector: test.pk -> test.txt.
  cDCL: array[0..7] of Byte = ($00, $04, $82, $24, $25, $8F, $80, $7F);
  cPlain: AnsiString = 'AIAIAIAIAIAIA';

procedure TestDCLReference(AContext: TNXTestContext);
var
  lSource, lOutput: TMemoryStream;
begin
  lSource := TMemoryStream.Create;
  lOutput := TMemoryStream.Create;
  try
    lSource.WriteBuffer(cDCL, SizeOf(cDCL));
    lSource.Position := 0;
    AbDecompressDCL(lSource, lOutput, Length(cPlain));
    AContext.AssertEquals(Length(cPlain), lOutput.Size, 'Reference vector size');
    AContext.AssertTrue(CompareMem(lOutput.Memory, @cPlain[1], Length(cPlain)),
      'Reference vector contents, including overlapping match');
  finally
    lOutput.Free;
    lSource.Free;
  end;
end;

procedure TestDCLCodedLiterals(AContext: TNXTestContext);
const
  // All 256 literal symbols followed by the end marker. Independently decoded
  // byte-for-byte by upstream blast 1.3, for each dictionary header (4, 5, 6).
  cEncoded =
    '01042009FC811FF0053EC01B78014FE0019718B8033722E00A5C803370028EC001D8033B600B6C80' +
    '35B002248125B000E6C00C987A50C20126A000C620874D48000B6C7C291E4C5C090E3616260C0C74' +
    'E8D0801148A08105E2C0508C2A12BA2850A108400C4C3E328F8B04A21C360B110CC8A08306229040' +
    '1854600011E83B4C06DDA6512916082198644327814C531519023C787020054110007A4017E80012' +
    '8038200688022280302004080202003FC007F0023C0037C00570021C003BC006B0022C0033C00430' +
    '020C003D4007D00234003540055002140039400690022400314004100204003E8007E00238003680' +
    '0560026DA00534810650076A4015A80065A0041481029007724016C8006920052481041007624014' +
    '8800612004048100E0077C8017F0006EC00538010760076C8015B00066C004180103A007748016D0' +
    '0018801A4007D000544005A000C80012A004100104001E800314002C000340037240064801280012' +
    '8000C001300014000180012000100008F807';
var
  lSource, lOutput: TMemoryStream;
  lIndex, lDictionary: Integer;
  lByte: Byte;
begin
  lSource := TMemoryStream.Create;
  lOutput := TMemoryStream.Create;
  try
    for lIndex := 0 to Length(cEncoded) div 2 - 1 do
    begin
      lByte := StrToInt('$' + Copy(cEncoded, lIndex * 2 + 1, 2));
      lSource.WriteBuffer(lByte, 1);
    end;
    for lDictionary := 4 to 6 do
    begin
      PByte(lSource.Memory)[1] := lDictionary;
      lSource.Position := 0;
      lOutput.Clear;
      AbDecompressDCL(lSource, lOutput, 256);
      AContext.AssertEquals(256, lOutput.Size, 'Coded-literal output size');
      for lIndex := 0 to 255 do
        AContext.AssertEquals(lIndex, PByte(lOutput.Memory)[lIndex],
          'Coded literal ' + IntToStr(lIndex));
    end;
  finally
    lOutput.Free;
    lSource.Free;
  end;
end;
procedure TestDCLInvalid(AContext: TNXTestContext);
const
  cInvalidDistance: array[0..3] of Byte = (0, 4, 31, 0);
var
  lSource, lOutput: TMemoryStream;
  lLength: Integer;
  lRejected: Boolean;

  procedure ExpectRejection(AExpectedSize: Int64; const ADescription: string);
  begin
    lSource.Position := 0;
    lOutput.Clear;
    lRejected := False;
    try
      AbDecompressDCL(lSource, lOutput, AExpectedSize);
    except
      on EAbInflateError do lRejected := True;
    end;
    AContext.AssertTrue(lRejected, ADescription);
  end;

begin
  lSource := TMemoryStream.Create;
  lOutput := TMemoryStream.Create;
  try
    for lLength := 0 to SizeOf(cDCL) - 1 do
    begin
      lSource.Clear;
      if lLength <> 0 then lSource.WriteBuffer(cDCL, lLength);
      ExpectRejection(Length(cPlain), 'Truncated prefix ' + IntToStr(lLength));
    end;
    lSource.Clear;
    lSource.WriteBuffer(cDCL, SizeOf(cDCL));
    ExpectRejection(Length(cPlain) - 1, 'Declared size too short');
    ExpectRejection(Length(cPlain) + 1, 'Declared size too long');
    PByte(lSource.Memory)[0] := 2;
    ExpectRejection(Length(cPlain), 'Invalid literal mode');
    PByte(lSource.Memory)[0] := 0;
    PByte(lSource.Memory)[1] := 3;
    ExpectRejection(Length(cPlain), 'Invalid dictionary size');
    lSource.Clear;
    lSource.WriteBuffer(cInvalidDistance, SizeOf(cInvalidDistance));
    ExpectRejection(3, 'Match before any bytes have been decoded');
  finally
    lOutput.Free;
    lSource.Free;
  end;
end;

procedure AddGzipMember(AStream: TStream; const APayload: AnsiString);
var
  lInput: TMemoryStream;
  lHelper: TAbGzipStreamHelper;
begin
  lInput := TMemoryStream.Create;
  lHelper := TAbGzipStreamHelper.Create(AStream);
  try
    if Length(APayload) <> 0 then
      lInput.WriteBuffer(APayload[1], Length(APayload));
    lInput.Position := 0;
    lHelper.WriteArchiveHeader;
    lHelper.WriteArchiveItem(lInput);
    lHelper.WriteArchiveTail;
  finally
    lHelper.Free;
    lInput.Free;
  end;
end;

procedure TestGzipConcatenated(AContext: TNXTestContext);
const
  cFirst: AnsiString = 'First member'#0#$80;
  cSecond: AnsiString = 'Second member'#$FF;
  cPrefix: AnsiString = 'existing output:';
var
  lSource, lOutput: TMemoryStream;
  lHelper: TAbGzipStreamHelper;
  lBucket: TAbBitBucketStream;
  lExpected: AnsiString;
begin
  lSource := TMemoryStream.Create;
  lOutput := TMemoryStream.Create;
  lBucket := TAbBitBucketStream.Create(1024);
  lHelper := TAbGzipStreamHelper.Create(lSource);
  try
    AddGzipMember(lSource, '');
    AddGzipMember(lSource, cFirst);
    AddGzipMember(lSource, '');
    AddGzipMember(lSource, cSecond);
    AddGzipMember(lSource, '');
    lOutput.WriteBuffer(cPrefix[1], Length(cPrefix));
    lHelper.ExtractItemData(lOutput);
    lExpected := cPrefix + cFirst + cSecond;
    AContext.AssertEquals(Length(lExpected), lOutput.Size, 'Concatenated output size');
    AContext.AssertTrue(CompareMem(lOutput.Memory, @lExpected[1], Length(lExpected)),
      'All members appended in order');
    AContext.AssertEquals(Length(cFirst) + Length(cSecond), lHelper.FileSize,
      'Decoded size excludes preexisting destination bytes');
    lHelper.ExtractItemData(lBucket);
    AContext.AssertEquals(Length(cFirst) + Length(cSecond), lHelper.FileSize,
      'Test-only mode counts and validates every member');
  finally
    lHelper.Free;
    lBucket.Free;
    lOutput.Free;
    lSource.Free;
  end;
end;

procedure TestGzipLaterMemberCRC(AContext: TNXTestContext);
var
  lSource: TMemoryStream;
  lBucket: TAbBitBucketStream;
  lHelper: TAbGzipStreamHelper;
  lTrailer, lSecondStart: Integer;
  lRejected: Boolean;
begin
  lSource := TMemoryStream.Create;
  lBucket := TAbBitBucketStream.Create(1024);
  lHelper := TAbGzipStreamHelper.Create(lSource);
  try
    AddGzipMember(lSource, 'first');
    lSecondStart := lSource.Size;
    AddGzipMember(lSource, 'second');
    lTrailer := lSource.Size - 8;
    AddGzipMember(lSource, 'third');
    PByte(lSource.Memory)[lTrailer] := PByte(lSource.Memory)[lTrailer] xor 1;
    lRejected := False;
    try
      lHelper.ExtractItemData(lBucket);
    except
      on EAbGzipBadCRC do lRejected := True;
    end;
    AContext.AssertTrue(lRejected, 'Reject corrupt CRC in middle member');
    PByte(lSource.Memory)[lTrailer] := PByte(lSource.Memory)[lTrailer] xor 1;
    PByte(lSource.Memory)[lTrailer + 4] := PByte(lSource.Memory)[lTrailer + 4] xor 1;
    lRejected := False;
    try
      lHelper.ExtractItemData(lBucket);
    except
      on EAbGzipBadFileSize do lRejected := True;
    end;
    AContext.AssertTrue(lRejected, 'Reject corrupt ISIZE in middle member');
    PByte(lSource.Memory)[lSecondStart] := 0;
    lRejected := False;
    try
      lHelper.ExtractItemData(lBucket);
    except
      on EAbGzipInvalid do lRejected := True;
    end;
    AContext.AssertTrue(lRejected, 'Reject invalid header in middle member');
  finally
    lHelper.Free;
    lBucket.Free;
    lSource.Free;
  end;
end;

procedure TestGzipTruncatedMember(AContext: TNXTestContext);
var
  lSource, lOutput: TMemoryStream;
  lHelper: TAbGzipStreamHelper;
  lSecondStart, lEnd, lSize: Integer;
  lRejected: Boolean;
begin
  lSource := TMemoryStream.Create;
  lOutput := TMemoryStream.Create;
  lHelper := TAbGzipStreamHelper.Create(lSource);
  try
    AddGzipMember(lSource, 'first');
    lSecondStart := lSource.Size;
    AddGzipMember(lSource, 'second');
    lEnd := lSource.Size;
    // Every incomplete later-member header and trailer must be rejected.
    for lSize := lEnd - 1 downto lSecondStart + 1 do
      if (lSize >= lEnd - 8) or (lSize < lSecondStart + 10) then
      begin
        lSource.Size := lSize;
        lOutput.Clear;
        lRejected := False;
        try
          lHelper.ExtractItemData(lOutput);
        except
          on EReadError do lRejected := True;
        end;
        AContext.AssertTrue(lRejected, 'Truncated member at ' + IntToStr(lSize));
      end;
  finally
    lHelper.Free;
    lOutput.Free;
    lSource.Free;
  end;
end;

procedure RegisterAbDecompressionTests(ARegistry: TNXTestRegistry);
var
  lSuite: TNXTestSuite;
begin
  lSuite := ARegistry.AddSuite('Abbrevia.Decompression');
  lSuite.AddTest('DCLReference', TestDCLReference);
  lSuite.AddTest('DCLInvalid', TestDCLInvalid);
  lSuite.AddTest('DCLCodedLiterals', TestDCLCodedLiterals);
  lSuite.AddTest('GzipConcatenated', TestGzipConcatenated);
  lSuite.AddTest('GzipLaterMemberIntegrity', TestGzipLaterMemberCRC);
  lSuite.AddTest('GzipTruncatedMember', TestGzipTruncatedMember);
end;

end.
