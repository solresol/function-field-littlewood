# Even-shift short windows in Lean

5 November 2026, Thursday, Australia/Sydney (AEDT), executed 4 November UTC.

Classification: **verification/infrastructure progress** on the 4 November
ordinary simultaneous-corner argument. This verifies its essential wider-stack
injectivity premise. It does not prove the conic transport itself in Lean,
uniform acceptance, a new prime decision or a characteristic-two result.

Verified proof snapshot:
[`8c0d60fd0037b160121ebd5e07581d11df4914f0`](https://github.com/solresol/function-field-littlewood/commit/8c0d60fd0037b160121ebd5e07581d11df4914f0).

## Question and decision

Read the actual stream, parent-window, descent, boundary and terminal-detection
sources, current roadmap, recent reports and the latest
[30 October weekly literature handoff](2026-10-30-literature-review.md).
Thursday favours Lean. The question stated before coding was whether the
short-window argument can prove that an `X^N-1` multiple of degree at most
`2q+1`, with `2q` zero rows at an even shift, must be zero. Its equal parity
budgets are the extra input needed for the two-column-wider parent in the
rank-four simultaneous response; the old nearly-square theorem does not apply.

Success verifies that specific prerequisite of the ordinary conic theorem.
Failure would reopen the claimed rank-four response. The unresolved substantive
step is still an acceptance invariant along **jointly realized** paths, not
selection of freely adjustable abstract lines. This bounded formal increment
does not substitute a new generic bridge or witness search for that question.

## Checked statement and argument

`EvenShortWindow.stream_even_short_window` uses the actual infinite **raw**
named stream, prime p>2 and

    p-1 = 2 * 2^r * (2k+1),    N = 2 * 2^r.

Thus N is the full two-primary part; Lean r=0 includes the usual valuation-r=1
comparison. For every polynomial R, including zero, and all n,q>=0, it proves

    X^N-1 divides R,    deg R <= 2q+1,
    filt R stream (2n+j)=0 for 1<=j<=2q
          implies R=0.

If a nonzero R has degree at most 2q, the existing proved coefficient-row
Proposition 2.3 contradicts the window immediately. Otherwise its degree is
exactly 2q+1. Write

    R=E(X^2)+X O(X^2),
    E=(X^H-1)U0, O=(X^H-1)U1, H=N/2.

The **actual** 2q parent rows at shift 2n give q rows of each parity. Derived
quotient-degree bounds give `H+deg Ui<=q` for each nonzero quotient. These
budgets supply all H cross moments using the existing `windows_moments` theorem
with delta=0 and A=B=q. Distinct root moments and prime-field nonsquareness
then force `X^H+1` into both quotients. The primitive-root contribution of E
vanishes. The leading odd child O is nonzero of exact degree q, is divisible
by `X^N-1`, and has q zero rows at shift n. The already proved Proposition 2.3
contradicts this. No square inverse, terminal acceptance, desired rank or
short-window statement is assumed.

`EvenShortWindow.stream_even_no_invisible` reconstructs a polynomial from an
arbitrary vector x with 2q+2 coefficients. Evaluation at an injective list of
N N-th roots forces `X^N-1` divisibility; the actual Hankel rows give the
window. The first theorem makes the polynomial zero, hence x=0. In symbols,

    [ A_(2n+1)(2q,2q+2) ; U_(2q+2)^T ] x=0  implies x=0.

This covers empty and singular blocks. For the 4 November conic parent, put
`n=old_q+1`, giving start `2*old_q+3`, or fractional shift `2*old_q+2`.
This parity is essential to the proof. No arbitrary-shift theorem is asserted.
The ordinary reports divide coefficients by H; the Lean statement keeps the
existing raw convention. No new coordinate identification with that normalized
presentation or end-to-end rational Laurent sum is claimed.

The downstream ordinary theorem identifies the quotient response with
`V direct-sum V` and the same input line in both children with its conic of
two-planes. That theorem still needs dimension and quotient-map formalisation.
More importantly, its abstract completions are not freely reachable states.
It supplies no accepting path by itself.

## Verification and limits

The [validation record](2026-11-05-short-window-validation.json) retains exact
commands, timings, source/pin hashes and resource limits. The default build,
two-declaration type/axiom audit and the unchanged simultaneous-corner regression
module pass. Only `propext`, `Classical.choice` and `Quot.sound` occur in all
five named audited closures. No new `sorry`, `admit`, project-defined axiom or
native decision procedure occurs. Challenge.lean:37 remains outside those
closures. No independent-kernel replay is claimed.

The Lean audit covers an empty p=3,q=0 stack, a singular actual 4-by-4
Hankel block at p=3,t=3 with its injective 4-by-6/evaluation stack, and the
existing p=5 simultaneous parent at t=127 with 16 rows and 18 columns.
A negative control kernel-checks the nonzero polynomial

    (X^2-1)(X^2+X+1) over F_3,

which has degree 4 and its first two rows zero at shift zero. Enlarging the
degree bound by one therefore fails already on the actual stream. This is a
boundary control, not a sharpness witness or a conjecture-level advance.

During audit development two diagnostic compilations failed while correcting
an incorrectly chosen singular test, a missing executable-stream import and
polynomial normalization. The proof module and initial default build already
passed; no failed audit or its temporary error axioms is accepted. The final
audit is warning-free. Diagnostic timings were not retained. The exact-rank
check used only (p,t,q)=(3,1,2),(3,3,2),(3,1,3),(5,127,8), on 2q-square blocks,
with ranks 4,2,6,16 respectively; it selected the singular regression, not a
new search range. The retained Python module independently checks the existing
fixed-pair certificate and prescribed empty/r=1/separate-field conic contexts;
its finite checks are support for the ordinary theorem, not its proof.

Primary source accessed **4 November UTC / 5 November Sydney 2026**:
[Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/html/2606.00633v1),
30 May 2026, still the sole version displayed at the
[abstract record](https://arxiv.org/abs/2606.00633).
Rechecked Theorem 1.2, Proposition 2.3 and Section 3, especially the parity
budgets and prime-field nonsquare step. The source proves a lower bound for
every irreducible P over every odd-characteristic field; it does not assert
uniform attainment. The shorter even-shift window is the internal deduction
recorded on 4 November, now verified for the named coefficient stream.
No firstness or priority claim is made. The weekly handoff was accessed five
Sydney dates earlier; no broad daily review was repeated. Its AMS/Elsevier
access gaps remain.
No characteristic-two candidate was proposed.

Read saved START.md and bootstrap recovery guidance; no executor-catalogued
Start skill, applicable AGENTS.md or .agents skill was present. Sourced the
prepared env.sh and passed check.py before work and again after refresh.
Expected origin and clean generated work at ad0ab829 were verified; fetched
live main matched, HEAD ancestry passed, work was preserved and tracking main
created and safely fast-forwarded. No overlapping research process was found.
Prepared exact toolchain, caches, pins and guarded runner were reused without
installation, download or environment rebuild. Other checkouts, shared settings,
credentials, network policy and schedules remain unchanged. No user machine
was accessed; the controller owns subsequent Raksasa reconciliation.

**Next useful step:** combine the single-response projective law and simultaneous
conic on jointly realized transitions to derive a condition forcing odd-shift
terminal acceptance, or a concrete obstruction. Do not spend the next run
repeating this prerequisite, routine formal packaging or attainment examples.
Uniform `Delta_p=2N` and the finite-field characteristic-two frontier remain open.
