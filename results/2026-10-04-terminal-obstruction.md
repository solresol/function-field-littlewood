# Sunday integration: the linked terminal obstruction is one scalar

4 October 2026, Sunday, Australia/Sydney (AEDT, UTC+11).
Classification: **modest mathematical progress on the auxiliary proof
obstruction**, plus weekly verification. No new main-conjecture result,
all-degree bound, Lean theorem or established publication novelty.

## Question and decision

Do the linked terminal factors recover the moment missing from the 2 October
descent? This question and the decision criteria were stated before coding.
An affirmative answer could continue the descent. A linked example with the
retained moments zero and the missing moment nonzero would rule out using those
algebraic identities alone, while leaving the full stream-window claim open.

The latter outcome occurs, uniformly for every r>=2. We also identify exactly
the scalar left undetermined and the shift parity where the loss occurs.
The next argument must retain original stream rows or sibling compatibility.

## Ordinary structural lemma

Use the notation and established parity identities of the 2 October report.
Let p be an odd prime, r=v_2(p-1)>=2, N=2^r, H=N/2,
D=t^H+1 and Z={z in F_p : z^H=-1}. Let

    F=1+t+...+t^(N-1),  g=1+t+...+t^(H-1),
    R=F V != 0,  V(t)=V0(t^2)+t V1(t^2),
    A=V0+t V1,  B=V0+V1,  W=V0^2-t V1^2.

Then R(t)=E(t^2)+t O(t^2), with E=gA and O=gB. Suppose R has
d+1 zero stream rows at shift m=2n+delta, where d=deg R and delta is 0 or 1.

**Conclusions.**

1. If delta=0, then t^N+1 divides V (and hence R).
2. If delta=1, there is a unique scalar C in F_p such that

       W = C t^(-n)  modulo D.

   Here t is a unit in F_p[t]/(D), so negative powers are well-defined.
   The first root moment beyond the guaranteed H-1 moments equals -N C.

These are necessary conditions for the terminal window, not sufficient ones.
They do not prove that C=0 in the odd-shift case, nor that the even-shift case
descends with an adequate window indefinitely.

### Exact row budget

Write e=deg V. The original parity rows are

    B_E(n+l)+E_O(n+l)=0                  (1<=l<=L_even),
    B_O(n+delta+l)+E_E(n+delta+l-1)=0    (1<=l<=L_odd),

where B_T(v)=sum_i T_i a_(v+i) and
E_T(v)=sum_(z in Z) z^v T(z). The latter uses the odd subsequence.
The row counts and degree upper bounds are:

| e | d | L_even | L_odd | deg A at most | deg B at most |
|---|---|---|---|---|---|
| 2k | 2(H+k)-1 | H+k | H+k | k | k |
| 2k+1 | 2(H+k) | H+k+delta | H+k+1-delta | k+1 | k |

Convolve the first system with B, starting delta rows later, and the second
with A. The stream terms cancel because EB=OA. The available common length is
at least

    min(L_even-delta-deg B, L_odd-deg A) >= H-delta.

Zero components require no rows; the table uses upper bounds, so the stated
guarantee remains valid when a leading coefficient cancels. The resulting
moments, with c=n+delta, are

    sum_(z in Z) z^(c+j) g(z) (A(z)^2-z B(z)^2)=0,
         j=0,...,H-delta-1.

In particular, the worst-case lost moment occurs at **odd shift**, for either
degree parity. Some special quotients may supply more moments; we do not infer
that every quotient loses one.

### Linked-factor simplification and kernel

Direct polynomial expansion gives

    A^2-t B^2=(1-t)(V0^2-t V1^2).

For z in Z, g(z)(1-z)=2. Thus the root weights are exactly 2W(z).
For an arbitrary c>=0 the H-1 equations

    sum_(z in Z) z^(c+j) W(z)=0,  j=0,...,H-2,

hold if and only if W(z)=C z^(1-c) for all z in Z, for a unique scalar C.
Indeed the matrix has rank H-1: any H-1 columns form an invertible
Vandermonde matrix after nonzero column scaling. Its kernel has dimension one.
The nonzero vector z^(1-c) lies in that kernel because the sum of the k-th
powers of the roots of t^H+1 is zero for 1<=k<=H-1. This power-sum identity
follows by writing Z as a nonzero scalar times the H-th roots of unity.
Since D has H distinct roots, equality of evaluations is exactly congruence
modulo D. The next weighted moment is

    2 sum_(z in Z) z^(c+H-1) W(z)
      = 2C sum_(z in Z) z^H = -2HC = -NC.

Neither 2 nor N is zero in F_p. Thus one more moment would force C=0.
At even shift the full H moments are available; Vandermonde forces W(z)=0.
Each z is a nonsquare, so V0(z)=V1(z)=0. Therefore D divides both V0 and V1,
and D(t^2)=t^N+1 divides V. At odd shift c=n+1, giving the displayed
congruence W=C t^(-n). This proves both conclusions.

## A linked obstruction for every r>=2

Take V=1 and m=1, so V0=1, V1=0, A=B=1 and W=1. The actual linked
weights are g(z)(1-z)=2. Their moments at exponents 1,...,H-1 all vanish,
but the next moment at exponent H is -N, which is nonzero. Equivalently C=1.
These polynomials satisfy the terminal linkage and its degree constraints;
the linkage cannot eliminate the surviving kernel direction.

This is **not** a terminal-window counterexample. Its very first stream row is

    B_F(2)=sum_(i=2)^(N+1) a_i = H(r-1) != 0  in F_p.

To see this, the supported indices in [2,N+1] are 2,4,...,N, each with
coefficient H, and N+1, with coefficient -H. There are r powers of two.
For r>=2, 0<r-1<p and H is nonzero. The original window therefore fails
immediately even though all the compressed H-1 moments vanish. This locates
information lost by cross-convolution, without refuting the terminal claim.

The r=1 comparison survives: over F_3, R=1+t,m=1 has stream rows 0,0,2.
Here H-1=0, so the compressed condition is empty. The same algebraic
simplification alone cannot distinguish the actual r=1 failure from r>=2.

**Retire the hypothesis:** terminal linkage plus the H-1 root moments alone
forces the missing moment. The 3 October Lean example only ruled out arbitrary
unlinked quotients; the present example addresses the additional linkage.
Do not retire the stronger hypothesis using the original window equations.

## Week's evidence and remaining boundaries

| Work | Classification | What it establishes |
|---|---|---|
| 28/30 September three-term family | Auxiliary mathematics | Exact attainment for r>=3; failed r=2 extension; no upper bound |
| 29 September / 1 October Laurent and size bridges | Verification/infrastructure | Certificates reach the actual fractional product; no structural nonvanishing |
| 2 October factor-aware descent | Auxiliary mathematics | Bound at every shift for d<N(N-1), by ordinary proof |
| 3 October root-moment Lean theorem | Verification/infrastructure | Full moments imply forced factors; parent moments and iteration still unformalised |
| 3 October public archive | Dissemination | Frozen v0.1.0 source; no strengthened mathematical claim |
| 4 October terminal scalar and linked obstruction | Auxiliary mathematics | Necessary scalar congruence; linkage-only completion refuted |

The week changed the auxiliary proof landscape through Friday's degree cutoff
and today's more precise obstruction. It did not establish the all-degree
N-bound and did not advance characteristic two. Further attainment examples,
routine larger boxes and more product bridges are not the next priority.
Historical reports and the frozen release remain dated snapshots; this report
supersedes the roadmap's suggestion that linkage alone might close the gap.

Next computation: retain the two uncompressed terminal parity systems alongside
W=C t^(-n) modulo D. Determine whether an unused boundary row or compatibility
between siblings forces C=0 for r>=2; if not, retain a genuine terminal-window
witness or identify the additional surviving invariant. A compressed-moment
witness such as V=1 is insufficient. Do not enlarge the old terminal box.

Next formal lemma: construct the root enumeration and prove the named stream's
odd-subsequence formula, then derive the exact full moment block from the
parent window. This supplies the hypotheses of ParityDescent.lean and enables
the existing ordinary degree cutoff. The scalar lemma is optional until it
contributes to closing the terminal argument; do not formalise it as a detour.

## Exact checks and reproduction

Run from the repository root:

    python3 -m search.terminal_moment_check
    python3 -m unittest discover -s tests -v
    lake build

The new check uses the standard library and existing polynomial/stream helpers.
It checks four prescribed quotient polynomials at p=3,5,13,41,17, both row-budget
parities for e=0,...,7, and all 25 residue polynomials modulo t^2+1 over F_5
for c=0,...,7. Both true and false moment premises are checked. Prescribed
V=1,m=1 examples include the missing moment and original stream rows, regenerated
independently from root sums. The largest original index is exactly 2N+1;
there is no inferred tail, unresolved cutoff, optimiser or random seed.
These checks verify formulas and counterexamples, not an infinite theorem by
finite agreement. All-r claims above have ordinary proofs, not Lean proofs.

Exact output and runtime are in `2026-10-04-terminal-moment-check.json`;
the Sunday regression/build commands, outcomes and runtimes are in
`2026-10-04-validation.json`. Lean/mathlib v4.27.0 and the manifest are unchanged.
No full audit, expanded terminal search or retired-stream search was needed.

## Primary-source refresh

Accessed 4 October 2026, Australia/Sydney:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  30 May 2026, remains the listed version. Its odd-characteristic theorem
  settles the main existence question; its Section 3 supplies the method
  adapted here. No novelty or priority claim is made for this algebraic refinement.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  22 August 2026, still conditions its characteristic-two conclusion on a
  counterexample. Scoped primary-source searches found no later resolution;
  search noise limits any absence inference.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  recalls the quadratic-series t-LC theorem and binary paperfolding application.
  Rational series satisfy t-LC by clearing denominators. The original
  de Mathan–Teulie proof was not re-audited.
- [Merta, arXiv:1810.03533v3](https://arxiv.org/html/1810.03533v3#S3.SS1)
  and [Garrett–Robertson, arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5)
  retain the quadratic-series and unbounded-window exclusions used in the
  27 September integration. No new binary candidate is proposed. All three
  retired streams remain regressions; their searches were not expanded.
