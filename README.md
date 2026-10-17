# External Nexus packages

This repository houses third-party libraries packaged for Nexus. Each package
owns its descriptor and documentation. Libraries maintained here retain their
original licenses and provenance under `external/`; their source and local fixes
are tracked directly by this collective repository. Abbrevia, Mustache,
and RegExpr use this model.

`Packages.RepositoryIndex.nxscript` explicitly lists the available packages.
Trusted sister repositories are discovery information, not instructions to
fetch or traverse them.

Current packages:

- [Abbrevia](compression/abbrevia/README.md): archive runtime units and the
  reproducible LLVM codec build, maintained directly in this repository.
- [Mustache](mustache/README.md): DMustache template parsing and rendering,
  maintained directly in this repository.
- [RegExpr](regexpr/README.md): Object Pascal regular expressions used by fpGUI,
  maintained directly in this repository.

All package sources are included in a normal clone of this repository.
