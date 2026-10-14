// Copyright (c) 2026 Kevin Collins.
// SPDX-License-Identifier: MPL-2.0-no-copyleft-exception

program AbbreviaCodecs;

{$mode objfpc}{$H+}

uses
  {$IFDEF LINUX}cthreads,{$ENDIF}
  Classes, SysUtils, Abbrevia.Zip, Abbrevia.ZipExtraction,
  Abbrevia.CRuntime, Abbrevia.LZMA, Abbrevia.WavPack;

procedure Check(ACondition: Boolean; const AMessage: string);
begin
  if not ACondition then raise Exception.Create(AMessage);
end;

procedure CheckArchives(const AFolder: string);
var
  lReference, lArchive: TAbZipArchive;
  lActual, lExpected: TMemoryStream;
  lName: string;
  lIndex, lReferenceIndex: Integer;
begin
  lReference := TAbZipArchive.Create(AFolder + '/Store.zip', fmOpenRead);
  lExpected := TMemoryStream.Create;
  lActual := TMemoryStream.Create;
  try
    lReference.Load;
    Check(lReference.Count = 11, 'Expected 11 reference files');
    for lName in ['Deflate', 'LZMA', 'PPMd'] do
    begin
      lArchive := TAbZipArchive.Create(AFolder + '/' + lName + '.zip', fmOpenRead);
      try
        lArchive.Load;
        Check(lArchive.Count = lReference.Count, lName + ': file count mismatch');
        for lIndex := 0 to lArchive.Count - 1 do
        begin
          lReferenceIndex := lReference.FindFile(lArchive.Items[lIndex].FileName);
          Check(lReferenceIndex >= 0, 'Missing reference entry');
          lExpected.Clear;
          lActual.Clear;
          AbUnzipToStream(lReference, lReference.Items[lReferenceIndex], lExpected);
          AbUnzipToStream(lArchive, lArchive.Items[lIndex], lActual);
          Check((lActual.Size = lExpected.Size) and
            CompareMem(lActual.Memory, lExpected.Memory, lExpected.Size),
            lName + ': different bytes for ' + lArchive.Items[lIndex].FileName);
        end;
        WriteLn('PASS ', lName, ': 11 extracted files match Store.zip');
      finally
        lArchive.Free;
      end;
    end;
  finally
    lActual.Free;
    lExpected.Free;
    lReference.Free;
  end;
end;

procedure CheckLZMA;
const cSizes: array[0..3] of Integer = (0, 1, 4096, 1048576);
var
  lData, lPacked, lRestored: TBytes;
  lInput, lCompressed, lOutput: TMemoryStream;
  lSize, lIndex, lPackedSize: Integer;
begin
  lInput := TMemoryStream.Create;
  lCompressed := TMemoryStream.Create;
  lOutput := TMemoryStream.Create;
  try
    for lSize in cSizes do
    begin
      SetLength(lData, lSize + 1);
      SetLength(lRestored, lSize + 1);
      SetLength(lPacked, lSize + 1024);
      for lIndex := 0 to lSize - 1 do
        lData[lIndex] := (lIndex * 37 xor (lIndex shr 8)) and $FF;
      lPackedSize := LzmaEncodeBuffer(@lData[0], lSize, @lPacked[0], Length(lPacked));
      Check(LzmaGetUncompressedSize(@lPacked[0], lPackedSize) = lSize, 'LZMA header length');
      LzmaDecodeBuffer(@lPacked[0], lPackedSize, @lRestored[0]);
      Check(CompareMem(@lData[0], @lRestored[0], lSize), 'LZMA buffer bytes');
      lInput.Clear;
      lCompressed.Clear;
      lOutput.Clear;
      lInput.WriteBuffer(lData[0], lSize);
      lInput.Position := 0;
      LzmaEncodeStream(lInput, lCompressed, lSize);
      lCompressed.Position := 0;
      LzmaDecodeStream(lCompressed, lOutput);
      Check((lOutput.Size = lSize) and
        CompareMem(@lData[0], lOutput.Memory, lSize), 'LZMA stream bytes');
      WriteLn('PASS LZMA buffer and stream round-trip: ', lSize, ' bytes');
    end;
  finally
    lOutput.Free;
    lCompressed.Free;
    lInput.Free;
  end;
end;

procedure CheckWavPack(const AFolder: string);
var
  lSource: TFileStream;
  lActual, lExpected: TMemoryStream;
  lName: string;
begin
  lActual := TMemoryStream.Create;
  lExpected := TMemoryStream.Create;
  try
    for lName in ['pcm8', 'pcm16', 'pcm24'] do
    begin
      lSource := TFileStream.Create(AFolder + '/' + lName + '.wv', fmOpenRead);
      try
        lActual.Clear;
        lExpected.LoadFromFile(AFolder + '/' + lName + '.wav');
        DecompressWavPack(lSource, lActual);
        Check((lActual.Size = lExpected.Size) and
          CompareMem(lActual.Memory, lExpected.Memory, lExpected.Size),
          lName + ': WavPack decoded bytes differ');
        WriteLn('PASS WavPack ', lName, ': decoded WAV matches source bytes');
      finally
        lSource.Free;
      end;
    end;
  finally
    lExpected.Free;
    lActual.Free;
  end;
end;

begin
  try
    Check(ParamCount = 2, 'Usage: AbbreviaCodecs <Canterbury folder> <WavPack fixture folder>');
    Check(SizeOf(size_t) = SizeOf(Pointer), 'C size_t must be pointer-sized');
    Check(Low(size_t) = 0, 'C size_t must be unsigned');
    CheckArchives(ParamStr(1));
    CheckLZMA;
    CheckWavPack(ParamStr(2));
  except
    on E: Exception do
    begin
      WriteLn(StdErr, E.ClassName, ': ', E.Message);
      ExitCode := 1;
    end;
  end;
end.
