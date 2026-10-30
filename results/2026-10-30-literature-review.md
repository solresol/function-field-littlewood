# Weekly human-research search checkpoint — 30 October 2026 UTC

Accessed **30 October UTC / 31 October 2026 Australia/Sydney**. The previous
successful weekly review is the [24 October baseline](2026-10-24-literature-review.md)
(23 October UTC). This review searched with overlap from **17 October UTC**.

**No useful new or revised external result was located for either current
target.** This is a bounded search result, not an absence or priority claim.

## Current target and decision

Read the current README, TODO, research log and latest scope reports at
`7f550d837f17fb2d61b46096149393964b132313`. For odd prime p, put
`N=2^v₂(p−1)`. The auxiliary target remains `Δ_p=2N` for the named Lai–Sprang
stream, with Δ the supremum of `j−deg R` over nonnegative shifts and nonzero
R with `R(0)≠0`, where j is the first nonzero fractional coefficient. The
second target remains the finite-field characteristic-two P(t)-adic frontier.

The current internal target-to-product and even-shift stripping proofs are
verification of known arguments; they supply no uniform accepting path.
Reuse them. No literature result found changes the next structural question:
identify the transverse forcing/output response lost by the empty target
slices of the fixed `T(62,8)`/`T(126,8)` collision, retaining odd-shift
compatibility. Keep rational, quadratic and known unbounded-window binary
inputs retired. No further instance search or code work is warranted by this
checkpoint.

## Primary-source rechecks and reading decisions

- **Lai–Sprang, [2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  30 May 2026**, still the sole displayed version. Re-read
  [Theorem 1.2, Lemmas 2.1–2.2 and Proposition 2.3](https://arxiv.org/html/2606.00633v1).
  The ordinary preprint proof covers every field of odd characteristic p and
  every irreducible P over that field. Its base-two norm gives the lower
  bound `2^(−2N deg P)`, not equality or uniform attainment. Proposition 2.3
  excludes the stated overly good approximation when `t^N−1` divides Q;
  it does not construct terminal acceptance. Essential full reading remains
  recommended; no new revision needs reading.
- **Hofer, [2610.12691v1](https://arxiv.org/abs/2610.12691v1),
  8 October 2026**, unchanged. Rechecked
  [Theorem 1, the introduction and §4.3](https://arxiv.org/html/2610.12691v1).
  The Hankel/Ostrowski factorization is a method result; Example 3 and the
  ensuing transfer retain a positive approximation bound as a premise.
  Characteristic two is still identified there as the remaining case.
  Full reading remains useful for Hankel/block methods, with no supplied
  closure or accepting path for our particular state.
- **Badziahin–Pavlenkov–Zorin,
  [2608.22078v1](https://arxiv.org/abs/2608.22078v1), 22 August 2026**,
  unchanged. Rechecked [Theorems 3.1–3.2](https://arxiv.org/html/2608.22078v1#S3).
  The any-prime-power statement requires a nonempty exceptional set; the
  unconditional construction requires q odd. No characteristic-two existence
  or sharp constant for our fixed stream follows. Defer further full reading
  unless pursuing the metric question.

The previously recorded published Thue–Morse result remains available at
[Selecta, DOI 10.1007/s00029-026-01163-9](https://link.springer.com/article/10.1007/s00029-026-01163-9)
(9 July 2026; [2503.18749v1](https://arxiv.org/abs/2503.18749v1), 24 March 2025).
Its partial escape-of-mass conclusion does not give bounded deficiency; no
candidate is revived. The
[Mathematika publisher page](https://londmathsoc.onlinelibrary.wiley.com/doi/full/10.1112/mtk.70064)
dates Robertson's existing number-wall paper to **12 December 2025 first
publication**, in the January 2026 issue. This is not a new October result.

## Search coverage and access limits

Successful [arXiv API](https://export.arxiv.org/api/query) queries used
`sortBy=lastUpdatedDate`, descending, `max_results=100`; all records were
retrieved in each query, so both new submissions and revisions were screened:

| Query | Records | Updates on/after 17 October 2026 |
| --- | ---: | ---: |
| `all:Littlewood AND (all:"function field" OR all:"t-adic" OR all:"P(t)-adic")` | 18 | 0 |
| `all:"number wall" OR all:"number walls" OR (all:Hankel AND all:"Laurent series")` | 20 | 0 |
| `(all:"Laurent series" OR all:"formal power series" OR all:"number wall") AND (all:"characteristic 2" OR all:"characteristic two" OR all:"continued fractions" OR all:"bounded deficiency")` | 37 | 0 |

Unrelated title/keyword matches were excluded. Supplementary web searches used
characteristic-two/2, P(t)-adic, number-wall, sharpness and Hankel terms,
including AMS/Mathematics of Computation, Elsevier/Advances in Mathematics,
Wiley/Mathematika, Springer/Selecta and
[Robertson's author page](https://sites.google.com/view/stevenrobertson).
The author's p-Cantor links were screened at the primary abstract records:
[2510.19449v1](https://arxiv.org/abs/2510.19449v1) and
[2510.19417v1](https://arxiv.org/abs/2510.19417v1), both **22 October 2025**,
unchanged. These describe odd-prime Cantor/escape-of-mass results, not a new
characteristic-two or sharpness theorem; full proof auditing was not needed
for this date/scope screen. Automated expositions were not evidence.

Fresh primary records also retain Garrett–Robertson
[2405.14454v2](https://arxiv.org/abs/2405.14454v2) (8 April 2025), Robertson
[2307.00955v3](https://arxiv.org/abs/2307.00955v3) (31 October 2025), and
Adiceam–Badziahin [2509.12826v3](https://arxiv.org/abs/2509.12826v3)
(10 August 2026). The
[AMS issue page](https://www.ams.org/journals/mcom/2026-95-362/) and
[Elsevier article page](https://www.sciencedirect.com/science/article/pii/S0001870826004342)
returned HTTP 403. No inaccessible journal-text change, or identity of all
journal/arXiv text, is asserted. These gaps do not prevent the scoped checkpoint;
unindexed, unpublished and differently named work remains outside its coverage.

Next review: use this successful checkpoint with a seven-day overlap beginning
**23 October 2026 UTC**, and recheck versions/withdrawals at primary records.
Only this literature note and its roadmap handoff changed; no proof, search program,
dependency, runtime, schedule, author contact or user-machine access changed.
