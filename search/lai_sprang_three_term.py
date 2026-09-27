"""Bounded three-term family test; no all-scale or global-bound assertion.

python3 -m search.lai_sprang_three_term PATH [--verify]
Generation checkpoints each prescribed input. Readback uses original root sums
and independent primal/dual dot products, never the support formula or solver.
"""
import argparse
from dataclasses import asdict
import json
from pathlib import Path
import platform
from time import perf_counter

from search.finite_rank import PrefixResult, check_result, longest_prefix, validate_field
from search.lai_sprang_finite_search import coeff, v2
from search.run_rank_experiments import oracle

PRIMES = (5, 13, 29, 41, 73, 17, 113, 97, 193, 641, 257)
R1_PRIMES = (3, 7, 11, 19, 23, 31)
OPTIMUM_MAX_N = 32


def sparse_index(p, a, terms, m, limit):
    """Evaluate a canonical sparse multiplier, reading at most m+d+limit.

    None means only a zero prefix through limit; the terminal coefficient is
    then absent. Terms include both nonzero endpoints, starting at degree zero.
    """
    validate_field(p)
    if (m < 0 or limit < 1 or not terms or terms[0][0] != 0
            or any(i < 0 or not 0 < c < p for i, c in terms)
            or any(x[0] >= y[0] for x, y in zip(terms, terms[1:]))):
        raise ValueError('invalid sparse multiplier, shift or cutoff')
    for j in range(1, limit+1):
        value = sum(c*a(m+i+j) for i, c in terms) % p
        if value:
            return dict(j=j, zero_prefix=j-1, terminal=value)
    return dict(j=None, zero_prefix=limit, terminal=None)


def cases():
    for p in PRIMES:
        N = 1 << v2(p-1)
        yield dict(kind='three_term', p=p, N=N, d=N, m=9*N+3,
                   limit=2*N, terms=[[0, 1], [N-1, p-1], [N, 1]])
    for p in R1_PRIMES:
        yield dict(kind='r1_comparison', p=p, N=2, d=2, m=2, limit=6,
                   terms=[[0, 1], [2, 1]])


def verify(path):
    """Check exact input coverage, first index and optional fixed-input optimum.

    Diagnostic rank and runtime metadata are not certified. Optima quantify all
    endpoint-nonzero multipliers only at the recorded degree and shift.
    """
    started = perf_counter()
    rows = [json.loads(line) for line in path.read_text().splitlines()]
    expected = list(cases())
    if len(rows) != len(expected):
        raise ValueError('missing or extra inputs')
    summary, optimum_count, unresolved = [], 0, 0
    for row, case in zip(rows, expected):
        if any(row.get(k) != v for k, v in case.items()):
            raise ValueError('unexpected, reordered or duplicate input')
        p, d, m, limit = (case[k] for k in ('p', 'd', 'm', 'limit'))
        # Dense independent evaluation deliberately does not call sparse_index.
        R = [0]*(d+1)
        for i, c in case['terms']:
            R[i] = c
        first, terminal = None, None
        for j in range(1, limit+1):
            value = sum(c*oracle('lai_sprang', p, m+i+j)
                        for i, c in enumerate(R)) % p
            if value:
                first, terminal = j, value
                break
        result = dict(j=first, zero_prefix=limit if first is None else first-1,
                      terminal=terminal)
        if row.get('witness') != result:
            raise ValueError('invalid first-index witness')
        needs_optimum = case['kind'] == 'three_term' and case['N'] <= OPTIMUM_MAX_N
        optimum = row.get('optimum')
        optimum_j = None
        if needs_optimum:
            if not isinstance(optimum, dict):
                raise ValueError('missing optimum')
            certificate = PrefixResult(**optimum)
            if not check_result(p, lambda n: oracle('lai_sprang', p, n),
                                d, m, limit, certificate):
                raise ValueError('invalid optimum certificate')
            optimum_count += 1
            optimum_j = certificate.j
            unresolved += optimum_j is None
        elif optimum is not None:
            raise ValueError('unexpected optimum claim')
        unresolved += first is None
        summary.append(dict(kind=case['kind'], p=p, N=case['N'], d=d, m=m,
                            j=first, defect=None if first is None else first-d,
                            optimum_checked=needs_optimum, optimum_j=optimum_j))
    return dict(witnesses_verified=len(rows), optima_verified=optimum_count,
                unresolved=unresolved, cases=summary,
                runtime_seconds=perf_counter()-started)


def run(path):
    summary_path = path.with_suffix('.json')
    if path == summary_path or summary_path.exists():
        raise FileExistsError('use a new JSONL path and absent JSON summary')
    started = perf_counter()
    with path.open('x') as output:
        for case in cases():
            p, d, m, limit = (case[k] for k in ('p', 'd', 'm', 'limit'))
            a = lambda n: coeff(p, n)
            witness = sparse_index(p, a, case['terms'], m, limit)
            optimum = None
            if case['kind'] == 'three_term' and case['N'] <= OPTIMUM_MAX_N:
                optimum = asdict(longest_prefix(p, a, d, m, limit))
            output.write(json.dumps(dict(**case, witness=witness, optimum=optimum),
                                    separators=(',', ':'))+'\n')
            output.flush()
    elapsed = perf_counter()-started
    readback = verify(path)
    data = dict(python=platform.python_version(), seed=None,
                method='prescribed sparse witnesses; selected exact affine optima',
                generation_seconds=elapsed, independent_readback=readback)
    with summary_path.open('x') as output:
        output.write(json.dumps(data, indent=2)+'\n')
    return data


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', type=Path)
    parser.add_argument('--verify', action='store_true')
    args = parser.parse_args()
    print(json.dumps(verify(args.path) if args.verify else run(args.path), indent=2))
