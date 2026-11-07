# A reachable dyadic corner family has only two values

8 November 2026, Sunday, Australia/Sydney. Scheduled invocation:
7 November 21:20 UTC; executed 7 November UTC / 8 November AEDT.

**Mathematical progress on auxiliary reachable-state structure:** an ordinary
all-odd-prime lemma identifies a canonical correlated family and its exact
two-point corner range. It rules out sweeping the projective pencil by simply
extending this dyadic ray. It supplies no uniform accepting path, new prime
decision, characteristic-two result, Lean theorem or novelty claim.

## Question and decision

Read the [6 November weekly human-literature review](2026-11-06-literature-review.md)
and current sources before selection. The remaining step after the projective,
conic and selector arguments is **reachability of an accepting parameter**.
The two known inputs T(62,8), T(126,8) lie on q=2^a-2 at fixed size.
Before coding, asked whether this actual dyadic family sweeps the missing
projective line as a increases. A sweep would provide a parameter-selection
mechanism; stabilization would retire that mechanism for this family.

It stabilizes after exactly one change in the range below. This is stronger
than the previous two-input observation: the family, the common seven
relations, its two distinct remaining lines and its eventual full-state
stabilization are derived for every odd prime. It does not classify all states
sharing those seven relations. Other shifts and other sizes remain possible.

## Exact coefficient window

Let p be an odd prime, r=v_2(p-1)>=1, N=2^r, H=N/2. Write c_n=a_n/H
for the normalized Lai-Sprang coefficient. For n>0 with odd part u,

    c_n = 0 unless u=1 mod N;
    c_n = (-1)^((u-1)/N) otherwise.

Use the existing relation

    R_t(m,n)={(u,U_n^T x): A_t(m,n)x=U_m u},
    (A_t)_ij=c_(t+i+j), (U_m)_iz=z^i, z^N=1.

The actual state T(q,k) stores R_(q+1+d)(k+i,k+j), d,i,j in {0,1},
q mod N and min(k,N). Fix s>=r+1, put k=2^(s-1), and take a>=s+r.
For B=2^a its complete required coefficient window is

    c_(B-1) = -1 if N=2, and 0 if N>=4;
    c_B = 1;
    c_(B+j) = c_j                    (1<=j<2k);
    c_(B+2k) = -1 if a=s+r, and +1 if a>=s+r+1.             (1)

**Proof.** For 0<j<2k=2^s, write j=2^v u with u odd and v<=s-1.
Since a-v>=r+1, the odd part of B+j is u+2^(a-v), congruent to u
modulo 2N. This preserves both support and sign. At j=2^s the odd
part is 1+2^(a-s): its sign is (-1)^(2^(a-s-r)), giving the last line.
At j=0 the odd part is 1. At j=-1 the odd part is B-1, which is not
1 modulo N when N>=4; when N=2 its sign is
(-1)^(2^(a-1)-1)=-1, since a>=3. QED.

Only the far square R_(q+2)(k+1,k+1), q=B-2, reads the final coefficient
in (1), and only its bottom-right Hankel entry reads it. All seven other
full relations are constant along the ray. The phase is always -2 modulo N
and the size is the same saturated k. Thus the whole state is constant for
a>=s+r+1; at a=s+r it can differ only in that square. The next argument
proves that the two squares really differ, without assuming a Hankel inverse.

In particular the canonical choice k=2N gives s=r+2 and

    T(4N^2-2,2N), T(8N^2-2,2N), T(16N^2-2,2N), ... .

The first state and the common later state are the exact two values. For
p=5 these begin with the existing T(62,8), T(126,8) pair.

## The endpoint gives a full algebraic pencil, but the ray reaches two lines

Use the constant prefix at t=B=2^(s+r). Put

    W=R_B(k,k+1), L=R_B(k+1,k), A=R_B(k,k).

These are actual stream relations. The existing no-invisible-vector result,
from Lai-Sprang Proposition 2.3, makes projection of the wide solution space
to W injective. Its transpose gives full row rank of [-U_k | A_B(k,k+1)].
Consequently dim W=N+1 and dim L=N-1; the analogous square dimension is N.
These are the same nearly-square dimension arguments used in the existing
boundary/transport reports, not an invertible-square assumption.

For w=(u,v) in W let x=(x_0,...,x_k) be its unique wide preimage. Define
linear functionals on W by

    psi(w)=x_k,
    phi(w)=sum_(j<k) c_(B+k+j)x_j - sum_(z^N=1) z^k u_z.

Appending the last row with arbitrary bottom-right coefficient x gives

    C_x=ker(phi+x*psi) in W.                                  (2)

Here the scalar x in C_x is distinct from the polynomial-coordinate vector.
The common kernel ker(phi) intersect ker(psi) is exactly L: psi=0 trims
the last polynomial coefficient, and phi=0 supplies the missing final row.
Hence (phi,psi):W->F_p^2 has rank two. Also ker(psi)=A, since trimming
the polynomial while keeping just the first k rows is the smaller square.

It follows that C_x for x in F_p, together with C_infinity=A, are precisely
all N-dimensional subspaces between L and W. They are pairwise distinct.
Equivalently, x maps projectively and bijectively to the corresponding line
in W/L. Rank persists under every field extension of F_p, so this is also
the full algebraic pencil over such an extension. In particular C_-1 and
C_+1 are distinct because p is odd; their intersection is L and sum is W.

Equation (1) now establishes the exact actual range on the ray:

    a=s+r:     missing corner C_-1;
    a>s+r:     missing corner C_+1.                            (3)

Every other point of this pencil is absent **from this ray in this range**.
No global non-reachability assertion follows. In particular, extending a
dyadic shift exponent cannot turn the bijective projective transport law
into an orbit visiting every parameter. It eventually repeats the same state.

For the existing F_5 chart, C_-1 has lambda=0, C_+1 has lambda=4 and
C_infinity=A has lambda=infinity. Thus lambda=2x+2. The already certified
five-digit selector accepts exactly x=-1. Reusing that certificate and (3),
its output accepts a=6 and rejects every a>=7 on T(2^a-2,8). This infinite
ray statement is a consequence of stabilization, not a new suffix enumeration
or uniform-prime selector. The F_5 suffix is not asserted to work elsewhere.

## Checks and scope

The proof above is ordinary mathematics. Three exact Python tests support it,
using original root sums independently of the integer support formula and
comparing actual state recursion with all eight directly constructed relations.
Prescribed fields p=3,5,13,41 and s=r+1,r+2 cover eight contexts. The exponents
checked are exactly a=s+r,s+r+1,s+r+2, with j=-1,...,2k inclusive. The largest
original coefficient read is 1056. No randomness or seed is used.

The endpoint tests construct the actual wide solution space, check its
projection and the two functionals' rank, and check every p+1 abstract pencil
member against its common borders. The actual -1,+1 and infinity members
are compared with the corresponding original-coefficient squares. These finite
eliminations are identity controls, not independent certificates of the
all-prime theorem. The infinite claim rests on the displayed proof and the
existing Proposition 2.3 input, not finite agreement. No terminal/attainment
search, graph enumeration, enlarged degree box or generic tool was added.

Reproduction, from the repository root with prepared runtime exports:

    python3 -m unittest discover -s tests -p test_dyadic_corner_family.py -v
    python3 -m unittest discover -s tests -q

Commands use prepared prepare.py's guarded runner and env_for('littlewood'),
with 2 GiB disk reserve, 12 GiB process-group RSS, two Lean threads and a
300-second command bound. Commands, results, timings and hashes are retained in
[the validation record](2026-11-08-dyadic-validation.json). The three focused
tests passed in 0.470 seconds (1.001 seconds including the guard); the full
128-test suite passed in 19.352 seconds (20.013 seconds including the guard).
No development/test failure occurred. No Lean code changed,
so no new Lean build or axiom-audit claim is made. Challenge.lean:37 and its
downstream assumed claims supply no premise here.

Primary recheck accessed **7 November UTC / 8 November 2026 Sydney**:
[Lai-Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
30 May 2026, the sole listed version; read
[Theorem 1.2, (1.2) and Proposition 2.3](https://arxiv.org/html/2606.00633v1).
The lower bound applies to every irreducible P over every odd-characteristic
ground field; it does not assert uniform attainment. The present lemma is an
internal deduction. Reuse the weekly review's bounded coverage and older
journal full-text gaps; no broad daily literature search, new binary candidate
or absence/priority claim was made. Existing Apache-2.0 sources and mathematical
attribution are retained; no external implementation or prose was copied.

The selected shared environment's complete check passed, including Scholz;
the previously missing receipt exists in this restored instance. Exact pins,
dependencies and representative imports passed without setup or downloads.
This run did not repair or publish shared setup. Clean work at 8d9d788 matched
the expected solresol origin and fetched main; ancestry verified, work preserved,
tracking main created. Only this repository was edited. No schedules, sibling
checkouts, runtime/configuration, security/credentials or user hosts were changed.

## Sunday reassessment and next step

This week's **mathematics** supplies projective transport, the simultaneous
conic, terminal separation/selection at F_5, and now an exact correlated
two-point family over every odd prime. Its **verification** supplies bordered
reconstruction and the even-shift short-window prerequisite in Lean. These
roles remain separate: neither uniform Delta_p=2N nor characteristic two has
been settled or given a new decided case. The retired N-bound and binary
baselines remain retired.

Next derive an accepting criterion whose locus meets one of C_-1,C_+1 for
this canonical family uniformly in p, or find a structural obstruction to
that criterion. A mechanism needing a third, freely chosen corner parameter
must change the reachable shift/size family; increasing a on this ray cannot
supply it. Do not enumerate more F_5 suffixes or repeat the transport/short-window
formalisation to replace that remaining acceptance problem.
