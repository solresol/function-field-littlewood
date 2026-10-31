# Sunday integration: the missing square carries a bordering scalar

1 November 2026, Sunday, Australia/Sydney (AEDT). Scheduled instant:
31 October 21:20 UTC = 1 November 08:20 AEDT.

Classification: **mathematical progress on auxiliary sharpness structure**:
a stronger, independently certified failure of a proposed compression, with
an ordinary quotient-space explanation. Neither uniform `Delta_p=2N` nor
the characteristic-two target is decided. There is no new Lean theorem,
sharpness witness, prime decision or priority claim.

## Question, literature and weekly outcome

Read the newer [30 October weekly human-literature review](2026-10-30-literature-review.md),
not only the previous 24 October handoff, before choosing work. Its targeted
primary-source checks found no new result deciding either target. Lai–Sprang
Theorem 1.2 proves the lower bound for every irreducible P over every field of
odd characteristic; it does not assert equality for the named stream. Hofer's
method retains a positive approximation bound as a hypothesis, and the
Badziahin–Pavlenkov–Zorin characteristic-two consequence retains a nonempty
exceptional-set hypothesis. These do not supply an accepting word here.

The substantive increments this week were the 26 October exact target
preimage/even-shift reduction, the 28 October fixed-affine obstruction and
the 30 October complete-profile obstruction. The 27, 29 and 31 October Lean
work verifies existing arguments, including binomial nonvanishing, exact
terminal detection and odd-shift reduction. Reuse those bridges. Test counts,
builds and finite agreement do not decide uniform acceptance. There was no
characteristic-two advance. The auxiliary N-bound remains refuted; further
degree-zero/three-term attainment examples cannot restore it.

Before coding, the question was: **does varying the fixed child-output moments
recover the response lost by the empty target slices in the fixed
T(62,8)/T(126,8) collision, and does that response close under the next digit?**
Closure would motivate a smaller response state; failure should identify the
missing forcing or output data. Inspection gives a sharper answer: all
one-step target channels are blind to the last square, even when arbitrary
forcing and output values are allowed. The omitted square is not determined
by the other seven full relations. Thus empty-slice information loss is a valid
description of the old observable, but is **not the whole obstruction**.

## 1. The one-step channels never read the last square

Use the existing normalized stream c=a/H, N=2^v2(p-1), H=N/2,
Omega the N-th roots in F_p, and boundary relation

    R_t(m,n) = {(u,v): A_t(m,n)x=U_m u, U_n^T x=v for some x},
    (A_t)_ij=c_(t+i+j),       (U_m)_iz=z^i.

For T(q,k), write its four square relations as

    B00 = R_(q+1)(k,k),       B01 = R_(q+1)(k+1,k+1),
    B10 = R_(q+2)(k,k),       B11 = R_(q+2)(k+1,k+1).

The eight-relation order is

    (B00, B00+B01, B00 intersect B01, B01,
     B10, B10+B11, B10 intersect B11, B11).

The 25 October reconstruction justifies the sums/intersections, including
singular and empty blocks. The exact parity merge gives the following children
for the **entire first square** of T(2q+e,2k+h), ordered by parent row parity:

| Digit (e,h) | First child | Second child |
|---|---|---|
| (0,0) | B00 | B00 |
| (0,1) | B00 intersect B01 | B00+B01 |
| (1,0) | B00 | B10 |
| (1,1) | B01 | B10 |

Proof: for t=2q+e+1, parent size 2k+h, the child at row parity a has
column parity b=(t+a) mod 2, start (t+a+b)/2, rows k+(h+1-a)//2,
and columns k+(h+1-b)//2. Substitution gives exactly the table. The forcing
maps depend only on q modulo N and the digit. No target value was fixed in
this derivation. Therefore all four next first-square relations, and every
membership query in them, depend only on phase and B00,B01,B10. B11 is never
read. Varying targets or forcing in these same channels cannot recover it.

This is an ordinary consequence of the existing exact merge, not a new
formalized theorem. It does not say all future channels ignore B11.

## 2. Seven actual relations agree, but the omitted square matters

At p=5, N=4, roots (1,2,3,4), take the already recorded states

    T(62,8), T(126,8).

They have the same phase, exact size, capped size and current rejection.
B00,B01,B10 agree exactly. More strongly, B10+B11 and B10 intersect B11
also agree. Thus the first **seven full relations** agree. Only B11 differs.
The fixed original-coefficient certificate establishes all four initial
squares directly; the equal rectangular relations follow by the proved
bordered reconstruction. This is stronger information than the empty affine
target profiles checked on 30 October.

Let A be the common B10; let B and C be the two B11 values. Their common
intersection L and sum W with A have dimensions 3 and 5. In (u|v) coordinates,

    L = span((1,0,0,3 | 1,2,3,0),
             (0,1,0,0 | 3,3,4,3),
             (0,0,1,1 | 1,2,1,4)).

Choose representatives outside L:

    a = (1,0,0,0 | 4,3,2,4) in A,
    b = (1,0,0,0 | 1,3,1,0) in B,
    c = (1,0,0,3 | 0,2,1,2) in C.

The exact identity is c=L_0+3a+2b, so

    A=L+span(a),  B=L+span(b),  C=L+span(b+4a).

The two missing lines have parameters 0 and 4 in this chart on W/L.
Their distinction is independent of the chosen chart; the numeric labels
are not intrinsic invariants.

Apply shared digit (1,1). The successors are T(125,17), T(253,17).
Their B01 values differ, so **the first-three-square profile and the
first-seven-relation profile admit no deterministic update**, even a nonlinear
one with exact size and current acceptance retained. In particular the omitted
square is not a function of the other seven actual relations.

There is a stronger all-target observation. Initially every next first-square
relation agrees, by the table. After the shared digit (1,1), the next digit
(1,1) gives different full first squares at T(251,35), T(507,35), independently
certified from original coefficients. Thus even the observable consisting of
the current first square and **all four complete next first-square responses**
is not closed. These two final targets both reject; this does **not** prove
terminal-language inequivalence. It also does not prove that every choice of
three squares fails, that four squares are globally minimal, or that no other
recognizer exists.

## 3. Why the missing datum is a scalar

This ordinary linear-algebra lemma identifies a useful next object. For any
two distinct adjacent Lagrangian squares A,B, the existing reconstruction
gives L=A intersect B of dimension N-1 and W=A+B of dimension N+1.
For the nondegenerate alternating form

    omega((u,v),(u',v'))=u.v'-v.u',

W=L-perp: both A and B annihilate L, and dimensions agree. Therefore W/L
is a nondegenerate two-dimensional symplectic space. Its lines are exactly
the Lagrangian N-spaces between L and W. After choosing a in A outside L
and b in B outside L, all completions distinct from A are

    B_lambda = L+span(b+lambda*a),       lambda in F_p.

These are p distinct abstract completions with the same intersection L and
sum W with A. Indeed b+lambda*a is outside L, self-pairs to zero, annihilates
L, and the quotient has exactly p+1 lines, one of which is A/L. This is a
parameterization, not a claim that all p completions occur in our stream.
The fixed example realizes two of them with identical other seven relations.

Consequently adding the omitted corner's tall and wide response to a
three-square state is insufficient. One must retain or recover its projective
line as well. The formula does not itself provide a useful scalar transport,
an invariant forcing acceptance, or a smaller closed state.

## 4. Exact checks and the inconclusive response experiment

[corner_response_obstruction.py](../search/corner_response_obstruction.py) and
the [fixed certificate](2026-11-01-corner-response-check.json) certify twelve
full squares: all four at each initial state, B01 at both first successors,
and B00 at both second successors. For every square the certificate gives
four independent projected vectors, their original polynomial preimages,
and the inverse of an n-column minor of [-U|A]. The invertible minor gives
row rank n, so the solution space has dimension N. The four independent
projected vectors therefore span exactly the full relation. Readback checks
both inverse products, all forcing/evaluation equations, echelon independence,
isotropy, the common L/W and the scalar identity. No elimination, state
recurrence, Proposition 2.3 or project theorem assumption is used in readback.
The largest original stream index is **576 inclusive**. Every coefficient
comes from the infinite rational root-sum definition, not zero padding.

Five new tests check solver/recurrence-disabled readback, reduced-state
agreement, exact regeneration, the four-branch table (120 prescribed comparisons,
including empty blocks and r=1), and ten corruption controls (rank, preimage,
relation, borders, quotient coordinates, parameter, completeness and roots).
This is independently checked finite algebra, not a Lean proof. The existing
Challenge.lean:37 sorry and downstream assumed claims are unused.

The preliminary primitive-forcing experiment allowed arbitrary output while
setting u_z=0 at nonprimitive roots, retaining that restricted relation for
all eight components. It distinguished the fixed pair through B11. On only
the 52 F_5 and 37 F_13 inputs already prescribed on 30 October, it had no
collision at equal phase/exact size/current acceptance. That is **inconclusive**
about closure and offers no reason for a larger box. The parity maps D_a u
square roots into the imprimitive set, so a primitive-support restriction
does not automatically close. The full-response table above instead settles
why varying the existing one-step channels cannot repair the fixed collision.

The exploratory command was a standard-library `python3 -` script (1.152s),
with precisely this comparison, no random seed:

```python
from collections import defaultdict
from search.four_square_state import FourSquareStates, reconstruct
from search.terminal_boundary_relation import basis, null
D = ((0,0),(0,1),(1,0),(1,1))
for p, paths in ((5, ((311,12),(313,12),(249,36),(505,36))),
                 (13, ((1465,80),(1463,80)))):
    m = FourSquareStates(p); N = m.N; base = set()
    def restricted(R):
        K = null([[r[j] for r in R] for j in range(N)
                  if j not in m.engine.primitive], len(R), p)
        return basis([[sum(w*r[j] for w,r in zip(v,R)) % p
                       for j in range(2*N)] for v in K], p)
    for q,k in paths:
        while q or k:
            if k >= N: base.add((q,k))
            q,k = q//2,k//2
    inputs = base | {(2*q+e,2*k+h) for q,k in base for e,h in D}
    groups = defaultdict(list)
    for q,k in sorted(inputs):
        s = m.evaluate(q,k)
        profile = tuple(restricted(R) for R in reconstruct(s,p).relations)
        groups[q % N,k,m.accepts(s),profile].append((q,k))
    print(p,len(inputs),[g for g in groups.values() if len(g)>1])
```

The retained command list, logs, exit codes, runtimes, guards and hashes are
in [the validation record](2026-11-01-sunday-validation.json). It reruns the
new certificate/tests, the week's profile/affine counterexamples, the exact
800-input target check, relevant boundary/target/four-square regressions,
default Lean build, and the target-preimage, terminal-detection and even-shift
audits. The r=1, empty, singular, F_13 and existing p=41 controls are retained;
no new search range is added. Python 3.12.14, exact F_5 arithmetic for the new
proof, standard library, no randomness. No new Lean declaration or independent
kernel replay is claimed. The existing audits check their unchanged declarations.
All **31 focused tests** pass. The fifteen retained guarded commands total
51.809s, including 15.061s preflight, 8.060s target comparison and 3.052s default
build. The three audits print 12, 14 and 17 axiom closures respectively, all
standard-only; these are output counts, not a count of distinct new theorems.
The unchanged default build still warns about Challenge.lean:37's placeholder.

## 5. Source record, environment and decision

Targeted primary rereading accessed **1 November 2026 Australia/Sydney**:
[Lai–Sprang 2606.00633v1](https://arxiv.org/html/2606.00633v1), dated 30 May 2026,
actual Theorem 1.2, equation (1.2), and the Proposition 2.3 context. Its lower
bound and exact valuation hypotheses match the reused foundation; equality
remains our auxiliary target. Also rechecked
[Adiceam–Nesharim–Lunnon 1806.04478v2, §7.2](https://arxiv.org/html/1806.04478v2#S7.SS2),
dated 11 October 2020: quadratic irrational series satisfy t-LC, including
the binary paperfolding series. Rational inputs have the denominator
obstruction. Known unbounded-window binary examples stay retired. No binary
candidate was selected. Other versions, scoped frontier search and unavailable
publisher text retain the 30 October weekly review's explicit access limits.
No broad daily literature search or new absence/priority claim was made.

The managed environment's source-version binding matched the parent's verified
configuration. Startup was initially pending; after readiness, the first shell
command sourced the prepared env.sh and ran check.py without installation or
download. Read saved START.md (no .agents Start or applicable AGENTS.md was
present), bootstrap recovery, current sources and Apache-2.0 attribution.
The clean generated work branch at cfea57d was preserved, expected solresol
origin verified, main fetched, ancestry/equality checked, tracking main created
and fast-forward-only merge completed. The prepared preflight passed again
after refresh. Exact pins and the valid shared runtime were reused. No runtime,
dependency, credential/security, schedule, environment publication, other
repository or user-machine change occurred. No external implementation or
source prose was copied. Raksasa synchronization remains the parent's job;
no direct remote shell was used and its local schedule remains paused.

**Next informative experiment:** on this fixed pair, derive the transport of
the missing line B11/L through the odd digit (1,1), using the existing merge
and bordered row/column equations. Test whether, with the common seven
relations held fixed, the induced next response is a nonconstant projective
map or needs a new transverse datum. Preserve singular charts. A derived
rank-two map would motivate a projective compatibility recurrence; a rank drop
or dependence on another datum would identify the next obstruction. Neither
outcome follows from two fitted parameter values. Do not enumerate the full
graph, expand attainment boxes or replace this derivation with generic tooling.
Abstract line completions are not independently reachable stream states; a
transport calculation must preserve that distinction and actual path correlations.

**Next formal lemma:** from the existing `CorrelatedState` merge, express the
first-square transition by the four-row table and prove independence from B11,
including k=0 and r=1. Then formalize the L-perp/two-dimensional quotient lemma
only if the transport argument needs it. These would verify the ordinary
structure; they cannot substitute for substantive transport or acceptance.

Weekly assessment: auxiliary mathematical structure improved and several
compressions are now explicitly retired. Verification removed assumptions
from useful bridges; maintenance did not change either mathematical outcome.
Uniform sharpness and characteristic two remain unresolved.
