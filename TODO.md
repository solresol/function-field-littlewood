# Research roadmap

## Next computation (Friday)

- Test the binary Rudin–Shapiro family suggested by the L=4 and L=8 witnesses:
  L=2^k, R=(1+t)(1+t^L+t^(2L)+t^(3L)), m=14L-1, candidate j=5L.
  Check bounded scales and exceptions, then seek a recurrence proof. Two scales
  do not prove unbounded defects; verify the exact binary encoding in literature.
- The planned p17 box d=1,...,16,m=65,...,256 is complete, maximum N=16,
  with positive-degree witness R=1-t^15+t^16,m=147,j=32. Investigate whether
  d=N,m=9N+3,R=1-t^(N-1)+t^N generalises to other r>=2; only N=16 is
  established here. Keep the r=1 comparison and all-degree N-bound distinction.
- Thue–Morse is retired as a candidate and degree-zero Lai–Sprang attainment
  is settled. Do not repeat their expansions as new evidence. Binary paperfolding
  already has unbounded-window literature; check sources before new work.
- Use certificates to guide number-wall work; singularity alone does not
  guarantee nonzero multiplier endpoints.

## Next formalisation (Thursday)

- Connect `fractionalCoeff` to actual Laurent-series multiplication and later
  the norm/product exponent. Avoid assuming that bridge as an axiom.
- Formalise the Lai–Sprang coefficient stream and identify the tested prefix;
  then prove the all-shift degree-zero bound and m=5N+1 attainment from
  the support formula (ordinary proof now recorded).
- Identify the recorded binary prefix with an infinite Thue–Morse definition in
  Lean; generated finite lists alone do not formalise that identity. The new
  adjacent-difference identity a_n+a_(n+1)=1+v2(n+1) mod 2 is a concrete next
  stream lemma; the polynomial endpoint/normalisation foundation is now proved.

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
