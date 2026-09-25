# Binary Rudin–Shapiro dyadic family — 25 September 2026

Friday computational run, Australia/Sydney. The proposed family has exact first
index j=5L for every L=2^k, k>=0. Its defect is 2L-1, so the binary pattern-parity
Rudin–Shapiro stream satisfies the t-adic Littlewood condition and is retired as
a counterexample candidate. The all-scale conclusion below is an ordinary
mathematical proof, not an inference from the finite run and not a Lean theorem.
No novelty claim is made. The main characteristic-two frontier and the auxiliary
odd-characteristic Lai–Sprang N-bound remain separate questions.

## Source audit and current literature

Started at approximately 08:20:30 AEST on clean main at cdff75f; origin was
`git@github.com:solresol/function-field-littlewood.git`. Fetch and fast-forward-only
merge found main current. No existing run marker or competing experiment was
found; this run created its own ignored `.research/run.lock`.

Read README, TODO, recent research log/results, and actual enumerator, affine
solver, independent checker, stream oracles and tests. The enumerator normalises
r_0=1 and requires r_d!=0. The affine solver stops at the first inconsistent or
forced-zero-leading-endpoint system; a nontrivial matrix kernel alone is not an
admissible witness. The dot-product checker verifies exact primal coefficients
and the dual obstruction without trusting elimination or the diagnostic rank.
The inclusive last coefficient is m+d+j, or m+d+limit for unresolved output.
Cutoff exhaustion is a labelled vanishing prefix, never an exact first index or
an upper bound. No changes to these existing semantics were needed.

Primary sources accessed **25 September 2026**, with current versions checked:

- Lai–Sprang, [arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  submitted 30 May 2026: the abstract settles failure for every irreducible P(t)
  over every ground field of odd characteristic. That existence search stays retired.
- Badziahin–Pavlenkov–Zorin,
  [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1), 22 August 2026:
  the characteristic-two exceptional-set conclusion remains conditional on a
  counterexample existing. Scoped arXiv searches for Littlewood in characteristic
  two and 2026 t-adic work found no later resolution. This is a search boundary,
  not proof that no other result exists.
- Robertson, [arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955v3),
  31 October 2025: number-wall/Toeplitz framework. No Rudin–Shapiro occurrence
  was found in the HTML text search; no claim of exhaustive coverage follows.
- Garrett–Robertson,
  [arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5),
  8 April 2025: prior discussion includes unbounded binary Thue–Morse and
  paperfolding windows. It is not cited as a proof of today's Rudin–Shapiro family.
- Sobolewski, [arXiv:2204.05287v2, Introduction](https://arxiv.org/html/2204.05287v2#S1),
  17 July 2023: defines the binary variant as parity of possibly overlapping `11`
  occurrences, distinct from the usual signed encoding. This verifies our stream
  convention; its arithmetic-progression results are not Littlewood conclusions.

## Attribution correction added 26 September 2026

The qualitative t-LC conclusion is already a consequence of established results.
Merta, [arXiv:1810.03533v3, §3.1, equation (8)](https://arxiv.org/html/1810.03533v3#S3.SS1),
published in DMTCS 22:1 (2020), gives
(1+x)^5 R^2+(1+x)^4 R+x^3=0 for the complemented binary encoding.
Our generating function B=R+1/(1+x) satisfies the same equation: the two added
terms are both (1+x)^3 and cancel in F_2. Substituting x=t^(-1) preserves
algebraic degree at most two. Rational series satisfy t-LC directly, and
[Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, §7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
recall de Mathan–Teulié's quadratic irrational power-series theorem (2004,
DOI 10.1007/s00605-003-0199-y). Thus no new qualitative t-LC result is claimed.
The proof below remains an independent explicit-family derivation; novelty of
that particular formula or argument has not been established. The earlier
scoped literature search missed this general quadratic-series route. Both
primary texts and the encoding conversion were rechecked on 26 September.

## All-scale proof

Let b(n) in F_2 count the overlapping `11` occurrences in the binary expansion
of n, with b(0)=0. Appending a bit gives

```text
b(2n) = b(n),       b(2n+1) = b(n) + (n mod 2).
```

Fix k>=1 and L=2^k. For q>=0 and 0<=s<L, write s with exactly k bits, padding
with leading zeros. The binary expansion of qL+s consists of q followed by this
block. The only possible new `11` pair crosses their boundary, hence in F_2

```text
b(qL+s) = b(q) + b(s) + (q mod 2) floor(s/(L/2)).                 (1)
```

Leading zeros do not affect the internal count; q=0 also satisfies (1).
Define S_L(n)=sum_{h=0}^3 b(n+hL). Summing (1) for q,q+1,q+2,q+3 cancels
four copies of b(s) and the boundary term, since exactly two of these four
integers are odd. Thus

```text
S_L(qL+s) = C(q),       C(q)=b(q)+b(q+1)+b(q+2)+b(q+3).          (2)
```

For k=0, L=1, (2) holds directly with s=0. Now take

```text
R_L(t) = (1+t)(1+t^L+t^(2L)+t^(3L)),
d = 3L+1,       m = 14L-1.
```

Its constant and leading coefficients are 1 at every scale. For L=1 the middle
terms cancel in F_2 and R_1=1+t^4, still degree 4. Its fractional coefficient at
index j>=1 is S_L(m+j)+S_L(m+j+1). Equation (2) makes this zero unless L divides
j. At j=uL, the two block indices are 13+u and 14+u, so the coefficient is

```text
C(13+u)+C(14+u) = b(13+u)+b(17+u).                             (3)
```

The five required pairs are directly computed from their binary expansions:

| u | b(13+u) | b(17+u) | sum in F_2 |
|---:|---:|---:|---:|
| 1 | 0 | 0 | 0 |
| 2 | 1 | 1 | 0 |
| 3 | 0 | 0 | 0 |
| 4 | 0 | 0 | 0 |
| 5 | 0 | 1 | 1 |

All j<5L therefore vanish and j=5L is nonzero. This proves the exact first
index at **every** k>=0, without any optimality assumption. The defect is
5L-(3L+1)=2L-1. With Q=t^m R_L, the F_2 norm product is 2^(d-j)=2^(1-2L),
which tends to zero. Consequently this stream cannot be a t-adic counterexample.
The same coefficient argument works for the complemented stream: the eight
formal summands cancel any added constant. Reducing the signed sequence
(-1)^b(n) modulo 2 instead gives the constant-one stream and is a different input.

## Bounded exact experiment

`search/rudin_shapiro_dyadic.py` retains all prescribed k=0,...,12 witnesses,
checkpointing after each scale and refusing to overwrite an existing output.
Generation uses the binary-string pattern counter and sparse multiplication.
Independent readback regenerates b through its even/odd recursion and checks
every coefficient through j; it does not use (1)–(3), the pattern counter or
elimination. Only k=0,...,4 additionally have exact affine optimum certificates,
independently verified using primal dot products and inconsistent-system duals.
The optimiser's witness can differ from the prescribed family multiplier.

| k | L | degree | shift | first j | defect | optimality certified? |
|---:|---:|---:|---:|---:|---:|:---|
| 0 | 1 | 4 | 13 | 5 | 1 | yes |
| 1 | 2 | 7 | 27 | 10 | 3 | yes |
| 2 | 4 | 13 | 55 | 20 | 7 | yes |
| 3 | 8 | 25 | 111 | 40 | 15 | yes |
| 4 | 16 | 49 | 223 | 80 | 31 | yes |
| 12 | 4096 | 12289 | 57343 | 20480 | 8191 | no |

The JSON also retains k=5,...,11. All 13 first indices resolve exactly at the
inclusive cutoff 5L. There are no scale exceptions; k=0 requires polynomial
cancellation. The highest requested coefficient index is 22*4096=90112.
This is a prescribed family check, not an exhaustive search over all degrees,
shifts or multipliers. Optimality is established only for the five stated inputs;
no all-scale optimality theorem follows.

Run environment: Python 3.9.6, standard library only, deterministic, seed null.
Generation plus small optimisations took 0.246678s; initial independent readback
0.110007s. JSON records exact timings and all certificates.

```sh
python3 -m search.rudin_shapiro_dyadic .research/rs-reproduction.json
python3 -m search.rudin_shapiro_dyadic results/2026-09-25-rudin-shapiro-dyadic.json --verify
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
shasum -a 256 -c results/2026-09-25-sha256.txt
```

Use an absent path for a fresh generation. The retained test run passed all
27 tests in 2.376s (2.496s subprocess time). New tests check (1) for k=1,...,8,
q=0,...,31 and every low block; (2)–(3)'s unshifted coefficient scaling for
k=0,...,8 and every n<32L; sparse/dense agreement, complement invariance,
inclusive locality and cutoff 5L-1 versus 5L through k=6; malformed scales;
and eleven certificate/input/completeness corruption controls. Saved readback
also passes with generation and elimination disabled.

Existing tests recheck all 7735 original and 5136 extended primal/dual records,
tiny exhaustive enumeration oracles, original Lai–Sprang root sums and the r=1
comparison witnesses. Three existing Lean exports match. No Lean source or pins
changed and no Lean build was run today. This proof is not kernel formalisation.

## Next work and limits

Keep Rudin–Shapiro as a growing-defect regression, and stop searching more scales
as if they could establish boundedness. A useful finite-field follow-up is the
separate Lai–Sprang three-term family R=1-t^(N-1)+t^N,m=9N+3 at other r>=2,
with exact endpoint-aware certificates and explicit failed cases. The known
p=17 instance does not justify a general claim. The all-degree N-bound remains
a hypothesis; the r=1 comparison stays in the regression suite.

On the next Lean day prioritise the actual Laurent coefficient bridge or named
Lai–Sprang stream. Equation (1), followed by the four-block cancellation (2), is
also a specific future formal lemma. No characteristic-two main-conjecture
resolution, global auxiliary N-bound or research novelty is asserted here.
