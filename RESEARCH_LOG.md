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
