# A fixed first-square linear envelope cannot exclude the target

16 November 2026, Monday, Australia/Sydney. Sources accessed 15 November UTC /
16 November AEDT. **Mathematical progress on an auxiliary invariant obstruction**:
an exact all-admissible-prime negative lemma for a specified approach. Neither
uniform `Delta_p=2N` nor the characteristic-two frontier is decided.

## Question stated before coding

The [15 November law](2026-11-15-fraction-free-integration.md) propagates full
compatibility but gives no accepting length or residual invariant. Test its
simplest motivated rejection invariant: fixed linear constraints on each of the
eight boundary relations, containing the two actual inputs and preserved by
the autonomous phase-3 map, with the first-square constraints excluding the
terminal target. A successful invariant would reject every repetition on these
rays. Failure would retire this specific linear-envelope approach, while
leaving nonlinear exterior identities and state-dependent constraints open.

Read the **13 November** checkpoint in the
[weekly human-literature review](2026-11-06-literature-review.md#13-november-2026-checkpoint)
before selection. Its bounded coverage and journal full-text gaps remain.
No new characteristic-two stream or broad daily literature search was selected.

## Exact statement

Use the integer normalized stream

    C(X) = sum_(v>=0) X^(2^v)/(1+X^(4*2^v)),

and the existing Fourier/residue boundary coordinates `(f_0,...,f_3,s_0,...,s_3)`.
For `q>=0`, let the first-square relation be

    R(q,k) = {(f,s): exists x_0,...,x_(k-1),
      sum_(j<k) c_(q+1+i+j) x_j = f_(i mod 4), 0<=i<k,
      s_a = sum_(j<k, j=a mod 4) x_j, 0<=a<4}.

For `p=5 mod 8` this is precisely the actual normalized Lai–Sprang relation
after the invertible Fourier change of coordinates, over F_p and its field
extensions. The terminal target is proportional to
`tau=(0,0,0,0,1,1,1,1)`. The relation definition uses the raw coefficient
start `q+1`; `q` itself is the terminal shift. This distinction is essential.

Put `q_m=2^m(q_0+1)-1`, `k_m=9*2^m-1`, for `q_0=62,126`.
Both rays first reach phase 3 at m=2. The following holds:

**Lemma.** In every field of characteristic `p>3`, at least one of

    R(251,35), R(503,71),       or       R(507,35), R(1015,71)

is a transverse pair of four-dimensional subspaces of K^8. In particular,
for every admissible `p=5 mod 8`, any linear subspace W containing the
first-square relations of **both** actual rays for every m>=2 is K^8.
Thus no fixed nonzero first-square covector common to both rays can exclude
tau from the first autonomous step onwards, even if chosen separately for p.

For characteristics not having N=4, the displayed statement is only about
this specified integer stream; it is not a Lai–Sprang-scale claim there.
The N=2/r=1 comparison remains the settled separate case.

## Integer proof certificate

For each pair `(q,k),(q',k')`, impose both sets of defining equations using
the **same** boundary vector `(f,s)` and separate polynomial vectors x,y.
In columns `(f[4],s[4],x[35],y[71])` the matrix has 114 rows and columns.
Its ordered blocks, with repeated-residue matrix D and residue-sum matrix V,
are

    [-D_35   0     A_(q+1)(35,35)       0             ]
    [  0    -I_4   V_35                 0             ]
    [-D_71   0     0                    A_(q'+1)(71,71)]
    [  0    -I_4   0                    V_71          ].

The [certificate](2026-11-16-linear-invariant-certificate.json) gives determinants

    D_62  = 311100975435120619377323849997562446056541693025356,
    D_126 = 71125722095308481942689533506690707367649200178,

and explicit integer weights a,b with `a*D_62+b*D_126=18`. Both determinants
are divisible by 18. Hence their gcd is exactly 18; for every p>3 at least
one matrix is invertible. No factorization or sampled-prime argument is used.

If that joint matrix is invertible, the two projected relations intersect
only in zero. Projection from either block's solution space is injective:
an invisible polynomial solution would also give a nonzero joint kernel
vector. Each individual block has k+8 variables and k+4 equations, so its
projected relation has dimension at least four. Trivial intersection in K^8
then makes both dimensions exactly four, and their sum is K^8. This proves
the lemma directly from the integer determinants. No unproved sharpness,
rank, no-invisible-vector or Challenge premise is needed for this step.

The determinant calculation is a computer-assisted exact proof certificate,
with two independent calculation paths; it is **not Lean/kernel checked**.
It is not finite agreement about an unbounded residual gcd or acceptance.

## Reproduction and checks

[The focused implementation](../search/repeated_linear_obstruction.py) reuses
the existing fraction-free law at m=0,1,2, then takes just the first-square
image of the fixed phase-3 map: `merge(A11,B00,t=0 mod 8)`. Wedge with the
input annihilator gives each determinant. This one image is needed to test
the stated invariant; no terminal target is queried at m=3 and no length,
word, prime, graph or attainment search is run.

Independent readback constructs both full original-window matrices using
the integer odd-part coefficient formula, independently of the generator's
formal-series expansion and exterior maps. Existing Fraction Gaussian
determinants reproduce both integers; direct integer dot products check the
Bezout identity. The last coefficient indices are **644** and **1156 inclusive**.
No pivot or coordinate content is divided out before reduction modulo p.

    python3 -m search.repeated_linear_obstruction --generate
    python3 -m search.repeated_linear_obstruction
    python3 -m unittest discover -s tests -p test_repeated_linear_obstruction.py -v

All pass under the prepared guarded runner: generation 2.060s, independent
readback 2.068s, focused tests 5.069s including guard overhead. Tests disable
the exterior generator during readback, reject corrupted determinants,
endpoints, contexts and Bezout weights, and retain existing accepted/rejected
terminal controls including r=1. Standard-library-only retained code; exact
arithmetic and no randomness. See [commands, pins, hashes and development
limits](2026-11-16-linear-validation.json) and linked outputs.

The initial exploratory rational envelope saturated; its tooling is ignored
scratch, not a deliverable. A corrected relative-module invocation and an
initial 112-versus-114 dimension assertion failure are recorded; the latter
is retained in [its failure log](2026-11-16-linear-generation-initial-failure.txt).
That assertion was corrected before all retained successful verification.
An installed SymPy limited factorization was exploratory only; it supplies
no proof premise or retained dependency. No Smith/elimination timeout or
expanded terminal search occurred.

## Limits and next decision

The excluded approach is **target exclusion by a fixed first-square linear
envelope common to both rays, starting at m=2**. This does not exclude
constraints coupling components, nonlinear/Plucker invariants, moving
covectors, prime-dependent selection of just one ray, or invariants beginning
on a later tail. It gives neither an accepting repetition nor all-length
rejection. Both determinant values may vanish at particular primes; only
their simultaneous vanishing is excluded. The joint kernel is a shared
arbitrary boundary, not the terminal test, so transversality itself says
nothing about either input's acceptance.

Retire the fixed common envelope as a way to prove nonvanishing of the full
residual. A further attempt on this repeated block needs a **moving** dual
covector with a proved transport rule and controlled nonzero pairing with
tau, or a specific nonlinear identity on the full tuple. No such rule was
obtained today. Without a concrete candidate, change the reachable shift/size
family; do not expand repetition lengths or infer anything from residual gcd
samples. No generic formalization of today's determinants is the next priority.

Targeted primary recheck: [Lai–Sprang arXiv:2606.00633](https://arxiv.org/abs/2606.00633),
still sole displayed **v1, 30 May 2026**; read
[Theorem 1.2, (1.2), Proposition 2.3 and the reduction](https://arxiv.org/html/2606.00633v1).
Its proved odd-characteristic lower bound does not assert uniform attainment.
Today's negative lemma is an internal deduction; no novelty claim is made.
Existing Apache-2.0 mathematical attribution is preserved.

Saved Start and bootstrap recovery instructions were read. The complete
prepared readiness check passed before work and after fetch, without setup
or downloads. Expected solresol origin and clean work at `0e38db2` matched
fetched main; ancestry was verified, work preserved, tracking main created
and FF-only checked. No applicable AGENTS file was found. Only this repository
was edited. Existing pins, dependencies, runtime, credentials, environment
configuration and schedules are unchanged. No Lean source changed, so no new
Lean build or axiom audit is claimed. `Challenge.lean:37` is not a premise.
The parent coordinates Raksasa synchronization after a verified push and keeps
its local Littlewood schedule paused; this worker uses no direct remote shell.
