# Research roadmap

## Next computation (Wednesday)

- Screen new binary streams for rational/quadratic generating series and existing
  unbounded-window results before treating them as open candidates. The known
  quadratic-series route already handles binary Rudin–Shapiro; see the
  26 September attribution correction.

- Binary Rudin–Shapiro is now retired as a counterexample candidate: the
  four-block concatenation argument proves j=5L and unbounded defect 2L-1
  at all dyadic scales. Keep its exact certificates as regressions; do not
  repeat scale expansion as new research. No all-scale optimality was proved.
- The three-term family R=1-t^(N-1)+t^N,m=9N+3 fails for every r=2:
  its first coefficient is -2. Retire the proposed all-r>=2 extension.
  Finite j=2N attainment now spans N=8,...,256; derive or refute the generic
  r>=3 support identity in the 28 September report instead of expanding scales.
  Only eight fixed degree/shift optima are certified, all at N<=32. The
  all-degree auxiliary N-bound remains a hypothesis; keep the r=1 comparison.
- Thue–Morse is retired as a candidate and degree-zero Lai–Sprang attainment
  is settled. Do not repeat their expansions as new evidence. Binary paperfolding
  is also retired: its exact recurrence proves a quadratic equation (27 September).
- Use certificates to guide number-wall work; singularity alone does not
  guarantee nonzero multiplier endpoints.

## Next formalisation (Thursday)

- The actual Laurent coefficient and polynomial-evaluation bridge is proved
  (29 September). Define the strictly positive fractional part, prove its order
  from `LaurentFirstPositive`, then connect the norm/product exponent. The full
  product can have poles; do not identify its order with the fractional index.
- The Lai–Sprang support stream, dyadic invariance, saved F_17 prefix and
  F_17/F_3 exact witnesses are now formalised. Prove the all-shift degree-zero
  bound and generic m=5N+1 attainment; identify the support formula with the
  original root-sum expression. None of these remaining bridges is assumed.
- The binary degree-nine prefix is now identified with the infinite digit-parity
  stream; even/odd recurrences and their uniqueness are proved. Next derive
  a_n+a_(n+1)=1+v2(n+1) mod 2 from the adjacent recurrences, then formalise
  the already recorded all-scale dyadic witness without new scale searches.

## Completed on 2026-09-29 (Tuesday formalisation)

- Proved the generic coefficient identity for actual mathlib Laurent products
  in x=t^(-1), polynomial evaluation, Hankel equivalence and certificate transport.
- Transferred named binary j=24, F_17 j=16 and F_3 r1 j=6 witnesses, and the binary
  optimum for every degree-nine polynomial with nonzero constant term.
- Kernel-checked shift-sign, zero-index, a_0 and terminal-boundary controls.
  Norm/product exponent and original Lai–Sprang root-sum equality remain unproved.
- Full Lean build and all 36 Python tests pass; three saved exports match.
  No new finite box, global bound, novelty claim or characteristic-two resolution.

## Completed on 2026-09-28 (Monday computation)

- Tested the three-term family in 11 prescribed fields with exact root-sum
  readback; retained six r=1 comparisons and eight primal/dual fixed-input optima.
- N=4 failure has an ordinary all-r=2 explanation; at p=5,13,29 even the
  optimal degree-four multiplier at m=39 has j=4. The auxiliary N-bound survives.
- At N=8,...,256 the prescribed family attains j=2N. This is finite evidence,
  not a proof for all r>=3, all-prime optimality or a new main-conjecture result.
- All36 Python tests and three saved exports pass. Primary literature refreshed;
  no later characteristic-two resolution found in scoped searches. No Lean edits.

## Completed on 2026-09-27 (Sunday integration)

- Added an exact F_2 supplied-relation screen modulo x^M, with independent
  recursive-stream/full-convolution readback. Five encoding cases through
  coefficient 1023; signed Rudin–Shapiro fails at coefficient 3.
- Derived the three baseline quadratic equations from their exact recurrences,
  with primary attribution. Paperfolding is now explicitly retired alongside
  Thue–Morse and Rudin–Shapiro via the known quadratic-series t-LC result.
- Finite agreement alone does not prove a relation. A delayed-tail mutation
  passes at precision 64 and fails at 65. This is a reusable screening primitive,
  not an exhaustive algebraicity search or a new main-conjecture result.
- Integrated finite/formal boundaries and reran Python, saved exports and Lean.
  Next Monday: three-term Lai–Sprang witness across other N; next Tuesday:
  Laurent coefficient bridge, then generic degree-zero support/attainment.

## Completed on 2026-09-26 (Saturday formalisation)

- Defined the infinite Lai–Sprang support-formula stream, proved odd-part and
  dyadic invariance, and transferred the saved F_17 optimum to that stream.
- Kernel-checked F_17 R=1,m=81,j=16 and F_3 R=1+t^2,m=2,j=6 directly.
  Root-sum equality, all-shift/global bounds and Laurent norms remain unproved.
- Corrected Rudin–Shapiro attribution: qualitative t-LC follows from published
  quadratic-series results; explicit-family novelty remains unestablished.
- Sunday integration completed on 27 September; the three-term experiment
  remains queued for Monday.

## Completed on 2026-09-25 (Friday computation)

- Ordinary proof for every k>=0 of the proposed Rudin–Shapiro family, including
  cancellation at k=0. Defect 2L-1 is unbounded; retire this binary candidate.
- Retained 13 exact sparse witnesses and five independently checked small
  primal/dual optima. No unresolved scales; maximum retained defect 8191.
- All 27 Python tests pass, including independent recurrence readback with
  generation/elimination disabled, cutoff/locality and corruption controls.
  Three Lean exports match. No Lean source changes or build today.
- Primary frontier and binary encoding rechecked. No novelty, characteristic-two
  main resolution or global Lai–Sprang N-bound claimed. Future finite formal
  lemma: binary-block identity and cancellation of four boundary terms.

## Completed on 2026-09-24 (Thursday formalisation)

- Defined infinite binary digit parity using mathlib digits, proved even/odd
  recurrences, uniqueness, and adjacent-difference recurrences at all indices.
- Kernel-identified the saved prefix through index 48, transferring the degree-9,
  shift-15 exact index 24 and optimality to the actual infinite named stream.
  Includes arbitrary endpoint-nonzero vectors and degree-nine polynomials.
- Checked convention controls at zero and at the first index beyond the prefix.
  The global dyadic theorem, valuation identity and Laurent bridge remain open
  formalisation tasks. No new search box or main-conjecture result claimed.

## Completed on 2026-09-23 (Wednesday computation)

- Certified 3072 positive-degree p17 optima and 2064 binary Rudin–Shapiro
  optima in disjoint extensions of the old boxes; no unresolved cases.
- p17 maximum defect 16 attained at d16,m147,j32 with a three-term witness;
  binary maximum 15 at d25,m111,j40 suggests a dyadic family, still unproved.
- Independent root-sum/recursive readback of all records, ten corruption and
  completeness controls, cutoff/locality tests and elimination-disabled readback.
  All 22 Python tests pass; existing Lean exports match. No new Lean theorem.
- Primary frontier rechecked; no later characteristic-2 resolution found in
  scoped searches. Finite agreement supplies no global auxiliary bound.

## Completed on 2026-09-22 (Tuesday formalisation)

- Nonzero scalar invariance of exact certificates and first indices over every
  field; the finite optimum now bounds all vectors with both endpoints nonzero.
- Polynomial reconstruction, degree and nonzero constant-term bridge, including
  degree zero. Checked optima now quantify over actual degree-d polynomials.
- Kernel-checked F_3 scaling and zero-scalar negative control, and saved F_2/F_17
  polynomial optimum corollaries. No Laurent-series or named-stream identification
  was assumed. Existing Python algorithms and finite search boxes are unchanged.

## Completed on 2026-09-21 (Monday computation)

- Proved by binary carries that R=(1+t)(1+t^(2^k)), m=2^(k+1)-1 has
  j=3*2^k for every k>=0 in the binary digit-parity stream. Its defect is
  unbounded, ruling out this stream as a t-adic counterexample. Ordinary proof,
  not Lean; no novelty claim and no general characteristic-2 resolution.
- Exact witnesses at k=0,...,12, independent recurrence readback, and six
  primal/dual optimum certificates for k<=5. All 19 Python tests pass,
  including cutoff, endpoint, duplicate/missing-input and corruption controls.
- Rechecked primary versions and identified relevant existing Thue–Morse
  number-wall discussion; distinguished digit parity from multiplicative
  generalised Thue–Morse products. No new odd-characteristic search this run.

## Completed on 2026-09-20 (Sunday integration)

- Proved on paper that the degree-zero maximum is exactly N for every r>=2;
  sharp witness R=1,m=5N+1. This is not yet a Lean theorem or an all-degree bound.
- Independently checked seven prescribed field witnesses (r=2,...,8) and the
  exhaustive p=17,d=0,m<=128 box; p=17 first attains 16 at m=81.
- Integrated the week's finite/formal evidence, retained the failed r=1 bound
  explicitly, and rechecked current primary-source versions. The binary
  main-conjecture frontier remains unresolved in the sources checked.
- Reran Python, saved-certificate and Lean checks; detailed outputs and timings
  are retained with the dated integration report.

## Completed on 2026-09-19

- Lean soundness of inconsistency and forced-zero-leading-coefficient duals,
  combined primal/dual optimality checker, first-index upper bound, and locality
  through the inclusive m+d+j prefix. Generic commutative-semiring proofs.
- Kernel-checked three selected saved prime-field certificates and five negative
  controls, including degree zero and a forced endpoint. Deterministic exporter
  independently regenerates coefficients; all 13 existing Python tests pass.
- Literature versions rechecked; no new infinite or novelty claim. Polynomial
  and Laurent-series bridges remain unfinished.

## Completed on 2026-09-18

- Exact endpoint-aware affine solver and generic prime-field stream interface.
- Exhaustive cross-checks on all 128 length-7 binary and 243 length-5 ternary
  streams (all documented tiny shifts/degrees), plus tiny Lai–Sprang boxes.
- Independent primal/dual readback of all 7,735 optima in degree 0–16, shift
  0–64 boxes across four odd fields and three binary baselines; no unresolved
  cases. Coefficients independently regenerated by root sums/recurrences.
- Rechecked primary literature versions; no later characteristic-2 resolution
  found in the searched sources. No main-conjecture novelty claimed.

## Completed on 2026-09-17

- Reconciled advertised files/algorithms; replaced unretained historical data with
  a reproducible 914,975-pair enumeration and explicit cutoff accounting.
- Independent root-sum validation and exact witness tests.
- Pinned Lean/mathlib; proved Hankel/prefix equivalence, finite certificate
  soundness, and invariance under tail replacement beyond `m+d+j`.
- Checked F_2 infrastructure and F_3 comparison-prefix certificates in Lean.

## Retired research direction

Searching whether odd characteristics congruent to 1 modulo 4 admit a
main-conjecture counterexample is superseded by Lai–Sprang (2026). Work on their
explicit stream concerns the separate auxiliary sharp-constant hypothesis.
The `N`-bound for `r=1` is already refuted by the documented degree-2 witnesses.
