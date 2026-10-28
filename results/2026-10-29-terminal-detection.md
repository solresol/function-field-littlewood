# Proved binomial nonvanishing and exact terminal detection

29 October 2026, Thursday, Australia/Sydney (AEDT). Scheduled instant:
28 October 21:20 UTC = 29 October 08:20 AEDT.
Classification: **verification/infrastructure progress on known mathematics**.
This closes missing formal proof inputs to the auxiliary sharpness programme;
it supplies no uniform accepting word, new prime or characteristic-two result.

## Question and result

Read the [24 October human-literature review](2026-10-24-literature-review.md),
current roadmap, Wednesday's affine obstruction and actual source before selection.
That obstruction calls for state-dependent or nonlinear structure. Further generic
affine packaging was not justified. Following Thursday's formalisation pattern,
the stated question before coding was whether the existing parity/moment library
could prove the coefficient-row form of Lai–Sprang Proposition 2.3, then remove
the assumed nonvanishing input from terminal detection. Success would connect
actual accepting states to the already proved product theorem; failure would
identify the missing step without replacing it by an axiom.

**Result:** the strict degree descent is proved. Accepted nonempty square targets
now imply endpoint-admissible exact terminal certificates and actual polynomial
product `2^(-2N)`. The no-invisible-vector statement needed for bordered
reconstruction is also proved, including singular Hankel blocks. Acceptance remains
an explicit hypothesis. Uniform attainment and the characteristic-two target
remain unresolved in this project.

## Exact mathematical scope

Lean uses `H=2^r`, `N=2H`, and `p-1=N(2k+1)`, with p prime and p>2.
Thus Lean r=0 includes the usual valuation-r=1 comparison. All shifts are
nonnegative, and all rows refer to the infinite named support stream `a`.

[BinomialNonvanishing.lean](../FunctionFieldLittlewood/BinomialNonvanishing.lean)
proves `stream_binomial_nonvanishing`: if nonzero R is divisible by `X^N-1`,
some filter row `1<=j<=deg R` at any shift is nonzero. No endpoint or target
assumption occurs. The proof writes `g=X^H-1` and splits R into
`E(X^2)+X O(X^2)`, with `E=g U0`, `O=g U1`. For degree `2q+epsilon` and
shift `2n+delta`, the existing extraction gives parity lengths
`q+epsilon*delta` and `q+epsilon*(1-delta)` from exactly degree-many parent rows.
The quotient degree bounds leave H cross-convolution moments. The existing
Vandermonde/nonsquare proof forces `X^H+1` into both quotients; here `g(z)=-2`
at every primitive root. Hence both children retain `X^N-1`. The leading
child has degree q and q zero rows at shift `n+epsilon*delta`. Since
`deg R>=N>=2`, this is a strict descent. Strong induction closes the contradiction.

[TerminalDetection.lean](../FunctionFieldLittlewood/TerminalDetection.lean)
then proves the following chain, with no assumed Proposition 2.3:

- `stream_geometric_nonvanishing`: a nonzero multiple of
  `F=1+X+...+X^(N-1)` has a nonzero row by `deg P+2`.
  Multiplication by X-1 and the exact difference-filter identity reduce this
  to the binomial theorem.
- `stream_terminal_certificate`: if the first `deg P+1` rows of such a
  polynomial vanish, its constant coefficient is nonzero and its exact first
  nonzero row is `deg P+2`. A hidden X factor would give an overlong window
  for a smaller geometric multiple at the next shift.
- `target_exact_certificate`: membership of `(0,e_1)` in the actual relation
  at shift m and square size `d+1` gives a polynomial P of **exact** degree d,
  F divisibility, and `ExactCertificate a (coefficients P) m (d+2)`.
  Complete root moments imply F divisibility and P(1)=1. The geometric bound
  forces the full degree and the certificate endpoints; they are conclusions.
- `target_sharp_product` composes this with the existing uniform dyadic lift,
  producing `X^(Nm) P(X^N)` with actual polynomial product `2^(-2N)`.
- `stream_no_invisible`: the stacked Hankel/evaluation map has trivial kernel
  for `d+1` columns and L rows whenever `d<=L`. Zero moments force `X^N-1`
  divisibility, and its nonvanishing theorem rules out a nonzero polynomial.
  Hankel invertibility is neither required nor inferred.

The target theorems take an injective, complete list of the N-th roots of unity;
the existing `BoundaryRelation.stream_full_root_data` supplies such lists.
No free pairing of child states, normalized-stream substitution or change of
the existing raw-stream root target occurs. The terminal implication is stated
for nonempty squares. It does not enumerate reachable states, prove their
dimensions, package the concrete affine directions, prove even-shift stripping
or construct a uniform accepting word. The original rational Laurent sum is
not identified with the named stream end to end, and the full arbitrary-P,
arbitrary-ground-field source theorem is not claimed as a Lean theorem.

## Checks and evidence

Prepared runtime startup checks passed before research: exact pins, dependency
HEADs and tracked cleanliness, readiness receipts and representative imports.
Read saved Start and cloud-bootstrap recovery instructions; reused the valid
prepared runtime. No applicable AGENTS.md was found. The clean generated work
branch at `6d6f0031e3e6a82af0ac0b947cb94610a6546c17` matched the expected origin;
fetched main, checked ancestry, preserved work and created tracking main with an
FF-only check. The parent had excluded overlapping workers; none was observed.

Lean 4.35.0 / mathlib `56a005855ea17e0b0958f73ec801ae140b0a1679` and all pins
remain unchanged. Existing project code and mathlib were reused under their
Apache-2.0 licences, with Lai–Sprang attribution retained. The saved guarded runner
enforced two Lean threads, 2 GiB disk reserve, 12 GiB process-group RSS and
1,800 seconds per retained command. [Validation](2026-10-29-terminal-detection-validation.json)
records exact commands, source hashes, exit codes and times:

    lake build
    lake env lean verification/TerminalDetectionAudit.lean
    python3 -m unittest discover -s tests -p test_terminal_target_preimage.py -v
    python3 -m search.terminal_target_preimage

All passed: build 2.040s, audit 3.038s, three focused tests 2.036s, existing fixed
check 7.039s. The build's only warning is the pre-existing Challenge.lean:37
statement placeholder. All 14 new declaration closures use only propext,
Classical.choice and Quot.sound. No new sorry, unproved axiom or native_decide
occurs. Challenge and its assumed claims are absent from these proof closures.
No separate-kernel replay is claimed.

The Lean audit checks the actual raw F_3 target `(2+2X)` at shift 1, its product
through the new implication, a singular zero-row/single-column stacked kernel,
the zero-polynomial exclusion, the material nonsquare premise, the existing F_5
terminal witness without binomial divisibility, and a failed terminal row at
shift zero. These are boundary/regression controls, not new witness research.
Development compilation exposed polynomial API names, multiplication orientation
and finite-field normalization issues; all were corrected before retained checks.

Python checks retain the prescribed 800 comparisons and existing p=3,5,13,41,17
controls from the target-preimage workflow, with original-root-sum affine
readback. No search range grew. Python 3.12.14, standard library, exact arithmetic,
no randomness or seed. The large p=41 control remains recurrence-based, not a
new giant independent or Lean certificate. A size-n square target reads through
index `m+2n-1`; its next row reads through `m+2n`. The formal proof uses the
infinite stream and never extends a finite prefix by zeros.

## Literature and next decision

Targeted primary reading accessed **29 October 2026 Australia/Sydney**:
[Lai–Sprang arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
30 May 2026, the only displayed version; inspected
[Proposition 2.3 and its strict-degree descent](https://arxiv.org/html/2606.00633v1).
This is known preprint mathematics. The new coefficient-row proof adapts that
argument using the existing formal root identities and finite row machinery.
The source's odd-characteristic lower bound does not supply accepting terminal
events. Other source/version and frontier-screen limits remain those of the
24 October weekly human-research review. No broad daily search or new binary
candidate was selected, and no priority claim is made.

The formal programme can now consume actual acceptance without assuming an
endpoint or exact-certificate bridge, and can consume the no-invisible-vector
lemma without assuming Proposition 2.3. Next substantive research remains
state-dependent/nonlinear compatibility transport on correlated adjacent-shift
states, seeking a uniform zero class. Do not repeat Wednesday's fixed-affine
obstruction, expand attainment boxes or turn further generic packaging into
automatic daily work. No installation/download, runtime/pin/security/credential
change, schedule change, outreach, environment publication, other-checkout or
user-machine action occurred. Cloud-thread send tools are unavailable in this
worker; the exact pushed commit is returned to the parent for coordination.
