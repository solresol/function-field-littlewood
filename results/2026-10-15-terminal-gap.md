# Formal low-degree terminal exclusion and stronger cutoff

15 October 2026, Thursday, Australia/Sydney (AEDT).
Classification: **verification/infrastructure progress on existing mathematics**.

## Question, decision and result

Before coding, the question was whether the 14 October original-row gap proof
could give Lean terminal nonvanishing for S=FV, F=1+t+...+t^(N-1),
nonzero V and deg V<N/2, at every shift. This closes the terminal base needed
to strengthen the formal degree cutoff; a conditional gap lemma without its
actual-stream support proof would not suffice. We chose this direct route
instead of separately formalising the 9 October norm/order argument.

The complete result is now proved in `FunctionFieldLittlewood/TerminalGap.lean`:

- For **every odd prime p**, every N=2^(r+2), every nonzero V of degree e<N/2
  and every M>=0, some original row B_(FV)(M+k), 1<=k<=N+e, is nonzero.
  This terminal theorem does not need N dividing p-1.
- With the Lai–Sprang relation p-1=N(2k+1), every nonzero degree-d multiplier
  at every shift has a nonzero row among 1,...,d+N whenever
  **d<N(N+N/2-1)**. The resulting first nonzero index satisfies j-d<=N.
  Lean's new parameter r is the usual valuation minus two, unlike
  DescentStep's valuation-minus-one convention.

For N=4,8,16 the formal strict cutoffs are 20,88,368. These are the existing
9 October ordinary cutoffs, not the stronger 12 October certified boundary
cutoffs 24,96,384. The all-degree bound, exact boundary shift localization,
terminal equivalence/dichotomy and characteristic-two construction remain
outside today's formal theorem. No mathematical novelty claim is made.

## Proof path and row semantics

1. `support_rep` derives n=2^k(1+Nh) from an actually nonzero coefficient
   of the existing infinite support stream. Modular arithmetic then proves
   all coefficients in qN+N/2<n<(q+1)N vanish.
2. For b_n=a_(n+N)-a_n, offsets one and two in each open block are nonzero
   over any odd prime. The proof uses the explicit odd progression, the
   dyadic recurrence and invertibility of 2; it does not assume the pivot.
3. `block_pivot` takes the last nonzero entry in the first half of the block
   containing M+e. It constructs an available t with
   M+e<t<M+N+e and a length-e zero gap on one side. It uses the known upper
   half gap and the nonzero offsets one and two. It does not formalise the
   finer capped-valuation formula for that last entry.
4. `gap_obstruction` isolates the trailing coefficient of V for a following
   gap or the leading coefficient for a preceding gap. Either yields a
   nonzero difference row. This avoids a determinant calculation, while
   retaining arbitrary constant coefficients and all shifts including zero.
5. `terminal_difference` proves the telescoping identity directly from
   F(X)(X-1)=X^N-1 and the existing polynomial filter composition theorem.
   The difference row has 1<=k<N+e, so both original rows k and k+1 lie
   in 1,...,N+e. No unavailable row, truncated tail or finite fixture is used.
   The inclusive original coefficient endpoint is M+2N+2e-1.
6. `terminal_degree_bound` converts factor divisibility and an actual
   terminal zero window into deg S>=N+N/2-1. `iterated_degree_bound`
   reuses the complete 13 October descent with this proved terminal base.
   `stream_nonvanishing_below_cutoff` is the final named-stream result.

The r=1 valuation comparison remains in the existing imported proof library;
the new terminal theorem requires N>=4 and does not purport to exclude it.
The N=4 modulo-3 boundary failure is consistent with e<N/2 here.

## Verification and reproduction

From the repository root:

```sh
lake build
lake env lean verification/TerminalGapAudit.lean
```

The pinned Lean 4.35.0-rc2/mathlib
065356127b1dc0016f66b7283ce0ce2c4055aa55 full build passed in 7.796s.
The separate ten-declaration type/axiom audit passed in 7.146s. Only propext,
Classical.choice and Quot.sound occur. There is no new sorry, axiom,
native_decide, dependency change or assumed terminal target. The existing
Challenge statement placeholder is still isolated outside these proof closures.
No independent-kernel replay is claimed for this increment.

Relevant existing source was inspected before reuse: named support stream,
root identity, polynomial filters, factor degree and complete descent. The
mathlib trailing-degree and finite-set maximum source and Apache-2.0 licence
were inspected. Development compile errors involved tactic arithmetic,
rewriting and API names; all were repaired before the successful final build.
No finite-field search, random inputs or Python algorithm changed, so no
new experiment or repeated Python suite is reported. Build/audit output and
runtime metadata are retained in the dated text and JSON files.

## Primary-source boundary

Accessed 15 October 2026, Australia/Sydney:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1)
  remains the listed version (submitted 30 May 2026). Its theorem settles
  odd-characteristic main-conjecture counterexample existence; this work is
  auxiliary formalisation for its explicit stream.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1)
  remains the listed version (22 August 2026), with the characteristic-two
  conclusion conditional on counterexample existence. A scoped arXiv search
  found no later relevant resolution; this is not an absence or novelty proof.
- [Adiceam–Nesharim–Lunnon v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  retains the quadratic-series exclusion and binary paperfolding application;
  its Thue–Morse discussion states unbounded deficiency.
  [Garrett–Robertson v2, Section 5](https://arxiv.org/html/2405.14454v2#S5)
  retains the unbounded-window discussion. Rational series are excluded by
  clearing denominators. No new binary candidate or retired-stream search.

## Next decision

Friday's substantive question remains symbolic multi-pivot elimination on
the exceptional odd-shift strips at e=N/2. Today's proof closes the planned
formal low-degree target; do not also formalise the alternative norm route.
A subsequent formal step can identify the exact last supported difference
and formalise the 14 October shift localization if it supports the boundary
argument. Larger covers and routine certificate exports are not substitutes.
