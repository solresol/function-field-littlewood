# Sunday integration: four square relations recover the full state

25 October 2026, Sunday, Australia/Sydney (AEDT; 24 October UTC).
Classification: **mathematical progress: an ordinary structural lemma**, with
exact finite checks. Not a Lean theorem, uniform sharpness result, new prime
decision, characteristic-two construction or established novelty claim.

## Question stated before implementation

Do the four squares at shifts q+1,q+2 and sizes k,k+1 determine the four
rectangular components of the correlated state, including singular blocks?
Both same-shift squares embed in the wide rectangle. The unresolved step was
whether these squares could coincide, leaving their sum too small. A proof
would reduce storage from eight relations to four; a counterexample would
retire this reconstruction. Neither finite agreement nor smaller storage would
establish uniform terminal existence.

**Outcome.** The squares are distinct, their sum is the wide rectangle, and
their intersection is the tall rectangle. The proof uses no matrix inverse.
It reuses the 19 October no-invisible-vector and dimension lemmas, whose
ordinary mathematical input is Lai–Sprang Proposition 2.3. This is a new
internal deduction, not an independently established publication-priority claim.

## 1. Bordered reconstruction, including singular blocks

Use the normalized Lai–Sprang stream and notation of
[19 October](2026-10-19-boundary-relation.md). For each admissible odd prime p,
N=2^v_2(p-1), t>=1 and k>=0, put

    L0 = R_t(k,k),                L1 = R_t(k+1,k+1),
    W = R_t(k,k+1),               J = R_t(k+1,k).

All are subspaces of F_p^(2N), with coordinates (u,v). Then

    L0 != L1,       W = L0 + L1,       J = L0 intersection L1.    (1)

In particular dim(L0 intersection L1)=N-1. The assertions include k=0,
the r=1 comparison, and either or both square Hankel blocks being singular.

**Proof of distinctness.** Write the bordered Hankel and root matrices as

    A_t(k+1,k+1) = [ A  b ],       U_(k+1) = [ U   ],
                    [ b^T a ]                   [ w^T ]

where A is symmetric, U=U_k, and w_z=z^k. Padding a square solution by a zero
last coefficient embeds L0 in W. Deleting the final equation embeds L1 in W.
The 19 October no-invisible-vector lemma says that a pair (u,v) in W has
a unique coefficient preimage (x,y).

Suppose L0=L1. For every solution A x=U u, its pair (u,U^T x) belongs to L1.
Its unique W-preimage is already (x,0), so the final bordered equation gives

    b^T x = w^T u     whenever A x = U u.                        (2)

The functional [b^T,-w^T] therefore annihilates the kernel of [A,-U].
The elementary row-space/kernel-annihilator identity supplies lambda with

    lambda^T A=b^T,       lambda^T U=w^T.

By symmetry, A lambda=b and U^T lambda=w. Consequently (-lambda,1) is a
nonzero vector in the kernel of the stacked matrix

    [ A   b   ],
    [ U^T w   ]

contradicting the same no-invisible-vector lemma for the k-by-(k+1) block.
This also covers k=0: the displayed systems have their empty-matrix meanings.
Hence L0 and L1 are distinct.

Both squares have dimension N and W has dimension N+1 by the existing
dimension lemma. Their sum lies in W; distinctness forces that sum to have
dimension at least N+1. Thus W=L0+L1.

To recover J, use the nondegenerate symplectic form

    omega((u,v),(u',v')) = u^T v' - v^T u'.

For a rectangle and its transpose, preimages x,y give
u^T U_m^T y-x^T U_n u'=y^T A x-x^T A^T y=0. Their dimensions add to 2N,
so J=W^(omega-perp). Both squares are Lagrangian, as proved on 19 October.
Therefore J=(L0+L1)^(omega-perp)=L0 intersection L1. QED.

Only the no-invisible-vector/dimension input uses the special stream theorem;
the bordered and symplectic arguments are finite-dimensional linear algebra.
This does not assume a terminal certificate, endpoint nonvanishing, or the
target sharpness result. It does not assert (1) for an arbitrary Hankel stream.
For example, the zero stream with k=N has identical adjacent square relations:
X^N-1 is invisible. The retained negative control demonstrates this failure.

## 2. Exact four-square state and what it changes

Retain phase q mod N, size min(k,N), and

    R_(q+1)(k,k),       R_(q+1)(k+1,k+1),
    R_(q+2)(k,k),       R_(q+2)(k+1,k+1).                       (3)

Apply (1) at each shift to recover all eight components of T(q,k). Apply the
existing paired-digit transition and retain its four squares again. This
proves exact closed transitions on the reachable four-square states, in both
directions of the binary encoding. The previous terminal output and fixed-prime
decidability follow unchanged, with the same explicit Proposition 2.3 dependency.
No independently reachable siblings are combined.

`search/four_square_state.py` implements this reconstruction and reuses the
existing `CorrelatedStates.step` rather than introducing another parity merge.
It stores four relations but still computes the old full transition internally;
no runtime improvement or practical whole-graph enumeration is claimed.

Friday's obstruction remains valid for one square or two adjacent-shift squares.
The additional size-(k+1) squares distinguish T(31,4) and T(63,4) over F_5:
both larger squares differ. Their common continuation still rejects/accepts
respectively. Thus the old failed compressions stay retired, while the proposed
four-square reconstruction is now proved ordinarily. This does not establish
minimality of four, a useful reachable-state bound, or uniform accepting words.

## 3. Sunday assessment of the week

- **Mathematics:** 19 October supplied the bounded root relation; 21 October
  closed correlated reachability; 23 October refuted smaller compressions;
  today recovers every rectangle from four squares. These change the structural
  route to the auxiliary question Delta_p=2N. They decide no additional prime.
- **Verification/infrastructure:** 20 and 22 October formalised the recurrence
  and reachability; 24 October formalised the uniform terminal lift already
  proved ordinarily on 5 October. That lift still requires an exact admissible
  terminal certificate. More instance exports would not fill the existence gap.
- **Main characteristic-two frontier:** no advance this week. The
  [24 October weekly literature baseline](2026-10-24-literature-review.md)
  was read before selection. Its newly located published Thue–Morse wall paper
  reinforces retirement of that candidate; Hofer is a method lead, not a binary
  construction. The rational/quadratic and known unbounded-window screens remain
  mandatory before selecting any new characteristic-two stream.

Neither target is settled. The universal auxiliary N-bound, primitive-root-only
moments, square-only/two-shift-square compression and the r=2 extension of the
three-term family remain retired. Degree-zero attainment and r>=3 three-term
attainment of N do not prove an upper bound. Thue–Morse, regular paperfolding
and overlapping-11 Rudin–Shapiro remain retired. No automaticity-to-independent-
random-trials inference, characteristic-two existence claim, or firstness claim
is supported. README's statement that the weekly review was unavailable has
been made explicitly historical; that review is now present and was used.
Its active near-term programme also still requested the refuted terminal
exclusion and already completed descent formalisation. It now follows the
current sharpness/acceptance question and the actual remaining formal gaps.

## 4. Exact checks and reproducibility

Initial HEAD 3e4a41af1fc2648345074ad6088245172933b388 was clean, on the generated
`work` branch. Verified the expected solresol/function-field-littlewood origin,
fetched main, checked ancestry/equality, preserved `work`, created tracking
`main`, and completed the fast-forward-only check. No overlapping research
process was found. No applicable repository/workspace AGENTS.md or .agents skill
was present. Read saved `/workspace/shared/theorem-provers/START.md`, bootstrap
recovery instructions, README, TODO, recent log/results and actual relevant
relation, transition, oracle, affine-solver and lift sources.

First sourced the selected environment's `env.sh` and ran its `check.py`:
exact pins, dependency HEADs, clean tracked dependency sources, readiness
receipts and representative imports passed. No installation, runtime creation,
cache download, dependency or credential change occurred. Only this repository
was edited; no external host or schedule was accessed.

Python 3.12.14, standard library, exact finite-field arithmetic, deterministic,
no randomness or seed. Guarded retained commands and timings are in
[the validation record](2026-10-25-validation.json). Each command used a
180-second bound, 2 GiB disk reserve and 12 GiB process-group RSS limit.

    python3 -m search.four_square_state
    python3 -m search.square_state_obstruction
    python3 -m search.terminal_lift_check
    python3 -m unittest discover -s tests -p 'test_*boundary*.py' -v
    python3 -m unittest discover -s tests -p test_four_square_state.py -v
    python3 -m unittest discover -s tests -p test_lai_sprang_sharpness.py -v

The [new identity check](2026-10-25-four-square-check.json) covers p=3,5,13,41,17
(N=2,4,4,8,16), q in {0,1,2,3,7,8,15,31}, k=0,...,4, and all four child
digits at each parent. It compares all eight reconstructed components against
full matrices built from original rational root sums: 8,000 component comparisons.
The parent checks include 233 singular square blocks and 56 pairs in which
both squares are singular, counted with multiplicity across prescribed inputs.
These are exhaustive checks of the specified finite list, not a state search.

The two relation paths share the existing nullspace routine. A separate affine
solver independently reconstructs and checks by dot products all 88 rectangle
basis preimages at (p,q,k)=(3,1,2),(5,311,12),(13,1465,80),(41,255,11),(5,0,0).
It includes both shifts and both rectangular orientations, with unique preimages.
The direct full tuple reads only through the inclusive endpoint q+2k+2;
a nonempty individual block reads through t+m+n-2, and an empty block reads
no stream coefficient. No truncation cutoff or inferred infinite certificate
enters the check.

The stored-state guard forbids any direct or recursive coefficient calculation
after initialization. Leading zeros, Friday's conflicting continuation and a
zero-stream invisible-vector negative control pass. Existing small checks rerun
Friday's independent target decisions and the 2,885 prescribed lift identities,
including the r=1 comparison and omitted-factor/over-scale controls.
The new identity check took 16.145s (17.009s guarded command); the two existing
checks took 0.181s and 0.013s internally. All 26 focused tests passed: 12 boundary,
3 new reconstruction and 11 sharpness tests. Detailed timings are retained.
No Lean source changed, so no new Lean build, headline axiom audit or independent
kernel replay is claimed. Challenge.lean:37's existing sorry and its downstream
assumptions are not evidence for this ordinary theorem or its computations.

## 5. Primary verification and next decision

Targeted primary reading, accessed **25 October 2026 Australia/Sydney**:
[Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
30 May 2026, [Proposition 2.3](https://arxiv.org/html/2606.00633v1#S2), excludes
the invisible polynomial at a nonnegative shift. This is the literature input
to the existing dimension/injectivity lemma used above; it supplies no accepting
terminal event. Theorem 1.2 already settles odd-characteristic existence.
[Hofer, arXiv:2610.12691v1](https://arxiv.org/abs/2610.12691v1), 8 October 2026,
Theorem 1 and the Hankel-block discussion were checked as a method lead.
The new bordered argument does not invoke her decomposition theorem. No broad
daily literature search or new claim of absence/novelty was made; retain the
weekly baseline and its access limitations for the other sources.

**Next informative experiment:** derive the one-digit preimage of terminal
target (0,e_1) in the four-square recurrence. The output-moment equation fixes
v_0(1)=v_1(1)=1/2 and v_0(w)=v_1(w)=0 at the other squares w in Omega; moments
at nonsquares in Omega remain variables. Express the remaining child-membership
conditions using the adjacent squares and their intersection. Check that reduced
criterion on the existing p=5,p=13 and r=1 accepting paths and neighboring
rejecting words. A stable invariant could guide uniform accepting words; failure
would identify which free moment obstructs that approach. Do not expand witness
boxes, enumerate a whole reachable graph or count a timeout as nonexistence.

**Next formal lemma, when needed by that acceptance argument:** bordered
square reconstruction (1) from explicit stacked-matrix injectivity and the
proved relation dimensions, followed by the transpose symplectic identity.
Keep these hypotheses visible; Proposition 2.3 and terminal exactness are still
ordinary inputs, not new Lean theorems or permissible project axioms.
Stop this run after this coherent structural increment and its checks.
