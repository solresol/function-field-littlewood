# 24 September 2026 — named binary stream in Lean

Thursday in Australia/Sydney. Began approximately 08:21 AEST on clean main at
7bbd69c, origin `git@github.com:solresol/function-field-littlewood.git`.
Fetched and fast-forward-only checked before editing; no competing run marker
or relevant process was present. The run uses the ignored `.research/run.lock`.

## Mathematical increment

`FunctionFieldLittlewood/BinaryStream.lean` defines

```text
a(n) = sum(Nat.digits 2 n) in ZMod 2, n >= 0.
```

Thus a(0)=0 and positive indices use the same binary digit-parity convention
as `search.run_rank_experiments.stream`. This is not a signed sequence reduced
modulo two. Reusing mathlib's digit definition avoids assuming an unproved
equivalence between a newly invented recursive definition and binary digits.

Lean proves for every natural n:

- a(2n)=a(n), a(2n+1)=1+a(n);
- these equations and a(0)=0 uniquely determine the stream, by strong induction;
- for D(n)=a(n)+a(n+1), D(2n)=1 and D(2n+1)=1+D(n).

The finite identification theorem proves equality with the recorded prefix at
every index 0 through 48. This is precisely the inclusive locality requirement
m+d+j=15+9+24. The existing primal/dual acceptance theorem transfers by the
already proved locality lemma. Consequently the infinite named stream has:

```text
R=(1+t)(1+t^8), d=9, m=15, exact first index j=24, defect=15;
every degree-nine multiplier with both endpoints nonzero has
a nonzero coefficient at some index 1 <= k <= 24.
```

The second conclusion quantifies over arbitrary endpoint-nonzero vectors; an
additional theorem quantifies over actual degree-nine polynomials with nonzero
constant coefficient. It still uses the finite coefficient sum, not an actual
Laurent-series multiplication theorem. The coefficient of the terminal index
and the impossibility of a longer admissible prefix come from the existing
checked primal and dual; Gaussian elimination is not trusted by Lean.

Controls prove a(0) is not 1 and the zero-padded saved prefix differs from a at
index 49. Thus no equality with the entire padded stream is asserted. Only the
degree-nine saved record receives named-stream identification today; the other
two saved records remain prefix statements with Python-checked identities.

The valuation expression D(n)=1+v2(n+1), the all-scale dyadic witness, and the
Laurent norm/product bridge remain unformalised. The 21 September ordinary
all-scale argument still retires Thue–Morse as a counterexample candidate.
There is no novelty claim, characteristic-two counterexample, or proof of the
auxiliary all-degree Lai–Sprang N-bound in this increment.

## Search audit and validation

Read actual enumerator, affine solver, independent checker and binary oracle.
The enumerator enforces both endpoints, fixes r0=1, checks j=1,...,limit inclusive,
and counts cutoff exhaustion as unresolved. The affine solver enforces the same
endpoints; a kernel or rank deficiency alone does not suffice. `check_result`
checks primal dot products and the inconsistency/forced-leading-zero dual
without elimination. Diagnostic rank remains uncertified. No solver changes or
new search boxes were necessary for this formal increment.

Lean and mathlib stay pinned to v4.27.0, mathlib revision
`a3a10db0e9d66acbebf76c5e6a135066525ac900`. Read
`Mathlib/Data/Nat/Digits/Defs.lean`, including `digits`, `digitsAux`, and
`digits_add`, and mathlib's Apache-2.0 licence before reuse. Existing ZMod,
normalisation and polynomial bridges are reused. Dependency cache command:

```sh
lake exe cache get Mathlib.Data.Nat.Digits.Defs
lake build
python3 -m unittest discover -s tests -v
python3 -m search.export_lean_certificates --check
```

Final build: 1,324 jobs, 20.250 seconds, no warnings. All 39 printed axiom reports
(nine new) contain only `propext`, `Classical.choice`, `Quot.sound`. No `sorry`,
`admit`, added axiom or `native_decide` occurs in project Lean source. Prefix
evaluation uses equation rewriting and kernel-checked `decide`; direct reduction
of mathlib's well-founded digit implementation was insufficient, so no native
evaluation shortcut was used. The build log and validation JSON are retained.

All 22 Python tests pass in 1.355 seconds, including tiny exhaustive rank oracles,
independent root sums, r=1 comparison witnesses, stored certificates, truncation,
endpoint and corruption controls. All three deterministic Lean exports match
(0.095 seconds). Python 3.11.6, standard library, no randomness or seed. This is
regression validation, not a repeated search offered as new research evidence.

## Primary literature recheck

Accessed 24 September 2026, using current arXiv abstract/version histories:

- [Lai–Sprang, 2606.00633v1](https://arxiv.org/abs/2606.00633v1), submitted
  30 May 2026: failure over every odd-characteristic ground field for every
  irreducible P(t). The superseded odd-characteristic existence search stays retired.
- [Badziahin–Pavlenkov–Zorin, 2608.22078v1](https://arxiv.org/abs/2608.22078v1),
  submitted 22 August 2026: the characteristic-two exceptional-set conclusion
  remains conditional on existence of a counterexample.
- [Robertson, 2307.00955v3](https://arxiv.org/abs/2307.00955v3), revised
  31 October 2025: retained number-wall reference.
- [Garrett–Robertson, 2405.14454v2](https://arxiv.org/abs/2405.14454v2), revised
  8 April 2025: retained small-field/number-wall baseline. The 21 September report
  records its existing discussion of unbounded binary Thue–Morse windows.

Scoped searches included `"Littlewood" "characteristic two" 2026`,
`"Littlewood" "characteristic 2" counterexample`, and arXiv-restricted
`"t-adic Littlewood" "two"` and `"Littlewood" "characteristic" "2026"`.
No later main characteristic-two resolution was found. This is a search boundary,
not proof that no such paper exists. No new literature theorem is attributed to
the present formalisation.

## Next useful steps

Friday: test the proposed Rudin–Shapiro dyadic family with bounded exact witnesses
and exceptions, then derive a recurrence if supported. Saturday: named Lai–Sprang
coefficients or actual Laurent multiplication; for the binary regression, derive
the valuation identity from today's recurrences before formalising the already
known all-scale family. Do not repeat completed scale searches as new evidence.
