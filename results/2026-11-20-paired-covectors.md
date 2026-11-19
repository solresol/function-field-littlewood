# Both children are necessary on at least one actual ray

Friday 20 November 2026, Sydney. Mathematical progress on a local obstruction
and a compatibility criterion for the auxiliary odd-characteristic target.

**Question.** At the first autonomous phase-3 merge on the two actual N=4
rays, can one transport a single child covector that descends to the parent
boundary and separates its terminal target? A surviving covector could seed a
rejection invariant. If projection to the internal coordinates is invertible
for both children, only a coupled rule can cross that step.

Use the definitions and full-rank specialization proof of the
[15 November recurrence](2026-11-15-fraction-free-integration.md).
From initial shifts 62,126 and size 8 take exactly two (1,1) steps to
q=251,507 and k=35. At the next first-square merge the children are
A11 (raw start q+1, size 36) and B00 (raw start q+2, size 35).
The parent raw start is 0 mod 8. Use the existing unimodular split
with parent boundary z=(f,s) and four internal coordinates w.
For child a, write its four pulled-back annihilator rows as [B_a | U_a].
Relative to the existing integral exterior representative the coefficient of
the four internal columns is the following signed integer.

| Initial shift | even child | odd child |
|---:|---:|---:|
|62|39924358351872572|2618120383213720|
|126|−3834774901834476|685749117850008|

**Lemma.** For every p=5 mod 8 prime, on at least one of these actual rays
both restrictions to the internal dual space are isomorphisms. Indeed the
gcd of the two row products is 32. On a ray with nonzero product, any
child covector with zero internal part is zero. Thus every nonzero parent
covector needs nonzero contributions from *both* children, even if the
single-child covector could otherwise vary freely with the state and p.
This concerns the first autonomous merge only.

On such a ray define H_a = U_a^{-1} B_a over the ground field, using any
basis of the four equations. For any boundary z, each child separately forces
w = -H_a z. Hence the parent relation is exactly ker(H_0-H_1). Equivalently,
for any row u on the internal coordinates the unique cancelling pair with
internal parts u and -u produces the parent covector u(H_0-H_1).
All parent annihilators arise in this way by the kernel identity.
In particular tau is accepted exactly when H_0 tau = H_1 tau.
This gives a simultaneous comparison in a chart guaranteed to exist on
at least one ray at this step. It does not show that either equality holds,
that the chart persists, or that a fixed choice of ray works for all primes.

**Exact checks.** Run from the repo root:

    python3 -m search.paired_covector_chart

Python standard library, deterministic, no seed. The complete check took 1.59 s. The first calculation pulls
back the two actual exterior representatives with the existing formal-series
generator. The independent check sets z=0 and builds the child equations
directly on (x,w) with the integer odd-part coefficients, then computes their
40- and 39-square determinants by Fraction elimination. Explicitly the rows
are A x + D K s_other = 0 and V x - s_child = 0 with the zero-boundary split
s_child=(-w_i,-w_(i+1),w_i,w_(i+1)), i=2a. Here D repeats residues and
K has entries alpha_(i+j) for both parities. Largest inclusive direct
coefficient indices are 322 and 578 respectively across the two rays.
Both methods yield the displayed integers. This is an exact computer-assisted
linear algebra proof, with no Lean claim or use of Challenge.lean.

Read the [13 November literature checkpoint](2026-11-06-literature-review.md#13-november-2026-checkpoint)
and rechecked [Lai–Sprang v1, Theorem 1.2 and Proposition 2.3](https://arxiv.org/html/2606.00633v1)
on 20 November Sydney. Their bound applies to every irreducible P in odd
characteristic. Uniform attainment is the separate repository target.
The r=1 comparison stays separate. No binary construction was attempted.

**Next decision.** Seek an identity for the difference of the two forced
splits at tau under the next actual merge, retaining both children. Any
iteration must prove chart persistence or provide a singular-chart transition.
No new terminal witness or all-length rejection follows here.
