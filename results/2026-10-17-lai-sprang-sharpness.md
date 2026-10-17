# The Lai–Sprang constant 2N is attained for p=5,13,29,37,53

17 October 2026, Saturday, Australia/Sydney (AEDT).
Classification: **mathematical progress**. The auxiliary all-degree bound
j-d<=N is **false**; the 5 October N-or-2N dichotomy selects 2N for five
primes; Lai–Sprang's Theorem 1.2 is therefore sharp in those characteristics.
The p=5 refutation is a Lean kernel-checked theorem. The other witnesses are
exact finite certificates read back from original root sums; minimality and the
exclusions for other primes are computer-assisted all-shift statements.

## Question and decision

Question, stated before computing: can the terminal problem be scanned at
**all degrees for a shift at once**, rather than one (degree, shift) pair at a
time, and does it have solutions beyond the previously screened boxes?
The [5 October reverse lift](2026-10-05-terminal-lift.md) made any terminal
witness decisive: it lifts to an original multiplier with defect exactly 2N.
A long all-shift exclusion would instead raise the cutoff and support the
12 October plan of seeking a uniform arithmetic obstruction.

The terminal problem is a continued-fraction question (Section 3). That
reformulation found witnesses within seconds at p=5. All earlier searches
were too small: the least p=5 witness has original degree 44 and shift 1244.

## 1. Results

Fix an odd prime p, r=v_2(p-1), N=2^r, the explicit Lai–Sprang stream a,
and F=1+t+...+t^(N-1). Row k of a multiplier T at shift M is
B_T(M+k)=sum_i T_i a_(M+i+k); the defect of t^m R is j-deg R, where j is
the first nonzero row. The Littlewood product is 2^(deg R-j) (base two).

**Theorem 1 (p=5, Lean kernel-checked).** Over F_5 (N=4) put

    V = 2+t+t^2+t^3+3t^4+3t^5+t^6+t^7+t^8,
    S = F V = 2+3t+4t^2+t^4+3t^5+3t^6+3t^7+t^8+3t^9+2t^10+t^11,
    R(t) = S(t^4),   m = 1244 = 4*311.

Then deg R=44, R(0)=2, R has leading coefficient 1, rows 1,...,51 of R at
shift 1244 vanish and row 52 equals 4. The defect is 52-44=8=2N and

    |t^1244 R| * |t^1244 R|_t * |<t^1244 R Lambda>| = 2^-8 < 2^-4.

Also S itself has its first deg S+1=12 rows zero at shift 311 and row 13
equal to 4: a genuine terminal window. [Sharpness.lean](../FunctionFieldLittlewood/Sharpness.lean)
proves both certificates, S=FV, the polynomial product 2^-8 for the actual
mathlib polynomial X^1244 R and the infinite named support stream, and the
failure of the 2^-4 bound (`sharp5_refutes_N_bound`), with standard axioms only.

**Theorem 2 (five primes).** For each row below, the stated S=FV (recorded
in [the JSON certificate](2026-10-17-sharpness.json)) has exactly deg S+1 zero
rows at the odd shift M, and its lift R=S(t^4), m=4M has exact defect 8=2N.

| p | M | deg V | deg S | lifted deg R | m | j | defect |
|---|---:|---:|---:|---:|---:|---:|---:|
| 5 | 311 | 8 | 11 | 44 | 1244 | 52 | 8 |
| 13 | 1465 | 76 | 79 | 316 | 5860 | 324 | 8 |
| 29 | 2501 | 326 | 329 | 1316 | 10004 | 1324 | 8 |
| 37 | 19939 | 1134 | 1137 | 4548 | 79756 | 4556 | 8 |
| 53 | 40193 | 1128 | 1131 | 4524 | 160772 | 4532 | 8 |

Hence for these primes the maximum defect is Delta_p=2N=8: the infimum of
the Littlewood products of the Lai–Sprang series over F_p is exactly 2^-8.
The upper bound is Lai–Sprang's Theorem 1.2; the witnesses give equality.

**Corollary 3 (Lai–Sprang Theorem 1.2 is sharp in these characteristics).**
Let K be any field of characteristic p in {5,13,29,37,53} and P in K[t] any
irreducible polynomial. Lai–Sprang prove

    inf_{Q in K[t]\{0}} |Q| |Q|_P |<Q Lambda(P(t))>| >= 2^(-2^(r+1) deg P).

Equality holds. *Proof.* Take Q=t^m R from Theorem 2, so R(0)!=0 and
<Q Lambda>=f with |f|=2^-j. Substitute t->P(t). The polynomial part of
Q Lambda stays polynomial, while f(P)=sum_(k>=j) f_k P^-k has size
2^(-j deg P)<1, so it is the fractional part of Q(P)Lambda(P). Also
|Q(P)|=2^((m+d) deg P), and v_P(Q(P))=m since R(P) is congruent to R(0)!=0
modulo P. The product is 2^((d-j) deg P)=2^(-2N deg P). QED. This is the
same composition principle as [Robertson's Theorem 1.6](https://arxiv.org/abs/2307.00955)
(as quoted by Garrett–Robertson); it is spelled out to fix the base-two norm.

**Theorem 4 (least degrees, all shifts; computer-assisted).** For every
nonzero polynomial R of degree d and every shift m>=0, some row among
1,...,d+N is nonzero whenever d<44, 316, 1316, 4548, 4524 for p=5, 13, 29,
37, 53 respectively. Theorem 2 shows each threshold is attained.

*Proof.* By the [2 October descent](2026-10-02-parity-descent.md), a
degree-d multiplier with d+N zero rows yields a terminal window of exact
degree floor(d/N), at some shift, of the form FV with deg V=floor(d/N)-N+1.
The complete covers in Section 4 exclude terminal windows with deg V below
8, 76, 326, 1134, 1128 respectively, at every shift. QED.

For p=5 the 12 October all-prime cutoff d<24 was correct but not sharp;
the true threshold is 44. The proved ordinary cutoffs N(N-1), N(3N/2-1)
and N(N+H) remain valid theorems.

**Finite exclusions for other primes (computer-assisted, all shifts).**
No terminal window with deg V<=E exists, so j-d<=N for all d<N(N+E):

| primes | N | E | strict all-shift cutoff |
|---|---|---:|---:|
| 61 | 4 | 2000 | d<8016 |
| every p congruent to 5 modulo 8 with 101<=p<=1181 (45 primes) | 4 | 250 | d<1016 |
| 41, 73, 89, 137 | 8 | 250 | d<2064 |
| 17, 113 | 16 | 250 | d<4256 |

These do not decide Delta_p for those primes. Section 7 explains why no
conclusion should be drawn from the empty ranges.

## 2. What the witnesses are not

They are not integer rank drops. The 12x9 integer matrix of the p=5 terminal
window (normalized stream, shift 311, deg V=8) has all 220 maximal minors
with gcd exactly 5; it has full rank in every other characteristic. Over a
large prime used as a proxy for the rationals, the scan of shifts M<=2000
(degrees up to about 150) found no partial quotient of degree N+1. The
witnesses are arithmetic accidents of the characteristic, consistent with
the 12 October observation that boundary minors had only small prime factors.

The genuine r=1 comparison S=1+t, M=1 over F_3 is retained as a control:
the same profile reports its terminal jump at degree zero.

## 3. Continued-fraction form of the terminal problem

Let b_v=a_v+...+a_(v+N-1), the stream of F Lambda. For V of degree e,
the rows of S=FV at shift M are sum_j V_j b_(M+k+j). So a terminal window
is exactly |<V Theta_M>| <= 2^-(N+e+1) for

    Theta_M = <t^M F Lambda> = sum_(k>=1) b_(M+k) t^-k.

By the best-approximation property of continued fractions, such a V exists
iff Theta_M has a convergent denominator of degree e'<=e whose next
partial quotient has degree at least N+1. The 5 October argument from
Lai–Sprang Proposition 2.3 shows that no FV has deg S+2 zero rows, so every
partial quotient of every Theta_M has degree at most N+1. Therefore:

> Delta_p=2N if and only if some shifted fractional part <t^M F Lambda>
> has a partial quotient of degree exactly N+1; otherwise Delta_p=N.

Equivalently, the number wall of the Lai–Sprang stream modulo p has a zero
window of side 2N-1 rather than at most N-1. One Euclidean expansion of
Theta_M, truncated after 2E+N+1 coefficients, decides all quotient degrees
e<=E at that shift. Partial quotients are correct for the infinite series
while deg Q_i+deg Q_(i+1) does not exceed the truncation length.

## 4. Complete all-shift cover

For E fixed, a terminal window with deg V<=E reads c_(M+1),...,c_(M+T),
T=2N+2E, where c=a/(N/2) is the normalized stream. Let L be the least
power of two exceeding T and P=NL. Writing M=qP+b, every index b+i not
divisible by L keeps its value: adding qNL changes its odd part by a
multiple of 2N. At most one index in the window is divisible by L; its
value is allowed to be any of 0,1,-1. This is the 12 October argument with
a larger window. The finite list of residues b and values x covers every
nonnegative shift; unrealizable x can only add conservative false alarms.

A truncated series that becomes rational at degree <=E is reported as a
conservative event, never dropped. None occurred.

## 5. Two independent scanners and a third check

- `search/lai_sprang_sharpness.py` (Python, standard library) uses the
  Berlekamp–Massey linear-complexity profile. Its values are exactly the
  convergent denominator degrees, so a jump of N+1 from complexity e is a
  terminal window at quotient degree e. It runs the p=5, 13, 29 covers.
- `search/terminal_cover.c`, driven by `search/run_terminal_cover.py`, uses
  Euclidean polynomial division instead. It runs all covers in the tables.
- The two implementations give identical hit lists for p=5 (E=30 and 250)
  and p=13 (E=80 and 250); the driver's `--verify` repeats the E=250 checks.
- For p=5 a third method computes the nullspace of every cover matrix for
  every e<=8 directly. It finds kernels exactly at (b,x,e)=(55,-1,8),
  (119,-1,8), matching both profiles.

Witnesses are taken at actual realizable shifts. For example, residue 55
modulo 128 needs c_320=c_10=c_5=-1, realized at M=311; residue 119 is first
realized at M=631. The p=13 kernel is also one-dimensional.

**Readback, independent of generation.** For every witness the verifier
divides S by F to recover V, checks both endpoints of S and R, recomputes
all rows from the original root sums sum_zeta zeta^l (no support formula,
profile or elimination), and checks the lifted rows of R=S(t^4) at m=4M.
The largest original index read is m+4 deg S+j, i.e. 1340 for p=5 and
169,828 for p=53. Mutating one coefficient of S, the shift, or j is rejected.

## 6. Why the earlier boxes saw only N

The 18 September boxes covered d<=16, m<=64; the 2 October terminal screen
covered deg V<=8, M<=64. The least p=5 terminal window has deg V=8 but its
first realizing shift is 311; the least original violation has d=44. The
degree-zero gaps and the three-term family attain only N. Nothing in those
records was wrong; the boxes were simply far too small.

## 7. Relation to Garrett–Robertson Conjecture 1.8

[Garrett–Robertson, arXiv:2405.14454v2](https://arxiv.org/abs/2405.14454)
(8 April 2025) define the level-n paperfolding sequences
Pi_i=((oddpart(i) mod 2^(n+1))-1)/2, prove the level-two series is a t-LC
counterexample over F_5 (computer-assisted, window bound not stated), and
conjecture as their Conjecture 1.8 that the infimum is q^(-2^n), with n least
such that p is not 1 modulo 2^(n+1) (so 2^n=N). This is a different series
from Lai–Sprang's: their values are 0,1,2,3, not N/2 times 1,-1,0.

As printed, the exponent conflicts with [Adiceam–Nesharim–Lunnon's
Theorem 1.1](https://arxiv.org/abs/1806.04478), which gives deficiency
exactly 4=2^(n+1) for the level-one sequence over F_3. Our own scans
agree: level one over F_3,7,11,19,23 reaches defect 4, and level two over F_5
reaches 8. An explicit level-two witness: m=61, deg R=64, R(0)=3, first
nonzero row j=72, product 5^-8 in their base-q norm. It is checked against
the fixed point of their Example 4.1 morphism, independently of the oddpart
formula. Their acknowledgement thanks Lunnon for a correction of
Conjecture 1.8, so the printed 2^n is plausibly a slip for 2^(n+1).
We do not claim to refute the intended statement. With exponent 2^(n+1),
it predicts deficiency 2N for their family, which matches what we prove
for the Lai–Sprang family at five primes.

## 8. Heuristic and open questions

Treat each realizable (window, degree) as an independent chance p^-N for a
size-N zero window in the derived number wall modulo p. Since the stream is
2-automatic, distinct windows up to degree E number on the order of E^2.
This predicts least quotient degrees of order p^(N/2). For N=4 the
observed values 8, 76, 326, 1134, 1128 are 0.32, 0.45, 0.39, 0.83, 0.40
times p^2, and p=61 has none below 2000 (ratio >0.53). The model is a
heuristic only.

For N=8 it predicts least degrees of order 41^4, about 3*10^6, at p=41,
far beyond the E=250 covers. **The empty N>=8 ranges are therefore not
evidence for Delta_p=N.** No prime with N>=8 is resolved, and neither is
p=61.

Open questions:

1. Is Delta_p=2N for every odd prime? It is for every r=1 prime: there
   c_n=(-1)^((oddpart(n)-1)/2) has no zeros, and R=1+t^2, m=2 has rows
   0,0,0,0,0,2 in every odd characteristic. It is now also true for the five
   N=4 primes above. A proof would need a
   construction not tied to sporadic arithmetic, or an argument that size-N
   windows must occur in an automatic number wall modulo p.
2. A sharper search for N=8 would need a method subquadratic in the
   degree for each shift, or an automaton description of the number wall
   modulo p, as in Adiceam–Nesharim–Lunnon and Garrett–Robertson.
3. Characteristic two is untouched by this work.

## 9. Consequences for the roadmap

- Retire the all-degree auxiliary N-bound for r>=2. It is false at
  p=5,13,29,37,53, formally so at p=5.
- Retire the 12 October plan to find a uniform dyadic identity bounding the
  terminal gcd's odd primes. At e=H it was harmless; in general p=5 divides
  the minors at e=8.
- The existing Lean descent work still formalises true statements (the
  degree cutoffs), but it is no longer a path to an all-degree bound.

## 10. Reproduction and limits

    python3 -m search.lai_sprang_sharpness results/2026-10-17-sharpness.json
    python3 -m search.lai_sprang_sharpness results/2026-10-17-sharpness.json --verify
    python3 -m search.run_terminal_cover results/2026-10-17-terminal-cover.json
    python3 -m search.run_terminal_cover results/2026-10-17-terminal-cover.json --verify
    python3 -m unittest discover -s tests -v
    lake build

Python 3.9+ standard library; the C cover needs a C compiler. No randomness.
The generator refuses to overwrite its output. Runtimes, versions and outputs
are in the JSON files and `2026-10-17-sharpness-validation.json`. Exclusions hold only
up to the stated E. The p=37 and p=53 minimality claims rely on the C
implementation, cross-checked with Python only on smaller fields. Theorem 1
is the only Lean result; Theorems 2 and 4 and Corollary 3 are ordinary or
computer-assisted proofs.

## Literature

Accessed 17 October 2026, Australia/Sydney:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633), 30 May
  2026, still the only listed version. Theorem 1.2 gives the lower bound
  2^(-2^(r+1) deg P) with base-two norm; Proposition 2.3 is the input to the
  N+1 cap above. The paper does not discuss optimality of the constant.
- [Garrett–Robertson, arXiv:2405.14454v2](https://arxiv.org/abs/2405.14454)
  and [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2](https://arxiv.org/abs/1806.04478),
  as discussed in Section 7.
- [Robertson, arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955)
  (31 October 2025): number-wall dictionary and the t to P(t) transfer.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078):
  uses the Lai–Sprang construction; no sharpness statement found in the
  scoped check. A scoped search found no prior statement that the Lai–Sprang
  constant is attained; this is not a comprehensive priority search.
