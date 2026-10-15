# Two-residue localization of odd terminal boundary windows

16 October 2026, Friday, Australia/Sydney (AEDT).
Classification: **mathematical progress on the auxiliary bound**, by an ordinary
uniform proof. No all-degree theorem, new all-shift degree cutoff, Lean theorem,
characteristic-two construction or publication-novelty claim.

## Question and outcome

Before coding: can multi-row elimination exclude the exceptional odd shifts
left by the 14 October gap lemma, uniformly in dyadic N, rather than adding
larger complete covers? A uniform obstruction would advance the degree-H
boundary proof; a rank failure would identify missing coefficient constraints.
Here H=N/2. The difference-only elimination probe on the existing N=8,16
covers suggested that original-row constants were unnecessary, but did not
supply a uniform algorithmic proof. The argument below extracts three explicit
identities instead.

**Theorem.** Let N=2^r>=8, H=N/2, and work over any field of odd
characteristic with the normalized stream

    c_n = (-1)^h if oddpart(n)=1+Nh, and 0 otherwise (n>=1).

Let F=1+t+...+t^(N-1). If M>=0 is odd, deg V=H, V is nonzero, and
all deg(FV)+1=N+H original rows vanish, then necessarily

    M = 1-N or 1-H modulo NH.

There is no assumption N=2^v_2(p-1) in this odd-shift theorem. For the
admissible Lai–Sprang stream that relation is retained; scaling c by H is
invertible, and the earlier even-shift factor lemma excludes even shifts at
this degree. Thus only **two residues modulo N^2/2** can remain at the
boundary, uniformly for r>=3. Their density among all shifts is 4/N^2.
The earlier localization had density 4/N before the even-shift exclusion,
or 2/N after it. Neither localization says these residues actually fail.

At N=8,16 all shifts were already excluded by the 12 October finite proof.
The new result is uniform in N. For r>=5 it narrows the first unresolved
quotient degree; it does not improve the existing all-shift cutoff. N=4 is
outside the new theorem, and its genuine characteristic-3 rank obstruction
remains a required control. The genuine r=1 comparison is also unchanged.

## Rows, endpoints, and notation

Write V=sum_(j=0)^H v_j t^j. The original matrix and its differences are

    A[k,j] = sum_(i=0)^(N-1) c_(M+k+j+i), 1<=k<=3H,
    D[k,j] = A[k+1,j]-A[k,j] = d_(M+k+j), 1<=k<=3H-1,
    d_n = c_(n+N)-c_n.

The inclusive original coefficient endpoint is M+3N-1=M+6H-1.
All equations below are consequences of Av=0, not of a truncated or padded
stream. In particular Dv=0. Define the twice-separated rows

    E[k,j] = D[k,j]+D[k+N,j]
           = c_(M+k+j+2N)-c_(M+k+j), 1<=k<=H-1.

Both D rows lie in 1,...,3H-1, including the last allowed one. Put
E(n)=c_(n+2N)-c_n for the underlying sequence.

We may assume v_0 and v_H are nonzero. The leading one follows from exact
degree. If v_0=0, remove the maximal power t^l dividing V and replace M by
M+l. The same 3H zero rows contain the required N+H-l rows for a quotient
of degree H-l<H, contradicting the 14 October low-degree gap theorem
(valid over every odd characteristic). This is a use of a proved lower-degree
result, not an endpoint assumption on arbitrary matrix kernels.

The old gap lemma reduces to q=floor((M+H)/N)=0 or -1 modulo H. Choose
K divisible by H so that q is K or K-1, and put B=KN and z=M-B. Then

    -3H <= z <= H-1.

Since M is odd and B,H are even, z is odd; the actual lower endpoint is
-3H+1. B=0 is possible only in the nonnegative-shift part of this range.
All indices used below are positive and inside the stated original window.

## Support identities used in the proof

For an open N-block, nonzero c or d entries have offsets that are powers
of two. The preceding-block formulas and identities 1–2 below are used only
when B>0; the B=0 case uses identity 3 alone. The 14 October support computation gives, for K divisible by H,

    d_(B-N+1)=2,
    d_(B-N+2^v)=1             (1<=v<r-1),
    d_(B-H)=sigma=(-1)^(K/H),

with all other interior entries of (B-N,B) zero. The next open block has
their negatives. The unknown endpoint d_(B-N) is denoted a.

The following identities keep the boundary values, rather than guessing them:

1. On B-3H<n<B, E(n) is zero except possibly at n=B-N, where
   E(B-N)=alpha=c_(B+N)-c_(B-N).
2. On B-H<=n<=B+2, E(n) is zero except at B and B+2, where
   E(B)=beta=c_(B+2N)-c_B and E(B+2)=-2.
3. In the open block (B+N,B+2N), the last nonzero d entry is
   d_(B+N+2)=-1, followed by N-3 zeros.

For completeness, identity 1 before B-N compares offsets in (H,N) in
two blocks; neither has supported coefficients. After B-N, the two block
indices are K-1 and K+1: both are odd, so only offset 1 is supported, with
the same coefficient -1. For identity 2, the negative offsets use that same
comparison. At offset 1 the signs at block indices K and K+2 coincide;
at offset 2 they are 1 and -1 because K is divisible by H>=4.
For identity 3 the even member of {K+1,K+2} has valuation exactly one,
so the last support offset is 2, with value -1. These arguments use H>=4;
they do not extend unchanged to N=4.

## First strip: antiperiodicity and a sparse divisor obstruction

Suppose -3H+1<=z<=-2H-1. Identity 1 applies to every E entry because
its coefficient indices lie in [M+1,M+N-1], a subset of (B-3H,B).
At k=B-N-M=-N-z, which lies in 1,...,H-1, the E row is
(alpha,0,...,0). Since v_0!=0, alpha=0.

Consequently d_(n+N)=-d_n throughout the overlap
M+1<=n<=M+N-1. The complete available d segment, of length 2N-1,
is therefore the restriction of an antiperiodic sequence of period N.
It contains the whole block B-N,...,B-1, whose polynomial is

    f(x)=a+2x+x^2+x^4+...+x^(H/2)+sigma*x^H.

There are 3H-1>=N consecutive zero D rows. They assert that cyclic
convolution by V vanishes at every residue modulo N with sign on wrapping.
More explicitly, with W(x)=x^H V(x^(-1)), all coefficients of Wf modulo
x^N+1 vanish: a coefficient at i+H is the corresponding forward row
sum, with the sign imposed by antiperiodicity. Thus x^N+1 divides Wf.
Both W and f have degree H, so their product is a nonzero scalar multiple
of x^N+1. In particular **f divides x^N+1**.

This is impossible in odd characteristic. If f divides x^N+1 then a!=0.
Also f(x)-f(-x)=4x, so f(x) and f(-x) are coprime. As N is even, both
divide x^N+1, and their degrees sum to N. Their product is monic
(sigma^2=1 and H is even), hence

    f(x)f(-x)=x^N+1.

But its x^6 coefficient is 2*sigma when H=4 and 2 when H>=8.
Indeed only the exponent pairs (2,4) and (4,2) contribute; the odd term
only contributes to degree 2. This coefficient is nonzero in odd
characteristic, whereas x^N+1 has zero x^6 coefficient for N>=8.
This contradiction excludes the entire first strip, with no characteristic
relation or enumeration of primes.

## Middle strip: two rows isolate the leading coefficient

Suppose -2H+3<=z<=-H-1. Set k0=-H-z and k2=k0+2.
Then 1<=k0<k2<=H-1. By identity 2 their E rows are

    E[k0,*] = (0,...,0,beta),
    E[k2,*] = (0,...,0,beta,0,-2).

The first row forces beta=0 because v_H!=0; the second then gives
-2v_H=0, a contradiction. The preceding odd offset z=-2H+1 is not
covered: k2=H+1 would exceed the available E rows. This missing row is
an actual proof boundary, not permission to extend the coefficient window.

## Last strip: use the next short-tail block

Suppose -H+3<=z<=H-1. By identity 3 take t=B+N+2, with d_t=-1
and H following zeros (N-3>=H). The H+1 consecutive D rows

    k=t-M-H,...,t-M

lie in 1,...,3H-1: the lower bound is immediate and the upper bound is
equivalent to z>=3-H. Reversing columns gives a triangular matrix with
all diagonal entries -1. It is invertible over any field. The preceding
odd offset z=-H+1 fails this row budget by two rows and is left open.

The three strips exhaust all odd z in [-3H,H-1] except
z=1-N and z=1-H. This proves the theorem. QED.

## Checks, attempts, and limits

`search/terminal_two_strip_check.py` reads the original rows from the
independent integer formal series sum_k x^(2^k)/(1+x^(N*2^k)). It verifies
the telescoping equations, sparse E rows, complete antiperiodic block,
reflection coefficient, cyclic-convolution coefficient correspondence and
triangular last-strip minor. The input is exactly
the existing complete abstract covers at N=8,16, with the one exceptional
coefficient allowed to be 0,1,-1. No larger complete cover was generated.
The proof is uniform; these finite checks do not supply its universal step.

| N | Old-gap cases | First strip | Middle strip | Last strip | Remaining abstract cases |
|---|---:|---:|---:|---:|---:|
| 8 | 160 | 48 | 24 | 40 | 48 |
| 16 | 960 | 96 | 72 | 104 | 48 |

Only odd shifts are counted. The residual residues are 25,29 modulo 32
and 113,121 modulo 128. Their abstract case multiplicities include free
boundary values; they are not counts of actual counterexamples.

Exploration first used exact Fraction elimination with power-of-two pivots
on the existing exceptional odd-shift matrices at N=4,8,16. It fully
eliminated N=8,16, but retained odd-factor residuals at N=4. Seven prescribed
relative shifts z in {-3H+1,-2H+1,-H-1,-H+1,-1,1,H-1}, at the single
boundary B=NH for N=8,16,32, were then used to inspect pivot patterns.
That diagnostic was not a complete larger cover or a proof of rank uniformity;
the direct identities above supersede its adaptive elimination. No random
search, multiplier enumeration, timeout conclusion or empirical novelty claim.
An initial scratch command used an invalid relative module invocation; it did
not run and was corrected before the successful probe. Scratch probes completed
in under one second each; they are not part of the retained proof checker.

Reproduction from the repository root:

```sh
python3 -m search.terminal_two_strip_check
python3 -m unittest discover -s tests -v
```

The dated JSON gives Python 3.14.4, standard-library-only dependencies,
seed null and checker runtime. The 57-test suite passed in 7.253 seconds,
including corruption rejection, branch/endpoint controls, original-root-sum
regressions and the retained N=4/modulo-3 and r=1 comparisons. The existing
retired binary regressions were not expanded. No Lean code, dependencies,
proof catalogue or release changed; no Lean build is claimed.

## Literature boundary and next decision

Primary sources accessed 16 October 2026, Australia/Sydney:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  submitted 30 May 2026, remains the listed version and settles main-conjecture
  counterexample existence in all odd characteristics. Today's result is only
  about the sharper auxiliary bound for that explicit stream.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  submitted 22 August 2026, retains a conditional characteristic-two conclusion.
  The scoped arXiv search found no later relevant resolution; this is not proof
  of absence or a novelty search.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, Section 7.2](https://arxiv.org/html/1806.04478v2#S7.SS2)
  retains the quadratic-series exclusion and binary paperfolding application;
  its Thue–Morse discussion also states unbounded deficiency. Rational series
  are excluded by clearing denominators.
  [Garrett–Robertson, arXiv:2405.14454v2, Section 5](https://arxiv.org/html/2405.14454v2#S5)
  discusses the known unbounded windows. No binary candidate was selected.

Next computation: at the two remaining offsets, preserve the actual missing
E-row budget and combine an original A row with the available D/E equations.
Do not assume the out-of-window rows vanish. A useful next formal lemma is the
sparse divisor obstruction f not dividing x^N+1 in odd characteristic, or its
antiperiodic convolution bridge when needed. Do not default to formalising
all of today's bookkeeping or extending complete covers.
