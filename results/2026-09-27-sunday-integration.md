# Sunday integration: exact quadratic screens and retired binary baselines

Date: 27 September 2026 (Sunday, Australia/Sydney). Started at approximately
08:20 AEST, on clean main at a1d683c. Origin is
`git@github.com:solresol/function-field-littlewood.git`; fetch and fast-forward-only
check found no incoming changes. No competing run marker/process was present.

## Concrete increment

Added `search/binary_quadratic_screen.py`: exact evaluation of a supplied
relation A(x)Y²+B(x)Y+C(x) in F_2[x]/(x^M). It accepts canonical binary
coefficient vectors, includes index zero, and rejects a relation independent of Y.
It returns every residual coefficient through inclusive M-1. No tail is padded
and then interpreted as known. Zero residual is finite agreement only; a nonzero
residual disproves that particular relation for every extension of the prefix.
This is neither an algebraicity decision procedure nor a search over all relations.

The three existing binary baselines are all excluded as t-LC counterexamples
by ordinary recurrence identities and the known theorem on quadratic series.
Paperfolding is now explicitly retired as well. These are established baselines,
not new main-conjecture results. The new increment is a reproducible exact screen,
encoding controls, and consolidated proof boundaries.

## Equations for the actual repository encodings

Work in F_2[[x]], put x=t^(-1), and include a_0=0 in each generating function.
The following are ordinary all-index arguments, not Lean proofs or extrapolations
from the experiment. Frobenius gives Y(x²)=Y(x)².

**Thue–Morse.** For digit parity, a_(2n)=a_n and a_(2n+1)=a_n+1.
Splitting even and odd indices gives

```text
T = (1+x)T² + x/(1+x²),
(1+x)³ T² + (1+x)² T + x = 0.
```

**Paperfolding.** Our convention is a_n=1 if oddpart(n)=1 mod 4, and 0
otherwise for n>0. Thus a_(2n)=a_n and a_(2n+1)=1 precisely when n is even:

```text
P = P² + x/(1+x⁴),
(1+x⁴)P² + (1+x⁴)P + x = 0.
```

This derivation fixes the encoding directly. It avoids silently identifying our
sequence with the complementary positive-index convention used in some sources.

**Rudin–Shapiro.** For overlapping-11 parity b_n, b_(2n)=b_n and
b_(2n+1)=b_n+(n mod 2). Consequently

```text
B = (1+x)B² + x³/(1+x⁴),
(1+x)⁵ B² + (1+x)⁴ B + x³ = 0.
```

All identities follow formally because the displayed denominators are units.
For the complemented series B+1/(1+x), the added residual is
(1+x)⁵/(1+x)²+(1+x)⁴/(1+x)=0, so its equation is unchanged.
The signed ±1 sequence reduced in F_2 is instead the constant-one sequence;
substitution leaves residual x³ and therefore fails at index 3.

Each series has algebraic degree at most two over F_2(x). If rational, clearing
the denominator makes the fractional part zero, proving t-LC immediately. If
quadratic irrational, the published quadratic-series theorem applies. Thus no
irrationality claim is needed to exclude these three baselines. Failure of one
quadratic screen on a new stream would not show that it is nonquadratic or that
it is a Littlewood counterexample.

## Primary literature refreshed on 27 September 2026

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1)
  (30 May 2026): odd-characteristic main conjecture already disproved for every
  irreducible P(t). Our N-bound work is about its explicit series, not this frontier.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1)
  (22 August 2026): the characteristic-two exceptional-set conclusion remains
  conditional on a counterexample. No later resolution was found in scoped
  arXiv searches for Littlewood with “characteristic two”/“characteristic 2”.
  This is an evidence boundary, not a claim of exhaustive literature coverage.
- [Merta, arXiv:1810.03533v3, §2.1 equation (2) and §3.1 equation (8)](https://arxiv.org/html/1810.03533v3):
  published equations for digit parity and complemented Rudin–Shapiro. The
  recurrence derivations above identify the precise encodings used here.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, §7.2](https://arxiv.org/html/1806.04478v2#S7.SS2):
  quadratic paperfolding discussion and attribution of the quadratic-irrational
  t-LC theorem to de Mathan–Teulié (2004), DOI
  [10.1007/s00605-003-0199-y](https://doi.org/10.1007/s00605-003-0199-y).
  The theorem was checked in this primary research exposition; the original
  2004 full proof was not separately re-audited today.
- [Robertson, arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955v3)
  (31 October 2025) and
  [Garrett–Robertson, arXiv:2405.14454v2](https://arxiv.org/abs/2405.14454v2)
  (8 April 2025): current version records rechecked; number-wall route remains
  relevant. Do not interpret these earlier odd-characteristic frontiers as current.

No novelty is claimed for the equations or qualitative exclusions. This run
implements the rational/quadratic screening lesson from the earlier attribution
correction; it does not repeat dyadic scale expansion as new evidence.

## Exact finite experiment and independent checks

The retained JSON checks five prescribed encodings at M=1024 (indices 0–1023).
The three baselines and complemented Rudin–Shapiro have zero residual. The
signed reduction has first nonzero residual 3. These are prescribed relation
checks, not exhaustive multiplier searches. Every row records the polynomials,
precision, SHA256 of the coefficient and residual byte vectors, and explicitly
sets `infinite_identity_proved_by_check=false`.

Generation uses direct digit/pattern/support formulas and Frobenius. Independent
readback regenerates streams using even/odd recurrences and squares by the full
Cauchy convolution, without the generator or fast residual routine. It checks
the complete fixed set of cases and all semantic fields. Timing/environment
metadata is informational, not independently certified. Standard-library Python,
deterministic, seed null. Exact environment and runtimes are in the JSON records.

New tests exhaust all 32 length-five binary prefixes and 60 nontrivial triples
of length-two relation polynomials (1920 comparisons against convolution).
They check malformed inputs, polynomial truncation, six record-field corruptions,
missing/duplicated/reordered cases, and readback with generation disabled.
Flipping coefficient 64 of Rudin–Shapiro leaves the relation zero modulo x^64,
but produces a nonzero coefficient at 64 modulo x^65. Changing coefficient 65
does not affect that check. This gives a concrete regression against promoting
finite agreement to an infinite identity.

## Source audit and integrated status

Re-read `lai_sprang_finite_search.py`, `finite_rank.py`, independent stream
oracles, recent certificate tests, and the finite/named-stream Lean definitions.
The enumerator normalises r_0=1, enforces r_d nonzero, counts every input and
records unresolved cutoffs explicitly. Fractional coefficient j uses exactly
sum_i r_i a_(m+i+j), with inclusive endpoint m+d+j. The affine solver retains
both endpoint conditions; a dual refutes vanishing through j and a primal
attains j. The independent checker deliberately does not certify diagnostic rank.
These semantics remain valid; no solver changes were required.

| Claim | Evidence and remaining boundary |
|---|---|
| Odd-characteristic main counterexamples | Lai–Sprang literature theorem; not a new repository theorem |
| Characteristic-two main conjecture | No resolution found in the primary sources checked |
| Auxiliary all-degree j-d<=N for r>=2 | Finite support only; still a hypothesis |
| Degree-zero maximum N at all shifts | Ordinary proof from 20 September; generic Lean proof outstanding |
| r=1 defect 4 comparison | Retained exact witnesses; F_3 named-stream certificate in Lean |
| Binary baselines satisfy t-LC | Known quadratic theorem plus exact recurrences; TM/RS also have ordinary explicit families |
| 12,871 saved box optima | Independent finite primal/dual checking; not all instantiated in Lean |
| Named-stream Lean statements | Selected TM and Lai–Sprang prefixes/certificates; generic all-scale bounds not formalised |
| Laurent/root-sum interpretation | Coefficient and norm bridge plus infinite root-sum equality still unformalised |

All 31 Python tests pass (2.976s, 3.101627s subprocess); three saved Lean
exports match. The pinned Lean build passes in 6.723141s, 1325 jobs, with 48
axiom reports containing only propext, Classical.choice and Quot.sound. No
sorry, admit, added axiom, native_decide or unsafe token occurs in project Lean
sources. Python is 3.9.6; baseline generation takes 0.005052s and independent
readback 0.199281s. The build is cached/replayed where unchanged; no new Lean theorem
is claimed. Raw outputs and timings are in `2026-09-27-validation.json` and
`2026-09-27-lean-build.txt`. Before documentation edits, all 15 entries in the
26 September hash manifest passed. Historical manifests remain snapshots and
are not rewritten when later documentation changes.

```sh
python3 -m search.binary_quadratic_screen .research/quadratic-reproduction.json
python3 -m search.binary_quadratic_screen results/2026-09-27-binary-quadratic-screen.json --verify
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
lake build
shasum -a 256 -c results/2026-09-27-sha256.txt
```

Use an absent path for fresh generation; the command refuses to overwrite files.
The next informative computation is the proposed Lai–Sprang three-term witness
R=1-t^(N-1)+t^N, m=9N+3, at other r>=2, with exact failure/attainment records.
Only N=16 is established by the prior box. Next formal lemma: connect the
finite coefficient sum to actual Laurent multiplication; then generic
degree-zero support/attainment. Screening a new binary candidate requires an
all-index argument and primary attribution before it can be retired.
