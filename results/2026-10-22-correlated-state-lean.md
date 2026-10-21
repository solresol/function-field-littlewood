# Correlated reachability in Lean

22 October 2026, Thursday, Australia/Sydney (AEDT).
Classification: **verification/infrastructure progress**. This formalises the
21 October ordinary structural lemma; it is not a new mathematical increment,
new sharpness case, characteristic-two construction, or publication-priority claim.

## Question stated before formalisation

Can the eight adjacent-shift/size boundary relations be proved to close under
paired binary digits, with all children taken from one actual parent tuple,
and can word induction identify exactly the reachable states? Success removes
the formal correlation gap and enables subsequent proofs about state reductions
or accepting paths. A failed endpoint identity would require correction of the
ordinary argument. The auxiliary universal N-bound is already refuted; the
successor question is uniform attainment of 2N, not renewed search for odd-field
main-conjecture counterexamples.

Started from clean main cd124e6 with the specified solresol origin. Fetch and
fast-forward-only merge were current; no competing research lock was present.
Read memory, README, roadmap, recent log/results, actual stream, root-boundary,
correlated-state and certificate/oracle sources before choosing the question.

## Proved result and scope

`FunctionFieldLittlewood/CorrelatedState.lean` defines

    T(q,k) = (q mod N, min(k,N),
              [R_(q+1+d)(k+i,k+j)]_(d,i,j in Fin 2)).

The relations use the actual rectangular Hankel matrix and all forcing/moment
coordinates from BoundaryRelation. The step function reads only the stored
state and a digit pair. It uses the existing proved natural-index parity merge,
not an assumed recurrence or independently selected child states.

- `half_length` checks exact parity lengths, including zero. `tupleStep_tuple`
  proves all four shift-digit/offset cases and arbitrary size digits. The middle
  shift case uses the even merge; both outer cases use the odd merge and its
  two different root exponents.
- `power_phase` and `tupleStep_phase` prove that root powers depend only on
  q mod N. `size_saturation` proves the capped size update exactly.
- `step_actual` proves step(T(q,k),(epsilon,eta))=T(2q+epsilon,2k+eta).
- `fold_actual` proves the identity for every finite MSB-first digit word.
  `leading_zero` preserves the initial state. `readPair_surjective` constructs
  a common binary word for every nonnegative pair by induction on q+k.
- `reachable_iff` proves BOTH directions: a state is reachable from T(0,0)
  exactly when it is T(q,k) for some q,k. Thus no spurious independent-sibling
  combinations are admitted, and no actual pair is omitted.
- `finiteState` proves the state type finite when the coefficient and coordinate
  types are finite. The implementation stores arbitrary relation predicates;
  this is a classical finiteness proof, not executable canonical subspace
  enumeration or the sharper subspace cardinal bound from the ordinary report.
- `stream_reachable_iff` discharges every recurrence hypothesis for the infinite
  named Lai–Sprang stream via `stream_full_root_data` and its even identity.
  It also supplies an injective complete N-root list. For Lean's parameter r,
  N=2*2^r and N divides p-1; maximal valuation is unnecessary. Lean r=0 includes
  the usual valuation-r=1 comparison.

Generic algebra requires a commutative ring, a finite root-coordinate type,
a weighted odd-root formula, the even recurrence, a squaring map, N>0 and
z^N=1. The target transition identity is a conclusion. No injectivity of the
Hankel map, rank bound, terminal existence, or Proposition 2.3 is assumed.

The raw stream a is used, as in the 20 October Lean merge; Python uses c=a/H.
Their forcing-coordinate rescaling is still an ordinary explanation, not a
newly formalised normalized-stream equivalence. For nonempty m-by-n blocks,
the inclusive final coefficient is t+m+n-2; empty blocks read no coefficient.
No finite truncation or unresolved cutoff enters the proof.

**Not proved here:** no-invisible-kernel/dimension/Lagrangian results, the
terminal-target-to-exact-defect interpretation, a formal acceptance algorithm,
a reachable graph enumeration, the ordinary bound N(N+1)p^(32N^2), or uniform
acceptance. Terminal interpretation still depends ordinarily on Lai–Sprang
Proposition 2.3 and the reverse-lift/dichotomy argument. Neither that literature
claim nor an assumed version of the target is inserted as a Lean axiom.

## Checks and reproducibility

Pins unchanged: Lean 4.35.0; mathlib
56a005855ea17e0b0958f73ec801ae140b0a1679. Inspected and reused mathlib's
Apache-2.0 root-power residue lemma, finite predicate/function/product types,
list folds, and the existing project merge/reindexing. Inspected DFA's fold
semantics; no new automaton library wrapper was needed.

    lake build
    lake env lean verification/CorrelatedStateAudit.lean
    python3 -m unittest discover -s tests -p 'test_*boundary*.py' -v

The default build passed in 7.488 seconds. The new module has no warnings.
The audit passed in 2.429 seconds and reports exact types/axioms for all 15
new theorem/instance declarations; every closure uses only propext,
Classical.choice and Quot.sound (some use fewer). No sorry, added axiom or
native_decide occurs in the new source. The default build replays the existing
Challenge statement placeholder; it is outside these proved closures.

Audit controls cover empty/full parity lengths, carry offsets, saturation,
the known (311,12) paired-word encoding and finite r=1 state type. The 12
existing boundary regressions passed (1.262 seconds command time, 1.154 seconds
reported test time), including independent root-sum matrix and affine checks.
Python 3.14.4 standard library, deterministic, no seed. No Python algorithm,
search range, dependency, or large certificate changed. No expanded witness
search, full-suite rerun, or independent-kernel replay is claimed.

Development compilation exposed missing section-variable inclusion, single-
occurrence rewrites, modular-arithmetic tactic limitations and a nested finite-
instance inference limit. Explicit hypotheses, complete rewrites, the modular
identity and intermediate finite instances resolved these. No mathematical
hypothesis or index formula failed. Final build/audit/regression logs and hashes
are retained in the companion validation JSON. Complete diffs were inspected.

## Literature and next decision

Primary pages and versions accessed 22 October 2026 (Australia/Sydney):

- [Lai–Sprang, 2606.00633v1](https://arxiv.org/abs/2606.00633v1), 30 May 2026,
  and [Proposition 2.3](https://arxiv.org/html/2606.00633v1#S2). The main
  odd-characteristic conjecture is already settled by their theorem.
- [Badziahin–Pavlenkov–Zorin, 2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  22 August 2026: the characteristic-two conclusion remains conditional.
- [Adiceam–Nesharim–Lunnon, 1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2),
  11 October 2020: quadratic-series exclusion; rational series are excluded by
  a denominator multiplier.
- [Garrett–Robertson, 2405.14454v2, Sections 3 and 5](https://arxiv.org/html/2405.14454v2#S5),
  8 April 2025: automatic-wall framework and known unbounded-window discussion.

Scoped arXiv searches for Littlewood characteristic two and Lai–Sprang found
no later relevant resolution. This is not proof of absence or a priority survey.
No characteristic-two candidate was chosen; retired quadratic/unbounded-window
baselines remain retired.

**Next substantive task:** test the proposed square-relation/phase/capped-size
compression for collisions with conflicting continuations among already reached
full tuples. A collision would rule it out; finite agreement would not prove it.
Alternatively derive accepting digit words uniformly in p. The full tuple's
closure and word induction are now formalised; repeating them, exporting more
witnesses, or enumerating the enormous state space is not the next increment.
Choose the next formal lemma from that structural evidence. The outstanding
Proposition 2.3/terminal interpretation is a separate substantial proof project.
