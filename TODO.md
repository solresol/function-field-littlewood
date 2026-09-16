# Research roadmap

## Next computation (Friday)

- Implement an exact F_p affine solver for `r_0=1` and `r_d!=0`; emit witnesses
  with explicit terminal nonzero coefficients or clearly labelled unresolved
  prefixes. Compare every tiny instance against exhaustive enumeration, including
  characteristic 2, where endpoint feasibility needs particular care.
- Separate the generic coefficient-stream interface from the odd-characteristic
  Lai–Sprang generator. Use it to begin documented binary-stream/Hankel experiments.
- Extend the auxiliary `r>=2` bound boxes only after solver cross-checks. The
  existing `p=17` box attains 15, not 16: do not advertise sharpness there.

## Next formalisation (Saturday)

- Connect `Fin (d+1)` multipliers with mathlib polynomials, proving degree `d`
  and nonzero constant term from the certificate endpoints.
- Connect `fractionalCoeff` to actual Laurent-series multiplication and later
  the norm/product exponent. Avoid assuming that bridge as an axiom.
- Formalise the Lai–Sprang coefficient stream and identify the tested prefix.
- Add rank/affine-feasibility certificate soundness after specifying the solver.

## Sunday integration

- Rerun small Python and Lean checks; review claims against saved certificates.
- Retire failed auxiliary hypotheses explicitly and record exact violating witnesses.
- Recheck primary literature before promoting a claim of novelty or openness.

## Completed on 2026-09-17

- Reconciled advertised files/algorithms; replaced unretained historical data with
  a reproducible 914,975-pair enumeration and explicit cutoff accounting.
- Independent root-sum validation and exact witness tests.
- Pinned Lean/mathlib; proved Hankel/prefix equivalence, finite certificate
  soundness, and invariance under tail replacement beyond `m+d+j`.
- Checked F_2 infrastructure and F_3 comparison-prefix certificates in Lean.

## Retired research direction

Searching whether odd characteristics congruent to 1 modulo 4 admit a
main-conjecture counterexample is superseded by Lai–Sprang (2026). Work on their
explicit stream concerns the separate auxiliary sharp-constant hypothesis.
The `N`-bound for `r=1` is already refuted by the documented degree-2 witnesses.
