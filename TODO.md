# Research roadmap

## Research priorities and progress criteria (30 September review)

The verified search and Lean foundations are useful, but they have not yet
resolved the auxiliary upper bound or materially advanced the characteristic-two
frontier. Judge the next work against two mathematical outcomes:

1. A structural lemma towards proving or refuting j-d<=N for all degrees and
   shifts in the Lai–Sprang stream, for r>=2.
2. A characteristic-two construction or stronger intermediate statement whose
   behaviour is not already explained by the primary literature.

Before implementing an experiment or formal lemma, state the exact question,
the unresolved step, and which possible outcomes would change the next decision.
A failed hypothesis is useful when it rules out a meaningful approach or exposes
structure. More examples of attainment, larger routine boxes, certificate exports
and generic tooling are not sufficient research outcomes by themselves.

Make a bounded serious attempt; there is no daily artifact or commit quota.
If it yields no useful increment, record the obstacle and inconclusive attempts
briefly and report that explicitly. Do not invent maintenance work to fill the
run. Distinguish mathematical progress, verification/infrastructure progress and
no useful increment in the daily account. On Sundays, assess these separately
and redirect work that repeatedly yields only infrastructure or maintenance.

The existing degree-zero attainment already shows why an N upper bound would
be sharp. The three-term positive-degree family adds structure but does not
prove that upper bound. Further scale checks of these families are unnecessary.
The three retired binary baselines remain regression inputs only.

## Next computation

- The 5 October reverse lift makes the terminal F_1 statement **equivalent**
  to the auxiliary all-degree N-bound. A terminal counterexample S at M lifts
  via R=S(t^N), m=NM to exact defect 2N. Together with the earlier descent,
  this proves that the maximum defect is either N or 2N, without selecting one.
  There is no remaining sibling-compatibility barrier to using a terminal witness.
  A minimum-degree terminal counterexample must have odd shift M=2n+1 and
  nonzero C in V_0^2-t V_1^2=C t^(-n) modulo t^(N/2)+1; its quotient V is
  coprime to t^N+1. Test whether the **original parity rows** can coexist with
  these conditions, or prove they cannot. Linkage plus compressed moments alone
  still cannot kill C. See results/2026-10-05-terminal-lift.md for the proof,
  including the use of Lai–Sprang Proposition 2.3 in the zero-sibling case.
  Do not replace this question with expanded boxes or further moment-only examples.

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
  The 30 September support classification proves j=2N for every r>=3
  by an ordinary argument; do not repeat scale expansion. Formalising the
  five-point support classification is a bounded future lemma.
  Only eight fixed degree/shift optima are certified, all at N<=32. The
  all-degree auxiliary N-bound remains a hypothesis; keep the r=1 comparison.
- Thue–Morse is retired as a candidate and degree-zero Lai–Sprang attainment
  is settled. Do not repeat their expansions as new evidence. Binary paperfolding
  is also retired: its exact recurrence proves a quadratic equation (27 September).
- First choose a structural upper-bound lemma or a literature-screened binary
  candidate and specify the discriminating calculation. Build number-wall
  profiles only if needed for that question; compare against existing rank
  certificates and independently check tiny determinants. Tool construction alone
  is not the objective. Singularity does not guarantee nonzero endpoints.

## Next formalisation

Choose a lemma on an explicit proof path to the priorities above and name the
downstream theorem it enables. Completing an essential bridge is legitimate
verification progress; avoid an indefinite sequence of bridges or formalised
retired examples that never reaches the substantive question.

- The fractional-part order, base-two size and polynomial product bridge is now
  proved (1 October). Product >= 2^(-N) is equivalent to a nonzero coefficient
  among 1,...,d+N, without assuming an exact index. Do not extend bridge work
  by default. The 2 October structural target is now available: formalise the
  F_s, surplus-s to F_(s/2), surplus-s/2 reduction for even s dividing N.
  Its downstream theorem is the all-shift degree cutoff d<N(N-1). Preserve
  arbitrary child constant coefficients and the exact shift n+epsilon*delta.
  The moment-to-forced-factor step is now kernel-checked in ParityDescent.lean
  (3 October), including Vandermonde rigidity, prime-field nonsquareness and
  nonvanishing of the geometric factor. Do not repeat that bridge. Next connect
  the parent rows to the exact H moments. RootStream.lean now proves the
  uniform H-root enumeration, odd-subsequence formula and polynomial-filter
  identity (6 October); do not repeat these. Prove the polynomial parity split,
  cross-convolution and exact row budgets using these identities.
  Then prove the leading-child degree/shift step and iterate to the cutoff.
  These are outstanding proofs, not assumed consequences of the new theorem.
- The Lai–Sprang support stream, dyadic invariance, saved F_17 prefix and
  F_17/F_3 exact witnesses are formalised. Generic degree-zero formalisation
  and original root-sum identification remain lower-priority obligations; do not
  let them replace the structural upper-bound question indefinitely.
- Defer further formalisation of the retired binary dyadic examples unless a
  selected structural argument needs the lemma. The adjacent-difference identity
  and all-scale witness remain available as optional regression/formal targets,
  not default daily work. The named prefix and basic recurrences already suffice
  for the existing certificate regressions.

## Completed on 2026-10-06 (Tuesday formalisation)

- Kernel-checked uniform root existence, distinctness, completeness and the
  named support stream's odd-subsequence formula, including H=1 and u=0.
- Proved the polynomial-filter identity for arbitrary polynomials and shifts,
  without endpoint assumptions or truncation. Only N dividing p-1 is needed.
- Classification: verification/infrastructure progress toward the structural
  cutoff. Full window-to-moments derivation and iterated descent remain open
  formal work; the all-degree bound and characteristic-two frontier unchanged.
- Next formal step: parity splitting, cross-convolution and exact row budgets.
  Next computation remains the original odd-shift terminal rows with C!=0.

## Completed on 2026-10-05 (Monday computation)

- Ordinary reverse-lift identity for all F_1 multiples and scales through N;
  terminal equivalence and the maximum-defect N-or-2N dichotomy.
- Minimum-degree terminal counterexamples localised to odd shifts, C!=0 and
  quotient coprime to t^N+1. The actual original rows remain unresolved.
- Mathematical progress on the auxiliary obstruction; no selected alternative,
  characteristic-two advance, Lean theorem or established novelty. Independent
  root-sum checks and existing Python regressions passed; no expanded search.
- Next formal work still supplies the named-stream/window-to-moment bridge.

## Completed on 2026-10-04 (Sunday integration)

- Ordinary proof of the linked weight identity and one-scalar kernel; full
  moments at even shifts force t^N+1 into the terminal quotient V.
- V=1,m=1 disproves linkage-only recovery of the missing moment for all r>=2;
  its first original stream row H(r-1) is nonzero. The terminal claim remains
  open. Preserve the actual r=1 failure; do not conflate the two examples.
- Mathematical progress this week: three-term proof, degree cutoff, terminal
  obstruction refinement. Verification/infrastructure: Laurent/product bridges
  and moment rigidity; dissemination: v0.1.0 archive. No characteristic-two
  advance and no all-degree bound. Exact small checks and existing Lean/Python
  regressions passed; these checks are not themselves mathematical progress.
- Next formal path remains the named-stream parent-window-to-moment proof,
  enabling the degree cutoff. No further product bridges or attainment searches.

## Completed on 2026-10-03 (Saturday formalisation)

- Kernel-checked the full moment block forcing t^H+1 into both parity quotients,
  and the resulting common factor in both children. Arbitrary starting exponent,
  quotient degrees and constant terms; nonsquareness proved from Fermat's theorem.
- Verified the geometric factor identity and nonvanishing. Generic root enumeration
  remains an explicit hypothesis; the F_5 instantiation discharges it concretely.
- A formal F_5 example shows that H-1 moments alone do not imply the factor. It
  is not a counterexample to the linked terminal statement. Retain the r=1 warning.
- Classification: verification/infrastructure progress on the structural proof path.
  Full descent, all-degree bound and characteristic-two frontier unchanged. Sunday's
  review should focus on the missing terminal relation, not further routine bridges.

## Completed on 2026-10-02 (Friday computation)

- Ordinary factor-aware parity-descent proof: any d+N zero window forces
  t^N+1 dividing R and d>=N(N-1). Thus the auxiliary N-bound is proved for
  every shift below that degree threshold. Not Lean or an all-degree result.
- The factors F_s and surplus s descend together to s=1; the terminal
  cross-convolution can lack one Vandermonde moment. Retained the actual r=1
  terminal violation. The r>=2 terminal screen was inconclusive, with no violation.
- Independent root-sum parity/cross-moment checks and existing primal/dual
  checking support the derivation. Classification: mathematical progress from
  the ordinary structural proof, not from finite agreement or tooling.

## Completed on 2026-10-01 (Thursday formalisation)

- Proved strictly positive fractional-part order and explicit base-two size;
  identified actual polynomial degree/trailing degree for Q=t^m R and proved
  the certificate-to-product formula 2^(d-j).
- Product lower bound is equivalent to a nonzero coefficient by d+N, including
  the zero fractional-part case. This exposes the structural proof obligation;
  it does not establish the global bound. Classification: verification/infrastructure.
- Full Lean build and boundary controls pass with standard axioms only. No new
  search, no expanded attainment family, no retired binary example formalisation.

## Completed on 2026-09-30 (Wednesday computation)

- Ordinary complete support proof: R=1-t^(N-1)+t^N,m=9N+3 has j=2N,
  terminal -N/2 and defect N for every r>=3. Retained the r=2 failure and
  r=1 comparisons. No all-degree bound, generic optimum or novelty claim.
- Added exact support-interval enumeration and cancellation partitions, with
  independent dense and root-sum checks. Seven old scales validate the proof
  tables; no search expansion or new Lean theorem is claimed.
- All 41 Python tests and three Lean exports pass. Primary sources refreshed;
  no later characteristic-two resolution found in scoped searches.

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
