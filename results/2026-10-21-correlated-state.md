# Correlated binary state closure for terminal sharpness

21 October 2026, Wednesday, Australia/Sydney (AEDT).
Classification: **mathematical progress: an ordinary structural lemma**.
Not a Lean theorem, new prime decision, characteristic-two advance, or
established publication novelty. The auxiliary universal N-bound is already
refuted; this addresses the successor question of universal 2N sharpness.

## Question and outcome

Before implementation: can a fixed tuple of adjacent-shift, nearly square
boundary relations close under simultaneous binary transitions, preserving
the correlations needed for actual stream inputs? Closure would replace
independent child-state pairing with an exact reachability problem; failure
would expose missing coordinates. The positive control was the existing
p=5 terminal event (M,e)=(311,8), not a new witness search.

**Theorem.** For each odd prime p, with N=2^v_2(p-1), the set of terminal
pairs (M,e) is binary-recognizable when encoded as (M,N+e). Eight boundary
relations, a shift residue and a saturated size counter suffice. Their four
transitions are effective finite-field operations. Hence existence of a
terminal event is decidable for each fixed p by finite graph reachability.

This is a proof of an exact finite-state presentation, not an enumerated
reachable graph, a useful complexity bound, or an existence proof. It closes
the correlation gap left explicitly open on 19 October. It does not assert
automaticity of the numerical number-wall determinants.

## 1. State and the merge being reused

Use the normalized stream c=a/(N/2) and the relations from
[19 October](2026-10-19-boundary-relation.md):

    R_t(m,n) = {(u,v): A_t(m,n)x=U_m u, U_n^T x=v for some x},
    A_t(m,n)_(i,j)=c_(t+i+j), U_l(i,z)=z^i, z in Omega={z:z^N=1}.

All relation coordinates lie in F_p^(2N); t>=1 and |m-n|<=1.
Set, for q,k>=0,

    T(q,k) = (q mod N, min(k,N),
              [R_(q+1+d)(k+i,k+j)]_(d,i,j in {0,1})).       (1)

The component order is lexicographic (d,i,j). Empty blocks are included.
In particular T(0,0) uses only the four shapes (0,0),(0,1),(1,0),(1,1)
at t=1,2. This is a computable initial state, with no missing negative index.

The previous merge splits rows by a in {0,1}. Column parity b=(t+a) mod 2
is the even-stream block; its child is

    R_((t+a+b)/2)( floor((m+1-a)/2), floor((n+1-b)/2) ).

Writing v_0,v_1 for the two child moments, membership is tested on
(D_a u-K_l v_(1-b), v_b), where

    (D_a u)_w = sum_(z^2=w) z^a u_z,
    l=(t+a+(1-b)-1)/2,
    (K_l)_(z,z)=(N/2)^(-1) z^l if z^(N/2)=-1, else 0.

The output moments are v_z=(v_0)_(z^2)+z(v_1)_(z^2). The merge is the
image of a linear solution space in 3N variables. It is exact in both
directions, even for empty/unequal blocks; it never assumes invertibility of A.
This algebraic identity was formalised on 20 October (with raw stream a).
The new tuple closure below is an ordinary argument, not yet Lean-checked.

## 2. Closed simultaneous transitions

Fix digits epsilon,eta in {0,1}. We compute T(2q+epsilon,2k+eta) from (1).
For its component (d,i,j), put

    t=2q+epsilon+1+d, m=2k+eta+i, n=2k+eta+j.

For each row parity a, define

    b = (epsilon+1+d+a) mod 2,
    d' = floor((epsilon+d+a)/2),
    i' = floor((eta+i+1-a)/2),
    j' = floor((eta+j+1-b)/2).                             (2)

Every numerator in the last three expressions is between 0 and 3, so
d',i',j' are all in {0,1}. Direct substitution in the merge gives child

    R_(q+1+d')(k+i',k+j'),                                (3)

which is a component of the *same* input tuple T(q,k). The odd-block
exponent is

    l=q+floor((epsilon+1+d+a)/2).                          (4)

Since all roots satisfy z^N=1, (4) requires only q mod N. Thus the entire
output relation is determined by the stored tuple and the two digits, with
no hidden dependence on q or k. The other coordinates update as

    phase'=(2 phase+epsilon) mod N,
    size'=min(2 size+eta,N).                              (5)

For (5), saturation is exact: if k<N the stored size is k; if k>=N then
both min(2k+eta,N) and min(2N+eta,N) equal N.

Equations (2)--(5), together with the exact merge, prove the transition
identity for every q,k>=0. In particular transition (0,0) fixes T(0,0).
There is no assumption that different sibling states can be independently
realised: both children are selected from one jointly realised tuple.

## 3. Finite-state recognition and decidability

Read equal-length, zero-padded binary representations of (q,k), most
significant digits first. Induction on word length using the transition
identity proves that the state reached is exactly T(q,k). Leading (0,0)
pairs have no effect. Conversely every finite word labels an actual
nonnegative pair (q,k), so every reachable tuple has a simultaneous stream
realisation. This proves both completeness and the absence of false states
caused by mixing unrelated children.

There are finitely many subspaces of F_p^(2N), with canonical reduced row
bases providing effective equality. For example every subspace is the row
span of some 2N-by-2N matrix, so their number is at most p^(4N^2).
A deliberately crude bound on possible tuple states is therefore

    B = N(N+1) p^(32N^2).                                (6)

The actual reachable set is closed under all four transitions. Breadth-first
exploration from T(0,0), deduplicating whole states, terminates after at most
B states. A transition on an arbitrary unrealizable tuple need not satisfy
the injectivity assertion in the implementation; this is irrelevant to
exploration from the initial state. Alternatively extend the abstract
automaton to such tuples by any total rule. No enumeration is run here.

Accept precisely when size=N and component (0,0,0) contains (0,e_1),
where e_1 is 1 at root 1 and zero at all other roots. By the terminal lemma
of 19 October, this is exactly a terminal window with M=q and e=k-N.
Its proof uses Lai--Sprang Proposition 2.3: there are no invisible vectors;
an F-multiple with k zero rows has exact degree k-1, nonzero constant term,
and nonzero row k+1. Thus the test retains exact degree and both endpoints.
The existing reverse-lift/dichotomy argument connects event existence to
Delta_p=2N. These terminal interpretations retain their explicit ordinary
literature dependency; no unproved axiom is being added to Lean.

This establishes an algorithm deciding the fixed-prime event, including a
negative answer if a complete reachable graph has no accepting state.
It does **not** make a bounded partial traversal a negative certificate,
give a uniform accepting path for all p, or make the bound (6) practical.
The new conclusion is supported by the proof, not by agreement on finite inputs.

## 4. Exact checks, sources and limitations

The checkout was clean on main at 5fef89b with the expected solresol origin;
fetch and fast-forward-only merge were already current. No competing research
lock was present. Read memory, roadmap, recent log/results, actual support,
root-sum oracle, relation/solver tests and the Lean merge before implementing.

Code reuses the existing merge by extracting it unchanged into
BoundaryRelations.merge; the old recursive entry point calls the same method.
The new state transition only selects stored components and invokes that
merge. It creates no growing Hankel matrix. The validation path independently
constructs full matrices from the original rational root-sum oracle. Both
matrix paths share the existing nullspace routine; the p=5 target is also
reconstructed with the separate affine solver and checked by dot products.

Commands:

    python3 -m search.correlated_boundary_state > results/2026-10-21-correlated-state-check.json
    python3 -m unittest discover -s tests -p 'test_*boundary*.py' -v

Python 3.14.4, standard library, exact finite-field arithmetic, no randomness
or seed. Transition validation took 3.539 seconds. The 12 selected new/existing
tests passed in 1.124 seconds. No Lean files or dependencies changed; no Lean
build or independent-kernel replay is claimed.

Prescribed checks, recorded in [the JSON](2026-10-21-correlated-state-check.json):

- p=3,5,13,41 (N=2,4,4,8); q in {0,1,2,3,7,8,15}, k=0,...,4;
  all four binary transitions from each input. Compare all eight relations
  at the parent and its children, including dimensions N+j-i and invisible
  nullity zero. This is a transition identity check, not a witness search.
- Existing controls: (p,q,k)=(3,1,2),(5,311,12),(13,1465,80) accept;
  (5,313,12) rejects. Every component also matches direct root sums.
  Three leading zero pairs leave the complete state unchanged.
- A guard forbids direct or recursive matrix calculation after initialization
  on the p=5 path. Its target reconstructs the known polynomial
  [2,3,4,0,1,3,3,3,1,3,2,1] with the independent affine solver.
  Removing the shift phase changes the next relation on this path.
  The size guard rejects k<N; invalid digits and negative inputs are rejected.

A nonempty m-by-n direct block reads exactly through index t+m+n-2;
empty blocks have no coefficient endpoint. All tuple sizes stay nearly square.
No truncation, unresolved cutoff or unrepresented abstract cover is used.
No existing p=41 large witness was rerun and no new prime was searched.

## 5. Literature and next research decision

Primary sources accessed **21 October 2026 (Australia/Sydney)**:

- [Lai--Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  30 May 2026; still v1. The functional equation underlies the merge, and
  [Proposition 2.3](https://arxiv.org/html/2606.00633v1#S2) is an explicit input
  to terminal detection. Their main odd-characteristic theorem is settled.
- [Badziahin--Pavlenkov--Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  22 August 2026; its characteristic-two consequence remains conditional.
- [Adiceam--Nesharim--Lunnon, arXiv:1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2),
  11 October 2020: quadratic-series exclusion. Rational series are excluded
  by a denominator multiplier.
- [Garrett--Robertson, arXiv:2405.14454v2, Sections 3 and 5](https://arxiv.org/html/2405.14454v2#S5),
  8 April 2025: automatic-wall framework and known unbounded-window context.
  The present proof supplies a special stream's terminal-event automaton;
  it is not a proof of their general numerical-wall automaticity conjecture.

Scoped primary searches for characteristic two/2 and Lai--Sprang sharpness
found no later relevant resolution. This is not proof of absence or a novelty
survey establishing priority. No binary candidate was selected; retired
Thue--Morse, paperfolding and Rudin--Shapiro searches remain retired.

**Next substantive step:** seek a structural reduction of the reachable
eight-relation tuples, or a family of digit words reaching the target uniformly
in p. First determine whether the square relation, phase and saturated size
can determine the next terminal outputs, using collisions of already reached
full states as an informative compression test. Conflicting outputs would
rule out that smaller state. Do not launch a whole reachable-graph enumeration
or more wall searches merely because a finite bound now exists.

**Next formal lemma:** the arithmetic index closure (2)--(5) and induction
on paired binary words, reusing BoundaryRelation's merge. This would formalise
the new finite-state presentation; the terminal soundness dependency on
Proposition 2.3 must remain explicit until separately proved.
