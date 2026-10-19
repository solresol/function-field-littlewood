# The Lai–Sprang constant 2N is attained for p=5,13,29,37,53,61 and 41

17 October 2026, Saturday, Australia/Sydney (AEDT).
Classification: **mathematical progress**. The auxiliary all-degree bound
j-d<=N is **false**; the 5 October N-or-2N dichotomy selects 2N for six
primes (p=61 added on 18 October); Lai–Sprang's Theorem 1.2 is therefore sharp
in those characteristics.
All six refutations are Lean kernel-checked: p=5 and p=13 in the default library
(the latter via a formalised reverse lift), and p=29,37,53,61 in the non-default
`SharpnessCertificates` target through a natural-number certificate checker with
a soundness proof. Minimality and the exclusions for other primes are
computer-assisted all-shift statements. On 19 October a number-wall search
added **p=41, the first prime with N=8** (defect 2N=16). That witness has
degree about 1.5*10^7 and is computer-verified three ways, not Lean-checked
([19 October addendum](#19-october-addendum-p41-the-first-n8-prime-attains-2n)).

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

**Theorem 2 (six primes).** For each row below, the stated S=FV (recorded
in [the JSON certificate](2026-10-17-sharpness.json), and for p=61 in
[its 18 October record](2026-10-18-sharpness-p61.json)) has exactly deg S+1
zero rows at the odd shift M, and its lift R=S(t^4), m=4M has exact defect 8=2N.

| p | M | deg V | deg S | lifted deg R | m | j | defect |
|---|---:|---:|---:|---:|---:|---:|---:|
| 5 | 311 | 8 | 11 | 44 | 1244 | 52 | 8 |
| 13 | 1465 | 76 | 79 | 316 | 5860 | 324 | 8 |
| 29 | 2501 | 326 | 329 | 1316 | 10004 | 1324 | 8 |
| 37 | 19939 | 1134 | 1137 | 4548 | 79756 | 4556 | 8 |
| 53 | 40193 | 1128 | 1131 | 4524 | 160772 | 4532 | 8 |
| 61 | 22815 | 2083 | 2086 | 8344 | 91260 | 8352 | 8 |

For p=13, [ReverseLift.lean](../FunctionFieldLittlewood/ReverseLift.lean)
kernel-checks the 81-row terminal certificate and the finitely many odd-row
residues, then derives the 323-row lifted certificate from a general theorem
(`certificate_liftTwo`): for any stream with a(2n)=a(n), doubling exponents
doubles the shift and the exact index when all odd rows vanish. Periodicity of
the odd support coefficients (`laiSprangStream_odd_period`) reduces that
condition to residues modulo N. The result is `sharp13_refutes_N_bound`.

Hence for these primes the maximum defect is Delta_p=2N=8: the infimum of
the Littlewood products of the Lai–Sprang series over F_p is exactly 2^-8.
The upper bound is Lai–Sprang's Theorem 1.2; the witnesses give equality.

**Corollary 3 (Lai–Sprang Theorem 1.2 is sharp in these characteristics).**
Let K be any field of characteristic p in {5,13,29,37,53,61} and P in K[t] any
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
1,...,d+N is nonzero whenever d<44, 316, 1316, 4548, 4524, 8344 for p=5, 13,
29, 37, 53, 61 respectively. Theorem 2 shows each threshold is attained.

*Proof.* By the [2 October descent](2026-10-02-parity-descent.md), a
degree-d multiplier with d+N zero rows yields a terminal window of exact
degree floor(d/N), at some shift, of the form FV with deg V=floor(d/N)-N+1.
The complete covers in Section 4 exclude terminal windows with deg V below
8, 76, 326, 1134, 1128, 2083 respectively, at every shift. QED.

For p=5 the 12 October all-prime cutoff d<24 was correct but not sharp;
the true threshold is 44. The proved ordinary cutoffs N(N-1), N(3N/2-1)
and N(N+H) remain valid theorems.

**Finite exclusions for other primes (computer-assisted, all shifts).**
No terminal window with deg V<=E exists, so j-d<=N for all d<N(N+E):

| primes | N | E | strict all-shift cutoff |
|---|---|---:|---:|
| every p congruent to 5 modulo 8 with 101<=p<=1181 (45 primes) | 4 | 250 | d<1016 |
| 41 (number wall, 19 October; 2N is attained) | 8 | 65,527 | d<524,280 |
| 73, 89, 137 | 8 | 250 | d<2064 |
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

For p=5 a further check (18 October, in the test suite) builds Lambda directly
from its definition, the sum of x^(2^k)/(1-zeta x^(2^(k+1))) over zeta^2=-1,
by generic power-series division over F_5 through x^1400. It then multiplies
by t^1244 R: rows 1-51 vanish and row 52 equals 4. No coefficient formula or
root-sum shortcut is involved.

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
for the Lai–Sprang family at six primes. A follow-up scan (shifts up to
60,000, truncation 600, so degrees up to about 300) finds level-two
deficiency reaching but never exceeding 8 over F_5, and reaching 7 over F_13.
This is finite evidence for the 2^(n+1) reading, not a proof.

## 8. Heuristic and open questions

Treat each realizable (window, degree) as an independent chance p^-N for a
size-N zero window in the derived number wall modulo p. The complete cover
bounds the number of (window,degree) cases by O(E^2)
for fixed N. It supplies neither a matching lower bound on distinct cases
nor independence or the probability p^-N for this structured stream. Under
those additional heuristic assumptions, the predicted least quotient degree
has order p^(N/2). (Qualified in the 18 October integration.) For N=4 the
observed values 8, 76, 326, 1134, 1128 are 0.32, 0.45, 0.39, 0.83, 0.40
times p^2, and p=61 gives 2083, ratio 0.56. The model is a heuristic only.

For N=8 it predicts least degrees of order 41^4, about 3*10^6, at p=41,
far beyond the E=250 covers. **The empty N>=8 ranges are therefore not
evidence for Delta_p=N.** No prime with N>=8 is resolved. (Superseded on
19 October: p=41 attains 2N, at quotient degree 1,916,335; see the addendum.
Its least degree is unknown.) Every N=4 prime
up to 61 attains 2N; primes p congruent to 5 modulo 8 from 101 upward are
untested beyond deg V=250.

Open questions:

1. Is Delta_p=2N for every odd prime? It is for every r=1 prime: there
   c_n=(-1)^((oddpart(n)-1)/2) has no zeros, and R=1+t^2, m=2 has rows
   0,0,0,0,0,2 in every odd characteristic. It is now also true for the six
   N=4 primes above, i.e. for every N=4 prime up to 61. A proof would need a
   construction not tied to sporadic arithmetic, or an argument that size-N
   windows must occur in an automatic number wall modulo p.
2. A sharper search for N=8 would need a method subquadratic in the
   degree for each shift, or an automaton description of the number wall
   modulo p, as in Adiceam–Nesharim–Lunnon and Garrett–Robertson.
3. Characteristic two is untouched by this work.

## 9. Consequences for the roadmap

- Retire the all-degree auxiliary N-bound for r>=2. It is false at
  p=5,13,29,37,53,61, formally so at all six primes, and at p=41 (r=3,
  computer-verified, 19 October).
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
implementation, cross-checked with Python only on smaller fields. Theorems 1
and 2 are Lean results (the latter for all six primes, see the addendum);
Theorem 4 and Corollary 3 are ordinary or computer-assisted proofs.
A direct Lean check of the p=13 lifted certificate (102,000 products) did not
finish in ten minutes, which motivated the formal lift.

## 18 October addendum: p=61 and full Lean coverage

A raksasa run of the same C program covered p=61 to deg V<=4000 in 96 residue
chunks (96,832 cases). It reported 14 conservative hits; the least is deg V=2083,
and nothing lies below it, so 2083 is least over all shifts
([analysis](2026-10-18-p61-cover.json)). At 2083 the case (b,x)=(6431,0) is
unrealizable, since its exceptional coefficient c_(1+4q) is never 0, but
(22815,0) is realized at M=22815. Berlekamp–Massey extraction and root-sum
readback confirm a terminal window of exactly 2087 rows and the lifted defect 8
at degree 8344, shift 91260, index 8352. The largest original index
read is 107,956. An earlier mid-run witness (deg V=3245, M=35113) was replaced
by this least one. `realizable_shift` in search/run_terminal_cover.py records
the realizability rule; a test compares it with actual shifts.

Lean now covers all six primes. FastCertificate.lean defines the stream as a
residue `lsNat`, proves `lsNat_cast`, and turns list dot products against a
precomputed window into `ExactCertificate` (`certificate_of_check`). Odd-row
residues and two reverse lifts then give the polynomial product 2^-8
(`product_of_checks`). Rows are checked in blocks of 100, joined by
`forall_lt_concat`, to bound kernel memory. SharpnessCertificates/P29, P37,
P53 and P61 build in 12, 98, 98 and 324 seconds on raksasa, each under 5.5 GB
([log and hashes](2026-10-18-sharpness-certificates-build.txt)). This target is
not built by default.

    python3 -m search.lai_sprang_sharpness results/2026-10-18-sharpness-p61.json --witness 61
    python3 -m search.lai_sprang_sharpness results/2026-10-18-sharpness-p61.json --verify
    python3 -m search.run_terminal_cover results/2026-10-18-p61-cover.json --analyze DIR 61 4000
    lake build SharpnessCertificates

## 18 October addendum: a number-wall engine and the N=8 cost

`search/number_wall.c` computes the number wall of a sequence over F_p with
Lunnon's frame equations, so all shifts are handled at once. A search to
quotient degree E then costs about E times the number of columns, instead of
E^2 per shift. The tests compare 5000+ wall entries with direct Toeplitz
determinants on random sequences (windows up to side 29 exercised). They also
check that side-4 windows of the p=5 derived wall coincide with the profile's
terminal windows on actual shifts. A longer local run matched all 3617
continued-fraction hits in its valid region, with no window larger than 4,
consistent with the N+1 cap.

The random model fitted at N=4 (least quotient degree about p^(N/2)/2:
predicted 12, 84, 420, 685, 1404, 1860 against observed 8, 76, 326, 1134,
1128, 2083) gives about 1.4 million for p=41, N=8. The wall area needed for
one expected hit is about N p^N, roughly 6*10^13 cells. The current engine
runs about 8*10^7 cells/s on raksasa's 12 threads, limited by serial window
bookkeeping. A ring-buffer redesign (frames read from the last g+3 rows,
compact window records, parallel detection) should approach 10^9 to 3*10^9
cells/s. At those projected rates, 6*10^13 cells alone would take about 5.6 to 16.7
hours of the whole machine, plus hours to extract and verify a degree-10^6 witness, which is far beyond
Lean. This was not run. (It was run on 19 October with a faster engine and a
corrected density; see the next addendum.)

## 19 October addendum: p=41, the first N=8 prime, attains 2N

**Theorem 5 (p=41, N=8; computer-verified).** Over F_41, let M=618,117 and
e=1,916,335. The Berlekamp–Massey connection polynomial of s_k=b_(M+k),
k=1..2e+9, reversed, gives a monic V of degree e. The linear complexity jumps
from e by exactly N+1=9 there. Put S=(1+t+...+t^7)V, D=deg S=1,916,342. Then
S has its first D+1 rows zero at shift M and row D+2 equal to 38. Its
lift R=S(t^8), of degree 15,330,736, has first nonzero row j=15,330,752 at
m=8M=4,944,936, with the same value. The defect is j-deg R=16=2N, so
Delta_41=2N. Corollary 3's argument applies unchanged: Lai–Sprang's
Theorem 1.2 is sharp in characteristic 41.

The witness is in [the record](2026-10-19-sharpness-p41.json.gz), gzipped
because V and S have about 1.9*10^6 coefficients each; it has the schema of
the p=61 record. Three independent computations agree:

1. The number wall of the derived stream modulo 41, computed through the
   frame equations, has a zero window of side 8 with top-left
   (1916335, 2534452).
2. Berlekamp–Massey on the normalized stream finds the jump N+1 at
   complexity e.
3. `search/terminal_witness.c` reads back all D+2 terminal rows and all j
   lifted rows from the root-sum definition. It reads no support formula,
   profile or wall. It also divides S by 1+...+t^7 to recover V, checks both
   endpoints, and rejects a mutated coefficient and a mutated shift. The
   largest original index read is 35,606,424. On raksasa the readback
   took 37 s for the terminal rows and 295 s for the lifted rows.
   Berlekamp–Massey took 22 hours (19 October 03:28 to 20 October 01:31)
   because per-term thread synchronisation stalls on a loaded shared
   machine; the extractor now runs it on one thread.

An independent spot-check (`search/p41_spot_check.py`) with the
repository's Python root-sum oracle (`search/run_rank_experiments.py`) agrees. It confirms S=(1+...+t^7)V and
that 20 terminal rows vanish, including D-1, D and D+1, while row D+2=38.
It also checks five lifted rows, including row j=38.

Lean is out of reach. The terminal certificate alone has about 3.7*10^12
products. The 102,000-product p=13 lifted certificate already failed to
finish a direct Lean check in ten minutes.

The least degree for p=41 is unknown. It satisfies 65,528 <= e <= 1,916,335
(below). Inside the scanned region the run stops at the first row holding a
side-8 window, so no terminal window has smaller degree there. Shifts beyond
that region are untested for 65,528 <= e < 1,916,335.

**Engine.** `search/number_wall.c` now keeps only the last gmax+4 rows in a
ring and keeps no window records. When the divisor W[m-2][n] is zero it scans
up to the window's top row and across it, then reads the frame values A to G
from the ring. Isolated zeros, about 97% of cases, use the combined formula

    H = (C0 (F A1^2 - B1^2 E) + A0 B1^2 G) / (A0 A1^2),

obtained from the second and third frame equations with D1=-B1 C1/A1. Rows
run in parallel column chunks with AVX2 for the cross rule and this formula.
Each chunk also counts the windows that start in it; the two edge zones are
redone serially, so cuts of the valid range follow the old rules exactly.
The record-based version is kept as `search/number_wall_ref.c`. The tests
require identical output (every row, window, cut and final range) on 80
random sequences, with gmax 64 and 8 and windows larger than 8, and on three
derived streams. They use many small chunks and the per-row serial
cross-check. On raksasa (12 threads) the engine runs 3-4*10^9 cells/s for
rows up to 10^6 wide and 2.7*10^9 at 1.2*10^7, against 9.4*10^7 for the old
engine on the same input. Under other jobs on the shared machine the run
averaged 1.8*10^9. `search/terminal_witness.c` reproduces all six recorded
N=4 witnesses exactly; tests also feed it 40 wall windows at p=5.

**The deep p=41 derived wall behaves like a random wall.** Over F_q a Hankel
determinant vanishes with probability exactly 1/q (q^(2n-2) singular n x n
Hankel matrices). Side-g windows have relative frequencies (q-1)q^-(g+1)
from the continued-fraction degree law. Together these give the per-cell
density

    rho_g = (q-1)^3 / ((q+1) q^(g+2)).

The 18 October figure omitted the normalization factor (q-1)/(q+1). Below
row 20,000 the p=41 derived wall matches rho_g band by band: within 0.1% for
g=1,2, about 1% for g=3,4 and 4% for g=5. Side 6 is overdispersed by a factor
of 2 to 3, since repeated factors repeat windows. The first 20,000 rows carry
an excess of structural windows of sides 4 to 7; side 7=N-1 gives the
defect-N branch. Hence rho_8=1.14*10^-13, one side-8 window per 8.8*10^12
distinct cells.

**Distinct cells.** A cell W[m][n] depends only on the factor
b_(n-m+1..n+m+1). The N=8 derived stream has about 10.5 L distinct factors
of length L, measured up to L=3*10^5 with `search/factor_counts.c`. Most
top-row cells therefore repeat. Before the run, the full C=1.2*10^7 triangle
(3.6*10^13 cells, 3.07*10^13 distinct) was expected to hold 3.5 side-8
windows if Delta_41=2N and the deep wall stays random at side 8. The rows
actually searched, 0 to 1,916,335, hold 1.88*10^13 cells, 1.40*10^13
distinct, where the model expects 1.6. One appeared, in the last row
searched.

**Run.** User-approved, 19 October 00:29–03:24 AEDT on raksasa: 12 threads at
nice 10, 240 MB, a checkpoint every 30 minutes. It was due to stop at 07:20
and stopped itself at the first side-8 window. (The follow-up extraction
then ran until 01:31 on 20 October, past the 07:30 limit, because its
timeout killed only a wrapper process.) At the 00:59 checkpoint the
build was switched to dynamic chunk scheduling (identical output), and the
run resumed from row 275,835. Commands, source hashes, band histograms and
valid ranges are in [the run record](2026-10-19-p41-number-wall.json). The
run met 4.34*10^11 windows; by side 1 to 8 they number 4.23*10^11,
1.03*10^10, 2.52*10^8, 6.60*10^6, 4.78*10^5, 1.44*10^5, 2.81*10^5 and 1.

**All-shift consequence (computer-assisted).** Take E=65,527, so T=2N+2E is
just below L=2^17, and P=NL=2^20. Off the one index divisible by L, the
window c_(M+1..M+T) is periodic in M with period P. At that index
c_(qP+h)=c(qN+h/L), and every value of c(qN+w) already occurs for some q in
[1,N] (brute force in the tests). So every shift has an equivalent shift in
[P,9P). Those shifts lie inside the framed region at every row e<=E, and no
side-8 window appeared there. Therefore no p=41 terminal window with
deg V<=65,527 exists at any shift, and j-d<=N for all d<524,280. The
previous cover gave d<2064. `search/number_wall_summary.py` performs this
check from the logs. At p=5 and p=13, every one of 6,457 windows found at
arbitrary shifts has an equivalent window in [P,(N+1)P).

**What this does and does not settle.** Delta_41=2N, so every prime decided
so far attains 2N: all r=1 primes, all six N=4 primes up to 61, and 41. The next N=8 primes cost far more under the same model:
rho_8~(p-1)^3 p^-10, so p=73 needs about 100 times as many distinct cells.
For N=16 the density is near 10^-20 at p=17, so brute force cannot reach
it. The random-wall agreement at p=41 is evidence for the heuristic that
every odd prime attains 2N. The expected number of side-N windows grows
without bound with depth because distinct cells grow like R^2. It is not a
proof.

    cc -O3 -march=native -fopenmp -o number_wall search/number_wall.c
    OMP_NUM_THREADS=12 ./number_wall 41 8 1 12000000 6000000 8 gmax=16 stop ckpt=ckpt
    cc -O3 -march=native -fopenmp -o terminal_witness search/terminal_witness.c
    ./terminal_witness 41 618117 1916335 w41.json
    python3 search/p41_spot_check.py results/2026-10-19-sharpness-p41.json.gz
    python3 search/number_wall_summary.py RUN_DIR OUT.json --factors FACTORS --run-info INFO

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
