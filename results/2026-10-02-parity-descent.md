# Factor-aware parity descent for the auxiliary N-bound

2 October 2026, Friday, Australia/Sydney. Ordinary mathematical proof,
not Lean formalisation. Classification: **mathematical progress on the
auxiliary bound**; no main-conjecture or publication-novelty claim.

## Question, decision and result

Can a vanishing window of length d+N be reduced to smaller degree without
losing the information needed for an upper bound? A successful reduction
would support induction; a failure should identify the missing invariant.
This question was stated before implementation. The only new computation
checks the resulting identities and screens the specific terminal condition.

Let p be an odd prime, r=v_2(p-1), N=2^r, and a the Lai–Sprang stream.
For a polynomial R define B_R(v)=sum_i R_i a_(v+i). Then:

**Theorem.** If R is nonzero, deg R=d, m>=0, and

    B_R(m+k)=0 for every 1<=k<=d+N,

then d>=N(N-1). Moreover, t^N+1 divides R. After r parity descents
there is a nonzero polynomial S of degree floor(d/N), divisible by

    F_1(t)=1+t+...+t^(N-1),

and a shift M>=0 such that B_S(M+k)=0 for 1<=k<=deg S+1.

Consequently the auxiliary j-d<=N bound holds at **every shift** for every
nonzero multiplier of degree d<N(N-1). In particular this covers d<12 for
N=4, d<56 for N=8, and d<240 for N=16. These are consequences of the proof,
not extrapolations from finite boxes. No endpoint hypothesis is needed for
the theorem; in particular it applies to the endpoint-admissible multipliers
in the Littlewood-product formulation. All coefficients here are in F_p.

The all-degree bound is still open in this repository. A sufficient remaining
statement is that every nonzero F_1-multiple has a nonzero coefficient among
its first deg S+1 rows, at every shift, when r>=2. Necessity of this remaining
statement for the original conjectured bound is **not** claimed: descent
discards compatibility between the two parity children.

## Proof of the factor-aware step

Put H=N/2 and Z={zeta in F_p : zeta^H=-1}. This set consists of H distinct
nonzero primitive N-th roots. Every member is a nonsquare in F_p because
N is the full power of two dividing p-1. For u>=0 put

    e_u = a_(2u+1) = sum_(zeta in Z) zeta^u.

The equality follows by expanding the odd part of the defining root sum;
equivalently, the sum is H*(-1)^h when u=Hh, and zero otherwise.
Also a_(2v)=a_v. For a polynomial V write

    E_V(v) = sum_i V_i e_(v+i)
           = sum_(zeta in Z) zeta^v V(zeta),  v>=0.

We prove a stronger induction step. Let s be an **even** divisor of N and put

    F_s(t) = (t^N-1)/(t^s-1) = sum_(i=0)^(N/s-1) t^(si).

Suppose R!=0, F_s divides R, d=deg R, and B_R(m+k)=0 for 1<=k<=d+s.
Then there is a nonzero R' with

    deg R'=floor(d/2),  F_(s/2) divides R',
    B_R'(m'+k)=0 for 1<=k<=deg R'+s/2,  m'>=0.

Write d=2q+epsilon, m=2n+delta, with epsilon,delta in {0,1}, and

    g(t)=(t^H-1)/(t^(s/2)-1),   h=deg g=H-s/2,
    R(t)=F_s(t) U(t),          U(t)=U_0(t^2)+t U_1(t^2),
    E=g U_0,                  O=g U_1.

Thus R(t)=E(t^2)+t O(t^2). Degree bounds, with deg 0=-infinity, are

    deg U_0 <= q-h,       deg U_1 <= q-1+epsilon-h,
    deg R_epsilon = q,    where R_0=E and R_1=O.

Because F_s has degree N-s, divisibility ensures q>=h. The leading parity
component R_epsilon is nonzero; its constant coefficient need not be nonzero.
We do not assume otherwise or normalise it away.

Splitting the parent rows by the parity of m+k gives precisely:

    B_E(n+l)+E_O(n+l)=0                  (1<=l<=A),
    B_O(n+delta+l)+E_E(n+delta+l-1)=0    (1<=l<=B),

where

    A=q+s/2+epsilon*delta,
    B=q+s/2+epsilon*(1-delta).

These formulae include the shift-zero case; the smallest e index is zero.

Convolve the first row sequence with U_1 and start delta rows later;
convolve the second with U_0. Both can be evaluated at
w=n+delta+l for l=1,...,H. Indeed, the required row counts are

    A-delta-deg U_1 >= H+(1-epsilon)*(1-delta) >= H,
    B-deg U_0       >= H+epsilon*(1-delta)     >= H.

For a zero U_i the corresponding convolution is zero and needs no rows.
The B terms cancel, since E U_1=O U_0=g U_0 U_1. Subtracting gives

    sum_(zeta in Z) zeta^(w-1) g(zeta)
         * (U_0(zeta)^2 - zeta U_1(zeta)^2) = 0

for H consecutive w=n+delta+1,...,n+delta+H. The H-by-H Vandermonde
matrix is invertible. Multiplication by each nonzero zeta^(n+delta)
does not change that fact. Hence each root weight vanishes.

Also g(zeta)!=0: in its quotient expression the numerator is -2 and
the denominator is nonzero, since zeta has order N and s/2<N. Therefore

    U_0(zeta)^2 = zeta U_1(zeta)^2.

Nonsquareness of zeta implies U_0(zeta)=U_1(zeta)=0. The distinct-root
factor theorem now gives D(t)=t^H+1 dividing both U_0 and U_1.
Consequently both E and O are divisible by

    g(t) D(t) = (t^N-1)/(t^(s/2)-1) = F_(s/2)(t).

In particular E_E(v)=E_O(v)=0 for all v>=0. The parity equations above
are now homogeneous stream equations. Select the leading child:

    R'=R_epsilon,     m'=n+epsilon*delta.

If epsilon=0, the first system supplies q+s/2 rows. If epsilon=1,
the second supplies q+s/2+1-delta rows, at least q+s/2. This proves
the step, including its degree, shift and complete finite-window claims.

## Iteration and the exact stopping point

Start with s=N and F_N=1, then apply the step r times. The values of s
are N,N/2,...,2,1, and the final degree is floor(d/N). The final polynomial
is divisible by F_1 of degree N-1, so floor(d/N)>=N-1. This proves the
degree threshold. On the first step g=1 and D divides both parity parts
of R, so D(t^2)=t^N+1 divides R as asserted.

The proof does **not** continue unchanged at s=1. F_1 has odd degree and
is not a polynomial in t^2. For R=F_1 V, writing V=V_0(t^2)+t V_1(t^2),
the parity components instead take the form

    E=g_1(V_0+t V_1),   O=g_1(V_0+V_1),
    g_1=(t^H-1)/(t-1),  deg g_1=H-1.

With only d+1 zero rows, the common-factor cross-convolution argument
guarantees only H-1 consecutive root moments in its worst parity cases.
Vandermonde needs H. An (H-1)-by-H matrix at distinct nonzero roots has
rank H-1: one root-weight direction remains. This is the precise loss;
it is not a counterexample to the terminal statement. The relations between
V_0+t V_1 and V_0+V_1, or compatibility with sibling children, could still
eliminate that direction, but this run does not prove they do.

For r=1, the original comparison R=1+t^2,m=2 descends to S=1+t,M=1.
Over F_3 its first three coefficients are 0,0,2. Thus it really violates
the terminal d+1-row claim. Any proof of the terminal statement must use
r>=2. This also prevents treating descent alone as an all-degree proof.

The full parent window matters. The already-proved degree-zero sharp gap
R=1,m=5N+1 has N-1 zero rows but is not divisible by t^N+1. Thus the
first-step divisibility claim cannot simply drop its final row.

## Targeted exact verification

`python3 -m search.lai_sprang_descent_check` uses Python 3.9.6, standard
library only, no randomness. Output is retained in
`results/2026-10-02-descent-check.json`; runtime was 17.03708225 seconds.

- For p=3,5,13,41,17, all dyadic s from 2 through N, eight explicitly
  listed coefficient vectors (reduced and trimmed in each field), and
  m=0,...,2N+1, check the parity rows, row-budget inequalities, forced-factor
  product, root nonsquareness and nonzero g evaluations. Direct coefficients
  come from the independent original-root-sum oracle. The 26,482 parity
  identities and 11,120 cross-moment identities hold without assuming a
  vanishing window, avoiding vacuous testing of the theorem's hypothesis.
- The terminal screen uses R=F_1 U, normalised U(0)=1 and nonzero leading
  coefficient, quotient degree e=0,...,2N, m=0,...,16N, cutoff e+N+1,
  in p=5,13,41,17. It asks specifically whether the first e+N=deg R+1
  rows can vanish. Existing endpoint-aware affine elimination solves every
  input; the existing independent dot-product checker verifies every primal
  and dual against a separately generated root-sum derived stream.
- All 11,844 terminal inputs resolve, with no such vanishing window. The
  maximum observed j-deg R is 1 in each field. This only leaves the terminal
  statement plausible within those bounds; it is not proof and is not the
  mathematical increment. Individual generated certificates are verified in
  memory, not exported; the deterministic script reproduces the screen.
- Keep the r=1 terminal violation and the one-row-short parent negative
  control above. No expanded attainment or retired binary-stream search.

The original affine solver is unchanged. In the terminal screen, requesting
derived coefficient n reads original coefficients n,...,n+N-1, inclusively.
Its last possible original index is m+e+cutoff+N-1. Cutoff exhaustion would
remain explicitly unresolved; none occurred. Degree/shift bounds here are
finite even though the ordinary theorem quantifies over every shift.

The existing Python suite also passed: `python3 -m unittest discover -s tests -v`,
41 tests in 3.543 seconds. No Lean source or dependency changed and no Lean
build was run. The proof was reviewed against the explicit four degree/shift
parity cases; source, report and complete diff were inspected before committing.

## Literature, attribution and next work

Primary sources accessed 2 October 2026:

- Lai–Sprang, [arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  submitted 30 May 2026. Their Theorem 1.2 settles the odd-characteristic
  existence question. Their [Section 3 proof](https://arxiv.org/html/2606.00633v1#S3)
  supplies the parity, Vandermonde and nonsquare method adapted here.
  This report tracks a different factor and surplus through that method;
  it does not claim an independent new technique or established novelty.
- Badziahin–Pavlenkov–Zorin,
  [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1), submitted
  22 August 2026. Its characteristic-two conclusion remains conditional on
  counterexample existence. A scoped primary-source search found no later
  resolution, but search results were noisy; no comprehensive absence claim.
  No characteristic-two candidate was proposed or searched in this run.

Next mathematical question: can the missing terminal root moment be recovered
from the linked expressions V_0+t V_1 and V_0+V_1 when r>=2, or can a
terminal counterexample be found that explains which sibling compatibility
was lost? Do not replace this with larger unconstrained boxes. A suitable
formal target is the factor-aware s-to-s/2 reduction, enabling the proved
degree cutoff; another routine norm bridge is unnecessary.
