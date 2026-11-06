# Weekly human-literature checkpoint — 6 November 2026 UTC

Scheduled 23:00 UTC / 7 November Sydney; sources accessed **6 November UTC**.
Previous successful review: [30 October](2026-10-30-literature-review.md).
Searched new submissions and revisions with overlap from **23 October UTC**.

**No usable new or revised source was located for either current target.**
This is a bounded negative result, not an absence or novelty claim.

## Exact targets and next research choice

Read current README, TODO, research log, prior review and the 6 November
selector report on fetched main `3d8199eab5be996f76a5efd1bbc46030178ddc23`.
For odd prime `p`, set `N=2^v₂(p−1)`. The auxiliary target is `Δ_p=2N` for
the specified Lai–Sprang stream: Δ is the supremum of `j−deg R` over shifts
`k>=0` and nonzero `R` with `R(0)≠0`, where `j` is the first nonzero fractional
coefficient of the shifted product. The second target is the **finite-field
characteristic-two** P(t)-adic Littlewood frontier.

The old bound `j−deg R<=N` is refuted. The fixed F_5 seven-relation collision
now has distinct terminal languages, but that finite separation is not a
uniform sharpness proof. Seek a state-dependent selector on a reachable family
forcing a compatible accepting parameter uniformly in the prime. Do not repeat
the fixed-pair suffix search, attained instances, or retired quadratic binary
inputs. The literature screen does not change this choice.

## Primary rechecks and reading decisions

- Lai–Sprang, [2606.00633](https://arxiv.org/abs/2606.00633), still has only
  **v1, 30 May 2026**. Re-read
  [Theorem 1.2 and the reduction](https://arxiv.org/html/2606.00633v1).
  For every field of odd characteristic and every irreducible P, the explicit
  stream has a positive product lower bound `2^(−2N deg P)` in the paper's
  base-two norm. This is a mathematical proof of failure of the conjecture,
  not uniform attainment of that bound. Essential full reading remains
  recommended; the superseded odd `p=1 mod 4` existence search stays retired.
- Hofer, [2610.12691](https://arxiv.org/abs/2610.12691), remains **v1,
  8 October 2026**. Re-read its
  [introduction and Example 3/§4.3](https://arxiv.org/html/2610.12691v1).
  Hankel/Ostrowski and digital-sequence descriptions retain a positive
  approximation-bound premise for transferring a counterexample. They do
  not supply our accepting path or a characteristic-two construction.
  Full method reading remains useful, with no new revision to prioritize.
- Badziahin–Pavlenkov–Zorin,
  [2608.22078](https://arxiv.org/abs/2608.22078), still **v1, 22 August 2026**.
  Rechecked [Theorems 3.1–3.2](https://arxiv.org/html/2608.22078v1): the
  any-prime-power metric result assumes nonemptiness; the explicit
  unconditional family requires odd q. These preprint proofs do not settle
  characteristic two or fixed-stream equality. Further full reading can wait
  unless the metric question becomes relevant.

## Coverage and limits

The [arXiv API](https://export.arxiv.org/api/query) used `lastUpdatedDate`
descending, `start=0`, `max_results=100`; all records in these queries were
retrieved and their dates/titles screened:

| Query | Retrieved / total | Updates since 23 October |
| --- | --- | --- |
| `all:Littlewood AND (all:"function field" OR all:"t-adic" OR all:"P(t)-adic")` | 18 / 18 | 0 |
| `all:"number wall" OR all:"number walls" OR (all:Hankel AND all:"Laurent series")` | 21 / 21 | 0 |
| `(all:"Laurent series" OR all:"formal power series" OR all:"number wall") AND (all:"characteristic 2" OR all:"characteristic two" OR all:"continued fractions" OR all:"bounded deficiency")` | 37 / 37 | 0 |

The additional wall-query record relative to last week concerns airflow, not
number-wall mathematics. Supplementary searches covered AMS/Mathematics of
Computation, Elsevier/Advances in Mathematics, Wiley/Mathematika and
Springer/Selecta sources. The published odd `3 mod 4` result and Thue–Morse
escape-of-mass paper are already recorded; neither reopens a retired target.
No new journal result matching the exact objectives was located. Older journal
full-text gaps in the prior review remain; no journal/arXiv textual identity
or exhaustive coverage is asserted. No other bot's claimed progress was used.

Next overlap starts **30 October UTC**. Documentation only: no experiment,
proof, pin, schedule or remote-machine work changed. The full shared startup
check failed at missing `scholz-ready.json` after thesis and Littlewood imports
passed. No further Lean work, preparation or environment repair was attempted.
