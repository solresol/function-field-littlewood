# Actual Laurent coefficient bridge — 29 September 2026

Tuesday, Australia/Sydney. This increment is Lean formalisation, not an expanded
finite search. Started at approximately 08:22 AEST on clean main at
6a716107a873d46e565248cd3b602bcb8c3a4e5e. Origin is
`git@github.com:solresol/function-field-littlewood.git`; fetch and fast-forward-only
merge were current. No prior run lock or competing project process was present.
The user-supplied AGENTS instructions were applied; no additional repository or
ancestor AGENTS.md was found outside dependencies. An exclusive run marker was
created before edits.

## Mathematical statement and scope

Write x=t^(-1). For any commutative semiring K and stream a:N→K, define A as
mathlib's power series with coefficients a, embedded in `LaurentSeries K`.
For a finite vector R indexed by Fin(d+1), define the Laurent multiplier
M=sum_i R_i x^(-i). The new theorem `shiftedLaurent_coeff` proves, for all
natural m,j (including zero),

```text
[x^j] (x^(-m) M A) = sum_i R_i a_(m+i+j).
```

The proof uses actual Hahn/Laurent multiplication, distributing over the finite
multiplier and applying mathlib's single-monomial coefficient theorem. It does
not postulate a coefficient law. `multiplierLaurent_eq_eval` identifies M with
evaluation of the earlier actual polynomial at x^(-1), over every field.

`LaurentFirstPositive` specifies the first nonzero strictly positive x-index.
It is equivalent to the previous `FirstNonzero`, so exact certificates transfer
to actual Laurent products. The existing Hankel-kernel equations likewise become
actual coefficient-vanishing statements. Primal/dual certificates yield the
fixed-degree/shift upper bound for every multiplier with nonzero endpoints;
`optimal_laurent_polynomial` states it directly for every genuine degree-d
polynomial with nonzero constant coefficient. No diagnostic rank is trusted.

`LaurentExamples.lean` transfers three previously proved named-stream results:

| Field and stream | d | m | exact positive j | Additional formal conclusion |
|---|---:|---:|---:|---|
| F_2 digit-parity Thue–Morse | 9 | 15 | 24 | every degree-nine polynomial with nonzero constant term has a nonzero positive coefficient by 24 |
| F_17 Lai–Sprang support formula | 0 | 81 | 16 | exact sharp witness R=1 |
| F_3 Lai–Sprang r=1 support formula | 2 | 2 | 6 | preserved comparison R=1+t^2 |

Five kernel-checked controls cover the sign of the shift (a_3 shifted by t^2
appears at x^1), unused a_0 with arbitrary positive index, rejection of j=0,
and the F_17 zero/nonzero boundary at indices 15/16. The named streams are
infinite definitions; the proofs are not statements about zero-padded tails.

The full product can have negative powers of x. Its order must not be equated
to j. The strictly positive fractional-part series, its order, the chosen norm,
and the Littlewood-product exponent remain further formalisation tasks. The
Lai–Sprang support series has not been identified in Lean with the original
infinite root-sum expression. The all-shift degree-zero theorem is still an
ordinary proof only; the all-degree auxiliary N-bound is still a hypothesis.
No characteristic-two counterexample or mathematical novelty is claimed.

## Initial exact-search audit

Read `search/lai_sprang_finite_search.py`, `finite_rank.py`, independent
root-sum/recursive readback and the relevant tests before choosing the increment.
The first file enumerates all normalised vectors with both endpoints nonzero;
it is not Gaussian elimination. The separate affine solver imposes r_0=1 and
r_d!=0, including d=0 and F_2. All fractional indices use m+i+j and inspect
only the inclusive prefix through m+d+limit. A cutoff without a nonzero term
remains unresolved; it gives no exact index or infinite-vanishing claim.

The independent checker verifies exact primal values and weighted-row dual
obstructions (inconsistency or forced zero leading coefficient). Its rank field
is diagnostic, not independently certified. No solver changes were needed.
Existing tests cover tiny exhaustive comparisons, endpoint/cutoff controls,
2,560 root-sum coefficients, r=1 witnesses and all 12,871 retained large-box
optima, as well as later dyadic and three-term records. No new box was run.

## Primary literature refreshed on 29 September 2026

- Lai–Sprang, [arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  submitted 30 May 2026; current abstract and
  [primary text](https://arxiv.org/html/2606.00633v1) rechecked. It settles
  failure for every irreducible P(t) over every odd-characteristic ground field.
  The auxiliary sharp constant concerns their known counterexample only.
- Badziahin–Pavlenkov–Zorin,
  [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  submitted 22 August 2026; current abstract still makes the characteristic-two
  exceptional-set result conditional on existence of a counterexample.
- Robertson, [arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955v3),
  last revised 31 October 2025; number-wall/Toeplitz framework and current
  version checked.

Scoped searches included `site:arxiv.org Littlewood "characteristic 2" 2026`,
`site:arxiv.org Littlewood "characteristic two" counterexample`, and the quoted
Littlewood/characteristic phrases with 2026/number walls. No later primary
resolution was found. This is a search boundary, not proof of absence. The
retired binary baselines and their prior quadratic-series attribution remain
unchanged; this run does not reclassify them as candidates.

## Dependency provenance and reproduction

Lean and mathlib remain pinned to v4.27.0; mathlib commit
`a3a10db0e9d66acbebf76c5e6a135066525ac900` and transitive pins are unchanged.
Inspected the Apache-2.0 licence and actual source in
`Mathlib/RingTheory/LaurentSeries.lean`, `HahnSeries/PowerSeries.lean`,
`HahnSeries/Multiplication.lean`, `HahnSeries/Addition.lean`, and
`Algebra/Polynomial/Eval/Defs.lean` before reuse. The power-series embedding,
coefficient-of-single-product, finite-sum and polynomial-evaluation lemmas
supply the library boundary. No copied external implementation or new axiom.

```sh
lake exe cache get Mathlib.RingTheory.LaurentSeries
lake build
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
shasum -a 256 -c results/2026-09-29-sha256.txt
```

The cache restored 2,177 dependency files; no toolchain/dependency update was
made. All 12 entries of the previous hash manifest passed before today's edits;
that historical snapshot is preserved. Python uses the standard library only,
with no random seed. Exact timings and outputs are retained in the dated
validation JSON and Lean build text.

## Verified results

- Full `lake build`: 2,206 jobs, 30.620815s; no warnings.
  All 60 printed axiom reports (12 new) contain only `propext`,
  `Classical.choice`, and `Quot.sound`. No sorry/admit, added axioms,
  native_decide or unsafe declarations occur in project Lean source.
- All 36 Python tests passed (3.572842s subprocess),
  Python 3.9.6; three independently checked Lean exports match
  (0.094519s).
- During development, two rewrite elaboration failures were repaired: the first
  simplification had already expanded the inner monomial product, and the
  concrete integer index 1 needed the explicit natural-index theorem instance.
  The retained build is the successful full build after those corrections.
- Complete source and documentation diff inspected; retained build, validation
  and SHA256 records describe this increment. No new search range or randomness.

## Next useful work

Wednesday: derive or refute the all-r>=3 support cancellation for the three-term
family, including the terminal coefficient -N/2; further scale expansion alone
would repeat evidence. Thursday: define the positive fractional part and prove
its order from `LaurentFirstPositive`, before a norm/product theorem. Generic
degree-zero support/attainment and the root-sum equality remain distinct goals.
