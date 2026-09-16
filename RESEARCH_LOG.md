# Research log

## 2026-09-17 (Thursday, Australia/Sydney) — first automation run

Started 08:20:56 AEST on clean, current `main` (`bd637f1`); verified origin and
completed fetch/fast-forward-only check. Read the actual Python source and
14 September literature note. No prior automation memory or Lean scaffolding
existed. The historical bound report was missing, and rank-solver claims did
not match the enumerator.

Added a pinned Lean 4.27.0/mathlib foundation proving exact certificate
soundness, finite-prefix locality through `m+d+j`, and the Hankel-kernel
formulation. Kernel-checked binary and ternary fixtures with negative controls;
no global bound or Laurent-series theorem is claimed.

Made cutoff exhaustion explicit in the enumerator and validated coefficients
against independent rational-summand root sums. Reproduced 914,975 pairs in
5.639 s; maximum defects 4,4,15 for p=5,13,17, zero unresolved inputs. Retained
six `r=1` defect-4 comparisons. Six Python tests pass; Lean build passes with
standard axioms only. Full ranges, source versions, commands, limits and build
output are in `results/2026-09-17-certificate-foundation.md` and accompanying
JSON/text records.

Primary-source recheck: Lai–Sprang v1 settles odd characteristic; the August
Badziahin–Pavlenkov–Zorin v1 still makes its characteristic-two result conditional
on a counterexample. No newer resolution found in the searched sources.

Next: exact endpoint-aware affine solver compared exhaustively to enumeration;
then use the shared stream interface for characteristic-2 experiments. Next
formal lemma: polynomial degree and the Laurent-coefficient bridge.
