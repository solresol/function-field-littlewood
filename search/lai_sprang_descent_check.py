"""Bounded checks for the 2 October parity-descent proof, not a proof by search.

Run from the repository root with python3 -m search.lai_sprang_descent_check.
Only the standard library and existing stream/affine/certificate code are used.
"""
import json
import platform
from functools import lru_cache
from time import perf_counter

from search.finite_rank import longest_prefix, check_result
from search.lai_sprang_finite_search import coeff, v2
from search.run_rank_experiments import oracle


def multiply(a, b, p):
    c = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            c[i+j] = (c[i+j] + x*y) % p
    return c


def evaluate(a, z, p):
    return sum(x*pow(z, i, p) for i, x in enumerate(a)) % p


def run():
    started = perf_counter()
    identities = moments = 0
    # Deterministic coefficient vectors, including both degree parities and
    # vanishing parity components. These are identity checks, not bad witnesses.
    vectors = [(1,), (0, 1), (1, 0, 1), (1, 2), (2, 1, 3),
               (1, 0, 2, 1), (1, 3, 0, 2, 1), (1, 2, 3, 4, 2, 1)]
    for p in (3, 5, 13, 41, 17):
        N = 1 << v2(p-1)
        H = N//2
        roots = [z for z in range(1, p) if pow(z, H, p) == p-1]
        assert len(roots) == H
        assert all(pow(z, (p-1)//2, p) == p-1 for z in roots)
        a = lambda n: oracle('lai_sprang', p, n)
        odd = lambda u: sum(pow(z, u, p) for z in roots) % p
        for s in (1 << k for k in range(1, v2(p-1)+1)):
            g = [int(i % (s//2) == 0) for i in range(H-s//2+1)]
            f = [int(i % s == 0) for i in range(N-s+1)]
            D = [1] + [0]*(H-1) + [1]
            next_factor = [int(i % (s//2) == 0)
                           for i in range(N-s//2+1)]
            assert multiply(g, D, p) == next_factor
            assert all(evaluate(g, z, p) for z in roots)
            for raw in vectors:
                U = [x % p for x in raw]
                while U and not U[-1]:
                    U.pop()
                R = multiply(f, U, p)
                E, O = R[::2], R[1::2]
                U0, U1 = U[::2], U[1::2]
                d = len(R)-1
                q, eps = divmod(d, 2)
                for m in range(2*N+2):
                    n, delta = divmod(m, 2)
                    L = d+s
                    A = (L+delta)//2
                    B = (L+1-delta)//2
                    # Degree upper bounds, valid also for a zero component.
                    assert A-delta-(q-1+eps-(H-s//2)) >= H
                    assert B-(q-(H-s//2)) >= H
                    for k in range(1, L+1):
                        direct = sum(x*a(m+k+i) for i, x in enumerate(R)) % p
                        absolute = m+k
                        v = absolute//2
                        if absolute % 2 == 0:
                            split = sum(x*a(v+i) for i, x in enumerate(E))
                            split += sum(x*odd(v+i) for i, x in enumerate(O))
                        else:
                            split = sum(x*odd(v+i) for i, x in enumerate(E))
                            split += sum(x*a(v+i+1) for i, x in enumerate(O))
                        assert direct == split % p
                        identities += 1
                    # The cross-convolution identity is checked without any
                    # vanishing hypothesis, so it is not a vacuous implication.
                    for w in range(n+delta+1, n+delta+H+1):
                        # U0*(B_O + e_E shifted back) minus
                        # U1*(B_E + e_O): the b terms cancel.
                        lhs = sum(x*(sum(y*a(w+i+j) for j, y in enumerate(O))
                                     + sum(y*odd(w+i+j-1) for j, y in enumerate(E)))
                                  for i, x in enumerate(U0))
                        lhs -= sum(x*(sum(y*a(w+i+j) for j, y in enumerate(E))
                                      + sum(y*odd(w+i+j) for j, y in enumerate(O)))
                                   for i, x in enumerate(U1))
                        rhs = sum(pow(z, w-1, p)*evaluate(g, z, p)*
                                  (evaluate(U0, z, p)**2-z*evaluate(U1, z, p)**2)
                                  for z in roots)
                        assert lhs % p == rhs % p
                        moments += 1

    terminal = []
    for p in (5, 13, 41, 17):
        N = 1 << v2(p-1)
        @lru_cache(None)
        def derived(n):
            return sum(coeff(p, n+i) for i in range(N)) % p
        @lru_cache(None)
        def independent(n):
            return sum(oracle('lai_sprang', p, n+i) for i in range(N)) % p
        checked = unresolved = failures = 0
        best = None
        for e in range(2*N+1):
            for m in range(16*N+1):
                limit = e+N+1
                result = longest_prefix(p, derived, e, m, limit)
                assert check_result(p, independent, e, m, limit, result)
                checked += 1
                unresolved += result.j is None
                failures += result.zero_prefix >= e+N
                if result.j is not None:
                    defect = result.j-(e+N-1)
                    if best is None or defect > best['terminal_defect']:
                        best = dict(e=e, m=m, j=result.j, U=result.R,
                                    terminal_defect=defect)
        terminal.append(dict(p=p, N=N, quotient_degree=[0, 2*N],
                             shifts=[0, 16*N], cutoff='e+N+1', checked=checked,
                             unresolved=unresolved, violations=failures, best=best))
    # Actual r=1 descent: 1+t^2 at shift 2 -> 1+t at shift 1.
    assert [sum(coeff(3, 1+k+i) for i in range(2)) % 3
            for k in range(1, 4)] == [0, 0, 2]
    # Removing one parent row is invalid: the known degree-zero sharp gap
    # vanishes through N-1, although R=1 is not divisible by t^N+1.
    for p in (5, 41, 17):
        N = 1 << v2(p-1)
        assert all(oracle('lai_sprang', p, 5*N+1+k) == 0 for k in range(1, N))
        assert oracle('lai_sprang', p, 6*N+1) != 0
    return dict(python=platform.python_version(), seed=None,
                method='exact parity identities and endpoint-aware terminal screen',
                parity_identities=identities, cross_moment_identities=moments,
                terminal=terminal, r1_terminal_values=[0, 0, 2],
                runtime_seconds=perf_counter()-started)


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
