# A uniform dyadic-gap minor and the remaining terminal strips

14 October 2026, Wednesday, Australia/Sydney (AEDT).
Classification: **mathematical progress on the auxiliary proof obstruction**,
by an ordinary structural proof. No all-degree result, stronger all-shift
degree cutoff, characteristic-two advance, Lean theorem or novelty claim.

## Question and decision

Can adjacent differences of the original terminal rows produce a minor whose
odd prime divisors are controlled uniformly in N? This question was stated
before coding. A uniform identity would remove part of the scale dependence
in the 12 October boundary certificates; failure would identify information
that the proposed simplification loses. We reused those same N=4,8,16 covers,
without enlarging the prime search or exporting more optimized certificates.

The result is a constructive triangular minor outside explicit exceptional
strips, for **every dyadic N>=4**. At quotient degree H=N/2 it confines any
terminal failure to

    floor((M+H)/N) = 0 or -1 modulo H.

For N>=8 this is a proper restriction, of density 4/N among nonnegative
shifts. It does not exclude the strips themselves. An actual N=8 example
below shows that the single-gap triangular argument cannot cover them all.
This redirects the uniform boundary problem to interacting short gaps, not
more primes or routine larger shift covers.

## Statement

Fix N=2^r with r>=2, H=N/2, and the integer normalized stream

    c_n = (-1)^h if oddpart(n)=1+Nh, and 0 otherwise, n>=1.

Write F=1+t+...+t^(N-1). For quotient degree e>=0 and shift M>=0 define

    A[k,j] = sum_(i=0)^(N-1) c_(M+k+j+i),
    1<=k<=N+e, 0<=j<=e.

Thus Av consists of all deg(FV)+1 original rows for a degree-e polynomial
V; no assumption on its constant coefficient is needed. Put

    q=floor((M+e)/N), s=(M+e) mod N,
    b=the even member of {q,q+1},
    u=2^min(v_2(b),r-1), with v_2(0)=infinity.

**Gap lemma.** If e+u<N, a square minor of the adjacent-difference matrix
Delta A has determinant

    (-1)^(e(e+1)/2) z^(e+1), with z in {-2,-1,1,2}.

In particular A has full column rank over every field of odd characteristic.
The gcd of all maximal integer minors of A divides a power of two. The latter
follows from Cauchy--Binet: the displayed difference minor is an integer linear
combination of maximal minors of A. A terminal zero window is therefore
impossible under the displayed inequality, uniformly in N and the prime.

The statement also concerns the integer stream reduced in characteristics
incompatible with N. For the Lai--Sprang interpretation we additionally retain
N=2^v_2(p-1); its coefficients are H*c_n, and H is invertible modulo odd p.

## Proof, including row budgets

Set d_n=c_(n+N)-c_n. Telescoping gives

    (Delta A)[k,j]=A[k+1,j]-A[k,j]=d_(M+k+j),
    1<=k<=N+e-1, 0<=j<=e.

First inspect the open block qN<n<(q+1)N. Nonzero coefficients can occur
only at n=qN+2^v, 0<=v<r: if c_n is supported then n modulo N is a power
of two, and the same holds for c_(n+N). More precisely,

    d_(qN+1) = -2*(-1)^q,
    d_(qN+2^v) = 1_(2^v divides q+1)*(-1)^((q+1)/2^v)
                 -1_(2^v divides q)*(-1)^(q/2^v), 1<=v<r,

where an exponent is used only when its indicator is one. Exactly one of q
and q+1 is even. Hence the last nonzero entry in this open block is
t0=qN+u, it has value 1 or -1, and

    d_n=0 for t0<n<(q+1)N.

This includes q=0, where u=H and the entries at powers 2,...,H are -1.
Always 2<=u<=H; here r>=2 is essential. The gap has length N-u-1>=e.

We choose a nonzero pivot t in the *available central interval*

    M+e+1 <= t <= M+N+e-1.

- If s<u, take t=qN+u. Its next e entries are zero and d_t=+/-1.
  Its distance from M+e=qN+s is u-s, between 1 and N-1.
- If s>=u, first try t=(q+1)N. When d_t!=0 it belongs to
  {-2,-1,1,2}, and its previous e entries are zero. When d_t=0,
  take t=(q+1)N+1 instead; d_t=-2*(-1)^(q+1), and its previous e
  entries are again zero. The respective distances are N-s and N+1-s.
  They lie between 1 and N-1 because s>=u>=2.

Select the e+1 consecutive difference rows

    k=t-M-e,...,t-M,

and all columns. The central interval proves that their first index is at
least 1 and their last index at most N+e-1. After reversing columns, the
matrix is triangular: its diagonal is d_t, and entries on one side sample
the chosen e zeros. Column reversal has sign (-1)^(e(e+1)/2). This proves
the determinant formula and all assertions of the lemma. QED.

The original coefficient endpoint is M+2N+2e-1, inclusively; no tail is
truncated or padded. Every chosen difference row uses two available original
rows, including at the extreme allowed first and last positions.

## Consequences and exact remaining scope

1. Since u<=H, every e<H is excluded at every shift, even without a relation
   between N and the odd characteristic. This gives a purely integer,
   original-row proof of the 9 October low-degree exclusion. Its admissible
   Lai--Sprang degree cutoff is unchanged; the new content is the explicit
   minor and the ensuing shift restriction beyond that range.
2. For e=H, a possible terminal window requires u=H, equivalently
   q=0 or -1 modulo H. These are the only unexcluded classes of
   floor((M+H)/N). Equivalently M modulo NH lies in the interval
   [-3H,H-1] modulo NH, of length 2N. At N=4 it is the whole period,
   consistent with the actual modulo-3 obstruction from 12 October.
3. More generally, if u<=H/2, the same argument excludes every
   e<=3N/4-1 **whose own q=floor((M+e)/N) has this property**. The q
   condition depends on e; it cannot be held fixed while changing degree.

No new *all-shift* cutoff beyond 12 October is claimed. For r>=5 the
previous all-shift cutoff d<N(3N/2-1) remains the supported one. The
all-degree N-or-2N dichotomy is still undecided. This lemma localizes the
terminal shift after descent, and is not a condition directly on the
original multiplier's shift without transporting it through that descent.

## Why a single zero gap does not finish the boundary proof

Take the actual integer stream at N=8, e=4, M=21. The difference entries
d_22,...,d_36 are

    0,0,1,2,1,0,-1,0,0,0,-1,-2,-1,0,1.

The possible central pivots are t=26,...,32. None is a nonzero entry with
four consecutive zeros on either side. Thus **no minor of the specific
consecutive-row triangular form used above exists**. This does not rule out
other triangular minors, nonconsecutive rows, or row operations.

The first five original rows, on the other hand, have determinant 12,
nonzero modulo 41 (the admissible prime used for this scale). The old complete
certificate already handles this shift and all admissible primes at N=8.
It is an odd shift in the exceptional classes, but not a terminal
counterexample. The next useful step is a symbolic
multi-pivot elimination inside the exceptional strips, tracking the two
adjacent dyadic tails and their boundary values. Repeating a general rank
cover at larger N would not supply that missing identity.

## Exact checks and reproduction

Run from the repository root:

```sh
python3 -m search.terminal_gap_check
python3 -m unittest discover -s tests -v
```

`search/terminal_gap_check.py` is a narrow proof checker, not a new optimizer.
It constructs the lemma's minor in the **existing** complete abstract covers
at N=4,8,16, e=H. Independent readback expands
sum_k x^(2^k)/(1+x^(N*2^k)), builds original F rows, subtracts them, checks
the triangular zeros and endpoints, and evaluates the determinant over
Fractions. The exceptional coefficient still ranges over 0,1,-1. The
constructive lemma handles 0/152, 304/624 and 1888/2528 cover cases;
the remaining cases are not claimed singular or independent.

Finite identity controls use the listed degrees {0,H-1,H,3N/4-1,N-2,N-1}
(duplicates removed) and actual shifts 0,...,3N-1 at these same scales.
These check the general inequality and its endpoints, not new degree bounds
inferred from a search. Tests additionally use original root sums over
p=5,13,41,17 at shifts 2^55*N plus offsets 0,1,N-1,N,2N-1,2N.
Malformed pivots/row endpoints are rejected. The genuine r=1 terminal
window [0,0,2] and the earlier wrong-characteristic N=4 control are retained.

Python version, exact finite inputs, runtime and the failure control are in
`2026-10-14-gap-check.json`; test outcome is in `2026-10-14-validation.json`.
Standard library only, deterministic, seed null. An initial scratch readback
had an undersized control-array endpoint; it raised IndexError, was corrected
to M+2N+2e-1, and the full check was rerun. No failed run is counted as a
verified result. No Lean source, toolchain, catalogue or archive was changed,
and no Lean build or kernel verification is claimed.

## Primary literature boundary

Accessed 14 October 2026, Australia/Sydney:

- [Lai--Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  submitted 30 May 2026, remains the listed version. Its odd-characteristic
  theorem settles main-conjecture counterexample existence. Section 3 supplies
  the parity method behind the repository's earlier descent. Today's lemma
  concerns the sharper auxiliary bound for the already known stream.
- [Badziahin--Pavlenkov--Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  submitted 22 August 2026, still conditions its characteristic-two conclusion
  on existence of a counterexample. Scoped arXiv searches for characteristic-two
  Littlewood results and Lai--Sprang found no later relevant resolution;
  noisy indexing is not a proof of absence or a novelty search.
- [Adiceam--Nesharim--Lunnon, arXiv:1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  retains the quadratic-series exclusion and binary paperfolding application;
  its Thue--Morse discussion states unbounded deficiency.
  [Garrett--Robertson, arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5)
  retains the unbounded-window discussion. Rational series are excluded by
  clearing denominators. No new binary candidate was selected and none of the
  retired streams was expanded.
