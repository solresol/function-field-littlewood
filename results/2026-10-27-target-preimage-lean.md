# Coupled terminal target preimages in Lean

27 October 2026, Tuesday, Australia/Sydney (AEDT). The scheduled instant,
26 October 21:20 UTC, is 27 October 08:20 AEDT.
Classification: **verification/infrastructure progress** on the
[26 October ordinary criterion](2026-10-26-terminal-target-preimage.md).
No new mathematical sharpness result, prime decision, uniform accepting word,
characteristic-two construction or novelty claim is made.

## Question and decision

Stated before coding: can the zero-forcing root target be reduced in Lean to
two coupled child tests whose only free moments lie outside the image of
squaring, and can the generic affine compatibility obstruction be checked?
The unresolved substantive step is the compatibility class under a shared
prefix digit on actual adjacent-shift states, towards uniform terminal existence.
A proved reduction supplies a checked criterion for that argument; a failed
normalization or endpoint identity would require revising Monday's criterion.

Read the [24 October weekly human-research review](2026-10-24-literature-review.md)
before choosing work. Its exact hypothesis comparisons leave uniform attainment
and finite-field characteristic two unresolved in the project. No new binary
candidate was selected; the rational/quadratic and unbounded-window screens
remain in force. No broad daily search or retired-stream experiment was run.

## Checked result and exact scope

[TargetPreimage.lean](../FunctionFieldLittlewood/TargetPreimage.lean) builds on the
existing BoundaryRelation and CorrelatedState definitions, with the **raw**
named stream a rather than the Python normalized stream c=a/H. Let

    e(q) = 1 if z(q)=1, and 0 otherwise,
    alpha(q) = e(q)/2,
    Primitive(x) means x(sigma(q))=0 for every q.

The transpose transport is proved pointwise, so the parent output equation is

    v0(sigma(q)) + z(q)*v1(sigma(q)) = e(q).

`output_iff` proves that equation is equivalent to
`Primitive(v0-alpha)` and `Primitive(v1-alpha)`. It derives the two-root argument
from injective nonzero root coordinates, negation closure, squaring compatibility
and 2 nonzero. It assumes neither a fibre formula nor any terminal event.
The generic conclusion also covers the two-root r=1 comparison.

`mergeEven_target_iff` and `mergeOdd_target_iff` substitute
`vb=alpha+xb` into the existing exact merge. The same x0,x1 occur in both child
conditions. The even orientation has equal forcing exponents; the odd orientation
retains s and s+1 and the original moment swap. The forcing is written in the
raw form `-diag(w*z^s)*(alpha+x)`. Removing alpha from this forcing, or rescaling
to Python's normalized coordinates, is not silently asserted as a Lean theorem.

`tupleStep_target_iff` and `actual_target_iff` prove all four digit branches,
including zero sizes and unequal rectangular child blocks. In particular,

    R_(2q+epsilon+1)(2k+eta,2k+eta)(0,e)
      iff reducedTarget(q,T(q,k),epsilon,eta).

The half-length functions retain every endpoint from the existing tuple merge.
No four-square reconstruction, rank hypothesis or independent choice of siblings
is needed. `stream_target_iff` supplies a complete injective root list and its
squaring map, discharges negation closure/nonvanishing from that list, proves
2 nonzero from the dyadic divisibility assumption, and uses the previously proved
infinite named-stream recurrences. It requires only prime p and
`2^(r+1) | p-1`; maximality of the valuation is unnecessary. Lean r=0 includes
the usual valuation-r=1 case. This is a target-membership theorem, not a theorem
that the target is reached or gives a sharp Littlewood product.

The separate generic affine lemmas prove

    exists x: x-a0 in L0 and x-a1 in L1
      iff a1-a0 in L0+L1
      iff [a1-a0] = 0 in V/(L0+L1).

The class is unchanged by moving either representative within its direction
space. Uniqueness explicitly assumes `L0 intersection L1 = {0}`.
The actual reduced child predicates have **not** yet been packaged as affine
subspaces in Lean, and their direction intersection is not proved trivial here.
No free-coordinate cardinality/dimension theorem is claimed. These boundaries
prevent the generic quotient theorem from being mistaken for a formal proof of
the ordinary no-invisible-vector input.

**Still outside this increment:** Proposition 2.3, no-invisible-vector/dimension
results, the four-square theorem, exact even-shift stripping, the boundary-target
to endpoint-admissible exact-certificate bridge, and uniform accepting words.
The completed TerminalLift theorem still needs an exact terminal certificate.
The existing Challenge.lean:37 placeholder and its assumed consequences are not
used; every new proof closure is audited independently of that module.

## Verification and environment

The clean generated work branch was at db7961726245ce4b6832fbdf3a9b34ce8e040d6b.
Verified origin `https://github.com/solresol/function-field-littlewood.git`, fetched
main, checked HEAD ancestry/equality, preserved work, created tracking main and
completed a fast-forward-only check. No applicable AGENTS.md or saved .agents
skill was present. Read the saved `/workspace/shared/theorem-provers/START.md`,
cloud-bootstrap recovery instructions, current README/TODO/log, recent ordinary
reports, actual root/merge/tuple/oracle sources and the Apache-2.0 reuse context.
The parent reported no overlapping Littlewood child. No other machine was used.

First sourced the prepared env.sh and ran check.py successfully. Exact toolchain,
configuration hashes, dependency revisions/cleanliness, readiness receipts and
representative imports passed. No install, download, cache warm, pin change,
new runtime, borrowed repository runtime, credential, schedule, author contact,
external environment publication or large-certificate run occurred.

Lean 4.35.0 and mathlib 56a005855ea17e0b0958f73ec801ae140b0a1679 are unchanged.
Reused the actual transport/merge/tuple proofs and mathlib's square-root identity,
submodule sum and quotient membership lemmas. The existing guarded runner was
loaded only for `m.run` and `env_for(littlewood)`; setup functions were not called.
All retained commands had two Lean threads, a 2 GiB disk reserve, a 12 GiB
process-group RSS limit and a 1,800-second timeout. Commands ran sequentially:

    lake build
    lake env lean verification/TargetPreimageAudit.lean
    python3 -m unittest discover -s tests -p test_terminal_target_preimage.py -v
    python3 -m search.terminal_target_preimage

The default build passed in 5.039 seconds. The 12-declaration audit passed in
4.039 seconds; every closure uses only propext, Classical.choice and Quot.sound
(some use fewer). The new source/audit has no warnings, sorry, added axiom or
native_decide. The default build reports only the pre-existing Challenge
placeholder. Audit controls check all four endpoint branches, r=1 free primitive
moments, rejection of a changed forced square moment, empty blocks, disagreeing
singleton slices, representative invariance and the r=1 stream specialization.

Three focused Python tests passed (2.049 seconds command time; 0.953 test time).
The unchanged prescribed check passed in 7.052 seconds command time. Its 800
comparisons use p=3,5,13,41,17; q in {0,1,2,3,7,8,15,31}; k=0,...,4; and all
four digits, with independent original-root-sum matrices and affine readback.
It retains the known accepting/rejecting paths and the one-parity/norm failure.
The p=41 large witness remains a recurrence-based regression here, not a new
independent giant-certificate or Lean verification. No search box was expanded.
For direct target shift M and size n>0 the inclusive final coefficient is
M+2n-1; empty blocks read none. The theorem uses the infinite stream without
truncation. Python 3.12.14, standard library, deterministic, no random seed.

Development checks exposed classical decidability, linear-combination sign,
finite-field cast/simplification and concrete inverse-normalization elaboration
issues. An audit attempted before a failed development build also reported its
missing object file. These were corrected before retained validation; no target
hypothesis was weakened, assumed or replaced by finite agreement. Full source
and documentation diffs were inspected. Commands, runtimes, hashes, exact types
and axiom lists are in [the validation record](2026-10-27-target-preimage-validation.json)
and companion logs. No independent-kernel replay is claimed.

## Source dependency and next decision

Targeted primary reading on **27 October 2026 Australia/Sydney** reused
[Lai–Sprang arXiv:2606.00633v1](https://arxiv.org/html/2606.00633v1), dated
30 May 2026: Theorem 1.2 gives an odd-characteristic lower bound for every
irreducible P over every field of that characteristic; Proposition 2.3 excludes
an overlong zero window for nonzero multiples of t^N-1. Neither provides an
accepting terminal witness. These are ordinary preprint results, not proved here
in full. The new module does not assume Proposition 2.3. Other source/version
and access limitations remain those of the 24 October weekly handoff; no new
latest-version/absence/priority survey is claimed.

The substantive next question remains how the compatibility class transforms
under a shared prefix digit on the same actual adjacent-shift states. Use the
existing p=5/p=13 accepting and rejecting paths to seek a useful invariant or a
collision refuting one. Further generic packaging, cardinality bookkeeping,
terminal-lift repetition, routine certificates or larger witness boxes should
not displace that question. This run completes one bounded formal increment;
it provides no new mathematical decision on either main research target.
