# 1 October 2026 — fractional-part order and polynomial product

Thursday, Australia/Sydney. **Classification: verification/infrastructure
progress.** No new structural upper-bound result, characteristic-two construction,
attainment family, or novelty claim.

## Question stated before implementation

Does an exact positive fractional index j give order j for the strictly positive
part of the actual Laurent product, size 2^(-j), and Littlewood product 2^(d-j)?
The unresolved formal step was the passage from coefficient certificates to a
product lower bound. A correct bridge would let a future all-degree nonvanishing
lemma imply the auxiliary bound; a failure at zero, at the constant term, or at
polynomial endpoints would require revising the certificate interpretation.

The downstream theorem is product >= 2^(-N) for every endpoint-admissible
Q=t^m R in the Lai–Sprang stream. Today's bridge does **not** assume or prove
that theorem. It identifies its remaining coefficient obligation exactly.

## Formal result and conventions

`FunctionFieldLittlewood/FractionalPart.lean` defines the fractional part in
x=t^(-1) by `f - HahnSeries.truncLT 1 f`. Its coefficient at n is f_n for n>0
and zero otherwise. Mathlib's `LaurentSeries.powerSeriesPart` instead shifts
by the order; using it directly here would be incorrect.

- `fractionalPart_order`: a first positive index j gives nonzero fractional
  part and actual Hahn order j. The order of the full product is not used.
- `fractionalPart_size`: the explicit real-valued base-two size is 2^(-j).
  Size at zero is defined to be zero, despite mathlib's total order(0)=0.
  This is not a new ambient norm instance or a bundled absolute-value structure.
- `polynomialLittlewoodProduct_eq_reduced`: for nonzero constant and leading
  endpoints, mathlib's polynomial degree of t^m R is d+m and its trailing
  degree is m. Evaluating the genuine polynomial at x^(-1) matches the actual
  shifted Laurent product. The factors 2^(d+m) and 2^(-m) therefore cancel.
- `certificate_polynomialLittlewoodProduct`: every exact certificate implies
  that this three-factor polynomial product equals 2^(d-j).
- `polynomialLittlewoodProduct_bound_iff`: product >= 2^(-N) if and only if
  some coefficient at 1<=k<=d+N is nonzero. This theorem does not presuppose
  that a first nonzero index exists; an identically zero fractional part fails
  both sides. Integer exponents avoid truncated natural subtraction.

The coefficient definition and inclusive terminal boundary are the existing
ones: sum over i=0,...,d of R_i a_(m+i+j). No solver, truncation convention,
certificate format or finite search changed. The field result is generic,
including characteristic two; no new binary candidate is instantiated.

`FractionalPartExamples.lean` checks discarded poles and constants, zero size,
j=1, a zero stream rejected by the bound, and the sign when j<d. The existing
F_17 sharp certificate gives 2^-16, while the r=1 F_3 comparison gives 2^-4.
These are bridge regressions, not additional mathematical attainment evidence.

## Verification and reproduction

Initial checkout: clean main at 12e8a0507ce443e75a9d442fc9e4a6c8054be930,
origin git@github.com:solresol/function-field-littlewood.git. No concurrent run
marker or research process found. Fetch and fast-forward-only merge were current.
No applicable filesystem AGENTS.md was found; supplied chat instructions applied.

Inspected existing certificate, polynomial and Laurent sources, plus mathlib's
Hahn order/truncation, Laurent power-series part, polynomial degree/trailing-degree,
and ordered integer-power lemmas. Mathlib's Apache-2.0 licence and dependency
pins were checked. Lean/mathlib remain v4.27.0; mathlib commit
`a3a10db0e9d66acbebf76c5e6a135066525ac900` is unchanged.

Reproduce from the repository root:

```sh
lake build
```

Final full build succeeded: 2,208 jobs, 6.881132 seconds, no warnings.
All 73 printed axiom reports (13 new) contain only propext, Classical.choice,
and Quot.sound. No sorry, new axioms, native_decide or admitted targets occur in
project Lean sources. Saved output and validation metadata accompany this report.
Initial development errors concerned integer-to-natural coercions, a classical
zero test, simplifier rewriting of inverse positivity, and the explicit degree
lemma argument; all were fixed before the retained build. Two unused simp
arguments were removed before that build.

No search inputs, randomness or new finite-field experiment. Python tests were
not rerun because Python sources and stored certificates are unchanged. Lean
checks cover every changed proof module and the existing imported regression
modules; no test count is offered as evidence for an unresolved conjecture.

## Literature and limits

Primary pages accessed 1 October 2026 (Australia/Sydney):

- Lai–Sprang, [arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1), submitted
  30 May 2026. Its abstract and submission history still state counterexamples
  for every irreducible P(t) over every odd-characteristic ground field.
- Badziahin–Pavlenkov–Zorin,
  [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1), submitted 22 August
  2026. Its characteristic-two conclusion remains conditional on existence.

This was a check of these primary versions, not a fresh exhaustive frontier
search. No new characteristic-two candidate was proposed, so there was no new
algebraicity/window screening. Prior retirements remain in force. The root-sum
identification is still a separate unproved formal obligation. The generic
all-degree N-bound and characteristic-two main frontier receive no new
mathematical result today. The ordinary degree-zero and r>=3 three-term
attainment proofs are unchanged, including the r=2 failure and r=1 comparison.

## Next decision

Do not continue with routine bridge or attainment-example formalisation.
Try splitting multiplier and row indices by parity, using a_(2n)=a_n and the
sparse alternating odd subsequence. Can a vanishing window of length d+N be
reduced to a smaller-degree vanishing system with controlled shift and
endpoints? A valid descent would support induction; a concrete obstruction
would identify why that approach fails or which additional invariant is needed.
Only build an exact experiment if it distinguishes those outcomes. Formalise a
successful structural reduction next; a bounded inconclusive attempt is allowed.
