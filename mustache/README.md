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

Upstream authors, revisions, import dates, SPDX license alternatives, and the
preserved SynPDF include and NexusFPC corrections are maintained in the
[central attribution record](https://github.com/nxrp-dev/nexus/blob/main/ATTRIBUTIONS.md#dmustache-and-synopse-include).
Original source, include files, upstream documentation, and notices remain here.
The former `NEXUS_PATCHES.md` prose is consolidated into that record.

The original source archive, SHA-256 manifest, and complete Git history bundle
are retained at `C:\backup\DMustacheOwnership-20261010`.

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
