# Weekly integration after the sharpness refutation

18 October 2026, Sunday, Australia/Sydney. Starting commit `37f3007`.
Classification for this run: **verification/infrastructure progress**, plus
roadmap maintenance. No new mathematical theorem or characteristic-two result.

## Exact question and decision

Before running checks: does the p=5 complete-cover exclusion below degree 44
agree with the degree-44 sharpness witness under the same stream, row and
endpoint conventions? A cover gap would weaken the claimed least degree;
it would not undo an independently verified witness. Agreement supports
retiring the old all-degree proof plan, not a universal sharpness conjecture.

The check succeeds. The week's decisive mathematical result was already in
the checkout: the auxiliary j-d<=N hypothesis is false, with defect 2N
certified at p=5,13,29,37,53,61. All six have Lean refutations; only the
default library and p=5/p=13 audit were rerun today. No N>=8 prime is decided.
This is auxiliary sharpness work on known odd-characteristic counterexamples.

## Consistency and independent small checks

For N=4 and quotient degree at most E, the cover reads the inclusive indices
M+1,...,M+T, where T=2N+2E. With L the least power of two greater than T,
the residue period is P=NL. Every nonexceptional coefficient is preserved
by adding P to M. At most one read index is divisible by L; allowing its
value to be 0,1,-1 covers all actual shifts, possibly with extra cases.

| E | T | L | P | Abstract cases | Terminal events |
|---|---:|---:|---:|---:|---|
| 7 | 22 | 32 | 128 | 304 | none |
| 8 | 24 | 32 | 128 | 320 | (b,x,e)=(55,-1,8),(119,-1,8) |

The profile jumps are exactly 5 at the two events. Direct modular nullspaces
give the same list over every degree 0,...,8. For an additional independent
coefficient check, replace the odd-part generator in that direct calculation
by the integer formal expansion sum_k x^(2^k)/(1+x^(4*2^k)), through index
152. It gives the same list. The existing small test also expands the original
two rational summands at each scale over F_5, without the support formula or
root-sum shortcut, and recovers rows 1,...,51 zero and row 52 equal to 4.

The p=5 terminal witness has S=F_1 V, deg V=8, deg S=11 and M=311.
Its last checked index is 311+11+13=335. The lifted R=S(t^4) has degree
44, shift 1244 and first index 52; the inclusive last input is 1340.
Both endpoints are nonzero. The product is 2^-8, below the proposed 2^-4.

Descent sends an original d+4 zero window to a nonzero terminal polynomial
of degree floor(d/4). Divisibility by F_1 gives quotient degree
floor(d/4)-3. For d<12 that is impossible; for 12<=d<44 it is at most 7,
excluded by the complete cover. The witness attains degree 44. This
computer-assisted minimality argument is not itself a Lean theorem.

The older N=4 boundary cutoff d<24 and formal cutoff d<20 are therefore
consistent. The N=8,16 boundary certificates, gap and two-strip identities,
and actual r=1 terminal/lift controls reproduce. They address smaller degrees
and do not contradict the new witnesses.

## What the week changed

- **Mathematical progress already recorded:** prime-independent boundary
  exclusions (12 October), the uniform support-gap and two-residue lemmas
  (14/16 October), then the continued-fraction reformulation and explicit
  refutation of the auxiliary hypothesis (17–18 October).
- **Verification/infrastructure:** formal descent, low-degree cutoff and
  sparse-divisor obstruction; reverse lift and all six sharpness certificates;
  number-wall implementation and this integration. Finite checks and successful
  builds are not additional conjecture progress.
- **Maintenance:** obsolete active roadmap instructions are replaced. Closing
  the degree-H offsets cannot restore the refuted universal bound. Further
  sporadic attainment examples, certificate exports and engine optimization
  are not default research objectives.

Characteristic two did not advance. No new candidate was selected, and none
of the three retired binary streams was searched further.

## Correction to the waiting-time argument

The cover itself has exactly N(L+2T) cases: among NL shift residues, NT
contain a multiple of L, each receiving two extra possible values. Since
L<=2T, this is at most 4NT. Thus for fixed N there are O(E) covered windows
and at most O(E^2) (window,degree) cases through E. This is an upper bound,
not a matching lower bound on distinct cases. It also says nothing about
independence or a p^-N event probability in this structured sequence.

The p^(N/2) waiting scale therefore remains an unproved random model.
The earlier wording deriving an order-of-growth count from automaticity is
qualified in the sharpness report. Empty N>=8 ranges decide neither branch.
The suggested optimized throughput is not measured; even at 1–3 billion
cells/second, 6*10^13 cells take about 5.6–16.7 hours before extraction costs.
No engine rewrite, benchmark or large search was performed today.

## Verification scope and reproduction

[The validation record](2026-10-18-sunday-validation.json) records commands,
inputs, outputs and runtimes. Python 3.14.4, standard library, no randomness.
The 11 existing sharpness tests passed (0.316 seconds including startup),
including independent p=5/p=13 root-sum readback and corruption controls.
The lift, gap, two-strip and prime-obstruction readbacks took respectively
0.062, 1.148, 0.287 and 2.725 seconds.

`lake build` passed in 26.581 seconds with the existing Lean 4.35.0-rc2 and
mathlib 065356127b1dc0016f66b7283ce0ce2c4055aa55 pins. The separate
`lake env lean verification/SharpnessAudit.lean` passed in 4.539 seconds;
its 19 axiom reports contain only propext, Classical.choice and Quot.sound.
No Lean source, dependency, theorem catalogue or certificate changed. No
independent-kernel replay, large-certificate rebuild, large minimality-cover
rerun or full-suite rerun is claimed.

To repeat the independent coefficient substitution after the commands in the
validation JSON:

```python
from unittest.mock import patch
from search.terminal_prime_obstruction import formal_series
from search.lai_sprang_sharpness import direct_rank_exclusion
a = formal_series(4, 152)
with patch('search.lai_sprang_sharpness.normalized',
           side_effect=lambda N, n: a[n]):
    assert direct_rank_exclusion(5, 8) == [(55, -1, 8), (119, -1, 8)]
```

## Literature boundary and next decision

Primary sources accessed 18 October 2026:

- [Lai–Sprang 2606.00633v1](https://arxiv.org/html/2606.00633v1), the only
  version listed on its abstract page, settles odd-characteristic existence.
  Theorem 1.2 supplies the 2N upper bound on defect; the repository witnesses
  attain it at the six listed primes. The universal upper bound is literature
  input, not a new Lean theorem here.
- [Badziahin–Pavlenkov–Zorin 2608.22078v1](https://arxiv.org/abs/2608.22078v1)
  still states its characteristic-two conclusion conditionally on existence.
  Scoped searches for Littlewood and characteristic two/2 found no later
  relevant resolution. This is an evidence boundary, not proof of absence.
- [Adiceam–Nesharim–Lunnon 1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  records the quadratic-series exclusion. Rational series are excluded by
  clearing denominators. [Garrett–Robertson 2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5)
  records the known unbounded-window examples. These screens still apply.

Next computation: attempt a parity-block recurrence for the derived terminal
Hankel rank defect whose residual dimension depends only on N, retaining the
characteristic and exact row budgets. Test any identity on the existing p=5
witness and N=8 boundary data before new searches. If residual dimensions grow
or states fail to determine transitions, record that obstruction rather than
building a larger wall. No such recurrence has been established in this run.

Next formal lemma: derive odd-filter vanishing from (1+X^H)|S using the
existing root enumeration, then propagate it through reverse-lift scales.
This would remove per-instance odd-row checks from the terminal-to-2N
implication. It verifies known mathematics and cannot establish existence
of terminal witnesses in unresolved characteristics on its own.
