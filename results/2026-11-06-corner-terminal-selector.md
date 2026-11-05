# The missing corner changes terminal acceptance

6 November 2026, Friday, Australia/Sydney. Executed 5 November UTC, beginning
at 22:20 UTC / 09:20 AEDT. Classification: **mathematical progress on auxiliary
sharpness structure**, through an exact finite obstruction and an algebraic
selector over every extension of F_5. Neither substantive target is settled.

## Question and outcome

Before coding, asked whether the two transport laws can carry the missing
corner to different terminal outputs along a **shared actual continuation**
of the existing T(62,8), T(126,8) pair. Seven full relations, phase, exact size
and current rejection agree. Earlier work established failure of profile
closure but explicitly left terminal-language separation open. A separator
would rule out ignoring this corner even in a recognizer concerned only with
terminal decisions; bounded failure would have been inconclusive.

The shared word, with digits (shift,size), is

    (1,1), (0,1), (0,1), (0,0), (1,0).

It sends the pair to **T(2001,284), T(4049,284)**. The first accepts (0,e_1);
the second rejects it. Thus the original states have different terminal
languages. No deterministic terminal recognizer can identify these two states
on the basis of their common seven relations, even with phase and exact size.
This strengthens the existing closure obstruction; it is not a minimality
theorem for all possible state representations.

The stronger explanation is an exact selector: fixing their common borders
and varying the missing line, this word accepts **exactly [s:t]=[0:1]**.
This statement holds over every field extension of F_5, for the algebraic
completion family defined below. Only parameters 0 and 4 are asserted to be
actual stream states. It constructs no uniform all-prime accepting path.

## Shared projective parameter, then the conic

Use the existing normalized coefficients c_i=a_i/H, N=4,H=2, and the
independently certified input of
[1 November](2026-11-01-corner-response-check.json). In its notation put

    F = R_63(9,9), L = R_64(9,8), W = R_64(8,9),
    C_[s:t] = L + span(s*a+t*b),  [s:t] in P^1(K).

Here dim L=3, dim W=5, a,b form a basis modulo L, and K is any extension
of F_5. All the seven retained relations stay fixed. The actual B11 values
are C_[0:1] and C_[4:1]. Abstract completions, including C_[1:0], are
comparisons inside the linear merge equations; reachability is not assumed.

The first digit (1,1) sends C to the next B01 by the proved projective
isomorphism, [s:t] -> [2s+t:s+t] in the previous output chart. Parameter 4
is its chart pole, retained throughout. The second digit (0,1) uses that
**same transported square twice**: the next B01 is

    merge_251(R_126(18,18), R_126(18,18)).

Consequently it is the rank-four conic response, not a second line pencil.
The remaining three digits take this coupled response to the terminal test.
The [2 November law](2026-11-02-odd-corner-transport.md) and
[4 November law](2026-11-04-simultaneous-corner.md) apply with their actual
common borders. The completed 5 November short-window premise is reused.

## Exact algebraic selector proof

Unroll just the final first square through those five digits. There are 32
leaf occurrences, consisting of F (15), L (4), W (4), and C (9). Keep the
nine C occurrences as separate boundary ports. At each such leaf, replace
C by W and append its coordinates (alpha_i,beta_i) modulo L in the basis
(a,b). Then require the SAME projective line at every port:

    t*alpha_i - s*beta_i = 0,  i=0,...,8.

Separate port vectors need not be equal. Only their common line is shared;
choosing nine independent line parameters would change the problem.

Exact parity composition gives a 13-dimensional linear relation in the
8 root-boundary coordinates and 18 port coordinates. Its boundary projection
has rank 8. The slice above (0,e_1) therefore projects to the affine space

    z = z_* + x_0*d_0 + ... + x_4*d_4  in K^18.

The complete z_*,d_j and their linear lifts are in the
[certificate](2026-11-06-corner-terminal-check.json), field `slice`.
The five directions are independent. This is an exact fiber computation,
including its dimension, rather than a fit to six parameter values.

For finite lambda=s/t let M(lambda) be the 9-by-6 augmented matrix whose
i-th row is

    (d_j[2i]-lambda*d_j[2i+1])_(j=0,...,4),
     z_*[2i]-lambda*z_*[2i+1].

Feasibility requires M(lambda)*(x_0,...,x_4,1)^T=0. In particular both
6-by-6 minors on rows (0,1,2,3,4,5) and (0,1,2,3,4,6) must vanish.
Their polynomials, with coefficients in F_5, are

    f = 3X + X^2 + 3X^3        + 4X^5 + 2X^6,
    g = 3X + X^2 + 4X^3 + 2X^4 + 3X^5 + 4X^6.

Direct polynomial multiplication verifies the identity

    (3+X+4X^2+4X^3+4X^4)*f
      + (4+4X^2+3X^3+3X^4)*g = X.

Hence any feasible finite lambda is zero, over every extension K. At zero,
the explicit vector x=(0,1,0,1,0) satisfies all nine equations. At infinity
the conditions are beta_i=0; the recorded dual
(0,4,1,3,0,1,0,0,0) annihilates the five direction columns and has nonzero
pairing with their right-hand side. Infinity is therefore excluded too.
This proves the exact homogeneous selector [0:1]. No division by a variable
parameter, discarded pole, assumed target or square Hankel inverse is used.

The response is stored as a 17-node directed acyclic composition. For each
node, explicit internal preimages prove one inclusion in the claimed output
relation; annihilator lifts into the defining equation row space prove the
other. Complete echelon bases check dimensions. Reusing a child node still
creates independent port copies in its two parent slots. At the root, an
invertible 8-column minor checks the projection rank. Readback uses arithmetic
and pre-recorded inverse products, not elimination, a solver or state recursion.

## Original-coefficient checks and bounded discovery

Terminal separation also has a separate check that does not use the merge
or its selector proof. For (q,k)=(2001,284), a length-284 polynomial vector
satisfies every original root-sum Hankel row and all four moments (1,0,0,0).
Its constant and leading coefficients are nonzero. For (4049,284), an explicit
288-entry dual annihilates every column of the analogous target system and
has nonzero pairing with the right-hand side. Original coefficient readback
ends at indices **2568 and 4616 inclusive**. This proves acceptance and
rejection directly; the accepting polynomial is evidence for separation,
not an additional-prime sharpness claim.

Discovery used only this fixed pair. An initial enumeration of all suffixes
through depth 4 checked 341 paired nodes, with no acceptance (1.027 seconds).
A second pass pruned equal full-state pairs and would stop at depth 8 or
60 seconds; it stopped at the first separator at depth 5 after 240 checked
pairs, in 2.761 seconds. Complete depth counts before that stop were 1,4,8,24,80;
18 equal pairs had been pruned, with no repeated unequal pair. No whole
reachable graph or new prime/attainment box was enumerated. These finite
search outputs suggested the word; the certificate proves the stated result.
No shortest-word or wider minimality claim is needed.

## Validation, sources, scope and next decision

Reproduction commands, from the repository root with the prepared environment:

    python3 -m search.corner_terminal_selector
    python3 -m unittest discover -s tests -p test_corner_terminal_selector.py -v
    python3 -m unittest discover -s tests -v

Generation is `python3 -m search.corner_terminal_selector --generate` into a
previously absent path (or supply `--path` for a fresh comparison copy).
Commands ran through the prepared `prepare.py` guarded runner and its
`env_for('littlewood')`, with a 2 GiB disk reserve, 12 GiB process-group RSS
limit, two Lean threads and 300-second command timeout. See the
[validation record](2026-11-06-corner-terminal-validation.json) for actual
commands, timings, hashes and development failures. The four new tests cover
solver/recurrence-disabled readback, exact regeneration, the actual correlated
word, all six abstract parameter controls, the retained r=1 control and 14
certificate corruptions. The final full suite passed 125 tests in 21.486 seconds
(22.019 seconds including the guard); standalone readback passed in 1.001
seconds including the guard. Test counts are verification evidence, not progress
on either unresolved conjecture. No Lean source changed or Lean build/axiom
audit is claimed; Challenge.lean:37 supplies no premise here.

Read the latest available [30 October weekly human-literature review](2026-10-30-literature-review.md)
before selection, retaining its AMS/Elsevier access gaps and bounded coverage.
Targeted primary recheck accessed 5 November UTC / 6 November Sydney:
[Lai–Sprang 2606.00633v1](https://arxiv.org/abs/2606.00633v1), 30 May 2026,
still the sole displayed version; re-read
[Theorem 1.2, (1.2), Proposition 2.3 and Section 3](https://arxiv.org/html/2606.00633v1).
The all-odd-characteristic result gives a lower bound, not attainment for
this stream at every prime. The selector above is an internal deduction and
exact computation; no novelty or publication-priority claim follows. No new
binary candidate was selected; known rational/quadratic and unbounded-window
retirements stand. Existing Apache-2.0 project sources and Lai–Sprang
attribution are reused, with no external implementation or source prose copied.

Read saved START, recovery instructions, current roadmap, recent results and
actual sources. Prepared env.sh/check.py passed before work and after refresh,
including exact toolchains, dependency HEADs and representative imports.
The discovered clean `work` branch at 0d989a3 matched expected origin and
fetched origin/main. Verified ancestry, preserved `work`, created tracking
`main` and checked FF-only current. No overlapping research process was found;
the controller had already completed task/environment overlap checks. The
runtime status described the attached cloud instance; no equality between its
`cecfg` identifier and the controller's named `asenvcfg` namespace is inferred.
No installs, dependency/runtime/settings/security/schedule changes, other
checkout writes or user-machine access occurred. Controller owns Raksasa sync.

**Decision:** terminal-only compression cannot identify this fixed seven-relation
pair. The missing scalar affects acceptance, not just unobserved output data.
Next seek a state-dependent selector/transport relation on a genuinely
reachable family, sufficient to force a compatible accepting parameter
uniformly in the odd prime. The two transport isomorphisms alone do not force
that reachable value. Further fixed-pair suffix enumeration or extra isolated
witnesses would not establish it. Uniform Delta_p=2N and characteristic two
remain unresolved.
