# Prime-independent terminal boundary exclusion at three dyadic scales

12 October 2026, Monday, Australia/Sydney (AEDT).
Classification: **mathematical progress on the auxiliary bound**, by an ordinary
common-divisor argument and an independently checked exact finite certificate.
No Lean theorem, all-degree result, characteristic-two advance or novelty claim.

## Question and result

The question, stated before coding, was whether the normalized integer matrices
in the existing complete shift cover have selected maximal minors with
power-of-two greatest common divisor. Such a certificate would remove the
dependence on a sampled prime. An odd common factor would instead identify a
characteristic requiring investigation. The scales and quotient degree remain
exactly those of 11 October: N=4,8,16 and e=H=N/2.

**Theorem.** Let p be any prime with r=v_2(p-1) in {2,3,4}, N=2^r,
H=N/2, and a the explicit Lai–Sprang stream over F_p. For every M>=0,
no nonzero S=(1+t+...+t^(N-1))V with deg V=H has all its first
deg S+1 stream rows zero. Consequently, at every shift,

    j-d <= N for every nonzero degree-d R with d < N(N+H).

The last implication uses the existing ordinary descent and low-degree
exclusion, not a newly formalised theorem.

| r | N | All primes covered | All-shift strict cutoff |
|---|---|---|---|
| 2 | 4 | p congruent to 5 modulo 8 | d<24 |
| 3 | 8 | p congruent to 9 modulo 16 | d<96 |
| 4 | 16 | p congruent to 17 modulo 32 | d<384 |

Yesterday these improved cutoffs applied only to p=5,13,41,17. Today the
prime quantifier is unrestricted within each stated congruence class. This is
not a larger prime or degree search. For r>=5 the supported uniform cutoff
remains d<N(3N/2-1). No branch of the all-degree N-or-2N dichotomy is selected.

## Integer matrices and the ordinary common-divisor argument

Divide the stream by H, which is invertible in every odd characteristic.
The resulting integer sequence, before reduction modulo p, is

    c_n = (-1)^h if oddpart(n)=1+Nh, and 0 otherwise.

Set D=N-1+H, T=2D+1=3N-1, L=4N and P=NL=4N^2. These agree with
the existing dyadic-cover parameters. The required original coefficient
interval is [M+1,M+T], inclusively. Write M=qP+b, 0<=b<P.
For an index b+i not divisible by L, its valuation s is less than v_2(L).
Adding qP preserves s and changes its odd part by qNL/2^s, a multiple of
2N. Thus c_(M+i)=c_(b+i). Since T<L, at most one index is divisible by L.
At that index allow x to be any of 0,1,-1. The actual coefficient always
belongs to this set. This proves that the finite cover contains every shift;
no finite-shift extrapolation or unobserved tail is assumed.

For each b and permitted x form the integer matrix

    A[k,j] = sum_(i=0)^(N-1) c_(b+k+j+i),
    k=1,...,D+1; j=0,...,H,

with the exceptional coefficient replaced by x. If v is the coefficient
vector of V, the terminal rows are H*A*v modulo p. Thus a nonzero maximal
minor modulo p excludes the proposed zero window, regardless of endpoints.

**Common-divisor lemma.** For any integer matrix A with h columns, choose
h-square minors with nonzero integer determinants delta_1,...,delta_s and
let g=gcd(|delta_1|,...,|delta_s|). If a prime p does not divide g, at least
one of these minors is nonzero modulo p, so A has zero kernel over F_p
(and over every extension of F_p). Indeed, if all determinants vanished
modulo p, p would divide their gcd. This uses a gcd of selected minors;
it does not require computing the gcd of *all* maximal minors or a Smith form.

The exact certificates establish:

| N | Complete abstract cases | Selected minors | Possible selected gcds |
|---|---:|---:|---|
| 4 | 152 | 214 | 1,2,3,4,8 |
| 8 | 624 | 825 | powers of two from 1 through 64 |
| 16 | 2528 | 3323 | powers of two from 1 through 512 |

For N=8,16 every odd prime is excluded as a common divisor. For N=4,
only p=3 remains possible, and it is incompatible with v_2(p-1)=2.
Therefore every admissible Lai–Sprang characteristic has full column rank
in every abstract matrix. In particular degree-H terminal windows are excluded.

The 9 October proof excludes quotient degrees below H. If an original
degree-d multiplier had d+N zero rows, the 2 October descent would give a
terminal S of exact degree floor(d/N), divisible by F=1+...+t^(N-1).
For d<N(N+H), its quotient V would have degree at most H, contradicting
one of these exclusions. This proves the stated all-shift cutoffs and the
existence of j within d+N, without assuming an endpoint normalization.

## A failed stronger hypothesis and its explanation

The proposed power-of-two gcd condition is false at N=4. At M=4, there
is no exceptional index in [5,15]; the actual normalized stream gives

    A = [ 0  2  1 ]
        [ 2  1  1 ]
        [ 1  1  0 ]
        [ 1  0 -2 ]
        [ 0 -2 -1 ]
        [-2 -1 -1 ].

Modulo 3 its nonzero kernel contains (1,2,2). Direct enumeration of all
20 maximal minors gives gcd 3. The other two cases with selected gcd 3
are (b,x)=(5,1),(6,1); x=1 is realizable there because c_16=1.
Thus the rank failure is not caused solely by overapproximating the one
exceptional coefficient. It rules out a theorem asserting full rank for
every odd characteristic at every N>=4.

This is **not** a Lai–Sprang terminal counterexample: in characteristic 3
their construction has N=2, not N=4. The genuine r=1 comparison remains
separate and is retained by the existing regression suite. The obstruction
shows why a future uniform argument should preserve the admissible relation
N=2^v_2(p-1), rather than discard the characteristic information entirely.

## Computation, independent checks and reproduction

The narrowly scoped implementation is `search/terminal_prime_obstruction.py`.
It reuses `_Affine` only to select minors, initially modulo 5,41,17 for the
three scales. It factors the odd part of each first determinant and asks for
alternative minors modulo those factors. This adaptive selection is a way of
finding integer certificates; no claim relies on its rank diagnostics, its
factorization being complete, or a search failing to produce a minor.

Independent readback expands the formal integer power series

    sum_(k>=0) x^(2^k)/(1+x^(N*2^k))

through the exact required endpoint P-1+T. Its coefficients are c_n: each
summand contributes (-1)^h at n=2^k(1+Nh), whose valuation is exactly k.
All later summands begin above the endpoint. The checker constructs rows
directly from this expansion and computes every determinant using Fraction
Gaussian elimination, independently of both modular selection and the
generator's integer Bareiss determinant. It then checks the gcd condition,
case completeness and uniqueness, determinant values and row bounds.

Inputs are exhaustive over the *complete abstract cover*: b=0,...,63,
0,...,255 and 0,...,1023 respectively, with the three possible values at
the unique exceptional coefficient. There is no polynomial enumeration,
randomness, cutoff exhaustion, heuristic tail or timeout conclusion.
Python 3.9.6; standard library only; seed null. Certificate generation took
1.866 seconds; independent readback in the retained validation took 3.299
seconds. The output is deterministic apart from timing metadata.

```sh
python3 -m search.terminal_prime_obstruction .research/prime-obstruction-reproduction.json
python3 -m search.terminal_prime_obstruction results/2026-10-12-prime-obstruction.json --verify
python3 -m unittest discover -s tests -v
```

All 4362 selected determinants were independently checked. The 50-test suite
passed in 8.186 seconds, including generation-disabled readback, nine corruption
controls, original-root-sum comparison through every required endpoint in the
four previous fields, determinant sign/singularity controls, and the exact
modulo-3 rank failure. The existing r=1 and retired-stream regressions pass;
none was expanded. The certificate and validation JSON files accompany this
record. No Lean source, dependency, catalogue or release changed; no Lean build
was needed or claimed for this ordinary finite proof.

## Literature and next decision

Primary sources accessed 12 October 2026, Australia/Sydney:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  submitted 30 May 2026, remains the listed version. The odd-characteristic
  main conjecture is already disproved. The [paper's Section 3](https://arxiv.org/html/2606.00633v1#S3)
  supplies the parity method behind the existing descent. Today's result
  concerns only the sharper auxiliary constant for their explicit stream.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  submitted 22 August 2026, still makes its characteristic-two consequence
  conditional on counterexample existence. Scoped searches found no later
  relevant resolution; noisy search results do not establish absence.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  retains the quadratic-series exclusion, citing de Mathan–Teulie, and the
  binary paperfolding application. Rational series are excluded directly by
  a denominator multiplier. [Garrett–Robertson, arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5)
  retains the discussion of unbounded Thue–Morse and binary paperfolding
  windows. No new binary candidate was selected or searched.

The structural gap is now the dependence on **N**, rather than on the prime
within the three checked scales. The next informative question is whether
dyadic row identities force every odd prime divisor of the maximal-minor gcd
to be incompatible with v_2(p-1)=log_2 N, uniformly in N. The modulo-3 example
must be preserved as a control against a stronger false statement. A proof
should track the original rows and the exceptional coefficient. More primes,
routine higher-scale covers or certificate exports are not substitutes for
that identity. No uniform-N identity was proved in this bounded attempt.

The next Lean step remains odd-subsequence cancellation and exact leading-child
degree/shift after `stream_parent_forced_factor`, then geometric-factor iteration
to the existing ordinary cutoff. Today's computation does not alter that path.
