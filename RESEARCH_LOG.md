# Research log

## 2026-09-17 (Thursday, Australia/Sydney) — first automation run

Started 08:20:56 AEST on clean, current `main` (`bd637f1`); verified origin and
completed fetch/fast-forward-only check. Read the actual Python source and
14 September literature note. No prior automation memory or Lean scaffolding
existed. The historical bound report was missing, and rank-solver claims did
not match the enumerator.

Added a pinned Lean 4.27.0/mathlib foundation proving exact certificate
soundness, finite-prefix locality through `m+d+j`, and the Hankel-kernel
formulation. Kernel-checked binary and ternary fixtures with negative controls;
no global bound or Laurent-series theorem is claimed.

Made cutoff exhaustion explicit in the enumerator and validated coefficients
against independent rational-summand root sums. Reproduced 914,975 pairs in
5.639 s; maximum defects 4,4,15 for p=5,13,17, zero unresolved inputs. Retained
six `r=1` defect-4 comparisons. Six Python tests pass; Lean build passes with
standard axioms only. Full ranges, source versions, commands, limits and build
output are in `results/2026-09-17-certificate-foundation.md` and accompanying
JSON/text records.

Primary-source recheck: Lai–Sprang v1 settles odd characteristic; the August
Badziahin–Pavlenkov–Zorin v1 still makes its characteristic-two result conditional
on a counterexample. No newer resolution found in the searched sources.

Next: exact endpoint-aware affine solver compared exhaustively to enumeration;
then use the shared stream interface for characteristic-2 experiments. Next
formal lemma: polynomial degree and the Laurent-coefficient bridge.

## 2026-09-18 (Friday, Australia/Sydney) — certified affine optimisation

Started 11:07:17 AEST on clean main at `0e1952f`; verified origin, fetched and
fast-forward checked (already current). Read actual source and prior records;
no concurrent-run marker. Revalidated the enumerator's endpoints, cutoff and
inclusive prefix semantics before adding a generic exact F_p affine solver.

Added independently checked dual obstructions for inconsistency or a forced-zero
leading coefficient. Exhaustive tiny-stream cross-checks include characteristic 2;
all 13 tests pass. Ran 7,735 degree/shift optima (d<=16,m<=64,cutoff128) in
6.807 s and independently regenerated/check-read all certificates in 0.843 s.
Lai–Sprang maxima for p=5,13,17,41 are 4,4,15,8; no auxiliary-bound violation,
and p=17 sharpness remains unobserved. Binary Thue–Morse, paperfolding and
Rudin–Shapiro maxima are 15,8,7, with explicit primal and dual witnesses.
Zero unresolved inputs; finite results only, no global or novelty claim.

Rechecked primary versions Lai–Sprang v1, Badziahin–Pavlenkov–Zorin v1 and
Robertson v3. No later characteristic-two resolution found in searched sources.
Detailed inputs, stream conventions, commands, runtimes and limitations are in
`results/2026-09-18-rank-experiments.md`; JSONL retains every certificate.
Next: formalise dual soundness/polynomial endpoints, then investigate dyadic
binary witness families and p=17 coefficient gaps. No Lean changes this run.

## 2026-09-19 (Saturday, Australia/Sydney) — Lean dual soundness

Started 08:21:19 AEST on clean main at df2ae5f; origin verified, fetched and
fast-forward-only checked, already current. No concurrent-run marker. Read
prior records and actual sources; revalidated inclusive cutoff, endpoint and
rank/certificate semantics. Corrected one stale enumerator module comment.

Proved both dual obstruction formats sound over a commutative semiring. The
combined checker proves attainment and a nonzero coefficient by j for every
normalised admissible multiplier at fixed d,m; tail locality extends the result
to all streams agreeing through m+d+j. Gaussian elimination is not trusted.
Kernel-checked three saved instances (binary optimum, forced endpoint, F_17
degree-zero gap), five negative controls, and their arbitrary-tail extensions.
All 18 printed axiom reports use standard axioms only; no sorry, new axioms or
native_decide. Lean build succeeds (1,129 jobs); all 13 Python tests pass
(0.839 s), including all saved certificates and the r=1 comparison. Deterministic
export regeneration matches all three Lean fixtures.

Rechecked Lai–Sprang v1, Badziahin–Pavlenkov–Zorin v1 and Robertson v3; no later
characteristic-two resolution found in searched primary sources. No new infinite
conclusion: this certifies finite optima, not a main-conjecture counterexample or
the auxiliary N-bound. Named infinite stream identity, scalar normalisation,
polynomial degree and Laurent-series bridges remain unfinished. Detailed commands,
versions, module runtimes and scope are in
results/2026-09-19-dual-certificate-soundness.md. Next formal increment: scalar
normalisation and polynomial endpoints; Sunday integrates the current evidence.

## 2026-09-20 (Sunday, Australia/Sydney) — integration and sharp degree-zero gaps

Started 08:20:39 AEST on clean main at d11a5d2; verified origin, fetched and
fast-forward-only checked, already current. No prior run lock. Audited actual
source, endpoint/cutoff/rank semantics, dated results and finite Lean scope.

Recorded an elementary proof from the coefficient support formula that for
every r>=2 the maximum degree-zero defect over all shifts is exactly N:
the upper bound follows from supported indices 1 modulo N, and R=1,m=5N+1
attains j=N. For p=17 this is m=81,j=16, outside the previous shift box.
This is an ordinary proof, not yet formalised in Lean; the all-degree auxiliary
upper bound remains a hypothesis, and no novelty is claimed.

Added a deterministic exact witness runner and independent root-sum readback.
Seven prescribed primes cover r=2,...,8; exhaustive p=17,d=0,m<=128 checks all
129 shifts with no unresolved cases, first attainment at 81. Runtime 0.146 s.
Retained the six r=1 comparisons. All 15 Python tests pass (1.215s), including
new cutoff and certificate-mutation controls; all 7,735 prior certificates verify.
Lean build passes (1129 cached/replayed jobs, 4.874 s); three exports still match,
18 standard-only axiom reports, and both recent hash manifests pass 19 entries.

Rechecked Lai–Sprang v1, Badziahin–Pavlenkov–Zorin v1 and Robertson v3; no later
characteristic-two resolution found in the searched primary sources. Integrated
finite/formal limits and retired the now-unneeded degree-zero shift search.
Next: characteristic-2 dyadic recurrences and p17 positive-degree shifts 65..256;
formal scalar normalisation/polynomial degree, then named-stream gap lemma.
Full proof, commands, ranges, limits and retained validation output accompany
results/2026-09-20-sunday-integration.md.

## 2026-09-21 (Monday, Australia/Sydney) — Thue–Morse dyadic family

Started approximately 08:21:51 AEST on clean main at 4b4be05. Origin verified,
fetch/fast-forward-only check current, no concurrent marker or experiment.
Read prior records and audited enumerator/affine/certificate semantics: both
endpoints, inclusive cutoff, unresolved prefixes and independently checked duals.

Proved by binary carries that for L=2^k, R=(1+t)(1+t^L), m=2L-1,
the first index is exactly j=3L for every k>=0. Thus defects 2L-1 diverge
and products 2^(1-2L) tend to zero. This binary Thue–Morse stream is retired
as a t-adic counterexample candidate. Ordinary proof, not yet Lean; no novelty
claim, consistent with prior number-wall literature. The general characteristic-2
frontier and auxiliary odd-characteristic all-degree N-bound remain unfinished.

Added checkpointed sparse witnesses k=0,...,12, independent recursive readback,
and six affine optimum certificates k<=5. All 13 witnesses resolve, maximum
defect 8191; runtime 0.096070s, Python 3.9.6, no randomness. All 19 tests pass in 1.519s,
including the prior 7735 certificates and r=1 comparisons, plus adjacent identities,
sparse/dense/cutoff checks and 10 corruption controls. Three existing Lean exports
match; no Lean source changes or build today. Primary versions rechecked, no
later characteristic-2 resolution found in the scoped searches. Related product
series were explicitly distinguished from the digit-parity encoding.

Full proof, sources, ranges, limitations and commands are in
results/2026-09-21-thue-morse-dyadic.md, with JSON witnesses/validation.
Next: Tuesday polynomial endpoints/scalar normalisation; Wednesday p17 positive
degrees and larger shifts, then informative remaining binary recurrence profiles.

## 2026-09-22 (Tuesday, Australia/Sydney) — polynomial normalisation

Started approximately 08:22:21 AEST on clean main at d3f259f. Verified origin,
fetched and fast-forward-only checked (already current); no competing lock or
experiment. Audited the actual enumerator, affine solver, independent checker,
truncation/endpoints, prior results, tests and Lean sources.

Proved nonzero scalar invariance of exact certificates and first indices over
all fields. Normalising the constant term to 1 now formally extends a checked
optimum to every multiplier with both endpoints nonzero. Built the mathlib
polynomial bridge: coefficient recovery, degree, exclusion of X divisibility,
reconstruction of every bounded-degree polynomial, and optimality quantified
over actual degree-d polynomials. Includes degree zero and characteristic two.
Kernel-checked F_3 scaling/zero-scalar controls and saved F_2/F_17 polynomial
corollaries. No Laurent or infinite-stream identification is assumed.

Final lake build passes (1322 jobs, 17.559s); 30 axiom reports use only propext,
Classical.choice and Quot.sound. No sorry, admit, added axioms or native_decide.
Lean/mathlib v4.27.0 pins unchanged; reused sources and Apache-2.0 licence read.
All 19 Python tests pass (1.604s), including all 7735 saved dual certificates,
root-sum validation, r=1 comparisons and prior regression families. Three Lean
exports match. No new search boxes were run or infinite claims inferred.

Rechecked primary Lai–Sprang v1, Badziahin–Pavlenkov–Zorin v1 and Robertson v3.
No later characteristic-two resolution found in scoped searches; odd main case
remains settled, auxiliary all-degree N-bound remains a hypothesis. Report,
source/version boundaries and command output are retained under
results/2026-09-22-polynomial-normalisation.md and accompanying JSON/text files.
Next: Wednesday p17 positive-degree shift extension; Thursday named stream
identities and Laurent coefficients. Polynomial endpoints/normalisation are done.

## 2026-09-23 (Wednesday, Australia/Sydney) — certified rank extensions

Started approximately 08:20:29 AEST on clean main at f60f3de; verified origin,
fetched/fast-forward-only checked, no competing lock/process. Read prior records
and actual enumerator/affine/checker source. Inclusive cutoffs, unresolved
accounting, normalisation, both endpoints and independent dual semantics verified.

New checkpointed experiment checks p17 d1..16,m65..256 (3072 optima) and binary
Rudin–Shapiro d17..32,m0..128 (2064), cutoff128. All 5136 independently verified,
none unresolved. p17 maximum16 at d16,m147,j32, R=1-t^15+t^16; no finite violation
of N-bound. Binary maximum15 at d25,m111,j40, R=(1+t)(1+t^8+t^16+t^24),
suggesting a dyadic family with the prior spacing4 witness. No all-scale claim.

Python3.11.6, no randomness, standard library; search5.495118s, initial
readback0.518003s. All22 tests pass1.372s, including old7735 certificates,
root sums, r1 comparisons, ten new corruption/completeness controls, exact cutoff
versus unresolved cutoff and readback with elimination disabled. Three Lean
exports match; no Lean changes/build today. Complete records/report/validation
retained under results/2026-09-23-extended-rank*, with a SHA256 manifest.

Primary Lai–Sprangv1, BPZv1, Robertsonv3 and Garrett–Robertsonv2 refreshed;
no later characteristic2 main resolution found in scoped primary searches.
Odd main case remains settled; auxiliary global N-bound remains a hypothesis.
Next: Thursday stream identities/Laurent bridge; Friday bounded tests and
recurrence derivation for the proposed Rudin–Shapiro family, then investigate
whether the p17 three-term witness extends to other N. No novelty claimed.

## 2026-09-24 (Thursday, Australia/Sydney) — named binary stream

Started approximately 08:21 AEST on clean main at 7bbd69c. Origin verified;
fetched and fast-forward-only checked; no competing lock/process. Read the
roadmap, recent records and actual enumerator/affine/checker/stream code.
Inclusive truncation, both endpoints and independent dual semantics validated.

Added BinaryStream.lean: infinite binary digit parity using mathlib Nat.digits,
even/odd recurrences, uniqueness, and adjacent-difference recurrences for all n.
Proved the saved degree-nine prefix agrees through inclusive index48; transferred
its checked exact index24 and optimum at shift15 to the infinite named stream,
including arbitrary endpoint-nonzero vectors and actual degree-nine polynomials.
Convention controls check a0=0 and disagreement with the padded prefix at49.
No all-scale dyadic, valuation-expression or Laurent norm theorem is claimed.

Final lake build passes1324 jobs20.250s with no warnings. All39 axiom reports
(nine new) use only propext/Classical.choice/Quot.sound. No sorry/admit/added
axioms/native_decide. Pins remain Lean/mathlib4.27.0; digit sources and Apache2
licence inspected. All22 Python regressions pass1.355s; three saved Lean exports
match0.095s. Python3.11.6, no randomness. No new search boxes or solver changes.
Report/build/validation/hash retained under results/2026-09-24-*.

Primary Lai–Sprangv1, BPZv1, Robertsonv3 and Garrett–Robertsonv2 rechecked;
no later characteristic-two main resolution found in scoped searches. This is
formal progress on a retired binary regression baseline, not a new counterexample
or proof of the auxiliary odd-characteristic global N-bound. Next Friday:
bounded Rudin–Shapiro dyadic family; Saturday named Lai–Sprang/Laurent bridge,
or derive the binary valuation identity from today's recurrences.

## 2026-09-25 (Friday, Australia/Sydney) — Rudin–Shapiro dyadic family

Started approximately 08:20:30 AEST on clean main at cdff75f. Verified origin,
fetched/fast-forward-only checked, no competing marker/process. Read prior
records and actual enumerator/affine/checker sources; both endpoints, inclusive
truncation, unresolved accounting and independent dual semantics remain valid.

Proved by binary-block concatenation that R=(1+t)(1+t^L+t^(2L)+t^(3L)),
m=14L-1 has exact j=5L for every L=2^k, k>=0. Four blocks cancel their internal
and boundary contributions; adjacent differencing reduces to five binary pairs.
Defect 2L-1 is unbounded, so this binary Rudin–Shapiro stream is retired as a
t-adic counterexample candidate. Ordinary proof, not Lean, with no novelty claim.
At L=1 the polynomial cancels to 1+t^4. Complemented encoding also works;
signed Rudin–Shapiro reduced modulo 2 would be a different, constant stream.

Checkpointed 13 sparse witnesses k=0..12 and five exact affine optima k=0..4,
independently read back using recursive coefficients and primal/dual checks.
All resolve; largest defect 8191 and inclusive index 90112. Python 3.9.6, standard
library, no randomness; generation 0.246678s/readback 0.110007s. All 27 tests pass
2.376s, including all 12871 old optimality certificates, root sums/r1 comparisons,
new block identities, cutoffs, locality and 11 corruption controls. Readback
passes with generation/elimination disabled; three Lean exports match. No Lean
changes/build today. Full proof, exact data, validation and SHA256 manifest are
retained under results/2026-09-25-*.

Primary Lai–Sprang v1, BPZ v1, Robertson v3, Garrett–Robertson v2 rechecked;
Sobolewski 2204.05287v2 verifies the binary pattern-parity encoding. No later
characteristic-two main resolution found in scoped searches. The auxiliary
all-degree Lai–Sprang N-bound is unchanged. Next Saturday: named Lai–Sprang or
Laurent coefficient bridge; next computation: test the p17-inspired three-term
family at other N. Do not repeat retired TM/RS scale expansion as new research.

## 2026-09-26 (Saturday, Australia/Sydney): named Lai–Sprang support stream

- Clean main at f4c3a4d fetched/FF-only checked against the correct origin; no
  competing run. Read prior records and actual enumerator, rank, independent
  checker and Lean sources. Truncation, endpoints and dual semantics remain valid.
- Added LaiSprangStream.lean: total odd-part function, all-index dyadic invariance,
  saved F_17 prefix identity and optimum at d=0,m=17,j=15. Kernel-checked sharp
  F_17 R=1,m=81,j=16 and r=1 F_3 R=1+t^2,m=2,j=6 directly. Root-sum equality,
  Laurent norms and all-shift/global bounds remain separate formal obligations.
- Corrected README and yesterday's report: Rudin–Shapiro's qualitative t-LC
  follows from published quadratic-series results. Primary versions rechecked;
  no later characteristic-2 resolution found in scoped queries, no novelty claim.
  Added rational/quadratic screening to roadmap; historical hash snapshot retained.
- Full Lean build passes in 16.001997s, 1325 jobs, no warnings; 48 standard-only
  axiom reports, nine new, no proof bypasses. All 27 Python tests pass in 3.072s,
  including 12,871 retained optima, root sums and r=1 controls. Three exports
  match; all 12 old hashes passed before today's edits. Pins unchanged at 4.27.0.
- Report/build/validation/hashes retained as results/2026-09-26-*. Next: Sunday
  integration, then generic degree-zero/Laurent bridge and Monday's three-term
  auxiliary experiment. No new finite search boxes.

## 2026-09-27 (Sunday, Australia/Sydney): quadratic screening integration

- Started approximately 08:20 AEST on clean main at a1d683c. Correct origin,
  fetch/FF-only current, no competing marker/process. Re-read enumerator,
  affine solver, independent oracles and finite/named Lean sources; inclusive
  truncation, both endpoints, unresolved cutoffs and dual semantics remain sound.
- Added exact supplied-quadratic-relation screening modulo x^M over F_2.
  Five encoding cases through index1023 independently read back using recursive
  coefficients and full Cauchy convolution. Four zero residuals; signed RS
  reduction rejected at coefficient3. No infinite identity follows from a prefix.
- Recorded ordinary all-index recurrence derivations for TM, paperfolding and
  RS, and the published quadratic-series exclusion. Explicitly retire paperfolding
  alongside TM/RS. This is integration of known results, not a novelty claim.
  A flipped coefficient64 passes precision64 and fails precision65 in tests.
- All31 Python tests pass2.976s, including1920 exhaustive tiny residual comparisons,
  corruption/completeness controls and12871 saved optima. Three exports match.
  Cached/replayed Lean build passes1325 jobs6.723141s;48 standard-only axiom
  reports, no proof bypasses, pins unchanged. Python3.9.6, seed null; screen
  generation0.005052s/readback0.199281s. All15 prior hashes passed before edits.
- Primary frontier and quadratic sources refreshed; no later characteristic-two
  resolution found in scoped primary searches. Finite/formal status table and
  exact output/validation/build/hash retained under results/2026-09-27-*.
  Auxiliary global N-bound unchanged, r1 comparisons retained. Next Monday:
  three-term Lai–Sprang family at other N; Tuesday: Laurent coefficient bridge
  then generic degree-zero support/attainment. Do not expand retired baselines.

## 2026-09-28 (Monday, Australia/Sydney): three-term family and exception

- Clean main at 302575f; correct origin, fetched/FF-only current, no competing
  run marker/process. Audited enumerator, affine solver, independent root sums
  and cutoff/endpoint/dual semantics; no existing solver changes were needed.
- Added checkpointed sparse-family experiment in 11 prescribed r>=2 fields,
  six r=1 comparisons and eight fixed degree/shift primal/dual optima. Independent
  dense root-sum readback verifies all17 witnesses/eight optima; no unresolved.
- R=1-t^(N-1)+t^N,m=9N+3 fails at N4 with j1; a_40-a_43+a_44=-2 proves
  failure for every r2 prime (ordinary argument, not Lean). At p5,13,29 the
  fixed d4,m39 optimum is j4. Retire the all-r>=2 family extension only.
- Eight prescribed r>=3 fields spanning N8..256 attain j2N and defectN.
  Optima certified only at N<=32; no all-r identity or global auxiliary bound.
  Kept p3,7,11,19,23,31 comparison defect4. No main-conjecture novelty claimed.
- All36 tests pass3.571s (3.721549s subprocess), including12871 old optima,
  512 tiny new cases, cutoffs/locality and15 corruption/coverage controls.
  Three Lean exports match0.090563s. Python3.9.6, seed null, generation0.024602s,
  independent readback0.441491s. No Lean source changes/build today.
- Primary Lai–Sprang2606.00633v1, BPZ2608.22078v1 and Robertson2307.00955v3
  rechecked28Sep; no later characteristic-two resolution found in scoped searches.
  Report, raw evidence, validation and hashes retained under results/2026-09-28-*.
  Next: generic r>=3 support identity; Tuesday Laurent coefficient bridge then
  generic degree-zero support. Global N-bound and characteristic2 remain separate.

## 2026-09-29 (Tuesday, Australia/Sydney): actual Laurent coefficient bridge

- Clean main at 6a71610; origin verified, fetched/FF-only current, no competing
  run. Audited actual enumerator, affine solver, independent readback and tests;
  inclusive cutoff, endpoints, unresolved and diagnostic-rank semantics valid.
- Added LaurentBridge.lean: embed streams in mathlib Laurent series with x=t^(-1),
  prove actual product coefficients equal the finite formula, identify polynomial
  evaluation, transport exact certificates/Hankel equations and all-polynomial
  optimality. Generic coefficient identity over commutative semirings.
- LaurentExamples.lean transports named binary j=24, F_17 j=16 and F_3 r1 j=6;
  binary degree-nine polynomial optimum and five boundary/convention controls.
  No full-product order, norm exponent or original root-sum equality assumed.
- Full Lean build: 2,206 jobs passes in 30.620815s, no warnings;
  60 axiom reports (12 new), standard axioms only, no proof bypasses. Pins unchanged
  4.27.0; inspected mathlib Laurent/Hahn/polynomial sources and Apache 2.0 licence.
- All 36 Python tests pass in 3.572842s subprocess, Python 3.9.6;
  three saved exports match in 0.094519s. No new search boxes,
  seed null. All 12 previous hashes passed before edits; historical manifest kept.
- Primary LS 2606.00633v1, BPZ 2608.22078v1, Robertson 2307.00955v3 refreshed;
  no later characteristic-two resolution found in scoped searches. No global
  auxiliary N-bound or novelty claim. Report/build/validation/hash retained.
- Next computation: prove/refute r>=3 three-term cancellation, retaining r2 failure.
  Next Lean: strictly positive fractional-part order, then norm/product exponent;
  generic degree-zero support and root-sum identification remain separate.

## 2026-09-30 (Wednesday, Australia/Sydney): generic three-term attainment

- Clean main at 3aaf7e7; correct origin, fetched/FF-only current, no competing
  run marker/process. Audited actual enumerator, affine solver, independent root
  sums and tests; inclusive cutoff, endpoints, dual and unresolved semantics hold.
- Ordinary proof for every r>=3: exactly five support points in [9N+4,12N+3]
  yield four cancellations and terminal -N/2. R=1-t^(N-1)+t^N,m=9N+3 has
  exact j=2N and defect N. Not Lean, global upper bound, generic optimality,
  characteristic-two progress or established novelty. r=2 failure retained.
- Added integer interval enumeration and complete cancellation records. Independent
  dense readback checks seven existing scales; root sums check every interval
  coefficient in 11 existing fields. No expansion of the old witness search.
- All 41 Python tests pass in 3.448s (3.560635s subprocess), including 3,280 tiny
  support intervals, nine corruption controls, 12,871 old rank optima, r=1 comparisons.
  Three saved Lean exports match in 0.093744s. New readback 0.046398s; old 17 witnesses
  and 8 optima readback 0.485012s. Python 3.9.6, seed null; no Lean edits/build.
- Primary LS 2606.00633v1, BPZ 2608.22078v1, Robertson 2307.00955v3 refreshed;
  no later characteristic-two resolution found in scoped searches. Report,
  partitions, validation and hashes retained as results/2026-09-30-*.
- Next computation: exact binary number-wall profiles, independent tiny determinant
  checks and comparison to endpoint-aware rank certificates. Thursday: fractional
  part order/norm bridge. No need for more three-term scale expansion.

## 2026-09-30 follow-up: research direction revised

At the user's request, updated the automation prompt and repository roadmap
following the progress assessment. Prioritise structural progress on the all-degree
N-bound or literature-screened characteristic-two constructions. Require an exact
question and a decision-relevant outcome before new tooling or formalisation.
Removed the daily artifact quota; a bounded unsuccessful attempt should be reported
as such. Separate mathematics from verification/infrastructure and maintenance.
Number-wall tooling is conditional, and more attainment/retired-stream examples
are not standalone objectives. Schedule, model and weekly work pattern remain.
This is a planning change, not a mathematical increment; documentation diff and
automation readback were checked. No code or proof changed; tests were not rerun.

## 2026-10-01 (Thursday, Australia/Sydney): fractional-part/product bridge

- Stated question before implementation: transport an exact positive index to
  fractional-part order, base-two size and polynomial Littlewood product, enabling
  a future structural all-degree lower-bound proof. Clean main at 12e8a05;
  origin verified, fetched/FF-only current, no competing run marker/process.
- Proved strict positive-part order and size; actual polynomial degree/trailing
  degree identify the factors for Q=t^m R with nonzero endpoints. Exact
  certificates now give product 2^(d-j). Size is an explicit real function,
  not an installed norm instance; root-sum identification remains separate.
- Proved product >=2^(-N) iff a nonzero fractional coefficient occurs by d+N,
  without assuming an exact index exists. This identifies the structural target;
  it does not prove that target for Lai–Sprang. Zero-part/pole/constant/index/sign
  controls and existing F_17 and r=1 F_3 product regressions pass.
- Full Lean build passes 2,208 jobs in 6.881132s, no warnings; 73 axiom reports
  (13 new), all standard-only. No proof bypass tokens; pins unchanged. Inspected
  relevant mathlib definitions and Apache-2.0 licence. No Python/solver changes,
  no expanded search; Python tests not rerun. Final build/validation/report saved.
- Rechecked LS2606.00633v1 and BPZ2608.22078v1 primary pages on 1 October;
  no new candidate or comprehensive frontier search. Odd main result remains
  settled; characteristic two and the auxiliary all-degree bound are unchanged.
- Classification: verification/infrastructure progress. Next: attempt parity-split
  descent for a vanishing window of d+N rows, tracking shifts and endpoints;
  formalise a useful structural reduction, not more routine bridge examples.

## 2026-10-02 (Friday, Australia/Sydney): factor-aware parity descent

- Clean main at 6367d45; verified origin, fetched and fast-forward-only checked
  (already current), no competing run marker/process. Read automation memory,
  README/TODO, recent records and relevant actual stream/solver/checker sources.
- Stated the parity-descent question and decision criteria before coding.
  Ordinary proof: if a nonzero degree-d multiplier has d+N zero rows, then
  t^N+1 divides it and d>=N(N-1). Thus j-d<=N holds for every shift when
  d<N(N-1). The invariant is divisibility by F_s=(t^N-1)/(t^s-1) with
  surplus s; both s and degree halve. No endpoint assumption on children.
- Descent ends at an F_1-multiple with deg S+1 zero rows. The terminal
  cross-convolution can lack one Vandermonde moment. No all-degree proof;
  the actual r=1 violation descends to S=1+t,M=1. The r>=2 terminal statement
  remains a sufficient, unproved target; reverse implication is not claimed.
- Exact independent root-sum parity and cross-moment identities checked.
  Targeted terminal screen: p=5,13,41,17, quotient e=0..2N, m=0..16N,
  cutoff e+N+1. Every primal/dual checked independently; no violation or
  unresolved case among 11,844 inputs. This finite agreement is inconclusive.
  Python3.9.6, seed null, combined checker runtime17.03708225s.
- Existing 41 Python tests pass3.543s. No solver edits, Lean edits or Lean
  build. Full proof/checker/output retained in results/2026-10-02-* and
  search/lai_sprang_descent_check.py; full diff inspected.
- Primary LS2606.00633v1 Section3 and BPZ2608.22078v1 refreshed2Oct.
  Explicit attribution to LS parity/Vandermonde/nonsquare method; novelty
  not established. Scoped frontier search found no later characteristic-two
  resolution; no binary candidate or retired-stream search was undertaken.
- Classification: mathematical progress from the all-shift structural proof.
  Next: recover the terminal missing moment using linked parity factors or
  expose lost sibling compatibility. Formal target: factor-aware descent and
  its degree cutoff, not another norm bridge or attainment example.

## 2026-10-03 (Saturday, Australia/Sydney): Lean root-moment rigidity

- Clean main at 0b73170; correct origin, fetched and fast-forward-only current;
  no competing lock/process. Read prior memory, roadmap, ordinary descent proof
  and actual stream/checker/Lean sources. Stated exact moment-rigidity question
  before implementation, with the degree cutoff as its downstream purpose.
- ParityDescent.lean proves H consecutive root moments force t^H+1 into both
  parity quotients. Proved prime-field nonsquareness from p-1=2H times an odd
  number, geometric-factor nonvanishing and the resulting common child factor.
  Arbitrary starting exponent, polynomial degrees and constant terms allowed.
- Generic root enumeration and the moment equations remain explicit hypotheses;
  these are discharged concretely for the F_5 instantiation, apart from its
  moment premise. Root enumeration, odd-subsequence identity, cross-convolution,
  exact row budgets and full iteration still need formalisation. The ordinary
  d<N(N-1) cutoff is not yet a Lean theorem; all-degree N-bound unchanged.
- F_5 boundary theorem: U_0=t-1,U_1=0 gives weights 1,4 at roots 2,3; moment
  zero vanishes but moment one does not, and t^2+1 is not a factor. This only
  refutes the weakened moment lemma, not the linked terminal stream statement.
  The existing r=1 terminal comparison remains relevant; no binary search.
- Full lake build passes 2,212 jobs in 10.985925s without warnings. All 85 axiom
  reports (12 new) are standard-only; no proof bypass tokens. Pins unchanged;
  actual mathlib sources and Apache-2.0 licence inspected. Python/certificates
  unchanged and not rerun. No finite search, seed or timeout inference.
- Primary LS2606.00633v1 Section 3 and BPZ2608.22078v1 refreshed 3 October;
  no comprehensive frontier search or novelty claim. Report, build and validation
  saved as results/2026-10-03-*. Complete source/documentation diff reviewed.
- Classification: verification/infrastructure progress on the structural path.
  Next formal step: derive moments from the named stream's parent window.
  Next mathematical step: recover the terminal missing relation or expose lost
  sibling compatibility; Sunday's review should not expand routine boxes.

## 2026-10-03 (Saturday, Australia/Sydney): archival release and project registration

- Published v0.1.0, *Root-moment rigidity for the Lai-Sprang Littlewood series
  in Lean 4*, at https://doi.org/10.5281/zenodo.23117611. Frozen source commit
  c80ad56b177bad7eb4d91a64388f5f2a58e7a4f1; annotated tag v0.1.0 pushed.
  The development repository remains private; the archived source is public
  under Apache-2.0 with attribution and extensive Codex-use disclosure.
- Release validation: full Lean build, standard-only axiom reports, 41 Python
  tests and the existing exact descent checks passed; details and source hashes
  are in releases/v0.1.0-validation.json. This repeated validation supports
  publication and does not constitute new mathematical progress.
- Confirmed the unauthenticated Zenodo API reports a submitted, open record;
  all three public file downloads match the uploaded files byte for byte.
  Source ZIP SHA-256: ab5876bb36945a62c35934318d0e1ec93210550c628f6cc9657d490bfb769372.
- Lean community registration: https://github.com/leanprover-community/project-intentions/issues/49.
  Also registered the p-adic machine-learning, Scholz-Brauer and NP-hardness
  projects as issues 50, 51 and 52. Their public issue records exist, but the
  registry bot did not put them on its board because the API could not apply
  the required intention label. Maintainer assistance requested once on #49.
- Classification: verification/infrastructure progress and dissemination.
  No first-formalisation priority, full Lean degree-cutoff theorem or new
  main-conjecture result is claimed. Next research steps remain the named-stream
  window-to-moment formal bridge and the terminal missing-relation question.
