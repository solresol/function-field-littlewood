# Sunday integration: complete fraction-free block compatibility

15 November 2026, Australia/Sydney; invocation 14 November 21:20 UTC.
Executed in the selected saved theorem-provers environment on 14 November UTC.

**Classification: verification/infrastructure. Neither mathematical target
advanced.** The result below lifts the existing boundary recurrence to integral
exterior coordinates, with a complete target test at every repetition length.
It removes chart division and large Smith computations from the stated blocker.
It supplies neither an accepting length nor an all-length rejection invariant.
The exterior-algebra mechanism is standard; no novelty claim is made.

## Question, evidence and decision

Before coding, asked for a fraction-free propagation law for `(1,1)^m` on the
two actual `N=4` inputs `T(62,8)` and `T(126,8)`, retaining full simultaneous
compatibility at specialization primes. A scalar necessary obstruction would
not answer this question. The useful outcomes were a complete law and then a
structural invariant, or an identified failure requiring another approach.

Read current main, actual sources and the **13 November** checkpoint appended
to [the weekly literature record](2026-11-06-literature-review.md#13-november-2026-checkpoint).
The 9 November obstruction rules out the old five-digit selector uniformly;
the 10 November Lean work verifies the two-state input reduction. Neither
changes uniform `Delta_p=2N` or the finite-field characteristic-two frontier.

The task handoff reports two subsequent inconclusive attempts: `(0,1)`
coordinate checks followed by a 60-second symbolic-elimination timeout on
13 November Sydney, and full `(1,1)^m` terminal checks at `m=0,1,2` followed
by a 60-second Smith timeout on 14 November Sydney. These are handoff history;
their ignored scratch records are unavailable in this checkout. They are not
premises of the argument below. No further lengths, words or primes were
searched. Timeout and rejection at a few lengths do not give a uniform result.

## Integral coordinates for the actual recurrence

Fix `N=4`, an admissible prime `p=5 mod 8`, and normalized integer coefficients

    C(X) = sum_(v>=0) X^(2^v)/(1+X^(4*2^v)),
    c_(2h)=c_h,     c_(2h+1)=alpha_h,
    alpha=(1,0,-1,0) periodically modulo 4.

Reduce this same sequence modulo p. Replace root-boundary coordinates `(u,v)`
by the invertible Fourier coordinates

    f_i = sum_(z^4=1) z^i u_z,
    s_j = (1/4) sum_(z^4=1) z^(-j) v_z,       0<=i,j<4.

Then `f` is the periodic forcing, and `s_j` is the sum of polynomial
coefficients in residue class j. Write the actual relation as

    R_t(m,n) = {(f,s): exists x,
      sum_(j<n) c_(t+i+j) x_j = f_(i mod 4), i<m,
      s_a = sum_(j<n, j=a mod 4) x_j}.

The terminal target is equivalently `tau=(0,0,0,0,1,1,1,1)`: the root target
maps to `(0,1/4,1/4,1/4,1/4)`, and relation membership is homogeneous.
All sizes on the prescribed ray are saturated (`k>=4`). This equivalence is
restricted to odd admissible characteristics, not characteristic two.

For the parity merge, let `s^0,s^1` be the residue vectors of the even and
odd polynomial children. For row parity `a`, put

    b=(t+a) mod 2, o=1-b, h=(t+a+o-1)/2,
    (D_a f)_i = f_(2i+a mod 4),
    (K_h s)_i = sum_(j<4) alpha_(h+i+j mod 4) s_j.

The exact simultaneous child conditions and parent output are

    (D_a f - K_h s^o, s^b) in child_a,       a=0,1,
    s_(2j mod 4) += s^0_j,
    s_(2j+1 mod 4) += s^1_j.

These are the existing parity equations in a different basis. Both children
retain their own vectors while sharing the same parent data. In particular,
the two occurrences of one child relation do not receive independent
parameters. The two offsets at odd t remain distinct.

Use internal variables `w=(s^0_2,s^0_3,s^1_2,s^1_3)`. The inverse split is

    s^0=(s_0-w_0,s_2-w_1,w_0,w_1),
    s^1=(s_1-w_2,s_3-w_3,w_2,w_3).

Thus the change from `(f,s^0,s^1)` to `(f,s,w)` is **unimodular**. All child
maps `M_a(t):(f,s,w)->(D_a f-K_h s^o,s^b)` have integer entries and depend
only on t modulo 8. No determinant, parameter or prime is inverted here.

## Fraction-free propagation and why specialization is safe

Represent a relation of codimension c by a nonzero decomposable c-form
`Omega` spanning the top exterior power of its annihilator. If its defining
rows are `l_1,...,l_c`, use `Omega=l_1 wedge ... wedge l_c`.
Let `E_w` retain the coefficient containing all four internal covectors
`dw_0,...,dw_3`, with boundary coordinates first. The merge law is

    Omega_parent = E_w(M_0(t)^* Omega_0 wedge M_1(t)^* Omega_1).     (1)

It is bilinear, integral and contains no elimination pivot or normalization.
The overall sign is irrelevant. All coordinates, including zeros, are retained.

Here is the nonvanishing argument; finite agreement is not its justification.
For actual nearly square blocks, the existing no-invisible-vector theorem and
its transpose give relation dimension `4+n-m`. The simultaneous child solution
space projects injectively to the actual parent relation. Consequently the
pulled-back annihilator rows are independent, and their restriction to the
four internal columns has rank four. Over any admissible field, row operations
can therefore arrange four rows as `[C|I_4]` and the remaining rows as `[B|0]`.
Extracting all four internal covectors gives a nonzero scalar times the wedge
of the independent rows of B. These rows annihilate exactly the parent
relation. This proves that (1) is nonzero and correct in **every** admissible
characteristic, including when the square Hankel block is singular. The row
operations prove the statement; the implementation never performs them.

Seeds are obtained equally without a rational chart. At each of the eight
fixed input blocks wedge the `m+4` rows

    [-D_m | 0    | A_t(m,n)],
    [ 0   | -I_4 | V_n       ],

in boundary coordinates `(f,s)` followed by the n polynomial coordinates x;
then extract the coefficient containing all n internal x covectors. Here
`D_m` repeats residues and `V_n` sums residues. Transposed no-invisibility gives
full row rank of `[-D_m|A_t]`; the moment equations add four independent rows.
No-invisibility makes projection injective. The same argument as above proves
that every seed form specializes nontrivially at every admissible p.
Induction now proves (1) correct for all repetition lengths and all such p.
The proof uses neither the Challenge placeholder nor an assumed sharpness claim.

**Never divide these forms by coordinate content or a rational pivot.** Such
an operation needs its own specialization justification and is not part of
this law. Common factors at nonadmissible primes need not be removed.

## The explicit repeated block and complete terminal criterion

Order the eight components `A00,A01,A10,A11,B00,B01,B10,B11`, where A has
shift `q+1` and B shift `q+2`. With `e=2(q mod 4)+2 mod 8` and `o=e+1`,
one `(1,1)` digit uses the following exact ordered pairs in (1):

| Output | t mod 8 | child 0 | child 1 |
| --- | --- | --- | --- |
| A00 | e | A11 | B00 |
| A01 | e | A11 | B01 |
| A10 | e | A11 | B10 |
| A11 | e | A11 | B11 |
| B00 | o | B10 | B01 |
| B01 | o | B11 | B01 |
| B10 | o | B10 | B11 |
| B11 | o | B11 | B11 |

The two inputs have initial phase 2. Their phases are `2,1,3,3,...`; the
corresponding pairs `(e,o)` are `(6,7),(4,5),(0,1),(0,1),...`. After two
steps this is one fixed coupled polynomial map. The entire eight-tuple has
504 exterior coordinates (codimensions `4,3,5,4` at each shift).
The actual indices are `q_m=2^m(q_0+1)-1`, `k_m=9*2^m-1`.

For the first square set

    r_m = interior_product_tau(Omega_A00,m).                         (2)

It is a 3-form with 56 coordinates. A vector annihilates a nonzero
decomposable 4-form by contraction exactly when every annihilator row
vanishes on that vector. Therefore, for every m and admissible p,

    T(q_m,k_m) accepts  <=>  all 56 coordinates of r_m vanish mod p.

Equivalently p divides their integer gcd, using `gcd(0,...,0)=0`.
This is **necessary and sufficient full simultaneous compatibility**, not
one selected obstruction pairing. Together (1)--(2) give the requested
fraction-free law. They do not identify a suitable m or bound its gcd.

## Validation and its limits

[The standard-library implementation](../search/fraction_free_block.py) uses
sparse exterior products. Its run checks only the previously studied lengths
`m=0,1,2` on both inputs. At p=5,13 it compares all eight resulting forms
with annihilators of the independently constructed original-root-sum relations:
96 whole-relation comparisons, through coefficient **579 inclusive**. Three
existing terminal controls include r=1 at p=3, acceptance at `(p,q,k)=(5,311,12)`
and rejection at `(5,313,12)`. This prevents a vacuous always-rejecting test.
Generation uses the formal generating series, not the root-sum oracle.

The six prescribed residual gcds are all 1, as are the contents of their
eight relation forms. This agrees with the finite prior rejections; **no
all-length gcd assertion follows**. No m>=3, additional prime, suffix, graph,
attainment box, symbolic elimination or Smith calculation was run.
There is no random seed or external Python dependency.

Reproduction with the saved exports and guarded prepared runner:

    python3 -m search.fraction_free_block
    python3 -m unittest discover -s tests -p test_dyadic_corner_family.py -v
    python3 -m search.dyadic_selector_obstruction

Relevant existing BoundaryRelation, TerminalDetection and DyadicRay type/axiom
audits were rerun using the absolute prepared Lean/Lake 4.35.0 binaries and
`env_for('littlewood')`. See [commands, timings, pins and source hash](2026-11-15-integration-validation.json)
and the six linked command outputs there. No Lean source changed; no new Lean
theorem, whole build, full Python suite or independent-kernel replay is claimed.
The existing `Challenge.lean:37` hole supplies no audited proof premise.

## Sources, environment and next decision

Targeted primary recheck accessed **14 November 2026 UTC / 15 November Sydney**:
[Lai--Sprang arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633), still the
sole displayed version, 30 May 2026; read
[Theorem 1.2, (1.2), Proposition 2.3 and its reduction](https://arxiv.org/html/2606.00633v1).
The paper proves the positive lower bound for every odd-characteristic ground
field and irreducible P; it does not prove uniform attainment. The present
coordinate law is an internal deduction from that input and the existing
boundary recurrence. The weekly review's bounded coverage and journal full-text
gaps remain; no broad daily search, new characteristic-two candidate, source
absence or priority claim is made. Existing Apache-2.0 attribution is retained;
no external implementation or prose was copied.

The complete prepared check passed before work and after refresh without
installing/downloading. Read saved Start and bootstrap recovery instructions;
the unchanged bootstrap source is the tested `b60cf9a0` version. Exact pins,
dependencies, readiness and representative imports passed. Expected origin is
`https://github.com/solresol/function-field-littlewood.git`. Clean generated
work at `19bc3a604742f70957a820a3994aa3e9353bd03b` matched fetched main;
ancestry checked, work preserved, tracking main created. No other worktree or
research process was observed locally. No applicable AGENTS file was found.
Computations and audits obeyed the prepared resource guards. No sibling runtime,
setup, dependency/security/credential, schedule, environment publication or
user-machine change occurred. Raksasa reconciliation remains a separate
coordinator task.

**Next mathematical obligation:** find a structural identity for the **full**
56-coordinate residual under the autonomous pair of merge maps at t residues
0 and 1 after phase stabilization, for example a preserved Bezout relation excluding all
admissible primes, or a mechanism forcing a common admissible prime divisor
at a controlled length. No such identity was obtained. Do not infer it from
the six gcds, expand the lengths, repeat Smith elimination, or formalize this
generic exterior packaging as a substitute. Select a concrete invariant to
try next; if it cannot be motivated, change the reachable shift/size family.
