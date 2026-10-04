# Reverse terminal lift and the N-or-2N dichotomy

5 October 2026, Monday, Australia/Sydney (AEDT).
Classification: **mathematical progress on the auxiliary bound**. Ordinary
proofs, not Lean theorems; no resolution of that bound, characteristic-two
advance or established publication novelty.

## Question and decision

Can the original terminal parity rows eliminate Sunday's surviving scalar,
or must descent retain a stronger invariant? The question and decision criteria
were stated before coding. This run does not force the scalar to vanish. It
instead proves that terminal counterexamples lift back to original ones, so
lost sibling compatibility cannot explain away a terminal counterexample.
It also confines a minimum-degree terminal counterexample to an odd shift
with nonzero scalar. These change the next proof target without expanding a
search box.

Fix an odd prime p, r=v_2(p-1), N=2^r, H=N/2, and the repository's infinite
Lai–Sprang stream a. Write

    B_T(v)=sum_i T_i a_(v+i),       v>=1,
    F=1+t+...+t^(N-1),             G=t^N-1.

The coefficient convention is unchanged: row k at shift M is B_T(M+k).

## 1. Exact reverse lift

**Lemma.** If F divides S, set T_i(t)=S(t^(2^i)) for 0<=i<=r. Then, for
all positive integers v,

    B_(T_i)(v) = B_S(v/2^i)   if 2^i divides v,
                 0           otherwise.

No constant-term condition is needed. If S has exact first index j at shift M,
then T_i has exact first index 2^i*j at shift 2^i*M.

**Proof.** Let Z be the H primitive N-th roots in F_p. The stream identities
are a_(2u)=a_u for u>=1 and a_(2u+1)=sum_(z in Z) z^u for u>=0.
For 1<=i<=r, the even rows of T_i=T_(i-1)(t^2) are B_(T_(i-1))(v/2).
Its row at 2u+1 is

    sum_(z in Z) z^u T_(i-1)(z)
      = sum_(z in Z) z^u S(z^(2^(i-1))) = 0.

Indeed z^(2^(i-1)) is an N-th root of order N/2^(i-1)>=2. It is a root
of F, so every summand vanishes. Induction proves the identity. At shift
2^i*M, all positive rows not divisible by 2^i vanish; the divisible rows
are exactly the rows of S at M. This proves the exact-index assertion.

The last allowed scale matters. At i=r+1, S=F has row 1 equal to H*N,
which is nonzero in F_p. The factor also matters: replacing F by
1+t^2+...+t^(N-2) at scale N gives row 1 equal to H^2, also nonzero.
Neither the scale range nor the full geometric factor may be omitted.

## 2. Terminal windows have exact excess two

We use **Lai–Sprang Proposition 2.3**, not a new result: a nonzero multiple
U of G cannot have its first deg U rows zero at any nonnegative shift.
This is the coefficient form of their strict fractional-size inequality.

For any nonzero S with F|S and D=deg S, consider U=(t-1)S. Then G|U,
deg U=D+1, and

    B_U(M+k)=B_S(M+k+1)-B_S(M+k).

If S had its first D+2 rows zero, U would have its first D+1 rows zero,
contradicting the proposition. Thus S always has a first nonzero row, by D+2.
In particular, a **terminal counterexample** (first D+1 rows zero) has
exactly j=D+2.

Such a counterexample necessarily has S(0)!=0. Otherwise write S=t^h S0,
h>=1. Since F(0)=1, F|S0. Its same zero window is at shift M+h, and has
length D+1>=deg S0+2, contradicting the bound just proved. Scalar
normalisation is therefore available without changing the index or degree.

## 3. Equivalence and dichotomy

Assume r>=2. The following statements are equivalent:

1. Every endpoint-admissible R over F_p, at every shift, has j-deg R<=N.
2. Every nonzero F-multiple S, at every shift, has a nonzero row among
   1,...,deg S+1.

The implication from (2) to (1) is the ordinary factor-aware descent proved
on 2 October: an original violation supplies such a terminal counterexample.
For the converse, a failure of (2) has S(0)!=0 and j=D+2 by Section 2.
The reverse lift R=S(t^N), m=NM then has

    deg R=ND,   R(0)!=0,   exact first index=N(D+2),
    j-deg R=2N.

It is an admissible original violation, proving equivalence. In particular,
a genuine terminal counterexample cannot be dismissed as a consequence of
compatibility discarded by the earlier descent. The reverse construction
supplies compatible ancestors with zero odd children.

Let Delta_p be the maximum defect over all admissible multipliers and shifts
for this fixed prime. It exists because the defects are integers, the set is
nonempty, and Lai–Sprang Theorem 1.2 bounds them by 2N. The proved degree-zero
attainment supplies Delta_p>=N. If there is any defect above N, the descent
and reverse lift supply one equal to 2N. Therefore

    Delta_p is either N or 2N.

Equivalently, the infimum of the Littlewood products for this stream over F_p
is either 2^(-N) or 2^(-2N). **This does not select either alternative.**
It constrains the optimum, not every individual defect; intermediate individual
values are not excluded. No arbitrary-ground-field extension is asserted here.

The r=1 comparison is retained: S=1+t, M=1 over F_3 has rows 0,0,2.
The lift R=1+t^2, m=2 has five zero rows and then 2, so j=6 and defect
4=2N. This is the existing comparison, not a new attainment family.

## 4. A minimum-degree terminal counterexample has odd shift and C!=0

Suppose terminal counterexamples exist and choose one S=FV of minimum degree
D across all nonnegative shifts. Write D=2q+epsilon, M=2n+delta, and
S=E(t^2)+t O(t^2). Sunday's moment lemma shows:

- At even shift, t^N+1 divides V.
- At odd shift, with V=V0(t^2)+t V1(t^2),
  V0^2-t V1^2 = C t^(-n) modulo t^H+1. If C=0, nonsquareness of the
  roots again forces t^N+1 to divide V.

Whenever this factor is forced, F divides both E and O. To check this,
write V0=(t^H+1)W0 and V1=(t^H+1)W1 in the linked expressions
E=g(V0+tV1), O=g(V0+V1), where g=1+...+t^(H-1) and g(t^H+1)=F.
Their odd-subsequence contributions vanish, leaving the original parity rows
as homogeneous stream equations:

    B_E(n+l)=0                 for 1<=l<=A,
    B_O(n+delta+l)=0           for 1<=l<=B,
    A=floor((D+1+delta)/2),    B=floor((D+2-delta)/2).

If epsilon=1, O has degree q and B=q+1, giving a smaller terminal
counterexample. If epsilon=0 and delta=1, E has degree q and A=q+1,
again giving a smaller one.

The remaining case is epsilon=delta=0. Here A=q and B=q+1. If O!=0,
its degree is at most q-1, so its rows give a smaller terminal counterexample.
If O=0, then S=E(t^2). Since F|S, S(-1)=E(1)=0. We already have F|E;
as F(1)=N!=0, it follows that G=(t-1)F divides E. Its q zero rows
contradict Lai–Sprang Proposition 2.3, since deg E=q.

Every case contradicts minimality. Thus a minimum-degree terminal
counterexample has **M odd and C nonzero**. The remaining proof obligation
is to rule out the actual parity rows with C!=0 at odd shifts.

Also gcd(V,t^N+1)=1 in that minimal counterexample. Indeed

    t^N+1 = product_(z in Z) (t^2-z),

and these quadratics are irreducible over F_p. Such a factor divides V
exactly when V0(z)=V1(z)=0, which is impossible because
V0(z)^2-z V1(z)^2=C z^(-n)!=0. This gives an additional restriction on
any future proposed obstruction. It does not prove one exists or is impossible.

## Verification and limits

Command: `python3 -m search.terminal_lift_check`.
Python 3.9.6, standard library only, deterministic, seed null. The saved JSON
records runtime, ranges, prescribed quotient vectors and inclusive endpoints.
It checks all residue classes of positive row indices 1,...,4N+1 at every
scale i=0,...,r for p=3,5,13,41,17 and five specified V, including V=t.
Direct lifted rows use the independent original-root-sum oracle; the other
side uses the support formula. There are 2,885 identity evaluations.
Negative controls omit the full factor or exceed the allowed scale; the
actual r=1 lift and all four row-budget parities are retained. The largest
original index read, including the beyond-scale control, is 481.

These are finite checks of formulas with both zero and nonzero values, not
an exhaustive multiplier search or proof by agreement. There is no optimiser,
cutoff exhaustion, random search, certificate export or new attainment search.
The mathematical conclusions follow from the proofs above, the earlier
ordinary descent/moment lemmas, and the cited published/preprint results.
The existing Python suite is run as a regression for the reused stream and
oracle; results are in the validation JSON. No Lean source or dependency
changed, and no Lean build was run. These statements are not Lean-formalised.

## Literature and next decision

Primary sources accessed 5 October 2026, Australia/Sydney:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  submitted 30 May 2026; v1 remains listed. [Proposition 2.3 and Section 3](https://arxiv.org/html/2606.00633v1#S3)
  are essential inputs, alongside the functional equation and coarse bound.
  The ordinary refinements here use their method; publication novelty has
  not been established. The odd-characteristic main existence question stays settled.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  submitted 22 August 2026, still makes the characteristic-two conclusion
  conditional on existence of a counterexample. Scoped searches returned no
  later resolution, but were noisy and do not establish absence.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  and [Garrett–Robertson, arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5)
  were revisited for the quadratic-series and unbounded-window exclusions.
  No new binary candidate is proposed; retired streams remain retired.

Next substantive question: can the original odd-shift parity rows coexist
with C!=0 and gcd(V,t^N+1)=1 in the norm congruence? A genuine terminal
witness now suffices to refute the N-bound by explicit reverse lift; there
is no separate sibling-compatibility barrier. If no implication is found,
record that precise obstacle rather than expanding routine boxes.
The next Lean path remains the named-stream/window-to-moment derivation
needed for the degree cutoff; this ordinary result does not complete it.
