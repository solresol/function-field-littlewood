# The dyadic selector is characteristic-specific at N=4

9 November 2026, Monday, Australia/Sydney. Scheduled invocation:
8 November 21:20 UTC; executed 8 November UTC / 9 November AEDT.

**Mathematical progress on an auxiliary acceptance obstruction:** the known
five-digit continuation accepts the first canonical dyadic ray state at N=4
if and only if the characteristic is 5. It rejects the stable ray state in
every admissible characteristic. These are exact all-prime conclusions from
integer identities, not sampled nonattainment. They rule out extending this
particular selector uniformly across primes. They do not exclude other words,
decide another prime, prove uniform sharpness, advance characteristic two or
supply a Lean theorem. No novelty/priority claim is made.

## Question and research decision

Read the actual [6 November weekly human-literature handoff](2026-11-06-literature-review.md),
current roadmap, source and [8 November dyadic-family proof](2026-11-08-dyadic-corner-family.md)
before selecting work. The unresolved obligation is an accepting criterion
meeting one of the two reachable signed corner lines uniformly in the prime.
Before coding, asked whether the existing five-digit F_5 continuation extends
uniformly even within the fixed N=4 class, or whether integer specialization
forces it to be characteristic-specific. A uniform criterion would support
reusing this word. An exact obstruction would require a different or
prime-dependent continuation; a mere finite list of failed primes would not
answer this question.

Let p be any prime with v_2(p-1)=2, equivalently p=5 modulo 8. Set

    W = (1,1),(0,1),(0,1),(0,0),(1,0),
    S_a = T(2^a-2,8),  a>=6.

Digits are (shift,size), most significant first, with the established update
T(q,k) -> T(2q+epsilon,2k+eta). The exact conclusion is

    W(S_a) accepts  if and only if  p=5 and a=6.             (1)

This includes every extension of each admissible prime field. It is a
classification for this prescribed infinite ray and this one word; it is
not a classification of all suffixes, all reachable states or all N.

## An integral terminal system

For N=4 the normalized coefficients c_n=a_n/2 are the integer coefficients of

    C(X) = sum_(v>=0) X^(2^v)/(1+X^(4*2^v)).               (2)

For n>0, if u is its odd part, c_n=0 unless u=1 modulo 4,
and otherwise c_n=(-1)^((u-1)/4). Thus reduction of this *same integer
sequence* gives the actual normalized stream in every admissible prime field.
Generation uses this support expression. Independent readback expands (2)
directly through the inclusive endpoint. No finite truncation is substituted
for the infinite stream beyond the finite rows being tested.

Put k=284. Define the integer (k+4)-by-k matrix A_q and column b by

    (A_q)_(i,j) = c_(q+1+i+j),                 0<=i,j<k;
    (A_q)_(k+a,j) = 1 if j=a modulo 4, else 0, 0<=a<4;
    b = (0,...,0,1,1,1,1)^T.

Over a field with four distinct fourth roots, A_q s=b is equivalent to
terminal target membership at T(q,k). Indeed, if x is the usual polynomial
with moment 1 at root 1 and moment 0 at the other roots, set s=4x. Its
four residue sums are all 1: evaluation at the fourth roots is exactly the
polynomial 1+X+X^2+X^3 modulo X^4-1. Conversely those residue sums give
the required moments after division by 4. The first k rows impose the usual
zero Hankel rows. The Fourier/Vandermonde map is invertible since p is odd.
The saturated-size test holds because k>=4. No endpoint assumption is needed
to derive rejection.

For any integer linear system A s=b, an integer row y satisfying

    y*A=0,  y*b=d                                           (3)

forces d=0 in every field where the system is solvable. In particular, if
d is nonzero, only prime divisors of d can allow a change from rational
inconsistency to finite-characteristic solvability. This elementary
specialization criterion is applied to the actual terminal systems here.

## Exact obstruction constants 5 and 1

Applying W to the first two ray representatives gives

    T(62,8)  -> T(2001,284),
    T(126,8) -> T(4049,284).

The [integer certificate](2026-11-09-selector-integer-check.json) supplies
two 288-entry integer rows, checked entry by entry, with

    y_- * A_2001 = 0,   y_- * b = 5;
    y_+ * A_4049 = 0,   y_+ * b = 1.                         (4)

The first identity excludes every characteristic other than 5. Sufficiency
in characteristic 5 is checked directly using the retained 284-entry primal
from the [6 November certificate](2026-11-06-corner-terminal-check.json),
multiplied by 4. All 288 equations hold modulo 5; both polynomial endpoints
remain nonzero. This does not supply an additional attainment instance.
The second identity excludes solvability in every field for this integral
system. Its Littlewood interpretation here is restricted to N=4 primes.
Equation (4) alone suffices for both exclusions: no rank-completeness,
Smith-form, determinant-factorization or solver claim is a premise.

The earlier all-prime dyadic-family lemma gives S_a=S_7 for every a>=7,
including phase and every full boundary relation. Deterministic correlated
updates preserve equality along W. Thus the two finite integer identities
prove (1) for **all** a>=6 and all admissible primes, rather than a bounded
exponent or prime search. In coordinates the output is
T(32*2^a-47,284); equality of its terminal state with the representative
does not assert equality of its absolute shift.

## Computation, checks and unsuccessful approaches

There was no new word enumeration, prime sweep, witness box or randomness.
Discovery considered exactly q=2001 and 4049, each with 284 columns and
288 equations. Rational left kernels establish inconsistency in characteristic
zero but initially produce large obstruction constants that do not by
themselves classify the exceptional primes. Kernel calculations in the two
prescribed opposite row orders produce different integral sublattices.
Combining them and taking a Bezout combination of their target pairings gives
exactly 5 and 1. Small-lattice Hermite normalization and elementary integer size
reductions shorten the records. The generator uses preinstalled SymPy 1.14.0;
no package was installed, upgraded or pinned differently. None of the kernel
generation, normalization or reduction is trusted by the readback.

Unsuccessful scratch approaches are retained in the validation account: an
initial incorrect runpy invocation failed before research execution; full
285-dimensional Hermite normalization and a direct integer diagonalization
each hit their independent 60-second guards; optional SymPy LLL shortening
raised an internal assertion. No timed-out result or LLL output was used.
The successful route uses two rational kernels and a rank-four lattice,
followed by exact elementary reductions. These failures are algorithm limits,
not mathematical nonexistence evidence.

Readback reconstructs (2), checks all 568 integer annihilator entries and
both exact pairings, and checks the characteristic-five primal without a
solver or state recurrence. Tests disable those facilities and SymPy during
readback. Independent original-root sums check (2) modulo 5 and 13 through
index 4616 inclusive. Ten corruptions exercise altered duals, contexts,
pairings, endpoints and primal data. Regeneration exactly matches the saved
certificate. Prescribed actual state controls use p=5,13,29 and a=6,7,8;
these controls are not the all-prime proof. The two direct coefficient
endpoints are 2568 and 4616 inclusive.

Reproduction from the checkout root:

    python3 -m search.dyadic_selector_obstruction
    python3 -m unittest discover -s tests -p test_dyadic_selector_obstruction.py -v
    python3 -m unittest discover -s tests -q

Optional regeneration, to a new path (the command refuses to overwrite):

    python3 -m search.dyadic_selector_obstruction --generate --path .research/selector-recheck.json

All accepted checks use the prepared prepare.py guarded runner and
env_for('littlewood'), with a 2 GiB disk reserve, 12 GiB process-group RSS
limit, two Lean threads and a 300-second command bound. Actual commands,
timings, dependency versions, hashes, failed approaches and full-suite evidence
are in [the validation record](2026-11-09-selector-validation.json).
No Lean source changed, so no new Lean build or axiom-audit claim is made.
Challenge.lean:37 and downstream assumed statements supply no premise.

## Sources, runtime and next obligation

Targeted primary verification accessed **8 November 2026 UTC / 9 November
Sydney**: [Lai-Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
30 May 2026, still the sole listed version; read
[Theorem 1.2, equation (1.2) and Proposition 2.3](https://arxiv.org/html/2606.00633v1).
Its lower bound holds for every irreducible P over every odd-characteristic
ground field. It does not assert uniform attainment for this stream.
The result above is an internal deduction supported by exact integer identities.
Reuse the latest weekly review's bounded coverage and recorded journal access
gaps; no broad daily search, new binary candidate or source-absence claim was
made. Existing Apache-2.0 source and Lai-Sprang attribution are retained;
no external implementation or prose was copied.

The complete prepared startup gate passed, including Scholz, with unchanged
exact pins and no setup or downloads. The expected origin and clean generated
work branch at bb77f89868daf54b5005e7b161da9eb9d36a5e1d matched fetched main.
Verified ancestry, preserved work, created tracking main and fast-forwarded
only. The coordinator checked account-level concurrency; local worktrees,
processes and absence of an index lock showed no competing repository writer.
The attached executor and prepared runtime were verified without equating
the platform's different configuration identifier namespaces. No applicable
AGENTS.md or .agents skill was present. Saved Start was unavailable both in
the cloud/executor skill catalogues and local skill locations; the explicit
standing startup instructions were followed. No shared runtime, sibling
checkout, credentials/security, environment settings or schedules were changed.
No Raksasa access occurred; the coordinator owns that separate authorized sync
and must keep the local schedule paused.

**Next:** a uniform criterion needs a different continuation, a continuation
depending on p, or a different reachable shift/size family. Extending the
dyadic exponent and replaying W cannot do it, already for N=4. The two
reachable lines themselves remain viable inputs for other words. Neither
uniform Delta_p=2N nor the characteristic-two frontier is settled. This is
one audited auxiliary obstruction; do not replace the remaining acceptance
problem with more fixed-pair suffix enumeration or routine certificate work.

A specific next mathematical question is whether controlled repetition of a
projective/conic transport block yields a recurrence for integral obstruction
pairings whose reduction vanishes at a predictable p-dependent length. Such
divisibility would still be only necessary: a positive result must also prove
full simultaneous target compatibility and retain the actual signed input line.
Derive that recurrence before any further suffix enumeration.
