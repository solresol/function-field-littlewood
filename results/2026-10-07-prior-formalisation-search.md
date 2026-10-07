# Prior-formalisation search — 7 October 2026 (Wednesday, Australia/Sydney)

## Finding and decision

No earlier public Lean formalisation of the specific Lai–Sprang coefficient,
root-moment and geometric forced-factor package was found. This makes it a
candidate for a first public Lean formalisation of those components, but does
not establish priority. It is not a first mathematical proof: the underlying
root-moment/nonsquare argument occurs in Lai–Sprang, Section 3, equations
(3.8)–(3.10). The full counterexample theorem is not formalised here.

The user's publication criterion is a first proof or a first formalisation.
Keep Palomar submission on hold: the search has found no predecessor but has
not confirmed that criterion. If describing the present work, use “no earlier
public Lean formalisation of these components found in a search on 7 October
2026”, not “the first formalisation of the Littlewood counterexample”.

## Exact scope

Searched for predecessors to
`FunctionFieldLittlewood.Palomar.root_moment_package` at source commit
`8994e60823b1de499146fefd931b33a0c80e037d`, and its component theorems
`stream_root_enumeration`, `stream_filtered_root_enumeration` and
`geometric_parity_forced_factor`. The package constructs all roots of
`X^H+1`, identifies the sparse odd coefficients and polynomial filters with
root moments, and obtains divisibility in both parity children from a full
block of H weighted moments. It assumes that moment block; it does not derive
it from a parent window or iterate descent.

The unresolved bibliographic question was whether this particular formal
argument already exists, including under different names. A matching earlier
proof would remove the proposed first-formalisation rationale. Finding only
general library ingredients would narrow the possible claim to the particular
application, without certifying priority.

## Searches and source inspection

- GitHub repository searches: `littlewood lean`, `littlewood function-field`,
  `Lai Sprang`, and both spellings of `littlewood formalisation/formalization`.
  Only this repository was returned for `littlewood function-field`.
- GitHub code searches: the paper identifier `2606.00633`, `LaiSprang`,
  `Lai` with `Sprang`, `Littlewood`, `t-adic`, `P(t)-adic`, `number wall`,
  `root_moment`, `geometric_parity`, `paperfolding`, and combinations of
  `Vandermonde`/`nonsquare` and `parity`/`ZMod`/`IsSquare`, restricted to Lean
  where appropriate. The three pages of the broad Littlewood query were
  retrieved; result paths were screened, not every proof body audited.
- Direct [Palomar API](https://data.palomar-registry.org/api/v1/results)
  searches for `Littlewood`, `2606.00633`, `Lai Sprang`, `root moment` and
  `parity descent`: no matching package. The returned Littlewood entry concerns
  Riemann-zeta zero density; the three Lai/Sprang entries concern 2-adic zeta
  irrationality. The root/moment hit concerns Collatz convergence.
- Web searches combined paper identifier, author names and function-field or
  t-adic Littlewood terminology with Lean, formalisation and formalization;
  searches also targeted indexed Lean Zulip/community and Zenodo pages. These
  found no predecessor. This was not an authenticated full Zulip archive search
  or an exhaustive Zenodo API search.
- Read [Lai–Sprang v1](https://arxiv.org/html/2606.00633v1), especially Section 3.
  The mathematical argument is already there; its HTML contains no Lean mention.
- Inspected the pinned Mathlib source. Its
  [Vandermonde rigidity theorem](https://github.com/leanprover-community/mathlib4/blob/065356127b1dc0016f66b7283ce0ce2c4055aa55/Mathlib/LinearAlgebra/Vandermonde.lean#L259)
  already proves that a full block of power moments determines the weights.
  Our shifted-moment lemma applies this existing theorem. General Vandermonde
  rigidity is therefore not a first formalisation supplied by this project.

## Potential predecessors ruled out at the inspected scope

| Primary source | What was inspected | Why it is not the matching formalisation |
|---|---|---|
| [cross-theory-formal-database](https://github.com/AlexenderSokolov/cross-theory-formal-database/tree/e2f90006c4b4cb4fcd859fc1b98654bc62a0ba30) | README, paper-ID hit in `sources/208301/source0.tex`, complete non-truncated tree | A LaTeX human-proof corpus. The hit is a citation in the Badziahin–Pavlenkov–Zorin paper; the tree has no `.lean` files. |
| [Formal Conjectures](https://github.com/google-deepmind/formal-conjectures/blob/83397bad317ac2cf180ffd418f791b8613d1a78f/FormalConjectures/Wikipedia/LittlewoodConjecture.lean) | Complete Littlewood statement module | Statements with `sorry` for the real classical and p-adic conjectures, not a function-field proof. |
| [Garrett–Robertson computational source](https://github.com/Steven-Robertson2229/Counterexamples_to_the_p-t-_adic_Littlewood_Conjecture_Over_Small_Finite_Fields) | README and repository file listing | Python number-wall/tiling verification for earlier small-characteristic counterexamples, not this Lean argument. |
| [2-adic Littlewood Lean project](https://github.com/antidepersonalizationer/some-bounds-related-to-the-2-adic-littlewood-conjecture-open-problems) | README and stated result inventory | Real-number/continued-fraction results; some explicitly conditional results. Different mathematical setting. No independent audit of its proof claims was attempted. |
| [ArkLib Vandermonde](https://github.com/Verified-zkEVM/ArkLib/blob/35ddcaa83f683011f944f58904be779495a5709a/ArkLib/Data/Matrix/Vandermonde.lean) | Source definitions and rank results | “Nonsquare” means a rectangular matrix here, not a quadratic nonresidue. This is general coding-theory infrastructure. |
| [Atlas Cloitre sequence](https://github.com/facebookresearch/atlas-lean/blob/cb2c60fdc395a3c248c8eb0c6609872476716250/MathlibExt/Combinatorics/InfiniteWord/CloitreSequence.lean) | Source definitions and paperfolding occurrence | Infinite-word/run-sum definitions, not a Lai–Sprang root-moment or Littlewood counterexample proof. |
| [AINTLIB formal series](https://github.com/CBirkbeck/AINTLIB/blob/577a8e561a2585f7c5e420952ca26f3ce7bef968/projects/HasseWeil/HasseWeil/Isogeny/FormalSeries.lean) | Source declarations and t-adic occurrences | Elliptic-curve formal isogeny series, not this application. |

## Evidence and limits

The adjacent JSON records dated API queries, returned counts and paths, source
URLs/hashes, errors and retries. GitHub search was temporarily rate-limited;
failed attempts are retained separately from successful targeted responses.
The Sprang-only query remained partially retrieved. The final broad
Littlewood query's third page was recovered separately. Search counts changed
from 270 to 277 during the session, so this is not a stable corpus enumeration.
Initial Palomar requests returned HTTP 403; requests with an explicit User-Agent
and Accept header succeeded. Failed requests are not counted as empty results.

GitHub indexing, default-branch coverage, phrase/token matching and theorem names
limit these searches. Private, unpublished, deleted, unindexed or differently
expressed developments may exist. No source authors or Lean maintainers were
contacted. Absence from Palomar is not absence from Lean.

This is literature/provenance verification, not mathematical progress. No proof
or dependency changed and no new Lean build was needed. A stronger publication
target would be a complete formalisation of Lai–Sprang Proposition 2.3 or a
proved auxiliary strengthening, with the priority search refreshed at that
milestone. The immediate formal bridge remains parent-window-to-moments;
the all-degree auxiliary bound and characteristic-two frontier remain open
project targets.
