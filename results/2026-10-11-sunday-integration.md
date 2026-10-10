# Sunday integration: an all-shift cover at the first unresolved degree

11 October 2026, Sunday, Australia/Sydney (AEDT).
Classification: **mathematical progress on the auxiliary bound**, using an
ordinary covering argument and independently checked exact finite computation.
This is not a Lean theorem, an all-degree result, or established novelty.

## Question and decision

Can the original terminal rows exclude quotient degree H=N/2 at every shift?
The 9 October proof excludes smaller degrees, but its monomial-norm argument
stops here. First consider the norm shapes; if these do not decide the rows,
test a finite abstraction that covers every shift, including arbitrarily large
ones. Full column rank in every abstract case proves exclusion. A surviving
case would instead require the actual stream recurrence at the abstracted
coefficient; it would not itself be a terminal witness. Both questions were
stated before their respective implementations.

**Result.** Over p=5,13,41,17, no nonzero terminal multiplier
S=(1+t+...+t^(N-1))V with deg V=H has its first deg S+1 rows zero at any
nonnegative shift. Together with the 9 October proof and 2 October descent:

| p | N | Previous all-shift strict cutoff | New all-shift strict cutoff |
|---|---|---|---|
| 5 | 4 | d<20 | d<24 |
| 13 | 4 | d<20 | d<24 |
| 41 | 8 | d<88 | d<96 |
| 17 | 16 | d<368 | d<384 |

Below these respective cutoffs, j exists and j-d<=N at every shift. The new
cutoffs apply only to these four fields. For other primes the ordinary bound
d<N(3N/2-1) remains the supported result. This calculation does not pick the
N versus 2N branch of the all-degree maximum-defect dichotomy.

## Why the norm alone did not settle the boundary

For deg V=H and V(0)=1, write W=V0^2-t V1^2. Since H is even,
W has constant coefficient 1 and leading coefficient a=lc(V)^2!=0.
The necessary odd-shift congruence makes W modulo t^H+1 a nonzero monomial.
Thus either

    W=1+a*t^H, a!=1,

or

    W=1+b*t^k+t^H, 1<=k<H, b!=0, lc(V)=+1 or -1.

Here k is congruent to -n modulo H for shift M=2n+1. This follows simply
by reducing the degree-H term and comparing the constant coefficient; it is
not a classification of which such polynomials are norms. In particular,
the existing F_5 example 1+t+3t^2 survives the first case. No implication
from these shapes to failure of the original rows was obtained. Rather than
enumerate more norm candidates, the calculation below keeps the original
linear row equations and does not assume the norm congruence at all.

## Ordinary proof that the finite cover includes every shift

Fix one of the listed primes, r=v_2(p-1), N=2^r, H=N/2. Put

    F=1+...+t^(N-1), D=N-1+H, T=2D+1.

Choose L a power of two strictly larger than T, and P=N*L. A proposed
D+1-row zero window of FV at shift M, with V of degree at most H, uses
exactly the coefficient interval [M+1,M+T], inclusively. Indeed the last
index is M+(D+1)+H+(N-1)=M+2D+1. Write M=qP+b with 0<=b<P.

For any i in [1,T] such that L does not divide b+i, put s=v_2(b+i).
Then s<v_2(L), and adding qP does not change this valuation. Moreover

    oddpart(M+i)-oddpart(b+i)=q*N*L/2^s

is divisible by 2N. The Lai–Sprang support formula depends only on the odd
part modulo 2N, so a_(M+i)=a_(b+i). This equality is an ordinary argument
for arbitrary q, not an inference from a finite sample of shifts.

Because T<L, there is at most one remaining index, where L divides b+i.
Its actual coefficient belongs to {0,H,-H}. Allowing each of those three
values independently is an overapproximation of the actual stream. If there
is no such index, there is one fully determined case. Thus the following
finite collection contains every possible original row matrix:

    b=0,...,P-1; x in {0,H,-H} at the exceptional index, when present.

The (D+1)-by-(H+1) matrix in each case has entries

    A[k,j]=sum_(i=0)^(N-1) a_(b+k+j+i), k=1,...,D+1, j=0,...,H,

using the replaced coefficient x when necessary. Its product with the
coefficient vector of V is precisely the original terminal window. A
nonzero (H+1)-square minor forces V=0. This handles both shift parities
and arbitrary constant coefficients, without normalising an endpoint.

## Exact finite verification

| p | D | T | L | P | Abstract cases | Minor size |
|---|---|---|---|---|---|---|
| 5 | 5 | 11 | 16 | 64 | 152 | 3 |
| 13 | 5 | 11 | 16 | 64 | 152 | 3 |
| 41 | 11 | 23 | 32 | 256 | 624 | 5 |
| 17 | 23 | 47 | 64 | 1024 | 2528 | 9 |

Every case has a nonzero minor. The saved JSON contains the complete ordered
case list, selected one-based original rows and determinant modulo p. Existing
affine elimination selects the rows; its reported rank is not the certificate.
Independent readback regenerates coefficients by original root sums and
computes each selected determinant by exact integer Bareiss elimination.
No elimination-selected row is accepted without that nonzero determinant.

The reader checks completeness, uniqueness, allowed row indices and all
metadata. Tests disable the generator and affine solver during readback,
reject seven coverage/certificate corruptions, compare small Bareiss results
with direct determinant formulas, and test the covering identity at specified
shifts including q=2^54 and exceptional first/last inclusive endpoints. Those
large shifts are implementation controls only; the all-shift conclusion uses
the proof above. No truncation, padding, timeout or inferred tail is involved.

To reproduce from the repository root:

```sh
python3 -m search.terminal_boundary_cover .research/boundary-cover-reproduction.json
python3 -m search.terminal_boundary_cover results/2026-10-11-boundary-cover.json --verify
python3 -m unittest discover -s tests -v
lake build
```

Python 3.9.6, standard library, no randomness (seed null). Initial generation
took 1.527 seconds; independent readback took 0.899 seconds. Full verification
and weekly checks are recorded in `2026-10-11-validation.json`.

The final implication uses the existing exact-degree descent: d+N zero rows
would yield a terminal S of degree floor(d/N). If d<N(N+H), its quotient
has degree at most H. Degrees below H are excluded by the ordinary 9 October
proof; degree H is excluded by the complete finite cover above. This proves
the four advertised strict cutoffs. It does not assert a single uniform
prime-independent certificate, nor extrapolate to H+1 or higher degrees.

## Week's assessment and next decision

| Work | Classification | Effect on the mathematical targets |
|---|---|---|
| 5 October reverse lift | Auxiliary mathematics, ordinary proof | Terminal statement equivalent to N-bound; exact N-or-2N dichotomy |
| 9 October low-degree norm exclusion | Auxiliary mathematics, ordinary proof | Uniform all-shift cutoff d<N(3N/2-1) |
| 11 October complete boundary cover | Auxiliary mathematics, exact finite proof plus ordinary cover | Four field-specific cutoffs raised by N |
| 6, 8, 10 October Lean work | Verification/infrastructure | Named root stream, moments and actual parent rows connected; iteration still missing |
| 7 October Comparator/catalogue/priority review | Verification and provenance | Independently checked recorded package; no new bound or established firstness |

The week changed the auxiliary-bound problem but did not resolve it. It made
no characteristic-two construction. Ordinary proofs and today's complete
finite calculation are outside the Lean theorem catalogue. The successful
weekly Lean build verifies the existing formal scope, not today's theorem;
the isolated Challenge statement placeholder remains outside Solution and
the completed theorem closures. No new Lean source or dependency changed.
The 5 and 9 October small check outputs were reproduced exactly after JSON
normalisation, ignoring runtime and interpreter metadata; the r=1 terminal
and lifted failures remain unchanged.

Retain the retirement of linkage-plus-moments as a sufficient condition, the
all-r three-term attainment extension, and the three quadratic binary streams.
Historical 2 October discussion of unresolved reverse compatibility is
superseded by 5 October, and old formal TODOs by the later proved components.
Further catalogue exports, retired-stream proofs, attainment families and
routine degree/shift expansion are not the next research decision.

**Next informative experiment:** determine whether the one unresolved
coefficient can be eliminated symbolically at degree H, uniformly in N and
the prime. The selected integer minors have odd prime factors, so their
nonvanishing in the four tested fields is insufficient for that claim.
Seek a row identity or a collection of minors whose common divisors are
controlled; a failed rank condition must first be classified as a spurious
abstract coefficient or a realizable stream state. Do not default to adding
primes or increasing the quotient degree.

**Next formal lemma:** after `stream_parent_forced_factor`, prove cancellation
of the odd subsequence and select the nonzero leading child of exact degree q
at shift n+epsilon*delta; combine with the next geometric-factor identity and
iterate. This enables the existing ordinary d<N(N-1) theorem. Formalising
today's finite certificates is lower priority than completing that descent.

## Primary literature and evidence boundary

Accessed 11 October 2026, Australia/Sydney:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1):
  v1 remains listed. The odd-characteristic main existence question is settled.
  [Proposition 2.3 and Section 3](https://arxiv.org/html/2606.00633v1#S3)
  supply the key input and descent method; this work concerns their explicit
  stream's auxiliary constant, without a publication-novelty claim.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1):
  v1 remains listed; the characteristic-two conclusion is still conditional
  on existence of a counterexample. Scoped searches found no later resolution,
  but returned noisy results and do not prove absence.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2):
  quadratic-series and Thue–Morse/paperfolding exclusions rechecked. Rational
  series are excluded by clearing a denominator. The repository's exact
  quadratic identities also retire its overlapping-11 Rudin–Shapiro encoding.
- [Garrett–Robertson, arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5):
  known unbounded-window discussion rechecked; the first anchored request
  failed, then the full HTML succeeded. No new binary candidate was proposed.
