# Finite parity windows to forced factors

8 October 2026, Thursday, Australia/Sydney.
Classification: **verification/infrastructure progress** on the auxiliary
Lai–Sprang bound. No new mathematical result or first-formalisation claim.

## Question and decision

Can the finite parity-row systems in the 2 October ordinary proof supply the
full H consecutive moments, with exact row budgets and zero quotients allowed?
This was stated before coding. A successful proof removes an assumed moment
block from the formal descent path to the all-shift degree cutoff d<N(N-1).
A failed budget would require revisiting the ordinary argument. This run proves
the convolution step; it does not assemble the original parent-window split.

Write B_P(v)=sum_i P_i a_(v+i), e_u=sum_z z^u, E=g U0 and O=g U1.
For zero-based row indices suppose

    B_E(n+l+1)+B_O[e](n+l+1)=0             (0<=l<A),
    B_O(n+delta+l+1)+B_E[e](n+delta+l)=0   (0<=l<B).

Assume delta+H+deg U1<=A when U1!=0, and H+deg U0<=B when U0!=0.
Then for every 0<=k<H,

    sum_z z^(n+delta+k) g(z) (U0(z)^2-z U1(z)^2)=0.

The proof cross-convolves the first system with U1, the second with U0,
and cancels B_(g U0 U1). It uses only rows indexed delta+k+i and k+i.
Polynomial support, not a fictitious degree of zero, determines which rows
are needed. The endpoints are inclusive: the last used first-system index is
at most A-1 and the last second-system index at most B-1. n=0 and delta=0
are allowed; the odd-sequence filter in the second system can start at zero.
There are no endpoint-nonzero or normalisation assumptions on the polynomials.

`WindowMoments.lean` proves filter composition for arbitrary fields, the
cross-moment identity, exact finite-window implication and its composition
with the existing geometric forced-factor theorem. It also checks the four
parity budget inequalities: H=h+s, quotient support indices satisfy

    i1+h+1<=q+epsilon,  i0+h<=q,

and hence delta+H+i1<=q+s+epsilon*delta and
H+i0<=q+s+epsilon*(1-delta), for epsilon,delta in {0,1}.
Here s is half the parent surplus, as in the existing geometric-factor API.
Deriving these support inequalities from a parent polynomial is still needed.

The main new theorem `stream_windows_forced_factor` supplies the root
list and odd-subsequence identity from RootStream. For prime p>2 with
p-1=2*2^r*(2k+1), s dividing 2^r, and the displayed parity windows in the
actual support stream, it proves g*(X^(2^r)+1) divides both g*U0 and g*U1,
where g=factorQuotient F_p (2^r) s. Neither root enumeration nor root moments
are hypotheses of this theorem. The Lean r is one less than v2(p-1), so r=0
retains the original r=1 comparison; no stronger all-degree claim follows.

## Verification and boundaries

- Lean 4.35.0-rc2 and Mathlib 065356127b1dc0016f66b7283ce0ce2c4055aa55
  remain pinned. Inspected Polynomial sum/induction/evaluation/support sources
  and Mathlib's Apache-2.0 licence before reuse.
- Full `lake build` passed; retained output and runtime are in the dated
  build and validation files. The new module has no warnings. The existing
  Challenge statement placeholder emits its expected warning; it is not an
  imported proof dependency of the new module.
- `lake env lean verification/WindowMomentsAudit.lean` independently queries
  the two selected theorem types and axioms. The six new reported proofs use
  only propext, Classical.choice and Quot.sound. No sorry, custom axiom,
  native_decide or bypass is present in the new proofs.
- Earlier development checks failed on unfolding too much and on a tactic
  sequencing change during warning cleanup; repaired before the retained
  successful build/audit. No claim of success for those attempts.
- No finite search, random input, new certificate, Python change or expanded
  attainment family. Python regressions were not rerun because this change
  does not modify their source or data. No independent-kernel/Comparator
  check of this new theorem is claimed; the older package is unchanged.

The original parent's polynomial parity decomposition and finite-row extraction,
actual child degree/shift selection, and descent iteration remain unformalised.
The auxiliary all-degree N-bound, terminal scalar C and N-versus-2N choice
remain unresolved. There is no characteristic-two construction in this run.

## Literature and next decision

Accessed 8 October 2026:
[Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
[Section 3](https://arxiv.org/html/2606.00633v1#S3), remains the source of
the parity/convolution/Vandermonde/nonsquare method. Its odd-characteristic
main theorem is already settled, separate from the auxiliary sharper bound.
The abstract/version page of
[Badziahin–Pavlenkov–Zorin, arXiv:2608.22078](https://arxiv.org/abs/2608.22078)
was also reopened. This was not a comprehensive characteristic-two frontier
or priority search; no new binary candidate or novelty claim depends on it.

Next formal step: derive these finite parity systems and support bounds from
R=E(t^2)+t O(t^2) and the d+surplus original rows, then select the leading
child. Next computational step remains the original odd-shift terminal rows
with C!=0 and coprime quotient. Do not spend another research run re-proving
this convolution or extending the already-settled attainment examples.
