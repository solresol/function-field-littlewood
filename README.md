# Function-field P(t)-adic Littlewood research

This repository tracks computational and formal work around the function-field `P(t)`-adic Littlewood conjecture.

## Status update (23 Sep 2026)

The original plan for this project was to focus on odd characteristics `ell = 1 (mod 4)`. That frontier has moved: Li Lai and Johannes Sprang, *On the P(t)-adic Littlewood conjecture in odd characteristics*, arXiv:2606.00633 (submitted 30 May 2026), prove that the conjecture fails for every irreducible `P(t)` over every ground field of odd characteristic.

Their explicit counterexample is built from

```text
r = v_2(p-1),   N = 2^r,
Lambda(t) = sum_{k>=0} sum_{zeta^(N/2)=-1}
              t^(2^k)/(t^(2^(k+1)) - zeta).
```

For the coefficient `a_n` of `t^(-n)` this simplifies to

```text
a_n = (N/2) (-1)^h   if oddpart(n) = 1 + N h,
      0               otherwise,
```

in `F_p`.  This is convenient for exact computation: no finite-field extension or rational-function arithmetic is needed to generate the series.

The remaining finite-field frontier appears to be characteristic 2. This was rechecked on 23 September 2026: Badziahin--Pavlenkov--Zorin, [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1), still make their characteristic-two exceptional-set conclusion conditional on the existence of a counterexample. No later resolution was found in the primary-source search; this is an evidence boundary, not a proof of absence. Robertson's number-wall reformulation gives a combinatorial route to the remaining questions.

## Current computational question

Lai--Sprang prove a uniform positive lower bound for the Littlewood product. Their argument gives a defect bound corresponding to `2N`, where `N=2^r`. The first experiment in this repository asks whether the explicit `Lambda` has a sharper bound when `r>=2`.

Write `Q=t^m R`, with `R(0) != 0`, `deg R=d`, and let `j` be the first non-zero coefficient of the fractional part of `t^m R Lambda`. The Littlewood product is `2^(d-j)`. Thus a lower bound `2^(-B)` is equivalent to

```text
j - d <= B.
```

The search in `search/lai_sprang_finite_search.py` exhaustively enumerates coefficient vectors over `F_p`, normalised by `r_0=1`, to look for violations of the candidate strengthening

```text
j - d <= N   (r >= 2).
```

The verified 17 September run finds no violation in the boxes below. The analogous strengthening is false for the tested `r=1` primes `3,7,11,19,23,31`: `R(t)=1+t^2`, `m=2` gives `j=6` and defect `4=2N`. This supplies exact witnesses attaining the published bound in these cases.

| p | N | degree range | shift range | pairs checked | max defect |
|---|---|---|---|---:|---:|
| 5 | 4 | 0–5 | 0–24 | 78,125 | 4 |
| 13 | 4 | 0–4 | 0–24 | 714,025 | 4 |
| 17 | 16 | 0–3 | 0–24 | 122,825 | 15 |

All indices were resolved within cutoff 10,000; finite agreement is not a global bound. Exact witnesses, runtime and counts are in `results/2026-09-17-exact-search.json`; the audit is in `results/2026-09-17-certificate-foundation.md`.

The first-run audit found that the formerly linked 14 September bound-search report was absent and the advertised Gaussian elimination was not implemented. Those historical computation claims had no retained output. The table above is a new reproducible run; the endpoint-aware rank solver was added on 18 September (below). Cutoff exhaustion now increments an explicit unresolved count instead of disappearing from the result.

## Endpoint-aware rank experiments (18 September)

`search/finite_rank.py` now works with arbitrary prime-field coefficient streams,
including characteristic 2. It optimises the vanishing prefix over all normalised
multipliers at each degree and shift using exact affine elimination. Both endpoints
are enforced. Each resolved result includes a multiplier and a dual linear
combination proving that no admissible multiplier can vanish one coefficient
further. A separate dot-product checker verifies both without elimination.
Cutoff exhaustion remains an unresolved prefix, never an exact index.

For **every degree 0–16 and shift 0–64**, with cutoff 128:

| stream | field | maximum defect | auxiliary N |
|---|---|---:|---:|
| Lai–Sprang | F_5 | 4 | 4 |
| Lai–Sprang | F_13 | 4 | 4 |
| Lai–Sprang | F_17 | 15 | 16 |
| Lai–Sprang | F_41 | 8 | 8 |
| Thue–Morse | F_2 | 15 | — |
| regular paperfolding | F_2 | 8 | — |
| Rudin–Shapiro | F_2 | 7 | — |

All 7,735 degree/shift optima have independently checked primal and dual
certificates, with no unresolved cases. Binary stream conventions, exact witnesses,
commands and limits are in `results/2026-09-18-rank-experiments.md`; all certificates
are retained in JSONL. The odd-characteristic boxes support the auxiliary bound
only finitely; that p=17 box does not attain N (a later witness below does). The binary streams are baseline
experiments, not established main-conjecture counterexamples. No infinite bounded
or unbounded defect conclusion follows from these boxes alone. The later
Thue–Morse recurrence proof below rules out that particular stream.

```sh
python3 -m search.run_rank_experiments /tmp/littlewood-rank-search.jsonl
python3 -m search.run_rank_experiments results/2026-09-18-rank-search.jsonl --verify
```

The run refuses to overwrite an existing output JSONL. It checkpoints each degree.
Python 3.9+ standard library only; deterministic, with no random seed.

## Degree-zero sharp constant (20 September)

For every odd prime with r>=2, the degree-zero maximum defect over **all shifts**
is exactly N. Every N consecutive indices contain a nonzero coefficient at an
index congruent to 1 modulo N. Conversely, the support formula gives N-1 zeros
immediately after m=5N+1, followed by a nonzero coefficient: R=1 attains j=N.
An elementary proof, not yet formalised in Lean, is in
`results/2026-09-20-sunday-integration.md`.

In particular, p=17 attains defect 16 at m=81, outside the old shift box.
Seven prescribed witnesses for r=2,...,8 and all 129 degree-zero shifts m<=128
for p=17 pass independent root-sum checks; exact certificates are retained in
`results/2026-09-20-degree-zero-gaps.json`. This settles only degree zero.
The auxiliary all-degree upper bound N and characteristic-2 main frontier
remain separate unfinished questions. No novelty claim is made.

```sh
python3 -m search.degree_zero_gaps results/2026-09-20-degree-zero-gaps.json --verify
```

## Binary Thue–Morse baseline retired (21 September)

For the stream a_n = binary digit sum of n modulo 2, let L=2^k for any k>=0.
The multiplier R=(1+t)(1+t^L), with d=L+1 and m=2L-1, has first nonzero
fractional index j=3L. Thus its defect is 2L-1, unbounded with k, and its
Littlewood product is 2^(1-2L), tending to zero. This stream therefore satisfies
the t-adic Littlewood condition; it cannot be a counterexample.

The all-scale conclusion follows from a binary-carry proof, **not** finite
agreement. The proof is not yet formalised in Lean, and no novelty is claimed:
prior number-wall literature already describes unbounded Thue–Morse windows.
The current characteristic-2 main frontier remains separate and unresolved in
the primary sources checked. The auxiliary odd-characteristic N-bound is unchanged.

`search/thue_morse_dyadic.py` retains exact sparse witnesses for k=0,...,12
(maximum defect 8191) and independently checked affine optimality certificates
for k=0,...,5 only. At k=0 the two t terms cancel, giving R=1+t^2.
The report `results/2026-09-21-thue-morse-dyadic.md` gives the proof, input ranges,
source versions, independent checks and limitations. Thue–Morse remains useful
as a growing-defect regression fixture, rather than a candidate to search further.

```sh
python3 -m search.thue_morse_dyadic results/2026-09-21-thue-morse-dyadic.json --verify
```

## Extended positive-degree and binary boxes (23 September)

All 5,136 new degree/shift optima have independently checked primal/dual
certificates, with no unresolved inputs at cutoff 128:

- Lai–Sprang F_17, d=1,...,16 and m=65,...,256: maximum defect 16=N.
  R=1-t^15+t^16 at m=147 has exact j=32, giving positive-degree attainment.
  No violation of the auxiliary bound occurs in this finite box.
- Binary Rudin–Shapiro, d=17,...,32 and m=0,...,128: maximum defect 15.
  R=(1+t)(1+t^8+t^16+t^24) at m=111 has j=40. The earlier box maximum
  was 7. These witnesses suggest a dyadic family, but prove no infinite bound
  or unboundedness and do not resolve the characteristic-2 main conjecture.

`results/2026-09-23-extended-rank.md` records exact witnesses, profiles, literature
boundaries and reproducible checks. JSONL retains every certificate; independent
readback checks completeness and regenerates coefficients without elimination.

```sh
python3 -m search.extended_rank_boxes results/2026-09-23-extended-rank.jsonl --verify
```

## Verified finite certificate foundation

`FunctionFieldLittlewood/Certificate.lean` defines coefficient streams, shifted multiplication, a Hankel matrix, and an exact-index certificate. It proves that the zero-prefix equations equal a matrix kernel condition, that an accepted certificate gives the first nonzero index, and that only coefficients through `m+d+j` affect the certificate. Both constant and leading multiplier coefficients must be nonzero.

`FunctionFieldLittlewood/Examples.lean` includes kernel-checked examples over `ZMod 2` and `ZMod 3`, plus invalid-index and invalid-endpoint controls. The binary example is a finite infrastructure fixture, not a main-conjecture candidate. The ternary example checks a recorded prefix; its identity with the infinite Lai–Sprang stream is tested independently in Python, not proved in Lean. No Laurent-series norm theorem or global sharp bound has been formalised.

`FunctionFieldLittlewood/DualCertificate.lean` now proves soundness of both dual
obstruction formats and of a combined primal/dual checker. Acceptance proves an
attained first index j and a nonzero coefficient by j for **every normalised**
multiplier at the fixed degree and shift. Tail replacement beyond m+d+j preserves
acceptance. This proof uses finite sums; it does not trust the solver or its rank.

`SavedCertificates.lean` kernel-checks three exported records: the Thue–Morse
F_2 case (d,m,j)=(9,15,24), an F_2 forced-endpoint obstruction, and the Lai–Sprang
F_17 degree-zero gap (0,17,15). Each theorem applies to every stream agreeing
with its recorded prefix; identification with the named infinite stream remains
a Python check, not a Lean theorem. Only these three saved records have been
instantiated in Lean, not all 7,735 records. Details and limits are in
`results/2026-09-19-dual-certificate-soundness.md`.

## Polynomial endpoints and scalar normalisation (22 September)

`Normalisation.lean` proves over every field that nonzero scalar multiplication
preserves exact certificates and first nonzero indices. Dividing by the constant
coefficient gives constant term 1 without changing the leading endpoint.
The new `checkOptimalCertificate_sound_all` therefore bounds **all multipliers
with both endpoints nonzero**, removing the normalisation restriction from the
semantic conclusion of the existing checker.

`PolynomialBridge.lean` assembles vectors as mathlib polynomials, recovers every
coefficient, proves the actual degree from the leading endpoint, and excludes
an X factor from the nonzero constant term. Every polynomial of degree at most d
is reconstructed from its vector. `optimal_polynomial_nonzero` consequently
bounds the finite coefficient sum for every degree-d polynomial with nonzero
constant term. This includes degree zero and characteristic two.

`BridgeExamples.lean` checks nontrivial F_3 scaling, rejection of zero scaling,
degree-zero endpoints, and the saved F_2/F_17 optima with polynomial quantifiers.
These are kernel-checked finite statements. The actual Laurent-series product,
norm exponent and named infinite-stream identities are still unformalised;
no global auxiliary bound or characteristic-2 counterexample follows. See
`results/2026-09-22-polynomial-normalisation.md` for validation and source details.

Lean and mathlib are pinned to `v4.27.0`; `lake-manifest.json` records exact dependency commits. The imported mathlib matrix and modular-arithmetic sources and their Apache-2.0 licence were inspected before reuse.

```sh
# First setup (requires elan, Git and network access)
MATHLIB_NO_CACHE_ON_UPDATE=1 lake update
lake exe cache get Mathlib.Data.ZMod.Basic Mathlib.Data.Matrix.Mul
lake build

# Python 3.9+ standard library only; no random seed
python3 search/lai_sprang_finite_search.py
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
```

The original tests independently expand the original root sums for 2,560 coefficients and check saved witnesses. They also check that a cutoff is unresolved, scalar normalisation preserves the index, and malformed inputs are rejected.

## Near-term programme

See `TODO.md` for the current roadmap and `RESEARCH_LOG.md` for dated records. Next: formalise named stream identities and the Laurent-series coefficient bridge; scalar normalisation and polynomial endpoints are now proved. Computationally, test and derive the proposed binary Rudin–Shapiro dyadic recurrence; the planned positive-degree p=17 box is now checked, and the Thue–Morse dyadic family is settled. See the roadmap for precise next experiments.

## References

- Li Lai and Johannes Sprang, *On the P(t)-adic Littlewood conjecture in odd characteristics*, arXiv:2606.00633 (2026).
- Faustin Adiceam and Dzmitry Badziahin, *On the P(t)-adic Littlewood Conjecture in Characteristics ell congruent 3 mod 4*, arXiv:2509.12826 (2025).
- Samuel Garrett and Steven Robertson, *Counterexamples to the p(t)-adic Littlewood Conjecture Over Small Finite Fields*, Mathematics of Computation (2025), DOI 10.1090/mcom/4104.
- Steven Robertson, *Combinatorics on number walls and the P(t)-adic Littlewood conjecture*, Mathematika 72 (2026), e70064, DOI 10.1112/mtk.70064.
