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
{* ABBREVIA: Abbrevia.CabinetBrowser.pas                                *}
{*********************************************************}
{* ABBREVIA: Cabinet file browser component              *}
{*********************************************************}

unit Abbrevia.CabinetBrowser;

{$I AbDefine.inc}

interface

{$IFDEF MSWINDOWS}

uses
  Classes,
  Abbrevia.Browser,
  Abbrevia.Cabinet;

type
  TAbCustomCabinetBrowser = class(TAbBaseBrowser)
  protected {private}
    FSetID : Word;

    function  GetCabArchive : TAbCabinetArchive;
    function  GetCabSize : Integer;
    function  GetCurrentCab : Word;
    function  GetFolderCount : Word;
    function  GetItem(Index : NativeInt) : TAbCabinetItem; virtual;
    function  GetHasNext : Boolean;
    function  GetHasPrev : Boolean;
    function  GetSetID : Word;
    procedure InitArchive;
      override;
    procedure SetFileName(const aFileName : string); override;
    procedure SetSetID(Value : Word);

  protected {properties}
    property CabSize : Integer
      read GetCabSize;
    property CurrentCab : Word
      read GetCurrentCab;
    property FolderCount : Word
      read GetFolderCount;
    property HasNext : Boolean
      read GetHasNext;
    property HasPrev : Boolean
      read GetHasPrev;
    property SetID : Word
      read GetSetID
      write SetSetID;

  public {methods}
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

  public {properties}
    property CabArchive : TAbCabinetArchive
      read  GetCabArchive;
    property Items[Index : NativeInt] : TAbCabinetItem
      read  GetItem; default;
  end;


type
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  TAbCabinetBrowser = class(TAbCustomCabinetBrowser)
  published
    property ArchiveProgressMeter;
    property BaseDirectory;
    property CabSize;
    property CurrentCab;
    property FolderCount;
    property HasNext;
    property HasPrev;
    property ItemProgressMeter;
    property LogFile;
    property Logging;
    property OnArchiveProgress;
    property OnArchiveItemProgress;
    property OnChange;
    property OnLoad;
    property SetID;
    property TempDirectory;
    property Version;
    property FileName;  {must be after OnLoad}
  end;
  {.Z+}

{$ENDIF}

implementation

{$IFDEF MSWINDOWS}

uses
  SysUtils,
  Abbrevia.Archive,
  Abbrevia.Utilities;

{ TAbCustomCabinetBrowser ====================================================== }
constructor TAbCustomCabinetBrowser.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FArchiveType := atCab;
end;
{ -------------------------------------------------------------------------- }
destructor TAbCustomCabinetBrowser.Destroy;
begin
  inherited Destroy;
end;
{ -------------------------------------------------------------------------- }
function TAbCustomCabinetBrowser.GetCabArchive : TAbCabinetArchive;
begin
  if Assigned(Archive) then
    Result := TAbCabinetArchive(Archive)
  else
    Result := nil;
end;
{ -------------------------------------------------------------------------- }
function TAbCustomCabinetBrowser.GetCabSize : Integer;
begin
  if Assigned(Archive) then
    Result := TAbCabinetArchive(Archive).CabSize
  else
    Result := 0;
end;
{ -------------------------------------------------------------------------- }
function TAbCustomCabinetBrowser.GetCurrentCab : Word;
begin
  if Assigned(Archive) then
    Result := TAbCabinetArchive(Archive).CurrentCab
  else
    Result := 0;
end;
{ -------------------------------------------------------------------------- }
function TAbCustomCabinetBrowser.GetFolderCount : Word;
begin
  if Assigned(Archive) then
    Result := TAbCabinetArchive(Archive).FolderCount
  else
    Result := 0;
end;
{ -------------------------------------------------------------------------- }
function TAbCustomCabinetBrowser.GetHasNext : Boolean;
begin
  if Assigned(Archive) then
    Result := TAbCabinetArchive(Archive).HasNext
  else
    Result := False;
end;
{ -------------------------------------------------------------------------- }
function TAbCustomCabinetBrowser.GetHasPrev : Boolean;
begin
  if Assigned(Archive) then
    Result := TAbCabinetArchive(Archive).HasPrev
  else
    Result := False;
end;
{ -------------------------------------------------------------------------- }
function TAbCustomCabinetBrowser.GetItem(Index : NativeInt) : TAbCabinetItem;
  {return cabinet item}
begin
  if Assigned(CabArchive) then
    Result := CabArchive.Items[Index]
  else
    Result := nil;
end;
{ -------------------------------------------------------------------------- }
function TAbCustomCabinetBrowser.GetSetID : Word;
begin
  if Assigned(Archive) then
    Result := TAbCabinetArchive(Archive).SetID
  else
    Result := 0;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBrowser.InitArchive;
begin
  inherited InitArchive;
  if Assigned(Archive) then
    TAbCabinetArchive(Archive).SetID := FSetID;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBrowser.SetFileName(const aFileName : string);
  {open/create cabinet archive}
begin
  FFileName := aFileName;
  if (csDesigning in ComponentState) then
    Exit;
  if Assigned(FArchive) then begin
    FArchive.Free;
    FArchive := nil;
  end;
  if (aFileName <> '') and
      FileExists(aFilename) and
     (AbDetermineArcType(aFileName, atCab) = atCab) then
  begin
    FArchive := TAbCabinetArchive.Create(aFileName, fmOpenRead);
    InitArchive;
    FArchive.Load;
  end;
  DoChange;
end;
{ -------------------------------------------------------------------------- }
procedure TAbCustomCabinetBrowser.SetSetID(Value : Word);
begin
  FSetID := Value;
  if Assigned(Archive) then
    TAbCabinetArchive(Archive).SetID := Value;
end;
{ -------------------------------------------------------------------------- }

{$ENDIF}

end.
