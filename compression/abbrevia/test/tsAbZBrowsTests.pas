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
 * Robert Love
 *
 * Portions created by the Initial Developer are Copyright (C) 1997-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

unit tsAbZBrowsTests;
{$mode delphi}{$H+}
{$I AbDefine.inc}
interface

uses
  obNXTestContext,
  obAbTestFixture, Abbrevia.ZipBrowser;

type

  TAbZipBrowserTests = class(TabCompTestCase)
  private
    Component : TAbZipBrowser;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestDefaultStreaming;
    procedure TestComponentLinks;

  end;

implementation

{ TAbZipBrowserTests }

procedure TAbZipBrowserTests.SetUp;
begin
  inherited;
  Component := TAbZipBrowser.Create(nil);
end;

procedure TAbZipBrowserTests.TearDown;
begin
  Component.Free;
  inherited;
end;

procedure TAbZipBrowserTests.TestComponentLinks;
begin
  TestComponentLink(Component, 'ArchiveProgressMeter', TAbTestMeter);
  TestComponentLink(Component, 'ItemProgressMeter', TAbTestMeter);
end;

procedure TAbZipBrowserTests.TestDefaultStreaming;
begin
  inherited TestDefaultStreaming(Component);
end;

end.

