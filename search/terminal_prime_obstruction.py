"""Prime-independent boundary certificates for the fixed scales N=4,8,16.

Prove a common-divisor condition on selected INTEGER maximal minors, rather
than sample primes. See results/2026-10-12-prime-obstruction.md for the theorem.
Generation uses modular elimination; readback uses a formal-series expansion
and rational determinants, independently of generation and Bareiss elimination.
"""
import argparse
from collections import Counter
from fractions import Fraction
import json
from math import gcd
from pathlib import Path
import platform
from time import perf_counter

from search.finite_rank import _Affine
from search.terminal_boundary_cover import determinant


SCALES = (4, 8, 16)
SELECTION_PRIMES = {4: 5, 8: 41, 16: 17}


def parameters(N):
    if N not in SCALES:
        raise ValueError('only the three stated boundary scales are supported')
    H = N // 2
    D = N - 1 + H
    T = 2 * D + 1
    L = 1 << T.bit_length()
    return H, D, T, L, N * L


def cases(N):
    _, _, T, L, period = parameters(N)
    for M in range(period):
        hole = any((M + i) % L == 0 for i in range(1, T + 1))
        for x in ((0, 1, -1) if hole else (None,)):
            yield M, x


def normalized_coefficient(N, n):
    u = n // (n & -n)
    return 0 if (u - 1) % N else 1 - 2 * (((u - 1) // N) % 2)


def integer_matrix(N, M, x):
    H, D, T, L, _ = parameters(N)
    a = [0] + [x if (M + i) % L == 0 else normalized_coefficient(N, M + i)
               for i in range(1, T + 1)]
    return [[sum(a[k+j:k+j+N]) for j in range(H + 1)]
            for k in range(1, D + 2)]


def formal_series(N, endpoint):
    """Independent exact coefficients of sum_k x^(2^k)/(1+x^(N*2^k))."""
    a = [0] * (endpoint + 1)
    scale = 1
    while scale <= endpoint:
        sign = 1
        for n in range(scale, endpoint + 1, N * scale):
            a[n] += sign
            sign = -sign
        scale *= 2
    return a


def rational_determinant(rows):
    """Independent Fraction Gaussian determinant, without modular/Bareiss code."""
    a = [[Fraction(x) for x in row] for row in rows]
    result = Fraction(1)
    for k in range(len(a)):
        pivot = next((i for i in range(k, len(a)) if a[i][k]), None)
        if pivot is None:
            return 0
        if pivot != k:
            a[k], a[pivot] = a[pivot], a[k]
            result = -result
        value = a[k][k]
        result *= value
        for i in range(k + 1, len(a)):
            factor = a[i][k] / value
            for j in range(k + 1, len(a)):
                a[i][j] -= factor * a[k][j]
    assert result.denominator == 1
    return result.numerator


def select_minor(A, p):
    system = _Affine(p, len(A[0]))
    selected = []
    for i, row in enumerate(A):
        old_rank = len(system.rows)
        system.add(row, 0)
        if len(system.rows) > old_rank:
            selected.append(i + 1)
        if len(selected) == len(A[0]):
            return selected
    return None


def odd_prime_factors(n):
    n = abs(n)
    if not n:
        raise ValueError('cannot factor zero')
    while n % 2 == 0:
        n //= 2
    factors, candidate = [], 3
    while candidate * candidate <= n:
        if n % candidate == 0:
            factors.append(candidate)
            while n % candidate == 0:
                n //= candidate
        candidate += 2
    if n > 1:
        factors.append(n)
    return factors


def generate():
    started = perf_counter()
    scales = []
    for N in SCALES:
        records = []
        for M, x in cases(N):
            A = integer_matrix(N, M, x)
            rows = select_minor(A, SELECTION_PRIMES[N])
            if rows is None:
                raise RuntimeError(('no initial minor', N, M, x))
            value = determinant([A[i-1] for i in rows])
            minors = [dict(rows=rows, determinant=value)]
            common = abs(value)
            for p in odd_prime_factors(common):
                rows = select_minor(A, p)
                if rows is None:
                    continue
                value = determinant([A[i-1] for i in rows])
                minors.append(dict(rows=rows, determinant=value))
                common = gcd(common, value)
            odd = common
            while odd % 2 == 0:
                odd //= 2
            if odd not in ((1, 3) if N == 4 else (1,)):
                raise RuntimeError(('unexcluded odd obstruction', N, M, x, common))
            records.append(dict(M=M, x=x, minors=minors, common_divisor=common))
        scales.append(dict(N=N, records=records))
    return dict(python=platform.python_version(), dependencies='standard library',
                seed=None, scope='all admissible primes with N=2^v2(p-1) in {4,8,16}; all shifts',
                scales=scales, runtime_seconds=perf_counter()-started)


def verify(data):
    started = perf_counter()
    assert [s['N'] for s in data['scales']] == list(SCALES)
    summaries = []
    for scale in data['scales']:
        N = scale['N']
        H, D, T, L, period = parameters(N)
        records = scale['records']
        assert [(r['M'], r['x']) for r in records] == list(cases(N))
        coefficients = formal_series(N, period - 1 + T)
        histogram, minors_checked = Counter(), 0
        for record in records:
            M, x = record['M'], record['x']
            # Independent construction directly in absolute coefficient indices.
            A = [[sum(x if (M+k+j+i) % L == 0 else coefficients[M+k+j+i]
                      for i in range(N)) for j in range(H+1)]
                 for k in range(1, D+2)]
            common = 0
            assert record['minors']
            for minor in record['minors']:
                rows = minor['rows']
                assert len(rows) == len(set(rows)) == H + 1
                assert all(isinstance(i, int) and 1 <= i <= D+1 for i in rows)
                value = rational_determinant([A[i-1] for i in rows])
                assert value != 0 and value == minor['determinant']
                common = gcd(common, value)
                minors_checked += 1
            assert common == record['common_divisor']
            odd = common
            while odd % 2 == 0:
                odd //= 2
            assert odd in ((1, 3) if N == 4 else (1,))
            histogram[common] += 1
        summaries.append(dict(N=N, cases=len(records), minors=minors_checked,
                              selected_gcd_histogram=dict(sorted(histogram.items()))))
    # A genuine failure of the stronger all-odd-characteristics rank hypothesis.
    a = formal_series(4, 15)
    A = [[sum(a[4+k+j:4+k+j+4]) for j in range(3)] for k in range(1, 7)]
    v = [1, 2, 2]
    assert all(sum(b*c for b, c in zip(row, v)) % 3 == 0 for row in A)
    return dict(scales=summaries, wrong_characteristic_control=dict(
        N=4, p=3, M=4, V=v, matrix=A), runtime_seconds=perf_counter()-started)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', type=Path)
    parser.add_argument('--verify', action='store_true')
    args = parser.parse_args()
    if args.verify:
        print(json.dumps(verify(json.loads(args.path.read_text())), indent=2))
    else:
        data = generate()
        args.path.write_text(json.dumps(data, separators=(',', ':')) + '\n')
        print(json.dumps(dict(cases=sum(len(s['records']) for s in data['scales']),
                              runtime_seconds=data['runtime_seconds'])))


if __name__ == '__main__':
    main()
