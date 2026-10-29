# The complete next-digit target-slice profile is not closed

30 October 2026, Friday, Australia/Sydney (AEDT). The scheduled instant
29 October 21:20 UTC is 30 October 08:20 AEDT.
Classification: **mathematical progress on auxiliary sharpness structure: a
refuted state-compression hypothesis**, proved by a finite exact certificate.
No Lean theorem, new prime decision, uniform acceptance, characteristic-two
construction or novelty claim follows.

## Question and decision

Read the designated [24 October weekly human-literature handoff](2026-10-24-literature-review.md)
and current sources before choosing work. The unresolved auxiliary target is
uniform terminal existence towards `Delta_p=2N` for all odd primes.
The [28 October report](2026-10-28-compatibility-affine-obstruction.md) refutes
fixed affine constraints on differences, but explicitly leaves complete
next-digit affine-slice profile closure inconclusive at saturated sizes.

Stated before coding: can compatibility classes and their direction spaces
be updated under a shared binary digit, retaining phase, size and current
acceptance? A collision with different successor classes would refute that
nonlinear compression; no collision would be inconclusive. The initial
collision also has equal **complete affine slices for all four next digits**,
so it settles the stronger profile-closure question left open on Wednesday.

For each actual state `T(q,k)`, let `C_a^(e,h)(q,k)` be the two primitive-variable
affine child slices of the existing target-preimage criterion, for next digit
`(e,h)` and row parity `a=0,1`. Coordinates are always

    x = (E(2), E(3), O(2), O(3)) in F_5^4.

Retain each whole affine set, plus `K_a^(e,h)`, the projected homogeneous
solution space of its defining local equations. This extra homogeneous space
is retained **even when the affine set is empty**. Define the profile to contain
all eight `(C,K)` pairs, `q mod N`, capped size, size parity and current acceptance.
The collision below also has equal exact k, so adding k does not repair closure.

## Fixed collision at saturated size

Here `p=5, N=4, H=2`, roots `Omega=(1,2,3,4)`, primitive roots `Z=(2,3)`.
Take the two actual inputs

    T(62,8), T(126,8).

Both have phase 2, capped size 4, exact size 8 and current rejection. All eight
affine slices are empty at **both** inputs. Their homogeneous spaces agree:

| Next digit | K_0 basis | K_1 basis |
|---|---|---|
| (0,0) | (1,4,2,3) | (1,4,4,4) |
| (0,1) | (1,4,2,3) | (1,0,4,0), (0,1,0,1) |
| (1,0) | (1,4,4,4) | (1,4,2,3) |
| (1,1) | (1,4,4,4) | (1,4,2,3) |

Apply the same digit `(1,1)`. The successors are `T(125,17)` and `T(253,17)`.
At their next digit `(1,1)`, all homogeneous spaces are zero and the slices are:

| Successor | C_0 singleton | C_1 singleton | Difference a_1-a_0 |
|---|---|---|---|
| T(125,17) | (2,1,3,0) | (4,4,1,2) | (2,3,3,2) |
| T(253,17) | (2,1,1,2) | (4,4,1,2) | (2,3,0,0) |

The successor profiles differ. Therefore **no deterministic update of this
profile alone**, affine or nonlinear, agrees with all actual digit transitions.
This remains false with exact k and current acceptance added. In particular,
recording complete local feasibility, directions and compatibility classes
cannot by itself supply the desired compatibility transport.

This is a statement about closure of the proposed observable, not terminal
language inequivalence. Both displayed successor targets reject. None of the
11 prescribed existing F_5 suffixes of length at most five distinguishes
acceptance for the initial collision. That finite failure is inconclusive;
it neither proves language equivalence nor refutes a different recognizer.
The result also leaves compression restricted to feasible or singleton profiles
open. Full four-square relations still close as previously proved.

## Independent proof from original coefficient equations

The [fixed certificate](2026-10-30-compatibility-profile-check.json) proves the
16 initial local profiles, four separating successor slices, and both current
rejections directly. It does not assume Proposition 2.3, four-square
reconstruction, or any recurrence result as proof of this finite collision.

For parent target shift `M=2q+e` and size `n=2k+h`, write
`S(X)=E(X^2)+X O(X^2)`. Let `c_i=a_i/H` be the normalized stream. On original
row `i=1+a+2 ell`, put `b=(e+1+a) mod 2`. The own polynomial is E if b=0,
O if b=1, with `(n+1-b)//2` coefficients. The other polynomial has
`(n+b)//2` coefficients. Its odd-index contribution is exactly

    H^(-1) sum_(z in Z) z^((M+1+a-b)/2 + ell) x_(1-b)(z).

The own contribution uses the original root-sum coefficients
`c_(M+1+a+2 ell+2j+b)`. The checker verifies the eliminated opposite-parity
coefficient identity entry by entry from the rational root definition.
The target root values of S give all-root values `(1/2,x(2),x(3),0)` for
each of E and O. Every omitted opposite polynomial length is at least N here;
the checked four-root Fourier interpolation identity realizes every such vector.
Thus these original local systems project to exactly the intended affine slices.

For each system `A(x,y)=rhs`, the certificate stores:

- A reduced-echelon basis D for its projected homogeneous solutions, with
  explicit full homogeneous preimages `(d,y)` for each d in D.
- An independent reduced-echelon family H of size `4-dim D`, with explicit
  row-combination weights giving `(h,0)` from A for each h in H.
- Either an affine preimage, or a row-combination contradiction `mu A=0`,
  `mu rhs!=0`.

These primal and dual identities prove the projected homogeneous space is
exactly span(D), by both inclusions and the complementary dimension. The
feasible successor slices have D empty, so their displayed points are unique.
The initial empty slices have explicit contradiction duals. Separate original
square-row/root-moment systems certify both current rejections.
Verification uses dot products and pivot guards, **no Gaussian elimination and
no relation engine**. Generation uses the existing exact solver; readback does
not trust generation. No saved inverse or proof assumption is silently imported.
The largest original coefficient index is **576**, inclusive, for M=507,n=35.
Every read coefficient belongs to the infinite rationally defined series;
no truncated prefix is extended by zeros. Challenge.lean:37's existing sorry
and downstream assumed conclusions are unused.

## Bounded discovery, checks and reproducibility

Use the existing F_5 paths `(311,12),(313,12),(249,36),(505,36)` and F_13 paths
`(1465,80),(1463,80)`. Form B by simultaneous halving of both coordinates,
retaining k>=N; inspect B and all its one-digit extensions only. This gives
12 prefixes / 52 inputs over F_5, and 9 prefixes / 37 inputs over F_13.
Compare complete profiles at equal phase, exact k and current acceptance.
The sole F_5 collision is the displayed pair, obtained by digit `(0,0)` from
`(31,4),(63,4)`. Its sole one-digit profile separation is `(1,1)`.
There is no collision in the prescribed F_13 inputs; that is inconclusive.
Suffixes are only the distinct tails of those existing paths, length<=5:
11 over F_5 and 9 over F_13. No arbitrary suffix tree, new attainment search,
rectangular box or reachable-graph enumeration was used.

Reproduce from the repository root:

    python3 -m search.compatibility_profile_obstruction --check-reduced
    python3 -m search.compatibility_profile_obstruction --discover
    python3 -m unittest discover -s tests -p test_compatibility_profile_obstruction.py -v

Generation is available via `--generate --path NEW_FILENAME`, refusing an
existing output. Four new tests verify independent readback with all solver
and relation routines disabled, reduced-state agreement, exact regeneration,
and seven primal/dual/point/root/completeness corruptions. With existing
boundary, target, four-square and prior affine-obstruction tests, **26 tests pass**;
these retain r=1 and F_13 controls. The fixed proof covers F_5 only.

[Validation](2026-10-30-validation.json) records every retained command, exit
code, log, runtime and source/certificate/pin hashes. Python 3.12.14, standard
library, exact arithmetic, deterministic, no randomness or seed. Discovery took
0.785s and 0.572s internally; seven guarded commands completed in 10.304s.
The prepared guarded runner enforced 180 seconds, 2 GiB disk reserve and
12 GiB process-group RSS per command. No Lean source changed, so no new Lean
build or axiom audit is claimed. This is ordinary finite linear algebra with
independent arithmetic readback, not a proof-kernel theorem.

## Literature, environment and next useful step

Targeted primary reading accessed **30 October 2026 Australia/Sydney**:
[Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/html/2606.00633v1),
30 May 2026, actual Theorem 1.2, functional equation and Proposition 2.3.
The theorem gives an odd-characteristic lower bound, not uniform equality or
an accepting terminal word. The functional equation matches the parity systems;
the independent finite certificate above needs only the original coefficient
definition. Other source versions, access limits and the characteristic-two
frontier screen remain those of the 24 October weekly handoff. There was no
broad daily literature search, new binary candidate or external priority claim.
No external source text or implementation was copied; the existing Apache-2.0
foundation and mathematical attribution are retained.

The clean generated work branch was at
`09cc7ab23eb77e212249e6975c8ddd976e859427` and was preserved. Verified the exact
solresol origin, fetched main, checked HEAD ancestry, created main and completed
the fast-forward-only check; origin/main was already equal. Parent checked the
selected saved environment and absence of overlapping runs. Read saved Start,
bootstrap recovery, current README/TODO/log, recent reports and actual sources;
no applicable AGENTS.md was present. First sourced prepared env.sh and passed
check.py; refreshed toolchain/configuration hashes matched the readiness receipt.
No installation, download, runtime duplication, dependency/pin, credential,
schedule, environment publication, other checkout or user-machine change occurred.
Cloud-thread sending tools are unavailable in this worker; exact push state is
returned to the parent for its authorized reconciliation. The local paused
schedule was left unchanged.

The mathematical increment retires complete fixed-target slice profiles as a
closed-state replacement at saturated size. The next useful question is which
**transverse forcing/output data** from the existing four squares distinguish
this pair but are lost when each local affine target slice is empty. Start from
this fixed collision and derive that missing response before proposing a new
compressed transport. Retaining generic affine packaging or expanding witness
boxes does not address the obstruction. Uniform `Delta_p=2N` and characteristic
two remain unresolved project targets.
