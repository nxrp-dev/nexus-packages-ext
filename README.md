# External Nexus packages

This repository houses third-party libraries packaged for Nexus. Each package
owns its descriptor and documentation; upstream source retains its own license
and Git identity under `external/`.

`Packages.RepositoryIndex.nxscript` explicitly lists the available packages.
Trusted sister repositories are discovery information, not instructions to
fetch or traverse them.

Current packages:

- [Mustache](mustache/README.md): template parsing and rendering through the
  Nexus-maintained DMustache fork.

After cloning this repository, populate its pinned source submodules with:

```text
git submodule update --init --recursive
```
