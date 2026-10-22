# Square boundary data do not determine terminal continuations

23 October 2026, Friday, Australia/Sydney (AEDT).
Classification: **mathematical progress: a verified finite obstruction to a
proposed structural reduction**. No universal sharpness theorem, new prime
case, characteristic-two construction, Lean theorem or priority claim.

## Question stated before coding

Does `(q mod N, min(k,N), R_(q+1)(k,k))` suffice as a deterministic state for
future terminal acceptance under the paired binary transitions? This is the
compression explicitly proposed after correlated closure on 21–22 October.
A conflicting continuation rules it out; finite agreement would be inconclusive.
The main objective remains Delta_p=2N, not the refuted auxiliary N-bound.

## Exact obstruction and ordinary consequence

Use the normalized stream and root ordering of the 19/21 October reports.
Over F_5, N=4, the actual states T(31,4) and T(63,4) have identical compressed
data: phase 3, capped size 4, and square relation with reduced row basis

```
1 0 0 0 | 3 1 2 3
0 1 0 0 | 1 0 2 2
0 0 1 0 | 2 2 2 3
0 0 0 1 | 3 2 3 3
```

Their next-shift square relations R_(q+2)(4,4) also agree. In fact components
(d,i,j)=(0,0,0),(0,0,1),(0,1,0),(1,0,0) agree; the other four differ.
Thus even adding the adjacent-shift square to the proposed data does not suffice.

Append the same paired binary word `(0,1),(0,0),(1,0)`, most significant first.
Each digit sends (q,k) to (2q+epsilon,2k+eta):

| Depth | First pair | Second pair | Square relations equal? | Terminal outputs |
|---|---|---|---|---|
| 0 | (31,4) | (63,4) | yes | reject, reject |
| 1 | (62,9) | (126,9) | yes | reject, reject |
| 2 | (124,18) | (252,18) | yes | reject, reject |
| 3 | (249,36) | (505,36) | no | reject, accept |

**Proposition.** There is no deterministic transition/output system on this
compressed statistic that reproduces all terminal outputs of actual tuples.
The same holds after adjoining R_(q+2)(k,k).

**Proof.** The two actual inputs give the same proposed state. Determinism
would assign identical states after any common continuation and hence identical
outputs. The displayed word has opposite outputs, a contradiction. All starting
and intermediate pairs are actual inputs, with k>=N throughout; neither
unrealizable sibling combinations nor size saturation explain the failure.
Even replacing capped size by the exact k cannot repair this collision.

This is a finite, exact disproof of sufficiency, not empirical evidence from
absence of collisions. It does not prove that all eight relations are necessary,
that no other compression exists, or that any uniform accepting path exists.
The accepting endpoint is used only to distinguish states; an additional
attainment example is not the research outcome. Interpreting terminal acceptance
as sharpness retains the ordinary Proposition 2.3 dependency from 19 October.
The distinction of the linear terminal targets itself needs no such assumption.

## Verification and bounded discovery

Read the saved Start instructions, README, TODO, recent log/results, bootstrap
recovery documentation, and actual tuple, merge, coefficient-oracle and affine
solver sources. No applicable AGENTS.md exists in this repository or workspace
root. The expected origin is https://github.com/solresol/function-field-littlewood.git.
The fresh clean `work` branch at b60cf9a was an ancestor of fetched origin/main
(equal here). Preserved `work`, created tracking `main`, fast-forward-only merge
was already current. No competing research process/lock was present.

First sourced `/workspace/shared/theorem-provers/env.sh` and ran its `check.py`:
all three prepared projects passed exact pins, dependency HEADs and representative
imports. Littlewood uses prepared Lean 4.35.0; no install, download, bootstrap,
cache fetch, dependency mutation or Lean build was needed. Challenge.lean's
existing sorry is not evidence for any claim here. Only this repository changed.

Discovery used existing cached recursive relations over F_5 with q=0,...,127,
k=4,...,16 (1,664 pairs, 1,161 compressed groups). For each group, compare its
first state with other distinct full tuples, trying common words of lengths
1 through 3 in lexicographic order; stop at the first output conflict. It found
the reported pair in 33.802s. This is a bounded discovery procedure, not an
exhaustive classification of collisions or minimal word lengths globally.
A separate targeted check of known accepting-path ancestors over q=0,...,511,
k=0,...,16 found (38,1)/(2,1) separated by `(1,1),(1,0),(1,0)` in 2.392s;
that unsaturated alternative is unnecessary to the retained obstruction.
Both temporary probes completed within 180s/90s limits; no wall run or full
reachable graph was attempted. No randomness or seed.

The retained fixed-input reproducer is `search/square_state_obstruction.py`:

```
python3 -m search.square_state_obstruction > results/2026-10-23-square-state-check.json
python3 -m unittest discover -s tests -p 'test_*boundary*.py' -v
```

The JSON records Python version, runtime, all inputs, differing components,
shared basis and accepting vector. Python 3.12.14, standard library only.
The fixed check takes under one second; 12 focused existing regressions passed
in 0.625s. These checks support the obstruction, not an unresolved global claim.

All eight components at all eight pairs match full original-rational-root-sum
matrices, independently of the support formula and parity merge. An m-by-n
nonempty block reads exactly through q+1+d+m+n-2, inclusive. The largest such
endpoint here is 579 (q=505,d=1,m=n=37); there is no truncated tail assumption.
The independent affine solver checks the target (0,e_1) at every pair, using
all four roots. Accepting vectors are checked with plain root-sum dot products;
rejections retain equation-combination weights and independently verify zero
left side and nonzero right side. Thus rejection is not inferred from an
unsuccessful search. The final accepting vector has both endpoints nonzero.
The r=1 p=3 control (q,k)=(1,2) remains accepting. The two relation paths share
the existing nullspace implementation; the affine/dual path is separate.

## Primary literature screen (accessed 23 October 2026, Sydney)

- [Lai–Sprang, 2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  30 May 2026: all odd characteristics already have counterexamples.
- [Badziahin–Pavlenkov–Zorin, 2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  22 August 2026: characteristic-two exceptional-set consequence conditional.
- [Adiceam–Nesharim–Lunnon, 1806.04478v2, §7.2](https://arxiv.org/html/1806.04478v2#S7.SS2),
  11 October 2020: quadratic-series exclusion; rational series are excluded
  directly by multiplying by a denominator.
- [Garrett–Robertson, 2405.14454v2, §5](https://arxiv.org/html/2405.14454v2#S5),
  8 April 2025: known unbounded-window examples and automaticity context.
- Newly noticed in the scoped search: [Hofer, 2610.12691v1, §1.1](https://arxiv.org/html/2610.12691v1#S1.SS1),
  8 October 2026, *Hankel Matrix Decompositions and Digital Sequences over
  Function Fields*, explicitly identifies characteristic two as the remaining
  P(t)-adic case; the paper offers a digital-sequence viewpoint, not its resolution.

The displayed versions remain current on their arXiv pages. Scoped arXiv queries
for Littlewood/characteristic two and Lai/Sprang/sharpness found no later relevant
resolution; this is no proof of absence or novelty. No binary candidate selected;
Thue–Morse, paperfolding and overlapping-11 Rudin–Shapiro remain retired.

## Next research decision

Retire square-only and adjacent-shift-square-only compression. Differences already
occur in the enlarged (k+1)-square and next-shift rectangles, before the square
output changes. Next test whether the four square relations at shifts q+1,q+2
and sizes k,k+1 determine the rectangular components or their terminal
continuations. Derive a bordered-relation reconstruction, treating singular
blocks explicitly, before searching; this result does not justify dropping
rectangular data. No further closure formalisation or isolated witness export
is needed. A focused future formal lemma could encode this exact compression
obstruction, but a substantive reconstruction or another informative obstruction
has higher research priority.
