# Complete formal descent and the first degree cutoff

13 October 2026, Tuesday, Australia/Sydney.
Classification: **verification/infrastructure progress** on the ordinary
2 October argument. No new mathematical bound or novelty claim.

## Question and decision

Before coding: can a nonzero F_(2s)-multiple with d+2s zero rows be reduced
to a nonzero F_s-multiple of exact degree floor(d/2), at the prescribed child
shift, with floor(d/2)+s zero rows? Success enables iteration to the first
all-shift cutoff. Failure would expose a missing hypothesis in the ordinary
argument. The bounded attempt succeeded and also completed that iteration.

The checkout was clean main at 424e579; origin was the requested
solresol/function-field-littlewood SSH remote. Fetch and fast-forward-only
update were already current. No competing run was found. The migrated memory,
README, roadmap, dated results/log and actual Lean sources were read before
selection. The advertised proof/search files and pinned Lean foundation exist;
the old missing-file audit is already recorded in README, not repeated here.

## Exact proved statement

Put N=2^(r+1) in the Lean notation, with prime p>2 and
p-1=N(2k+1). Thus Lean r is one less than the usual v_2(p-1).
For the named infinite support-formula stream a, let
B_R(v)=sum_i coeff(R,i)*a(v+i) and F_s=(X^N-1)/(X^s-1).
The quotient is defined as a finite geometric polynomial, without division.

`stream_descent_step` proves: for s dividing N/2, R nonzero, F_(2s)|R,
deg R=2q+epsilon, epsilon,delta in {0,1}, and a window of d+2s zero
rows at shift 2n+delta, there is a nonzero S with degree q, F_s|S, and
q+s zero rows at shift n+epsilon*delta. Neither child constant coefficient
is required to be nonzero; shift zero and zero non-leading children are allowed.

The proof composes the previously checked actual-parent forced factors with:

- `odd_filter_zero`: X^(N/2)+1 divisibility kills every odd-subsequence filter,
  using the proved root enumeration for the actual stream;
- `leading_child`: the parity matching the parent's leading exponent is
  nonzero and has exact degree q, proved from its leading coefficient;
- `factorQuotient_next`: g*(X^(N/2)+1)=F_s by polynomial cancellation.

The even child has q+s+epsilon*delta available rows; the odd child has
q+s+epsilon*(1-delta). Selecting the leading child always retains at least
q+s rows. The exact child shift is part of the theorem.

`iterated_degree_bound` inducts on j: a nonzero F_(2^j)-multiple with
surplus 2^j and j<=r+1 has degree at least 2^j*(N-1). At j=0, the
nonzero polynomial is divisible by F_1 of degree N-1. The inductive step
uses the actual child theorem and its floor-half degree; no terminal
nonvanishing hypothesis is inserted.

`stream_degree_bound` starts with F_N=1 and proves d>=N(N-1) whenever
all d+N positive rows vanish. `stream_nonvanishing_below_cutoff` gives
its contrapositive: for every nonzero R of degree d<N(N-1) and every
nonnegative shift m, some i in 1,...,d+N has B_R(m+i) != 0.
This is the coefficient form of the auxiliary bound j-d<=N below the cutoff.
The existing product equivalence supplies its mathematical interpretation;
no new Laurent/product theorem is asserted by this module.

## Limits and comparison

The cutoffs are d<12,56,240 at N=4,8,16. These are the already-known
2 October cutoffs, not improvements on the stronger ordinary 9/12 October
results. Those stronger terminal arguments are not formalised here.
The result also includes N=2 (Lean r=0), where the strict cutoff is d<2;
the known F_3 witness R=1+X^2,m=2,d=2,j=6 is outside that range.
It therefore remains a valid counterexample to the proposed N-bound at r=1.

Iteration proves a degree inequality. This module does not package a final
terminal witness, identify the whole infinite rational-function Laurent sum,
formalise the source's main theorem, or select the N-versus-2N branch.
The all-degree N-bound and characteristic-two construction remain unresolved
research targets. No attainment search, larger box or binary search was run.

## Verification and reproducibility

Lean v4.35.0-rc2 and mathlib commit
065356127b1dc0016f66b7283ce0ce2c4055aa55 are unchanged. The imported polynomial
expansion/degree APIs and source were inspected; mathlib is Apache-2.0.
The source argument is attributed to Lai–Sprang Section 3 and the repository's
2 October factor-aware adaptation. No paper source was bundled.

Run `lake build`, then `lake env lean verification/DescentStepAudit.lean`.
The dated build/audit transcripts and validation JSON retain commands,
exit codes and runtime. The audit prints full types and axioms of all seven
new declarations. Only propext, Classical.choice and Quot.sound are used;
no sorry, unproved axiom, native_decide or target assumption is introduced.
The existing isolated Challenge statement placeholder is outside this closure.
No Python source changed or Python experiment ran. Seeds/input boxes do not
apply: the proof quantifies over every admissible prime, polynomial and shift.
Finite filter rows use inclusive endpoint m+d+(d+N); there is no truncation,
search cutoff, timeout inference or extrapolation from finite agreement.

## Literature boundary and next decision

Primary sources accessed 13 October 2026:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/html/2606.00633v1),
  current abstract/version page and Section 3: the odd-characteristic main
  conjecture is already settled; this module concerns the auxiliary constant.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/html/2608.22078v1):
  the characteristic-two conclusion remains conditional on counterexample
  existence. Scoped arXiv searches for Littlewood plus characteristic two/2
  found no later resolution; this is not a comprehensive absence claim.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  and [Garrett–Robertson, arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5)
  were reopened for the recorded quadratic/unbounded-window exclusions. The
  browser's quadratic-text find failed; the established prior attribution was
  retained, not treated as a newly verified passage. No binary candidate was proposed.

Next computation: the original-row identity controlling admissible odd prime
factors uniformly in N, retaining the N=4/modulo-3 failure control. Next formal
result: the low-degree terminal norm/order and adjacent-row exclusion, enabling
d<N(3N/2-1). The generic descent and bridge phase is now complete for the first
cutoff; do not restart it or substitute formalised attainment examples.
