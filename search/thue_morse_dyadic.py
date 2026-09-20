"""Prescribed binary Thue--Morse witnesses, with independent finite readback.

The all-scale proof is in results/2026-09-21-thue-morse-dyadic.md. This runner
checks only k=0,...,12, and certifies degree/shift optimality only for k<=5.
Python 3.9+ standard library; deterministic; no random seed.
"""
import argparse
from dataclasses import asdict
import json
from pathlib import Path
import platform
from time import perf_counter

from search.finite_rank import PrefixResult, check_result, longest_prefix
from search.run_rank_experiments import oracle, stream


MAX_K = 12
RANK_MAX_K = 5


def family(k):
    if not isinstance(k, int) or k < 0:
        raise ValueError('k must be a nonnegative integer')
    L = 1 << k
    # Polynomial multiplication over F_2: at k=0 the two t terms cancel.
    support = set()
    for i in (0, 1, L, L+1):
        support.symmetric_difference_update([i])
    return dict(k=k, p=2, d=L+1, m=2*L-1, limit=3*L,
                support=sorted(support))


def first_index(a, support, m, limit):
    """Sparse F_2 multiplication; None means unresolved through inclusive limit."""
    if (not support or support[0] != 0 or support != sorted(set(support))
            or any(not isinstance(i, int) or i < 0 for i in support)
            or m < 0 or limit < 1):
        raise ValueError('invalid sparse multiplier, shift or cutoff')
    return next((j for j in range(1, limit+1)
                 if sum(a(m+i+j) for i in support) % 2), None)


def verify(data):
    """Recompute all coefficients by binary recurrence, without elimination.

    Checks the exact fixed input list, primal indices and small-case duals.
    Timing/platform metadata and the rank diagnostic are not certified.
    """
    rows = data['witnesses']
    if [row['k'] for row in rows] != list(range(MAX_K+1)):
        raise ValueError('missing, duplicate or unexpected scale')
    a = lambda n: oracle('thue_morse', 2, n)
    for row in rows:
        k = row['k']
        expected = family(k)
        if any(row[key] != value for key, value in expected.items()):
            raise ValueError('unexpected family input')
        j = first_index(a, row['support'], row['m'], row['limit'])
        if j != 3*(1 << k) or row['j'] != j or row['defect'] != j-row['d']:
            raise ValueError('invalid exact-index witness')
        if k <= RANK_MAX_K:
            result = PrefixResult(**row['optimum'])
            if result.j != j or not check_result(
                    2, a, row['d'], row['m'], row['limit'], result):
                raise ValueError('invalid optimum certificate')
        elif row['optimum'] is not None:
            raise ValueError('unexpected optimum claim')
    return dict(witnesses_verified=MAX_K+1, optima_verified=RANK_MAX_K+1,
                unresolved=0, max_defect=(1 << (MAX_K+1))-1,
                max_inclusive_coefficient=6*(1 << MAX_K))


def run(output):
    """Checkpoint each prescribed scale as a complete JSON document."""
    started = perf_counter()
    data = dict(python=platform.python_version(), seed=None,
                method='prescribed sparse witnesses; small exact affine optima',
                witnesses=[])
    a = lambda n: stream('thue_morse', 2, n)
    for k in range(MAX_K+1):
        row = family(k)
        row['j'] = first_index(a, row['support'], row['m'], row['limit'])
        row['defect'] = None if row['j'] is None else row['j']-row['d']
        row['optimum'] = (asdict(longest_prefix(2, a, row['d'], row['m'], row['limit']))
                          if k <= RANK_MAX_K else None)
        data['witnesses'].append(row)
        output.seek(0)
        json.dump(data, output, indent=2)
        output.truncate()
        output.flush()
    data['independent_readback'] = verify(data)
    data['runtime_seconds'] = perf_counter()-started
    output.seek(0)
    json.dump(data, output, indent=2)
    output.write('\n')
    output.truncate()
    return data


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', type=Path)
    parser.add_argument('--verify', action='store_true')
    args = parser.parse_args()
    if args.verify:
        print(json.dumps(verify(json.loads(args.path.read_text())), indent=2))
    else:
        with args.path.open('x') as output:
            data = run(output)
        print(json.dumps(data['independent_readback'], indent=2))
        print(f"runtime_seconds: {data['runtime_seconds']:.6f}")
