# Even-shift terminal stripping formalised

31 October 2026, Saturday, Australia/Sydney (AEDT). Scheduled instant:
30 October 21:20 UTC = 31 October 08:20 AEDT.
Classification: **verification/infrastructure progress on the 26 October ordinary
argument**. No new mathematical sharpness decision, uniform accepting word,
prime, characteristic-two construction or priority claim.

## Question and decision

Read the latest available [weekly human-literature handoff](2026-10-24-literature-review.md),
current roadmap, 30 October profile obstruction and actual Lean foundations
before selection. The complete fixed-target profile is already refuted as a
closed state; that finished result was not rerun. Saturday's exact question,
stated before coding, was whether every even-shift event strips by a simultaneous
binary zero, including empty sizes and the usual valuation-r=1 comparison.
Success would reduce uniform terminal existence to the unresolved odd-shift
compatibility problem; failure would identify the missing factor or row-budget
lemma. This was one bounded formalisation attempt, not a witness search.

**Outcome.** [EvenShift.lean](../FunctionFieldLittlewood/EvenShift.lean) proves

    A(2m,2n) iff A(m,n),       not A(2m,2n+1),

where A(m,n) is actual target membership `(0,e_1)` in the n-by-n boundary
relation starting at stream index m+1. There is no event at shift zero.
Every polynomial event has `m=2^s u`, `n=2^s v` for an odd u and an event
at (u,v). `target_exists_odd_iff` gives the corresponding equivalence of
actual boundary-target existence and odd-shift existence. Existence remains
an input, not a theorem inferred from these reductions.

## Semantics and proof path

Lean uses H=2^r, N=2H and prime p>2 with `p-1=N(2k+1)`; hence Lean r=0
is the usual valuation-r=1 case. All coefficients are in F_p and all rows use
the infinite named Lai–Sprang support stream. The full two-primary order,
not merely N dividing p-1, is required by the nonsquare argument.

`Terminal p r m n` means a nonzero polynomial P with exact degree n-1,
F_N divisibility and rows 1 through n zero at shift m. It has no assumed
normalization, nonzero constant endpoint or first-nonzero assertion. Existing
`stream_terminal_certificate` supplies the endpoints and exact next row.
`target_iff_terminal` proves equivalence with actual boundary membership for
an injective complete N-th-root list, including n=0. Binomial nonvanishing
proves P(1) is nonzero, so normalization by P(1) is justified.

The essential new factor lemma `stream_even_forced_factor` writes

    F_N(X)=F_H(X^2)(1+X),        P=E(X^2)+X O(X^2),
    E=F_H U_0,                  O=F_H U_1.

At even shift and degree 2q+epsilon, the degree+1 parent rows give parity
lengths q+epsilon and q+1. The existing quotient-degree bounds leave H
cross-convolution moments, including H=1. The proved Vandermonde/nonsquare
lemma forces X^H+1 into U_0,U_1, hence F_N into both E,O. Odd-subsequence
filters then vanish, leaving the exact child windows.

For even size the leading odd child has half the size and is terminal.
Conversely `(1+X)P(X^2)` preserves F_N and doubles shift and size. For odd
size, the odd child has too many zero rows and is zero by the proved
geometric degree+2 bound. Evaluation of the parent at -1 then makes P(1)=0;
the parent has X^N-1 as a factor, contradicting proved binomial nonvanishing.
Strong size descent excludes shift zero. Strong shift descent gives the
odd representative with the same power of two dividing shift and size.

The proof reuses ParentWindow, WindowMoments, ParityDescent, DescentStep,
TerminalLift and TerminalDetection after inspecting their definitions and
index conventions. No matrix invertibility, affine-slice uniqueness or assumed
project theorem is introduced. The normalized unique-polynomial formula
`(1+X)T(X^2)/2` and its iterated closed form are not separate new Lean claims
here; the existing finite regression still checks that formula. Four-square
dimensions/reconstruction and transverse response compression remain outside
this module. The full rational Laurent-sum identification and arbitrary-field/P
source theorem also remain outside these declarations.

## Checks and reproducibility

Prepared runtime preflight passed before work and after fetch: exact pins,
dependency HEADs and clean tracked dependency sources, readiness receipts and
representative imports. The clean generated work branch at fb16a73 was preserved.
Verified the expected solresol origin, fetched main, checked ancestry/equality,
created local main and completed the fast-forward-only check. No applicable
workspace/repository AGENTS.md or .agents skill was present. Read saved
`/workspace/shared/theorem-provers/START.md` and `docs/cloud-bootstrap.md`.
The environment source-version binding matched the verified handoff; startup
completed before the successful preflight. No runtime duplication, installation,
download, pin/dependency change, environment publication, credential change,
schedule or other-checkout edit occurred.

Retained commands, with exact logs, hashes and timings in
[the validation record](2026-10-31-even-shift-validation.json):

    lake build
    lake env lean verification/EvenShiftAudit.lean
    python3 -m unittest discover -s tests -p test_terminal_target_preimage.py -v
    python3 -m search.terminal_target_preimage

Each was run sequentially through the saved `prepare.py` module's `m.run`,
with `env_for('littlewood')`, LEAN_NUM_THREADS=2, a 2 GiB disk reserve,
12 GiB process-group RSS limit and 900-second timeout. No setup function was
called. Command times were 6.004s, 4.004s, 2.002s and 7.005s. The default
build includes the new module. Its existing Challenge.lean:37 placeholder is
not proof and is absent from every new audited closure. No non-default large
certificate build or independent-kernel replay is claimed.

The audit prints the Terminal definition and exact theorem types. All 15 new
theorems and both named r=1 regression proofs use only propext, Classical.choice
and Quot.sound. The new proof/audit/root files pass prohibited-token scans.
Kernel regressions check actual r=1 target doubling and stripping, odd-size
rejection, empty squares and shift zero. A negative control removes F_N:
over F_5, P=1 has its single required row zero at even shift 2, so the odd-size
exclusion cannot be generalized to arbitrary polynomials. The F_5 square root
of -1 retains the maximal-order warning. During development, field-instance,
rewrite and sum-normalization issues and the audit's missing fast-stream import
were corrected before the retained passing checks.

The unchanged Python checks use Python 3.12.14, the standard library, exact
finite-field arithmetic and no randomness/seed. Three tests retain p=3,5,13
normalized lifts and the existing p=41 path. The fixed check compares 800
prescribed targets over p=3,5,13,41,17, q in {0,1,2,3,7,8,15,31}, k=0,...,4
and all four digits, plus its existing accepting/rejecting controls. These are
finite regression identities, not evidence for uniform existence. No box,
whole-graph enumeration, new witness or profile-collision search was added.

## Literature and next useful step

Targeted primary reading, accessed **31 October 2026 Australia/Sydney**:
[Lai–Sprang, arXiv:2606.00633](https://arxiv.org/abs/2606.00633), only displayed
version v1, 30 May 2026; [actual Theorem 1.2, equation (1.2) and Proposition 2.3](https://arxiv.org/html/2606.00633v1).
The theorem gives the odd-characteristic lower bound, not attainment. The
proposition excludes an overlong zero window for a binomial multiple; it supplies
no accepting word. Its full valuation and nonnegative-shift hypotheses match
the reused coefficient-row formalisation. The parity identity is the same
infinite-stream recurrence. No broad daily literature search was duplicated.
Other sources, access limits and the binary rational/quadratic/unbounded-window
screen remain those of the 24 October weekly review. No new binary candidate
was selected. Existing project/mathlib Apache-2.0 licences and mathematical
attribution were inspected and retained; no external source prose or code was copied.

**Next useful research step:** at odd shifts, identify the transverse forcing/output
response discarded by the empty target slices in the fixed T(62,8)/T(126,8)
collision. Use this proved reduction and the completed target-to-product theorem;
do not replace that investigation with repeated stripping, generic affine
packaging, retired examples or additional attainment witnesses. Uniform
Delta_p=2N and characteristic two remain unresolved.
