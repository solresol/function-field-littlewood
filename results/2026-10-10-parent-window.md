# Parent coefficient windows to forced factors

10 October 2026, Saturday, Australia/Sydney (AEDT).
Classification: **verification/infrastructure progress** on the existing
ordinary factor-aware descent. No new mathematical or priority claim.

## Question and decision

Can the two finite parity windows and their convolution degree budgets be
derived in Lean from the actual vanishing parent window? This was stated
before implementation. Success connects the 8 October moment theorem to
the parent and moves the next formal obligation to child selection and
iteration. A failed derivation could expose an indexing or budget gap in
the 2 October ordinary proof. The derivation succeeded, including all four
degree/shift parity cases, shift zero and zero parity components.

## Exact theorem

Put H=2^r, p-1=2H(2k+1), p prime greater than 2, and s dividing H.
Here the Lean parameter r is one less than v_2(p-1), N=2H, and the parent
surplus is 2s. Define g=(t^H-1)/(t^s-1) by its finite geometric sum and
R=g(t^2)U. Let E=g U_0 and O=g U_1, where the canonical coefficients are
(U_0)_i=U_(2i) and (U_1)_i=U_(2i+1).

`stream_parent_forced_factor` proves: if natDegree R=2q+epsilon, epsilon<=1,
delta<=1, and B_R(2n+delta+j)=0 for 1<=j<=2q+epsilon+2s, then
g(t)(t^H+1) divides both E and O. Its parent is represented explicitly
as a product; no arbitrary decomposition, parity rows, quotient degree
bounds, root enumeration, or moment equations are hypotheses.

The canonical split uses mathlib `contract` and `divX`. Separate lemmas
prove R=E(t^2)+t O(t^2), degree bounds from its even and odd coefficients,
deg g+s=H, and g(t^2)=F_(2s)(t). The derived windows have lengths
A=q+s+epsilon*delta and B=q+s+epsilon*(1-delta), exactly as in the
ordinary proof. Their original positive parent indices are respectively
2l+2-delta and 2l+delta+1 for zero-based l. This proves positivity and
the inclusive endpoint bound, including delta=0 and n=0.

The theorem does not require U or its constant coefficient to be nonzero.
The parent hypothesis uses Lean natDegree (zero for the zero polynomial).
For a zero parent the divisibility conclusion is valid but gives no
nonzero descent child. It applies also at r=0 (the original r=1 comparison);
no terminal exclusion is asserted there.

## Limits and next step

The forced factor is now reached from the actual parent window. Still to
formalise: cancellation of the odd-subsequence terms after divisibility,
selection of the nonzero leading child of degree q at shift n+epsilon*delta,
the identification with the next geometric factor, and iteration.
The 9 October stronger degree cutoff also needs its terminal norm and
adjacent-row arguments formalised. Neither degree cutoff, the auxiliary
all-degree N-bound, nor a characteristic-two construction follows as a
Lean theorem from this increment.

Next computation remains the degree-H terminal norm boundary with the
original parity rows. No multiplier box, attainment family, retired binary
stream, or certificate export was expanded today.

## Verification and provenance

Reproduce with `lake build` and
`lake env lean verification/ParentWindowAudit.lean`.
The dated validation JSON and build/audit transcripts record exit codes,
runtime, exact toolchain and dependency pins, source hashes and axioms.
No randomness or finite experiment: seed and input ranges are inapplicable.
No Python source or data changed, so its existing regressions were not rerun.

Reused the existing filter and stream recurrence, `WindowMoments` and
`ParityDescent`; inspected mathlib's polynomial expansion, contraction,
coefficient, divX and degree sources and its Apache-2.0 licence. No dependency
or toolchain change. This increment has a Lean-kernel/type/axiom audit;
the older Comparator run and Zenodo release do not cover it.

## Primary-source boundary

Accessed 10 October 2026:

- [Lai–Sprang v1](https://arxiv.org/abs/2606.00633v1), submitted 30 May 2026,
  remains the listed version. Its [Section 3](https://arxiv.org/html/2606.00633v1#S3)
  supplies the adapted parity method. Its main odd-characteristic theorem
  is already settled; today's work concerns an auxiliary refinement.
- [Badziahin–Pavlenkov–Zorin v1](https://arxiv.org/abs/2608.22078v1), submitted
  22 August 2026, still conditions the characteristic-two conclusion on
  existence of a counterexample. This refresh of specific sources is not
  a comprehensive search for later resolutions or a novelty claim.
- [Adiceam–Nesharim–Lunnon v2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  retains the quadratic-series exclusion and binary paperfolding application;
  its Thue–Morse discussion gives unbounded deficiency. Rational series are
  excluded by clearing denominators. No binary candidate is proposed here.
