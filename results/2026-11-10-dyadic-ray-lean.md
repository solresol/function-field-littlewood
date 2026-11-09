# Dyadic-ray coefficient windows and stored-state stabilization in Lean

10 November 2026, Tuesday, Australia/Sydney (AEDT). Scheduled invocation:
9 November 21:20 UTC; executed 9 November UTC / 10 November Sydney.

**Classification: verification/infrastructure progress.** This formalises the
coefficient-window and stabilization part of the [8 November ordinary
argument](2026-11-08-dyadic-corner-family.md). It supplies a concrete verified
input reduction for the proposed prime-dependent transport recurrence. It does
not derive that recurrence, a compatible accepting continuation, uniform
Delta_p=2N, a new prime decision or a characteristic-two construction.

Verified proof snapshot:
[`1c937cfae402cc5e8fbfd4dac3e4b79600dac4f4`](https://github.com/solresol/function-field-littlewood/commit/1c937cfae402cc5e8fbfd4dac3e4b79600dac4f4).

## Question and downstream obligation

Read the current sources, roadmap, research log, 8–9 November results and
[6 November weekly human-literature checkpoint](2026-11-06-literature-review.md)
before choosing work. Tuesday favours Lean. The exact question stated before
coding was whether the actual infinite named stream has the claimed stable
interior and single endpoint sign change uniformly in the prime. Success
allows a later prime-dependent transport proof to use two actual input states
rather than an unbounded exponent family. Failure would reopen the ordinary
ray argument. No new suffix enumeration, larger box or isolated witness was
proposed or run.

The 9 November result already excludes reusing its fixed five-digit selector
uniformly at N=4. Today does not retry that selector. The next substantive
obligation remains a different or prime-dependent continuation whose full
simultaneous target compatibility can be proved on one of the actual inputs.
Necessary divisibility of an obstruction pairing alone will not suffice.

## Precise formal statement

The new module is `FunctionFieldLittlewood/DyadicRay.lean`, imported by the
default root module. Its parameter convention is

    r >= 0, H=2^r, N=2^(r+1), k=2^s, a0=s+r+2.

Thus Lean r=0 includes the usual valuation-R=1 comparison. For the actual raw
stream `laiSprangStream p (r+1)`, without dividing by H, the kernel proves:

- Positive rows `n<2^s` satisfy `a_(2^a+n)=a_n` whenever `a>=s+r+1`.
- At `B=2^(a0+d)`, the endpoint `a_(B+2k)` is `H*(-1)^(2^d)`:
  it is -H at d=0, then H for every d>=1.
- The prefix from `B-1` through `B+2k-1`, inclusive, is constant from a0.
  The full window through `B+2k`, inclusive, is constant from a0+1.
- Every relation indexed by `(delta,i,j)` with at least one index zero
  is constant from a0. Only `(1,1,1)` can read the changing endpoint.
- All eight relations, the stored phase modulo N and the capped size agree
  at every `a>=a0+1`. The whole ray `T(2^a-2,k)`, a>=a0, therefore has
  **at most two** stored states. Every common paired-digit word acts equally
  on its stable tail, including a word selected as a function of p.

The coefficient and state equalities hold for every natural modulus p and
arbitrary fixed finite evaluation coordinates; they need neither primality
nor maximal valuation. Interpreting them as the project's odd-prime problem
uses the existing complete root data and full two-primary N. The continuation
equality uses arbitrary common weights/map; actual stream interpretation
reuses `CorrelatedState.step_actual` and `fold_actual` with their recurrence
hypotheses. It is not a new realizability assumption or acceptance theorem.

At the canonical size k=2N, put s=r+2. Then a0=2r+4, equivalently 2R+2
for usual R=r+1. The p=5 specialization says every a>=6 gives either the
actual T(62,8) or actual T(126,8), with the latter constant for a>=7.

**Limits:** this module does not prove that the first and later corner
relations are distinct, their dimension or full algebraic pencil. Those remain
ordinary parts of the 8 November argument. An endpoint coefficient change does
not by itself prove relation distinctness. No Hankel inverse, rank assumption,
terminal target or version of the desired sharpness theorem is a premise.
Identities also valid modulo 2 do not constitute a characteristic-two result.

## Proof mechanism

The existing odd-row formula has period `2^(r+1)` in its half-index: adding
that amount preserves both its support residue and alternating sign. Induction
on the dyadic window width handles positive even rows by dividing the index
and center by two; odd rows use that period directly. A separate periodicity
argument handles the predecessor B-1. Dyadic invariance reduces B+2k to one
odd row, giving the exact endpoint exponent `2^d`.

Each actual Hankel entry lies in the stated inclusive window. In the seven
selected relations its maximum index is one smaller. Equal blocks and unchanged
evaluation matrices give equal full forcing/moment predicates directly, even
when blocks are singular. Natural-number modular subtraction proves phase
equality; size is unchanged. Equality of stored states then transports through
any common fold. All arguments concern the infinite named stream.

## Evidence and reproduction

The [type/axiom audit](2026-11-10-dyadic-ray-audit.txt) records all 15 declarations:
`odd_period`, `interior`, `center`, `endpoint`, `endpoint_first`,
`endpoint_stable`, `predecessor_step`, `predecessor`, `prefix_window`,
`stable_window`, `tuple_stable`, `seven_relations`, `actual_stable`,
`ray_two_states`, and `continuation_stable`, all in namespace
`FunctionFieldLittlewood.DyadicRay`. Four additional kernel controls cover
the smallest size k=1 at p=3 for all stable exponents, the entire canonical
p=5 ray, and the two endpoint changes at p=3 and p=5. The negative controls
exclude an incorrect extension of the constant prefix by one coefficient.

Every audited closure uses only `propext`, `Classical.choice`, and `Quot.sound`.
No `sorry`, admitted axiom or `native_decide` occurs in the new proof or audit.
The [default build](2026-11-10-dyadic-ray-build.txt) passed. Its existing
`Challenge.lean:37` placeholder warning is retained and excluded from all
these closures; downstream assumed claims supply no premise.

The unchanged [dyadic-family regressions](2026-11-10-dyadic-ray-regressions.txt)
passed: original root sums independently check windows and actual relations
at prescribed p=3,5,13,41 inputs, through original index 1056 inclusive.
These are finite controls, not the proof of the universal statements or an
attainment search. No random seed or new search range was used. No Python
algorithm changed, and no full Python-suite rerun is claimed.

The [validation record](2026-11-10-dyadic-ray-validation.json) retains commands,
hashes, resource bounds, available runtimes and development diagnostics.
The guarded audit took 2.001 seconds; the regression command took 1.001 seconds
(0.434 seconds inside unittest). The build reports 1.9 seconds for the new
module and 1.4 seconds for the root; a separate whole-build duration was not
retained. Diagnostic proof failures were corrected before the accepted build.

In this prepared environment, after the mandatory saved startup gate, use
`prepare.env_for('littlewood')`, its `m.installed_tools` absolute binaries,
and `m.run` to execute `lake build`, `lake env lean verification/DyadicRayAudit.lean`,
and `python3 -m unittest discover -s tests -p test_dyadic_corner_family.py -v`.
The Lean commands use the absolute installed Lake/Lean paths, with two threads,
a 2 GiB disk reserve and 12 GiB process-group RSS guard. The retained build
used a 900-second timeout; other commands used 300 seconds. No setup function,
cache download, package installation or pin change was performed.

## Sources, startup and next step

Targeted source verification on **9 November UTC / 10 November Sydney**:
[Lai–Sprang arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
30 May 2026, still the sole listed version; read the
[construction, functional equation and Theorem 1.2](https://arxiv.org/html/2606.00633v1).
Their odd-characteristic theorem provides a lower bound, not uniform attainment
for this stream. The new code is an internal formalisation of the repository's
ordinary deduction. Reused existing Apache-2.0 project and mathlib definitions;
no external implementation was copied. No novelty or priority claim is made.
The weekly review's bounded coverage and journal-access gaps remain; no broad
daily literature search or retired binary-candidate revival occurred.

The complete prepared gate passed for thesis, Littlewood and Scholz. The saved
`/workspace/shared/theorem-provers/START.md` was available and read this run,
unlike the preceding worker's report. The actual attached executor was ready;
no equality between different platform configuration-ID namespaces is asserted.
Expected origin and clean generated work at dab78a6 matched fetched main.
Verified ancestry, preserved work, created tracking main and fast-forwarded only.
No competing local research writer or Git index lock was found; the coordinator
handled account-level overlap. Prepared pins and exact clean dependency HEADs
were rechecked after the proof. Shared runtime, sibling checkouts, credentials,
security, environment settings and schedules were unchanged. Raksasa was not
accessed; the coordinator owns that separate authorized synchronization.
Remote CI was not checked.

**Next:** derive a controlled transport-block recurrence on the actual two
inputs, then prove its full target compatibility at a predictable p-dependent
length, or redirect to a different reachable family. Do not repeat this
stabilization, replay the excluded word, enumerate fixed-pair suffixes, or use
additional formal packaging as a substitute for that mathematical step.
