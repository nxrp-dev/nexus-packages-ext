// Copyright (c) 2026 Kevin Collins.
// SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
program AbbreviaCoreTests;

{$mode objfpc}{$H+}

// Focused archive and filename nxtest cases without native codec dependencies.
uses
  {$IFDEF LINUX}cwstring,{$ENDIF}
  obNXTestRegistry, obNXTestResult, tsAbCabinetAPITests, tsAbDecompressionTests,
  tsAbZipFileNameTests;

var
  lRegistry: TNXTestRegistry;
  lResult: TNXTestResult;
  lSuite, lTest, lPassed, lFailed, lErrors, lSkipped: Integer;
begin
  lRegistry := TNXTestRegistry.Create;
  try
    RegisterAbCabinetAPITests(lRegistry);
    RegisterAbDecompressionTests(lRegistry);
    RegisterAbZipFileNameTests(lRegistry);
    for lSuite := 0 to lRegistry.SuiteCount - 1 do
      for lTest := 0 to lRegistry.Suites[lSuite].TestCount - 1 do
      begin
        lResult := lRegistry.Suites[lSuite].Tests[lTest].Execute(lRegistry.Suites[lSuite].Name);
        try
          case lResult.Status of
            tsPassed: Inc(lPassed);
            tsFailed: Inc(lFailed);
            tsError: Inc(lErrors);
            tsSkipped: Inc(lSkipped);
          end;
          WriteLn(lResult.StatusText, ' ', lResult.TestId, ' ', lResult.Message,
            ' ', lResult.ErrorClass, ' ', lResult.ErrorMessage);
          if (lResult.Expected <> '') or (lResult.Actual <> '') then
            WriteLn('  expected: ', lResult.Expected, '; actual: ', lResult.Actual);
        finally
          lResult.Free;
        end;
      end;
    WriteLn(lPassed, ' passed; ', lFailed, ' failed; ', lErrors, ' errors; ', lSkipped, ' skipped');
    if (lFailed + lErrors <> 0) or (lPassed = 0) then ExitCode := 1;
  finally
    lRegistry.Free;
  end;
end.
