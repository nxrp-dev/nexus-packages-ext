# External Nexus Package Instructions

- This repository packages third-party libraries for Nexus.
- Follow `../../.ai/standards/pascal.md` for Nexus-owned Object Pascal code.
- Keep upstream source and its license notices intact under each package's `external` folder.
- Maintain authors, original URLs/revisions, fork/import dates, our locations, upstream SPDX expressions, and status in Nexus root `ATTRIBUTIONS.md`. Package READMEs link there rather than maintaining duplicate provenance.
- Keep package descriptions and catalog entries independent of runnable project definitions.
- Do not introduce wrappers or dependency-resolution behavior solely to package an existing library.
