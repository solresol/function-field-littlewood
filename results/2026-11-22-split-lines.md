# Two distinct reasons for rejection at the fourth merge

Sunday 22 November 2026, Sydney. Fix N=4 and an admissible prime p=5
modulo 8. Starting from (q,k)=(62,8) or (126,8), apply (1,1) four times.
**Both resulting first squares reject τ. For each p, at least one ray has
two individually soluble children forcing different outer splits. At p=53
the ray starting at 126 instead has two individually insoluble children.**

## Proof and reproducible computation

Use the integral exterior recurrence and its full-rank specialization
argument from [15 November](2026-11-15-fraction-free-integration.md).
After two steps the correlated pairs (3,7) and (6,5) merge to components
3 and 4. Pull their resulting four-forms back through the two outer child
maps at raw phase zero. Restrict each to the five columns (h,w) parametrizing
parent boundary hτ and shared split w. The coefficient column for h is the
sum of the four residue columns since τ=(0,0,0,0,1,1,1,1).
For each child let L=(d,v) be the five signed maximal minors, with sign
(-1)^j on deleting column j (zero-based). Wherever L is nonzero its
restricted equations have rank four and the kernel is exactly the line L
by cofactor expansion. A nonzero restricted minor also certifies that the
preceding eliminations represent actual projected relations at that prime.
Thus d nonzero gives the unique split v/d, and d zero with v nonzero
precludes h=1. This evaluates the existence test proved on 21 November.

For each ray put g=gcd of the four coordinates of d₀v₁−d₁v₀.
Exact integral evaluation gives g=16 and 7632 respectively, and
gcd across rays of the two integers d₀d₁g equals 8704=2⁹·17.
No admissible prime divides this last gcd, so at least one ray has
two invertible first coordinates and unequal forced splits.

More strongly, wherever p does not divide g the nonzero cross-product
certifies that both lines exist and cannot meet at h=1, even if one
first coordinate vanishes. Only the second ray at p=53 needs another
test since 7632=2⁴·3²·53. Its cofactor vectors modulo 53 are
(0,1,35,29,32) and (0,32,28,24,19). Each child therefore precludes
h=1 by itself. Dividing or normalizing by a first coordinate would lose
this actual specialization.

Run from the repository root with standard-library Python and no random seed:

    python3 -m search.two_merge_split
    python3 -m search.paired_covector_chart
    python3 -m search.odd_dilation_obstruction

The first command took 0.93 s, including direct readback at 5 and 53 on
both rays. Readback solves the original normalized root-sum windows of sizes
72 and 71 at starts 8(q+1)+a for row parity a=0,1, projecting solutions
to the five coordinates. Largest inclusive indices are 646 and 1158.
The integral recurrence starts only from coefficients through q+18.
The previous chart and binary obstruction regressions took 0.77 and 0.08 s.
The uniform claim follows by integer gcd and specialization. The prime
readbacks independently check the coordinate convention. No Lean source
changed and no theorem here depends on Challenge.lean.

## Research decision

Retire length four on these rays as a selector. A fixed invertible chart
on both rays already fails. Seek a transport identity for the full minors
of the two homogeneous lines and track intersection with h=1 separately.
This local exclusion leaves all-length rejection and uniform Δ_p=2N open.
The r=1 comparison remains separate. The week's unweighted odd-dilation
obstruction rules out that binary family, leaving the characteristic-two
construction frontier unchanged.

The coordinator reports no directly relevant new work from the 21 November
weekly literature check. The latest detailed review in this checkout is the
[13 November checkpoint](2026-11-06-literature-review.md#13-november-2026-checkpoint).
On 22 November Sydney we rechecked the arbitrary odd-characteristic ground
field and irreducible P hypotheses and the lower bound in
[Lai–Sprang v1, Theorem 1.2](https://arxiv.org/html/2606.00633v1).
Our exclusion concerns attainment for their specific series.
