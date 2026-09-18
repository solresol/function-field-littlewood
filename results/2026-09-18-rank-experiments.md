# Exact affine prefix optimisation — 18 September 2026

Friday computational run, Australia/Sydney. Started 11:07:17 AEST on clean
`main` at `0e1952f`; origin `git@github.com:solresol/function-field-littlewood.git`
was verified, fetched, and already current under `git merge --ff-only origin/main`.
No existing run lock or unrelated edits were present.

## Source audit and finite semantics

Read the actual enumerator, tests, Lean certificate definitions, README, TODO,
research log, literature note, and prior run records before choosing work.
`search/lai_sprang_finite_search.py` remains the independently useful brute-force
reference. It normalises r_0=1, excludes a zero leading coefficient, checks j=1
through the inclusive cutoff, and reports exhaustion as unresolved. Its exact
certificate requires coefficients through the inclusive index m+d+j; it does not
implicitly fill an unknown tail with zeros. Its odd-prime coefficient formula and
stored r=1 comparisons passed the existing independent root-sum tests unchanged.

The new generic `search/finite_rank.py` accepts a callable a(n) over F_p,
including p=2. For fixed d,m it incrementally solves

    r_0 = 1,
    sum_{i=0}^d r_i a_{m+i+k} = 0,  k=1,...,L,
    r_d != 0.

All arithmetic is integer arithmetic modulo a validated prime. The affine
solution's last coordinate is either fixed or varies over the whole field. If a
particular solution has last coordinate zero, adding a nullspace direction with
nonzero last coordinate gives a valid endpoint, including over F_2. A nontrivial
kernel alone is insufficient: H=[0,1] has a kernel but forces r_1=0.

When the first infeasible prefix is L=j, the previous multiplier is a witness
with exact first index j. Every result includes a dual combination of the original
rows (normalisation first, then k=1,...,j). The combination gives either:

- zero coefficient vector with nonzero right-hand side, an inconsistency; or
- the last coordinate vector with zero right-hand side, forcing r_d=0.

The separate `check_result` uses only dot products. It checks all preceding
fractional coefficients vanish, the terminal coefficient is nonzero, both
endpoints are admissible, and the dual identity holds. Thus it verifies both an
attained index and its optimality for that finite (d,m). Diagnostic RREF rank is
not certified by this checker and is not used to establish optimality. These
finite certificates are checked by Python; dual soundness has not yet been
formalised in Lean. No infinite degree/shift bound follows.

If every prefix through the cutoff is feasible, j is null, the last witness is
labelled only a vanishing prefix, and no dual or exact index is asserted.
The maximum possible queried index in this run is 64+16+128=208; the maximum
actually required by the retained certificates is 99.

## Exact experiment and independent readback

Python 3.9.6, standard library only, no random choices or seeds. Each of seven
streams uses all d=0,...,16, m=0,...,64, cutoff 128 (1,105 optima per stream).
These boxes cover all normalised multipliers via affine optimisation, rather
than enumerating their exponentially many coefficient vectors.

| Stream | Field | Maximum defect j-d | Witness (d,m,j) | Unresolved |
|---|---|---:|---|---:|
| Lai–Sprang | F_5 | 4 | (0,21,4) | 0 |
| Lai–Sprang | F_13 | 4 | (0,21,4) | 0 |
| Lai–Sprang | F_17 | 15 | (0,17,15) | 0 |
| Lai–Sprang | F_41 | 8 | (0,41,8) | 0 |
| Thue–Morse | F_2 | 15 | (9,15,24) | 0 |
| regular paperfolding | F_2 | 8 | (12,8,20) | 0 |
| Rudin–Shapiro | F_2 | 7 | (13,55,20) | 0 |

All odd-field table witnesses use R=1. Their N values are 4,4,16,8 respectively;
none violates the auxiliary N-bound. The p=17 maximum remains below N and does
not establish sharpness. The earlier r=1 defect-4 witnesses remain verified.

Binary coefficient conventions are fixed for n>=1, with n=0 unused:

- Thue–Morse: a_n is the parity of the binary digit sum of n (not n-1).
- Regular paperfolding: a_n=1 iff oddpart(n)=1 modulo 4, otherwise zero.
- Rudin–Shapiro: a_n is the parity of the number of overlapping `11` pairs in n.

The binary maximum witnesses, respectively, are

    R = (1+t)(1+t^8),
    R = 1+t^4+t^8+t^12,
    R = (1+t)(1+t^4+t^8+t^12).

They provide reproducible baselines for characteristic-2 investigation, not
established counterexamples to the main conjecture. Neither boundedness nor
unboundedness of defects over all shifts/degrees has been proved. No claim of
novelty for these named streams is made. The Thue–Morse example suggests testing
dyadic families with recurrence identities next, with a literature check before
promoting any result.

The JSONL retains every input, primal witness, and dual obstruction. There are
5,697 inconsistency duals and 2,038 forced-zero-leading-coefficient duals.
The runner flushes each completed degree and refuses to overwrite its JSONL.
The summary JSON records per-degree profiles as well as maxima and runtimes.

Search time: 6.806694458 s. Independent readback: 0.842701250 s, all 7,735
certificates accepted, zero unresolved. Readback regenerates Lai–Sprang
coefficients by expanding the original rational root sums, and binary values by
recursive formulas rather than the search's bit-string definitions. It checks
duplicate/missing inputs and the expected cutoff/boxes without invoking elimination.

## Validation and reproducibility

```sh
python3 -m unittest discover -s tests -v
python3 -m search.run_rank_experiments /tmp/littlewood-rank-search.jsonl
python3 -m search.run_rank_experiments results/2026-09-18-rank-search.jsonl --verify
```

Use a fresh output path for a rerun. The saved search used the second command with
`results/2026-09-18-rank-search.jsonl` as its output path.

13 tests passed in 2.086 s (saved output). The new enumeration oracle covers all
128 length-7 binary streams with d<=3 and m=0,1, and all 243 length-5 ternary
streams with d<=2 and m=0,1; cutoff is length-m-d. This gives 2,482 complete tiny
stream/degree/shift comparisons, plus 144 Lai–Sprang comparisons for p=3,5,13,17,
d<=3,m<=8,cutoff 32. Tests include both obstruction types, certificate mutations,
unresolved prefixes, endpoint failures, and inclusive prefix locality. Existing
root-sum and r=1 regression tests also pass. The full saved certificate file is
independently checked during the suite. Lean source and dependencies are unchanged;
no new Lean theorem or Lean build is claimed for this computational run.

## Primary literature rechecked on 18 September 2026

- Li Lai and Johannes Sprang, [arXiv:2606.00633v1](https://arxiv.org/abs/2606.00633v1),
  submitted 30 May 2026; version history still lists v1. Checked the
  [full text](https://arxiv.org/html/2606.00633v1), Theorem 1.2 and Remark 1.3:
  all odd characteristics are settled, with bound 2^(-2N deg P). Our N-bound
  question concerns their explicit known counterexample, not the main frontier.
- Dzmitry Badziahin, Volodymyr Pavlenkov and Evgeniy Zorin,
  [arXiv:2608.22078v1](https://arxiv.org/abs/2608.22078v1), 22 August 2026;
  history still lists v1. Abstract/full text retain a characteristic-two
  exceptional-set statement conditional on counterexample existence.
- Steven Robertson, [arXiv:2307.00955v3](https://arxiv.org/abs/2307.00955v3),
  31 October 2025, published in Mathematika 72 (2026), e70064,
  [DOI 10.1112/mtk.70064](https://doi.org/10.1112/mtk.70064).
  Number-wall dictionary remains a relevant route; current experiment uses its
  underlying finite Hankel equations without constructing a number wall.

Searches included `site:arxiv.org "Littlewood" "characteristic two"`,
`site:arxiv.org "Littlewood" "characteristic 2" 2026`, and Robertson's title/DOI.
No later characteristic-two resolution was found in these searched primary
sources. This describes the evidence boundary, not proof that none exists.

Next formal work: prove dual-obstruction soundness and the multiplier polynomial
endpoint/degree bridge. Next computation: dyadic binary witness families and the
p=17 degree-zero gap structure before indiscriminately expanding boxes.
