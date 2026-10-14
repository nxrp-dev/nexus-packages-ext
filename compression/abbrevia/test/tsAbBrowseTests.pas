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
 * Craig Peterson
 *
 * Portions created by the Initial Developer are Copyright (C) 1997-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

unit tsAbBrowseTests;

{$mode delphi}{$H+}
{$I AbDefine.inc}

interface

uses
  obNXTestContext,
  obAbTestFixture, Abbrevia.Browser, Abbrevia.Utilities;

type
  TAbBaseBrowserTests = class(TAbCompTestCase)
  public
  end;

  TAbDetermineArcTypeTest = class(TAbTestCase)
  private
    FFilename: string;
    FExpectedType: TAbArchiveType;
    procedure AssertEqual(expected, actual: TAbArchiveType; const msg: string);
  public
    constructor Create(AContext: TNXTestContext; const aFilename: string; aExpectedType: TAbArchiveType); reintroduce;
  public
    procedure TestDetermineArcType;
  end;


implementation

uses
  Classes, SysUtils, TypInfo;

function ArcTypeToStr(aValue: TAbArchiveType): string;
begin
  Result := GetEnumName(TypeInfo(TAbArchiveType), Integer(aValue));
end;

{ TAbBaseBrowserTests }


{ TAbDetermineArcTypeTest }

constructor TAbDetermineArcTypeTest.Create(AContext: TNXTestContext; const aFilename: string;
  aExpectedType: TAbArchiveType);
begin
  inherited Create(AContext);
  FFilename := aFilename;
  FExpectedType := aExpectedType;
  {$IFNDEF MSWINDOWS}
  if FExpectedType = atCab then
    FExpectedType := atUnknown;
  {$ENDIF}
end;

procedure TAbDetermineArcTypeTest.AssertEqual(expected, actual: TAbArchiveType;
  const msg: string);
begin
  if expected <> actual then
    Context.AssertEquals(ArcTypeToStr(expected), ArcTypeToStr(actual), msg);
end;

procedure TAbDetermineArcTypeTest.TestDetermineArcType;
var
  Stream: TBufferedFileStream;
  TmpFile: string;
begin
  AssertEqual(FExpectedType, AbDetermineArcType(FFilename, FExpectedType),
    'Checking filename with asserted type');
  AssertEqual(FExpectedType, AbDetermineArcType(FFilename, atUnknown),
    'Checking filename without asserted type');
  Stream := TBufferedFileStream.Create(FFilename, fmOpenRead);
  try
    AssertEqual(FExpectedType, AbDetermineArcType(Stream), 'Checking stream');
  finally
    Stream.Free;
  end;
  TmpFile := TestTempDir + ChangeFileExt(ExtractFileName(FFilename), '.tmp');
  AbCopyFile(FFilename, TmpFile, True);
  AssertEqual(FExpectedType, AbDetermineArcType(TmpFile, atUnknown),
    'Checking filename with unknown extension');
end;

end.

