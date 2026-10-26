# Research roadmap

## Review weekly human literature findings before choosing research

Before choosing research on each run, review the latest findings from the
separately scheduled weekly human-authored literature check for this exact
problem and its key sublemmas. Reuse those findings; a fresh search on every run
is not required. The weekly check should prioritize new and revised arXiv papers
and relevant mathematics, theoretical computer science and computational journals,
and broaden beyond familiar authors and sources.

Keep a dated source record in the research notes: source URLs, paper versions
and access dates, changes since the previous check, whether each finding is a
proved result, computational evidence or an unverified claim, and its effect on
the next research choice. Read the actual theorem hypotheses and match them to
this project's formulation; similar titles do not establish equivalence. Other
bots' claimed results are not established progress. Reuse and cite applicable
results with license and attribution respected, and retire superseded searches
while preserving the record of retired hypotheses and existing proof standards.
If the weekly findings are missing, stale or sources are unavailable, record that
limitation rather than claiming no progress elsewhere. This requirement alone
is not evidence that a literature check occurred. Do not contact authors, change
dependencies or broaden the research target without authorization. This section
does not enable or modify any schedule.

## Research priorities and progress criteria (26 October update)

Latest weekly handoff: [24 October literature baseline](results/2026-10-24-literature-review.md).
The newly located published Thue–Morse wall result reinforces its retirement;
Hofer remains a method lead. Neither supplies uniform terminal existence or a
characteristic-two counterexample. Keep the substantive priorities below.

Sunday's [bordered reconstruction](results/2026-10-25-sunday-integration.md)
recovers all eight relations from four adjacent squares, including singular
blocks. Monday's [target preimage](results/2026-10-26-terminal-target-preimage.md)
now strips every even-shift event exactly to an odd-shift representative and
isolates the remaining affine compatibility class. One full parity subsystem
plus the old norm congruence is insufficient, with an explicit F_5 example.
These are ordinary mathematical increments on auxiliary structure; both
substantive targets remain open. Next study the compatibility class under a
shared prefix digit, preserving actual adjacent-shift correlations.

The 17–18 October work refutes the auxiliary upper bound at six primes.
The characteristic-two frontier has not advanced. Judge the next work against
the following outcomes, preserving that distinction:

1. A structural lemma towards proving or refuting j-d<=N for all degrees and
   shifts in the Lai–Sprang stream, for r>=2. **Settled 17 October: refuted.**
   The bound fails at p=5, 13, 29, 37, 53, 61 (all Lean), where Delta_p=2N.
   The successor question is whether Delta_p=2N for every odd prime.
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

The existing degree-zero and three-term positive-degree families attain N;
neither supported the now-refuted universal N upper bound. Further scale checks
of these families are unnecessary.
The three retired binary baselines remain regression inputs only.

## Keeping the proof catalogue current

When completing a meaningful Lean milestone, update theorem-catalogue.yaml,
THEOREMS.md and formalization.yaml with its exact hypotheses, declaration names,
verified proof commit and audit evidence. Keep ordinary proofs and open targets
outside the proved-theorem list. A DOI covers only the source frozen in that
release. Catalogue updates support research reporting; they are not themselves
mathematical progress or a daily work quota.

The Palomar comparison package is in PALOMAR.md. Challenge/Solution modules
and Comparator configuration are prepared, and the sandboxed Linux comparison
passed with Lean, NanoDa and con-ron at the recorded immutable snapshot.
Palomar intake and its own mechanical/editorial review remain pending. The source is already
licensed Apache-2.0 with mathematical attribution and AI-use disclosure. Do not
claim registry verification or registration before those steps actually succeed.

User publication criterion (7 October): pursue submission for a first proof or
first formalisation, not verification alone. The [prior-formalisation search](results/2026-10-07-prior-formalisation-search.md)
found no earlier public Lean version of the specific Lai–Sprang components;
priority remains unestablished. Keep submission on hold and retain this scoped
finding rather than promoting it to a firstness claim.

## Next computation

- The universal auxiliary N-bound is retired: it is false at p=5,13,29,37,53,61
  and (19 October, computer-verified, N=8) at p=41. The first six are
  kernel-checked; their least original degrees are 44,316,1316,4548,4524,8344
  by computer-assisted all-shift covers. Sunday's
  independent small recheck confirms the p=5 threshold. See
  [the sharpness report](results/2026-10-17-lai-sprang-sharpness.md) and
  [the weekly integration](results/2026-10-18-sunday-integration.md).
- Successor question: is Delta_p=2N for every odd prime? The r=1 family is
  already settled; six N=4 primes and p=41 (N=8) attain 2N. No other N>=8
  prime is decided. Do not obtain more isolated witnesses merely to extend the
  list; the next brute-force case (p=73) would cost about 100 p=41 runs.
- The requested bounded-state recurrence is now proved ordinarily: retain
  forcing and evaluations at all N-th roots, a relation in F_p^(2N). Its
  parity merge uses 3N variables; Proposition 2.3 excludes invisible kernels.
  Terminal existence is the target (0,e_1). Primitive-root-only moments lose
  the known p=5 witness and are rejected. See
  [the 19 October proof](results/2026-10-19-boundary-relation.md).
- The correlated tuple is now closed: eight relations at two shifts and
  four adjacent row/column sizes, plus q mod N and min(k,N). Four binary
  transitions preserve simultaneous realizability. Terminal events are
  binary-recognizable, giving fixed-prime decidability in principle. See
  [the 21 October ordinary proof](results/2026-10-21-correlated-state.md).
  No reachable graph has been enumerated; the crude finite bound is enormous.
- **23 October compression obstruction:** T(31,4) and T(63,4) over F_5
  have the same phase, size and square relation (also next-shift square),
  but the common digit word (0,1),(0,0),(1,0) has opposite terminal outputs.
  Square-only and adjacent-shift-square-only compression are retired; even
  exact k cannot repair this collision. See
  [the verified obstruction](results/2026-10-23-square-state-obstruction.md).
- **25 October reconstruction:** at each shift, the wide rectangle is the sum
  of the adjacent square relations, and the tall rectangle is their intersection.
  The squares are distinct: equality would give an invisible vector. The proof
  includes singular/empty blocks and r=1, using the existing ordinary
  Proposition 2.3 input. Four squares therefore recover the exact eight-relation
  state and all terminal continuations. See
  [the proof and exact checks](results/2026-10-25-sunday-integration.md).
- **26 October target preimage:** the two child equations use only N primitive
  variables and have at most one joint solution. If their affine slices are
  a_i+K_i, the exact obstruction is [a_1-a_0] modulo K_0+K_1, with K_0 cap K_1=0.
  A(2q,2k)=A(q,k), while A(2q,2k+1) is false, including r=1. Thus all events
  reduce canonically to odd shift. See
  [the proof, branch table and failed criterion](results/2026-10-26-terminal-target-preimage.md).
  Both local slices can be feasible and their candidates disagree; over F_5 at
  M=313,n=12, one entire original parity subsystem plus the full norm congruence
  still fails the other subsystem. Retire that sufficiency hypothesis.
- Next bounded structural attempt: derive the compatibility class's change
  under a shared prefix digit on actual adjacent-shift squares. Seek a preserved
  proper subspace, or a collision refuting that reduction, on the existing
  p=5/p=13 accepting and rejecting paths. The quotient can have full dimension N;
  do not replace it by independent child feasibility or norm moments. No whole
  graph enumeration, larger witness boxes or practical-complexity claim follows.
- The degree-H two-residue localization and earlier cutoffs remain true.
  Closing its residual offsets would not decide the all-degree sharpness
  question; defer the remaining boundary bookkeeping unless the new recurrence
  needs it. The proposed all-degree dyadic-gcd obstruction is retired because
  the p=5 witness has maximal-minor gcd 5.
- Number wall (19 October): the ring-buffer engine (35x, identical output to
  search/number_wall_ref.c) found the p=41 witness at e=1,916,335, M=618,117.
  Its least degree is open (65,528<=e<=1,916,335). Below its first 20,000 rows
  the p=41 wall matches the random-wall density (q-1)^3/((q+1)q^(g+2)) for
  window sides 1-5. That supports the random model at depth but is not a
  proof. A structural explanation (an automaton for the wall modulo p, or a
  construction of side-N windows) remains the route to all primes. No further
  hours-long whole-machine run without explicit approval. Verifying the p=41
  witness in Lean would need a new certificate method (about 3.7*10^12
  terminal products).
- Keep characteristic two as the remaining finite-field main-conjecture
  frontier in the 24 October weekly primary-source review. Before selecting any
  new candidate, exclude rational/quadratic generating series and known
  unbounded-window constructions. Thue–Morse, regular paperfolding and
  overlapping-11 Rudin–Shapiro stay retired; no further scale expansion.
- Degree-zero attainment and the r>=3 three-term family are complete ordinary
  arguments; the r=2 extension of that family fails. Retain r=1 as a control.
  These results do not support the refuted N-bound.
- Garrett–Robertson Conjecture 1.8 has a printed exponent inconsistent with
  the established F_3 deficiency. The proposed 2^(n+1) correction remains an
  interpretation, not an author-confirmed correction or a refutation of intent.

## Next formalisation

All six refutations are kernel-checked (Sharpness, ReverseLift,
FastCertificate and the separate SharpnessCertificates target). The existing
cutoffs and sparse-divisor obstruction remain valid, but no longer form a
proof path to the universal N-bound.

The 20 October formalisation completes the algebraic recurrence: all-root
coordinates, odd-block factorisation, squaring transport, both parity merges,
and exact natural-index reindexing. It includes empty/unequal blocks and r=1.
Do not repeat this bridge. The no-invisible-kernel, dimension and terminal-target
claims are still ordinary deductions from Proposition 2.3, not Lean theorems.

The 22 October CorrelatedState proof now formalises the eight-relation tuple's
exact digit transitions, phase/saturation updates, word induction and converse
binary encoding. Reachable states are exactly actual tuples; the state type is
finite, and the infinite named stream supplies all recurrence hypotheses.
This is verification/infrastructure progress, not a new mathematical increment.
The terminal interpretation, executable enumeration and sharper cardinal bound
remain outside this theorem. See [the scope](results/2026-10-22-correlated-state-lean.md).
Next formal work should follow the compression/accepting-path evidence from the
next substantive computation; do not repeat closure or digit bookkeeping.
Formalising Proposition 2.3 is a separate substantial project, not an assumed
input to be disguised as an unconditional terminal theorem.

**24 October: the uniform reverse lift is complete.** TerminalLift.lean proves
odd-row annihilation for X^(N/2)+1 multiples and, for F_1 multiples, at every
dyadic intermediate scale. Its all-row identity includes scales 1 through N,
zero rows/polynomials and r=1. Exact certificates transport both endpoints and
the first nonzero row; a terminal exact certificate j=deg S+2 gives the actual
polynomial product 2^(-2N), uniformly in the prime. No per-instance odd-row
residues or Proposition 2.3 assumption enters the new proof. See
[the precise scope and checks](results/2026-10-24-terminal-lift.md).
This is verification/infrastructure progress on the 5 October ordinary result,
not new sharpness mathematics. Do not repeat the lift or export more instances.

The 25 October ordinary bordered reconstruction now recovers all rectangles
from four squares. The next formal lemma, if needed by the accepting-path
argument, is the generic sum/intersection identity from explicit stacked-matrix
injectivity and relation dimensions, including singular blocks. Keep these
hypotheses visible; this is not an unconditional formalisation of Proposition 2.3.
The reduced one-digit acceptance criterion is now proved ordinarily on 26 October;
next substantive work is its remaining odd-shift compatibility class above.
Further formal work should serve that question rather than repeat state closure.
The generic affine-intersection obstruction and target-specialized merge are
now kernel-checked in TargetPreimage.lean (27 October), including the actual
named-stream target criterion. Do not repeat them. Concrete affine-slice
packaging, normalized-forcing simplification and dimension counts remain outside
Lean and should be undertaken only when the substantive accepting-path argument
needs them. Exact even-shift stripping also needs the ordinary moment-factor/D+2
input; keep that dependency explicit.
The separate missing bridge from boundary target (0,e_1) to an endpoint-admissible
exact terminal certificate still needs a proof of Proposition 2.3 (or another
proved replacement); do not insert it as an axiom or count it as completed.

Defer the antiperiodic convolution bridge, further boundary bookkeeping,
composition-to-P formalisation, large certificate exports and retired binary
examples unless a chosen substantive argument needs them. Do not repeat the
completed descent, terminal cutoff, sparse-divisor or product bridges.

## Completed on 2026-10-27 (Tuesday formalisation)

- Kernel-checked target output reduction to two primitive parts, both parity
  orientations, all four paired-digit branches and actual infinite named-stream
  target membership. Complete root data discharge nonzero/negation/squaring
  hypotheses; empty blocks and r=1 are retained.
- Proved the generic affine sum-quotient criterion, representative independence
  and uniqueness with an explicit trivial-direction-intersection hypothesis.
  Actual child predicates are not yet packaged as affine subspaces in Lean;
  no-invisible-vector, Proposition 2.3 and the exact-certificate bridge stay open.
- Classification: verification/infrastructure progress on Monday's ordinary
  argument. Default build, 12 standard-axiom audits, three focused tests and
  800 prescribed original-root-sum target comparisons pass. No new prime,
  uniform accepting word, characteristic-two advance or novelty claim.
- Next substantive computation remains the compatibility class under a shared
  prefix digit on actual adjacent-shift states. The reduced target and generic
  quotient bridge now exist; do not repeat them or the terminal lift. Choose
  further formal work from a useful invariant/collision, rather than packaging
  generic affine spaces as an automatic next task. See the dated report.

## Completed on 2026-10-26

- Proved exact terminal acceptance recursion A(2q,2k)=A(q,k), and no event at
  (2q,2k+1), including r=1. Every event has a canonical odd-shift representative;
  the normalized synchronized lift is (1+X)T(X^2)/2. This is distinct from the
  previously formalized reverse lift T(X^N).
- Derived the four target-preimage branches in N primitive variables and the
  affine quotient compatibility obstruction, with uniqueness from no invisible
  vectors. Explicit endpoint-admissible F_5 polynomial satisfies one complete
  original parity subsystem and the full old norm congruence, yet coupling fails.
  Retired one-parity-plus-norm sufficiency; individual child feasibility also fails.
- Exact prescribed checks compare 800 targets with independent original-root-sum
  matrices; existing accepting/rejecting paths and the p=41 odd-size branch pass.
  All 18 focused tests pass. Ordinary mathematics, not a Lean theorem, new prime,
  uniform accepting path or characteristic-two advance. See the dated report.

## Completed on 2026-10-25 (Sunday integration)

- Proved ordinary reconstruction: adjacent squares are distinct; their sum is
  the wide rectangle and their intersection the tall rectangle. Four squares
  recover all eight components, including singular blocks, empty blocks and r=1.
- Exact original-root-sum checks cover 8,000 component comparisons in five
  fields, with 233 singular parent square blocks and 56 doubly singular pairs;
  independent affine solving checks 88 rectangle basis preimages. Twenty-six
  focused tests and the existing compression/lift checks pass.
- Classification: mathematical progress on auxiliary structure; no new prime,
  uniform terminal existence, characteristic-two result, Lean theorem or novelty
  claim. The week's recurrence/compression mathematics and formal verification
  are assessed separately in the dated integration report. Weekly literature
  findings are now present and were read; retired hypotheses remain retired.
- Next: the one-digit terminal preimage and its free primitive-root moments;
  reuse the completed lift and avoid more routine certificates or larger boxes.

## Completed on 2026-10-21 (Wednesday computation)

- Proved correlated eight-relation closure under paired binary digits for
  all odd primes, including zero shift and empty/unequal blocks.
- Proved binary recognition and fixed-prime decidability of terminal
  sharpness events; no full reachable graph or new prime was computed.
- Exact root-sum transition checks, independent p=5 affine reconstruction,
  p=13 and r=1 controls, and existing boundary regressions pass.
- Classification: mathematical progress (ordinary structural lemma), not
  Lean verification, characteristic-two progress or established novelty.

## Completed on 2026-10-20 (Tuesday formalisation)

- Proved the algebraic boundary recurrence in Lean, including all N-th roots,
  both parity orientations, squaring fibres, exact endpoints and empty blocks.
- Reused the named stream/root identities and stable Lean/mathlib 4.35.0.
  Default build, dedicated axiom audit and existing focused regressions pass.
- Classification: verification/infrastructure progress on the 19 October proof;
  no new mathematical result, prime decision or characteristic-two advance.
- Retained the newly fetched p=41 result as computer-verified, not Lean-checked.
  Next substantive work is correlated reachability, not another witness export.

## Completed on 2026-10-19 (Monday computation)

- Proved the 2N-coordinate root-evaluation relation and 3N-variable parity
  merge for all admissible odd primes and all nearly square Hankel sizes.
  Proved injectivity, exact state dimension, and the fixed terminal target.
- Exact checks against independent root sums and affine reconstruction pass,
  including existing p=5/p=13 witnesses, r=1 and N=8 boundary representatives.
  No additional witness search, Lean change or expanded wall computation.
- Classification: mathematical progress (ordinary structural lemma); no new
  prime decided, no reachable-state classification, no characteristic-two
  advance and no established publication novelty.

## Completed on 2026-10-18 (Sunday integration)

- Reconciled the week's boundary work with the subsequent six sharpness
  refutations; independently rechecked the p=5 all-shift threshold and actual
  rational-definition witness. Older degree cutoffs remain consistent.
- Corrected the unsupported inference from automaticity to independent
  random trials, and retired obsolete active proof/search directions.
- Classification: verification/infrastructure progress and roadmap maintenance;
  no new mathematical theorem, new prime or characteristic-two advance today.
  The week's substantive progress is the previously proved refutation.

## Completed on 2026-10-17 (Saturday computation and formalisation)

- Continued-fraction reformulation of the terminal problem; complete covers
  by two independent scanners (Python Berlekamp–Massey, C Euclid). Terminal
  witnesses at p=5,13,29,37,53 lift to defect exactly 2N; least degrees found.
- Lean: oddCoreFuel, laiSprangFast and the kernel-checked p=5 certificates,
  polynomial product 2^-8 and failure of the 2^-4 bound.
- Lai–Sprang Theorem 1.2 is sharp for these five characteristics (all P).
- Classification: mathematical progress (refutes the auxiliary hypothesis and
  selects the 2N branch for five primes). p=61, N>=8 and characteristic two
  remain open.

## Completed on 2026-10-16 (Friday computation)

- Ordinary uniform proof localizes degree-H odd terminal failures to two
  residues modulo NH for every N>=8, using three exact row arguments.
- The first-strip obstruction reduces to a sparse divisor of x^N+1 and
  contradicts its reflection product's x^6 coefficient in odd characteristic.
- Classification: mathematical progress on the auxiliary bound. No new
  all-shift cutoff, all-degree result, characteristic-two advance or Lean proof.
  Next address the two remaining offsets with actual original-row information.

## Completed on 2026-10-15 (Thursday formalisation)

- Proved actual-stream support gaps, available pivots and original-row terminal
  nonvanishing for every nonzero quotient of degree <N/2 at every shift.
- Composed the proved terminal base with existing descent to formalise
  d<N(3N/2-1), including zero shift and zero constant coefficients.
- Classification: verification/infrastructure progress on existing mathematics.
  No all-degree, characteristic-two or stronger mathematical cutoff result.
  Next computation remains exceptional odd-shift multi-pivot elimination.

## Completed on 2026-10-14 (Wednesday computation)

- Proved the uniform dyadic-gap minor lemma over the normalized integer stream.
  It recovers low-degree exclusion without a characteristic relation and
  confines degree-H terminal failures to two classes of floor((M+H)/N) mod H.
- An actual N=8 stream disproves completeness of the single-gap triangular
  method. Next retain multiple dyadic tails in the exceptional odd-shift strips.
- Classification: mathematical progress on the auxiliary obstruction. No new
  all-shift cutoff, all-degree result, characteristic-two advance or Lean theorem.

## Completed on 2026-10-13 (Tuesday formalisation)

- Kernel-checked full factor-aware descent, including odd-filter cancellation,
  the nonzero degree-q child at shift n+epsilon*delta, and F_s identity.
- Iterated to the uniform all-shift degree cutoff d<N(N-1), in finite
  nonvanishing form. No terminal statement or target bound is assumed.
- Classification: verification/infrastructure progress on existing mathematics.
  The stronger terminal cutoffs, all-degree bound and characteristic two remain
  unresolved formal/substantive work as applicable. Next formal target is the
  low-degree terminal exclusion; no more generic bridges or retired examples.

## Completed on 2026-10-12 (Monday computation)

- Removed the prime restriction from the boundary exclusion at N=4,8,16
  using exact integer maximal-minor gcds and independent formal-series/Fraction
  readback. All primes with r=2,3,4 have the improved all-shift cutoffs.
- Refuted the stronger power-of-two-gcd hypothesis at N=4 with an actual
  modulo-3 kernel; that characteristic is outside the admissible class.
- Classification: mathematical progress. Uniform N, all-degree bound and
  characteristic two remain unresolved; no Lean or publication change.

## Completed on 2026-10-11 (Sunday integration)

- Ordinary complete shift cover plus independently verified exact minors
  excludes quotient degree H over p=5,13,41,17 at every nonnegative shift.
  The respective strict original degree cutoffs rise to 24,24,96,384.
- Weekly lift/low-degree controls reproduce; Python regressions and existing
  pinned Lean build pass. No new Lean theorem or characteristic-two result.
- Classification: field-specific mathematical progress. Next seek a uniform
  row obstruction, not more finite boxes or retired-stream formalisation.

## Completed on 2026-10-10 (Saturday formalisation)

- Kernel-checked canonical parity split, exact parent-window extraction,
  quotient degree bounds and geometric quotient degree/expansion identities.
- The named-stream forced factor now follows from the actual factored parent
  and its vanishing window, without assuming parity rows or degree budgets.
- Classification: verification/infrastructure progress on the existing
  ordinary descent. Child selection/cancellation and iteration remain;
  no all-degree or characteristic-two advance. Next computation is unchanged.

## Completed on 2026-10-09 (Friday computation)

- Ordinary all-shift terminal exclusion for deg V<N/2; original auxiliary
  degree cutoff improves from N(N-1) to N(3N/2-1). The proof uses norm
  degree/order rigidity and an explicit two-row obstruction for monomial V.
- Retained the genuine r=1 failure and a nonmonomial e=N/2 compressed-norm
  boundary example that fails the original rows. Independent root-sum controls
  and Python regressions passed; no Lean or expanded multiplier search.
- Classification: mathematical progress on the auxiliary bound. All-degree
  bound, N-or-2N branch, characteristic two and publication novelty unresolved.
- Next computation: degree-H norm classification with actual parity rows;
  next formalisation remains parent-row extraction on the existing descent path.

## Completed on 2026-10-08 (Thursday formalisation)

- Kernel-checked finite parity windows imply H consecutive root moments with
  support-aware row budgets, including zero polynomials and zero shifts.
- Composed with RootStream and ParityDescent to prove a forced factor for the
  named stream without assuming root enumeration or moment vanishing.
- Classification: verification/infrastructure progress. Parent polynomial split,
  window extraction, child degrees/shifts and iteration remain. The all-degree
  bound and characteristic-two frontier are unchanged; no new mathematics claim.

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
