# The missing corner has invertible projective transport through the odd digit

2 November 2026, Monday, Australia/Sydney (AEDT). Scheduled instant:
1 November 21:20 UTC = 2 November 08:20 AEDT.

Classification: **mathematical progress on auxiliary sharpness structure**:
an ordinary all-prime structural lemma, with a fixed exact computation.
This is not a Lean theorem, a new accepting word or prime decision, a proof of
uniform `Delta_p=2N`, a characteristic-two result or an established novelty claim.

## Question and decision

Read the saved [30 October weekly literature review](2026-10-30-literature-review.md)
and [1 November result](2026-11-01-sunday-integration.md) before choosing work.
The question stated before code was whether, holding the seven common relations
fixed, the missing B11 line transports through digit (1,1) by a nonconstant
projective map, or whether a rank drop or another transverse datum intervenes.
Rank two would justify retaining this scalar in a projective recurrence;
failure would identify an obstruction. Two fitted values would not decide it.

**Outcome:** for the next B01 response the map always has rank two. This follows
from the existing actual wide/tall relations, including empty and singular blocks
and r=1. No additional datum is needed for this particular response. On the fixed
F_5 pair, a canonical output chart gives `(2 lambda+1)/(lambda+1)`; the actual
second input lambda=4 maps to infinity. This is a chart pole, not a rank drop.

## 1. Exact transport lemma

Use the normalized Lai–Sprang stream, all-root boundary relation R, and
no-invisible-vector/dimension/merge lemmas of
[19 October](2026-10-19-boundary-relation.md), with the
[25 October bordered reconstruction](2026-10-25-sunday-integration.md).
Fix any odd prime p, N=2^v2(p-1), H=N/2, and q,k>=0. Write

    F = R_(q+1)(k+1,k+1),
    A = R_(q+2)(k,k),       B = R_(q+2)(k+1,k+1),
    L = A intersect B = R_(q+2)(k+1,k),
    W = A+B           = R_(q+2)(k,k+1).

Thus dim L=N-1 and dim W=N+1. In the old four-square state, F=B01,
A=B10 and B=B11. Fixing F,L,W suffices for the following response; the
remaining fixed relations are not used.

For w=(u,v0,v1) in F_p^(3N) define

    M0 w = (D0 u - K_(q+1) v1, v0),
    M1 w = (D1 u - K_(q+1) v0, v1),
    P w  = (u, (v0_(z^2)+z v1_(z^2))_(z in Omega)),

where `(D_a u)_y=sum_(z^2=y) z^a u_z`, and K_j is diagonal with
entry `H^(-1) z^j` on primitive N-th roots and zero elsewhere.
These are precisely the row-parity maps for the even start t=2q+2.
Put

    S   = {w : M0 w in F, M1 w in W},
    S_L = {w : M0 w in F, M1 w in L}.

**Lemma.** The induced maps

    S/S_L --M1--> W/L,
    S/S_L ---P--> W'/L'

are linear isomorphisms between two-dimensional spaces, where

    W' = R_(2q+2)(2k+1,2k+2),
    L' = R_(2q+2)(2k+2,2k+1).

Consequently `Phi = Pbar composed with M1bar^(-1)` is a canonical linear
isomorphism W/L -> W'/L'. For any line ell in W/L, the algebraic merge
of F with its preimage C_ell in W is the preimage of Phi(ell) in W'.
The resulting map on projective lines is bijective, including infinity.

**Proof.** Apply the exact parity merge to the actual wide parent
`R_(2q+2)(2k+1,2k+2)`. Its even-row child is F (k+1 rows and columns);
its odd-row child is W (k rows and k+1 columns). Hence P maps S bijectively
onto W'. Injectivity is the existing no-invisible-vector argument, not an
assumed invertible Hankel matrix. In particular dim S=dim W'=N+1.

For the actual tall parent `R_(2q+2)(2k+2,2k+1)`, the even-row child
is again F; the odd-row child is L (k+1 rows and k columns). Thus
P(S_L)=L', again injectively, and dim S_L=N-1. The map
`w -> M1 w mod L` from S to W/L has kernel exactly S_L. Its rank is
therefore two, the full dimension of W/L. This proves the first isomorphism;
the second follows from the established P isomorphism and P(S_L)=L'.
Taking the preimage of an arbitrary line proves the pencil statement. QED.

The distinguished input line A/L maps to
`A'/L'`, where `A'=R_(2q+2)(2k+1,2k+1)`: its two children are F,A.
The actual input B/L maps to `B'/L'`, with
`B'=R_(2q+2)(2k+2,2k+2)`: its children are F,B. These are precisely the
next B00 and B01 at T(2q+1,2k+1). Bordered reconstruction also identifies
W'=A'+B' and L'=A' intersect B'.

If a,b represent independent classes in W/L and alpha,beta are their
transported classes, then

    L + span(s a+t b)  ->  L' + span(s alpha+t beta), [s:t] in P^1(F_p).

This is a linear derivation, not a fit. In arbitrary quotient bases it is
a fractional-linear map with nonzero determinant. No singular chart may be
discarded. Actual adjacent large squares exclude the distinguished line A;
the full projective pencil includes it as a useful algebraic comparison.
The proof does not assert that the other abstract completions are reachable
stream states, or that they can be independently substituted in other corners.

## 2. Fixed F_5 certificate and actual pole

Reuse exactly T(62,8),T(126,8), whose first seven relations agree, and the
input chart a,b,L from the independently checked
[1 November certificate](2026-11-01-corner-response-check.json).
Their missing lines have parameters 0 and 4 in `b+lambda a`.
The relevant exponent q+1 is congruent to 63 modulo N=4 for both states.

The [new certificate](2026-11-02-odd-corner-check.json) proves dim S=5 by
seven independent equations in twelve variables, with an explicit inverse
minor. Five independent outputs with internal preimages prove P is injective.
Three kernel outputs and two quotient lifts prove the rank-two quotient map.
It gives the output kernel

    L' = span((1,0,0,0 | 3,2,2,3),
              (0,1,0,2 | 3,3,3,0),
              (0,0,1,4 | 4,4,4,2))

and output quotient basis

    e=(1,0,0,0 | 3,0,3,4),
    f=(0,1,0,0 | 2,0,3,4).

The transported a,b classes are respectively 2e+f and e+f. Thus

    [s:t] -> [2s+t:s+t],       determinant = 1 mod 5,
    lambda -> (2lambda+1)/(lambda+1).

| Input lambda | 0 | 1 | 2 | 3 | 4 | infinity |
| --- | --- | --- | --- | --- | --- | --- |
| Output coordinate | 1 | 4 | 0 | 3 | infinity | 2 |

The actual successor B01 squares at T(125,17),T(253,17) match output
coordinates 1 and infinity respectively, by the original-coefficient full
relation certificate, not merely the recurrence. The numerical chart is not
intrinsic. The original source readback still ends at index 576 inclusive;
no larger coefficient or witness range was searched.

A first scratch calculation tried to lift the representative b exactly
through M1 and failed: the image of M1 on S has dimension four, not five.
Only its image modulo L needs to be surjective. Lifting b modulo L succeeds
and is the invariant construction proved above. No exact representative
surjectivity or extra hidden datum is assumed.

## 3. Checks, sources and scope

`search/odd_corner_transport.py` generates the certificate with exact F_5
elimination. Independent readback uses the original root-sum source certificate,
dot products, echelon independence guards and both products of explicit inverse
minors. Solving, elimination and relation/direct/recursive/merge methods are
disabled in the corresponding test. It checks all required dimensions, quotient
lifts, output coordinates and actual realizations. All six abstract completions
are separately compared with the existing merge; original-coefficient output
wide/tall relations are also compared. The latter comparisons are finite
computations, not a proof of all-prime transport or actual reachability of six
completions.

Four tests additionally cover exact regeneration, ten certificate corruptions,
and the prescribed contexts (p,q,k)=(3,0,0),(3,1,2),(13,7,4), including empty
blocks and r=1. All **20 distinct focused tests** pass. The first combined
invocation passed 16 tests but failed to import the existing correlated-state
module: its bare sibling import requires `unittest discover -s tests`.
The affected module's four tests pass with that invocation. The failed command
and successful correction are retained; no test source was altered to fix the
invocation. The initial validation driver aborted before saving per-command
wall times; those times are explicitly unknown, with its logs preserved.
The proof above supplies the all-prime statement. No inverse
Hankel matrix, field-dependent search hypothesis, terminal acceptance or existing
Challenge.lean:37 placeholder is used. No Lean source changed or new Lean
proof/build/axiom audit is claimed. Focused commands, times and hashes are in
[the validation record](2026-11-02-validation.json).

Primary source accessed **1 November 2026 UTC / 2 November Australia/Sydney**:
[Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/html/2606.00633v1),
30 May 2026, still the sole displayed version. Rechecked Theorem 1.2,
functional equation (1.2) and Proposition 2.3. The theorem gives the lower
bound for all irreducible P over every odd-characteristic ground field;
it does not assert uniform attainment. Proposition 2.3 applies at the
nonnegative shifts used by the reused no-invisible-vector proof.
This transport lemma is an internal deduction from that foundation, not a
claim of publication priority. The latest weekly review's other source/access
limits remain; no broad daily search or new binary candidate was attempted.
Known rational/quadratic and unbounded-window binary streams remain retired.
No external implementation or source prose was copied; existing project code
and attribution are reused under the repository's Apache-2.0 licence.

The runtime source-version binding matched the parent's verified configuration.
Personal Context was unavailable; the saved START.md and weekly review were
available locally. No applicable AGENTS.md or .agents skill was present.
Before any download or install, sourced the prepared env.sh and passed check.py.
Verified the clean generated work branch, expected solresol origin and ancestry
to fetched origin/main; preserved work and created tracking main at b2ce21c.
Exact pins/readiness passed again after refresh. No installation, dependency,
runtime, credential/network/security, environment publication, other repository,
schedule or user-machine change occurred. Parent handles Raksasa reconciliation
after push through its authorized cloud thread; no direct remote shell was used.

**Next useful step:** derive the simultaneous odd-digit update of the remaining
large square, whose two child occurrences both contain the same B11 line.
Determine whether its dependence is a projective linear law, a higher-degree
correspondence or requires additional correlated data. Retain the actual
border identities and poles; independent abstract sibling substitutions are
not a reachability proof. The single-response isomorphism above settles its
rank-drop question but supplies neither an accepting continuation nor a smaller
closed recognizer. Do not replace the next question by more attainment examples
or another generic bridge formalisation.
