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
{* ABBREVIA: Abbrevia.CabinetBuilder.pas                                *}
{*********************************************************}
{* ABBREVIA: Cabinet builder component                   *}
{*********************************************************}

unit Abbrevia.CabinetBuilder;

{$I AbDefine.inc}

interface

{$IFDEF MSWINDOWS}

uses
  Classes,
  Abbrevia.CabinetBrowser,
  Abbrevia.Archive, Abbrevia.Cabinet;

type
  TAbCustomCabinetBuilder = class(TAbCustomCabinetBrowser)
  protected {private}
    FFolderThreshold     : Integer;
    FCompressionType     : TAbCabCompressionType;
    FStoreOptions           : TAbStoreOptions;
    FOnSave              : TAbArchiveEvent;

 protected {methods}
    procedure DoSave(Sender : TObject); virtual;
    procedure InitArchive; override;
    procedure SetFolderThreshold(Value : Integer);
    procedure SetCompressionType(Value : TAbCabCompressionType);
    procedure SetFileName(const aFileName : string); override;
    procedure SetStoreOptions( Value : TAbStoreOptions );

  protected {properties}
    property CompressionType : TAbCabCompressionType
      read  FCompressionType
      write SetCompressionType;
    property FolderThreshold : Integer
      read  FFolderThreshold
      write SetFolderThreshold;
    property StoreOptions : TAbStoreOptions
      read  FStoreOptions
      write SetStoreOptions
      default AbDefStoreOptions;

  protected {events}
    property OnSave : TAbArchiveEvent
      read  FOnSave
      write FOnSave;

  public {methods}
    constructor Create( AOwner : TComponent ); override;
    procedure AddFiles(const FileMask : string; SearchAttr : Integer );
    procedure AddFilesEx(const FileMask : string;
                         const ExclusionMask : string; SearchAttr : Integer );
    procedure StartNewFolder;
    procedure StartNewCabinet;
  end;

type
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  TAbCabinetBuilder = class(TAbCustomCabinetBuilder)
  published
    property ArchiveProgressMeter;
    property BaseDirectory;
    property CabSize;
    property CompressionType;
    property FolderThreshold;
    property ItemProgressMeter;
    property StoreOptions;
    property OnArchiveProgress;
    property OnArchiveItemProgress;
    property OnChange;
    property OnConfirmProcessItem;
    property OnLoad;
    property OnProcessItemFailure;
    property OnRequestImage;
    property OnSave;
    property SetID;
    property SpanningThreshold;
    property TempDirectory;
    property Version;
    property FileName; {must be after OnLoad}
  end;
  {.Z+}

{$ENDIF}

implementation

{$IFDEF MSWINDOWS}

uses
  SysUtils,
  Abbrevia.Exceptions,
  Abbrevia.Utilities;

{ TAbCustomCabinetBuilder ========================================================= }
constructor TAbCustomCabinetBuilder.Create( AOwner : TComponent );
begin
  inherited Create( AOwner );
  FCompressionType := AbDefCompressionType;
  FSpanningThreshold := AbDefCabSpanningThreshold;
  FFolderThreshold := AbDefFolderThreshold;
  FSetID := 0;
  FStoreOptions := AbDefStoreOptions;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBuilder.AddFiles(const FileMask : string; SearchAttr : Integer );
  {Add files to the cabinet where the disk filespec matches}
begin
  if Assigned(CabArchive) then
    CabArchive.AddFiles(FileMask, SearchAttr)
  else
    raise EAbNoArchive.Create;
  DoChange;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBuilder.AddFilesEx(const FileMask : string;
                                      const ExclusionMask : string;
                                            SearchAttr : Integer);
  {Add files that match Filemask except those matching ExclusionMask}
begin
  if Assigned(CabArchive) then
    CabArchive.AddFilesEx(FileMask, ExclusionMask, SearchAttr)
  else
    raise EAbNoArchive.Create;
  DoChange;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBuilder.DoSave(Sender : TObject);
begin
  if Assigned(FOnSave) then
    FOnSave(Self);
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBuilder.InitArchive;
begin
  inherited InitArchive;
  if Assigned(CabArchive) then begin
    {properties}
    CabArchive.FolderThreshold   := AbToUInt32(FFolderThreshold);
    CabArchive.CompressionType   := FCompressionType;
    CabArchive.SetID             := FSetID;
    CabArchive.StoreOptions      := FStoreOptions;
    {events}
    CabArchive.OnSave            := DoSave;
  end;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBuilder.SetCompressionType(Value : TAbCabCompressionType);
  {Set the type of compression to use}
begin
  FCompressionType := Value;
  if Assigned(CabArchive) then
    CabArchive.CompressionType := Value;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBuilder.SetFileName(const aFileName : string);
  {Create the specified cabinet file}
begin
  FFilename := aFileName;
  if csDesigning in ComponentState then
    Exit;
  if Assigned(FArchive) then begin
    FArchive.Free;
    FArchive := nil;
  end;
  if (aFileName <> '') then begin
    FArchive := TAbCabinetArchive.Create(aFileName, fmOpenWrite);
    InitArchive;
    FArchive.Load;
    FArchiveType := atCab;
  end;
  DoChange;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBuilder.SetFolderThreshold(Value : Integer);
  {Set folder compression boundary}
begin
  FFolderThreshold := Value;
  if Assigned(CabArchive) then
    CabArchive.FolderThreshold := AbToUInt32(Value);
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBuilder.SetStoreOptions(Value : TAbStoreOptions);
begin
  FStoreOptions := Value;
  if Assigned(CabArchive) then
    CabArchive.StoreOptions := Value;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBuilder.StartNewCabinet;
  {Flush current cabinet and start a new one}
begin
  if Assigned(CabArchive) then
    CabArchive.NewCabinet
  else
    raise EAbNoArchive.Create;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBuilder.StartNewFolder;
  {Flush current folder and start a new one}
begin
  if Assigned(CabArchive) then
    CabArchive.NewFolder
  else
    raise EAbNoArchive.Create;
end;
{ -------------------------------------------------------------------------- }

{$ENDIF}

end.
