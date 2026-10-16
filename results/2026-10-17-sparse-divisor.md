# Formal sparse-divisor obstruction

17 October 2026, Saturday, Australia/Sydney (AEDT).
Classification: **verification/infrastructure progress on existing mathematics**.

## Exact question and outcome

Before coding: does the first-strip sparse polynomial in the 16 October
argument fail to divide X^(2H)+1 over every field of odd characteristic,
uniformly for dyadic H>=4? A complete formal proof verifies the algebraic
obstruction needed for that strip; a failed proof could expose a missing
characteristic restriction or invalidate that elimination. This is auxiliary
work on the known Lai–Sprang counterexample, not a main-conjecture search.

The theorem is complete in FunctionFieldLittlewood/SparseDivisor.lean:

    K a field, (2:K)!=0, a,sigma in K, sigma^2=1, H=2^(r+2), r>=0:
    f = a+2X+sum_(i=0)^r X^(2^(i+1))+sigma*X^H
    implies f does not divide X^(2H)+1.

The constant a is arbitrary, including zero. No finite-field, prime congruence,
root enumeration or nonzero constant-coefficient assumption is imposed.
The statement also includes characteristic zero. Lean's r is log2(H)-2,
or the usual valuation parameter minus three when N=2H is admissible.

The recursive definition is connected to this exact finite sum by
`sparse_eq_sum`. `sparse_not_dvd` derives its degree, leading coefficient,
reflection identity and coefficient obstruction; these are not assumptions
of the final theorem. There is no assumed version of the target.

## Proof and downstream boundary

1. Induction proves degree H and leading coefficient sigma, and
   f(X)-f(-X)=4X. Above H=4 the coefficients through degree six stabilize.
2. If f divides T=X^(2H)+1, then f(-X) divides T. Since T is coprime to X,
   so is f. Invertibility of 4 and the reflection difference make f and
   f(-X) coprime. This avoids needing a separate assumption on a.
3. Their product therefore divides T. Its degree is 2H and its leading
   coefficient is sigma^2=1, so monicity gives f(X)f(-X)=T.
4. The degree-six coefficient of the product is 2*sigma for H=4 and 2
   for H>=8; both are nonzero. T has zero degree-six coefficient because
   2H>=8. This is a contradiction.

The downstream theorem is the first-strip exclusion in the 16 October
ordinary localization proof. Connecting the actual D/E rows, antiperiodic
segment and reversed quotient W to the divisibility hypothesis is still
ordinary mathematics, not proved here. In particular the full two-residue
localization has not become a Lean theorem through this increment.

No mathematical cutoff improves. The two remaining offsets M=1-N and
1-H modulo NH, uniform boundary exclusion, all-degree j-d<=N, and the
characteristic-two frontier remain separate. N=4 (H=2) is outside this
lemma, consistent with the retained characteristic-3 boundary control.
The r=1 comparison remains unchanged.

## Verification and reproduction

From the repository root:

```sh
lake build
lake env lean verification/SparseDivisorAudit.lean
```

Pinned Lean 4.35.0-rc2 and mathlib
065356127b1dc0016f66b7283ce0ce2c4055aa55 are unchanged. The full build
passed in 12.174 seconds; the separate seven-declaration type/axiom audit
passed in 6.961 seconds. All audited declarations use only propext,
Classical.choice and Quot.sound. No sorry, added axiom or native_decide
occurs in this module; the existing Challenge statement placeholder is
outside these proof closures. No independent-kernel replay is claimed.

Reused mathlib's polynomial degree, composition, monicity and coprime-divisor
lemmas after reading their source and Apache-2.0 licence. Development exposed
rewrite-order and coefficient-sum simplification errors, repaired before
both successful final commands. No mathematical hypothesis failed and no
characteristic exception emerged. The finite seven-pair antidiagonal identity
uses kernel-reduced `decide`, not an external oracle.

This is a universal formal proof, not exhaustive or heuristic finite search.
There are no input boxes, random seeds or new Python dependencies. No Python
algorithm or stored certificate changed, so the unrelated suite was not
repeated. Existing source/truncation semantics were read only as needed to
identify the polynomial; no row-window theorem is asserted by this module.
Full logs, exact types and runtime metadata accompany this report.

## Literature and next decision

Primary sources accessed 17 October 2026, Australia/Sydney:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1)
  remains the listed version, settling odd-characteristic main-conjecture
  counterexample existence.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1)
  still states its characteristic-two conclusion conditionally on existence.
  Scoped arXiv searches for Littlewood and characteristic two/2 found no
  later relevant resolution. This is not proof of absence or priority.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  retains the quadratic-series exclusion; rational series are excluded by
  clearing denominators. [Garrett–Robertson, arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5)
  discusses known unbounded-window cases. No binary candidate was selected
  or retired-stream search expanded. No novelty claim is made.

Next substantive work remains the original A rows together with available
D/E rows at the two residual offsets, keeping the missing-row budget exact.
The antiperiodic convolution bridge is a possible focused formal continuation,
but a new boundary lemma should take priority over routine bookkeeping.
