# Three-term attainment for every r >= 3

30 September 2026, Wednesday, Australia/Sydney. Started at approximately
08:21 AEST. Clean main at 3aaf7e7; correct origin
`git@github.com:solresol/function-field-littlewood.git`, fetched and
fast-forward-only checked (already current). No competing run marker/process.
Read supplied instructions, README, TODO, recent reports/log and actual search,
rank, independent oracle and test sources before choosing the increment.

## Mathematical result and scope

Let p be an odd prime, r=v_2(p-1)>=3 and N=2^r. For the Lai–Sprang
support-formula stream, the polynomial and shift

    R(t)=1-t^(N-1)+t^N,  d=N,  m=9N+3

have exact first nonzero fractional index j=2N, with coefficient -N/2 in F_p.
Thus j-d=N and the Littlewood product is 2^(-N).
This is an ordinary proof for every such prime, not extrapolation from a finite
list. It is not yet a Lean theorem. It proves positive-degree attainment only:
no upper bound over other multipliers/shifts, or all-prime optimality at this
fixed degree/shift, is established. The all-degree auxiliary N-bound remains a
hypothesis. Novelty of this particular family is not established.

The odd-characteristic main conjecture is already settled negatively by
Lai–Sprang. This increment concerns their known counterexample, not a new
counterexample or a resolution of the characteristic-two frontier.

## Proof by complete support classification

Work first over the integers with the normalised stream

    b_n = (-1)^h if n=2^k(1+Nh), k,h>=0; otherwise b_n=0.

This representation is unique: 1+Nh is odd, so k=v_2(n). The field coefficient
is a_n=(N/2)b_n modulo p. For 1<=j<=2N, the three indices required are
m+j, m+N-1+j and m+N+j; all lie in the inclusive interval

    I=[9N+4, 12N+3].

We classify every supported index in I, uniformly for dyadic N>=8.

- If h=0, n is a power of two. I lies strictly between 8N and 16N,
  consecutive powers of two, so there is no such index.
- If h>=1 and k>=4, n>=16(N+1)>12N+3, so there is no such index.
- For k=3, h=1 gives 8N+8<9N+4 because N>=8; h>=2 gives
  n>=16N+8>12N+3. There is no such index.
- For k=2, h<=2 gives n<=8N+4<9N+4; h>=3 gives
  n>=12N+4>12N+3. There is no such index.
- For k=1, precisely h=5,6 give indices in I.
- For k=0, precisely h=10,11,12 give indices in I.

Therefore the complete support in I is:

| n | k | h | b_n |
|---|---:|---:|---:|
| 10N+1 | 0 | 10 | +1 |
| 10N+2 | 1 | 5 | -1 |
| 11N+1 | 0 | 11 | -1 |
| 12N+1 | 0 | 12 | +1 |
| 12N+2 | 1 | 6 | +1 |

Now write c_j=b_(9N+3+j)-b_(10N+2+j)+b_(10N+3+j).
Substitution of those five support points gives every possible contribution in
1<=j<=2N. The signs in the middle column below already include the minus sign.

| j | first term | second term | third term | c_j |
|---|---:|---:|---:|---:|
| N-2 | +1 | 0 | -1 | 0 |
| N-1 | -1 | +1 | 0 | 0 |
| 2N-2 | -1 | 0 | +1 | 0 |
| 2N-1 | 0 | -1 | +1 | 0 |
| 2N | 0 | -1 | 0 | -1 |

All unlisted j have three zero terms, by completeness of the support table.
Thus c_j=0 for 1<=j<2N and c_(2N)=-1. Since N divides p-1,
0<N/2<p and -N/2 is nonzero in F_p. Both polynomial endpoints are 1 and
its degree is N. This proves the claimed exact index and defect.

The N>=8 restriction matters. At N=4, k=3,h=1 gives n=40 inside I,
and the j=1 coefficient is a_40-a_43+a_44=-2. This retains the all-r=2
failure proved on 28 September; it does not refute the auxiliary N-bound.
The separate documented r=1 comparison R=1+t^2,m=2 has j=6 and defect4=2N
for p=3,7,11,19,23,31; these regression certificates remain checked.

## Exact implementation and independent checks

`search/lai_sprang_support.py` adds an exact integer interval enumerator.
For each scale s=2^k it enumerates precisely

    max(0,ceil((lo-s)/(sN))) <= h <= floor((hi-s)/(sN)),

including h=0. It then translates the support into the three weighted terms,
retaining cancellation events even when their sum is zero. No floating point,
randomness, Gaussian elimination, field extensions or added dependency is used.
A separate checker scans each inclusive interval by stripping factors of two;
it reconstructs every support point and all three contributions for every j.
It does not call the interval enumerator or partition generator.

The retained seven partitions use N=4,8,16,32,64,128,256, all already present
in the 28 September family experiment. They validate the proof's support and
cancellation tables; this is not an expanded search or the basis of the
all-r quantifier. Every coefficient in the intervals is also checked against
the original rational root-sum oracle in the same 11 prescribed prime fields
p=5,13,29,41,73,17,113,97,193,641,257.

New tests exhaust all 3,280 inclusive subintervals of [1,40] for N=2,4,8,16,
covering powers of two, high valuations and singleton endpoints. Nine corrupted
or incomplete records are rejected; readback succeeds with both generators
disabled. The N=4 exception remains explicit. No new optimum claims are made.

Audit of the existing search semantics found no required solver change:

- `lai_sprang_finite_search.py` enumerates r_0=1 with r_d nonzero; degree zero
  is separate. Cutoff exhaustion returns None and increments unresolved.
- The fractional coefficient uses a_(m+i+j); data through inclusive m+d+j
  suffice. Cutoff j-1 cannot certify an index at j.
- `finite_rank.py` handles inconsistent affine equations and a forced zero
  leading endpoint separately. The independent checker verifies weighted rows;
  its diagnostic rank is deliberately not certified. A singular matrix alone
  does not establish an admissible endpoint-nonzero witness.

All 41 Python tests pass (3.448s test time, 3.560635s subprocess), including
12,871 old rank optima, old family witnesses, root sums, endpoint/cutoff controls
and the r=1 comparisons. Three saved Lean exports match (0.093744s).
Independent new partition CLI readback passes (0.046398s); separate old family
readback verifies 17 witnesses and eight optima with zero unresolved
(0.485012s subprocess). Python 3.9.6, standard library, seed null.
No Lean files or dependency pins changed; no Lean build was run today.
The generic support proof above is not represented as machine-checked Lean.
Exact generation time is in the partition JSON, and full command outputs/timings
are in `results/2026-09-30-validation.json`.

Reproduction from the repository root (generation refuses to overwrite):

```sh
python3 -m search.lai_sprang_support results/2026-09-30-support-partition.json --verify
python3 -m search.lai_sprang_support .research/support-partition-recheck.json
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
python3 -m search.lai_sprang_three_term results/2026-09-28-three-term.jsonl --verify
```

## Primary literature refreshed on 30 September 2026

- [Lai–Sprang, arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  submitted 30 May 2026; version history shows v1. Abstract and
  [primary HTML](https://arxiv.org/html/2606.00633v1) retain failure of the
  main conjecture over every ground field of odd characteristic.
- [Badziahin–Pavlenkov–Zorin, arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078),
  submitted 22 August 2026; version history shows v1. The abstract still makes
  its characteristic-two exceptional-set result conditional on a counterexample.
- [Robertson, arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955v3),
  revised 31 October 2025; version history shows v3. The number-wall framework
  connects finite Toeplitz determinants with the Diophantine problem.

Scoped searches included `site:arxiv.org "Littlewood" "characteristic" "2026"`,
`site:arxiv.org "Littlewood" "characteristic two" counterexample`,
`site:arxiv.org/abs/ "t-adic Littlewood" "two"` and
`site:arxiv.org "Littlewood" "2609"`. No later characteristic-two resolution
was found. This is a search boundary, not proof that no such result exists.
Unversioned Lai–Sprang/Robertson fetches initially failed; their versioned
primary pages and histories were successfully accessed. No novelty claim.

## Next informative work

For computation, return to characteristic-two number walls: build a bounded
exact determinant profile for arbitrary binary prefixes, cross-check with direct
permutation determinants in tiny cases, and compare zero windows with the
endpoint-aware rank certificates. Retain the three retired binary streams as
regression inputs, not open candidates. Do not expand this three-term family
again merely to support the now-proved attainment identity.

Thursday's formal priority remains the strictly positive fractional-part order
and norm/product exponent. The support classification above is an additional
small formal lemma target; original root-sum identity and generic degree-zero
bounds remain separate obligations. The auxiliary all-degree N-bound is open
within this repository.
