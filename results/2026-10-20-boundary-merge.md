# Exact parity merge in Lean

20 October 2026, Tuesday, Australia/Sydney (AEDT).
Classification: **verification/infrastructure progress**, formalising the algebraic
part of the 19 October ordinary boundary-relation proof. No new mathematical
sharpness result, characteristic-two construction, or priority claim.

## Question and decision, stated before formalisation

Does the odd-index block factor exactly through root evaluations, and does the
resulting two-child merge preserve the parent relation in both directions,
including empty blocks, unequal sizes and the last row? This is the essential
algebraic step on the current proof path to correlated boundary-state analysis.
Success makes that recurrence available to Lean; a failure would expose missing
state information or an endpoint error before pursuing reachability.

The clean main checkout fast-forwarded from 6ed71f1 to 3238e07, from the expected
solresol/function-field-littlewood origin. The fetched p=41 result already selects
2N at N=8 by computer verification; it is not Lean-checked or rerun here. The
auxiliary N-bound is already false, and the successor question is sharpness for
all odd primes. No active research lock was present; this run used its own lock.
Read the latest README, TODO, dated logs/results and actual boundary-relation,
certificate, stream, RootStream and matrix sources before choosing this work.

## What is proved

`FunctionFieldLittlewood/BoundaryRelation.lean` proves:

1. For any weighted odd-root expansion a_(2l+1)=sum_q w_q z_q^l, the entire
   m-by-n odd block is U_m diag(w_q z_q^k) U_n^T. This is a matrix equality,
   not a test on a finite set of input sizes.
2. The named Lai–Sprang stream has a complete injective list of N=2H roots,
   a squaring map sigma, and weights selecting the H odd powers. Here the Lean
   parameter is r with H=2^r, N=2^(r+1); N dividing p-1 suffices. Maximal
   valuation and r>=1 are not required, retaining the usual r=1 comparison.
3. The forcing transport D_a sums over each squaring fibre, weighted by z^a.
   U D_a has entries z^(2i+a); its transpose reconstructs the parity moments.
   Squaring need not be injective. All N roots, including 1, are retained.
4. A generic block-system relation merges exactly: its children retain
   (D_0 u-K_0 v_1,v_0) and (D_1 u-K_1 v_0,v_1), and the parent moments are
   E_0 v_0+E_1 v_1. Both implications are proved with only u,v_0,v_1 as retained
   coordinates. No matrix inverse, injectivity or assumed target is used.
5. `even_merge` and `odd_merge` apply that theorem to the actual parity-indexed
   Hankel matrices. At odd starts the columns and moments are swapped together;
   the two odd blocks use k and k+1, respectively. `natural_holds_iff` supplies
   the explicit equivalence between Fin m and its ceil(m/2)/floor(m/2) parity
   groups. Thus the original rectangular system, including zero sizes and exact
   endpoints, is covered. No nearly-square assumption is needed for the merge.

The generic recurrence hypotheses are discharged for the infinite named stream
by `laiSprangStream_even` and the new `stream_full_root_data`. The latter uses
existing uniform primitive-root existence and the proved odd coefficient formula;
it does not postulate root enumeration or the desired recurrence.

## Normalisation and evidence boundary

The Lean module uses the **raw** stream a, whereas the 19 October Python relation
uses c=a/H. With the same U and moments, R_a(u,v) is R_c(H^(-1)u,v).
Consequently zero-forcing terminal targets are unchanged. The raw odd-block
weight is 1 on primitive roots; the normalized version uses H^(-1). The Lean
module does not claim a separately formalised normalized-coordinate isomorphism.

No-invisible-kernel, exact dimension, Lagrangian structure and terminal-target
characterization remain ordinary results whose proof uses Lai–Sprang Proposition
2.3. They are not hypotheses or conclusions of the new merge theorems. In
particular, a valid algebraic relation merge does not prove injectivity or
terminal existence. Finite coordinate dimension also does not establish a
correlated reachable-state set or a feasible enumeration.

This formalises an existing ordinary structural lemma. It does not change the
mathematical outcome already recorded on 19 October. No new prime is decided,
no larger search is run, and no characteristic-two candidate is introduced.

## Verification and reproduction

Stable pins unchanged: Lean 4.35.0 and mathlib
56a005855ea17e0b0958f73ec801ae140b0a1679, with the existing manifest. Inspected
mathlib's `Data/Matrix/Block.lean`, `Data/Matrix/Mul.lean`,
`RingTheory/RootsOfUnity/PrimitiveRoots.lean` and Apache-2.0 licence. Reused its
block-matrix multiplication and reindexing lemmas, finite sums and primitive roots.

    lake build
    lake env lean verification/BoundaryRelationAudit.lean
    python3 -m unittest discover -s tests -p test_terminal_boundary_relation.py -v

The default build passes. The dedicated audit prints types and axiom closures
for all 20 new theorems; only propext, Classical.choice and Quot.sound occur.
Its semantic controls include an odd-block offset mismatch, the empty relation's
arbitrary forcing/zero moments, and named r=1 data. No new sorry, axiom or
native_decide is used. The default build replays the existing deliberate
Challenge statement placeholder, outside all audited proof closures. The final
new source and audit emit no warnings. During development, finite-sum rewriting
and parity-equivalence elaboration errors were repaired before validation.

The four existing boundary tests pass, including independent affine reconstruction,
the known p=5 witness and shift/next-row/moment mutations. These support the old
computational interpretation; they are not new mathematical evidence or a new
search. Python 3.14.4, exact finite-field arithmetic, no random seed. Test inputs
are the existing six systems (p,t,m,n)=(3,2,2,2), (5,312,12,12), (5,313,12,13),
(13,1466,80,80), (41,255,12,11), (41,256,11,12), plus the recorded small controls.
No Python implementation or dependency changed; large certificate rebuilds and
whole-repository test repetition were unnecessary after yesterday's upgrade.

Exact commands, final runtimes, hashes and validation are in
[the validation record](2026-10-20-boundary-validation.json), with build/audit/test
logs alongside it. The catalogue records the immutable verified proof commit;
archive and Palomar coverage are unchanged. These are Lean kernel proofs, not a
new independent-kernel comparison run.

## Primary literature and next decision

Accessed 20 October 2026 (Sydney):

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/html/2606.00633v1),
  still v1, 30 May 2026: functional equation and Proposition 2.3. Their theorem
  already settles the odd-characteristic main conjecture; today's work concerns
  the auxiliary stream's successor sharpness problem.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078),
  22 August 2026: its characteristic-two conclusion remains conditional on a
  counterexample. Scoped arXiv searches for Littlewood in characteristic two/2
  found no later relevant resolution; this is not a proof of absence.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  and [Garrett–Robertson, arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5)
  retain the quadratic-series and known unbounded-window screens. Rational
  series are excluded by a denominator multiplier. The three retired binary
  streams stay retired; none was expanded or formalised here.

Next substantive attempt: derive a closed tuple of adjacent-offset/nearly-square
relations under **correlated** binary transitions and test its implications on
the existing p=5 event. Freely combining separately reachable siblings is invalid.
This formal algebraic step is complete; repeating it or exporting more witnesses
would not answer that question. Choose the next formal lemma from new structural
evidence rather than extending routine bridge work.
