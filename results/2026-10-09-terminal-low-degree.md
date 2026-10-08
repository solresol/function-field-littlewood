# Low-degree terminal exclusion at every shift

9 October 2026, Friday, Australia/Sydney (AEDT).
Classification: **mathematical progress on the auxiliary Lai–Sprang bound**.
Ordinary proof, not Lean formalisation or an established novelty claim.

## Question and decision

Can the original stream rows exclude terminal multipliers
S=(1+t+...+t^(N-1))V of low quotient degree at every shift, rather than
only in a finite shift box? This question was stated before implementation.
The 5 October equivalence makes a genuine terminal witness decisive for
refuting the N-bound. An all-shift exclusion instead strengthens the degree
cutoff; an inconclusive finite scan would not be mathematical progress.

The result is an exclusion for **deg V < H=N/2**, giving the stronger cutoff

    j-d <= N whenever d < N(N+H-1) = N(3N/2-1), at every shift.

The previous cutoff was N(N-1). Neither cutoff proves the all-degree bound.

## Notation and existing input

Fix an odd prime p, r=v_2(p-1)>=2, N=2^r and H=N/2. Let a be the
Lai–Sprang stream, with a_(2u)=a_u for u>=1 and

    a_n = H*(-1)^h if oddpart(n)=1+Nh, and 0 otherwise.
    F(t)=1+t+...+t^(N-1),  B_T(v)=sum_i T_i a_(v+i), v>=1.

A terminal window for S=FV!=0, D=deg S, at M>=0 means
B_S(M+k)=0 for k=1,...,D+1. No endpoint condition is imposed here.

The [4 October moment lemma](2026-10-04-terminal-obstruction.md) supplies:

- If M is even, t^N+1 divides V.
- If M=2n+1, writing V(t)=V0(t^2)+t V1(t^2), the polynomial
  W(t)=V0(t)^2-t V1(t)^2 satisfies W=C t^(-n) modulo t^H+1.

These are necessary consequences of the actual rows. The argument below
does not assume that the compressed congruence is sufficient.

## 1. F itself has no N-row zero window

**Lemma.** For every M>=0, at least one of B_F(M+1),...,B_F(M+N)
is nonzero when r>=2.

**Proof.** Adjacent rows satisfy

    B_F(v+1)-B_F(v)=a_(v+N)-a_v.

If all N rows vanished, the right side would vanish at every
v in [M+1,M+N-1]. There are two cases.

If M is not congruent to 1 modulo N, that interval contains an integer
v=1+Nq. It is odd, and a_v=H*(-1)^q whereas a_(v+N)=-a_v.
Their difference is -2H*(-1)^q, which is nonzero in F_p.

If M=1+Nq, choose v=M+1=2+Nq. Because N is divisible by 4,
both v and v+N have 2-adic valuation exactly one. Their odd parts are
1+Hq and 1+H(q+1). Exactly one is 1 modulo N. Thus exactly one
of a_v and a_(v+N) is nonzero, with value H or -H. Again the
difference is nonzero. The two rows used have indices 1 and 2 within
the proposed window. Both cases contradict the zero window. QED.

Consequently no nonzero monomial multiple c*t^h*F can have N consecutive
zero rows at any nonnegative shift: its rows are c times those of F at
the shifted argument M+h.

The use of r>=2 is essential. For r=1 the two valuations in the second
case need not equal one. Over F_3, F=1+t at M=1 has rows 0,0,2,
the retained genuine terminal counterexample.

## 2. A norm of degree below H leaves only the monomial case

**Algebraic lemma.** For nonzero V, let e=deg V and h=ord_t V. Then

    deg(V0^2-t V1^2)=e,  ord_t(V0^2-t V1^2)=h.

Indeed W(s^2)=V(s)V(-s). The latter has degree 2e and order 2h,
since its leading and trailing coefficients are nonzero products in a
field. Substitution doubles degree and order. In particular W is nonzero,
and if W is a monomial, e=h and V is a monomial too.

**Terminal exclusion theorem.** A terminal window S=FV!=0 cannot have e<H.

**Proof.** If M is even, the existing moment lemma forces t^N+1 to divide
V, impossible at e<H<N. If M=2n+1, reduce t^(-n) modulo t^H+1.
Since t^H=-1 in this quotient, its unique representative is a nonzero
scalar times t^k for some 0<=k<H. Also deg W=e<H, so the congruence
is an equality between its unique degree-below-H representatives.
The case C=0 would give W=0, impossible. Otherwise W is a monomial;
the algebraic lemma makes V=c*t^e.

But the assumed D+1=N+e zero rows of S now include N zero rows of
c*t^e*F. Section 1 excludes those at every shift. QED.

This proves the exclusion for every nonzero V of degree below H, including
V(0)=0; it does not need a minimal-counterexample or endpoint assumption.
It is not an inference from tested primes, quotient vectors or shifts.

## 3. Consequence for the original auxiliary bound

The [2 October factor-aware descent](2026-10-02-parity-descent.md) takes
any nonzero degree-d polynomial R with d+N zero rows at any shift to
a terminal S with exact degree floor(d/N). By Section 2,

    floor(d/N)=deg S=N-1+deg V >= N+H-1.

Hence every such R has d>=N(N+H-1). Equivalently, below this threshold
some row among 1,...,d+N is nonzero. This proves the advertised j-d<=N
bound, including existence of j, for every shift in that degree range.
It also applies when R(0)=0, although Littlewood-product multipliers are
usually separated into a power of t and an endpoint-admissible R.

| N | Previous strict degree cutoff | New strict degree cutoff |
|---|---:|---:|
| 4 | 12 | 20 |
| 8 | 56 | 88 |
| 16 | 240 | 368 |

These are proof consequences for all primes with the given N, not finite
search maxima. The N-or-2N maximum-defect dichotomy remains undecided.

## 4. Why the argument stops at e=H

Over F_5 take N=4, H=2, V=1+t+3t^2 and M=1. Then

    W=(1+3t)^2-t = 1+4t^2 = 2 modulo t^2+1.

Thus the necessary norm congruence holds with C=2!=0 and V is not a
monomial. The quotient is also coprime to t^4+1: a common root would
force its norm to vanish at a root of t^2+1, contrary to the residue 2.
The first H-1 compressed moments vanish, but S=FV has original rows

    2,0,2,0,2,4,0 at M=1.

It fails immediately as a terminal witness. This is a boundary control for
the new degree argument, not another claimed refutation of the already
retired linkage-only hypothesis. Polynomial reduction first allows a
nonmonomial at e=H, so extending the proof needs more original-row information.

Next informative question: at e=H, classify solutions of
W=C t^(-n) mod (t^H+1) with V(0)!=0, then determine whether their
original parity rows can vanish. A further scan over arbitrary degrees and
shifts would not address the reason the present proof stops.

## Exact checks and limits

Run `python3 -m search.terminal_low_degree_check` from the repository root.
The saved JSON records Python version, deterministic inputs, inclusive original
coefficient endpoints and runtime. Dependencies: standard library; seed: null.

- Full multiplication V(s)V(-s) independently checks the parity norm, degree,
  order and monomial claims. Algebraic controls enumerate coefficient vectors
  of widths 2,4,2,1,3 respectively over p=3,5,13,41,17, excluding zero,
  plus the explicitly listed sparse vectors. This is finite verification of
  identities with an ordinary proof, not an all-degree search.
- Adjacent-row obstructions are checked over p=5,13,41,17 for every
  M=0,...,2N-1 and M=2^50*N+b with b in {0,1,N-1}. This tests both
  residue branches, both exceptional q parities, shift zero and large indices.
  Row sums come from the existing original-root-sum oracle, while the
  difference formula uses the support stream independently. The two actual
  adjacent rows are retained as nonvanishing evidence for each fixed input.
- The e=H boundary polynomial, its norm and original rows, and the genuine
  r=1 rows are retained. No optimiser, padded prefix, unresolved cutoff,
  inferred infinite tail or certificate export is involved.

The existing Python regression suite was also run; validation is recorded in
the dated JSON. No Lean source, theorem catalogue or dependency changed, and
no Lean build or independent-kernel claim is made for this ordinary proof.

## Primary literature refresh

Accessed 9 October 2026, Australia/Sydney:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  submitted 30 May 2026, remains the listed version. Its odd-characteristic
  theorem settles main-conjecture counterexample existence; its
  [Section 3](https://arxiv.org/html/2606.00633v1#S3) supplies the method
  adapted by the repository's descent. Today's claim is an auxiliary
  refinement for their explicit prime-field stream. Publication novelty has
  not been established.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  submitted 22 August 2026, still conditions its characteristic-two conclusion
  on existence of a counterexample. Scoped searches for characteristic-two
  Littlewood counterexamples and Lai–Sprang sharper bounds found no relevant
  later resolution; noisy indexing does not establish absence.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  states the quadratic-series exclusion and its binary paperfolding application.
  Its discussion of Thue–Morse also explicitly states unbounded deficiency.
  A targeted content refresh of
  [Garrett–Robertson, arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5)
  failed with a fetch timeout after the initial page lookup; no fresh claim
  depends on that refresh. Rational series are excluded by clearing
  denominators. No new binary candidate was proposed;
  no retired stream search was expanded, and no characteristic-two advance
  is claimed.
