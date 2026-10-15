# RegExpr

Regular expressions through the TRegExpr library. The package identity
is `NXRP.RegExpr`. fpGUI uses the `regexpr` unit directly. The library source
and local corrections are maintained directly in this repository.

## Structure

- `Package.nxscript`: intrinsic package metadata.
- `external/tregexpr`: imported library source, tracked directly here.
- `external/tregexpr/src`: `regexpr.pas`, its compiler include and Unicode data.

Upstream URL, imported revision, import date, authors, and license indicators are
maintained in the
[central attribution record](https://github.com/nxrp-dev/nexus/blob/main/ATTRIBUTIONS.md#tregexpr).
Original license texts and unit notices remain with the sources.

From the Nexus root, add this unit search path:

```text
-Fupackages/nexus-packages-ext/regexpr/external/tregexpr/src
```

The Pascal compiler builds the unit from source with each consuming project.
There is no Nexus wrapper, prebuilt binary requirement, download action, or
implicit dependency-resolution behavior.

The descriptor uses the caller's `nxpackage.Language.nxscript` dialect catalog;
it does not refer to a project-owned dialect by a relative filesystem path.

