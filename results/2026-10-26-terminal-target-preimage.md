# Terminal target preimages: exact even-shift stripping and an odd-shift obstruction

26 October 2026, Monday, Australia/Sydney (AEDT; 25 October UTC).
Classification: **mathematical progress on the auxiliary sharpness structure**:
an ordinary exact acceptance recursion and a stronger failed simplification.
No new prime, uniform terminal existence, Lean theorem, characteristic-two
advance or publication-priority claim is established.

## Question and decision

Before coding: can the one-digit preimage of `(0,e_1)` in Sunday's four-square
state give a useful compatibility condition on primitive-root moments? The
unresolved step is finding a uniform accepting word, hence proving `Delta_p=2N`
for all odd primes. A reduced criterion could guide those words; a failed
criterion should identify the information that must survive. Read the
[24 October weekly human-research review](2026-10-24-literature-review.md)
before selection; no broad daily literature search was repeated.

**Outcome.** Even-shift events strip exactly by a simultaneous binary zero.
Odd-shift acceptance retains an explicit affine quotient obstruction. Both
children can be individually feasible, and one complete original parity system
can satisfy the full old norm congruence, while their coupling still fails.
Thus one parity subsystem plus norm moments is retired as a sufficient test.

## 1. Exact one-digit criterion in N primitive variables

Use the normalized stream and boundary relations of
[19 October](2026-10-19-boundary-relation.md). Let `N=2^v_2(p-1)`, `H=N/2`,
`Omega={z:z^N=1}`, `Q=Omega^2`, and `Z=Omega\Q={z:z^H=-1}`. Squaring has
two-element fibers on Q; Z is the set of nonsquares in Omega, and all its
members are nonsquares in F_p. Put

    alpha = (1/2)e_1,
    D_s = H^(-1) diag_(z in Z)(z^s),
    L_d^i = R_(q+1+d)(k+i,k+i),
    J_0 = L_0^0 intersection L_0^1,   W_0 = L_0^0 + L_0^1.

The last two identities use Sunday's ordinary four-square theorem, including
singular and empty blocks. Let `A(M,n)` mean target membership
`(0,e_1) in R_(M+1)(n,n)`. It has no size-cap predicate. Target membership
already implies `n>=N` by divisibility by `F=1+...+X^(N-1)`.

For the digit `(epsilon,eta)`, the new target is `A(2q+epsilon,2k+eta)`.
Write the parity output moments as `v_b=alpha+x_b`, where x_b is supported
on Z, for b=0,1. Indeed the parent output equation

    v(z)=v_0(z^2)+z v_1(z^2)=e_1(z)

fixes `v_0(1)=v_1(1)=1/2`, and both outputs vanish at all other points of Q.
Only x_0,x_1 remain free: 2H=N variables. Substitution into the proved merge
gives this exact table; every displayed pair is `(forcing, output)`:

| digit | first child membership | second child membership |
|---|---|---|
| (0,0) | `(-D_q x_0,alpha+x_1) in L_0^0` | `(-D_(q+1) x_1,alpha+x_0) in L_0^0` |
| (0,1) | `(-D_q x_0,alpha+x_1) in J_0` | `(-D_(q+1) x_1,alpha+x_0) in W_0` |
| (1,0) | `(-D_(q+1) x_1,alpha+x_0) in L_0^0` | `(-D_(q+1) x_0,alpha+x_1) in L_1^0` |
| (1,1) | `(-D_(q+1) x_1,alpha+x_0) in L_0^1` | `(-D_(q+1) x_0,alpha+x_1) in L_1^0` |

Each child condition is an affine slice `a_b+K_b` in F_p^N, if nonempty.
The homogeneous directions satisfy `K_0 intersection K_1=0`: a joint
homogeneous solution would merge to parent `(u,v)=(0,0)`, hence to an
invisible parent polynomial. The existing no-invisible-vector lemma makes
that polynomial zero and therefore all its child moments zero.
Consequently the combined homogeneous equations have full column rank N,
and every feasible target preimage is unique.

If either slice is empty, reject. Otherwise the exact remaining obstruction is

    [a_1-a_0] in F_p^N / (K_0+K_1).                         (1)

Acceptance is equivalent to this class being zero. It is independent of the
chosen affine representatives. Its quotient dimension is
`N-dim K_0-dim K_1`, since the direction intersection is trivial. A functional
annihilating both directions but not `a_1-a_0` certifies rejection. This is a
coupled test on the same actual tuple, not free pairing of reachable states.
Smaller equations do not imply practical graph enumeration or uniform acceptance.

## 2. Every even-shift event strips exactly

For all q,k>=0, including r=1 and empty blocks,

    A(2q,2k) iff A(q,k),        A(2q,2k+1) is false.          (2)

The preimage at `(2q,2k)`, if present, is uniquely

    S(X) = (1+X) T(X^2) / 2,                                (3)

where T is the normalized preimage at `(q,k)`. This is a synchronized
shift/size lift, distinct from the already formalized reverse lift `T(X^N)`.

**Proof, with the r=1 boundary explicit.** Recall the existing consequence of
Lai–Sprang Proposition 2.3: a nonzero F-multiple of degree D cannot have D+2
zero rows. A target preimage at size n therefore has exact degree n-1; its
first nonzero row is n+1 and both coefficient endpoints are nonzero.
If n<N or n=0, no preimage exists. For any remaining event write S=FV and

    g=1+...+X^(H-1),          V=V_0(X^2)+X V_1(X^2),
    A=V_0+X V_1,             B=V_0+V_1,
    S=E(X^2)+X O(X^2),       E=gA, O=gB, so EB=OA.

Here A,B are polynomial names, not the acceptance predicate. At shift 2q the
two original parity systems, with `B_P(v)=sum_i P_i c_(v+i)`, are

    B_E(q+l) + H^(-1) sum_(z in Z) z^(q+l) O(z) = 0,
    B_O(q+l) + H^(-1) sum_(z in Z) z^(q+l-1) E(z) = 0.

For deg V=2j the lengths are H+j,H+j, and deg A,deg B<=j.
For deg V=2j+1 they are H+j,H+j+1, and deg A<=j+1,deg B<=j.
Convolve the first system with B and the second with A. In both cases at
least H rows remain. The stream terms cancel, leaving

    sum_(z in Z) z^(q+l-1) g(z)(A(z)^2-z B(z)^2)=0,
                                                    l=1,...,H.

Since `A^2-XB^2=(1-X)(V_0^2-X V_1^2)` and `g(z)(1-z)=2`, a full weighted
Vandermonde system gives `V_0(z)^2=z V_1(z)^2`. Nonsquareness of z forces
both values zero. Hence `X^H+1` divides V_0,V_1, and F divides E,O.
This is the old even-shift factor proof, now explicitly including H=1:
there is one nonzero Vandermonde entry and z=-1 is a nonsquare. No H-1
moment argument is being silently substituted at this boundary.

Thus x_0=x_1=0 in the table. For size 2k, both children belong to the same
square, with forcing zero and output alpha. Unique coefficient preimages
imply E=O=T/2. Conversely (3) supplies both child equations and the exact
parent target, proving the first equivalence. For size 2k+1, O has degree at
most k-1, is an F-multiple, and has k+1 zero rows. The D+2 bound forces
O=0, contradicting O(1)=1/2. This proves the second assertion. QED.

For M>0, put s=v_2(M). Repeatedly applying (2) gives

    A(M,n) iff 2^s divides n and A(M/2^s,n/2^s).             (4)

There are no events at M=0: halve the size until it is odd, or reach the
empty block. Every event has a canonical odd-shift representative. The
iterated polynomial lift is

    2^(-s)(1+X+...+X^(2^s-1)) T(X^(2^s)).

The earlier 5 October record proved only that a minimum-degree event has odd
shift. Equations (2)–(4) describe every event and its unique preimage. They
do not prove that an odd-shift event exists uniformly in p.

## 3. One original parity system plus the old norm congruence is insufficient

For odd shift M=2q+1, the old necessary quotient norm condition translates to

    (1-z) z^q (x_0(z)^2-z x_1(z)^2) = constant on Z.          (5)

Indeed `E=g(V_0+X V_1)`, `O=g(V_0+V_1)` imply
`(1-z)(E(z)^2-z O(z)^2)=4(V_0(z)^2-z V_1(z)^2)`. Thus (5) is precisely
the old scalar norm congruence, not a new necessary condition.

The stronger proposed sufficiency fails with actual original parity rows.
Over F_5, take M=313, n=12 and ascending coefficient lists

    V=[3,3,4,0,1,3,4,0,1],
    S=F V=[3,1,0,0,3,3,3,3,3,0,1,1],
    E=[3,0,3,3,3,1],   O=[1,0,3,3,0,1].

Both endpoints are nonzero. At roots [1,2,3,4], S has evaluations [1,0,0,0].
The primitive moments are `x_0=x_1=[4,2]` at z=2,3. Both values of (5)
equal 1 (the old V-norm scalar is C=4). But original, unnormalized rows
1,...,12 read back from the rational root definition are

    [0,4,0,3,0,3,0,4,0,1,0,1].

All six rows of the first parity subsystem vanish, and every row of the
other subsystem fails. At parent `(q,k)=(156,6)`, digit `(1,0)`, the first
affine child slice is the singleton `(4,2;4,2)`. The second is the singleton
`(1,4;1,0)`. Thus the actual tuple has a nonzero four-dimensional quotient
class (1), and **no** coupled solution; an independent original-matrix solver
also certifies rejection. This is not merely a poorly chosen O polynomial.

The known accepting neighbor M=311,n=12 has both singleton candidates
`(3,1;4,2)`. The p=13 accepting path similarly matches its candidates;
the nearby rejecting M=1463,n=80 has two feasible singleton candidates that
differ. This strengthens the 4 October linkage-only failure, which retained
neither complete original parity subsystem.

## 4. Verification and reproducibility

The generated `work` branch was clean at f02f5ff4dc249e2e51f937ddadfdb05a72c1455b.
Verified expected origin `https://github.com/solresol/function-field-littlewood.git`,
fetched main, checked HEAD ancestry/equality, preserved work, created tracking
main and completed a fast-forward-only check. Parent verified no overlapping
cloud task; no independent Littlewood process was present. Cloud-thread tools
are not exposed to this child. No other computer was accessed.

Read saved `/workspace/shared/theorem-provers/START.md`, cloud-bootstrap recovery
instructions, README, current TODO/log, weekly literature review, recent results
and the actual relation, transition, four-square, moment, oracle and affine
solver sources. No applicable AGENTS.md or repository .agents skills were
present. First sourced prepared env.sh and ran check.py successfully: exact pins,
dependency HEADs, tracked dependency cleanliness, readiness receipts and imports.
No install, cache download, runtime creation, pin, credential or schedule change.

An independent delegated mathematical review derived the branch table, checked
the H=1 proof and exact stripping corollary, and rechecked the failed implication
from original rational root sums. It edited no files. This is ordinary argument
and exact arithmetic, not an independent proof-kernel check.

Python 3.12.14, standard library, deterministic, no randomness or seed. Retained
commands, guarded timings and exit statuses are in
[the validation record](2026-10-26-validation.json):

    python3 -m search.terminal_target_preimage
    python3 -m unittest discover -s tests -p test_terminal_target_preimage.py -v
    python3 -m unittest discover -s tests -p 'test_*boundary*.py' -v
    python3 -m unittest discover -s tests -p test_four_square_state.py -v

Each retained command uses a 180-second limit, 2 GiB disk reserve and 12 GiB
process-group RSS bound. The new prescribed check took about 4.13 seconds
internally. It checks 800 child targets: p=3,5,13,41,17, q in
{0,1,2,3,7,8,15,31}, k=0,...,4, and all four digits. Each target is compared
with the independent affine solver on full original-root-sum rows, including
empty blocks, r=1, both shift/size parities and infeasible local slices.
The affine solver retains rejection duals, checked by direct dot products;
joint rejections with feasible children also retain the quotient annihilator.
The combined homogeneous rank is N in all prescribed cases, as proved above.

Known path controls include p=3, p=5 M=311/313,n=12, the existing Friday
M=249/505,n=36 continuation, and p=13 M=1465/1463,n=80. The existing p=41
M=618117,n=1916343 witness checks the accepting `(1,1)` branch without
building its huge matrix; this control is recurrence-based and does not repeat
the 19 October independent giant-certificate readback. It is not a new witness.
The tests additionally verify formula (3) against full original matrices and
its exact next nonzero row for the known p=3,5,13 normalized polynomials.
Stored-state guards forbid direct or recursive coefficient calculations while
computing the reduced preimage. All 18 focused tests pass.

For a direct target at shift M and size n>0, the inclusive last stream index
is M+2n-1; n=0 reads no stream coefficient. The explicit failed polynomial
reads only through 336. Original finite rows are exact coefficients of the
infinite rationally defined stream; no prefix is assumed to continue with zeros.
No Lean source changed and no Lean build or axiom audit is claimed. The
existing Challenge.lean:37 sorry and its downstream assumptions play no part.

## 5. Literature dependency, limits and next useful work

Targeted primary verification accessed **26 October 2026 Australia/Sydney**:
[Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
30 May 2026, still the only displayed version;
[functional equation and Proposition 2.3](https://arxiv.org/html/2606.00633v1).
Their odd-characteristic counterexample theorem is established background;
Proposition 2.3 supplies the ordinary no-invisible-vector/D+2 bound used here.
It supplies no accepting terminal event. Other source/version and access limits
remain those of the 24 October weekly review. No new binary candidate or claim
of a newly opened frontier was selected, so retired rational/quadratic and
unbounded-window streams were not searched again.

The concrete increment is exact canonical odd-shift reduction and a certified
failure of one-parity-plus-norm sufficiency. Uniform odd-shift existence and
characteristic two remain open project targets. The affine quotient could
still have full dimension N, as it does at the known singleton controls;
no practical enumeration or small invariant is implied.

Next mathematical question: how does the compatibility class (1) transform under
a shared prefix digit on the *actual adjacent-shift* squares? Seek a preserved
proper subspace or an explicit collision ruling out that reduction, using the
existing accepting/rejecting p=5,p=13 paths. Do not independently combine sibling
feasibility, replace compatibility by (5), repeat full graph closure, or expand
witness boxes. Formal work can first prove the generic affine-intersection
criterion and the target-specialized merge from the existing BoundaryRelation
and CorrelatedState declarations. Exact stripping additionally needs the
ordinary moment-factor/D+2 inputs formalized; do not insert Proposition 2.3 or
the desired acceptance theorem as an axiom.
