# A bounded root-evaluation relation for terminal Hankel recursion

19 October 2026, Monday, Australia/Sydney (AEDT).
Classification: **mathematical progress: an ordinary structural lemma**, with
exact finite checks. Not a Lean theorem, new sharpness witness, characteristic-two
advance, or established novelty claim. The auxiliary N-bound was already
refuted on 17–18 October; this addresses its successor sharpness question.

## Question stated before coding

Can parity splitting of the terminal Hankel problem close on boundary data of
dimension bounded in terms of N, independently of quotient degree e? A closed relation
would replace the unbounded matrix in the next structural investigation. A
failure of closure or an invisible kernel would identify missing state data.
The starting roadmap explicitly requested this test, against the existing
p=5,e=8 witness and N=8,e=4 cover, without expanding a witness search.

**Outcome.** Keep evaluations at *all* N-th roots, not just primitive roots.
A relation in F_p^(2N) closes under parity splitting, using only 3N variables
in each merge. For nearly square blocks it loses no kernel vectors. The
terminal event is membership of one fixed vector in this relation. This gives
an exact bounded-state recurrence, but no reachable-state classification or
decision of the 2N branch for any previously undecided prime.

## 1. The state and its injectivity

Fix an odd prime p, N=2^v_2(p-1), H=N/2, and work over F_p. Let c be the
Lai–Sprang coefficient stream divided by H. For positive indices,

    c_(2k)=c_k,
    c_(2k+1)=H^(-1) sum_(z in Z) z^k,
    Z={z : z^H=-1}.

Let Omega={z : z^N=1}, so |Omega|=N, Z is a subset, and squaring maps
Omega into itself. Write U_l=(z^i)_(0<=i<l,z in Omega). For t>=1 and
nonnegative m,n with |m-n|<=1 set

    A_t(m,n)=(c_(t+i+j))_(0<=i<m,0<=j<n),
    R_t(m,n)={(u,v) in F_p^N x F_p^N :
                 A_t(m,n) x=U_m u, U_n^T x=v for some x in F_p^n}.

The forcing coordinate u is retained even when U_m has dependent columns.
Matrices with zero rows or columns have their usual empty-system meaning.

**Lemma 1 (no invisible vectors).** The matrix obtained by stacking A_t(m,n)
and U_n^T has trivial kernel. Thus every (u,v) in R has a unique preimage x.

*Proof.* If x is in this kernel, its polynomial X(T)=sum_(j<n) x_j T^j
vanishes on Omega, hence T^N-1 divides X. If X is nonzero, its degree d is
at most n-1<=m. The m rows of A x=0 are exactly the first m fractional
coefficients of T^(t-1) X Lambda, up to the nonzero scalar H. Consequently
the fractional size is at most 2^(-m-1)<2^(-d). This contradicts
[Lai–Sprang Proposition 2.3](https://arxiv.org/html/2606.00633v1#S2), at the
nonnegative shift t-1. For n=0 there is nothing to prove. QED.

Apply the same lemma to A^T=A_t(n,m). The matrix [A,-U_m] has full row rank:
a vector in its left kernel would be invisible for A^T. Its solution space
in (x,u) therefore has dimension n+N-m. Lemma 1 says projection to (u,v)
is injective, giving the exact dimension

    dim R_t(m,n)=N+n-m.                                      (1)

For square blocks R has dimension N and is isotropic for
omega((u,v),(u',v'))=u^T v'-v^T u'. Indeed this expression equals
x^T A^T x'-x^T A x'=0. Hence square states are Lagrangian subspaces.
These conclusions use the admissible characteristic relation N=2^v_2(p-1);
they are not claims about arbitrary reductions of the same integer stream.

## 2. An exact merge using 3N variables

Split row and column indices by their parity. Put

    m_a=floor((m+1-a)/2), n_b=floor((n+1-b)/2), a,b in {0,1}.

For row parity a, let b be (t+a) modulo 2 and b'=1-b. Then the block in
column parity b has even stream indices and is

    A_((t+a+b)/2)(m_a,n_b).

The other block has odd stream indices and equals

    U_(m_a) K_k U_(n_b')^T,
    k=(t+a+b'-1)/2,
    (K_k)_(z,z)=H^(-1) z^k if z in Z, and 0 otherwise.       (2)

Define the fixed N-by-N map D_a by

    (D_a u)_w=sum_(z in Omega, z^2=w) z^a u_z.

The row-parity restriction of U_m u is U_(m_a) D_a u. If x_0,x_1 are
the even/odd coefficient vectors and v_b=U_(n_b)^T x_b, the parent equation
is thus equivalent to the two memberships

    (D_a u-K_k v_b', v_b)
       in R_((t+a+b)/2)(m_a,n_b),             a=0,1.         (3)

Let W be the subspace of triples (u,v_0,v_1) satisfying (3). The parent
relation is exactly its image under

    (u,v_0,v_1) -> (u,v),  v_z=(v_0)_(z^2)+z (v_1)_(z^2). (4)

*Proof of both directions.* A parent solution restricts to solutions of the
two block equations, so gives a triple in W and (4). Conversely (3) supplies
the two coefficient vectors x_b with exactly their specified moments. The
odd blocks depend only on these moments by (2); interleaving x_0 and x_1
therefore solves the parent equation and has the moments (4). Nothing is
discarded at a row endpoint. By Lemma 1 both child reconstructions are unique;
if (4) is zero, the interleaved parent vector is invisible and hence zero.
Thus (4) is also injective on W. QED.

Every child still has |m_a-n_b|<=1 and positive starting index. For
max(m,n)>1 its maximum size is smaller than the parent's. Stop at sizes
at most one; their relations use only the single value c_t (or empty blocks).
The stored state always has 2N coordinates, each merge has 3N variables, and
the forcing coefficients depend on k only modulo N. No invertibility of a
Hankel block is assumed, and no inverse or coefficient vector of growing
size is retained. The quotient degree has disappeared from the state size.

For each fixed p there are finitely many possible subspaces of F_p^(2N).
This fact and the recurrence do **not** establish which states occur for
actual paired shift/size inputs. Arbitrarily pairing independently reachable
child states can create false positives. No finite automaton, closed reachable
set, practical complexity bound, or uniform-in-p sharpness theorem is claimed here.

## 3. Terminal detection and endpoints

Let F=1+T+...+T^(N-1), e>=0, n=N+e and t=M+1. The usual derived terminal
matrix has rows sum_j V_j sum_(i=0..N-1) c_(M+k+j+i), k=1,...,N+e.
Writing S=F V turns these into the square system A_t(n,n) S=0.

**Lemma 2 (one target vector).** A terminal window at degree e and shift M
exists if and only if

    (0,e_1) in R_(M+1)(N+e,N+e),                           (5)

where e_1 has value 1 at the root 1 and zero at every other root in Omega.

*Proof.* F divides S exactly when S(z)=0 for z in Omega other than 1.
A nonzero terminal S cannot also have S(1)=0: it would be invisible by
Lemma 1. Scale to S(1)=1 to obtain (5). Conversely a preimage of (5) is
nonzero, is divisible by F, and has the required zero rows.

To check that this is the exact-degree, endpoint-admissible event, recall the
short consequence of Proposition 2.3: a nonzero F-multiple of degree D
cannot have D+2 zero rows. Otherwise (T-1)S, divisible by T^N-1 and of
degree D+1, would have D+1 zero difference rows, contradicting the proposition.
Thus a preimage in (5), with n zero rows, must have degree n-1 and first
nonzero row n+1. It also has nonzero constant coefficient: removing a factor
T would produce a lower-degree F-multiple with the same n zero rows at the
shift M+1. Both endpoints of V are nonzero because F is monic with constant
coefficient 1. The existing reverse lift gives original defect exactly 2N.
QED. This adds no new existence result: it is an equivalent test.

## 4. Why primitive-root moments are insufficient

At p=5,t=312,n=12 the already proved terminal polynomial is

    S=[2,3,4,0,1,3,3,3,1,3,2,1]   (ascending coefficients).

Its root evaluations at [1,2,3,4] are [1,0,0,0]. Its Hankel rows vanish,
and its evaluations at both primitive fourth roots vanish. A state retaining
only those primitive-root moments makes this actual kernel vector invisible.
Also, parity substitution squares evaluation points: starting from primitive
roots and closing under squaring requires all of Omega, including 1. This
rules out the narrower moment state; it does not rule out other compressions
that explicitly retain invisible-kernel information.

## 5. Bounded checks and reproducibility

Sources read: the actual support/original-root-sum implementations, terminal
matrix and cover/profile code, affine solver, and 5/17/18 October proof records.
The clean checkout fast-forwarded from 28afe09 to 1eea18a before selection.
The intervening wall-engine commits are independent of this work; no wall
search or engine modification was performed.

Commands, Python version and runtimes are in
[the validation record](2026-10-19-boundary-relation-check.json).

    python3 -m search.terminal_boundary_relation
    python3 -m unittest discover -s tests -p test_terminal_boundary_relation.py -v
    python3 -m unittest discover -s tests -p test_lai_sprang_sharpness.py -v

Python standard library, exact F_p arithmetic, no randomness/seed. The new
recursive implementation only constructs scalar Hankel bases. Direct readback
constructs the full relation using the independent original root-sum oracle,
including all forcing directions, not just its nullity. Prescribed comparisons:

- p=3,5,13,41,17 (N=2,4,4,8,16); n=0 through 8,16,12,16,8 respectively;
  m=max(0,n-1),n,n+1; t in {1,2,3,4,7,8,15,16,31,32}. This checks both
  parities, empty blocks, dimension (1), absence of invisible vectors, and
  isotropy for square blocks. Repeated m=0 at n=0 is harmless and included
  in the reported comparison counts.
- Existing p=5,e=8 and p=41,e=4 abstract covers, restricted to cases with an
  actual representative M=b+qP, 0<=q<2N. There are 248/320 and 424/640 such
  representatives. Compare entire relations and terminal membership with the
  direct derived matrix. The p=5 hits are the existing M=311,631 pair;
  no p=41 hit. The 72/216 unrepresented abstract cases are **skipped**, not
  silently assigned a stream or claimed excluded by the recurrence check.
- Independent affine-solver reconstruction of every basis vector in six
  selected relations, including the existing p=13 degree-76 terminal system.
  Each reconstructed vector is checked by dot products with original root
  sums. This supplements the two paths sharing the older nullspace routine.
- The target at p=5 reconstructs the exact known S above; changing the shift,
  adding the next row, or altering a root moment is rejected. The r=1 p=3
  terminal event remains a positive control. A guard rejects any recursive
  call attempting a direct Hankel calculation larger than 1 by 1.

These are finite checks of a proved identity, not an exhaustive multiplier or
state search. No truncated series is treated as an infinite certificate; a
direct m-by-n block reads through t+m+n-2 when both sizes are nonzero. No
Lean source/dependency changed and no Lean build is claimed.

## 6. Literature, limits and next decision

Primary sources accessed **19 October 2026 (Australia/Sydney)**:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  still v1 of 30 May 2026. Its functional equation and Proposition 2.3
  are explicit inputs above; odd-characteristic main-conjecture failure is
  already their theorem. Today's lemmas are deductions, not a claimed new
  proof of that result or an established publication priority.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  22 August 2026, still conditional on existence in characteristic two.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2),
  11 October 2020, supplies the quadratic-series exclusion context;
  [Garrett–Robertson, arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5),
  8 April 2025, discusses known unbounded-window examples. Rational series
  are excluded by multiplying by a denominator. No new binary candidate was
  selected and none of the three retired streams was expanded.

Scoped arXiv searches for Littlewood in characteristic two/2 and Lai–Sprang
sharpness found no later relevant resolution. This is not proof of absence.

**Next mathematical question:** can a finite tuple of these relations for
adjacent offsets and nearly square sizes be closed under simultaneous binary
transitions, preserving correlations between siblings, and can its reachable
set contain (0,e_1)? First derive the tuple/transition rules and test them on
the already known p=5 event. Do not replace correlated reachability with free
pairing of states or launch a larger wall box. If the state space cannot be
controlled, report that obstacle; bounded coordinate dimension alone does not
make enumeration feasible. A focused future formal lemma is the odd-block
factorization (2), followed by the merge equivalence (3)-(4), using existing
named-stream identities. Lemma 1 retains an explicit literature dependency
on Proposition 2.3 until that input itself is formalised.
