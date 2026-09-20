# Binary Thue–Morse dyadic witnesses — 21 September 2026

Monday, Australia/Sydney. Started approximately 08:21:51 AEST on clean main
at 4b4be05; verified origin git@github.com:solresol/function-field-littlewood.git,
fetched and fast-forward-only checked (already current). No existing run lock
or active experiment process was found; acquired an exclusive run marker.
Read automation history, README, TODO, research log, recent results and actual
search/checker sources. No applicable filesystem AGENTS.md was found; the
supplied wording instructions apply.

## All-scale result (ordinary proof, not Lean)

Let a_n be the binary digit sum of n modulo 2, including a_0=0, and let
A(t)=sum_{n>=1} a_n t^(-n) over F_2. For every k>=0 put

    L=2^k, R(t)=(1+t)(1+t^L), d=L+1, m=2L-1.

Then R has nonzero constant and leading coefficients and the first nonzero
fractional coefficient of t^m R A is at **j=3L**. Its defect is therefore
j-d=2L-1. This diverges with k, so this particular stream satisfies t-adic
Littlewood and cannot be a counterexample. This conclusion follows from the
proof below, not extrapolation from the retained finite records. No novelty
relative to existing Thue–Morse literature is claimed.

**Adjacent difference.** Adding one to n changes its trailing v_2(n+1) ones
to zeros and changes the preceding zero to one. Hence, modulo 2,

    a_n + a_(n+1) = 1 + v_2(n+1).

This holds also at n=0. Writing n=m+j, the coefficient contributed by R is

    a_n+a_(n+1)+a_(n+L)+a_(n+L+1)
      = v_2(2L+j)+v_2(3L+j)  (mod 2).

If 1<=j<3L and L does not divide j, write j=2^s u with u odd and s<k.
Both 2L+j and 3L+j then have valuation s, so the coefficient is zero.
The remaining j<3L are L and 2L. Their respective valuation pairs are
(k,k+2) and (k+2,k), again giving zero modulo 2. At j=3L the pair is
(k,k+1), giving one. These cases exhaust every positive j<=3L, including
k=0 (where the nondivisible case is empty and the two t terms in R cancel).
This proves the asserted exact index for all scales.

**Product conclusion.** For Q=t^m R, v_t(Q)=m and deg Q=m+d, so with the
repository's base-2 norm convention, |Q| |Q|_t = 2^d. The fractional part
has leading term t^(-3L), giving product 2^(d-3L)=2^(1-2L) -> 0.
This is an ordinary Laurent-series argument; the norm bridge is not yet in
Lean. No claim that j=3L is optimal over every multiplier at these d,m for
all k is needed or made. The finite optimality checks below cover only k<=5.

The proof also applies to the complemented binary stream: replacing every
a_n by a_n+1 adds R(1)=0 to each tested coefficient. This reconciles the
complemented convention in the 1998 paper with this repository's convention.
It does not identify this stream with a signed multiplicative product.

## Exact experiments and source audit

The original Lai–Sprang enumerator uses normalised r_0=1 with nonzero leading
coefficient, searches 1<=j<=limit inclusively, and labels cutoff exhaustion
unresolved. Its coefficient reads end at m+d+limit. The separate affine solver
imposes the same endpoints and can reject a singular prefix whose kernel forces
r_d=0. Independent dot-product checking certifies primal indices and dual
obstructions, not the diagnostic rank. Existing tests cross-check tiny binary
and ternary boxes against exhaustive enumeration. No change to those algorithms
was necessary; the documented r=1 comparisons remain tested.

New `search/thue_morse_dyadic.py` performs a prescribed-family experiment:

- Every k=0,...,12: sparse coefficients of R, m=2L-1, inclusive cutoff 3L;
  13 exact indices, zero unresolved, degrees 2 through 4097 at these scales.
- Largest case: k=12, L=4096, d=4097, m=8191, j=12288, defect=8191.
  Only stream coefficients through the inclusive index m+d+j=24576 are used.
- For k=0,...,5 only, exact affine optimisation over all normalised degree-d
  multipliers at the prescribed shift. All six optima equal the family index;
  independently checked primal and dual certificates are retained.
- Generation uses binary digit counts; verification regenerates coefficients
  recursively with a_(2n)=a_n and a_(2n+1)=a_n+1. Sparse dot products check
  every index, and the existing independent checker checks the small duals.
  Verification calls no elimination and checks completeness of the fixed input
  list. Tests disable the elimination class during saved-certificate readback.
- k=0 is explicitly reduced to support [0,2]. Each completed scale is flushed
  as a JSON checkpoint; incomplete runs fail the completeness check. Existing
  output files are refused. No timeout, randomness or external dependency.

Python 3.9.6, standard library. Runtime including independent readback:
0.096070 seconds. This is not an exhaustive stream, degree or shift search;
only the six small fixed-degree/shift optima quantify over all multipliers.

Commands run from the repository root:

```sh
python3 -m search.thue_morse_dyadic results/2026-09-21-thue-morse-dyadic.json
python3 -m search.thue_morse_dyadic results/2026-09-21-thue-morse-dyadic.json --verify
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
```

All 19 Python tests passed in 1.519 seconds. New tests cover 16,384 adjacent
identities, seven sparse/dense comparisons, inclusive truncation, unresolved
cutoffs, the k=0 cancellation, and ten saved-record mutations (including altered
endpoints, middle support, shifts, indices and duals, and missing/duplicate
scales). Existing tests include all 7,735 earlier primal/dual certificates,
independent root sums and all six r=1 comparisons. Three exported Lean fixtures
still match. No Lean source or toolchain changes; no Lean build was run today,
and no new theorem is claimed as kernel-checked. Observed validation results
are retained in `results/2026-09-21-validation.json`.

## Primary literature check, accessed 21 September 2026

- Lai–Sprang, [arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  30 May 2026: odd characteristic is settled for every irreducible P(t).
- Badziahin–Pavlenkov–Zorin,
  [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1), 22 August 2026:
  the characteristic-two exceptional-set result remains conditional on a
  counterexample. Scoped primary-source searches found no later resolution.
  This describes the sources checked, not proof that no later paper exists.
- Robertson, [arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955v3),
  31 October 2025: current listed version of the number-wall framework.
- Garrett–Robertson,
  [arXiv:2405.14454v2, section 5](https://arxiv.org/html/2405.14454v2#S5),
  8 April 2025: already reports unbounded windows for the binary Thue–Morse
  and paperfolding walls, and points to the 1998 automaticity result. Thus
  today's explicit family is a repository proof/fixture increment, not a claim
  to discover an unknown characteristic-two phenomenon.
- Allouche–Peyrière–Wen–Wen, *Hankel determinants of the Thue-Morse sequence*,
  Ann. Inst. Fourier 48(1), 1–27 (1998),
  [DOI 10.5802/aif.1609](https://www.numdam.org/item/AIF_1998__48_1_1_0/).
  The primary PDF introduction uses e_0=1, complemented relative to a_0=0 here.
  This run did not revalidate the paper's full determinant construction.
- Badziahin, [arXiv:2001.01422v1](https://arxiv.org/abs/2001.01422v1),
  6 January 2020, treats products product_n(1+u t^(-2^n)). The abstract's
  finite-field conclusion is not directly an identification of our digit-parity
  series: over F_2, u=1 makes every product coefficient one, while u=0 makes
  the product constant. Do not substitute that differently encoded stream.

Searches included `Thue Morse t-adic Littlewood conjecture characteristic 2
Laurent series`, `characteristic 2 Littlewood conjecture counterexample 2026
function fields`, and exact named-stream/title queries. Only primary sources
support the literature statements above. No literature theorem or conjecture
for all characteristic-two streams follows from today's calculation.

## Decisions and next work

Retire this Thue–Morse stream as a counterexample candidate, retaining it for
regressions with growing defects. Preserve the all-degree Lai–Sprang N-bound
as an auxiliary hypothesis: today's work adds no evidence for or against it.
Wednesday's useful separate computation remains p=17, d=1,...,16,
m=65,...,256, cutoff 128, with certificates; binary paperfolding/Rudin–Shapiro
recurrences or number-wall profiles remain possible subsequent work.
Tuesday should prioritise polynomial endpoints and scalar normalisation, then
named-stream identities, including the adjacent-difference lemma proved here.
