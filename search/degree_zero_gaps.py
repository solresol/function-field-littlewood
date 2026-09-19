"""Exact checks accompanying the degree-zero gap proof in the 20 September note.

Run with python3 -m search.degree_zero_gaps PATH [--verify]. The finite output
is evidence for implementations, not the proof of the all-shift statement.
"""
import argparse
from dataclasses import asdict
import json
from pathlib import Path
import platform
from time import perf_counter

from search.finite_rank import PrefixResult, check_result, longest_prefix
from search.lai_sprang_finite_search import coeff, first_fractional_index, v2
from search.run_rank_experiments import oracle


# One prime for each r=2,...,8; no randomness or prime-search heuristic.
PRIMES = (5, 41, 17, 97, 193, 641, 257)


def verify(data):
    """Read back using original rational root sums, without affine elimination."""
    rows = data['witnesses']
    if [row['p'] for row in rows] != list(PRIMES):
        raise ValueError('missing, duplicate or unexpected prime')
    for row in rows:
        p = row['p']
        N = 1 << v2(p-1)
        if (row['N'], row['d'], row['m'], row['limit']) != (N, 0, 5*N+1, N):
            raise ValueError('unexpected witness input')
        result = PrefixResult(**row['result'])
        if result.j != N or not check_result(
                p, lambda n: oracle('lai_sprang', p, n), 0, 5*N+1, N, result):
            raise ValueError('invalid degree-zero certificate')
    box = data['p17_shift_box']
    if (box['p'], box['d'], box['max_m'], box['limit']) != (17, 0, 128, 16):
        raise ValueError('unexpected shift box')
    expected = [next((j for j in range(1, 17)
                     if oracle('lai_sprang', 17, m+j)), None)
                for m in range(129)]
    if box['indices'] != expected or None in expected:
        raise ValueError('incomplete or incorrect shift indices')
    return dict(witnesses_verified=len(rows), shifts_verified=len(expected),
                unresolved=0, p17_max_index=max(expected),
                p17_first_attaining_shift=expected.index(16))


def run():
    started = perf_counter()
    rows = []
    for p in PRIMES:
        N = 1 << v2(p-1)
        m = 5*N+1
        result = longest_prefix(p, lambda n: coeff(p, n), 0, m, N)
        rows.append(dict(p=p, N=N, d=0, m=m, limit=N, result=asdict(result)))
    data = dict(python=platform.python_version(), seed=None,
                method='seven prescribed witnesses and exhaustive p17 degree-zero shifts',
                witnesses=rows,
                p17_shift_box=dict(p=17, d=0, max_m=128, limit=16,
                    indices=[first_fractional_index(17, (1,), m, 16)
                             for m in range(129)]))
    data['independent_readback'] = verify(data)
    data['runtime_seconds'] = perf_counter()-started
    return data


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', type=Path)
    parser.add_argument('--verify', action='store_true')
    args = parser.parse_args()
    if args.verify:
        print(json.dumps(verify(json.loads(args.path.read_text())), indent=2))
    else:
        # Refuse overwrites before starting any computation.
        with args.path.open('x') as output:
            data = run()
            json.dump(data, output, indent=2)
            output.write('\n')
        print(json.dumps(data['independent_readback'], indent=2))
        print(f"runtime_seconds: {data['runtime_seconds']:.6f}")
