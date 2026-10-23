# Weekly human-research literature review — 24 October 2026 (Australia/Sydney)

First weekly baseline: the 14 September literature note and subsequent daily
source screens are useful history, but no earlier completed weekly handoff was
found. All sources below were accessed **24 October 2026 Australia/Sydney**
(23 October UTC). Source/version dates below are not crawl or typeset `today`
dates. Human-attributed papers are distinguished from autonomous-agent claims;
none of this review's source reading is new internal proof progress.

## Exact targets and current internal state

Read `TODO.md`, the 14 September note, recent research reports, catalogue scope
and the actual `TerminalLift.lean` statements at
`c7b2a988ff0661baf9308c3ac3c3d71c455141f1`.
For odd prime `p`, put `r=v₂(p-1)` and `N=2^r`. For the named Lai–Sprang series,
`Δ_p` is the supremum of `j-deg R` over shifts `m>=0` and nonzero polynomials
`R` with `R(0)≠0`, where `j` is the first nonzero fractional coefficient of
`t^m R Λ`. The current auxiliary question is **`Δ_p=2N` for every odd prime**.
The second target is the **finite-field characteristic-two P(t)-adic frontier**,
after excluding rational/quadratic and already understood unbounded-window inputs.

Internal baseline, not external discoveries: `j-d<=N` is refuted; the six N=4
prime witnesses are kernel-checked, and p=41 is computationally verified. The
24 October uniform dyadic lift gives product `2^(-2N)` **given an
endpoint-admissible exact terminal certificate**. Uniform terminal existence and
the boundary-target-to-exact-certificate bridge are not supplied. Square-only
compression is already refuted. Do not restart odd-characteristic existence,
the N-bound, routine witness exports or larger retired binary boxes.

## Primary theorem recheck: established background

Li Lai and Johannes Sprang,
[*On the P(t)-adic Littlewood conjecture in odd characteristics*](https://arxiv.org/abs/2606.00633v1),
v1 **30 May 2026**, still the only displayed version. Started here and read
[Theorem 1.2, Lemmas 2.1–2.2, Proposition 2.3 and the descent argument](https://arxiv.org/html/2606.00633v1).
For **any field K of odd characteristic p** and **any irreducible P in K[t]**,
the explicit `Λ(P)` has Littlewood infimum at least
`2^(-2^(r+1) deg P)`, with the paper's base-two degree norm.
This is a lower bound, not an equality/attainment theorem.
Proposition 2.3 excludes nonzero `Q` divisible by `t^N-1` with
`|<Q t^m Λ>| < 1/|Q|`; it does not assert an accepting terminal witness exists.
Lemma 2.1 transports the t-adic constant to irreducible P and Lemma 2.2 handles
extension-field coefficients. Classification: **preprint theorem with an ordinary
proof; not a newly published result or a full Lean theorem in this repository**.
Keep this short paper as essential reading; no source located here upgrades its
bound to uniform `Δ_p=2N`.

Badziahin–Pavlenkov–Zorin,
[*Positive Logarithmic Hausdorff Measures…*](https://arxiv.org/abs/2608.22078v1),
v1 **22 August 2026**, unchanged. Read
[Theorems 3.1–3.2 and Lemma 3.4](https://arxiv.org/html/2608.22078v1#S3).
For every prime power q, Theorem 3.1's infinite logarithmic Hausdorff measure
conclusion assumes the exceptional set is **nonempty**. The stronger
construction/measure theorem assumes **q odd**, with exponent
`A_q=(q-1)log₂(q-1)/2`. Its norm is `q^degree`, not our base-two convention.
Classification: **preprint theorem, proof not independently audited here**.
It provides no characteristic-two existence theorem and no exact sharpness
constant for our fixed stream. Full reading is worthwhile for metric questions,
not required to repeat the present terminal-lift work.

## Newly located baseline source and deeper reading of an existing lead

**Nesharim–Shapira–Soffer Aranov,**
[*Escape of mass of the Thue-Morse sequence*](https://doi.org/10.1007/s00029-026-01163-9),
**Selecta Mathematica 32, article 69, published 9 July 2026**;
[arXiv:2503.18749v1](https://arxiv.org/abs/2503.18749v1), **24 March 2025**.
This source was not found in the existing repository records. Read the publisher's
§1.1–1.2 and Theorem 1.14: it proves an explicit substitution/coding description
of the binary Thue–Morse number wall and disproves a **full escape-of-mass**
conjecture. The theorem's tiling proof uses finite computer verification as an
ingredient. The same introduction retains unbounded shifted partial-quotient
degrees for quadratic Laurent series.
Classification: **published mathematical/computer-assisted result**, not reproduced
here. Partial escape does not give bounded deficiency or a Littlewood
counterexample. It reinforces retirement of binary Thue–Morse. Full reading is
worthwhile for number-wall symmetry/tiling methods; it is not a reason to restart
that candidate or infer compression of our eight correlated relations.

**Roswitha Hofer,**
[*Hankel Matrix Decompositions and Digital Sequences over Function Fields*](https://arxiv.org/abs/2610.12691v1),
v1 **8 October 2026**, no later version displayed. Already noticed in the
23 October report; this review adds inspection of
[Theorem 1 and §§4.2–4.3](https://arxiv.org/html/2610.12691v1).
Theorem 1 constructs triangular factors and a block factor of a Hankel matrix
from the continued-fraction/Ostrowski data of a fractional Laurent series over
a field. Example 3's digital `(t,2)` characterization assumes the corresponding
uniform positive approximation bound; it does not construct such a series.
The introduction explicitly retains characteristic 2 as the remaining
finite-field P(t)-adic case. The author states the mathematics was developed
without AI; AI was used for presentation/language.
Classification: **preprint theorem/method, not a frontier resolution**.
Full reading is worthwhile when designing a bordered-relation argument,
especially where continued-fraction block boundaries replace invertibility of
individual minors. No four-square reconstruction or uniform accepting path for
the Lai–Sprang stream follows from the statements inspected.

## Characteristic-two candidate screen retained

- Rational series are excluded by clearing a denominator; a finite failed
  recurrence search does not prove irrationality or nonquadraticity.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2](https://arxiv.org/abs/1806.04478v2),
  **11 October 2020**, [§7.2](https://arxiv.org/html/1806.04478v2#S7.SS2), gives
  the binary paperfolding/pagoda quadratic identities and the quadratic-series
  exclusion. The discussion after Theorem 2.6 explicitly explains unbounded
  binary Thue–Morse deficiency. This is published background (Duke Math. J.,
  2021), not a new obstruction from this review.
- [Garrett–Robertson, arXiv:2405.14454v2](https://arxiv.org/abs/2405.14454v2),
  **8 April 2025**, [§5](https://arxiv.org/html/2405.14454v2#S5), reports known
  unbounded-window examples. Its general automatic-number-wall assertion is
  **Conjecture 5.1**, not a theorem licensed for arbitrary automatic streams.
  Automaticity alone also does not imply bounded windows. The printed
  Conjecture 1.8 is not substituted for Lai–Sprang's proved constant; no
  author-confirmed correction of its exponent is claimed here.
- The [27 September exact recurrence screens](2026-09-27-sunday-integration.md)
  already handle this repository's digit-parity Thue–Morse, regular paperfolding
  and overlapping-11 Rudin–Shapiro conventions. They remain retired. No new
  binary candidate was selected, so no finite prefix was promoted to an infinite
  nonquadraticity or bounded-window claim.

## Decision, checkpoint and limits

**No new external resolution of uniform sharpness or characteristic-two existence
was located.** This is a scoped search result, not an assertion of absence or
novelty. The substantive plan stays four-square bordered-relation reconstruction
(including singular blocks) or uniform accepting paths. Reuse the completed
conditional lift. The July Selecta paper is new to this baseline, while Hofer,
Lai–Sprang and the August measure paper were already known background.

Queried the [arXiv API](https://export.arxiv.org/api/query), sorted by
`lastUpdatedDate` descending, for new submissions **and revisions**, across all
indexed dates to establish the baseline:

- `ti:Littlewood AND (all:"function field" OR all:"t-adic" OR all:"P(t)")`:
  13 results, all retrieved.
- `all:Littlewood AND (all:"t-adic" OR all:"P(t)-adic" OR all:"function fields")`:
  18 results, all retrieved; this broader query also finds Hofer.
- Supplemented with characteristic two/2, Lai–Sprang/sharpness, number-wall and
  Thue–Morse searches, then primary Springer/Selecta, AMS/Mathematics of
  Computation, Mathematika/Wiley, Advances in Mathematics and author sources.

The publisher search located Adiceam–Badziahin's Advances in Mathematics 503
(October 2026), article 111213; its primary
[arXiv:2509.12826v3](https://arxiv.org/abs/2509.12826v3) is dated
**10 August 2026**. This remains the older `p≡3 mod 4` result, superseded for
existence by Lai–Sprang. The publisher's full page returned 403, so no separate
journal-text/exponent change is asserted. Some other publisher pages also
restricted access; their snippets were discovery leads, not proof evidence.
The Selecta paper was found by the supplementary number-wall search, illustrating
the limits of Littlewood-title queries.

Next review: search since this checkpoint with a seven-day overlap beginning
**17 October 2026 UTC**, recheck exact versions/withdrawals, and do not interpret
unchanged daily source checks as a new weekly result. No proof, catalogue claim,
search program, dependency, runtime, schedule, author contact or user machine was
changed. Prepared-runtime `check.py` passed; only documentation validation and
applicable triggered CI are relevant to these edits.
