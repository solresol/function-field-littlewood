# Uniform terminal-certificate lift in Lean

24 October 2026, Saturday, Australia/Sydney (AEDT).
Classification: **verification/infrastructure progress** on the 5 October
ordinary proof. No new sharpness mathematics, prime decision, characteristic-two
construction, global sharpness theorem or priority claim.

## Question and decision

Can the geometric factor prove odd-row vanishing at every intermediate dyadic
scale, so that any exact terminal certificate lifts to product 2^(-2N) without
per-prime residue checks? This was stated before editing. Success closes the
uniform reverse-lift implication; a failed scale/root argument would expose a
missing hypothesis. The chosen step is the explicit fallback in the roadmap.
Friday's square-state obstruction is retained, not rerun or formalised as filler.

Write N=2^(r+1), H=2^r in this module's parameters: r=0 includes the usual
valuation-r=1 comparison. Assume p prime and N divides p-1; maximality of this
power of two is unnecessary. Let a be the infinite named support stream,
F_N=1+X+...+X^(N-1), and B_S(v)=sum_j S_j a_(v+j).

For every F_N multiple S and 0<=s<=r+1, the new theorem proves

    B_(S(X^(2^s)))(v) = B_S(v/2^s)  if 2^s divides v,
                        0           otherwise,

for every natural v, including v=0 and S=0. The proof is about the infinite
stream, with no finite prefix or unresolved truncation cutoff.

If S has endpoint-admissible exact first index j at shift M, its expansion
has degree 2^s deg S, both endpoints nonzero, shift 2^s M and exact first
index 2^s j. In particular, when j=deg S+2, set R=S(X^N), m=NM. Then

    j_R-deg R = N(deg S+2)-N deg S = 2N,
    polynomialLittlewoodProduct(a, X^m R) = 2^(-2N).

This is an implication with explicit input certificate, not a proof that such
a certificate exists for every prime. The still-unformalised boundary-target
interpretation must supply that exact certificate; its ordinary proof uses
Lai–Sprang Proposition 2.3. Today's theorem neither assumes that proposition
as an axiom nor derives exactness from a zero window alone. The global upper
bound, terminal equivalence/dichotomy and identification with the complete
infinite rational-function sum are not proved here.

## Proof and reuse

`FunctionFieldLittlewood/TerminalLift.lean` proves:

- `odd_filter_of_dvd`: X^H+1 multiples kill all odd-row filters, by the existing
  uniform root-filter enumeration and polynomial evaluation.
- `geometric_eval_zero`: F_N multiples vanish at every nontrivial N-th root,
  using the existing geometric-product identity, with no division by zero.
- `geometric_dyadic_odd_rows`: for s<=r, a root z with z^H=-1 has z^(2^s)
  nontrivial and its N-th power is 1, so every odd filter of S(X^(2^s)) vanishes.
- `geometric_dyadic_rows`: induction with the proved even stream recurrence
  and exact polynomial-index expansion gives the full displayed identity.
- `certificate_dyadic`: transports the two endpoints, all strictly earlier
  positive rows and the terminal nonzero row. Divisibility and natural division
  are handled exactly; there is no natural-subtraction defect convention.
- `terminal_product`: composes that certificate with the already proved actual
  polynomial/Laurent product theorem and simplifies the integer exponent.

The two coefficient/reconstruction lemmas connect the polynomial's actual
coefficient vector to the existing certificate convention; no parallel stream,
polynomial-size or product definition was introduced. The default library
imports the new module. Its proof closure does not import Sharpness or Challenge;
Sharpness is imported only by the separate audit for finite controls.

Inspected and reused RootStream's filtered enumeration, WindowMoments.filt,
ParentWindow.filt_expand, ParityDescent.factorQuotient, the coefficient-vector
reconstruction, and FractionalPart's product bridge. Inspected the actual
pinned mathlib polynomial expansion/evaluation/degree sources (Apache-2.0,
including Kenny Lau's Expand.lean). The new proof sources and documentation
retain this project's Apache-2.0 licence and Lai–Sprang attribution in NOTICE.

## Environment and checks

Started on clean generated `work` at 61c0c333821a4aeb90c4f79302ca881c8f58f05b.
Verified origin https://github.com/solresol/function-field-littlewood.git,
fetched, checked HEAD ancestry/equality with origin/main, preserved `work`,
created tracking `main`, and completed the fast-forward-only check. No overlap
or applicable workspace/repository AGENTS.md was found. Read the saved
`/workspace/shared/theorem-provers/START.md`, README, TODO, recent research log,
19/22/23 October results, 5 October ordinary proof and actual relevant sources.

Sourced the prepared environment and ran its check.py before any setup:
all recorded pins, readiness receipts, exact dependency HEADs, clean tracked
dependency sources and representative imports passed. Read cloud-bootstrap
recovery/resource guidance; no bootstrap, installer, download, cache fetch,
re-preparation, dependency change or other repository edit was needed. Existing
project prerequisites were checked with guarded lake build. Lean is 4.35.0,
mathlib 56a005855ea17e0b0958f73ec801ae140b0a1679; all pin hashes are unchanged.

Every Lean command used prepare.py's tested guarded runner and project-specific
cache environment: two threads, 2 GiB disk reserve, 12 GiB aggregate process-group
RSS, 30-minute command limit. Commands ran sequentially; no limit was raised.

    lake build
    lake env lean verification/TerminalLiftAudit.lean
    python3 -m search.terminal_lift_check
    python3 -m unittest discover -s tests -p test_lai_sprang_sharpness.py -v

The full default build passed in 6.006 seconds. The new module has no warnings.
The existing Challenge.lean:37 statement placeholder is replayed by the default
build but is not evidence for this theorem. The dedicated audit passed in
4.003 seconds and checks exact types/axioms for all nine new declarations:
only propext, Classical.choice and Quot.sound. No sorry, added axiom,
native_decide, assumed odd-row condition or assumed target theorem occurs
in the new proof. No independent-kernel replay is claimed.

The audit also derives the existing F_3 terminal product through the generic
theorem, covers zero polynomial/row, and kernel-checks original-stream controls:
F_5's first forbidden scale 2N has odd row 3, the incomplete geometric factor
has odd row 4 at scale N, and the factor-free odd row is nonzero. These check
why the precise hypotheses matter, without enlarging an attainment search.

The existing independent root-sum lift checker passed 2,885 prescribed row
identities in 0.013 seconds over p=3,5,13,41,17, N=2,4,4,8,16. It retains its
five quotient vectors, scales 0 through the usual valuation r, and absolute
rows 1 through 4N+1; precise inclusive root-oracle endpoints are recorded in
the JSON. The first forbidden scale and omitted-factor controls remain nonzero.
Its finite checks support the interpretation; the Lean theorem is the proof.
The 11 existing sharpness regressions passed in 0.209 seconds (guarded command
1.001 seconds). Python 3.12.14, standard library only, deterministic, no seed.
No Python code or search range changed and no full-suite or large-certificate
rerun is claimed.

Development errors involved dependent rewrites/finite-index arithmetic and
normalising polynomial degree in the audit; all were repaired without changing
mathematical hypotheses. Source and complete diffs were inspected. The build,
audit, finite checks, tests and companion validation JSON retain the commands,
runtimes, exact declaration types, hashes and scope.

## Literature and next step

The newly required weekly HUMAN literature-review findings are not present in
this saved checkout. The first weekly check may not yet be available this
morning. This limits current literature coverage; it is not evidence of no
outside progress. Reused the dated 23 October record rather than broad-searching
again. No current characteristic-two or novelty claim is made.

Targeted primary verification, accessed **24 October 2026 Australia/Sydney**:
[Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1), submitted
30 May 2026, remains the version displayed on the abstract page. Read the
[functional equation (1.2), Theorem 1.2 and Proposition 2.3](https://arxiv.org/html/2606.00633v1#S2).
Theorem 1.2 already proves main-conjecture failure over all odd-characteristic
ground fields. The present result uses its coefficient/root functional equation
through existing proved stream identities; it needs only N dividing p-1 and
works over the prime field. It does not formalise the paper's full theorem or
its extension to every irreducible P. The reverse-lift deduction itself was
already proved ordinarily in this repository on 5 October.

Next substantive work remains four-square bordered-relation reconstruction,
including singular blocks, or uniform accepting paths. The completed lift
should be reused, not expanded into routine witness exports. Further Lean
work should follow that evidence; the Proposition 2.3/terminal-exactness bridge
is a separate substantial project. No schedule or external host was accessed
or changed.
