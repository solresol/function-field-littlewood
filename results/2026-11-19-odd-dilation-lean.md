# The odd-dilation obstruction in Lean

19 November 2026, Thursday, Australia/Sydney; executed 18 November UTC.

**Classification: verification/infrastructure progress.** The all-scale
obstruction proved ordinarily on [18 November](2026-11-18-odd-dilation-obstruction.md)
is now kernel-checked for its infinite support-formula stream over F_2,
including exact certificates and actual polynomial Littlewood products. This
verifies a failed construction screen. It supplies neither a characteristic-two
counterexample nor progress on uniform odd-characteristic `Delta_p=2N`.
No novelty or first-formalisation claim is made.

## Question selected before implementation

Read the latest [13 November human-literature checkpoint](2026-11-06-literature-review.md#13-november-2026-checkpoint),
current roadmap/log, 15–18 November results and actual coefficient, certificate,
polynomial and Laurent/product sources. The repeated-block moving covector is
still incompatible; no generic duality lemma or further length search follows.

The Thursday formal question was: does the claimed off-lattice cancellation
and on-lattice base-row reduction hold for the actual infinite odd-dilation
coefficient stream, yielding its exact first index at every scale? Success
verifies the obstruction any weighted or altered-numerator proposal must
escape. Failure would reopen yesterday's ordinary argument or its formal
coefficient/certificate identification. No new candidate or expanded finite
search was proposed. This completes that specific formal step; further
formal packaging of this retired family is not the next research task.

## Exact formal scope

[OddDilation.lean](../FunctionFieldLittlewood/OddDilation.lean) defines `stream`
at all natural indices: `c_0=0`, strip factors of ell at positive indices,
then assign 1 iff the remaining unit u satisfies

    u mod N = 1,   u mod (ell*N) != 1.

This is yesterday's coefficient formula, not a truncated prefix. The formal
result assumes **ell>2, N>1, ell divides N**; primality is unnecessary for
the support-stream theorem. In the intended family ell is an odd prime and
N=ell^r, r>=1. `power_certificate ell r a` uses N=ell^(r+1), so its Lean
parameter r=0 includes the intended r=1 case.

Writing L=ell^a and `b_h=c_(1+h)+c_(N+1+h)`, Lean proves:

- `row_off_lattice`: `c_(L+h)+c_((N+1)L+h)=0` whenever L does not divide h,
  at every index, with no cutoff.
- `row_on_lattice`: at h=L*k that sum is exactly b_k.
- `stream_window`, `base_zero`, `base_hit`: b_k=0 for
  0<k<(ell-1)N, and b_((ell-1)N)=1. The inclusive seed window retains
  both absent endpoints 1 and ell*N+1.
- `certificate`, `first`: the actual vector of `1+t^(NL)` has nonzero
  endpoints and exact first fractional index `(ell-1)NL` at shift L.
- `binomial_polynomial`, `product`: the assembled polynomial is exactly
  `1+t^(NL)`; for the actual polynomial `Q=t^L(1+t^(NL))`, the existing
  Laurent and trailing-degree bridge gives product `2^(-(ell-2)NL)`.
- `unbounded_defect`, `arbitrarily_large_certificates`,
  `arbitrarily_small_products`: defects exceed every natural bound, and
  **nonzero actual polynomials** have products below each prescribed `2^-B`.

The cancellation proof descends on a. If ell divides h, divide both
indices by ell; otherwise both are units, and their difference is a multiple
of ell*N, so their coefficients agree and cancel in F_2. No primality,
finite enumeration, assumed nonvanishing or version of the target is used.

**Formal boundary:** equality with the infinite primitive-root sum, descent
from its splitting field, transcendence and transport to every
characteristic-two extension remain ordinary parts of the 18 November report.
They are not Lean conclusions here. The support-stream theorem over F_2 is
unconditional. No theorem about a weighted or different-numerator family follows.

## Evidence

The [default build](2026-11-19-odd-dilation-build.txt) passes using the prepared
Lean 4.35.0 and mathlib `56a005855ea17e0b0958f73ec801ae140b0a1679`.
The existing `Challenge.lean:37` sorry warning is retained; that placeholder
and downstream assumed statements supply no premise to any new result.
The [audit](2026-11-19-odd-dilation-audit.txt) reports types and axiom closures
for 18 public results plus five controls. Every closure uses only `propext`,
`Classical.choice`, and `Quot.sound`. No new sorry, axiom or native_decide is used.
Controls include the whole ternary r=1 scale family, inclusive support endpoints,
wrong adjacent first indices, the ell=2 zero-defect boundary, and the existing
distinct odd-characteristic r=1 comparison.

The unchanged independent [readback](2026-11-19-odd-dilation-readback.txt)
and [regressions](2026-11-19-odd-dilation-regressions.txt) pass. These reuse
five fixed (ell,r) contexts, a=0,...,3, through original coefficient 17150
inclusive, and four direct-root controls through 2450. Rational-series division
and primitive-root sums do not use the unit-part formula. Corrupt first indices,
missing multiplier terms and a changed shift are rejected. No search range,
Python algorithm or random seed changed; finite agreement is not the proof.

The [validation record](2026-11-19-odd-dilation-validation.json) saves exact
commands, pins, source hashes and runtime. The audit took 2.103 seconds,
regressions 1.102 and independent readback 1.087; Lake reports 2.1 seconds for
the new module and 1.0 for the root, with whole-build wall time not separately
retained. Development failures in lemma names, casts, field imports and recursive
simp were corrected before the successful build/audit; none counted as proof.

Reproduction after sourcing shared env.sh and passing check.py: use
`prepare.env_for('littlewood')`, its `m.installed_tools` absolute Lean/Lake
binaries and `m.run` for `lake build`, `lake env lean verification/OddDilationAudit.lean`,
`python3 -m unittest discover -s tests -p test_odd_dilation_obstruction.py -v`
and `python3 -m search.odd_dilation_obstruction`. Commands ran sequentially
with two Lean threads, a 2 GiB disk reserve, 12 GiB process-group RSS limit
and 900-second timeout. No installer, download, cache-get or lake-update ran.

## Sources, startup and next decision

Targeted primary checks accessed **18 November UTC / 19 November Sydney**:
[Lai–Sprang v1](https://arxiv.org/html/2606.00633v1), 30 May 2026, remains
the sole displayed version. Its Theorem 1.2 and reduction prove the known
odd-characteristic lower bound, without uniform attainment or this binary
analogue. [Adiceam–Nesharim–Lunnon v2, §7.2](https://arxiv.org/html/1806.04478v2#S7.SS2),
11 October 2020, retains the quadratic-series exclusion and its attribution
to de Mathan–Teulié. [Garrett–Robertson v2, §5](https://arxiv.org/html/2405.14454v2),
8 April 2025, lists known unbounded-window examples; its automatic-wall
assertion remains a conjecture. The different, transcendental stream and its
ordinary source screen are in yesterday's report. No new broad review,
priority search or independent replay of those literature proofs is claimed;
the weekly review's journal-access gaps remain.

Saved [START.md](/workspace/shared/theorem-provers/START.md) and repository
bootstrap recovery were read. The complete prepared readiness gate passed
initially and [again after refresh](2026-11-19-odd-dilation-preflight.txt),
without repair, pin changes or a duplicate runtime. No applicable AGENTS was
found. Only this repository changed. Its clean generated `work` at
`7ef2b54acb917d7de3ff0bcda3b55ffc18bdb17a` matched the expected solresol origin;
fetched main, verified ancestry, preserved work, created tracking main and
fast-forwarded only. No competing local research writer was found.

Next substantive work needs a motivated weighted or altered-numerator seed
whose binomial-dilation law escapes this cancellation, screened before any
window search; alternatively solve actual repeated-ray covector compatibility.
Neither is supplied here. More examples or formalisation of this unweighted
family cannot change its retirement. The coordinator owns Raksasa sync and
keeps its local schedule paused; this worker took neither action.
