# Weekly human-literature checkpoint — 6 November 2026 UTC

Latest checkpoint: [13 November 2026](#13-november-2026-checkpoint).

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

## 13 November 2026 checkpoint

Previous successful review: 6 November above. Search cutoff **13 November
2026, 23:43 UTC**, overlap **30 October UTC**, including revisions. Sources
accessed 13 November. Read current roadmap, research log and dyadic-ray records
on fetched main `ba019ecd09e791b13606a38e4d2e900e43c93286`.

**No usable new or revised source was located for either exact target:**
`Δ_p=2N`, `N=2^v₂(p−1)`, for every odd prime in the named Lai–Sprang stream,
and the finite-field characteristic-two P(t)-adic frontier. The fixed five-digit
selector has an all-prime obstruction on its N=4 ray, accepting only p=5 at the
initial exponent. Seek a prime-dependent criterion meeting the actual reachable
lines with simultaneous target compatibility, or change the family. The refuted
`j−d<=N` bound and retired quadratic binary streams stay retired.

[Lai–Sprang](https://arxiv.org/abs/2606.00633) remains **v1, 30 May 2026**.
Re-read Theorem 1.2 and its reduction: the lower bound `2^(−2N deg P)` covers
every ground field of odd characteristic and irreducible P, without uniform
attainment. This is the known starting paper; full reading remains essential.
[Hofer](https://arxiv.org/abs/2610.12691) remains **v1, 8 October**;
Example 3/§4.3 retain the positive approximation-bound premise. Its method is
an optional full read, not a characteristic-two construction.
[Badziahin–Pavlenkov–Zorin](https://arxiv.org/abs/2608.22078) remains **v1,
22 August**; Theorems 3.1–3.2 retain nonemptiness for arbitrary q and odd q for
the explicit unconditional family. These are supplied preprint proofs; no
independent formal replay or new full-reading priority follows.

The arXiv API reran the exact three queries above, `lastUpdatedDate` descending,
`start=0`, `max_results=100`: **18/18**, **21/21** and **37/37** records,
respectively, with **zero** updates from 30 October in each. Supplementary
searches covered AMS/Mathematics of Computation, Advances in Mathematics,
Mathematika and Springer primary sources. The known published odd `3 mod 4`
result was rechecked at its publisher abstract; no journal full-text audit or
textual-identity check is claimed. Real-number uniform Littlewood results were
excluded from this finite-field target. Earlier journal access gaps remain;
unindexed/differently named work is outside coverage. This is a bounded search
result, not a novelty claim. Next overlap: **6 November UTC**.

Parent cleared overlap; only this existing literature record changes.
Documentation only: no experiment, Lean build, shared startup execution,
external artifact replay, dependency/runtime, schedule or user-machine work.
