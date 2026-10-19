# Stable Lean/mathlib 4.35.0 upgrade

19 October 2026, Australia/Sydney. User-requested dependency maintenance and
verification; no mathematical increment.

## Change and scope

Upgraded `lean-toolchain` from 4.35.0-rc2 to 4.35.0 and pinned mathlib to
`56a005855ea17e0b0958f73ec801ae140b0a1679`, its stable v4.35.0 release.
Regenerated the Lake manifest, including the release's transitive dependency
pins and manifest format 1.3.0. All shared dependency revisions exactly match
those already used by `../phd-thesis-lean`.

The starting Littlewood checkout was clean main at
`62c6537df42bf6df952bec096a5818c051361006`; origin fetch/fast-forward-only
reported current. No active research lock or Lean job was present. A lock
protected the upgrade. The sibling was also clean main and current with origin.
No source compatibility repair was needed: all 40 tracked Lean sources are
byte-identical to the starting commit. The existing mathematical statements,
certificate data and proof techniques are unchanged.

The active README, Palomar guide, dependency provenance and theorem guide now
identify stable development. Original immutable proof snapshots, dated build
logs and release/archive claims remain historical evidence. This upgrade does
not publish a release or submit to Palomar.

## Verification

Results and exact command runtimes are in
[validation.json](2026-10-19-stable-upgrade/validation.json); full build,
audit, test and comparison logs accompany it. Mathlib's matching compiled
cache was reused. A toolchain change caused project proofs and all four large
certificate modules to rebuild; a from-source rebuild of all mathlib is not
claimed.

| Check | Result | Wall time |
|---|---|---:|
| Default `lake build` | Passed | 50.432 s |
| Certificate p=29 | Passed | 19.667 s |
| Certificate p=37 | Passed | 171.851 s |
| Certificate p=53 | Passed | 165.799 s |
| Certificate p=61 | Passed | 571.547 s |
| Combined `SharpnessCertificates` target | Passed | 14.968 s |
| All nine declaration/axiom audit files | Passed; 73 distinct declarations, standard axioms only | 39.098 s total |
| Python regression suite | Passed; 80 tests | 24.910 s |
| Sandboxed Comparator | Passed; Lean, NanoDa and con-ron accepted | 49.005 s |
| Thesis default and prototype libraries | Passed | 45.902 s |

Independent-kernel acceptance applies to the existing root-moment comparison
package, not to every theorem in either repository. All large certificate
proofs passed Lean's kernel and their dedicated axiom audit. Peak process RSS
for the largest certificate was 4,438,720 KiB (about 4.23 GiB).

The large certificates were compiled sequentially to limit memory use while
other unrelated workloads used the workstation. Runtimes are not controlled
benchmarks against the earlier release candidate. No unrelated process was
stopped, no test was bypassed, and no proof was replaced with native evaluation,
a placeholder or an assumption.

The default build retains the existing deliberate `sorry` warning in
Challenge.lean, a statement-only comparison module. It is not an axiom of the
proved Solution or any audited result. The sibling build emits existing module
system suggestions, deprecation notices and linter warnings; no `sorry` warning
or nonstandard audited axiom occurred there.

## Thesis repository

`../phd-thesis-lean` was already on Lean/mathlib v4.35.0 at
`77a93c5683c3a313ea62e303a4651acdab4fdf66`, with its existing pinned
lean-np-hardness dependency. Its manifest contains no Littlewood dependency.
Both its default `PhdThesisLean` library and non-default
`DiscreteMetricRegression` library build successfully together. The 979 axiom
reports emitted by that build contain only propext, Classical.choice and
Quot.sound. No thesis source, manifest or documentation changes were needed;
its checkout remains clean. Its full build log is retained alongside the
Littlewood validation evidence. Trailing whitespace in compiler suggestions
was stripped for Git hygiene; both raw and retained log hashes are recorded.

## Reproduction

From this repository, after fetching the matching mathlib cache:

```sh
lake build
lake build SharpnessCertificates.P29
lake build SharpnessCertificates.P37
lake build SharpnessCertificates.P53
lake build SharpnessCertificates.P61
lake build SharpnessCertificates
for audit in verification/*Audit.lean; do
  lake env lean "$audit" || exit 1
done
python3 -m unittest discover -s tests -v
bash scripts/verify-palomar.sh
```

The last command requires the documented Linux/bubblewrap environment and
uses the stable toolchain's bundled checkers without bypassing the sandbox.
For the sibling checkout, run `lake build PhdThesisLean DiscreteMetricRegression`.

Stable release references checked on 19 October 2026:
[Lean v4.35.0](https://github.com/leanprover/lean4/releases/tag/v4.35.0) and
[mathlib v4.35.0](https://github.com/leanprover-community/mathlib4/releases/tag/v4.35.0).
