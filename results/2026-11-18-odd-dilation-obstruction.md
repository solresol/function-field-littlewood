# Direct odd-prime dilation fails in characteristic two

18 November 2026, Wednesday, Australia/Sydney; executed 17 November UTC.

**Classification: mathematical progress on a failed characteristic-two
construction.** An ordinary all-scale proof rules out the direct unweighted
odd-prime analogue of Lai–Sprang's root-sum construction. Its defect is
unbounded, even though its series is transcendental over F_2(t). This changes
the candidate screen, not the unresolved characteristic-two conjecture or
uniform odd-characteristic `Delta_p=2N`. No novelty or Lean theorem is claimed.

## Question and source screen, before implementation

Read the latest [13 November weekly human-literature checkpoint](2026-11-06-literature-review.md#13-november-2026-checkpoint),
current roadmap, 15–17 November records and actual recurrence, target and
finite-certificate sources. The recent repeated-block approach has no compatible
moving rejection covector. Choose a different, motivated family rather than
another length sweep or generic formal lemma.

Question stated before coding: does Lai–Sprang Proposition 2.3's crucial
nonvanishing property survive ternary dilation in characteristic two, using
primitive cube roots in F_4? Namely, can a nonzero multiple of `t^3-1` have
more initial zero fractional coefficients than its degree? A surviving property
would support a construction; failure would require understanding whether it
scales and retiring the construction if it does. The result extends to every
odd prime dilation below.

Targeted primary reading, accessed **17 November UTC / 18 November Sydney**:

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/html/2606.00633v1),
  30 May 2026, still the sole displayed version: Theorem 1.2, equation (1.2),
  Proposition 2.3 and the reduction. The proved odd-characteristic lower bound
  does not assert this characteristic-two generalization or uniform attainment.
- [Adiceam–Nesharim–Lunnon, arXiv:1806.04478v2, §7.2](https://arxiv.org/html/1806.04478v2#S7.SS2),
  11 October 2020: paperfolding and pagoda over F_2 are quadratic; the cited
  quadratic-series theorem implies unbounded deficiency. Theorem 2.2 relates
  unbounded deficiency to t-adic Littlewood. The present stream is different
  and, as shown below, transcendental, so the quadratic exclusion does not
  supply today's result. Rational inputs remain excluded too.
- [Garrett–Robertson, arXiv:2405.14454v2, §5](https://arxiv.org/html/2405.14454v2),
  8 April 2025: the recorded unbounded-window examples concern Thue–Morse,
  paperfolding and Cantor inputs. The Cantor digit-restriction sequence is not
  the unit-part root-sum stream below. Their automatic-wall assertion is a
  conjecture, not a theorem excluding every automatic stream. No applicable
  all-automatic or odd-dilation exclusion was found in this targeted reading.

Exact-family searches for ternary/odd-dilation root-sum and Mahler variants
located no applicable source. This is a limited screen, not an exhaustive
literature or priority claim. The weekly review's journal full-text gaps remain;
no broad daily review or other bot's claimed result is used.

## The family and coefficient normalization

Let `ell>=3` be an odd prime, `r>=1`, `N=ell^r`, and `H=N/ell`. In a splitting
field of characteristic two define

    Lambda_(ell,r)(t) = sum_(v>=0) sum_(ord(zeta)=N)
        t^((ell-1)*ell^v) / (t^(ell^(v+1))-zeta).

This is a specific direct analogue, with numerator chosen so its seed indices
are `ell*j+1`. It is not a claim about all choices of numerator or root weights.
The sums converge formally because their orders tend to infinity.

The coefficient of `t^(-(ell*j+1))` in the seed is

    sum_(ord(zeta)=N) zeta^j
      = sum_(zeta^N=1) zeta^j - sum_(zeta^H=1) zeta^j
      = 1_(N divides j) + 1_(H divides j)                 in F_2.

The geometric root sums are valid since N is odd. This is 1 exactly when
`j=H*b` with `ell` not dividing b. Every positive index has a unique form
`n=ell^v*u` with `ell` not dividing u. Thus the entire coefficient stream is

    c_n = 1  iff  u = 1+b*N mod ell*N,  1<=b<ell;       (1)
    c_n = 0  otherwise.

In particular all coefficients descend to F_2. The construction and the
conclusion therefore make sense over every characteristic-two ground field,
whether or not it itself contains the displayed roots. No scalar normalization
is omitted. For ell=3,N=3 the seed is `x^4/(1+x^3+x^6)`, with x=t^-1.

## Exact all-scale obstruction

**Theorem.** Put `L=ell^a`, for any `a>=0`. At shift `m=L`, the multiplier

    R_a(t) = 1+t^(N*L)

has degree `d=N*L`, nonzero endpoints, and exact first nonzero fractional index

    j=(ell-1)*N*L,     j-d=(ell-2)*N*L.                 (2)

It is divisible by `t^N-1`. Consequently these series satisfy t-adic Littlewood,
with products `2^(-(ell-2)*N*L)` tending to zero. In particular none is a
counterexample. The corresponding proposed Proposition 2.3 already fails at
`a=0`: `R=1+t^N`, shift 1, has `j>d`.

**Proof.** First take `a=0`. Among indices `2,...,ell*N+1`, the only nonzero
coefficients are at

    N+1, 2*N+1, ..., (ell-1)*N+1.

Indeed, a positive ell-adic valuation in this interval leaves unit part at most
N, below the first supported value N+1. At valuation zero, (1) gives exactly
the listed indices. The filtered coefficients at shift 1 are

    b_h=c_(1+h)+c_(N+1+h).

For `1<=h<(ell-1)*N`, only `h=N,2N,...,(ell-2)*N` can contribute, and both
summands are 1 there, cancelling in characteristic two. At `h=(ell-1)*N`
the values are 1 and 0. This proves the exact base index.

For general a the complete dilation identity is

    c_(L+h)+c_((N+1)*L+h) = 0                         if L does not divide h;
                              b_(h/L)                if L divides h.       (3)

For the first case put `v=v_ell(h)<a`. Both indices have valuation v, and their
unit parts differ by `N*ell^(a-v)`, a multiple of `ell*N`. Formula (1) makes
the coefficients equal. In the second case, divide both indices by L using
`c_(ell*n)=c_n`. This proves (3) at every positive h, then (2).

Finally `R_a=(t^N)^L-1` in characteristic two, hence `t^N-1` divides it.
For `Q_a=t^L R_a`, the t-adic factor removes exactly the shift L because
`R_a(0)=1`. Thus `|Q_a| |Q_a|_t ||Q_a Lambda||=2^(d-j)`, giving the stated
limit. Nonzero filtered value 1 is preserved under every field extension. QED.

For the initial ternary case this reads `m=3^a`, `R=1+t^(3^(a+1))`,
`j=2*3^(a+1)`, defect `3^(a+1)`. The failure is an infinite algebraic
mechanism, not an inference from a finite lack of witnesses.

## Why the quadratic retirement did not already settle this family

Formula (1) gives a finite ell-kernel: `c_(ell*n)=c_n`; nonzero residues other
than 1 give zero, and `c_(ell*n+1)` is periodic modulo N, indicating
`H|n` and `N` not dividing n. Subsequences of this periodic sequence have a
finite kernel. Hence c is ell-automatic.

It is not ultimately periodic. For any proposed period P>0, choose
`k>v_ell(P)+r`. The unit part of `A*ell^k+P` equals that of P modulo ell*N,
so `c_(A*ell^k+P)=c_P`. But `c_(A*ell^k)=c_A`, and choosing A=1 or N+1
makes this value 0 or 1, opposite to c_P. These mismatches occur arbitrarily far
out, contradicting eventual periodicity.

[Christol–Kamae–Mendès France–Rauzy, Theorem 1](https://www.numdam.org/item/BSMF_1980__108__401_0.pdf),
*Bull. Soc. Math. France* 108 (1980), pp. 406–409, identifies algebraic series
over F_2(t) with 2-automatic coefficient streams. Its §8, pp. 409–410, states the
Cobham implication: recognizable in multiplicatively independent bases means
ultimately periodic. Since 2 and ell are independent, c cannot be 2-automatic
and its generating series is transcendental over F_2(t). The original
[Cobham publication record](https://research.ibm.com/publications/on-the-base-dependence-of-sets-of-numbers-recognizable-by-finite-automata)
states the same base-dependence condition. Both sources accessed today;
the 1980 full text and its cited theorem statements were read, without a
separate replay of Cobham's proof. Thus today's retirement is not a repetition
of a rational/quadratic example. No copied proof text or external code is used.

## Exact checks, limits and next decision

The first bounded pilot allowed degrees 3–12 and shifts 0–26 but stopped at
degree 3, shift 1, after checking shifts 0 and 1 only. It found `R=1+t^3`,
`j=6`. A seven-scale check `a=0,...,6` then supported the ternary identity;
its largest coefficient index was 7290 inclusive. These were discovery
controls, not a completed search box or a finite optimum claim.

[The retained checker](../search/odd_dilation_obstruction.py) verifies the proved
identity at the fixed contexts `(ell,r)=(3,1),(3,2),(5,1),(5,2),(7,1)`, each
at `a=0,...,3`. It independently expands the logarithmic-derivative seed

    x*y*Phi_N'(y)/Phi_N(y), y=x^ell,
    Phi_N(y)=sum_(h=0)^(ell-1) y^(h*H),

by exact F_2 long division, then sums its dilates. This path does not use (1).
Direct primitive-root sums in F_4, F_64, F_16 and F_8 check normalization
separately; exhaustive multiplicative inverses verify the four small quotient
fields. Fixed tests disable the unit-part function, reject altered first
indices, missing multiplier terms and wrong shifts, and retain the original
odd-characteristic r=1 comparison (`p=3,R=t^2-1,m=1,j=2`, defect zero).

All retained checks pass. The maximum coefficient index is **17150 inclusive**;
root readback uses at most **2450**. Exact arithmetic, standard-library Python,
no random seed. [Command outputs, times, pins and hashes](2026-11-18-odd-dilation-validation.json)
give reproduction evidence. An initial scratch invocation incorrectly used
`python -m` with a relative file path and failed before research execution;
`runpy.run_path` corrected it. No search timeout or unresolved experiment remains.
The infinite theorem is the ordinary proof above, not the finite controls.
No Lean source changed, build or axiom audit is claimed; Challenge.lean:37
and downstream assumptions supply no premise.

The prepared shared env.sh/check.py gate passed without installing anything,
including exact Lean 4.35.0/dependency pins and representative Littlewood imports.
Bootstrap recovery was read and no duplicate runtime was made. The generated
clean work branch at `a8b0762` matched the expected solresol origin; fetched
main, verified ancestry, preserved work and created main, FF-only current.
No applicable AGENTS or saved Start skill was visible in the repository,
mounted .agents directories, local skill locations or cloud skill catalogue;
the explicit standing instructions govern this run. This availability limit
does not alter the mathematical statement. Only this repository was changed.

Retire **this direct unweighted root-sum construction for every odd prime ell
and every r>=1**. Changing the odd dilation, splitting field or root order
cannot rescue it. Weighted or different-numerator constructions are not covered.
Any such next candidate needs a reason to avoid the cancellation in (3), and
a binomial-multiple/dilation screen before a window search. No such replacement
is supplied today. The odd-characteristic acceptance obligation remains open.
Neither substantive conjecture is resolved; this is a proved negative screen
for a new candidate family. Parent coordinates Raksasa sync after verified push;
this worker makes no machine, schedule or environment-publication change.
