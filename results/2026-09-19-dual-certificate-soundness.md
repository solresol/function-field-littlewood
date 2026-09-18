# Dual certificate soundness — 19 September 2026

Saturday Lean run, Australia/Sydney; started 08:21:19 AEST. Initial checkout
was clean main at df2ae5f; origin was verified as
git@github.com:solresol/function-field-littlewood.git. Fetch and fast-forward-only
merge succeeded, already current. No concurrent-run lock/process was present.
Read the README, TODO, research log, both prior reports, literature note, actual
Python/Lean sources and tests. No repository AGENTS.md was found; the supplied
wording instructions apply.

## Increment and mathematical conclusion

`FunctionFieldLittlewood/DualCertificate.lean` proves the finite linear-combination
argument underlying `search/finite_rank.py`. If the row weights are w_0,...,w_L,
the coefficient at column i of their combination is

    c_i = w_0 [i=0] + sum_{k=1}^L w_k a_{m+i+k}.

For any R with R_0=1 annihilating the first L coefficients, summing c_i R_i
therefore gives w_0. Two independently decidable identities obstruct this:

- c_i=0 for all i and w_0 nonzero would give 0=w_0;
- c_i=[i=d] and w_0=0 would give R_d=0, violating the endpoint.

The generic proof works over a commutative semiring. `checkOptimalCertificate`
combines the dual with the previous `ExactCertificate` and normalisation.
Acceptance proves the witness's exact first index j, and that every normalised
multiplier with nonzero leading coefficient has some nonzero coefficient between
1 and j inclusive. This excludes even a hypothetical infinitely vanishing
competitor; the conclusion is not restricted to competitors already supplied
with a first index. `optimal_first_le` gives the corresponding upper bound on
any other exact first index. These statements fix d and m; they do not quantify
a uniform bound over all degrees or shifts.

`checkOptimalCertificate_congr_prefix` proves that only the inclusive prefix
through m+d+j affects acceptance. The generated fixture theorems consequently
apply to every extension of their recorded coefficient lists, without assuming
that the infinite tail is zero.

## Source semantics revalidated

The original enumerator normalises R_0=1, requires R_d nonzero, checks indices
1 through the inclusive cutoff, and records cutoff exhaustion as unresolved.
The separate affine solver retains both endpoints and emits a dual at the first
infeasible prefix. Its independent checker verifies exact terminal nonvanishing
and the dual identity, but deliberately does not verify diagnostic rank.
No search cutoff or rank claim was converted into a theorem. Corrected the
enumerator's stale module comment saying that no rank solver existed.

Lean weights use `Fin (L+1)`, with zero for the normalisation row and `k.succ`
for coefficient index k+1. This matches the retained Python weight order. Lean
checks a disjunction of the two identities rather than trusting the JSON kind
label. Gaussian elimination and the Python program are not formally verified.

## Saved instances and controls

`python3 -m search.export_lean_certificates` deterministically reads three unique
records from the 18 September JSONL. It regenerates stream coefficients using
the independent root-sum/recursive oracle, runs the independent Python checker,
and emits finite data plus ordinary Lean `decide` proofs. The generated data
are untrusted inputs to the Lean checker.

| Recorded stream | Field | d | m | j | Defect | Dual kind | Inclusive prefix end |
|---|---|---:|---:|---:|---:|---|---:|
| Thue–Morse | F_2 | 9 | 15 | 24 | 15 | inconsistent | 48 |
| Thue–Morse | F_2 | 1 | 2 | 1 | 0 | leading_zero | 4 |
| Lai–Sprang | F_17 | 0 | 17 | 15 | 15 | inconsistent | 32 |

The first multiplier is (1+t)(1+t^8); the other two are 1+t and 1.
Five kernel-checked negative controls cover zero weights, a wrong terminal index,
a zero leading coefficient, the forced-endpoint row not being the zero row,
and a zero-length prefix with zero weights not being an obstruction.

These are three selected formal instantiations, not a Lean replay of all 7,735
records. Identification of each recorded prefix with its named infinite stream
is independently checked in Python, not proved in Lean. Normalisation of an
arbitrary multiplier over a field, actual polynomial degree, Laurent-series
multiplication, and the norm/product bridge remain to be formalised.

## Validation, dependencies and runtime

- Lean 4.27.0, arm64-apple-darwin24.6.0; toolchain commit
  db93fe1608548721853390a10cd40580fe7d22ae.
- mathlib v4.27.0, exact commit a3a10db0e9d66acbebf76c5e6a135066525ac900;
  existing manifest and pins unchanged. Inspected finite-sum distribution and
  summation interchange usage, matrix/ZMod source headers and Apache-2.0 licence.
- Python 3.9.6 standard library; deterministic, no random seed and no new search box.

Commands executed from the repository root:

```sh
python3 -m search.export_lean_certificates
lake build
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
lake env lean --version
git -C .lake/packages/mathlib rev-parse HEAD
rg -n '\bsorry\b|\baxiom\b|native_decide' FunctionFieldLittlewood FunctionFieldLittlewood.lean
```

The final source build succeeded, 1,129 jobs including cached dependencies.
Lake reported 6.9 s for DualCertificate, 2.7 s for SavedCertificates and 1.4 s
for the root module (module times, not an independently timed full run).
All 18 printed axiom reports, including the existing examples, contain only
propext, Classical.choice and Quot.sound. There are no sorry declarations,
added axioms or native_decide uses in project Lean source.

All 13 Python tests passed in 0.839 s. They include exhaustive tiny binary and
ternary comparisons, root-sum coefficient checks, unresolved cutoff semantics,
the documented r=1 comparisons and independent readback of all 7,735 saved
certificates. Fixture regeneration reported that all three saved certificates
match the tracked Lean source. Source/artifact hashes accompany this report.

## Primary-source recheck (accessed 19 September 2026)

- Lai and Sprang, [arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  30 May 2026. Current history lists only v1; the abstract settles every
  irreducible P(t) in every odd characteristic. The F_17 work above is about
  their known counterexample and the auxiliary constant, not an open main case.
- Badziahin, Pavlenkov and Zorin,
  [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1), 22 August 2026.
  Current history lists only v1; the characteristic-two exceptional-set
  conclusion remains conditional on existence of a counterexample.
- Robertson, [arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955v3),
  last revised 31 October 2025. The current abstract describes the number-wall
  dictionary via finite Toeplitz determinants; no newer arXiv version is listed.

Searched `"Littlewood" "characteristic 2" counterexample 2026`,
`"Littlewood" "characteristic two" 2026`, and both characteristic wordings
restricted to arxiv.org. No later resolution was found in these sources.
This is a bounded literature check, not proof of absence or a novelty claim.

The characteristic-two examples remain finite infrastructure results. The
Lai–Sprang F_17 case still attains defect 15 rather than N=16. No global bound
or new counterexample is proved. Next formal step: scalar normalisation and the
polynomial endpoint/degree bridge, followed by named-stream identities. Next
computation remains the dyadic binary family and p=17 gap analysis already planned.
