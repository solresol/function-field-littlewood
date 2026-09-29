"""Exact integer support partitions; all-scale proof is in the dated report.

The stream is divided by N/2 before reduction to a prime field. Enumeration
here certifies only the requested finite interval, never a global bound.
"""
import argparse
import json
from pathlib import Path
import platform
from time import perf_counter


def support_interval(N, lo, hi):
    """List (n, sign) with n=2^k(1+Nh) in the inclusive interval.

    Each n has a unique k because N is even. Enumerate h by exact integer
    bounds, including h=0 (powers of two), without scanning the coefficients.
    """
    if N < 2 or N & (N-1) or lo < 1 or hi < lo:
        raise ValueError('require dyadic N>=2 and 1<=lo<=hi')
    points, scale = [], 1
    while scale <= hi:
        step = scale*N
        first = max(0, (lo-scale+step-1)//step)
        last = (hi-scale)//step
        for h in range(first, last+1):
            points.append((scale*(1+N*h), -1 if h % 2 else 1))
        scale *= 2
    return sorted(points)


def three_term_partition(N):
    """Retain all support and cancellation events through j=2N, including zeros."""
    m = 9*N+3
    points = support_interval(N, m+1, m+3*N)
    events = {}
    for term, (offset, weight) in enumerate(((0, 1), (N-1, -1), (N, 1))):
        for n, sign in points:
            j = n-m-offset
            if 1 <= j <= 2*N:
                events.setdefault(j, [0, 0, 0])[term] += weight*sign
    return dict(N=N, lo=m+1, hi=m+3*N, support=[list(x) for x in points],
                events=[dict(j=j, terms=values, total=sum(values))
                        for j, values in sorted(events.items())])


def verify_record(row):
    """Independent dense odd-part recurrence, without support enumeration.

    Checks complete support and complete events, not just a claimed first index.
    Integer signs are checked before any field reduction. No rank claim.
    """
    N = row['N']
    if N < 2 or N & (N-1):
        raise ValueError('invalid N')
    m, values = 9*N+3, {}
    for n in range(m+1, m+3*N+1):
        u = n
        while u % 2 == 0:
            u //= 2
        values[n] = (0 if u % N != 1 else
                     (-1 if ((u-1)//N) % 2 else 1))
    support = [[n, s] for n, s in values.items() if s]
    events = []
    for j in range(1, 2*N+1):
        terms = [values[m+j], -values[m+N-1+j], values[m+N+j]]
        if any(terms):
            events.append(dict(j=j, terms=terms, total=sum(terms)))
    expected = dict(N=N, lo=m+1, hi=m+3*N, support=support, events=events)
    if row != expected:
        raise ValueError('incorrect or incomplete support partition')
    return next((e['j'] for e in events if e['total']), None)


SCALES = (4, 8, 16, 32, 64, 128, 256)  # Recheck old scales, no expansion.


def verify(data):
    rows = data['partitions']
    if [r['N'] for r in rows] != list(SCALES):
        raise ValueError('missing, reordered or extra scales')
    indices = [verify_record(row) for row in rows]
    if indices != [1] + [2*N for N in SCALES[1:]]:
        raise ValueError('unexpected first indices')
    return dict(partitions_checked=len(rows), first_indices=indices)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', type=Path)
    parser.add_argument('--verify', action='store_true')
    args = parser.parse_args()
    start = perf_counter()
    if args.verify:
        result = verify(json.loads(args.path.read_text()))
    else:
        data = dict(python=platform.python_version(), seed=None,
                    method='integer support partition, finite regression only',
                    partitions=[three_term_partition(N) for N in SCALES])
        result = verify(data)
        data['generation_and_readback_seconds'] = perf_counter()-start
        with args.path.open('x') as output:
            output.write(json.dumps(data, indent=2)+'\n')
    print(json.dumps(result))
