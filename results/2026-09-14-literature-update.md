# Literature update — 2026-09-14

## The planned ell = 1 mod 4 search has been superseded

Li Lai and Johannes Sprang, arXiv:2606.00633 (30 May 2026), prove failure of the P(t)-adic Littlewood conjecture for **every irreducible P(t) over every ground field of odd characteristic**. Therefore ell = 1 mod 4 is no longer an unresolved frontier.

This supersedes the 2025 Adiceam--Badziahin result, which handled characteristics ell = 3 mod 4 and explicitly left ell = 1 mod 4 open.

## Current frontier

The natural finite-field frontier is characteristic 2. A further useful confirmation comes from Badziahin--Pavlenkov--Zorin, arXiv:2608.22078 (22 Aug 2026): they prove strong Hausdorff-measure conclusions for t-adic exceptional sets in odd q, while stating that in characteristic two the analogous conclusion remains conditional on the existence of a counterexample.

This means the project should not spend compute searching for odd-characteristic counterexamples to the main conjecture: those now have a theorem. Odd characteristic remains useful for:

1. reproducing and simplifying the Lai--Sprang construction;
2. searching for sharper quantitative constants and finite-state descriptions;
3. developing exact certificate infrastructure that can later be applied in characteristic 2.

## Today's research hypothesis

For the Lai--Sprang explicit series in odd characteristic, write r=v_2(p-1), N=2^r. Their proof yields a uniform positive lower bound on the Littlewood product at a scale corresponding to a defect bound 2N. A computationally falsifiable strengthening is:

> For r >= 2, the explicit series may satisfy defect j-d <= N for every shifted polynomial multiplier t^m R with R(0) != 0.

Here d=deg R and j is the first nonzero coefficient of the fractional part of t^m R Lambda. This is **not** a claim about the main conjecture; it is an auxiliary sharp-constant question about a known counterexample.

The analogous N-bound cannot hold uniformly for r=1: the simple multiplier R=1+t^2, m=2 gives the 2N scale in the small cases motivating the search.

## Next exact computation

Implement finite-field linear algebra over F_p for the coefficient stream

```text
a_n = (N/2)(-1)^h  if oddpart(n)=1+Nh,
      0              otherwise.
```

For each p with r>=2 and ranges of m,d, solve for R coefficients that force the longest initial zero block after multiplication. Record exact witnesses whenever j-d>N. If no witness appears, mine the resulting nullspaces for a finite-state explanation rather than treating finite search as proof.

## Sources checked

- Li Lai, Johannes Sprang, *On the P(t)-adic Littlewood conjecture in odd characteristics*, arXiv:2606.00633.
- Faustin Adiceam, Dzmitry Badziahin, *On the P(t)-adic Littlewood Conjecture in Characteristics ell congruent 3 mod 4*, arXiv:2509.12826.
- Dzmitry Badziahin, Volodymyr Pavlenkov, Evgeniy Zorin, *Positive Logarithmic Hausdorff Measures of Exceptional Sets for the p-adic and t-adic Littlewood Conjectures*, arXiv:2608.22078.
