// Copyright (c) 2026 Kevin Collins.
// SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
unit tsAbLZMAStreamTests;

{$mode delphi}{$H+}

interface
uses obNXTestRegistry;
procedure RegisterAbLZMAStreamTests(ARegistry: TNXTestRegistry);

implementation
uses Classes, SysUtils, obNXTestContext, obNXTestSuite,
  Abbrevia.LZMA, Abbrevia.LZMAStream;

type
  TFaultMode = (fmNone, fmShortPayload, fmRaisePayload, fmFinalHeader, fmInitialHeader);
  TFaultStream = class(TMemoryStream)
  private
    FMode: TFaultMode;
    FHeaderWritten: Boolean;
    FFailureCount: Integer;
  public
    constructor Create(AMode: TFaultMode);
    property FailureCount: Integer read FFailureCount;
    function Write(const ABuffer; ACount: Longint): Longint; override;
  end;
  EOriginalFailure = class(Exception);

constructor TFaultStream.Create(AMode: TFaultMode);
begin
  inherited Create;
  FMode := AMode;
end;

function TFaultStream.Write(const ABuffer; ACount: Longint): Longint;
begin
  if (FMode = fmInitialHeader) or
    ((FMode = fmFinalHeader) and (Position = 5) and FHeaderWritten) or
    ((FMode = fmRaisePayload) and (Position >= 13)) then
  begin
    Inc(FFailureCount);
    raise EWriteError.Create('Injected output failure');
  end;
  if (FMode = fmShortPayload) and (Position >= 13) then
    Exit(inherited Write(ABuffer, ACount - 1));
  if Position = 5 then FHeaderWritten := True;
  Result := inherited Write(ABuffer, ACount);
end;

function MakeData(ASize: Integer): TBytes;
var
  lIndex: Integer;
  lState: UInt32;
begin
  SetLength(Result, ASize);
  lState := $1A2B3C4D;
  for lIndex := 0 to ASize - 1 do
  begin
    lState := lState xor (lState shl 13);
    lState := lState xor (lState shr 17);
    lState := lState xor (lState shl 5);
    Result[lIndex] := Byte(lState shr 24);
  end;
end;

procedure CheckDecoded(AContext: TNXTestContext; ASource: TStream;
  const AExpected: TBytes; AChunkSize: Integer);
var
  lDecoder: TAbLZMADecompressionStream;
  lActual: TBytes;
  lOffset, lCount: Integer;
  lByte: Byte;
begin
  SetLength(lActual, Length(AExpected));
  lDecoder := TAbLZMADecompressionStream.Create(ASource);
  try
    AContext.AssertEquals(IntToStr(Length(AExpected)), IntToStr(lDecoder.Size), 'Header size');
    lOffset := 0;
    while lOffset < Length(lActual) do
    begin
      lCount := Length(lActual) - lOffset;
      if lCount > AChunkSize then lCount := AChunkSize;
      AContext.AssertEquals(lCount, lDecoder.Read(lActual[lOffset], lCount), 'Decoded byte count');
      Inc(lOffset, lCount);
    end;
    AContext.AssertEquals(0, lDecoder.Read(lByte, 1), 'EOF');
    AContext.AssertEquals(IntToStr(lOffset), IntToStr(lDecoder.BytesRead), 'Read position');
    if Length(lActual) <> 0 then
      AContext.AssertTrue(CompareMem(@AExpected[0], @lActual[0], Length(lActual)), 'Decoded contents');
  finally
    lDecoder.Free;
  end;
end;

procedure TestCompletion(AContext: TNXTestContext);
var
  lOutput: TMemoryStream;
  lCompressor: TAbLZMACompressionStream;
  lData: TBytes;
  lPrefix: UInt32;
  lEnd: Int64;
  lRejected: Boolean;
begin
  lData := MakeData(98307);
  lOutput := TMemoryStream.Create;
  try
    lPrefix := $12345678;
    lOutput.WriteBuffer(lPrefix, SizeOf(lPrefix));
    lCompressor := TAbLZMACompressionStream.Create(lOutput);
    try
      AContext.AssertTrue(lCompressor.IsBusy, 'Encoder waits for producer input');
      lCompressor.WriteBuffer(lData[0], Length(lData));
      lCompressor.NoMoreDataToCompress;
      lCompressor.NoMoreDataToCompress;
      AContext.AssertEquals(SZ_OK, lCompressor.WaitForCompressionToFinish, 'Completion');
      AContext.AssertFalse(lCompressor.IsBusy, 'Worker joined');
      lEnd := lOutput.Position;
      AContext.AssertEquals(SZ_OK, lCompressor.WaitForCompressionToFinish, 'Repeated completion');
      AContext.AssertEquals(IntToStr(lEnd), IntToStr(lOutput.Position), 'Output position retained');
      lRejected := False;
      try lCompressor.WriteBuffer(lPrefix, 1);
      except on EAbLZMAException do lRejected := True; end;
      AContext.AssertTrue(lRejected, 'Write after completion rejected');
      lOutput.Position := SizeOf(lPrefix);
      CheckDecoded(AContext, lOutput, lData, 997);
      AContext.AssertEquals(IntToStr(lEnd), IntToStr(lOutput.Position), 'Trailing bytes restored');
      lOutput.Position := 0;
      lOutput.ReadBuffer(lPrefix, SizeOf(lPrefix));
      AContext.AssertTrue(lPrefix = $12345678, 'Prefix retained');
    finally
      lCompressor.Free;
    end;
  finally
    lOutput.Free;
  end;
end;

procedure TestChunkedInput(AContext: TNXTestContext);
var
  lOutput: TMemoryStream;
  lCompressor: TAbLZMACompressionStream;
  lData: TBytes;
  lOffset, lCount: Integer;
begin
  lData := MakeData(3 * 1024 * 1024 + 97);
  lOutput := TMemoryStream.Create;
  try
    lCompressor := TAbLZMACompressionStream.Create(lOutput);
    try
      lOffset := 0;
      while lOffset < Length(lData) do
      begin
        if lOffset < 257 then lCount := 1 else lCount := 32771;
        if lCount > Length(lData) - lOffset then lCount := Length(lData) - lOffset;
        lCompressor.WriteBuffer(lData[lOffset], lCount);
        Inc(lOffset, lCount);
      end;
      AContext.AssertEquals(IntToStr(Length(lData)), IntToStr(lCompressor.Position), 'Input position');
      AContext.AssertEquals(SZ_OK, lCompressor.WaitForCompressionToFinish);
    finally
      lCompressor.Free;
    end;
    lOutput.Position := 0;
    CheckDecoded(AContext, lOutput, lData, 65539);
  finally
    lOutput.Free;
  end;
end;

procedure TestLargeWrite(AContext: TNXTestContext);
var
  lOutput: TMemoryStream;
  lCompressor: TAbLZMACompressionStream;
  lData: TBytes;
begin
  lData := MakeData(5 * 1024 * 1024 + 13);
  lOutput := TMemoryStream.Create;
  try
    lCompressor := TAbLZMACompressionStream.Create(lOutput);
    try
      AContext.AssertEquals(Length(lData), lCompressor.Write(lData[0], Length(lData)), 'Write larger than bounded queue');
    finally
      lCompressor.Free;
    end;
    lOutput.Position := 0;
    CheckDecoded(AContext, lOutput, lData, 65536);
  finally
    lOutput.Free;
  end;
end;

procedure TestEmptyInput(AContext: TNXTestContext);
var
  lOutput: TMemoryStream;
  lCompressor: TAbLZMACompressionStream;
begin
  lOutput := TMemoryStream.Create;
  try
    lCompressor := TAbLZMACompressionStream.Create(lOutput);
    lCompressor.Free;
    lOutput.Position := 0;
    CheckDecoded(AContext, lOutput, nil, 1);
  finally
    lOutput.Free;
  end;
end;

procedure CheckFailure(AContext: TNXTestContext; AMode: TFaultMode;
  AImplicit, ALarge: Boolean);
var
  lOutput: TFaultStream;
  lCompressor: TAbLZMACompressionStream;
  lData: TBytes;
  lRaised: Boolean;
begin
  if ALarge then lData := MakeData(5 * 1024 * 1024) else lData := MakeData(4096);
  lOutput := TFaultStream.Create(AMode);
  try
    lCompressor := TAbLZMACompressionStream.Create(lOutput);
    try
      lRaised := False;
      try lCompressor.WriteBuffer(lData[0], Length(lData));
      except on EAbLZMAException do lRaised := True; end;
      if ALarge then
        AContext.AssertTrue(lRaised, 'Encoder failure wakes blocked writer')
      else
        AContext.AssertFalse(lRaised, 'Small input accepted before completion');
      if AImplicit then
      begin
        FreeAndNil(lCompressor);
        AContext.AssertEquals(1, lOutput.FailureCount,
          'Destruction joins failed output without raising from cleanup');
      end
      else
      begin
        AContext.AssertEquals(SZ_ERROR_WRITE, lCompressor.WaitForCompressionToFinish, 'Output error');
        AContext.AssertEquals(SZ_ERROR_WRITE, lCompressor.ErrorCode, 'Latched error');
        AContext.AssertFalse(lCompressor.IsBusy, 'Failed worker joined');
        AContext.AssertEquals(SZ_ERROR_WRITE, lCompressor.WaitForCompressionToFinish, 'Repeated failed completion');
      end;
    finally
      lCompressor.Free;
    end;
  finally
    lOutput.Free;
  end;
end;

procedure TestShortWrite(AContext: TNXTestContext);
begin CheckFailure(AContext, fmShortPayload, False, False); end;
procedure TestOutputException(AContext: TNXTestContext);
begin CheckFailure(AContext, fmRaisePayload, False, False); end;
procedure TestDestructorCleanup(AContext: TNXTestContext);
begin CheckFailure(AContext, fmRaisePayload, True, False); end;
procedure TestHeaderFailure(AContext: TNXTestContext);
begin CheckFailure(AContext, fmFinalHeader, False, False); end;
procedure TestBlockedWriterFailure(AContext: TNXTestContext);
begin CheckFailure(AContext, fmRaisePayload, False, True); end;

procedure TestConstructorFailure(AContext: TNXTestContext);
var
  lOutput: TFaultStream;
  lRaised: Boolean;
begin
  lRaised := False;
  try TAbLZMACompressionStream.Create(nil).Free;
  except on EAbLZMAException do lRaised := True; end;
  AContext.AssertTrue(lRaised, 'Nil output rejected');
  lOutput := TFaultStream.Create(fmInitialHeader);
  try
    lRaised := False;
    try TAbLZMACompressionStream.Create(lOutput).Free;
    except on EWriteError do lRaised := True; end;
    AContext.AssertTrue(lRaised, 'Constructor preserves header write exception');
  finally
    lOutput.Free;
  end;
end;

procedure TestExceptionUnwind(AContext: TNXTestContext);
var
  lOutput: TFaultStream;
  lCompressor: TAbLZMACompressionStream;
  lData: TBytes;
  lOriginal: Boolean;
begin
  lData := MakeData(4096);
  lOutput := TFaultStream.Create(fmRaisePayload);
  try
    lOriginal := False;
    try
      lCompressor := TAbLZMACompressionStream.Create(lOutput);
      try
        lCompressor.WriteBuffer(lData[0], Length(lData));
        raise EOriginalFailure.Create('Original caller exception');
      finally
        lCompressor.Free;
      end;
    except on EOriginalFailure do lOriginal := True; end;
    AContext.AssertTrue(lOriginal, 'Cleanup preserves the caller exception');
  finally
    lOutput.Free;
  end;
end;

procedure TestTruncatedInput(AContext: TNXTestContext);
var
  lOutput: TMemoryStream;
  lCompressor: TAbLZMACompressionStream;
  lDecoder: TAbLZMADecompressionStream;
  lData: TBytes;
  lRaised: Boolean;
begin
  lData := MakeData(16384);
  lOutput := TMemoryStream.Create;
  try
    lCompressor := TAbLZMACompressionStream.Create(lOutput);
    try lCompressor.WriteBuffer(lData[0], Length(lData));
    finally lCompressor.Free; end;
    lOutput.Size := lOutput.Size - 10;
    lOutput.Position := 0;
    lDecoder := TAbLZMADecompressionStream.Create(lOutput);
    try
      lRaised := False;
      try lDecoder.ReadBuffer(lData[0], Length(lData));
      except on Exception do lRaised := True; end;
      AContext.AssertTrue(lRaised, 'Truncated payload rejected');
    finally
      lDecoder.Free;
    end;
  finally
    lOutput.Free;
  end;
end;

procedure RegisterAbLZMAStreamTests(ARegistry: TNXTestRegistry);
var
  lSuite: TNXTestSuite;
begin
  lSuite := ARegistry.AddSuite('Abbrevia.LZMAStreams');
  lSuite.AddTest('Completion', TestCompletion);
  lSuite.AddTest('ChunkedInput', TestChunkedInput);
  lSuite.AddTest('LargeWrite', TestLargeWrite);
  lSuite.AddTest('EmptyInput', TestEmptyInput);
  lSuite.AddTest('ShortWrite', TestShortWrite);
  lSuite.AddTest('OutputException', TestOutputException);
  lSuite.AddTest('DestructorCleanup', TestDestructorCleanup);
  lSuite.AddTest('HeaderFailure', TestHeaderFailure);
  lSuite.AddTest('BlockedWriterFailure', TestBlockedWriterFailure);
  lSuite.AddTest('ConstructorFailure', TestConstructorFailure);
  lSuite.AddTest('ExceptionUnwind', TestExceptionUnwind);
  lSuite.AddTest('TruncatedInput', TestTruncatedInput);
end;
end.
