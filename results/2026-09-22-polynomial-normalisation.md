# Polynomial endpoints and scalar normalisation — 22 September 2026

Tuesday, Australia/Sydney. Started approximately 08:22:21 AEST on clean main
at d3f259f. Verified origin git@github.com:solresol/function-field-littlewood.git,
fetched and fast-forward-only checked (already current). No filesystem AGENTS.md
or competing research lock/process was found; the supplied wording instructions
apply. Read automation history, README, TODO, research log, recent results,
the original enumerator, affine solver, independent checker, tests and Lean source.
Acquired an exclusive ignored `.research/run.lock` for this run.

## Proved increment

New `FunctionFieldLittlewood/Normalisation.lean` proves, for any field K:

- Multiplying every vector coefficient by c multiplies each `fractionalCoeff`
  by c. If c is nonzero, exact certificates and first nonzero indices are
  preserved in both directions.
- Dividing a vector by its nonzero constant coefficient gives constant term 1
  and preserves its nonzero leading coefficient, including degree zero.
- `checkOptimalCertificate_sound_all` removes the normalisation restriction
  from the old soundness conclusion. An accepted primal/dual optimum at d,m,j
  proves attainment and a nonzero coefficient by j for every competing vector
  with both endpoints nonzero. No first index is assumed for the competitor.
  `optimal_first_le_all` bounds any supplied competing first index by j.

New `FunctionFieldLittlewood/PolynomialBridge.lean` uses actual mathlib polynomials:

- `multiplierPolynomial R = sum_i monomial i (R i)` recovers each input
  coefficient and has zero coefficients above d.
- A nonzero leading endpoint gives natural degree d. The nonzero constant
  endpoint excludes divisibility by X and also excludes the zero polynomial.
  Thus the degree-zero case is covered without confusing zero with a constant.
- Every polynomial of natural degree at most d is reconstructed from its
  coefficient vector. The formalised vector representation omits no admissible
  degree-d polynomial.
- `optimal_polynomial_nonzero` applies the accepted optimum to any polynomial
  P of natural degree d with P.coeff 0 nonzero. It proves that for some
  1<=k<=j, the exact finite sum

      sum_(i=0)^d P.coeff i * a(m+i+k)

  is nonzero. This statement is valid over fields of any characteristic.

`BridgeExamples.lean` applies these results to the existing saved F_2 optimum
(d,m,j)=(9,15,24) and F_17 optimum (0,17,15), now quantified over polynomials.
It checks F_3 scaling by 2, normalisation back to the original vector, rejection
of zero scaling, degree-2 endpoints, and the degree-zero polynomial case.
Primal/dual fixtures themselves are unchanged. Primality of 17 is proved by
kernel reduction, not assumed as an axiom.

## Search and truncation audit

The original `search/lai_sprang_finite_search.py` remains an exhaustive vector
enumerator, separate from `finite_rank.py`. Its indices run 1 through `limit`
inclusively; both constant and leading coefficients must be nonzero. A missing
nonzero coefficient at the cutoff remains explicitly unresolved. The largest
possible coefficient read is m+d+limit; an exact certificate only needs m+d+j.
Existing tests cover inclusive terminal indices, root-sum identity, scaling,
invalid endpoints and all six documented r=1 comparison primes.

The affine solver fixes r_0=1 and requires r_d nonzero. A rank deficiency does
not by itself certify admissibility; the dual checker independently verifies
inconsistency or a forced zero leading endpoint. The diagnostic rank is not
certified. Today's theorem supplies the previously missing formal justification
for extending these normalised optima to all nonzero constant terms.

No new enumeration box or heuristic search was run. The all-degree N-bound
for the known odd-characteristic Lai–Sprang counterexample remains an auxiliary
hypothesis. The degree-zero attainment proof and retired Thue–Morse dyadic
family were not repeated as new research.

## Validation and dependencies

Lean and mathlib remain pinned to v4.27.0, with mathlib commit
`a3a10db0e9d66acbebf76c5e6a135066525ac900` and unchanged `lake-manifest.json`.
Inspected mathlib's Apache-2.0 licence and the reused polynomial coefficient,
degree, division, field and ZMod field-instance sources. Reused
`natDegree_eq_of_le_of_coeff_ne_zero`, `natDegree_le_iff_coeff_eq_zero`,
`coeff_eq_zero_of_natDegree_lt`, `X_dvd_iff` and existing field cancellation.

Commands from the repository root:

```sh
lake exe cache get Mathlib.Algebra.Polynomial.Degree.Lemmas Mathlib.Algebra.Polynomial.Div
lake build
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
git diff --check
shasum -a 256 -c results/2026-09-22-sha256.txt
```

Final `lake build` passes, including all new modules and saved fixtures.
All 30 printed axiom reports contain only propext, Classical.choice and
Quot.sound. Project sources contain no sorry, admit, added axiom or native_decide.
During development, missing explicit Field/ZMod imports, the Fact proof for
17, simplifier details and a section terminator were corrected before the
successful final build. Failed elaborations were not counted as proofs.

All 19 Python tests pass (1.604 seconds within unittest), including exhaustive
tiny binary/ternary oracles, all 7,735 saved primal/dual certificates, 2,560
independent root-sum coefficients, six r=1 comparisons, cutoff/mutation controls
and the existing dyadic regression. Three exported Lean certificates match.
Python 3.9.6; standard library only; deterministic, no random seed.
Exact command runtimes and outputs are retained in `2026-09-22-validation.json`
and `2026-09-22-lean-build.txt`; the accompanying manifest hashes the increment.

## Primary literature check — accessed 22 September 2026

- Lai–Sprang, [arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  30 May 2026, remains the current listed version. Its abstract settles failure
  for every irreducible P(t) over every odd-characteristic ground field.
- Badziahin–Pavlenkov–Zorin,
  [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1), 22 August 2026,
  remains the current listed version; its characteristic-two exceptional-set
  result is still conditional on existence of a counterexample.
- Robertson, [arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955v3),
  31 October 2025, remains the current listed version of the number-wall
  dictionary, based on determinants of finite Toeplitz matrices.

Reopened these primary abstract/version pages. Searches included `Littlewood
characteristic 2 2026 counterexample` and arXiv-restricted queries with
`characteristic two` and `characteristic 2`. No later main-conjecture resolution
was found in these scoped searches; this is a source boundary, not proof that
no other paper exists. No novelty claim is made.

## Limits and next work

These are proved finite algebraic statements, not just experimental agreement.
They do not identify the finite coefficient sum with mathlib Laurent-series
multiplication, prove a norm exponent, identify a named infinite stream, establish
the global auxiliary N-bound, or resolve characteristic two. Saved examples
remain recorded prefixes; the generic theorem can be combined with existing
prefix-invariance lemmas when the required stream agreement is proved.

Wednesday: the planned exact p=17 positive-degree box d=1,...,16,
m=65,...,256, cutoff 128, with independently checked certificates and unresolved
accounting. Thursday: named stream identities (for example binary adjacent
differences), then the actual Laurent coefficient bridge and the recorded
Lai–Sprang degree-zero proof. Scalar normalisation and polynomial endpoints are
now completed foundations rather than recurring roadmap items.
