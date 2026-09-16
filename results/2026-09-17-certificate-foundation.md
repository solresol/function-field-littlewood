# 2026-09-17 — finite certificate foundation (Thursday, Australia/Sydney)

## Repository reconciliation

Started from clean `main` at `bd637f195e71b8d9fde9f1b7a0bd6b3ae010283f`, with
origin `git@github.com:solresol/function-field-littlewood.git`. Fetch and
fast-forward-only merge reported already up to date. No other active search or
Lean build was observed. There was no applicable on-disk AGENTS.md, TODO,
research log, test suite, Lean project or prior automation memory.

The only historical research record was `results/2026-09-14-literature-update.md`.
The README's linked bound-search result did not exist. The Python source did
exact enumeration, not its advertised Gaussian elimination. Prior numerical
claims were therefore unverified historical claims until this fresh run.

## Current primary literature

Access date for all sources: **17 September 2026 AEST**.

- Lai–Sprang, [arXiv:2606.00633v1](https://arxiv.org/html/2606.00633v1),
  submitted 30 May 2026; the abstract page lists only v1. Theorem 1.2 covers
  every irreducible polynomial over every odd-characteristic ground field and
  gives the lower bound `2^(-2N deg P)`. This settles the odd-characteristic
  main conjecture negatively; the auxiliary `N` bound remains a separate question.
- Badziahin–Pavlenkov–Zorin,
  [arXiv:2608.22078v1](https://arxiv.org/html/2608.22078v1), submitted
  22 August 2026; the abstract page lists only v1. Its abstract explicitly makes
  the characteristic-two Hausdorff-measure conclusion conditional on the
  existence of a counterexample. This supports retaining characteristic 2 as
  the finite-field research frontier.
- Garrett–Robertson, [arXiv:2405.14454v2](https://arxiv.org/abs/2405.14454v2),
  8 April 2025: the abstract describes computational constructions in small
  odd characteristics; its conjectural picture excludes characteristic 2.
- Robertson, [arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955v3),
  31 October 2025; version of record
  [Mathematika 72, e70064](https://londmathsoc.onlinelibrary.wiley.com/doi/full/10.1112/mtk.70064),
  online 12 December 2025. Provides the number-wall/Diophantine dictionary.

Searches included `"Littlewood" "characteristic 2" function field 2026`,
`"P(t)-adic" "characteristic" Littlewood 2026`, and
`"t-adic Littlewood" "characteristic two"`. No later primary-source resolution
was found. This is a dated search result, not an exhaustive literature theorem.

## Audited search semantics

For `R=(r_0,...,r_d)`, the coefficient at fractional index `j>=1` is

```
b_j = sum_{i=0}^d r_i a_{m+i+j} mod p.
```

A certificate of exact index `j` requires **every** `b_1,...,b_(j-1)=0`
and `b_j!=0`. Both `r_0` and `r_d` must be nonzero modulo `p` so that the
shift and degree are actual. Normalising `r_0=1` enumerates every admissible
multiplier up to nonzero scaling; it is not a monic normalisation.

The matrix for `L` vanishing equations has entries
`H[row,i]=a_(m+i+row+1)` for `0<=row<L`. This is Hankel (constant along
anti-diagonals). An exact solver must find a kernel vector with both endpoints
nonzero, or solve the affine system obtained by fixing `r_0=1` and still
requiring `r_d!=0`. Rank deficiency alone is insufficient: a kernel may lie in
an endpoint coordinate hyperplane. In particular, over F_2 one must not infer
endpoint feasibility merely from a generic-field heuristic.

There is **no rank solver** in this increment. Lean proves the exact equivalence
between the matrix kernel equations and the zero prefix. It does not prove
an algorithm for rank or feasibility.

The original search silently skipped `None` after cutoff 10,000. It now reports
`checked`, `unresolved`, `first_unresolved` and `limit`; `best` is only over
resolved cases. No whole-box bound follows if any cases remain unresolved.
A zero prefix of length `L` shows an index at least `L+1` **if one exists**;
it must not be reported as an exact index. The API now rejects characteristic
2/composite moduli for this odd-characteristic construction, nonpositive
cutoffs, negative shifts/degrees and zero endpoint coefficients.

## Formal increment and proof boundary

- Generic coefficient stream and finite multiplier over a commutative semiring.
- `hankel_mulVec`, `hankel_kernel_iff`: matrix/zero-prefix correspondence.
- `certificate_sound`, `checkCertificate_sound`: an exact finite certificate
  or accepted Boolean checker entails the semantic first nonzero index.
- `fractionalCoeff_congr_prefix`, `certificate_congr_prefix`: agreement of input
  streams through **inclusive index `m+d+j`** suffices. Thus one needs an array
  of length `m+d+j+1` if index zero is stored.
- Kernel-checked F_2 fixture: `a_1=a_2=a_3=1`, `a_n=0` for `n>=4`,
  `R=1+t`, `m=0`, `j=3`. This finite-support example has no claimed
  counterexample significance. Incorrect indices and zero endpoints are rejected.
- Kernel-checked F_3 prefix fixture:
  `a_[0..10]=[0,1,1,2,1,1,2,2,1,1,1]`, `R=1+t^2`, `m=2`, `j=6`.
  `comparison_first_of_prefix` transfers this certificate to any stream
  agreeing through index 10. Python checks the Lai–Sprang coefficient formula
  against independent root-sum expansion, but the infinite stream identification
  has **not** been formalised. Neither polynomial degree nor Laurent norms
  have yet been connected to these coefficient definitions in Lean.

The mathematical increment is finite certificate soundness and prefix locality,
not a new solution of the main conjecture or the auxiliary sharp bound.

## Exact computation and independent checking

`python3 search/lai_sprang_finite_search.py` produced
`results/2026-09-17-exact-search.json` in **5.639 seconds**, Python **3.9.6**,
standard library only, no randomisation/seed. All ranges are inclusive;
cutoff `j<=10000` for every multiplier.

| p | N | d max | m max | checked | unresolved | max j-d | witness (R,m,j) |
|---|---|---|---|---:|---:|---:|---|
| 5 | 4 | 5 | 24 | 78,125 | 0 | 4 | ([1],21,4) |
| 13 | 4 | 4 | 24 | 714,025 | 0 | 4 | ([1],21,4) |
| 17 | 16 | 3 | 24 | 122,825 | 0 | 15 | ([1],17,15) |

The count in each box is `(mmax+1)*p^dmax`, totalling **914,975** pairs.
No violation of `j-d<=N` occurs in these boxes. This remains finite evidence.
For `p=3,7,11,19,23,31`, the retained `r=1` comparison has `(R,m,j)=([1,0,1],2,6)`
and defect 4. Those primes attain the published `2N` bound.

`python3 -m unittest discover -s tests -v` passed all six tests in **0.041 s**.
The independent coefficient oracle expands the original rational summands by
summing powers of roots `zeta^(N/2)=-1` in F_p; it does not reuse the simplified
support/sign formula. It checks indices 1–256 for primes
`3,5,7,11,13,17,19,23,31,41` (2,560 coefficients), retained witnesses, deliberately
wrong indices/endpoints, cutoff exhaustion and scalar invariance. This checks
selected certificates independently, not every enumerated candidate via a second
search algorithm.

## Build and dependencies

Lean **4.27.0**, mathlib tag **v4.27.0**, commit
`a3a10db0e9d66acbebf76c5e6a135066525ac900`. Transitive commits are pinned in
`lake-manifest.json`; no local sibling project is a dependency. Inspected
mathlib's `Data/Matrix/Mul.lean` (`dotProduct`, `Matrix.mulVec`) and
`Data/ZMod/Basic.lean`, and its Apache-2.0 licence, before importing. The pinned
Lean distribution also carries Apache-2.0 licensing. No dependency source is
copied into the project.

Setup:

```sh
MATHLIB_NO_CACHE_ON_UPDATE=1 lake update
lake exe cache get Mathlib.Data.ZMod.Basic Mathlib.Data.Matrix.Mul
/usr/bin/time -p lake build
```

A first cache command using repository-relative `Mathlib/...` paths failed;
module-name arguments succeeded (1,108 cached files unpacked). The initial build
found missing vector literal notation imports in the examples; replacing those
literals with explicit functions fixed it. The successful build completed all
1,127 jobs in **11.85 seconds** (warm dependencies and the already-built generic
certificate module). The output is retained in
`results/2026-09-17-lean-build.txt`.

The seven explicit `#print axioms` reports contain only the standard Lean axioms
`propext`, `Classical.choice`, and `Quot.sound`; no `sorryAx`, added axiom,
`native_decide`, or assumed version of a research target is used.

## Next informative work

Implement exact affine feasibility with nonzero endpoints and compare every
small instance against enumeration before widening any box. Use arbitrary
coefficient streams so binary candidates can share the verified indexing.
On the next Lean day, prove the polynomial-degree and Laurent-coefficient bridge
and formalise identification of the recorded Lai–Sprang prefix.
