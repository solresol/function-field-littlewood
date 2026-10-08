"""Exact controls for the 9 October all-shift terminal degree exclusion.

Run python3 -m search.terminal_low_degree_check. The ordinary proof is in the
dated report. This checks polynomial identities and explicit adjacent-row
obstructions, not a multiplier/shift search or a proof by finite agreement.
"""
import json
import platform
from itertools import product
from time import perf_counter

from search.lai_sprang_descent_check import evaluate, multiply
from search.lai_sprang_finite_search import coeff, v2
from search.run_rank_experiments import oracle


def trim(a):
    a = list(a)
    while a and a[-1] == 0:
        a.pop()
    return a


def norm_polynomial(V, p):
    even = multiply(V[::2], V[::2], p) if V[::2] else []
    odd = multiply(V[1::2], V[1::2], p) if V[1::2] else []
    W = [0] * max(len(even), len(odd) + 1)
    for i, x in enumerate(even):
        W[i] = x
    for i, x in enumerate(odd):
        W[i+1] = (W[i+1] - x) % p
    return trim(W)


def run():
    started = perf_counter()
    polynomial_checks = []
    for p in (3, 5, 13, 41, 17):
        N = 1 << v2(p-1)
        H = N//2
        # Exhaustive coefficient domains are small algebraic controls only.
        width = {3: 2, 5: 4, 13: 2, 41: 1, 17: 3}[p]
        vectors = {tuple(trim(V)) for V in product(range(p), repeat=width)}
        vectors.update(tuple([0]*i + [1]) for i in range(H))
        vectors.add(tuple([1] + [0]*(H-1) + [1]))
        vectors.discard(())
        low_degree_monomial_norms = 0
        for V in vectors:
            W = norm_polynomial(V, p)
            # Independent full product in s, rather than parity formulas.
            full = multiply(V, [x * (-1)**i % p for i, x in enumerate(V)], p)
            expanded = [0] * (2*len(W)-1)
            expanded[::2] = W
            assert trim(full) == expanded
            assert len(W) == len(V)
            assert next(i for i, x in enumerate(W) if x) == next(
                i for i, x in enumerate(V) if x)
            assert (sum(x != 0 for x in W) == 1) == (
                sum(x != 0 for x in V) == 1)
            if len(V) <= H and sum(x != 0 for x in W) == 1:
                low_degree_monomial_norms += 1
        polynomial_checks.append(dict(
            p=p, N=N, exhaustive_coefficient_width=width,
            additional_vectors='all unit monomials of degree < H; 1+t^H',
            nonzero_vectors=len(vectors),
            low_degree_monomial_norms=low_degree_monomial_norms))

    row_checks = []
    for p in (5, 13, 41, 17):
        N = 1 << v2(p-1)
        H = N//2
        # Representatives of every residue and both exceptional q parities,
        # plus large indices; there is no inference about unexamined shifts.
        shifts = list(range(2*N)) + [(1 << 50)*N+b for b in (0, 1, N-1)]
        records = []
        for M in shifts:
            exceptional = M % N == 1
            v = M+1 if exceptional else M+1 + (-M) % N
            j = v-M
            assert 1 <= j < N
            rows = [sum(oracle('lai_sprang', p, M+k+i) for i in range(N)) % p
                    for k in (j, j+1)]
            difference = (rows[1]-rows[0]) % p
            assert difference == (coeff(p, v+N)-coeff(p, v)) % p
            if exceptional:
                q = (M-1)//N
                expected = (H*(-1)**((q+1)//2) if q % 2 else
                            -H*(-1)**(q//2)) % p
            else:
                q = (v-1)//N
                expected = -2*H*(-1)**q % p
            assert difference == expected and difference != 0
            records.append(dict(M=M, adjacent_rows=[j, j+1], values=rows,
                                difference=difference,
                                inclusive_original_endpoint=v+N))
        row_checks.append(dict(p=p, N=N, records=records))

    # At the excluded boundary e=H the reduced norm can be a monomial even
    # though V is not. It is not a genuine terminal-window counterexample.
    p, N, H = 5, 4, 2
    V = [1, 1, 3]
    W = norm_polynomial(V, p)
    assert W == [1, 0, 4]
    roots = [z for z in range(1, p) if pow(z, H, p) == p-1]
    assert [evaluate(W, z, p) for z in roots] == [2, 2]
    assert sum(z*evaluate(W, z, p) for z in roots) % p == 0
    S = multiply([1]*N, V, p)
    rows = [sum(x*oracle('lai_sprang', p, 1+k+i) for i, x in enumerate(S)) % p
            for k in range(1, len(S)+2)]
    assert rows == [2, 0, 2, 0, 2, 4, 0]
    r1 = [sum(oracle('lai_sprang', 3, 1+k+i) for i in (0, 1)) % 3
          for k in range(1, 4)]
    assert r1 == [0, 0, 2]
    return dict(
        python=platform.python_version(), dependencies='Python standard library',
        seed=None, scope='identity and explicit obstruction checks; no search',
        polynomial_checks=polynomial_checks, adjacent_row_checks=row_checks,
        degree_boundary=dict(p=5, N=4, V=V, W=W, M=1, C=2,
                             original_rows=rows, inclusive_original_endpoint=13),
        r1_terminal_rows=r1, runtime_seconds=perf_counter()-started)


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
