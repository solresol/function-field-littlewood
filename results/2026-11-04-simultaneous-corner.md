# Simultaneous odd-corner transport is a conic

4 November 2026, Wednesday, Australia/Sydney (AEDT). Scheduled instant:
3 November 21:20 UTC = 4 November 08:20 AEDT. Executed 3 November UTC.

Classification: **mathematical progress on auxiliary sharpness structure**:
an ordinary all-prime lemma, supported by independently checked finite algebra.
It gives no uniform accepting path, additional prime decision, characteristic-two
result, Lean theorem or established publication-priority claim.

## Question stated before coding

Read the current roadmap, actual merge/stream definitions, the
[30 October weekly human-literature checkpoint](2026-10-30-literature-review.md),
and the [2 November single-response transport](2026-11-02-odd-corner-transport.md).
The unresolved question was the larger square's simultaneous dependence on
**two copies of the same** missing B11 line under digit (1,1). Would it be
another projective line law, a genuinely quadratic correspondence, or suffer
projection kernels requiring extra data? A derived law would determine what
recurrence to use next. Fitting the two actual values would not decide it.

**Outcome:** the law is a nonsingular conic of two-planes in a four-dimensional
quotient. Every parameter gives an N-dimensional relation; distinct parameters
remain distinct. There is no exceptional projection kernel or extra datum for
this response. A short-window strengthening of the existing nonvanishing
argument proves the required injectivity uniformly, rather than assuming the
larger rectangular block is covered by the old nearly-square lemma.

## 1. The extra injectivity, with exact row budgets

Work over F_p for an odd prime p. Put N=2^v2(p-1), H=N/2 and
c_i=(coefficient of t^(-i) in the named Lai–Sprang stream)/H. Thus

    c_(2i)=c_i,   c_(2i+1)=H^(-1) sum_(z^H=-1) z^i.

Use the original boundary definition

    R_t(m,n)={(u,U_n^T x) : A_t(m,n)x=U_m u},
    (A_t(m,n))_ij=c_(t+i+j),  (U_m)_iz=z^i,  z^N=1.

For this report the definition is also used when |m-n|=2; none of the old
dimension/injectivity claims for nearly-square blocks is silently extended.

**Short-window lemma.** For a,k>=0, if Q is divisible by X^N-1,
deg Q<=2k+1, and the first 2k fractional rows of t^(2a)Q Lambda vanish,
then Q=0. Consequently the stack [A_(2a+1)(2k,2k+2); U_(2k+2)^T]
is injective.

**Proof.** If Q is nonzero with degree <=2k, this is already Proposition 2.3.
In the only remaining case deg Q=2k+1, write

    Q=E(X^2)+X O(X^2),
    E=(X^H-1)V0,  O=(X^H-1)V1.

Here deg E,deg O<=k and each nonzero V_i has degree <=k-H. If k<H,
divisibility and degree already exclude Q. Write B_P(j)=sum_i P_i c_(j+i)
and Z={z:z^H=-1}. The parent rows 1,...,2k give, for l=0,...,k-1,

    B_E(a+l+1) + H^(-1) sum_Z z^(a+l+1) O(z) = 0,
    B_O(a+l+1) + H^(-1) sum_Z z^(a+l)   E(z) = 0.

Convolve the first system with V1 and the second with V0, then subtract.
The stream terms cancel because E V1=O V0. For l=0,...,H-1 all required
rows exist: l+deg V_i<=H-1+(k-H)=k-1 for each nonzero V_i. Zero quotients
have empty convolution sums. The resulting H equations are

    sum_Z z^(a+l)(z^H-1)(V0(z)^2-z V1(z)^2)=0.

The shifted Vandermonde matrix is invertible and z^H-1=-2!=0. Thus
V0(z)^2=z V1(z)^2 for every z in Z. Such z is a nonsquare **in F_p**:
if z=y^2, then y^(p-1)=(z^H)^((p-1)/N)=-1, a contradiction.
Therefore both V_i(z) vanish. Hence X^H+1 divides both V_i, and X^N-1
divides E and O. Their primitive-root rational terms vanish, leaving k
zero rows for each. Proposition 2.3, since deg E,deg O<=k, forces E=O=0.
This contradicts Q!=0. This proof includes H=1 (r=1) and k=0. QED.

This reuses the cross-moment/nonsquare method, not an improved approximation
constant. The removed row is justified by these equal even-shift budgets;
no arbitrary-shift or arbitrary-stream extension is claimed.

## 2. A rank-four simultaneous transport theorem

For any q,k>=0 define actual child borders at t=q+2 by

    A=R_(q+2)(k,k),  B=R_(q+2)(k+1,k+1),
    L=A intersect B=R_(q+2)(k+1,k),
    W=A+B          =R_(q+2)(k,k+1),  V=W/L.

The proved border identities give dim L=N-1, dim W=N+1 and dim V=2,
including singular and empty Hankel blocks. At the new odd start t'=2q+3 put

    W+=R_(2q+3)(2k,2k+2),  L+=R_(2q+3)(2k+2,2k).

The short-window lemma and the old injectivity for tall matrices prove
dim W+=N+2, dim L+=N-2. Specifically, projection of the defining solution
space to boundary data is injective, and the transpose's stacked injectivity
gives full row rank of [A,-U]. Thus the dimension formula is justified on
both new rectangles.

On w=(u,v0,v1) use the exact odd-parent parity maps

    M0 w=(D0 u-K_(q+1) v0, v1),
    M1 w=(D1 u-K_(q+2) v1, v0),
    P w =(u,(v0_(z^2)+z v1_(z^2))_(z^N=1)),
    (D_a u)_y=sum_(z^2=y) z^a u_z,
    (K_j)_zz=H^(-1)z^j on Z and zero elsewhere.

Set S_W={w:M0w,M1w in W}, S_L={w:M0w,M1w in L}.
The exact parity merge (interleaving coefficient preimages) gives

    P:S_W -> W+ bijective,  P:S_L -> L+ bijective.

Child preimages are unique by the old nearly-square lemma; parent projection
is injective by the short-window lemma. Thus dim S_W=N+2 and dim S_L=N-2.
The map w -> (M0w mod L,M1w mod L) has kernel exactly S_L, and hence rank
four. Its target V direct-sum V also has dimension four. Consequently

    S_W/S_L  --(M0,M1)-->  V direct-sum V
        | P
        v
      W+/L+

are both linear isomorphisms. Let Psi:V direct-sum V -> W+/L+ be their
composition. No square inverse, assumed rank, terminal target or desired
acceptance is an input.

**Simultaneous transport theorem.** For every line ell in V, let C_ell be its
preimage in W. The algebraic odd merge of **(C_ell,C_ell)** is precisely
the preimage of Psi(ell direct-sum ell) in W+. This is an N-space.
It depends only on q mod N, L,W and ell. The same line is used twice;
independent sibling substitutions are neither used nor justified.

Choose a,b representing a basis of V and let alpha0,alpha1,beta0,beta1
represent Psi(a,0),Psi(0,a),Psi(b,0),Psi(0,b). For [s:t] in P^1(F_p),

    C_[s:t]=L+span(s a+t b)
       -> L+ + span(s alpha0+t beta0, s alpha1+t beta1).

In quotient coordinates (alpha0,alpha1,beta0,beta1), its six plane
(Plucker) coordinates, ordered 01,02,03,12,13,23, are

    [s^2 : 0 : s*t : -s*t : 0 : t^2].

The three quadratic coefficient vectors are independent. This is the
nonsingular Veronese conic, with all homogeneous parameters retained.
Any two distinct planes meet exactly in L+ and sum to W+. Therefore the
output is not a pencil with an (N-1)-dimensional common core. There is no
division or discarded chart pole, and distinct input lines never collide.
The actual B11 gives the next B11 at T(2q+1,2k+1). Other parameters are
algebraic comparisons, **not a claim of reachable stream states**.

## 3. Fixed collision, independent evidence and limits

Reused exactly T(62,8),T(126,8) over F_5 and the independently certified
1 November input chart b+lambda a, with actual parameters 0,4. Their L,W
and q mod N agree, so the same conic applies. The
[certificate](2026-11-04-simultaneous-corner-check.json) gives the common core

    (1,0,1,4 | 2,3,2,0), (0,1,2,0 | 1,3,2,1)

and alpha0,alpha1,beta0,beta1 respectively

    (3,1,0,4 | 1,0,0,2), (1,2,3,4 | 0,4,4,0),
    (3,0,3,0 | 3,3,3,4), (4,0,1,2 | 0,1,1,1).

Six independent equations give dim S_W=6. Six independent outputs with
explicit internal preimages prove P injective. The four quotient lifts
have the four prescribed standard coordinates modulo L, proving rank four
and the exact two-dimensional kernel, without fitting output values.
For both actual successor B11 squares, explicit original-root-sum polynomial
preimages and invertible full-row-rank minors independently prove the complete
relations. Their inclusive coefficient endpoints are 161 and 289; the fixed-pair
certificate's maximum read index remains the inherited 576. No witness range
was searched or enlarged.

Readback disables solvers, elimination and the relation/direct/recursive/merge
methods in its test; it uses dot products, echelon guards and both products
of inverse minors. Certificate regeneration, ten corruptions, all six abstract
F_5 merges, independent original-coefficient wide/tall comparisons and the
prescribed contexts (p,q,k)=(3,0,0),(3,1,2),(13,7,4) pass. In the latter
contexts all p+1 lines retain dimension N and pairwise sum W+. These finite
checks support the ordinary proof; they do not prove an infinite theorem.
The full Python suite passes **121 tests**, including the four new tests,
in 22.472s (23.022s including the resource runner). The retained certificate
command passes in 1.001s including that runner. No test failures occurred.

The first diagnostic calculation also checked the double-wide invisible
kernel at the already prescribed inputs (5,311,12),(5,313,12),(13,1465,80),
(41,255,11),(5,31,4),(5,63,4),(5,125,17),(5,253,17): all were zero.
Their inclusive original-coefficient endpoints were respectively
673,677,3253,557,81,145,321,577. These new parent rectangles at existing
inputs were diagnostic identity checks, not a state or attainment search.
The diagnostic expression was
`BoundaryRelations(p).direct(2*q+3,2*k,2*k+2)`; its second return value is
the invisible-kernel dimension. The list above specifies all eight inputs.
The four initial pencil contexts took 0.053s and these eight checks 0.531s
of tool wall time; per-script CPU times were not recorded. The all-prime
conclusion rests on the explicit row-budget proof above, not this agreement.
Exact retained validation commands, timings, guards, pins and hashes are in
[the validation record](2026-11-04-simultaneous-validation.json).

No Lean code changed; no new Lean theorem, build or axiom audit is claimed.
Existing Challenge.lean:37 and downstream assumptions supply no evidence here.
The binary frontier and its rational/quadratic/unbounded-window exclusions
are unchanged. No isolated sharpness witness or broad daily literature search
was attempted. The weekly checkpoint's remaining access limits still apply.

Primary source accessed **3 November UTC / 4 November Sydney 2026**:
[Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/html/2606.00633v1),
30 May 2026, still the sole displayed version. Rechecked Theorem 1.2,
functional equation (1.2), Proposition 2.3 and its Section 3 cross-moment/
nonsquare proof. The theorem covers all irreducible P over every odd-
characteristic ground field and gives a lower bound, not uniform attainment.
The new short-window statement is an internal deduction over the prime field;
no novelty or priority follows from the bounded literature check. Existing
project code is reused under Apache-2.0 with Lai–Sprang attribution; no external
implementation or source prose was copied.

The attached runtime's exact source-version binding matched the controller's
verified selection. Saved START.md was available; no executor catalog skills,
applicable AGENTS.md or .agents skill was present. Sourced the prepared env.sh
and passed check.py before work and after refresh, without installation or
download. Verified clean work at 8212723, expected origin, fetched ancestry,
preserved work, created tracking main and checked FF-only current. Used the
prepared runtime/caches and resource guards; no dependency, runtime, security,
credential/network, schedule, environment-publication, other-checkout or user-
machine change occurred. Parent handles Raksasa reconciliation after push.

**Next unresolved step:** combine this conic and the single-response projective
map along jointly realized transitions to obtain an invariant forcing odd-shift
terminal acceptance, or a concrete obstruction. The simultaneous dependence is
now derived; repeating this pencil check, refuted compressions, generic bridge
formalisation or larger witness boxes will not supply that invariant. Uniform
Delta_p=2N and the finite-field characteristic-two frontier remain open.
