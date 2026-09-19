# Sunday integration and sharp degree-zero gaps — 20 September 2026

Australia/Sydney, Sunday; started 08:20:39 AEST on clean main at d11a5d2.
Origin: git@github.com:solresol/function-field-littlewood.git. Fetch and
fast-forward-only merge succeeded, already current. No existing run lock was
present; acquired an exclusive marker before edits. Read the prior records,
README, TODO, log, actual enumerator, affine solver, independent checker, exporter
and finite Lean proofs. No applicable filesystem AGENTS.md was found; supplied
wording instructions apply.

## A complete degree-zero result (ordinary mathematical proof)

For the repository's Lai–Sprang stream, let p be an odd prime, r=v_2(p-1)>=2,
and N=2^r. For **every shift m>=0 and every nonzero constant multiplier R**,
the first fractional index exists and satisfies j<=N. Equality occurs at
R=1, m=5N+1. Thus the degree-zero maximum defect over all shifts is exactly N.
This is a consequence of the explicit coefficient formula, not an inference
from finite searches. The argument below has not been formalised in Lean;
no novelty relative to the literature is claimed.

The root-sum expansion of the rational summands gives

    a_n = (N/2)(-1)^h  if oddpart(n)=1+Nh, and zero otherwise.

Indeed, write n=2^k(2l+1). Only this k contributes, with coefficient
sum_{zeta^(N/2)=-1} zeta^l. The roots form a coset of the group of (N/2)-th
roots of unity in F_p. Its power sum vanishes unless (N/2) divides l;
when l=(N/2)h the sum is (N/2)(-1)^h. Since N divides p-1,
N/2 is nonzero in F_p. Hence the support consists exactly of

    n = 2^k(1+Nh),  k,h>=0.

**Upper bound.** Every interval of N consecutive positive integers contains
an integer congruent to 1 modulo N. That integer is odd and supported.
Apply this to m+1,...,m+N. Multiplication by a nonzero constant preserves
nonvanishing, so j<=N for every shift and constant multiplier.

**Attainment.** There is no supported integer strictly between 5N+1 and 6N+1.
To check this, suppose n=2^k(1+Nh) lies in that open interval.

- If h=0, n is a power of two; the entire interval lies strictly between
  the consecutive powers 4N and 8N.
- If h>=1 and k=0, there is no integer 1+Nh strictly between the endpoints.
- If h>=1 and k=1, h<=2 gives n<=4N+2<=5N+1; h>=3 gives n>=6N+2.
- If h>=1 and k=2, h=1 gives n=4N+4<=5N+1 (N>=4);
  h>=2 gives n>=8N+4.
- If h>=1 and k>=3, n>=8(N+1)>6N+1.

All cases are excluded. At n=6N+1 the coefficient is N/2, since h=6.
Consequently a_{5N+2},...,a_{6N} vanish and a_{6N+1} does not: j=N
at m=5N+1. For p=17 this gives **R=1, m=81, j=16**, resolving the
previously unobserved attainment. The product for Q=t^81 is 2^-16 under
the repository's norm convention. Any all-degree bound smaller than N
is therefore impossible. The conjectured all-degree upper bound N remains
unproved; this result covers d=0 only.

## Exact implementation checks

`search/degree_zero_gaps.py` retains seven prescribed witnesses, one for each
r=2,...,8, with primes 5,41,17,97,193,641,257. Inputs are d=0, m=5N+1,
cutoff N; every first index is exactly N. Each record contains the primal
multiplier and an affine dual obstruction. Independent readback uses original
rational root sums and dot products, without Gaussian elimination. Diagnostic
rank is not certified. Maximum inclusive coefficient index is 6N+1=1537.

An exhaustive additional box covers p=17, d=0, m=0,...,128, cutoff 16.
All 129 shifts resolve; maximum index 16, first attained at m=81. Every exact
index is retained and independently regenerated. Seven prescribed cases are
not an exhaustive prime search. All arithmetic is exact; Python standard
library only, no randomness. Runtime including independent checks: 0.146 s
on Python 3.9.6. The output refuses overwrites.

New regressions verify the seven witnesses by root sums, distinguish cutoff
N-1 from exact index N, and reject altered terminal indices, zero duals,
incorrect shift results and incomplete witness lists. The existing r=1
comparison remains: R=1+t^2, m=2 gives defect 4=2N for p=3,7,11,19,23,31.

Source audit reconfirmed that the enumerator tests both endpoints and the
inclusive cutoff. The affine solver fixes R_0=1, enforces R_d!=0, and records
cutoff exhaustion as unresolved. The independent checker validates the primal
and dual identities, not rank. Lean's existing optimality statement fixes d,m
and normalisation; it does not imply a uniform all-degree bound.

## Weekly evidence and retired directions

- The 914,975 enumerated pairs and 7,735 certified degree/shift optima remain
  finite results. The saved maxima and boxes are unchanged; the new p=17
  witness lies outside the old shift range 0,...,64.
- Three saved certificates, not all 7,735, have Lean instantiations. Their
  arbitrary-tail extension theorems do not identify named infinite streams.
- Binary maxima 15,8,7 for the three recorded streams are finite baselines.
  No characteristic-2 main-conjecture counterexample has been established here.
- Retain the explicit retirement of the odd-characteristic main-conjecture
  search and of the r=1 auxiliary N-bound. A degree-zero bound of 15 for p=17
  is excluded by m=81; 15 remains the correct maximum for the old box.
- Replace further degree-zero shift searches with positive-degree work and
  characteristic-2 dyadic recurrence experiments. Formalise the named stream
  and this degree-zero lemma after the scalar/degree bridges.

## Primary sources rechecked (accessed 20 September 2026)

- Lai–Sprang, [arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  30 May 2026; only v1 listed. [Theorem 1.2 and equation 1.1](https://arxiv.org/html/2606.00633v1)
  give the series and the odd-characteristic theorem; the stated lower bound
  for P=t corresponds to defect 2N.
- Badziahin–Pavlenkov–Zorin,
  [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1), 22 August 2026;
  only v1 listed. Its characteristic-two conclusion still assumes a
  counterexample exists.
- Robertson, [arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955v3),
  31 October 2025; latest listed version. The abstract gives the
  number-wall/Toeplitz-determinant formulation.

Searched both `"Littlewood conjecture" "characteristic two" site:arxiv.org`
and `"Littlewood conjecture" "characteristic 2" site:arxiv.org`, plus broader
2026 and Thue–Morse queries. No later characteristic-two resolution was found
in the searched primary sources. This is a scoped check, not proof of absence.

## Reproduction and validation

Run from the repository root (choose a fresh path for generation):

```sh
python3 -m search.degree_zero_gaps .research/degree-zero-reproduction.json
python3 -m search.degree_zero_gaps results/2026-09-20-degree-zero-gaps.json --verify
python3 -m unittest discover -s tests -v
python3 -m search.run_rank_experiments results/2026-09-18-rank-search.jsonl --verify
python3 -m search.export_lean_certificates --check
lake build
```

Detailed exit codes, timings and output are retained in
`2026-09-20-validation.json`; a SHA256 manifest covers today's changed sources
and supporting records. Lean/mathlib pins are unchanged at 4.27.0; no new Lean
theorem or dependency is introduced by this increment.

All 15 Python tests passed (1.215 s test runtime); independent readback of all
7,735 prior certificates and all new records passed. The three generated Lean
fixtures still match. `lake build` succeeded with 1,129 jobs (cached/replayed,
4.874 s wall time); all 18 axiom reports contain only propext, Classical.choice
and Quot.sound. No sorry, added axiom or native_decide occurs in project Lean
sources. Both 18 and 19 September hash manifests pass (19 entries total).
