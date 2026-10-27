# Full affine span of actual terminal compatibility differences

28 October 2026, Wednesday, Australia/Sydney (AEDT). The scheduled instant
27 October 21:20 UTC is 28 October 08:20 AEDT.
Classification: **mathematical progress on auxiliary structure: a refuted
affine-reduction hypothesis**, with a finite exact certificate. This is not a
Lean theorem, new prime decision, uniform accepting word, characteristic-two
construction or established novelty claim.

## Question, bounded attempt and decision

Read the [24 October weekly human-literature review](2026-10-24-literature-review.md)
before choosing work. The substantive unresolved question remains uniform
terminal existence towards `Delta_p=2N` for all odd primes.

Stated before coding: do the actual affine child slices for all next digits
contain enough information to update the compatibility test under a shared
digit? A useful collision would refute that compression; failure to find one
would be inconclusive. Compared only prefixes of the existing p=5 paths
(311,12), (313,12), (249,36), (505,36), and p=13 paths (1465,80), (1463,80).
There were 28 and 16 distinct prefixes respectively. The profile retained
phase, capped size, current acceptance, and both complete affine slices and
homogeneous directions for each of the four digits. Comparison also required
equal actual k; common suffixes were drawn from these existing words, with
length at most five. All collisions found in these inputs had k=0. They do
not settle whether such a profile is useful after the size reaches N.

Refined the question before further coding: at fixed phase, capped size,
size parity and next digit, can the compatibility differences lie in a proper
linear subspace? A full-rank finite obstruction would rule that out; a
smaller observed span would only suggest an invariant. One shared-digit
extension of the existing p=5 prefixes was enough to disprove even the
stronger **proper affine-subspace** hypothesis.

For reproducibility, form B by repeatedly halving both coordinates of the
four p=5 pairs above and retaining k>=4. B has 12 pairs. Examine

    B union {(2q+epsilon,2k+eta): (q,k) in B, epsilon,eta in {0,1}}.

This has 52 pairs, not a rectangular search or a reachable-graph enumeration.
For each pair examine only the two odd-shift target digits (1,0), (1,1).
Keep states where both child slices are singletons, and compare differences
at fixed q mod 4, k mod 2 and target digit. Discovery took under one second
per exploratory command; no randomness or seed was used. The five retained
inputs below suffice for the proof, independently of discovery.

## Exact finite obstruction

Use the normalized stream c=a/H and the coordinates of
[26 October](2026-10-26-terminal-target-preimage.md). Here p=5, N=4, H=2,
Omega=(1,2,3,4), primitive roots Z=(2,3), and alpha=(1/2)e_1.
The next digit is always (1,1), so the parent target is
`A(2q+1,2k+1)`. Its two affine child conditions are

    (-D_(q+1) x1, alpha+x0) in R_(q+1)(k+1,k+1),
    (-D_(q+1) x0, alpha+x1) in R_(q+2)(k,k).

Both conditions use the same four coordinates
`x=(E(2),E(3),O(2),O(3))`. Each child slice in the following table is a
singleton a0 or a1, so K0=K1=0 and the quotient obstruction is the actual,
representative-independent vector delta=a1-a0 in F_5^4.

| q | k | a0 | a1 | delta |
|---:|---:|---|---|---|
| 31 | 4 | (3,1,0,0) | (1,1,3,4) | (3,0,3,4) |
| 63 | 4 | (1,2,1,1) | (1,1,3,4) | (0,4,2,3) |
| 155 | 6 | (3,1,0,3) | (3,1,4,2) | (0,0,4,4) |
| 63 | 8 | (0,0,4,2) | (0,3,2,2) | (0,3,3,0) |
| 127 | 8 | (2,3,2,0) | (0,3,2,2) | (3,0,0,2) |

All five have the same labels `(q mod N,min(k,N),k mod 2)=(3,4,0)`.
The last two arise from the first two under the **same** digit (1,0).
The determinant of rows delta_1,delta_2,delta_3,delta_5 is 3 modulo 5.
More strongly, the 5-by-5 matrix with rows `(delta_i,1)` has determinant
1 modulo 5. Thus the five differences affinely span **all F_5^4**.

Consequently, no proper affine subspace with coefficients depending only on
these discrete labels and the next digit can contain all actual singleton
compatibility differences. Any invertible affine coordinate change depending
only on these labels preserves this obstruction. This retires that particular
linear/affine invariant reduction. It does not refute state-dependent spaces,
nonlinear constraints, richer profiles, or a reduction restricted to states
already known to lead to acceptance. The five displayed next targets reject;
they are not new attainment examples. A full span of rejections does not
establish or refute uniform terminal existence.

## Independent certificate from original parity equations

The finite proof does not need Proposition 2.3, no-invisible-vector or the
four-square reconstruction theorem as an assumed input. For each listed
input, set M=2q+1, n=2k+1 and write S=E(X^2)+X O(X^2), with coefficient
lengths k+1 and k. Direct original root sums give the two subsystems

    sum_j E_j c_(2q+2+2ell+2j)
      + H^(-1) sum_(z in Z) z^(q+1+ell) x1(z) = 0,  ell=0,...,k,
    sum_j O_j c_(2q+4+2ell+2j)
      + H^(-1) sum_(z in Z) z^(q+1+ell) x0(z) = 0,  ell=0,...,k-1.

Add all-root moment equations for E or O: value 1/2 at 1, value zero at
4, and the corresponding x coordinates at 2,3. This gives square matrices
on `(x,E)` or `(x,O)` of sizes (9,8), (9,8), (11,10), (13,12), (13,12).
Each system's saved inverse is checked on **both sides**, and the saved
solution is checked against the original equations. This proves feasibility
and uniqueness of each projected x directly. Opposite-parity coefficient
identities are checked entry by entry against the original root-sum formula.
The fixed all-root evaluation constraints are exactly the target output
equation; the same two child x variables are retained throughout. Because
k>=4, every opposite moment vector is realizable within its polynomial length:
the checker verifies the four-root discrete Fourier interpolation identity.

The [certificate](2026-10-28-compatibility-affine-check.json) retains all ten
inverses, both local polynomial preimages per input, the five differences and
the two determinants. Its checker performs matrix products and independent
Leibniz determinant expansions (4! and 5! terms); it performs no elimination
and uses no state recurrence. Its largest original parent coefficient index
is **336**, inclusive. The coefficients are exact coefficients of the infinite
rationally defined stream, not a finite prefix extended by zeros.

The separate reduced-state comparison obtains exactly the same ten singleton
slices. It is a regression check, not the justification for the independent
inverse certificate. Four new tests check readback with elimination and
relation routines disabled, agreement with the existing reduced criterion,
exact regeneration and five corruption/completeness controls. Together with
the existing target, boundary and four-square tests, **22 tests pass**; the
existing r=1 and p=13 comparisons remain in those regressions.

Reproduce from the repository root:

    python3 -m search.compatibility_affine_obstruction
    python3 -m search.compatibility_affine_obstruction --check-reduced
    python3 -m unittest discover -s tests -p test_compatibility_affine_obstruction.py -v

To regenerate, use `--generate --path` with a new filename; generation refuses
to overwrite an existing certificate. Commands, exit codes and timings for
all retained checks are in [validation](2026-10-28-validation.json), with
their companion text logs. The check and four new tests each took about one
second including guard polling; all five commands finished in about seven seconds.
Python 3.12.14, standard library only, exact arithmetic. The guarded runner
enforced 180 seconds, 2 GiB disk reserve and 12 GiB process-group RSS per
retained command. No Lean source changed, so no Lean build or new axiom audit
is claimed. Challenge.lean:37's existing sorry is not used as proof.

## Literature, environment and next decision

Targeted primary reading accessed **28 October 2026 Australia/Sydney**:
[Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
30 May 2026, still the only displayed version; checked the
[actual Theorem 1.2, functional equation and Proposition 2.3](https://arxiv.org/html/2606.00633v1).
Theorem 1.2 provides a lower bound for every odd-characteristic field and
irreducible P, not equality or a uniform accepting terminal word. Proposition
2.3 remains ordinary mathematical background for the general relation theory;
the finite inverses here do not assume it. Other primary source versions,
access limits and the characteristic-two screen remain those of the weekly
handoff. No broad daily search, new binary candidate, or external novelty
claim was made. No source text or external implementation was copied; existing
Apache-2.0 project/oracle reuse and Lai–Sprang attribution are retained.

The generated work branch was clean at
e3044a50c75e4dda8e84bfe7eceb25d4fa196d29. Verified expected solresol origin,
fetched main, checked ancestry/equality, preserved work, created tracking main
and completed an FF-only merge. No overlapping Littlewood process was found;
the parent had checked the listed direct tasks. Read saved Start, bootstrap
recovery instructions, current README/TODO/log and relevant actual sources.
No applicable AGENTS.md or saved .agents skill was present. First sourced
the selected prepared env.sh and ran check.py; it passed again after refresh.
Exact pins, dependency HEADs/cleanliness, readiness and representative imports
passed. No install, cache download, runtime creation, pin, security, credential,
schedule, other checkout or user-machine change was made. Publication of the
environment and outreach were outside this run. Cloud-thread sending tools
were not exposed in this child; the exact push state is returned to the parent.

Next substantive question: derive compatibility transport while retaining
state-dependent relation data, or identify a nonlinear constraint that can
force a zero class. The general full-slice profile closure question remains
inconclusive after the bounded prefix check; do not call it refuted by the
affine-span result. Do not return to fixed proper affine constraints at these
labels, independent-child feasibility, one-parity-plus-norm sufficiency or
larger attainment boxes. Uniform odd-shift existence and the finite-field
characteristic-two frontier remain open project targets.
