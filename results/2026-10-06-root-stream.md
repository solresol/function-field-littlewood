# Root enumeration and the named odd subsequence in Lean

6 October 2026, Tuesday, Australia/Sydney (AEDT).
Classification: **verification/infrastructure progress** on the auxiliary
all-degree bound. No new mathematical bound, characteristic-two result,
publication novelty or first-formalisation claim.

## Question and decision

The question stated before implementation was whether Lean could prove

    a_(2u+1) = sum_(z^H=-1) z^u,    H=N/2,

for the actual support-formula stream, with a proved uniform enumeration of
all H roots. This supplies the odd-row identity in the 2 October ordinary
parity-descent proof. Previously the moment rigidity theorem took the root
list and moment equations as hypotheses. Success removes the root-formula
obligation; the parent-window cross-convolution and its precise row budgets
remain the next essential formal step toward the all-shift degree cutoff.

## Kernel-checked increment

`FunctionFieldLittlewood/RootStream.lean` proves:

- A primitive N-th root exists in F_p whenever N divides p-1, using cyclicity
  of the finite field's unit group and taking a power of its generator.
- For a primitive 2H-th root xi, the H elements xi^(2i+1), 0<=i<H, are
  distinct, satisfy z^H=-1, and exhaust the roots. Completeness follows from
  the existing monic root-product theorem, not an assumed root count.
- Their u-th power sum is H*(-1)^(u/H) if H divides u, and zero otherwise.
  The divisible case uses z^H=-1; the other case uses a geometric sum and the
  exact order H of xi^2. This includes H=1 and u=0.
- The named support stream's odd coefficient has exactly that formula.
  `stream_root_enumeration` combines enumeration, completeness and the
  coefficient identity, with no root-list or root-formula hypothesis.
- `stream_filtered_root_enumeration` supplies, for every polynomial P and n>=0,

      sum_(j=0)^deg(P) P_j a_(2(n+j)+1) = sum_i z_i^n P(z_i).

  This is the E_P(n) identity used in the cross-convolution. The sum includes
  the last index 2(n+natDegree P)+1. It is also valid for P=0; Lean's
  natDegree-zero convention contributes a zero coefficient in that case.
  It makes no constant/leading-endpoint assumption and no finite truncation.

The Lean parameter is `r+1` in `laiSprangStream p (r+1)`: H=2^r and
N=2^(r+1). The only arithmetic hypothesis is N dividing p-1, besides primality.
This is weaker than requiring N to be the largest power of two dividing p-1.
That maximality condition is needed for the later nonsquareness argument,
not for this coefficient identity. The r=1 comparison in the repository's
usual notation corresponds to Lean's r=0 here and remains included.

The argument formalises standard root sums underlying Lai–Sprang's functional
equation. It does not identify the entire infinite sum of rational Laurent
series with the support stream: it proves the exact coefficient identity
needed for descent. The existing even-index identity is unchanged.

## Verification and reproducibility

Run `lake build` from the repository root. The new module is imported by the
root library target. Full build output is retained in
`results/2026-10-06-lean-build.txt`; exact elapsed time, axiom audit and source
hashes are in `results/2026-10-06-validation.json`.

Lean and mathlib remain pinned to v4.27.0, mathlib commit
`a3a10db0e9d66acbebf76c5e6a135066525ac900`. Inspected the actual Apache-2.0
mathlib sources for primitive roots, finite-field cyclicity, geometric sums
and polynomial evaluation before reuse. No dependency or toolchain change.
Every new theorem has a `#print axioms` report. The final full build passed 2,214 jobs in 18.452428167 seconds without
warnings. All 95 axiom reports (10 new) use only propext, Classical.choice
and Quot.sound; the project-wide proof-bypass scan was clean. No assumed target, project axiom, native
computation bypass or unfinished proof is accepted.

No finite search, input box, random seed, solver change or certificate export.
Python tests were not rerun because no Python source or stored certificate
changed. Generic kernel proofs quantify over every input in their stated
hypotheses; they do not extrapolate from finite agreement. Initial elaboration
failures concerned a positivity proof and multiplication order; both were
resolved. A redundant positivity parameter was removed after the first
successful build, then the complete library was rebuilt.

## Literature and limits

Primary sources accessed 6 October 2026:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  submitted 30 May 2026, still the version listed by arXiv. Its
  [functional equation and Section 3](https://arxiv.org/html/2606.00633v1)
  supply the root-sum/parity method. The odd-characteristic main-conjecture
  existence question stays settled by their theorem.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  submitted 22 August 2026, still explicitly conditions its characteristic-two
  conclusion on counterexample existence. This run refreshed that source,
  rather than conducting a comprehensive frontier or novelty search. No new
  binary candidate was proposed or searched; the retired streams stay retired.

The full parent-window-to-moments implication, leading-child degree/shift
calculation and iterated d<N(N-1) cutoff are still not Lean theorems. The
ordinary 5 October terminal equivalence and N-or-2N dichotomy remain unchanged;
this run does not choose a branch or constrain the residual scalar C.

Next formal step: combine this root formula and even-index invariance with
polynomial parity splitting, then prove the cross-convolution and exact row
budgets supplying H moments to `geometric_parity_forced_factor`. Do not repeat
the root enumeration. Next computational question remains the original
odd-shift terminal rows with C nonzero and quotient coprime to t^N+1.
