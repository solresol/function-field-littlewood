"""Small exact checks for the 4 October linked-terminal obstruction proof.

This verifies identities and a prescribed failed implication, not a search for
Littlewood counterexamples. Run: python3 -m search.terminal_moment_check
"""
import json
import platform
from itertools import product
from time import perf_counter

from search.lai_sprang_descent_check import evaluate, multiply
from search.lai_sprang_finite_search import coeff, v2
from search.run_rank_experiments import oracle


def run():
    started = perf_counter()
    examples = []
    identities = budgets = 0
    for p in (3, 5, 13, 41, 17):
        r = v2(p-1)
        N, H = 1 << r, 1 << (r-1)
        roots = [z for z in range(1, p) if pow(z, H, p) == p-1]
        assert len(roots) == H
        g = [1]*H
        for V in ((1,), (0, 1), (1, 2, 1), (1, 2, 0, 1)):
            R = multiply([1]*N, V, p)
            E, O = R[::2], R[1::2]
            V0, V1 = V[::2], V[1::2]
            for z in roots:
                x, y = evaluate(V0, z, p), evaluate(V1, z, p)
                A, B = (x+z*y) % p, (x+y) % p
                gz = evaluate(g, z, p)
                assert evaluate(E, z, p) == gz*A % p
                assert evaluate(O, z, p) == gz*B % p
                assert gz*(A*A-z*B*B) % p == 2*(x*x-z*y*y) % p
                identities += 1
        # Exact degree upper bounds, including both quotient/shift parities.
        for e in range(8):
            d = N-1+e
            k = e//2
            adeg, bdeg = k+e%2, k
            for delta in (0, 1):
                even_rows = (d+1+delta)//2
                odd_rows = (d+2-delta)//2
                available = min(even_rows-delta-bdeg, odd_rows-adeg)
                assert available == H-delta
                budgets += 1
        # Linked V=1, shift m=1: all retained moments, then the missing one.
        weights = [(evaluate(g, z, p)*(1-z)) % p for z in roots]
        assert weights == [2 % p]*H
        moments = [sum(pow(z, c, p)*w for z, w in zip(roots, weights)) % p
                   for c in range(1, H+1)]
        assert moments == [0]*(H-1)+[-N % p]
        direct = [sum(coeff(p, 1+j+i) for i in range(N)) % p
                  for j in range(1, N+2)]
        independent = [sum(oracle('lai_sprang', p, 1+j+i) for i in range(N)) % p
                       for j in range(1, N+2)]
        assert direct == independent
        assert direct[0] == H*(r-1) % p
        if r >= 2:
            assert direct[0] != 0  # NOT a terminal-window counterexample.
        else:
            assert direct == [0, 0, 2]  # Existing actual F_3 terminal failure.
        examples.append(dict(p=p, r=r, N=N, V=[1], m=1,
                             retained_moments=moments[:-1],
                             missing_moment=moments[-1], stream_rows=direct,
                             inclusive_original_endpoint=2*N+1))
    # Independent exhaustive check of the kernel description: all functions
    # W on the two roots over F_5, represented by W=w0+w1*t; c=0,...,7.
    # Includes both zero and nonzero residual scalars, with false premises too.
    kernel_checks = 0
    for W in product(range(5), repeat=2):
        vals = [evaluate(W, z, 5) for z in (2, 3)]
        for c in range(8):
            moment = sum(pow(z, c, 5)*w for z, w in zip((2, 3), vals)) % 5
            C = vals[0]*pow(2, c-1, 5) % 5
            scalar_form = all(w == C*pow(z, 1-c, 5) % 5
                              for z, w in zip((2, 3), vals))
            assert (moment == 0) == scalar_form
            if scalar_form:
                missing = sum(2*pow(z, c+1, 5)*w
                              for z, w in zip((2, 3), vals)) % 5
                assert missing == -4*C % 5
            kernel_checks += 1
    return dict(python=platform.python_version(), seed=None,
                linked_identity_checks=identities, row_budget_checks=budgets,
                exhaustive_F5_kernel_checks=kernel_checks, examples=examples,
                runtime_seconds=perf_counter()-started,
                scope='identity checks; no multiplier search or infinite inference')


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
