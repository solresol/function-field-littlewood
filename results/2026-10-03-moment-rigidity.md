# Kernel-checked root-moment rigidity

3 October 2026, Saturday, Australia/Sydney.
Classification: **verification/infrastructure progress** on the structural
auxiliary-bound proof path. No new all-degree or characteristic-two result.

## Question and decision

Can the root-moment block in the 2 October factor-aware descent be checked in
Lean without assuming Vandermonde invertibility, prime-field nonsquareness, or
the forced-factor conclusion? This question was stated before implementation.
Success verifies the algebraic core needed for the all-shift degree cutoff;
failure would require revisiting that ordinary proof. It does not by itself
repair the missing terminal moment.

## Formal statement and boundary

`FunctionFieldLittlewood/ParityDescent.lean` proves the following. Let p>2 be
prime, H>0, p-1=2H(2k+1), and let z:Fin H -> F_p be injective with z_i^H=-1.
Let s divide H and put

    g(t) = sum_{a=0}^{H/s-1} t^(sa).

For arbitrary polynomials U_0,U_1 and n>=0, suppose

    sum_i z_i^(n+j) g(z_i) (U_0(z_i)^2-z_i U_1(z_i)^2) = 0
        for every j=0,...,H-1.

Then D=t^H+1 divides both U_0 and U_1, and gD divides both gU_0 and gU_1.
Here s is **half** the parent surplus in the 2 October report; H=N/2.
The starting exponent is n+delta in that report. Thus all H moments, including
the last one, are required. No bound on quotient degree or nonzero constant
term is assumed. Zero parity components are allowed.

The proof uses mathlib's Vandermonde theorem to annihilate the shifted weights.
Fermat's theorem proves nonsquareness: if z=y^2, then
y^(p-1)=(z^H)^(2k+1)=-1, contradicting y^(p-1)=1. The geometric identity
g(t)(t^s-1)=t^H-1 gives g(z)(z^s-1)=-2, so g(z) cannot vanish. The quadratic
form then forces both evaluations to zero. Pairwise coprimality of the linear
factors and monicity identify their product as t^H+1.

The generic theorem **assumes the displayed root enumeration and moments**.
These are explicit input data, not axioms or an assumed version of the target.
It does not construct the enumeration uniformly, prove the support stream's
odd-subsequence root identity, derive moments from parent rows, prove the
leading-child degree/shift bounds, or iterate the descent. The all-shift degree
cutoff remains an ordinary theorem, not a completed Lean theorem. Identification
with the original infinite Laurent root sum also remains separate.

An F_5 instantiation uses roots 2 and 3 and g=1, and verifies all root hypotheses
for arbitrary U_0,U_1,n. The formal negative control uses U_0=t-1,U_1=0,n=0:
the weights are 1,4, whose zeroth moment is 0 and first moment is 4. The
polynomial t^2+1 does not divide t-1. Thus dropping a moment is invalid even
in r=2. This is **not** a counterexample to the terminal stream statement:
it does not supply the linked terminal quotients or a vanishing stream window.
The r=1 terminal failure from 2 October is retained; the full-moment rigidity
lemma itself also applies in r=1.

## Verification and reproduction

Lean and mathlib remain v4.27.0; mathlib is pinned in lake-manifest.json to
a3a10db0e9d66acbebf76c5e6a135066525ac900. Inspected the Apache-2.0 licence and
the actual Vandermonde, finite-field Fermat, polynomial factor/divisibility,
degree, and geometric-sum sources before reuse. No dependency pins changed.

Commands:

    lake env lean FunctionFieldLittlewood/ParityDescent.lean
    lake build

The final `lake build` passed (2,212 jobs, 10.985925 seconds, no warnings).
The build and axiom audit are recorded in `2026-10-03-lean-build.txt`
and `2026-10-03-validation.json`. All 85 theorem axiom reports, including the
12 new ones, contain only propext, Classical.choice and Quot.sound. A scan of
all project Lean sources found no admitted proof, project axiom or proof bypass.
The named F_5 boundary theorem is checked by the Lean kernel.
There is no random seed, finite search box, timeout-based inference or new
certificate export. Python and old certificates are unchanged, so their suite
was not rerun. The complete source and documentation diff were inspected.

## Sources and next decision

Primary sources accessed 3 October 2026:

- Lai–Sprang, [arXiv:2606.00633v1, Section 3](https://arxiv.org/html/2606.00633v1#S3),
  submitted 30 May 2026. The moment/Vandermonde/nonsquare argument is adapted
  from their proof. Their odd-characteristic main theorem is already settled;
  this work verifies a step of the repository's auxiliary strengthening.
- Badziahin–Pavlenkov–Zorin, [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  submitted 22 August 2026. Its characteristic-two statement remains conditional
  in the checked version. No new binary candidate was proposed, no comprehensive
  frontier search was undertaken today, and no novelty claim is made.

Next formal obligation: derive the exact moment block from the named stream's
parent window, including the root enumeration and odd-subsequence formula.
Next substantive mathematical decision: determine whether linked terminal
quotients recover the missing moment or whether a terminal obstruction exposes
lost sibling compatibility. Do not replace that question with larger boxes.
