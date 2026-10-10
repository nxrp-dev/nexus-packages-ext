# Nexus Patches

This fork stays as close as possible to `synopse/dmustache`.

## SynDoubleToText.inc

Current upstream `dmustache` includes `SynDoubleToText.inc` from `SynCommons.pas`
when `DOUBLETOSHORT_USEGRISU` is enabled. That define is active for the
NexusSchema FPC/Win64 build path, but upstream `dmustache` does not ship the
include file.

`SynDoubleToText.inc` was added from `synopse/SynPDF`, where it is distributed
with the matching Synopse units and license header.
