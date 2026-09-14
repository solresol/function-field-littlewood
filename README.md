# Function-field P(t)-adic Littlewood research

This repository tracks computational and formal work around the function-field `P(t)`-adic Littlewood conjecture.

## Status update (14 Sep 2026)

The original plan for this project was to focus on odd characteristics `ell = 1 (mod 4)`. That frontier has moved: Li Lai and Johannes Sprang, *On the P(t)-adic Littlewood conjecture in odd characteristics*, arXiv:2606.00633 (submitted 30 May 2026), prove that the conjecture fails for every irreducible `P(t)` over every ground field of odd characteristic.

Their explicit counterexample is built from

```text
r = v_2(p-1),   N = 2^r,
Lambda(t) = sum_{k>=0} sum_{zeta^(N/2)=-1}
              t^(2^k)/(t^(2^(k+1)) - zeta).
```

For the coefficient `a_n` of `t^(-n)` this simplifies to

```text
a_n = (N/2) (-1)^h   if oddpart(n) = 1 + N h,
      0               otherwise,
```

in `F_p`.  This is convenient for exact computation: no finite-field extension or rational-function arithmetic is needed to generate the series.

The remaining global finite-field frontier therefore appears to be characteristic 2. Earlier work by Garrett--Robertson explicitly described the odd-characteristic picture as complete except for characteristic 2, and Robertson's number-wall reformulation gives a combinatorial route to the remaining questions.

## Current computational question

Lai--Sprang prove a uniform positive lower bound for the Littlewood product. Their argument gives a defect bound corresponding to `2N`, where `N=2^r`. The first experiment in this repository asks whether the explicit `Lambda` has a sharper bound when `r>=2`.

Write `Q=t^m R`, with `R(0) != 0`, `deg R=d`, and let `j` be the first non-zero coefficient of the fractional part of `t^m R Lambda`. The Littlewood product is `2^(d-j)`. Thus a lower bound `2^(-B)` is equivalent to

```text
j - d <= B.
```

The search in `search/lai_sprang_finite_search.py` uses exact linear algebra over `F_p` to look for violations of the candidate strengthening

```text
j - d <= N   (r >= 2).
```

Initial data finds no violation for primes with `r>=2` in the tested boxes, while the analogous strengthening is definitely false for `r=1`: for every tested prime with `r=1`, `R(t)=1+t^2`, `m=2` gives defect `4=2N`. This also supplies a small exact witness showing that the published `2N` scale is sharp in the `r=1` case.

See `results/2026-09-14-lai-sprang-bound-search.md` for exact search ranges and witnesses.

## Near-term programme

1. Push the `r>=2` sharp-constant search much further and identify the finite-state/automatic structure behind the observed `N` bound.
2. Recast the search in number-wall language, where bounded zero windows are equivalent to counterexamples to `t`-LC.
3. Determine the precise current status in characteristic 2 and reproduce the strongest finite computations there.
4. On formalisation days, build Lean definitions for Laurent coefficient streams, the Toeplitz/Hankel certificate formulation, and exact finite certificate checking before attempting the analytic statement itself.

## References

- Li Lai and Johannes Sprang, *On the P(t)-adic Littlewood conjecture in odd characteristics*, arXiv:2606.00633 (2026).
- Faustin Adiceam and Dzmitry Badziahin, *On the P(t)-adic Littlewood Conjecture in Characteristics ell congruent 3 mod 4*, arXiv:2509.12826 (2025).
- Samuel Garrett and Steven Robertson, *Counterexamples to the p(t)-adic Littlewood Conjecture Over Small Finite Fields*, Mathematics of Computation (2025), DOI 10.1090/mcom/4104.
- Steven Robertson, *Combinatorics on number walls and the P(t)-adic Littlewood conjecture*, Mathematika 72 (2026), e70064, DOI 10.1112/mtk.70064.
