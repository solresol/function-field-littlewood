# Named Lai–Sprang support stream — 26 September 2026

Saturday formalisation, Australia/Sydney. Added `LaiSprangStream.lean` and its
root-module import. This identifies the saved F_17 prefix with the infinite
support formula and kernel-checks two further exact witnesses. Equality with
the original root-sum Laurent expression and the norm bridge remain unproved.

## Source and checkout audit

Started at approximately 08:21 AEST on clean main at f4c3a4d. Origin is
`git@github.com:solresol/function-field-littlewood.git`; fetch and fast-forward-only
merge found main current. No competing marker or experiment was found. Created
an exclusive ignored `.research/run.lock`. Read README, TODO, dated results/log,
automation memory and actual search/Lean sources. No repository AGENTS.md was
found; the supplied wording instructions apply.

`search/lai_sprang_finite_search.py` enumerates normalised coefficient vectors,
not ranks. It enforces both endpoints, tests indices 1 through the inclusive
cutoff, and records unresolved inputs. The separate affine solver enforces
r_0=1 and r_d nonzero. Its dot-product checker verifies the primal and dual
without trusting elimination or diagnostic rank. A kernel vector alone need
not have admissible endpoints. Certificates inspect through inclusive m+d+j;
unresolved output inspects through m+d+limit and establishes only a zero prefix.
Existing exhaustive-oracle, root-sum, endpoint, cutoff and mutation tests pass.
No solver changes or new search boxes were needed.

## Kernel-checked increment

- `oddCore` removes factors of two, with total convention oddCore(0)=0.
  `oddCore_dyadic` proves oddCore(2^k(2h+1))=2h+1 for every k,h.
- `laiSprangStream p r n` defines N=2^r and the support/sign formula, with a_0=0.
  Its Lai–Sprang interpretation requires odd prime p and r=v_2(p-1). The total
  definition asserts no such interpretation outside that domain. The concrete
  pairs (17,4) and (3,1) have the required parameter values.
- `laiSprangStream_dyadic` proves a(2^k n)=a(n) for every p,r,k,n.
- `laiSprang17_saved_prefix` identifies indices 0..32 of the saved fixture.
  The existing primal/dual checker transfers exact j=15 at d=0,m=17 and the
  optimality bound for every endpoint-nonzero multiplier to the infinite stream.
- `laiSprang17_sharp_first` proves j=16 for R=1,m=81, through index 97.
  Defect is 16=N. This formalises the recorded attainment; it is not an all-shift
  upper bound or a new search.
- `laiSprang3_comparison_first` proves j=6 for R=1+t^2,m=2, through index 10.
  Defect is 4=2N, preserving the r=1 comparison.
- Controls distinguish the F_17 fixture from the infinite stream at index 33
  and verify that the sharp witness vanishes at 15 and is nonzero at 16.

These statements use `fractionalCoeff`, the existing finite-sum semantics.
Neither root-sum equality nor the Laurent coefficient/norm bridge is assumed.
The all-shift degree-zero bound is still an ordinary proof in the 20 September
report; the all-degree auxiliary N-bound is still a hypothesis. No main-conjecture
counterexample or research novelty is claimed.

## Literature and attribution correction

Primary sources accessed **26 September 2026**, with current versions checked:

- [Lai–Sprang 2606.00633v1](https://arxiv.org/abs/2606.00633v1), 30 May 2026:
  odd-characteristic existence is settled for every irreducible P(t).
- [Badziahin–Pavlenkov–Zorin 2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  22 August 2026: the characteristic-two exceptional-set result is conditional.
  Scoped arXiv-indexed queries for Littlewood in characteristic two/2 and 2026
  t-adic results found no later settlement. This is a search boundary.
- [Robertson 2307.00955v3](https://arxiv.org/abs/2307.00955v3), 31 October 2025,
  and [Garrett–Robertson 2405.14454v2](https://arxiv.org/abs/2405.14454v2),
  8 April 2025: checked number-wall references.
- [Merta 1810.03533v3](https://arxiv.org/html/1810.03533v3#S3.SS1), 30 April 2020,
  published DMTCS 22:1, DOI 10.23638/DMTCS-22-1-15, and
  [Adiceam–Nesharim–Lunnon 1806.04478v2 §7.2](https://arxiv.org/html/1806.04478v2#S7.SS2),
  11 October 2020: rechecked the missed quadratic-series route for Rudin–Shapiro.
  The README and dated addition to the 25 September report now give the equation,
  encoding conversion and attribution. The original de Mathan–Teulié theorem
  is attributed through the latter primary paper, not a newly read full text.

Rudin–Shapiro's qualitative t-LC conclusion was already available; novelty of
the repository's particular dyadic formula remains unestablished. The old report
has only a dated attribution section added. Its original SHA256 remains in the
unchanged historical manifest and Git history. That snapshot manifest includes
README/TODO/log, so it is not expected to match today's amended documents.

## Validation

Lean/mathlib remain pinned to 4.27.0; mathlib commit is
`a3a10db0e9d66acbebf76c5e6a135066525ac900`. No dependency changes. Reused the
existing certificate, normalisation and polynomial modules; inspected mathlib's
ZMod field source and Apache-2.0 licence.

```sh
lake build
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
shasum -a 256 -c results/2026-09-26-sha256.txt
```

Final full build passes in 16.001997s, 1325 jobs, no warnings. All 48 printed
axiom reports (nine new) use only propext, Classical.choice and Quot.sound.
Source audit finds no sorry, admit, added axiom, unsafe or native_decide.
An early attempt unfolded recursion under a symbolic finite binder and hit a
simplifier stack overflow; the final proof enumerates finite cases before
arithmetic reduction. Only the successful final build output is retained.

All 27 Python tests pass in 3.072s (3.235930s subprocess time), including all
12,871 retained box optima, independent root-sum coefficients, r=1 comparisons,
dyadic readbacks, mutations and unresolved-cutoff controls. Three existing Lean
exports match (0.132499s). All 12 previous manifest entries passed before today's
edits; unchanged computational files are rechecked separately afterward.
Python 3.9.6, standard library only, deterministic, no random seed. Commands,
timings and outputs are in `2026-09-26-validation.json`; final build output and
axiom reports are in `2026-09-26-lean-build.txt`.

## Next work

Sunday: integrate the proof boundaries and key small certificates. Next Lean
increment: the generic degree-zero support bound or actual Laurent coefficient
bridge, followed by root-sum equality. Next computation: certify or refute the
three-term Lai–Sprang family at other N. Screen new binary streams for rational
or quadratic series and known unbounded number walls before treating them as
open candidates. Do not repeat retired Thue–Morse/Rudin–Shapiro scale searches.
