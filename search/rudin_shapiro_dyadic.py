"""Prescribed binary Rudin--Shapiro witnesses with independent finite checking.

The all-scale binary-block proof is in results/2026-09-25-rudin-shapiro-dyadic.md.
This runner checks k=0,...,12; only k<=4 receive affine optimality certificates.
Python 3.9+ standard library, deterministic, no random seed.
"""
import argparse
from dataclasses import asdict
import json
from pathlib import Path
import platform
from time import perf_counter

from search.finite_rank import PrefixResult, check_result, longest_prefix
from search.run_rank_experiments import oracle, stream
from search.thue_morse_dyadic import first_index


MAX_K = 12
RANK_MAX_K = 4


def family(k):
    if type(k) is not int or k < 0:
        raise ValueError('k must be a nonnegative integer')
    L = 1 << k
    support = set()
    for h in range(4):
        for e in (0, 1):
            support.symmetric_difference_update([h*L+e])
    return dict(k=k, p=2, d=3*L+1, m=14*L-1, limit=5*L,
                support=sorted(support))


def verify(data):
    """Check every retained coefficient via recursion, not the scaling identity.

    Neither generation's binary-string counter nor elimination is called.
    Input completeness, exact first index, endpoints and small duals are checked;
    runtime/platform metadata and diagnostic ranks are not certified.
    """
    rows = data['witnesses']
    if [row['k'] for row in rows] != list(range(MAX_K+1)):
        raise ValueError('missing, duplicate or unexpected scale')
    a = lambda n: oracle('rudin_shapiro', 2, n)
    for row in rows:
        k = row['k']
        if any(row[key] != value for key, value in family(k).items()):
            raise ValueError('unexpected family input')
        j = row['j']
        if j != row['limit'] or row['defect'] != j-row['d']:
            raise ValueError('invalid index or defect')
        # Fixed inputs above ensure nonzero endpoints and inclusive m+d+j locality.
        for s in range(1, j+1):
            value = sum(a(row['m']+i+s) for i in row['support']) % 2
            if value != int(s == j):
                raise ValueError('invalid exact-index witness')
        if k <= RANK_MAX_K:
            result = PrefixResult(**row['optimum'])
            if result.j != j or not check_result(
                    2, a, row['d'], row['m'], row['limit'], result):
                raise ValueError('invalid optimum certificate')
        elif row['optimum'] is not None:
            raise ValueError('unexpected optimum claim')
    return dict(witnesses_verified=MAX_K+1, optima_verified=RANK_MAX_K+1,
                unresolved=0, max_defect=2*(1 << MAX_K)-1,
                max_inclusive_coefficient=22*(1 << MAX_K))


def run(output):
    """Checkpoint each completed scale; caller must open a fresh output file."""
    started = perf_counter()
    data = dict(python=platform.python_version(), seed=None,
                method='prescribed sparse witnesses; small exact affine optima',
                witnesses=[])
    a = lambda n: stream('rudin_shapiro', 2, n)
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
    data['search_runtime_seconds'] = perf_counter()-started
    started = perf_counter()
    data['independent_readback'] = verify(data)
    data['readback_runtime_seconds'] = perf_counter()-started
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
        print(json.dumps({k: v for k, v in data.items() if k != 'witnesses'}, indent=2))
