(* ***** BEGIN LICENSE BLOCK *****
  * Version: MPL 1.1
  *
  * The contents of this file are subject to the Mozilla Public License Version
  * 1.1 (the "License"); you may not use this file except in compliance with
  * the License. You may obtain a copy of the License at
  * http://www.mozilla.org/MPL/
  *
  * Software distributed under the License is distributed on an "AS IS" basis,
  * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  * for the specific language governing rights and limitations under the
  * License.
  *
  * The Original Code is TurboPower Abbrevia
  *
  * The Initial Developer of the Original Code is Pierre le Riche
  *
  * Portions created by the Initial Developer are Copyright (C) 2011
  * the Initial Developer. All Rights Reserved.
  *
  * Contributor(s):
  * Pierre le Riche <pierre_le_riche@users.sourceforge.net>
  * Craig Peterson <capeterson@users.sourceforge.net>
  *
  * ***** END LICENSE BLOCK *****


Usage:
  Write uncompressed data to TAbLZMACompressionStream, then call
  WaitForCompressionToFinish and check its result. Destruction finishes and joins
  the worker as cleanup, but cannot report successful completion to its caller.
  The caller owns the output stream and must not access or free it until the
  compressor has been joined. All producer operations belong to one caller.
  Write waits when the fixed 1 MiB input buffer is full.

  TAbLZMADecompressionStream reads synchronously from its borrowed input stream.
*)

unit Abbrevia.LZMAStream;

{$I AbDefine.inc}

interface

{$IF DEFINED(MSWINDOWS) OR DEFINED(LINUX)}
uses
  Classes, SysUtils, Abbrevia.LZMA, Abbrevia.Utilities;

const
  CompressedDataBufferSize = 16 * 1024;
  UncompressedDataBufferSize = 32 * 1024;
  MaximumBlockSizeForBufferedIO = 1024;

type
  TAbLZMACompressionStream = class;

  {The SDK encoder blocks asking for future input. This worker lets the producer
   return from Write and supply that input; running it on the producer would
   deadlock. No other thread is owned by this stream or available to do that work.}
  TAbLZMACompressionThread = class(TThread)
  private
    FCompressionStream: TAbLZMACompressionStream;
  protected
    procedure Execute; override;
  public
    constructor Create(ACompressionStream: TAbLZMACompressionStream);
  end;

  TAbLZMACompressionStream = class(TStream)
  private
    FOutputStream: TStream;
    FLock: TRTLCriticalSection;
    FLockInitialized: Boolean;
    FDataAvailable: PEventState;
    FSpaceAvailable: PEventState;
    FInputBuffer: TBytes;
    FReadPosition, FWritePosition, FBufferedCount: Integer;
    FInputComplete, FWorkerFinished: Boolean;
    FWorkerStarted, FHeaderFinalized: Boolean;
    FLZMAEncHandle: CLzmaEncHandle;
    FCompressionThread: TAbLZMACompressionThread;
    FCompressionErrorCode: Integer;
    FOutputStreamHeaderSizeFieldPosition: Int64;
    FTotalBytesWritten: Int64;
    procedure RecordError(AError: Integer);
    procedure CheckError;
    function FinishCompression: Integer;
  protected
    function GetErrorCode: Integer;
  public
    constructor Create(AOutputStream: TStream; ACompressionLevel: Integer = 5;
      ADictionarySize: Integer = 65536);
    destructor Destroy; override;
    function Read(var ABuffer; ACount: Integer): Integer; override;
    function Write(const ABuffer; ACount: Integer): Integer; override;
    function Seek(AOffset: Integer; AOrigin: Word): Integer; override;
    function Seek(const AOffset: Int64; AOrigin: TSeekOrigin): Int64; override;
    {Close input. Further writes are rejected; compression may still be running.}
    procedure NoMoreDataToCompress;
    {Join, finalize the header, and return the error code. Repeated calls are safe.
     Check this result before accepting the output. Destruction does not raise
     compression errors, so it cannot replace an exception already unwinding.}
    function WaitForCompressionToFinish: Integer;
    {Status only: call WaitForCompressionToFinish before accessing the output.}
    function IsBusy: Boolean;
    property ErrorCode: Integer read GetErrorCode;
  end;

  {------------LZMA decompression stream------------}

  TAbLZMADecompressionStream = class(TStream)
  protected
    FSourceStream: TStream;
    {The intermediate buffers for compressed and uncompressed data
     respectively.}
    FCompressedDataBuffer: array[0..CompressedDataBufferSize - 1] of Byte;
    FUncompressedDataBuffer: array[0..UncompressedDataBufferSize - 1] of Byte;
    {Read buffer control: Used to speed up frequent small reads via
     FUncompressedDataBuffer.}
    FReadBufferSize: Integer;
    FReadBufferAvailableBytes: Integer;
    {The current size and position into FCompressedDataBuffer}
    FCompressedDataBufferSize: Integer;
    FCompressedDataBufferPosition: Integer;
    {The uncompressed size according to the header.}
    FUncompressedSize: Int64;
    {The total number of bytes that have been decompressed.}
    FBytesDecompressed: Int64;
    {The LZMA decompression state}
    FLzmaState: CLzmaDec;
    {Decompresses data from the compressed source to the buffer pointed to by
     APBuffer. Returns the number of actual bytes stored (which may be less
     than the requested size if the end of the compressed stream was reached).}
    function InternalDecompressToBuffer(APBuffer: Pointer; ABufferSize: Integer): Integer;
    {---Property getters/setters---}
    function GetBytesRead: Int64;
    function GetSize: Int64; override;
  public
    constructor Create(ASourceStream: TStream);
    destructor Destroy; override;
    function Read(var ABuffer; ACount: Integer): Integer; override;
    {Writing to a decompression stream is not allowed}
    function Write(const ABuffer; ACount: Integer): Integer; override;
    {Will raise an exception if an attempt is made to seek off the current
     position.}
    function Seek(AOffset: Integer; AOrigin: Word): Integer; override;
    function Seek(const AOffset: Int64; AOrigin: TSeekOrigin): Int64; override;
    {---Public properties---}
    {The number of decompressed bytes read from the decompression stream.}
    property BytesRead: Int64 read GetBytesRead;
  end;

{$ENDIF}

implementation

{$IF DEFINED(MSWINDOWS) OR DEFINED(LINUX)}
uses
  Abbrevia.CRuntime;

const
  cInputBufferCapacity = 1024 * 1024;
  cWaitForever = High(Cardinal);
  cEventSignaled = 0; // BasicEventWaitFor result on both supported hosts.

function SzAlloc(AContext: Pointer; ASize: size_t): Pointer; cdecl;
begin
  try
    Result := GetMemory(ASize);
  except
    Result := nil;
  end;
end;

procedure SzFree(AContext, AAddress: Pointer); cdecl;
begin
  FreeMemory(AAddress);
end;

var
  PascalMMInterface: ISzAlloc = (Alloc: SzAlloc; Free: SzFree);

type
  CSeqInStream_Compress = packed record
    Intf: ISeqInStream;
    CompressionStream: TAbLZMACompressionStream;
  end;
  CSeqOutStream_Compress = packed record
    Intf: ISeqOutStream;
    CompressionStream: TAbLZMACompressionStream;
  end;

function ISeqInStream_Compress_Read(AContext: Pointer; var ABuffer;
  var ASize: size_t): SRes; cdecl;
var
  lStream: TAbLZMACompressionStream;
  lCount, lFirst: Integer;
begin
  lStream := CSeqInStream_Compress(AContext^).CompressionStream;
  try
    if ASize = 0 then Exit(SZ_OK);
    while True do
    begin
      EnterCriticalSection(lStream.FLock);
      try
        Result := lStream.FCompressionErrorCode;
        if Result <> SZ_OK then
        begin
          ASize := 0;
          Exit;
        end;
        if lStream.FBufferedCount <> 0 then
        begin
          lCount := lStream.FBufferedCount;
          if ASize < size_t(lCount) then lCount := Integer(ASize);
          lFirst := cInputBufferCapacity - lStream.FReadPosition;
          if lFirst > lCount then lFirst := lCount;
          Move(lStream.FInputBuffer[lStream.FReadPosition], ABuffer, lFirst);
          if lFirst < lCount then
            Move(lStream.FInputBuffer[0], PByte(@ABuffer)[lFirst], lCount - lFirst);
          lStream.FReadPosition := (lStream.FReadPosition + lCount) mod cInputBufferCapacity;
          Dec(lStream.FBufferedCount, lCount);
          ASize := lCount;
          BasicEventSetEvent(lStream.FSpaceAvailable);
          Exit(SZ_OK);
        end;
        if lStream.FInputComplete then
        begin
          ASize := 0;
          Exit(SZ_OK);
        end;
      finally
        LeaveCriticalSection(lStream.FLock);
      end;
      if BasicEventWaitFor(cWaitForever, lStream.FDataAvailable) <> cEventSignaled then
      begin
        lStream.RecordError(SZ_ERROR_THREAD);
        ASize := 0;
        Exit(SZ_ERROR_THREAD);
      end;
    end;
  except
    ASize := 0;
    lStream.RecordError(SZ_ERROR_READ);
    Result := SZ_ERROR_READ;
  end;
end;

function ISeqOutStream_Compress_Write(AContext: Pointer; const ABuffer;
  ASize: size_t): size_t; cdecl;
var
  lStream: TAbLZMACompressionStream;
begin
  lStream := CSeqOutStream_Compress(AContext^).CompressionStream;
  try
    Result := lStream.FOutputStream.Write(ABuffer, ASize);
    if Result <> ASize then lStream.RecordError(SZ_ERROR_WRITE);
  except
    lStream.RecordError(SZ_ERROR_WRITE);
    Result := 0;
  end;
end;

constructor TAbLZMACompressionThread.Create(ACompressionStream: TAbLZMACompressionStream);
begin
  inherited Create(True);
  FCompressionStream := ACompressionStream;
end;

procedure TAbLZMACompressionThread.Execute;
var
  lInput: CSeqInStream_Compress;
  lOutput: CSeqOutStream_Compress;
  lError: Integer;
begin
  lError := SZ_ERROR_FAIL;
  try
    try
      lInput.Intf.Read := ISeqInStream_Compress_Read;
      lInput.CompressionStream := FCompressionStream;
      lOutput.Intf.Write := ISeqOutStream_Compress_Write;
      lOutput.CompressionStream := FCompressionStream;
      lError := LzmaEnc_Encode(FCompressionStream.FLZMAEncHandle,
        @lOutput.Intf, @lInput.Intf, nil, @PascalMMInterface, @PascalMMInterface);
    except
      lError := SZ_ERROR_FAIL;
    end;
  finally
    FCompressionStream.RecordError(lError);
    EnterCriticalSection(FCompressionStream.FLock);
    try
      FCompressionStream.FWorkerFinished := True;
    finally
      LeaveCriticalSection(FCompressionStream.FLock);
    end;
    BasicEventSetEvent(FCompressionStream.FSpaceAvailable);
  end;
end;

constructor TAbLZMACompressionStream.Create(AOutputStream: TStream;
  ACompressionLevel, ADictionarySize: Integer);
var
  lProperties: CLzmaEncProps;
  lPropertyData: TLZMAPropertyData;
  lHeaderSize: size_t;
begin
  inherited Create;
  if AOutputStream = nil then
    raise EAbLZMAException.Create('An output stream is required.');
  FOutputStream := AOutputStream;
  InitCriticalSection(FLock);
  FLockInitialized := True;
  FDataAvailable := BasicEventCreate(nil, False, False, '');
  if FDataAvailable = nil then LzmaCheck(SZ_ERROR_THREAD);
  FSpaceAvailable := BasicEventCreate(nil, False, False, '');
  if FSpaceAvailable = nil then LzmaCheck(SZ_ERROR_THREAD);
  SetLength(FInputBuffer, cInputBufferCapacity);
  FLZMAEncHandle := LzmaEnc_Create(@PascalMMInterface);
  if FLZMAEncHandle = nil then LzmaCheck(SZ_ERROR_MEM);
  LzmaEncProps_Init(lProperties);
  lProperties.level := ACompressionLevel;
  lProperties.dictSize := AbToUInt32(ADictionarySize);
  LzmaCheck(LzmaEnc_SetProps(FLZMAEncHandle, lProperties));
  lHeaderSize := LZMA_PROPS_SIZE;
  LzmaCheck(LzmaEnc_WriteProperties(FLZMAEncHandle, PByte(@lPropertyData), lHeaderSize));
  FOutputStream.WriteBuffer(lPropertyData, lHeaderSize);
  FOutputStreamHeaderSizeFieldPosition := FOutputStream.Position;
  FOutputStream.WriteBuffer(FTotalBytesWritten, SizeOf(FTotalBytesWritten));
  FCompressionThread := TAbLZMACompressionThread.Create(Self);
  FCompressionThread.Start;
  FWorkerStarted := True;
end;

procedure TAbLZMACompressionStream.RecordError(AError: Integer);
begin
  if AError = SZ_OK then Exit;
  EnterCriticalSection(FLock);
  try
    if FCompressionErrorCode = SZ_OK then FCompressionErrorCode := AError;
  finally
    LeaveCriticalSection(FLock);
  end;
  BasicEventSetEvent(FDataAvailable);
  BasicEventSetEvent(FSpaceAvailable);
end;

function TAbLZMACompressionStream.GetErrorCode: Integer;
begin
  EnterCriticalSection(FLock);
  try
    Result := FCompressionErrorCode;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

procedure TAbLZMACompressionStream.CheckError;
begin
  LzmaCheck(GetErrorCode);
end;

procedure TAbLZMACompressionStream.NoMoreDataToCompress;
begin
  EnterCriticalSection(FLock);
  try
    FInputComplete := True;
  finally
    LeaveCriticalSection(FLock);
  end;
  BasicEventSetEvent(FDataAvailable);
end;

function TAbLZMACompressionStream.FinishCompression: Integer;
var
  lPosition: Int64;
begin
  if not FWorkerStarted then Exit(SZ_OK);
  NoMoreDataToCompress;
  if FCompressionThread <> nil then
  begin
    FCompressionThread.WaitFor;
    if FCompressionThread.FatalException <> nil then RecordError(SZ_ERROR_FAIL);
    FreeAndNil(FCompressionThread);
  end;
  if (GetErrorCode = SZ_OK) and not FHeaderFinalized then
  begin
    try
      lPosition := FOutputStream.Position;
      try
        FOutputStream.Position := FOutputStreamHeaderSizeFieldPosition;
        FOutputStream.WriteBuffer(FTotalBytesWritten, SizeOf(FTotalBytesWritten));
      finally
        FOutputStream.Position := lPosition;
      end;
      FHeaderFinalized := True;
    except
      RecordError(SZ_ERROR_WRITE);
    end;
  end;
  Result := GetErrorCode;
end;

function TAbLZMACompressionStream.WaitForCompressionToFinish: Integer;
begin
  Result := FinishCompression;
end;

function TAbLZMACompressionStream.IsBusy: Boolean;
begin
  EnterCriticalSection(FLock);
  try
    Result := FWorkerStarted and not FWorkerFinished;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

destructor TAbLZMACompressionStream.Destroy;
begin
  try
    FinishCompression;
  finally
    FCompressionThread.Free;
    if FLZMAEncHandle <> nil then
      LzmaEnc_Destroy(FLZMAEncHandle, @PascalMMInterface, @PascalMMInterface);
    if FSpaceAvailable <> nil then BasicEventDestroy(FSpaceAvailable);
    if FDataAvailable <> nil then BasicEventDestroy(FDataAvailable);
    if FLockInitialized then DoneCriticalSection(FLock);
    inherited Destroy;
  end;
end;

function TAbLZMACompressionStream.Read(var ABuffer; ACount: Integer): Integer;
begin
  raise EAbLZMAException.Create('The compression stream does not support reading.');
end;

function TAbLZMACompressionStream.Seek(const AOffset: Int64; AOrigin: TSeekOrigin): Int64;
begin
  Result := FTotalBytesWritten;
  if ((AOrigin <> soBeginning) or (AOffset <> Result))
    and ((AOrigin <> soCurrent) or (AOffset <> 0)) then
    raise EAbLZMAException.Create('The compression stream does not support seeking away from the current position.');
end;

function TAbLZMACompressionStream.Seek(AOffset: Integer; AOrigin: Word): Integer;
begin
  Result := AbToInt32(Seek(Int64(AOffset), TSeekOrigin(AOrigin)));
end;

function TAbLZMACompressionStream.Write(const ABuffer; ACount: Integer): Integer;
var
  lCount, lFirst: Integer;
begin
  Result := 0;
  CheckError;
  EnterCriticalSection(FLock);
  try
    if FInputComplete then
      raise EAbLZMAException.Create('Write may not be called after NoMoreDataToCompress.');
  finally
    LeaveCriticalSection(FLock);
  end;
  while ACount > 0 do
  begin
    CheckError;
    EnterCriticalSection(FLock);
    try
      lCount := cInputBufferCapacity - FBufferedCount;
      if lCount > ACount then lCount := ACount;
      if lCount <> 0 then
      begin
        lFirst := cInputBufferCapacity - FWritePosition;
        if lFirst > lCount then lFirst := lCount;
        Move(PByte(@ABuffer)[Result], FInputBuffer[FWritePosition], lFirst);
        if lFirst < lCount then
          Move(PByte(@ABuffer)[Result + lFirst], FInputBuffer[0], lCount - lFirst);
        FWritePosition := (FWritePosition + lCount) mod cInputBufferCapacity;
        Inc(FBufferedCount, lCount);
        Inc(FTotalBytesWritten, lCount);
      end;
    finally
      LeaveCriticalSection(FLock);
    end;
    if lCount <> 0 then
    begin
      Inc(Result, lCount);
      Dec(ACount, lCount);
      BasicEventSetEvent(FDataAvailable);
    end
    else if BasicEventWaitFor(cWaitForever, FSpaceAvailable) <> cEventSignaled then
      RecordError(SZ_ERROR_THREAD);
  end;
  CheckError;
end;

{ TAbLZMADecompressionStream }

constructor TAbLZMADecompressionStream.Create(ASourceStream: TStream);
var
  LLZMAPropData: TLZMAPropertyData;
begin
  inherited Create;

  FSourceStream := ASourceStream;

  {Read the header and uncompressed size from the compressed data stream.}
  FSourceStream.ReadBuffer(LLZMAPropData, LZMA_PROPS_SIZE);
  FSourceStream.ReadBuffer(FUncompressedSize, SizeOf(FUncompressedSize));

  {Initialize the decompressor using the information from the header}
  LzmaDec_Construct(FLzmaState);
  LzmaCheck(LzmaDec_Allocate(FLzmaState, PByte(@LLZMAPropData), LZMA_PROPS_SIZE,
    @PascalMMInterface));
  LzmaDec_Init(FLzmaState);
end;

destructor TAbLZMADecompressionStream.Destroy;
var
  LUnusedBytes: Integer;
begin
  {Release all decompression resources.}
  LzmaDec_Free(FLzmaState, @PascalMMInterface);

  {Any unconsumed bytes in the compressed input buffer should be returned to
   the source stream.}
  LUnusedBytes := FCompressedDataBufferSize - FCompressedDataBufferPosition;
  if LUnusedBytes > 0 then
    FSourceStream.Position := FSourceStream.Position - LUnusedBytes;

  inherited Destroy;
end;

function TAbLZMADecompressionStream.GetBytesRead: Int64;
begin
  Result := FBytesDecompressed - FReadBufferAvailableBytes;
end;

function TAbLZMADecompressionStream.GetSize: Int64;
begin
  Result := FUncompressedSize;
end;

function TAbLZMADecompressionStream.InternalDecompressToBuffer(APBuffer: Pointer;
  ABufferSize: Integer): Integer;
var
  LInputBytesProcessed, LOutputBytesProcessed: size_t;
  LFinishMode: Integer;
  LStatus: ELzmaStatus;
begin
  Result := 0;
  {Any more data to decompress to the output buffer?}
  while ABufferSize > 0 do
  begin
    {Read more compressed data into the compressed data buffer, if required.}
    if FCompressedDataBufferPosition >= FCompressedDataBufferSize then
    begin
      FCompressedDataBufferSize := FSourceStream.Read(FCompressedDataBuffer,
        CompressedDataBufferSize);
      FCompressedDataBufferPosition := 0;
    end;

    {Initialize the "processed byte count" variables to the sizes of the input
     and output buffers.}
    LInputBytesProcessed := FCompressedDataBufferSize - FCompressedDataBufferPosition;
    LOutputBytesProcessed := ABufferSize;
    {We may not read more bytes than the number of uncompressed bytes according
     to the header.}
    if (FUncompressedSize - FBytesDecompressed) <= LOutputBytesProcessed then
    begin
      LOutputBytesProcessed := size_t(FUncompressedSize - FBytesDecompressed);
      LFinishMode := LZMA_FINISH_END;
    end
    else
      LFinishMode := LZMA_FINISH_ANY;

    {Decompress from the input to the output buffer}
    LzmaCheck(LzmaDec_DecodeToBuf(FLzmaState, APBuffer,
      LOutputBytesProcessed, @FCompressedDataBuffer[FCompressedDataBufferPosition],
      LInputBytesProcessed, LFinishMode, LStatus));

    {Update the input and output buffer stats}
    Inc(FCompressedDataBufferPosition, LInputBytesProcessed);
    Inc(PAnsiChar(APBuffer), LOutputBytesProcessed);
    Dec(ABufferSize, LOutputBytesProcessed);

    {Update the number of bytes decompressed}
    Inc(Result, LOutputBytesProcessed);
    Inc(FBytesDecompressed, LOutputBytesProcessed);

    {Was all the data decompressed? If so, break the loop.}
    if FUncompressedSize = FBytesDecompressed then
      Break;

    {Was nothing from the input or output streams processed? If so, then
     something has gone wrong.}
    if (LInputBytesProcessed = 0) and (LOutputBytesProcessed = 0) then
      raise Exception.Create('LZMA decompression data error');

  end;
end;

function TAbLZMADecompressionStream.Read(var ABuffer; ACount: Integer): Integer;
var
  LBytesAlreadyRead: Integer;
begin
  {Anything to read?}
  if ACount > 0 then
  begin
    {Do we have enough data in the read buffer to satisfy the request?}
    if FReadBufferAvailableBytes >= ACount then
    begin
      {Enough data in the buffer: Fill the output buffer.}
      System.Move(PAnsiChar(@FUncompressedDataBuffer)[FReadBufferSize - FReadBufferAvailableBytes],
        ABuffer, ACount);
      {Subtract from the available bytes in the read buffer.}
      Dec(FReadBufferAvailableBytes, ACount);
      {Successfully read the number of bytes requested}
      Result := ACount;
    end
    else
    begin
      {Not enough bytes available in the read buffer: Is there anything
       available in the uncompressed data buffer? If so, then transfer what we
       have.}
      if FReadBufferAvailableBytes > 0 then
      begin
        {There is some data in the buffer: Read everything}
        System.Move(PAnsiChar(@FUncompressedDataBuffer)[FReadBufferSize - FReadBufferAvailableBytes],
          ABuffer, FReadBufferAvailableBytes);
        LBytesAlreadyRead := FReadBufferAvailableBytes;
        FReadBufferAvailableBytes := 0;
      end
      else
        LBytesAlreadyRead := 0;
      {If we get here it means the read buffer has been emptied and some data
       still has to be read: Do we need to fill up the read buffer again, or do
       we read directly into the target buffer? Large reads bypass the read
       buffering mechanism.}
      if ACount <= MaximumBlockSizeForBufferedIO then
      begin
        {Try to fill the read buffer again}
        FReadBufferSize := InternalDecompressToBuffer(@FUncompressedDataBuffer, UncompressedDataBufferSize);
        FReadBufferAvailableBytes := FReadBufferSize;
        {No more data available? If so we're done.}
        if FReadBufferAvailableBytes = 0 then begin
          Result := LBytesAlreadyRead;
          Exit;
        end;
        {Is enough data now available?}
        if FReadBufferAvailableBytes >= (ACount - LBytesAlreadyRead) then
        begin
          {Enough data in the buffer: Fill the output buffer.}
          System.Move(FUncompressedDataBuffer,
            PAnsiChar(@ABuffer)[LBytesAlreadyRead],
            ACount - LBytesAlreadyRead);
          {Subtract from the available bytes in the read buffer and return the
           number of bytes read.}
          Dec(FReadBufferAvailableBytes, ACount - LBytesAlreadyRead);
          {Successfully read the number of bytes requested}
          Result := ACount;
        end
        else
        begin
          {Enough data is still not available (the end of the compressed stream
           has been reached): Read what we can.}
          System.Move(FUncompressedDataBuffer,
            PAnsiChar(@ABuffer)[LBytesAlreadyRead],
            FReadBufferAvailableBytes);
          Inc(LBytesAlreadyRead, FReadBufferAvailableBytes);
          FReadBufferAvailableBytes := 0;
          Result := LBytesAlreadyRead;
        end;
      end
      else
      begin
        {Decompress directly into the output buffer.}
        Result := InternalDecompressToBuffer(
          @PAnsiChar(@ABuffer)[LBytesAlreadyRead],
          ACount - LBytesAlreadyRead) + LBytesAlreadyRead;
      end;
    end;
  end
  else
    Result := 0;
end;

function TAbLZMADecompressionStream.Seek(const AOffset: Int64; AOrigin: TSeekOrigin): Int64;
begin
  Result := GetBytesRead;
  if ((AOrigin <> soBeginning) or (AOffset <> Result))
    and ((AOrigin <> soCurrent) or (AOffset <> 0)) then
  begin
    raise Exception.Create('Decompression streams do not support seeking away '
      + 'from the current position.');
  end;
end;

function TAbLZMADecompressionStream.Seek(AOffset: Integer; AOrigin: Word): Integer;
begin
  Result := AbToInt32(Seek(Int64(AOffset), TSeekOrigin(AOrigin)));
end;

function TAbLZMADecompressionStream.Write(const ABuffer; ACount: Integer): Integer;
begin
  raise Exception.Create('Writing to a LZMA decompression stream is not supported.');
end;

{$ENDIF}

end.
