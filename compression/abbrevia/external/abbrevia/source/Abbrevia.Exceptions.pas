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
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1997-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{* ABBREVIA: Abbrevia.Exceptions.pas                                *}
{*********************************************************}
{* ABBREVIA: Exception classes                           *}
{*********************************************************}

unit Abbrevia.Exceptions;

{$I AbDefine.inc}

interface

uses
  SysUtils,
  Abbrevia.Utilities;

type
  EAbException = class( Exception )
  public
    ErrorCode : Integer;
  end;

  EAbArchiveBusy = class( EAbException )
  public
    constructor Create;
  end;

  EAbBadStream = class( EAbException )
  protected
    FInnerException : Exception;
  public
    constructor Create;
    constructor CreateInner(aInnerException : Exception);
    property InnerException : Exception read FInnerException;
  end;

  EAbDuplicateName = class( EAbException )
  public
    constructor Create;
  end;

  EAbFileNotFound = class( EAbException )
  public
    constructor Create;
  end;

  EAbNoArchive = class( EAbException )
  public
    constructor Create;
  end;

  EAbUserAbort = class( EAbException )
  public
    constructor Create;
  end;

  EAbNoSuchDirectory = class( EAbException )
  public
    constructor Create;
  end;

  EAbUnhandledType = class( EAbException )
  public
    constructor Create;
  end;

  EAbSpanningNotSupported = class (EAbException)
  public
    constructor Create;
  end;

  EAbInvalidSpanningThreshold = class ( EAbException )
  public
    constructor Create;
  end;

  EAbZipException = class( EAbException ); {Zip exception}
  EAbCabinetException = class( EAbException ); {Cab exception}
  EAbTarException = class( EAbException ); {Tar Exception}
  EAbGzipException = class( EAbException); {GZip exception}

  EAbZipBadSpanStream = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipBadCRC = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipInflateBlock = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipInvalid = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbInvalidIndex = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipInvalidFactor = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipInvalidLocalFileHeader = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipInvalidMethod = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipInvalidPassword = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipInvalidStub= class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipNoExtraction = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipNoInsertion = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipSpanOverwrite= class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipStreamFull = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipTruncate = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipUnsupported = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbZipVersion = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbReadError = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbGzipBadCRC = class( EAbGZipException )
  public
    constructor Create;
  end;

  EAbGzipBadFileSize = class( EAbGZipException )
  public
    constructor Create;
  end;

  EAbGzipInvalid = class( EAbGZipException )
  public
    constructor Create;
  end;

  EAbTarInvalid = class( EAbTarException)
  public
    constructor Create;
  end;

  EAbTarBadFileName = class( EAbTarException)
  public
    constructor Create;
  end;

  EAbTarBadLinkName = class( EAbTarException)
  public
    constructor Create;
  end;

  EAbTarInvalidOperation = class( EAbTarException)
  public
    constructor Create;
  end;

  EAbVirtualMemoryStreamInvalidOrigin = class( EAbZipException )
  public
    constructor Create( Value : Integer );
  end;

  EAbVirtualMemoryStreamOpenSwapError = class( EAbZipException )
  public
    constructor Create( const Value : string );
  end;

  EAbVirtualMemoryStreamSeekFailed = class( EAbZipException )
  public
    constructor Create( const Value : string );
  end;

  EAbVirtualMemoryStreamReadFailed = class( EAbZipException )
  public
    constructor Create( Count : Integer; const Value : string );
  end;

  EAbVirtualMemoryStreamWriteFailed = class( EAbZipException )
  public
    constructor Create( Count : Integer; const Value : string );
  end;

  EAbVirtualMemoryStreamWriteTooManyBytes = class( EAbZipException )
  public
    constructor Create( Count : Integer );
  end;

  EAbBitBucketStreamReadTooManyBytes = class( EAbZipException )
  public
    constructor Create(Count : Integer );
  end;

  EAbBitBucketStreamSeekOutsideBuffer = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbBitBucketStreamInvalidOrigin = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbBitBucketStreamWriteTooManyBytes = class( EAbZipException )
  public
    constructor Create(Count : Integer );
  end;

  EAbSlidingWindowStreamNotAtEnd = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbSlidingWindowStreamSeekFailed = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbSlidingWindowStreamWriteFailed = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbSlidingWindowStreamInvalidOrigin = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbSlidingWindowStreamInvalidNewOrigin = class( EAbZipException )
  public
    constructor Create;
  end;

  EAbNoCabinetDll = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetBuilderFileOpenError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetBuilderFileReadError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetBuilderFileWriteError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetBuilderFileCloseError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetBuilderFileSeekError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetBuilderFileDeleteError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetBuilderAddFileError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetBuilderCreateError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetBuilderFlushCabinetError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetBuilderFlushFolderError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetExtractorCopyError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbCabinetExtractorCreateError = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbInvalidCabinetTemplate = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbInvalidCabinetFile = class( EAbCabinetException )
  public
    constructor Create;
  end;

  EAbFileTooLarge = class(EAbException)
  public
    constructor Create;
  end;

  procedure AbConvertException( const E : Exception;
                                var eClass : TAbErrorClass;
                                var eErrorCode : Integer );


implementation

uses
  Classes,
  Abbrevia.Constants,
  Abbrevia.ResourceStrings;

constructor EAbArchiveBusy.Create;
begin
  inherited Create(AbArchiveBusyS);
  ErrorCode := AbArchiveBusy;
end;

constructor EAbBadStream.Create;
begin
  inherited Create(AbBadStreamTypeS);
  FInnerException := nil;
  ErrorCode := AbBadStreamType;
end;

constructor EAbBadStream.CreateInner(aInnerException: Exception);
begin
  inherited Create(AbBadStreamTypeS + #13#10 + aInnerException.Message);
  FInnerException := aInnerException;
  ErrorCode := AbBadStreamType;
end;


constructor EAbDuplicateName.Create;
begin
  inherited Create(AbDuplicateNameS);
  ErrorCode := AbDuplicateName;
end;

constructor EAbNoSuchDirectory.Create;
begin
  inherited Create(AbNoSuchDirectoryS);
  ErrorCode := AbNoSuchDirectory;
end;

constructor EAbInvalidSpanningThreshold.Create;
begin
  inherited Create(AbInvalidThresholdS);
  ErrorCode := AbInvalidThreshold;
end;

constructor EAbFileNotFound.Create;
begin
  inherited Create(AbFileNotFoundS);
  ErrorCode := AbFileNotFound;
end;

constructor EAbNoArchive.Create;
begin
  inherited Create(AbNoArchiveS);
  ErrorCode := AbNoArchive;
end;

constructor EAbUserAbort.Create;
begin
  inherited Create(AbUserAbortS);
  ErrorCode := AbUserAbort;
end;

constructor EAbZipBadSpanStream.Create;
begin
  inherited Create(AbBadSpanStreamS);
  ErrorCode := AbBadSpanStream;
end;

constructor EAbZipBadCRC.Create;
begin
  inherited Create(AbZipBadCRCS);
  ErrorCode := AbZipBadCRC;
end;

constructor EAbZipInflateBlock.Create;
begin
  inherited Create(AbInflateBlockErrorS);
  ErrorCode := AbInflateBlockError;
end;

constructor EAbZipInvalid.Create;
begin
  inherited Create(AbErrZipInvalidS);
  ErrorCode := AbErrZipInvalid;
end;

constructor EAbInvalidIndex.Create;
begin
  inherited Create(AbInvalidIndexS);
  ErrorCode := AbInvalidIndex;
end;

constructor EAbZipInvalidFactor.Create;
begin
  inherited Create(AbInvalidFactorS);
  ErrorCode := AbInvalidFactor;
end;

constructor EAbZipInvalidLocalFileHeader.Create;
begin
  inherited Create(AbInvalidLFHS);
  ErrorCode := AbInvalidLFH;
end;

constructor EAbZipInvalidMethod.Create;
begin
  inherited Create(AbUnknownCompressionMethodS);
  ErrorCode := AbUnknownCompressionMethod;
end;

constructor EAbZipInvalidPassword.Create;
begin
  inherited Create(AbInvalidPasswordS);
  ErrorCode := AbInvalidPassword;
end;

constructor EAbZipInvalidStub.Create;
begin
  inherited Create(AbZipBadStubS);
  ErrorCode := AbZipBadStub;
end;

constructor EAbZipNoExtraction.Create;
begin
  inherited Create(AbNoExtractionMethodS);
  ErrorCode := AbNoExtractionMethod;
end;

constructor EAbZipNoInsertion.Create;
begin
  inherited Create(AbNoInsertionMethodS);
  ErrorCode := AbNoInsertionMethod;
end;

constructor EAbZipSpanOverwrite.Create;
begin
  inherited Create(AbNoOverwriteSpanStreamS);
  ErrorCode := AbNoOverwriteSpanStream;
end;

constructor EAbZipStreamFull.Create;
begin
  inherited Create(AbStreamFullS);
  ErrorCode := AbStreamFull;
end;

constructor EAbZipTruncate.Create;
begin
  inherited Create(AbTruncateErrorS);
  ErrorCode := AbTruncateError;
end;

constructor EAbZipUnsupported.Create;
begin
  inherited Create(AbUnsupportedCompressionMethodS);
  ErrorCode := AbUnsupportedCompressionMethod;
end;

constructor EAbZipVersion.Create;
begin
  inherited Create(AbZipVersionNeededS);
  ErrorCode := AbZipVersionNeeded;
end;

constructor EAbReadError.Create;
begin
  inherited Create(AbReadErrorS);
  ErrorCode := AbReadError;
end;

constructor EAbVirtualMemoryStreamInvalidOrigin.Create( Value : Integer );
begin
  inherited Create(Format(AbVMSInvalidOriginS, [Value]));
  ErrorCode := AbVMSInvalidOrigin;
end;

constructor EAbBitBucketStreamReadTooManyBytes.Create(Count : Integer );
begin
  inherited Create(Format(AbBBSReadTooManyBytesS, [Count]));
  ErrorCode := AbBBSReadTooManyBytes;
end;

constructor EAbBitBucketStreamSeekOutsideBuffer.Create;
begin
  inherited Create(AbBBSSeekOutsideBufferS);
  ErrorCode := AbBBSSeekOutsideBuffer;
end;

constructor EAbBitBucketStreamInvalidOrigin.Create;
begin
  inherited Create(AbBBSInvalidOriginS);
  ErrorCode := AbBBSInvalidOrigin;
end;

constructor EAbBitBucketStreamWriteTooManyBytes.Create(Count : Integer);
begin
  inherited Create(Format(AbBBSWriteTooManyBytesS, [Count]));
  ErrorCode := AbBBSWriteTooManyBytes;
end;

constructor EAbVirtualMemoryStreamOpenSwapError.Create( const Value : string );
begin
  inherited Create(Format(AbVMSErrorOpenSwapS, [Value]));
  ErrorCode := AbVMSErrorOpenSwap;
end;

constructor EAbVirtualMemoryStreamSeekFailed.Create( const Value : string );
begin
  inherited Create(Format(AbVMSSeekFailS, [Value]));
  ErrorCode := AbVMSSeekFail;
end;

constructor EAbVirtualMemoryStreamReadFailed.Create( Count : Integer; const Value : string );
begin
  inherited Create(Format(AbVMSReadFailS, [Count, Value]));
  ErrorCode := AbVMSReadFail;
end;

constructor EAbVirtualMemoryStreamWriteFailed.Create( Count : Integer; const Value : string );
begin
  inherited Create(Format(AbVMSWriteFailS, [Count, Value]));
  ErrorCode := AbVMSWriteFail;
end;

constructor EAbVirtualMemoryStreamWriteTooManyBytes.Create( Count : Integer );
begin
  inherited Create(Format(AbVMSWriteTooManyBytesS, [Count]));
  ErrorCode := AbVMSWriteTooManyBytes;
end;

constructor EAbSlidingWindowStreamNotAtEnd.Create;
begin
  inherited Create(AbSWSNotEndofStreamS);
  ErrorCode := AbSWSNotEndofStream;
end;

constructor EAbSlidingWindowStreamSeekFailed.Create;
begin
  inherited Create(AbSWSSeekFailedS);
  ErrorCode := AbSWSSeekFailed;
end;

constructor EAbSlidingWindowStreamWriteFailed.Create;
begin
  inherited Create(AbSWSWriteFailedS);
  ErrorCode := AbSWSWriteFailed;
end;

constructor EAbSlidingWindowStreamInvalidOrigin.Create;
begin
  inherited Create(AbSWSInvalidOriginS);
  ErrorCode := AbSWSInvalidOrigin;
end;

constructor EAbSlidingWindowStreamInvalidNewOrigin.Create;
begin
  inherited Create(AbSWSInvalidNewOriginS);
  ErrorCode := AbSWSInvalidNewOrigin;
end;

constructor EAbCabinetBuilderFileOpenError.Create;
begin
  inherited Create(AbFCIFileOpenErrorS);
  ErrorCode := AbFCIFileOpenError;
end;

constructor EAbNoCabinetDll.Create;
begin
  inherited Create(AbNoCabinetDllErrorS);
  ErrorCode := AbNoCabinetDllError;
end;

constructor EAbCabinetBuilderFileReadError.Create;
begin
  inherited Create(AbFCIFileReadErrorS);
  ErrorCode := AbFCIFileReadError;
end;

constructor EAbCabinetBuilderFileWriteError.Create;
begin
  inherited Create(AbFCIFileWriteErrorS);
  ErrorCode := AbFCIFileWriteError;
end;

constructor EAbCabinetBuilderFileCloseError.Create;
begin
  inherited Create(AbFCIFileCloseErrorS);
  ErrorCode := AbFCIFileCloseError;
end;

constructor EAbCabinetBuilderFileSeekError.Create;
begin
  inherited Create(AbFCIFileSeekErrorS);
  ErrorCode := AbFCIFileSeekError;
end;

constructor EAbCabinetBuilderFileDeleteError.Create;
begin
  inherited Create(AbFCIFileDeleteErrorS);
  ErrorCode := AbFCIFileDeleteError;
end;

constructor EAbCabinetBuilderAddFileError.Create;
begin
  inherited Create(AbFCIAddFileErrorS);
  ErrorCode := AbFCIAddFileError;
end;

constructor EAbCabinetBuilderCreateError.Create;
begin
  inherited Create(AbFCICreateErrorS);
  ErrorCode := AbFCICreateError;
end;

constructor EAbCabinetBuilderFlushCabinetError.Create;
begin
  inherited Create(AbFCIFlushCabinetErrorS);
  ErrorCode := AbFCIFlushCabinetError;
end;

constructor EAbCabinetBuilderFlushFolderError.Create;
begin
  inherited Create(AbFCIFlushFolderErrorS);
  ErrorCode := AbFCIFlushFolderError;
end;

constructor EAbCabinetExtractorCopyError.Create;
begin
  inherited Create(AbFDICopyErrorS);
  ErrorCode := AbFDICopyError;
end;

constructor EAbCabinetExtractorCreateError.Create;
begin
  inherited Create(AbFDICreateErrorS);
  ErrorCode := AbFDICreateError;
end;

constructor EAbInvalidCabinetTemplate.Create;
begin
  inherited Create(AbInvalidCabTemplateS);
  ErrorCode := AbInvalidCabTemplate;
end;

constructor EAbInvalidCabinetFile.Create;
begin
  inherited Create(AbInvalidCabFileS);
  ErrorCode := AbInvalidCabFile;
end;

procedure AbConvertException( const E : Exception;
                              var eClass : TAbErrorClass;
                              var eErrorCode : Integer );
begin
  eClass := ecOther;
  eErrorCode := 0;
  if E is EAbException then begin
    eClass := ecAbbrevia;
    eErrorCode := (E as EAbException).ErrorCode;
  end
  else if E is EInOutError then begin
    eClass := ecInOutError;
    eErrorCode := (E as EInOutError).ErrorCode;
  end
  else if E is EFilerError then
    eClass := ecFilerError
  else if E is EFOpenError then
    eClass := ecFileOpenError
  else if E is EFCreateError then
    eClass := ecFileCreateError;
end;

{ EAbUnhandledType }

constructor EAbUnhandledType.Create;
begin
  inherited Create(AbUnhandledFileTypeS);
  ErrorCode := AbUnhandledFileType;
end;

{ EAbGzipBadCRC }

constructor EAbGzipBadCRC.Create;
begin
  inherited Create(AbGzipBadCRCS);
  ErrorCode := AbGzipBadCRC;
end;

{ EAbGzipBadFileSize }

constructor EAbGzipBadFileSize.Create;
begin
  inherited Create(AbGzipBadFileSizeS);
  ErrorCode := AbGzipBadFileSize;
end;

{ EAbGzipInvalid }

constructor EAbGzipInvalid.Create;
begin
  inherited Create(AbSpanningNotSupportedS);
  ErrorCode := AbSpanningNotSupported;

end;

{ EAbTarInvalid }

constructor EAbTarInvalid.Create;
begin
  inherited Create(AbTarInvalidS);
  ErrorCode := AbTarInvalid;
end;

{ EAbTarBadFileName }

constructor EAbTarBadFileName.Create;
begin
  inherited Create(AbTarBadFileNameS);
  ErrorCode := AbTarBadFileName;
end;

{ EAbTarBadLinkName }

constructor EAbTarBadLinkName.Create;
begin
  inherited Create(AbTarBadLinkNameS);
  ErrorCode := AbTarBadLinkName;
end;

{ EAbTarInvalidOperation }

constructor EAbTarInvalidOperation.Create;
begin
  inherited Create(AbTarBadOpS);
  ErrorCode := AbTarBadOp;
end;

{ EAbSpanningNotSupported }

constructor EAbSpanningNotSupported.Create;
begin
  inherited Create(AbSpanningNotSupportedS);
  ErrorCode := AbSpanningNotSupported;
end;

{ EAbFileTooLarge }

constructor EAbFileTooLarge.Create;
begin
  {TODO Create const and fix wording}
  inherited Create(AbFileSizeTooBigS);
end;

end.
