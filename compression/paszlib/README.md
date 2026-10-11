# PasZLib

Package identity: `NXRP.Compression.PasZLib`.

`external/paszlib` contains the maintained source snapshot, metadata, examples,
and test fixtures; built units and binaries are excluded. Upstream revision,
import date, authors, and license indicators are maintained in the
[central attribution record](https://github.com/nxrp-dev/nexus/blob/main/ATTRIBUTIONS.md#paszlib).
Original notices and `COPYING.FPC` remain with the sources.

Add `external/paszlib/src` to the unit and include search paths. Matching RTL and
FPC `hash` units are required. Do not mix the same units from this snapshot and a
compiler distribution in one build. NexusFPC retains its own copy for bootstrap
and package ZIP creation; this package does not redirect the compiler build.
