# Mustache

Reusable template parsing and rendering through DMustache, maintained directly
by this collective repository. The package identity is `NXRP.Mustache`.

## Structure

- `Package.nxscript`: intrinsic package metadata.
- `external/dmustache`: ordinary tracked source directory; no separate fork or
  submodule is required.
  This contains `SynMustache`, its supporting units and includes, and the
  upstream documentation and license notices.

There is no Nexus wrapper or empty `src` folder: current consumers use
`SynMustache` directly. Add `external/dmustache` to the compiler's unit search
path. From the Nexus repository root, this is:

```text
-Fupackages/nexus-packages-ext/mustache/external/dmustache
```

The source retains its upstream MPL/GPL/LGPL licensing. All 13 files from the
former fork are imported byte-for-byte, including its original documentation
and `NEXUS_PATCHES.md`. Consumer paths and template behavior are unchanged.

## Provenance and preserved fixes

The source originated in `synopse/dmustache`. This import preserves revision
`a178d4475657f1c6f5cae1a986740305c54d543d` from the former Nexus-maintained checkout.
That revision is provenance; future maintenance belongs to this repository.

- `f416f11`: added the missing `SynDoubleToText.inc` from `synopse/SynPDF`, with
  its original license header.
- `a178d44`: corrected `SynCommons.pas` and `Synopse.inc` for NexusFPC 3.3.
  This commit was local to the former checkout and is included in full here.

The original 13-file source archive, SHA-256 manifest and verified complete Git
history bundle are retained at `C:\backup\DMustacheOwnership-20261010`.

## Ownership-conversion validation

On October 10, 2026, all 13 working files and files reconstructed from the Git
index matched their pre-conversion SHA-256 hashes. Forced Win64 NexusFPC source
builds of Forge and NexusScript tests used that reconstructed copy.

- Forge: 25 passed, 0 failed.
- NexusScript: 75 passed, 0 failed. The `IncludeCollections` assertion in
  nexus-packages now normalizes CRLF to LF before comparing the nine expected
  tables. Templates retain their own line endings; renderer source is unchanged.
- Heap reports recorded two outstanding allocations per suite: 223 bytes for
  Forge and 227 bytes for NexusScript. These were not investigated as part of
  the ownership conversion.

Commands, build/test logs and the exact rendered output are retained beside
the backup.

The descriptor uses the caller's `nxpackage.Language.nxscript` dialect
catalog; it does not reach out to a project folder for that language.
