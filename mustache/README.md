# Mustache

Reusable template parsing and rendering through the Nexus-maintained DMustache
fork. The package identity is `NXRP.Mustache`.

## Structure

- `Package.nxscript`: intrinsic package metadata.
- `external/dmustache`: pinned Git submodule of `https://github.com/nxrp-dev/dmustache.git`.
  This contains `SynMustache`, its supporting units and includes, and the
  upstream documentation and license notices.

There is no Nexus wrapper or empty `src` folder: current consumers use
`SynMustache` directly. Add `external/dmustache` to the compiler's unit search
path. From the Nexus repository root, this is:

```text
-Fupackages/nexus-packages-ext/mustache/external/dmustache
```

The source retains its upstream MPL/GPL/LGPL licensing. The existing
`NEXUS_PATCHES.md` records the fork's additional `SynDoubleToText.inc`.
Packaging does not change upstream code, licensing, or template behavior.

The descriptor uses the caller's `nxpackage.Language.nxscript` dialect
catalog; it does not reach out to a project folder for that language.
