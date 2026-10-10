# RegExpr

Regular expressions through the upstream TRegExpr library. The package identity
is `NXRP.RegExpr`. fpGUI uses the `regexpr` unit directly.

## Structure

- `Package.nxscript`: intrinsic package metadata.
- `external/tregexpr`: pinned Git submodule of
  `https://github.com/andgineer/TRegExpr.git`.
- `external/tregexpr/src`: `regexpr.pas`, its compiler include and Unicode data.

The initial pinned revision is
`19389caeb6823cddfb110ed284f57d1088dd8ac2`.
Upstream source and license notices are unchanged. The repository contains
`LICENSE.txt` (MIT); `regexpr.pas` also retains its original alternative
license notices. Refer to those upstream files for the terms.

From the Nexus root, add this unit search path:

```text
-Fupackages/nexus-packages-ext/regexpr/external/tregexpr/src
```

The Pascal compiler builds the unit from source with each consuming project.
There is no Nexus wrapper, prebuilt binary requirement, download action, or
implicit dependency-resolution behavior.

The descriptor uses the caller's `nxpackage.Language.nxscript` dialect catalog;
it does not refer to a project-owned dialect by a relative filesystem path.

