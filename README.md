# External Nexus packages

This repository houses third-party libraries packaged for Nexus. Each package
owns its descriptor and documentation. Libraries maintained here retain their
original licenses and provenance under `external/`; their source and local fixes
are tracked directly by this collective repository. Abbrevia, PasZLib and
Mustache use this model. RegExpr retains its existing submodule.

`Packages.RepositoryIndex.nxscript` explicitly lists the available packages.
Trusted sister repositories are discovery information, not instructions to
fetch or traverse them.

Current packages:

- [Abbrevia](compression/abbrevia/README.md): archive runtime units and the
  reproducible LLVM codec build, maintained directly in this repository.
- [PasZLib](compression/paszlib/README.md): directly tracked compression sources.
- [Mustache](mustache/README.md): DMustache template parsing and rendering,
  maintained directly in this repository.
- [RegExpr](regexpr/README.md): upstream Object Pascal regular expressions used
  by fpGUI.

After cloning this repository, populate the remaining RegExpr submodule with
the following command. Abbrevia, PasZLib and Mustache are already present:

```text
git submodule update --init --recursive
```
