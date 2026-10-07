# Proved theorem catalogue

The machine-readable register is [theorem-catalogue.yaml](theorem-catalogue.yaml).
This catalogue pins the proved source to `a88a66bfbf75c98d279a45b40137bb5259718f10` (6 October 2026).
It records curated theorem groups, not every supporting lemma or experimental observation.
Each entry gives its assumptions, Lean-reported types, source locations, source hashes,
axiom audit, archive coverage and registry status.

| Theorem group | Role | Archive |
|---|---|---|
| [Root-moment rigidity and forced factors](https://github.com/solresol/function-field-littlewood/blob/a88a66bfbf75c98d279a45b40137bb5259718f10/FunctionFieldLittlewood/ParityDescent.lean#L162) | source-based adaptation | v0.1.0 |
| [Uniform roots and odd-coefficient identity](https://github.com/solresol/function-field-littlewood/blob/a88a66bfbf75c98d279a45b40137bb5259718f10/FunctionFieldLittlewood/RootStream.lean#L113) | known root-sum identity formalised | Not yet archived |
| [Exact coefficient certificates and Hankel kernels](https://github.com/solresol/function-field-littlewood/blob/a88a66bfbf75c98d279a45b40137bb5259718f10/FunctionFieldLittlewood/Certificate.lean#L60) | verification foundation | v0.1.0 |
| [Primal-dual optimum for all admissible multipliers](https://github.com/solresol/function-field-littlewood/blob/a88a66bfbf75c98d279a45b40137bb5259718f10/FunctionFieldLittlewood/Normalisation.lean#L49) | verification foundation | v0.1.0 |
| [Scalar normalisation and actual polynomial endpoints](https://github.com/solresol/function-field-littlewood/blob/a88a66bfbf75c98d279a45b40137bb5259718f10/FunctionFieldLittlewood/Normalisation.lean#L42) | verification foundation | v0.1.0 |
| [Actual Laurent coefficients and certificate transport](https://github.com/solresol/function-field-littlewood/blob/a88a66bfbf75c98d279a45b40137bb5259718f10/FunctionFieldLittlewood/LaurentBridge.lean#L37) | verification foundation | v0.1.0 |
| [Littlewood product and finite nonvanishing equivalence](https://github.com/solresol/function-field-littlewood/blob/a88a66bfbf75c98d279a45b40137bb5259718f10/FunctionFieldLittlewood/FractionalPart.lean#L187) | verification foundation | v0.1.0 |
| [Infinite support-stream comparison witnesses](https://github.com/solresol/function-field-littlewood/blob/a88a66bfbf75c98d279a45b40137bb5259718f10/FunctionFieldLittlewood/LaiSprangStream.lean#L99) | regression formalisation | v0.1.0 |
| [Binary digit-parity stream recurrences](https://github.com/solresol/function-field-littlewood/blob/a88a66bfbf75c98d279a45b40137bb5259718f10/FunctionFieldLittlewood/BinaryStream.lean#L21) | known recurrence formalised for regression | v0.1.0 |

## Verification boundary

Every listed declaration was resolved in Lean and its axioms audited on 7 October.
The complete pinned development built successfully on 6 October; only `propext`, `Classical.choice`
and `Quot.sound` occur in the listed proofs. The exact audited declarations and types are in
[the catalogue audit](results/2026-10-07-catalogue-declarations.txt).

These are Lean kernel checks. Comparator and independent-kernel certification have not
been completed, and no Palomar entry has been submitted. First-formalisation priority
and independent human peer review remain unestablished.

Reproduce the declaration audit from the repository root after `lake build`:

```sh
lake env lean verification/CatalogueAudit.lean
```

The [publication validation record](results/2026-10-07-publication-validation.json)
also checks YAML schema compliance, source hashes and frozen-archive coverage.

## Results outside the proved catalogue

The all-shift degree cutoff and terminal equivalence/dichotomy have ordinary proofs
in the dated reports; they are recorded separately in `unformalised_and_open`.
The all-degree auxiliary N-bound remains open in this project. A characteristic-two
construction is not claimed. Finite certificates and retired binary regressions do not
establish either target.

## Updating the register

When a meaningful formal milestone is proved:

1. Add or revise a theorem group with the full declaration names and exact hypotheses.
2. Check its Lean types and axioms, run the relevant build, and retain the evidence.
3. Pin the verified proof commit and source hashes; the metadata commit may follow it.
4. Record whether the proof is in an actual Zenodo release or registered Palomar version.
5. Update this index and `formalization.yaml` if the project scope changes.

A proved declaration is not an ordinary proof or an accepted finite-search hypothesis.
Keep archive coverage version-specific: the 3 October DOI excludes the 6 October root-stream proof.
Use the same catalogue fields in other projects when those projects are inventoried.

## Palomar preparation

The independent statement and solution are now in [PALOMAR.md](PALOMAR.md).
The historical catalogue above retains its original proof snapshot; later module
migration and dependency upgrades do not rewrite that audit or archive coverage.

The project metadata follows [formalization.yaml v0.4](https://github.com/mathlib-initiative/formalization.yaml).
Verification and submission status follow
[Palomar’s submission guide](https://palomar-registry.org/how-to-submit).
Prefer a coherent parity-descent formalisation package with exact scope. A complete
Lean degree-cutoff theorem would be a stronger subsequent milestone.
