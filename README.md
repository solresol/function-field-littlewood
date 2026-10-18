# Function-field P(t)-adic Littlewood research

This repository tracks computational and formal work around the function-field `P(t)`-adic Littlewood conjecture.

The [daily research automation](AUTOMATION.md) runs on raksasa; its udara copy
was paused after the 12 October 2026 handoff.

The first research software release is **Root-moment rigidity for the
Lai–Sprang Littlewood series in Lean 4**; see [v0.1.0](releases/v0.1.0.md)
for its exact theorem, limitations and reproduction commands. Citation metadata
is in [CITATION.cff](CITATION.cff), with [Apache-2.0 licensing](LICENSE) and
mathematical attribution and AI disclosure in [NOTICE](NOTICE). The public
archive is [Zenodo DOI 10.5281/zenodo.23117611](https://doi.org/10.5281/zenodo.23117611).

## Proof catalogue and provenance

[THEOREMS.md](THEOREMS.md) indexes the completed Lean theorem groups.
[theorem-catalogue.yaml](theorem-catalogue.yaml) records their exact statements,
assumptions, source declarations, verified commits, audits and archive coverage.
[formalization.yaml](formalization.yaml) supplies standard project provenance,
AI-use disclosure and the current formalisation scope.

The catalogue distinguishes Lean theorems from ordinary proofs and open targets.
The published v0.1.0 DOI names the frozen 3 October source; later development,
including the 6 October root-stream identity, is not included in that archive.
Palomar registration is not yet submitted; its preparation requirements are in
[the comparison package](PALOMAR.md).

The [Palomar comparison package](PALOMAR.md) independently states and proves
the combined root-moment component. Its sandboxed Comparator check and Lean,
NanoDa and con-ron replays passed on 7 October. Current development uses Lean 4.35.0-rc2;
the frozen v0.1.0 release retains its original Lean 4.27.0 pin.

## Result on 17–18 October 2026: the Lai–Sprang constant is attained

The repository's auxiliary hypothesis j-d<=N for r>=2 is **false**. Over F_5,
R(t)=S(t^4) with S=(1+t+t^2+t^3)(2+t+t^2+t^3+3t^4+3t^5+t^6+t^7+t^8) has
degree 44. At shift 1244 its first nonzero fractional coefficient has index 52:
defect 8=2N and Littlewood product 2^-8. This is kernel-checked for the actual
polynomial and the infinite named stream in
[Sharpness.lean](FunctionFieldLittlewood/Sharpness.lean) (`sharp5_refutes_N_bound`).
[ReverseLift.lean](FunctionFieldLittlewood/ReverseLift.lean) formalises the reverse
lift and kernel-checks the p=13 case the same way (`sharp13_refutes_N_bound`).
[FastCertificate.lean](FunctionFieldLittlewood/FastCertificate.lean) adds a sound
natural-number certificate checker; with it the non-default target
`lake build SharpnessCertificates` kernel-checks p=29, 37, 53 and 61 as well.

Exact certificates, read back from original root sums, give defect 2N also
for p=13, 29, 37, 53, 61: every N=4 prime up to 61. For these six primes the
N-or-2N dichotomy selects 2N.
Lai–Sprang's Theorem 1.2 bound 2^(-2^(r+1) deg P) is then attained for every
irreducible P over every field of that characteristic. Least multiplier degrees
over all shifts are 44, 316, 1316, 4548, 4524 and 8344 (computer-assisted
covers).

The search uses a continued-fraction reformulation: Delta_p=2N exactly when
some <t^M (1+t+...+t^(N-1)) Lambda> has a partial quotient of degree N+1.
Every prime with N>=8 remains undecided. A random-model heuristic
predicts witnesses near quotient degree p^(N/2), far beyond feasible N>=8
searches, so empty ranges there are not evidence for N.

The printed exponent in Garrett–Robertson's Conjecture 1.8 conflicts with
Adiceam–Nesharim–Lunnon's F_3 theorem. Their level-two F_5 series also reaches
deficiency 8; the intended exponent is plausibly 2^(n+1). See
[the report](results/2026-10-17-lai-sprang-sharpness.md). Dated sections below
are historical; their statements that the all-degree N-bound is open are superseded.

## Bounded boundary relation on 19 October 2026

An ordinary structural lemma reduces the terminal Hankel problem to a relation
in F_p^(2N), retaining forcing coefficients and evaluations at all N-th roots.
Parity recursion merges two child relations using only 3N variables, independent
of quotient degree. Lai–Sprang Proposition 2.3 excludes invisible kernel vectors
in the nearly square blocks; a terminal event is membership of one fixed vector.
Primitive-root moments alone fail on the existing p=5 witness.

This is **mathematical progress on the successor sharpness question**, supported
by exact root-sum and independent affine checks. It does not decide a new prime,
establish reachable-state closure, or advance characteristic two. See
[the proof and bounded checks](results/2026-10-19-boundary-relation.md).
The next question is correlated reachability of these relations, not a larger
search box or additional attainment examples.

## Weekly integration on 18 October 2026

Independent small checks reproduce the p=5 least degree 44 and exact index 52,
including expansion from the original rational definition. The earlier boundary
exclusions remain consistent with that witness. The pinned default Lean build
and sharpness axiom audit pass. This integration is **verification/infrastructure
progress**, with no new mathematical result. The random-model search scale for
N>=8 is unproved; automaticity supplies a case-count upper bound, not independent
trials. See [the integration record](results/2026-10-18-sunday-integration.md)
and [the revised roadmap](TODO.md).

## Sparse-divisor obstruction formalised on 17 October 2026

[SparseDivisor.lean](FunctionFieldLittlewood/SparseDivisor.lean) proves that
`a+2X+X^2+X^4+...+X^(H/2)+sigma*X^H` cannot divide `X^(2H)+1`
for every dyadic H>=4 over any field with 2!=0, when sigma^2=1.
This is **verification/infrastructure progress** on the algebraic step in the
16 October first-strip proof. The actual-row antiperiodic convolution bridge
and full shift localization are not formalised by this theorem. The two
residual degree-H shift classes remain unresolved uniformly; the all-degree
N-bound was subsequently refuted as described above.
See [the statement, proof and checks](results/2026-10-17-sparse-divisor.md).

## Stronger formal cutoff completed on 15 October 2026

[TerminalGap.lean](FunctionFieldLittlewood/TerminalGap.lean) proves the actual
original-row terminal exclusion for every nonzero quotient V with deg V<N/2,
then iterates the existing descent to give a nonzero row among 1,...,d+N
at every shift whenever **d<N(3N/2-1)**. The proof derives the needed gaps
from the infinite support stream and imposes no constant-coefficient condition.
This is **verification/infrastructure progress** on the 9/14 October ordinary
proofs, not a new mathematical bound. The stronger certified boundary cutoffs,
all-degree question and characteristic two remain separate. See
[the proof scope and checks](results/2026-10-15-terminal-gap.md).

## Formal degree cutoff completed on 13 October 2026

[DescentStep.lean](FunctionFieldLittlewood/DescentStep.lean) now proves the
complete surplus-halving step and iterates it: any nonzero polynomial with
`d+N` zero rows has `d>=N(N-1)`. Thus at every shift and degree
`d<N(N-1)` the named stream has a nonzero row among `1,...,d+N`.
All degree/shift parities, shift zero and arbitrary constant coefficients are
included. This is **verification/infrastructure progress** on the ordinary
2 October argument, not a stronger mathematical bound. The low-degree terminal
cutoff was subsequently formalised on 15 October; the all-degree bound and
characteristic two remain outside this theorem.
See [the proof scope and checks](results/2026-10-13-descent-cutoff.md).

## Formal step completed on 10 October 2026

[ParentWindow.lean](FunctionFieldLittlewood/ParentWindow.lean) now derives
finite parity rows and quotient degree budgets from an actual factored
parent window, then forces the next binomial factor in both canonical children.
All four degree/shift parities and shift zero are included. This is
verification/infrastructure progress on the ordinary descent; leading-child
selection and iteration were subsequently completed on 13 October. No all-degree
or characteristic-two result is claimed. See [the statement and limits](results/2026-10-10-parent-window.md).

## Formal step completed on 8 October 2026

[WindowMoments.lean](FunctionFieldLittlewood/WindowMoments.lean) derives the
full root-moment block from finite parity-row windows with exact row budgets,
then proves the geometric forced factor for the named Lai–Sprang stream.
Zero parity quotients and shift zero are included. This is verification progress
on the 2 October ordinary descent proof, not a new mathematical result.
The parent-window split is now connected above; child degree/shift selection
and iteration were completed on 13 October; the auxiliary all-degree bound
is unresolved.
See [the exact statement and limits](results/2026-10-08-window-moments.md).

## Status update (6 Oct 2026)

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

The remaining finite-field frontier appears to be characteristic 2. This was rechecked on 18 October 2026: Badziahin--Pavlenkov--Zorin, [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1), still make their characteristic-two exceptional-set conclusion conditional on the existence of a counterexample. No later resolution was found in the scoped primary-source search; this is an evidence boundary, not a proof of absence. Robertson's number-wall reformulation gives a combinatorial route to the remaining questions.

## Current computational question

Superseded on 17 October: the auxiliary N-bound is false for p=5,13,29,37,53,61
(section above). The paragraphs below record the earlier cutoff work.

**16 October two-residue localization:** for every dyadic N>=8, an odd-shift
terminal failure at quotient degree H=N/2 must have
`M=1-N or 1-H modulo NH`. Three explicit row arguments exclude the other
exceptional strips, including an antiperiodic sparse-divisor obstruction whose
reflection product has a forbidden nonzero x^6 coefficient. This is a uniform
**auxiliary mathematical increment**, not a new all-shift cutoff or an
all-degree result. The two residual classes remain open uniformly in N;
N=8,16 were already handled by finite certificates. See
[the ordinary proof and checks](results/2026-10-16-two-strip-localization.md).
This boundary problem is now deferred: completing it cannot restore the
refuted all-degree N-bound. The current structural question is in [TODO.md](TODO.md).

**14 October uniform dyadic-gap lemma:** original-row differences have an
explicit triangular minor with determinant a signed power of 1 or 2 whenever
`e+u<N`, where `q=floor((M+e)/N)` and `u` is the largest power of two at most
`N/2` dividing the even member of `{q,q+1}` (use `u=N/2` at q=0).
This excludes those terminal windows for every dyadic N>=4 and every odd
characteristic. At quotient degree e=N/2, any remaining terminal failure must
have `q=0 or -1 mod (N/2)`: only a fraction 4/N of shifts remain when N>=8.
An actual N=8 example shows why a single zero gap does not finish the proof.
This is **auxiliary mathematical progress**, without a new all-shift degree
cutoff or an all-degree result. See [the proof and limits](results/2026-10-14-dyadic-gap.md).
The 16 October argument above further reduces those odd-shift strips to two residues.

**12 October prime-independent boundary exclusion:** the all-shift cutoffs
are now **d<24,96,384 for every prime with r=v_2(p-1)=2,3,4**, respectively.
Integer maximal-minor gcd certificates extend the
[11 October four-field result](results/2026-10-11-sunday-integration.md)
to all primes in those classes. The stronger all-odd-characteristics rank
hypothesis fails at N=4 modulo 3; that characteristic is inadmissible for
the N=4 Lai–Sprang stream. This is mathematical progress by an ordinary
argument and exact finite proof, not an all-degree or Lean theorem.
Dependence on N remains: the next question is a dyadic row identity controlling
admissible prime divisors uniformly, not more primes or routine larger covers.
See [the proof, failure control and checks](results/2026-10-12-prime-obstruction.md).

**9 October structural result:** the auxiliary bound holds at every shift
for **d<N(3N/2-1)** when r>=2, improving the earlier cutoff N(N-1).
The ordinary proof excludes terminal quotients of degree below N/2: their
norm congruence forces a monomial, and two original adjacent stream rows
rule out that case. A nonmonomial boundary example at quotient degree N/2
shows where this argument stops; it is not a terminal counterexample.
See [the proof and exact controls](results/2026-10-09-terminal-low-degree.md).
This is auxiliary mathematical progress, not an all-degree result or
characteristic-two construction. Its low-degree cutoff was formalised on 15 October.

Lai--Sprang prove a uniform positive lower bound for the Littlewood product. Their argument gives a defect bound corresponding to `2N`, where `N=2^r`. The first experiment in this repository asks whether the explicit `Lambda` has a sharper bound when `r>=2`.

Write `Q=t^m R`, with `R(0) != 0`, `deg R=d`, and let `j` be the first non-zero coefficient of the fractional part of `t^m R Lambda`. The Littlewood product is `2^(d-j)`. Thus a lower bound `2^(-B)` is equivalent to

```text
j - d <= B.
```

The search in `search/lai_sprang_finite_search.py` exhaustively enumerates coefficient vectors over `F_p`, normalised by `r_0=1`, to look for violations of the candidate strengthening

```text
j - d <= N   (r >= 2).
```

**2 October structural result:** an ordinary factor-aware parity-descent proof
establishes this bound at **every shift for d<N(N-1)** over F_p. Any violation
must have t^N+1 dividing R and descends to a nonzero multiple S of
1+t+...+t^(N-1) with its first deg S+1 fractional coefficients zero.
The proof tracks a forced factor F_s=(t^N-1)/(t^s-1) while halving s and
the degree. It stops at s=1; the all-degree terminal statement remains unproved.
See [the proof and precise obstruction](results/2026-10-02-parity-descent.md).
This is mathematical progress on the auxiliary bound, not a new main-conjecture
counterexample or a Lean theorem. The method adapts Lai–Sprang's Section 3;
publication novelty has not been established.

**4 October terminal refinement:** for R=F_1 V with d+1 zero rows, an even
shift forces t^N+1 to divide V. At an odd shift m=2n+1, the linked factors
leave the necessary congruence V_0^2-t V_1^2=C t^(-n) modulo t^(N/2)+1.
The missing moment is -NC. Linkage alone cannot force C=0: V=1,m=1 satisfies
all retained moments but has a nonzero missing moment, for every r>=2.
It fails the original stream window and does not refute the terminal statement.
This ordinary algebraic refinement redirects work to the uncompressed rows;
see [the proof and weekly assessment](results/2026-10-04-terminal-obstruction.md).

**5 October reverse lift:** for every F_1-multiple S, dilating by t->t^N
kills all non-N-divisible rows and reproduces S on the remaining rows.
The terminal statement is therefore **equivalent** to the auxiliary all-degree
N-bound. A terminal failure lifts to exact defect 2N, so the maximum defect
for each fixed prime with r>=2 is either N or 2N; this does not decide which.
Any minimum-degree terminal counterexample must have odd shift and C!=0,
with its quotient V coprime to t^N+1. These ordinary proofs use Lai–Sprang
Proposition 2.3 and the preceding descent; they are not Lean theorems or a
novelty claim. See [the proof and checks](results/2026-10-05-terminal-lift.md).

The verified 17 September run finds no violation in the boxes below. The analogous strengthening is false for the tested `r=1` primes `3,7,11,19,23,31`: `R(t)=1+t^2`, `m=2` gives `j=6` and defect `4=2N`. This supplies exact witnesses attaining the published bound in these cases.

| p | N | degree range | shift range | pairs checked | max defect |
|---|---|---|---|---:|---:|
| 5 | 4 | 0–5 | 0–24 | 78,125 | 4 |
| 13 | 4 | 0–4 | 0–24 | 714,025 | 4 |
| 17 | 16 | 0–3 | 0–24 | 122,825 | 15 |

All indices were resolved within cutoff 10,000; finite agreement is not a global bound. Exact witnesses, runtime and counts are in `results/2026-09-17-exact-search.json`; the audit is in `results/2026-09-17-certificate-foundation.md`.

The first-run audit found that the formerly linked 14 September bound-search report was absent and the advertised Gaussian elimination was not implemented. Those historical computation claims had no retained output. The table above is a new reproducible run; the endpoint-aware rank solver was added on 18 September (below). Cutoff exhaustion now increments an explicit unresolved count instead of disappearing from the result.

## Endpoint-aware rank experiments (18 September)

`search/finite_rank.py` now works with arbitrary prime-field coefficient streams,
including characteristic 2. It optimises the vanishing prefix over all normalised
multipliers at each degree and shift using exact affine elimination. Both endpoints
are enforced. Each resolved result includes a multiplier and a dual linear
combination proving that no admissible multiplier can vanish one coefficient
further. A separate dot-product checker verifies both without elimination.
Cutoff exhaustion remains an unresolved prefix, never an exact index.

For **every degree 0–16 and shift 0–64**, with cutoff 128:

| stream | field | maximum defect | auxiliary N |
|---|---|---:|---:|
| Lai–Sprang | F_5 | 4 | 4 |
| Lai–Sprang | F_13 | 4 | 4 |
| Lai–Sprang | F_17 | 15 | 16 |
| Lai–Sprang | F_41 | 8 | 8 |
| Thue–Morse | F_2 | 15 | — |
| regular paperfolding | F_2 | 8 | — |
| Rudin–Shapiro | F_2 | 7 | — |

All 7,735 degree/shift optima have independently checked primal and dual
certificates, with no unresolved cases. Binary stream conventions, exact witnesses,
commands and limits are in `results/2026-09-18-rank-experiments.md`; all certificates
are retained in JSONL. The odd-characteristic boxes support the auxiliary bound
only finitely; that p=17 box does not attain N (a later witness below does). The binary streams are baseline
experiments, not established main-conjecture counterexamples. No infinite bounded
or unbounded defect conclusion follows from these boxes alone. The later
Thue–Morse recurrence proof below rules out that particular stream.

```sh
python3 -m search.run_rank_experiments /tmp/littlewood-rank-search.jsonl
python3 -m search.run_rank_experiments results/2026-09-18-rank-search.jsonl --verify
```

The run refuses to overwrite an existing output JSONL. It checkpoints each degree.
Python 3.9+ standard library only; deterministic, with no random seed.

## Degree-zero sharp constant (20 September)

For every odd prime with r>=2, the degree-zero maximum defect over **all shifts**
is exactly N. Every N consecutive indices contain a nonzero coefficient at an
index congruent to 1 modulo N. Conversely, the support formula gives N-1 zeros
immediately after m=5N+1, followed by a nonzero coefficient: R=1 attains j=N.
An elementary proof, not yet formalised in Lean, is in
`results/2026-09-20-sunday-integration.md`.

In particular, p=17 attains defect 16 at m=81, outside the old shift box.
Seven prescribed witnesses for r=2,...,8 and all 129 degree-zero shifts m<=128
for p=17 pass independent root-sum checks; exact certificates are retained in
`results/2026-09-20-degree-zero-gaps.json`. This settles only degree zero.
The auxiliary all-degree upper bound N and characteristic-2 main frontier
remain separate unfinished questions. No novelty claim is made.

```sh
python3 -m search.degree_zero_gaps results/2026-09-20-degree-zero-gaps.json --verify
```

## Binary Thue–Morse baseline retired (21 September)

For the stream a_n = binary digit sum of n modulo 2, let L=2^k for any k>=0.
The multiplier R=(1+t)(1+t^L), with d=L+1 and m=2L-1, has first nonzero
fractional index j=3L. Thus its defect is 2L-1, unbounded with k, and its
Littlewood product is 2^(1-2L), tending to zero. This stream therefore satisfies
the t-adic Littlewood condition; it cannot be a counterexample.

The all-scale conclusion follows from a binary-carry proof, **not** finite
agreement. The proof is not yet formalised in Lean, and no novelty is claimed:
prior number-wall literature already describes unbounded Thue–Morse windows.
The current characteristic-2 main frontier remains separate and unresolved in
the primary sources checked. The auxiliary odd-characteristic N-bound is unchanged.

`search/thue_morse_dyadic.py` retains exact sparse witnesses for k=0,...,12
(maximum defect 8191) and independently checked affine optimality certificates
for k=0,...,5 only. At k=0 the two t terms cancel, giving R=1+t^2.
The report `results/2026-09-21-thue-morse-dyadic.md` gives the proof, input ranges,
source versions, independent checks and limitations. Thue–Morse remains useful
as a growing-defect regression fixture, rather than a candidate to search further.

```sh
python3 -m search.thue_morse_dyadic results/2026-09-21-thue-morse-dyadic.json --verify
```

## Extended positive-degree and binary boxes (23 September)

All 5,136 new degree/shift optima have independently checked primal/dual
certificates, with no unresolved inputs at cutoff 128:

- Lai–Sprang F_17, d=1,...,16 and m=65,...,256: maximum defect 16=N.
  R=1-t^15+t^16 at m=147 has exact j=32, giving positive-degree attainment.
  No violation of the auxiliary bound occurs in this finite box.
- Binary Rudin–Shapiro, d=17,...,32 and m=0,...,128: maximum defect 15.
  R=(1+t)(1+t^8+t^16+t^24) at m=111 has j=40. The earlier box maximum
  was 7. These finite witnesses suggested the dyadic family proved on 25 September
  below. The box alone proves no infinite conclusion or main-conjecture result.

`results/2026-09-23-extended-rank.md` records exact witnesses, profiles, literature
boundaries and reproducible checks. JSONL retains every certificate; independent
readback checks completeness and regenerates coefficients without elimination.

```sh
python3 -m search.extended_rank_boxes results/2026-09-23-extended-rank.jsonl --verify
```

## Binary Rudin–Shapiro baseline retired (25 September)

For b(n) equal to the parity of overlapping `11` occurrences in the binary
expansion of n, let L=2^k, k>=0. Then R=(1+t)(1+t^L+t^(2L)+t^(3L)),
m=14L-1 has exact first index j=5L and degree 3L+1. Its defect 2L-1 is
unbounded, so this stream satisfies the t-adic Littlewood condition and cannot
be a counterexample. At k=0 the polynomial simplifies to 1+t^4.

An ordinary all-scale proof uses binary-block concatenation: summing four
L-spaced coefficients cancels the low block and its boundary contribution;
the adjacent difference reduces the claim to five explicit binary pairs.
This is **not a Lean theorem**, and no novelty is claimed. The binary encoding
agrees with Sobolewski's arXiv:2204.05287v2; reducing signed Rudin–Shapiro modulo
2 would instead give a constant stream.

The qualitative conclusion was already available from published results.
[Merta, arXiv:1810.03533v3, §3.1 equation (8)](https://arxiv.org/html/1810.03533v3#S3.SS1)
gives a quadratic equation for the complemented binary generating series;
adding 1/(1+x) gives our encoding and preserves that equation.
[Adiceam–Nesharim–Lunnon, §7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
recall de Mathan–Teulié's theorem that quadratic irrational power series satisfy
t-LC (rational cases are immediate). Our explicit dyadic family supplies a
separate exact derivation and regression certificates. Novelty of its particular
formula has not been established. This attribution was added on 26 September;
the previous scoped search missed the quadratic-series route.

`search/rudin_shapiro_dyadic.py` retains independently checked sparse witnesses
k=0,...,12 (maximum defect 8191) and five primal/dual optimum certificates for
k<=4. No larger-scale optimality is claimed. The proof, source versions, exact
ranges and checks are in `results/2026-09-25-rudin-shapiro-dyadic.md`.

```sh
python3 -m search.rudin_shapiro_dyadic results/2026-09-25-rudin-shapiro-dyadic.json --verify
```

The characteristic-two main frontier remains unresolved in the checked sources;
the auxiliary odd-characteristic all-degree N-bound is unchanged.

## Binary quadratic screening and weekly integration (27 September)

All three binary baselines now have a known reason to satisfy t-LC and are
retired as counterexample candidates. In particular, for the repository's
paperfolding convention P(x)=sum_{n>=1} a_n x^n, the recurrence gives
`(1+x^4)(P^2+P)+x=0`. The published theorem for quadratic irrational
series applies; rational series satisfy t-LC immediately. This is an ordinary
argument using a known theorem, not a conclusion inferred from finite checks.

`search/binary_quadratic_screen.py` tests supplied relations
`A(x)Y^2+B(x)Y+C(x)` exactly modulo x^M over F_2. The retained M=1024
checks cover Thue–Morse, paperfolding, Rudin–Shapiro and its complement;
the signed Rudin–Shapiro reduction fails the same equation at coefficient 3.
Independent readback uses recursive streams and full Cauchy convolution.
A zero residual is only finite agreement; it neither proves algebraicity nor
licenses excluding a new candidate. A nonzero residual refutes only the supplied
relation. The checker does not search all quadratic or rational relations.

```sh
python3 -m search.binary_quadratic_screen results/2026-09-27-binary-quadratic-screen.json --verify
```

The dated report `results/2026-09-27-sunday-integration.md` gives the three
ordinary recurrence derivations, current primary references, a finite/formal
status table and the validation record. No new main-conjecture result or global
auxiliary N-bound is claimed. The three-term Lai–Sprang experiment is now recorded below; all three binary
baselines remain regressions.

## Three-term family exception and finite attainment (28 September)

For R=1-t^(N-1)+t^N at m=9N+3, exact checks give j=2N (defect N)
for p=41,73,17,113,97,193,641,257, spanning N=8,...,256. Independent
primal/dual certificates establish optimality at this degree and shift for
N<=32 among those fields; larger N has witness evidence only.

The proposed extension to all r>=2 is **false**. At N=4, j=1: the first
coefficient is a_40-a_43+a_44=-2 for every prime with r=2. At p=5,13,29,
the certified optimum at d=4,m=39 is j=4, so changing coefficients at that
fixed degree/shift cannot attain defect 4. This does not refute the auxiliary
upper bound N. Its known degree-zero attainment uses a different shift.

`search/lai_sprang_three_term.py` retains 17 exact witnesses (including six
r=1 comparisons), eight fixed-input optima and independent root-sum readback.
See `results/2026-09-28-three-term.md` for the failure explanation, exact ranges,
checks and primary literature. These 28 September computations were finite evidence; the all-r>=3
support identity is now proved by the ordinary argument below. No global bound,
new Lean theorem, novelty or characteristic-two resolution is claimed.

```sh
python3 -m search.lai_sprang_three_term results/2026-09-28-three-term.jsonl --verify
```

## Three-term attainment for every r>=3 (30 September)

For every odd prime with r=v_2(p-1)>=3, the same family
R=1-t^(N-1)+t^N at m=9N+3 has exact j=2N and terminal coefficient -N/2.
Its defect is exactly N. An ordinary proof classifies all five supported indices
in [9N+4,12N+3] and cancels the four earlier contribution pairs. The r=2
exception survives; no all-degree upper bound or general optimality is proved.

`search/lai_sprang_support.py` enumerates exact integer support intervals and
retains all cancellation events. Independent dense readback and original root
sums verify the tables at the existing scales; no finite-scale expansion is used
as proof. See `results/2026-09-30-three-term-support-proof.md` for the complete
all-r argument, checks and literature boundary. This is not yet a Lean theorem,
not a characteristic-two result, and not a claim of novelty.

## Verified finite certificate foundation

`FunctionFieldLittlewood/Certificate.lean` defines coefficient streams, shifted multiplication, a Hankel matrix, and an exact-index certificate. It proves that the zero-prefix equations equal a matrix kernel condition, that an accepted certificate gives the first nonzero index, and that only coefficients through `m+d+j` affect the certificate. Both constant and leading multiplier coefficients must be nonzero.

`FunctionFieldLittlewood/Examples.lean` includes kernel-checked examples over `ZMod 2` and `ZMod 3`, plus invalid-index and invalid-endpoint controls. The binary example is a finite infrastructure fixture, not a main-conjecture candidate. The ternary example originally checked a recorded prefix; `LaiSprangStream.lean` now also proves its certificate directly for the infinite support-formula stream. The fractional-size/product bridge is now formalised below; no global sharp bound is proved.

`FunctionFieldLittlewood/DualCertificate.lean` now proves soundness of both dual
obstruction formats and of a combined primal/dual checker. Acceptance proves an
attained first index j and a nonzero coefficient by j for **every normalised**
multiplier at the fixed degree and shift. Tail replacement beyond m+d+j preserves
acceptance. This proof uses finite sums; it does not trust the solver or its rank.

`SavedCertificates.lean` kernel-checks three exported records: the Thue–Morse
F_2 case (d,m,j)=(9,15,24), an F_2 forced-endpoint obstruction, and the Lai–Sprang
F_17 degree-zero gap (0,17,15). Each theorem applies to every stream agreeing
with its recorded prefix; the Thue–Morse degree-nine prefix is now identified
with the infinite stream in `BinaryStream.lean` (24 September, below). The F_17
prefix is now identified with the infinite support-formula stream
in `LaiSprangStream.lean` (26 September); the forced-endpoint binary fixture
remains a finite-prefix statement here. Only these three saved records have been
instantiated in Lean, not all 7,735 records. Details and limits are in
`results/2026-09-19-dual-certificate-soundness.md`.

## Polynomial endpoints and scalar normalisation (22 September)

`Normalisation.lean` proves over every field that nonzero scalar multiplication
preserves exact certificates and first nonzero indices. Dividing by the constant
coefficient gives constant term 1 without changing the leading endpoint.
The new `checkOptimalCertificate_sound_all` therefore bounds **all multipliers
with both endpoints nonzero**, removing the normalisation restriction from the
semantic conclusion of the existing checker.

`PolynomialBridge.lean` assembles vectors as mathlib polynomials, recovers every
coefficient, proves the actual degree from the leading endpoint, and excludes
an X factor from the nonzero constant term. Every polynomial of degree at most d
is reconstructed from its vector. `optimal_polynomial_nonzero` consequently
bounds the finite coefficient sum for every degree-d polynomial with nonzero
constant term. This includes degree zero and characteristic two.

`BridgeExamples.lean` checks nontrivial F_3 scaling, rejection of zero scaling,
degree-zero endpoints, and the saved F_2/F_17 optima with polynomial quantifiers.
These are kernel-checked finite statements. At that stage the actual Laurent-series
product was unformalised; the 29 September bridge below identifies its coefficients.
The 1 October bridge proves the base-two product exponent. The later binary
identification is below.
No global auxiliary bound or characteristic-2 counterexample follows. See
`results/2026-09-22-polynomial-normalisation.md` for validation and source details.

## Named binary stream (24 September)

`BinaryStream.lean` defines the infinite Thue–Morse stream as the sum of
`Nat.digits 2 n`, reduced in `ZMod 2`. It proves the even/odd recurrences and
uniqueness from those recurrences. For D(n)=a(n)+a(n+1), it proves
D(2n)=1 and D(2n+1)=1+D(n) for every n.

The saved prefix through inclusive index 48 is now kernel-proved to agree
with this definition. The existing primal/dual certificate consequently proves
exact j=24 for R=(1+t)(1+t^8), m=15, and an upper bound of 24 for every
degree-nine multiplier with nonzero endpoints on the **infinite named stream**.
A polynomial corollary removes the coefficient-vector representation from the
quantifier. The finite prefix is not equated to the entire stream: they differ
at index 49, as a checked control records.

This closes one named-stream identification gap. It does not formalise the
all-scale dyadic witness, the valuation formula for D, or the Laurent norm
bridge. Thue–Morse remains a retired candidate and a regression baseline.
No characteristic-2 counterexample or global auxiliary N-bound follows.
See `results/2026-09-24-named-binary-stream.md` for checks and source versions.

## Named Lai–Sprang support stream (26 September)

`LaiSprangStream.lean` defines the infinite support formula with explicit p,r
parameters and a total odd-part function. It proves dyadic index invariance for
all indices and identifies the saved F_17 prefix through index 32. The saved
degree-zero certificate at m=17 therefore gives exact j=15 and its optimum on
this infinite stream, including all nonzero scalar multipliers.

The module also kernel-checks R=1,m=81,j=16 in F_17 and the r=1 comparison
R=1+t^2,m=2,j=6 in F_3 directly on the named streams. These are finite exact
certificates about infinite streams. They do not prove the all-shift degree-zero
bound, the all-degree N-bound, or equality with the original infinite root-sum
Laurent expression. That equality remains a separate formal obligation; the
coefficient and fractional-size/product bridges are now proved below.
No characteristic-2 counterexample follows.
See `results/2026-09-26-named-lai-sprang-stream.md` for validation and attribution.

## Actual Laurent coefficient bridge (29 September)

`LaurentBridge.lean` embeds any coefficient stream in mathlib's Laurent series
with variable x=t^(-1), evaluates the multiplier polynomial at x^(-1), and proves
that the x^j coefficient of x^(-m) R(x^(-1)) A(x) is exactly
`fractionalCoeff a R m j`. The coefficient identity holds over every commutative
semiring, including characteristic two; the polynomial and optimality corollaries
use fields. The Hankel kernel is now equivalent to vanishing of the corresponding
actual Laurent coefficients.

Existing exact and primal/dual certificates therefore give the first nonzero
**positive** x-index and its fixed-degree/shift upper bound on the actual product.
`LaurentExamples.lean` transfers the named binary j=24, F_17 sharp j=16 and F_3
r=1 j=6 witnesses, and quantifies binary optimality over actual degree-nine
polynomials. Positive index is not the order of the full product, which can have
negative powers; the 1 October bridge below takes the strictly positive part
before computing its size and the product exponent.

This is a generic Lean proof, not a new search or conjecture result. The original
Lai–Sprang root-sum equality, all-shift degree-zero theorem and all-degree N-bound
remain separate. Validation and exact scope are recorded in
`results/2026-09-29-laurent-coefficient-bridge.md`.

## Fractional part and Littlewood product bridge (1 October)

`FractionalPart.lean` removes all nonpositive x-powers and proves that an exact
positive index j is the order of this fractional part. Its explicit base-two size
is 2^(-j), with size zero for a zero fractional part. For endpoint-nonzero R,
mathlib's actual polynomial degree and trailing degree identify the factors of
Q=t^m R; an exact certificate proves the product equals 2^(d-j).
The real-valued size is explicitly defined from order, not installed as an
ambient norm instance.

More usefully for the unresolved upper bound, the module proves, without
assuming a first index exists, that product >= 2^(-N) is equivalent to some
nonzero fractional coefficient among indices 1,...,d+N. This gives the exact
formal target for a structural nonvanishing argument. It does not prove that
target for the Lai–Sprang stream. Existing F_17 and r=1 F_3 certificates provide
boundary regressions; no new attainment evidence or binary search is claimed.

This is **verification/infrastructure progress**, with no new structural result
on the all-degree bound or characteristic-two frontier. See
`results/2026-10-01-fractional-product-bridge.md` for scope and validation.

## Root-moment rigidity in Lean (3 October)

`ParityDescent.lean` verifies the moment-to-forced-factor step in the 2 October
ordinary proof. H consecutive moments at H distinct roots force both parity
quotients to be divisible by t^H+1. The prime-field theorem proves nonsquareness
from p-1=2H times an odd number, and proves that the geometric common factor
does not vanish at those roots. It allows zero constant terms and arbitrary
nonnegative starting exponents. An F_5 boundary example verifies that one fewer
moment need not force the factor.

This is **verification/infrastructure progress**. The generic theorem still
requires an enumeration of H distinct roots and the full moment equations.
Deriving those equations from the support-formula stream's parent window
and completing the degree/shift descent remain unformalised. The uniform
enumeration and odd-subsequence identity were subsequently proved on 6 October
(below). Neither the all-degree bound nor the terminal obstruction
has been resolved. See [scope and validation](results/2026-10-03-moment-rigidity.md).

## Named stream root formula in Lean (6 October)

`RootStream.lean` constructs all H roots of t^H+1 in F_p and proves
`a_(2u+1)=sum_i z_i^u` for the infinite support stream, including u=0.
It also proves the polynomial-filter formula
`sum_j P_j a_(2(n+j)+1)=sum_i z_i^n P(z_i)` for every polynomial P.
The only arithmetic hypothesis is N=2H dividing p-1; maximal 2-adic valuation
is needed later for nonsquareness, not for these identities. The r=1 case
is included. Root existence, distinctness and completeness are proved.

This is **verification/infrastructure progress**: it removes the root-formula
gap on the path to the degree cutoff. The parent-window cross-convolution,
exact row budgets and full descent still need formalisation. It does not
identify the entire infinite rational-function sum, prove the all-degree
bound, or decide the terminal N-or-2N alternative.
See [the theorem scope and checks](results/2026-10-06-root-stream.md).

Lean and mathlib are pinned to `v4.27.0`; `lake-manifest.json` records exact dependency commits. The imported mathlib matrix and modular-arithmetic sources and their Apache-2.0 licence were inspected before reuse.

```sh
# First setup (requires elan, Git and network access)
MATHLIB_NO_CACHE_ON_UPDATE=1 lake update
lake exe cache get Mathlib.Data.ZMod.Basic Mathlib.Data.Matrix.Mul Mathlib.RingTheory.LaurentSeries
lake build

# Python 3.9+ standard library only; no random seed
python3 search/lai_sprang_finite_search.py
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
```

The original tests independently expand the original root sums for 2,560 coefficients and check saved witnesses. They also check that a cutoff is unresolved, scalar normalisation preserves the index, and malformed inputs are rejected.

## Near-term programme

See `TODO.md` for the current roadmap and `RESEARCH_LOG.md` for dated records.
Next substantive work: rule out the original odd-shift terminal parity rows
with C!=0 and quotient coprime to t^N+1, or exhibit such a window. The reverse
lift makes any terminal witness decisive; no sibling-compatibility barrier
remains. Linked factors and H-1 moments alone do not suffice. The ordinary reduction
already proves the all-shift cutoff d<N(N-1). Its moment-to-factor step is now
formalised; the parent-window calculation and complete descent remain to be checked
in Lean.
The positive fractional-part/product bridge is complete for Q=t^m R with
nonzero endpoints. Original root-sum identification and generic degree-zero
formalisation remain separate, lower-priority obligations. The Laurent coefficient
bridge, named prefixes, scalar normalisation and polynomial endpoints are proved.
The three-term support identity for r>=3 now has an ordinary proof; its r=2
extension failed. Prioritise a structural lemma
towards the all-degree upper bound or a literature-screened characteristic-two
construction. Number-wall tooling is conditional on a specific discriminating
question. The three binary baselines remain retired via known quadratic-series
results and serve as
regressions. New binary candidates need a literature/algebraicity screen first.

The 30 September research review replaces the daily artifact quota with a
mathematical progress criterion. Each run should identify the unresolved question
and explain how its result changes the next decision. Report mathematical and
verification/infrastructure progress separately; a bounded attempt with no useful
increment is acceptable. More attainment examples or routine search expansion
are insufficient by themselves. The detailed criteria are in `TODO.md`.

## References

- Li Lai and Johannes Sprang, *On the P(t)-adic Littlewood conjecture in odd characteristics*, arXiv:2606.00633 (2026).
- Faustin Adiceam and Dzmitry Badziahin, *On the P(t)-adic Littlewood Conjecture in Characteristics ell congruent 3 mod 4*, arXiv:2509.12826 (2025).
- Samuel Garrett and Steven Robertson, *Counterexamples to the p(t)-adic Littlewood Conjecture Over Small Finite Fields*, Mathematics of Computation (2025), DOI 10.1090/mcom/4104.
- Steven Robertson, *Combinatorics on number walls and the P(t)-adic Littlewood conjecture*, Mathematika 72 (2026), e70064, DOI 10.1112/mtk.70064.
