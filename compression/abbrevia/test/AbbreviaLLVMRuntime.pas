// Copyright (c) 2026 Kevin Collins.
// SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
program AbbreviaLLVMRuntime;
{$mode delphi}

uses
  SysUtils, Abbrevia.Tar.Types, Abbrevia.Zip.Types, Abbrevia.GZip.Types, Abbrevia.Zip.Procedures, Abbrevia.Unzip.Procedures,
  Abbrevia.LZMA, Abbrevia.PPMd, Abbrevia.WavPack, Abbrevia.BZip2;

begin
  { This preserves the original combined link/startup probe. Codec behavior is
    exercised separately by the Forge C/C++ bzip2 round-trip fixture. }
  WriteLn('PASS Abbrevia runtime linkage and startup with LLVM codec objects');
end.
