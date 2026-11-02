# Bordered reconstruction in Lean

3 November 2026, Tuesday, Australia/Sydney (AEDT). Scheduled instant:
2 November 21:20 UTC = 3 November 08:20 AEDT. Executed 2 November UTC.

Classification: **verification/infrastructure progress on current auxiliary
sharpness structure**. This formalises the 25 October ordinary reconstruction
needed by the 2 November projective transport argument. It is not a new
sharpness decision, uniform accepting path, characteristic-two result or
publication-priority claim.

## Question and decision, before formalisation

Read the latest [30 October weekly literature review](2026-10-30-literature-review.md),
current roadmap and the [2 November transport proof](2026-11-02-odd-corner-transport.md).
The chosen question was whether the exact adjacent-square identities, including
distinctness, can be derived in Lean from the **proved actual** stacked
Hankel/evaluation injectivity, without an invertible Hankel or assumed dimension.
That was an essential unformalised prerequisite of the quotient-line transport,
not an attempt to revive a retired compression or attainment family.

Success supplies checked borders for the transport proof and a precise
four-square determination theorem. Failure would identify the missing
injectivity/duality step before more projective formalisation. Uniform terminal
existence is the unresolved substantive invariant throughout; a successful
reconstruction cannot decide it.

**Outcome:** all three identities and the four-square determination corollary
are kernel-checked for the actual infinite stream. A constructive border
correction avoids a separate dimension proof and the symplectic-orthogonal
argument in the ordinary 25 October proof. This is a proof reorganisation of
existing mathematics, not a new conjecture-level result.

## Exact statements and proof

`BorderedRelation.space a z t m n` is the submodule of pairs `(u,v)` satisfying
the existing `CorrelatedState.relation`: some coefficient vector x obeys

    A_t(m,n) x = U_m u,       U_n^T x = v.

Its carrier equality is definitional and audited by `mem_space`. It uses the
existing **raw coefficient** convention of the Lean foundations. The ordinary
reports use coefficients divided by H; that rescales forcing coordinates.
No normalized-coordinate or rational Laurent-series identification is newly
claimed here.

For a general field, finite root-coordinate set and arbitrary Hankel stream,
`NoInvisible a z t k` explicitly says the stacked map of the k-by-(k+1)
wide block and its root evaluations has zero kernel. Under that hypothesis:

    S = R_t(k,k),       B = R_t(k+1,k+1),
    W = R_t(k,k+1),     L = R_t(k+1,k)

satisfy

    S != B,            W = S + B,            L = S intersect B.

`wide_preimage_unique` first proves uniqueness of coefficient preimages of
each wide boundary pair. For `border_defect_exists`, suppose every small
solution `Ax=Uu` satisfies the last bordered equation `b.x=w.u`. Then that
last functional annihilates the kernel of `[A,-U]`. Mathlib's proved
`LinearMap.range_dualMap_eq_dualAnnihilator_ker` provides a row functional
lambda with `A lambda=b` and `U^T lambda=w` (using Hankel symmetry).
The vector `(-lambda,1)` is invisible in the wide stacked map, a contradiction.
This includes k=0 with the usual empty sums.

To prove the sum identity, choose a small solution with nonzero defect D.
Given any wide solution with final-row defect delta, subtract delta/D times
that small solution. The result satisfies the final row and belongs to B;
the subtracted vector belongs to S. The reverse inclusion is by padding or
deleting the last equation. No dimension/rank formula is assumed.

For the intersection identity, the coefficient preimages of a shared pair
in S and B must agree in W after zero-padding the smaller vector. Its last
coefficient therefore vanishes, giving the tall relation. Conversely pad a
tall solution or delete its last row. The nonzero-defect small solution cannot
belong to B by the same unique-preimage argument, proving distinctness.

`stream_noInvisible` discharges the generic premise using
`TerminalDetection.stream_no_invisible`, whose coefficient-row Proposition 2.3
is already proved by descent. `stream_bordered_reconstruction` assumes only:

- prime p>2 and `p-1 = 2*2^r*(2*l+1)`, so `N=2^(r+1)` is the full two-primary
  part; Lean r=0 is the usual valuation-r=1 case;
- an injective list `z : Fin N -> ZMod p` with every z_i^N=1;
- arbitrary nonnegative m,k, with actual matrix start t=m+1.

Neither stacked injectivity, a terminal certificate, desired acceptance,
relation dimensions nor square invertibility is an assumption of the actual
stream theorem. Its hypotheses match the existing full-root construction.

`stream_tuple_eq_of_squares` then proves that equality of the four actual
squares at shifts q+1,q+2 and sizes k,k+1 determines equality of **all eight**
existing correlated predicates. The compared actual pairs may have different
shifts and sizes. This combines only jointly realized tuples. It enables
reusing checked border identities in the projective transport proof and the
existing exact correlated recurrence; it does not build a new compressed
automaton or show terminal acceptance.

## Checks, provenance and limits

Retained commands, timings, exact pins, source hashes, guards and audit results
are in [the validation record](2026-11-03-bordered-validation.json).
The default `lake build`, nine-declaration type/axiom audit, four named Lean
regression audits and three unchanged focused Python tests pass. The audit
also includes the F_5 specialization as an anonymous example.

Lean regressions cover the empty k=0 boundary at p=3, the singular actual
size-two Hankel `[[1,2],[2,1]]` at t=2 over F_3, and the separate p=5/r=1
case at t=63,k=8. A zero-stream negative control proves that X^2-1 is
invisible and adjacent size-two/size-three squares agree. Thus dropping
the special-stream/stacked-injectivity premise really makes distinctness false.
These are exact kernel computations and general proofs, not random testing.
The existing Python controls retain five prescribed contexts, the fixed
correlation obstruction and zero-stream failure; no witness range was expanded.

The nine headline declarations and four named regressions use only `propext`,
`Classical.choice`, `Quot.sound`. New source, audit and root module pass the
prohibited-token scan. The existing `Challenge.lean:37` statement placeholder
remains outside their proof closures. Initial development elaborations failed
on local proof syntax and audit imports/module visibility; corrected before the
retained final checks. Failed elaborations were never accepted as proofs.
No independent-kernel replay or large-certificate rebuild is claimed.

Primary verification accessed **2 November UTC / 3 November 2026 Sydney**:
[Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/html/2606.00633v1),
30 May 2026, Theorem 1.2, functional equation (1.2) and Proposition 2.3.
The theorem covers every irreducible P over every odd-characteristic ground
field and supplies the lower bound, not uniform attainment. Proposition 2.3
excludes a nonzero X^N-1 multiple with degree-many zero fractional rows at a
nonnegative shift. Our existing Lean coefficient theorem supplies that input.
No broad daily literature search or new binary candidate was attempted.
Other source/access and frontier limits remain those of the weekly handoff;
no absence or novelty claim is made.

Reused actual source definitions and pinned mathlib duality code were inspected.
Mathlib's duality file carries its Apache-2.0 notice (Johan Commelin, Fabian
Glöckle, Kyle Miller); project code and reports retain the existing Apache-2.0
licence and Lai–Sprang attribution. No external source prose was copied.

The attached runtime's source-version binding matched the parent's verified
published configuration. The prepared env.sh/check.py passed before work and
after refresh; exact pins, dependency HEADs, readiness and imports passed.
Verified clean `work` at 0ce2a34, expected solresol origin and fetched equality,
preserved `work`, created tracking main and checked fast-forward-only current.
Read saved START.md and bootstrap recovery; no applicable AGENTS.md or .agents
skill was found. Reused prepared Lean/caches under the existing resource guards;
no setup, download, dependency, credential/network, runtime, schedule,
environment-publication, other-checkout or user-machine change occurred.

**Next useful substantive step remains unchanged:** derive the remaining large
square's simultaneous odd-digit dependence on two occurrences of the same B11
line, preserving correlations and poles. The reconstructed borders are now
available in Lean. Relation dimensions, the two-dimensional projective quotient
and the full transport isomorphism remain unformalised; further verification
should follow a substantive use of that transport rather than become another
sequence of generic bridges. Neither uniform Delta_p=2N nor characteristic two
has advanced in this run. Parent coordinates any Raksasa reconciliation and
keeps its local schedule paused.
