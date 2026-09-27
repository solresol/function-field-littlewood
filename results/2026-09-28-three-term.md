# Three-term Lai–Sprang family: finite attainment and an N=4 exception

28 September 2026, Monday, Australia/Sydney. Clean main at 302575f; origin
`git@github.com:solresol/function-field-littlewood.git` checked, fetched and
fast-forward-only checked (already current). No competing run marker or search
process was found. Read README, TODO, recent reports/log, enumerator, affine
solver, independent root-sum oracle and their tests before choosing this work.

## Result

Test the proposed multiplier R=1-t^(N-1)+t^N at d=N, m=9N+3, where
N=2^v2(p-1). The proposed extension from the earlier p=17 witness to every
r>=2 is **false**: at N=4 its first fractional coefficient is already nonzero.
For the prescribed fields at N=8,...,256, the witness has exact j=2N and defect
N. Those successes are finite evidence only, not an all-r theorem or a global
upper bound on defect.

| p | N | m | three-term j | defect j-N | optimum j at this d,m |
|---|---:|---:|---:|---:|---:|
| 5, 13, 29 | 4 | 39 | 1 | -3 | 4 |
| 41, 73 | 8 | 75 | 16 | 8 | 16 |
| 17, 113 | 16 | 147 | 32 | 16 | 32 |
| 97 | 32 | 291 | 64 | 32 | 64 |
| 193 | 64 | 579 | 128 | 64 | not computed |
| 641 | 128 | 1155 | 256 | 128 | not computed |
| 257 | 256 | 2307 | 512 | 256 | not computed |

All eight displayed optima have independent primal/dual certificates, quantifying
over every normalised degree-N multiplier with both endpoints nonzero at that
particular shift. Nonzero scalar normalisation preserves first indices, so the
same optima apply without normalising the constant coefficient. This is not an
exhaustive search over primes, degrees or shifts. The p=17 record is deliberately
reused as a cross-field family regression, not counted as a new search box.

At N=4, the optimum multiplier returned is 1-t^2-t^3+t^4 with j=4 (defect 0)
in each of the three fields. Thus changing only the degree-four coefficients at
m=39 cannot rescue defect 4 in these fields. This does not contradict the known
degree-zero attainment at a different shift, or refute the auxiliary bound.

There is also a short ordinary explanation of the family failure for **every**
prime with r=2. At m=39, the j=1 coefficient is a_40-a_43+a_44.
The odd parts of 40,43,44 are 5,43,11. The support formula gives a_40=-2,
a_43=a_44=0, so j=1 in every such odd characteristic. This argument is not
formalised in Lean. We do not extrapolate the computed optimal j=4 to every
r=2 prime, nor the successful j=2N pattern to every r>=3.

The six existing r=1 comparisons p=3,7,11,19,23,31 are retained explicitly:
R=1+t^2,m=2,j=6,defect 4=2N. They concern a different multiplier family.
No novelty claim is made for any formula or failure explanation.

## Implementation and evidence boundaries

`search/lai_sprang_three_term.py` adds a sparse exact-prefix evaluator and a
bounded experiment with independently checked readback. The evaluator accepts
sorted distinct exponents, canonical nonzero field coefficients and a nonzero
constant endpoint. It searches j=1,...,limit inclusively; no terminal coefficient
means an unresolved prefix, never an exact first index. It reads no coefficient
past m+d+limit. For the family limit=2N; for r=1 comparisons limit=6.

The JSONL checkpoints each of 17 prescribed inputs. Each record stores its field,
N, degree, shift, cutoff, sparse multiplier, zero-prefix length, exact first index
and terminal value, plus an optional full primal/dual optimum certificate for
N<=32. Larger N carries no optimality claim. The largest inclusive coefficient
index required is 2307+256+512=3075. All inputs resolve within their cutoffs.

Generation uses the simplified odd-part support formula. Independent readback
expands the original rational root sums through `run_rank_experiments.oracle`,
uses dense multiplication for witnesses, and checks dual dot products without
elimination. It verifies complete ordered input coverage and each semantic field.
The summary is recomputed from the JSONL; runtime and diagnostic rank are not
certified. No randomness; Python 3.9.6 standard library only. Generation took
0.024602 seconds, independent readback 0.441491 seconds in the original run.

Source audit confirmed the existing enumerator requires both endpoints nonzero,
normalises r_0=1, records unresolved counts and uses sum_i r_i a_(m+i+j).
The affine solver enforces endpoints and certifies infeasibility through either
an inconsistent linear combination or a forced-zero leading coefficient.
Its independent checker does not certify the diagnostic rank. No changes to
these established semantics were needed.

All **36 Python tests pass**, 3.571 seconds (3.721549 seconds subprocess), including
all 12,871 older box optima, root-sum comparisons and new family checks. New tests
include 512 exhaustive tiny binary stream/multiplier/shift comparisons, sparse
versus dense checks, exact cutoff and inclusive locality checks, 15 record
corruption/coverage controls, invalid sparse inputs, overwrite refusal, and
readback with generation/evaluation/optimisation entry points disabled. The
three saved Lean exports still match (0.090563 seconds). No Lean source or pins
changed; no Lean build or new formal theorem is claimed today. Raw checks and
runtime metadata are in `2026-09-28-validation.json`.

```sh
python3 -m search.lai_sprang_three_term .research/three-term-reproduction.jsonl
python3 -m search.lai_sprang_three_term results/2026-09-28-three-term.jsonl --verify
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
shasum -a 256 -c results/2026-09-28-sha256.txt
```

Fresh generation requires absent JSONL and companion JSON paths. SHA256 manifests
are dated snapshots; historical manifests are not rewritten after document edits.

## Primary literature checked on 28 September 2026

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/html/2606.00633v1)
  (30 May 2026), Theorem 1.2: all odd-characteristic main counterexamples are
  established. Its product bound is 2^(-2N) for P=t. Today's work concerns the
  separate auxiliary N-bound for this particular explicit series.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1)
  (22 August 2026): the abstract still makes its characteristic-two exceptional-set
  conclusion conditional on existence of a counterexample.
- [Robertson, arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955v3)
  (31 October 2025): current version verified; the number-wall dictionary remains
  relevant. Its older list of known characteristics is not the current frontier.

Scoped primary-source searches for “adic Littlewood” with “characteristic two”,
“characteristic 2”, “2026” and “September” found no later characteristic-two
resolution. This is a dated literature-search boundary, not proof of absence.
No characteristic-two candidate or main-conjecture result was produced today.
The quadratic binary baselines retired in the 27 September report remain retired.

## Next useful work

Next computational step: derive or refute the restricted r>=3 identity
`a_(9N+3+j)-a_(10N+2+j)+a_(10N+3+j)=0` for 1<=j<2N,
with terminal -N/2 at j=2N, by a generic support/valuation argument. The terminal
value matches every retained r>=3 record but remains a general conjecture here.
Do not expand the same finite scales as a substitute for this argument.
The all-degree upper bound N remains open within the repository even if that
one-family identity is proved. Next formal step remains the actual Laurent
coefficient bridge, then generic degree-zero support/attainment.
