"""Bounded deterministic experiment; run from repository root with python -m.

Writes one checkpoint JSONL record per (stream,degree,shift). Verification can
be rerun separately using --verify, with no Gaussian elimination calls.
"""
import argparse
from dataclasses import asdict
from functools import lru_cache
import json
from pathlib import Path
import platform
from time import perf_counter

from search.finite_rank import PrefixResult, longest_prefix, check_result
from search.lai_sprang_finite_search import coeff, oddpart, v2


@lru_cache(None)
def stream(name, p, n):
    if name == 'lai_sprang':
        return coeff(p, n)
    if name == 'thue_morse':
        return bin(n).count('1') % 2
    if name == 'paperfolding':
        return int(oddpart(n) % 4 == 1)
    if name == 'rudin_shapiro':
        bits = bin(n)[2:]
        return sum(bits[i:i+2] == '11' for i in range(len(bits)-1)) % 2
    raise ValueError(name)


@lru_cache(None)
def oracle(name, p, n):
    """Independent rational root sums / binary recurrences for readback."""
    if name == 'lai_sprang':
        N = 1 << v2(p-1)
        roots = [z for z in range(p) if pow(z, N//2, p) == p-1]
        total, scale = 0, 1
        while scale <= n:
            if n % scale == 0 and (n//scale) % 2:
                total += sum(pow(z, (n//scale-1)//2, p) for z in roots)
            scale *= 2
        return total % p
    if n == 0:
        return 0
    if name == 'thue_morse':
        return (oracle(name, p, n//2) + n%2) % 2
    if name == 'paperfolding':
        return int(n%4 == 1) if n%2 else oracle(name, p, n//2)
    if name == 'rudin_shapiro':
        return (oracle(name, p, n//2) + (n%2)*(n//2%2)) % 2
    raise ValueError(name)


def verify(path):
    started, count, unresolved = perf_counter(), 0, 0
    seen = set()
    for line in path.read_text().splitlines():
        row = json.loads(line)
        name, p, d, m, limit = (row[k] for k in ('stream','p','d','m','limit'))
        if limit != 128:
            raise ValueError('unexpected cutoff')
        key = (name, p, d, m)
        if key in seen:
            raise ValueError('duplicate input')
        seen.add(key)
        result = PrefixResult(**row['result'])
        if not check_result(p, lambda n: oracle(name, p, n), d, m, limit, result):
            raise ValueError(f'invalid certificate: {key}')
        count += 1
        unresolved += result.j is None
    # Completeness of the advertised fixed boxes is checked independently.
    expected = {(name,p,d,m) for name,p in STREAMS for d in range(17) for m in range(65)}
    if seen != expected:
        raise ValueError('missing or unexpected box inputs')
    return dict(verified=count, unresolved=unresolved,
                runtime_seconds=perf_counter()-started)


STREAMS = [('lai_sprang', p) for p in (5,13,17,41)] + [
    (name, 2) for name in ('thue_morse','paperfolding','rudin_shapiro')]


def run(path):
    started, boxes = perf_counter(), []
    with path.open('x') as output:
        for name, p in STREAMS:
            best, unresolved, profiles = None, 0, []
            for d in range(17):
                degree_best = None
                for m in range(65):
                    result = longest_prefix(p, lambda n: stream(name,p,n), d,m,128)
                    record = dict(stream=name,p=p,d=d,m=m,limit=128,result=asdict(result))
                    output.write(json.dumps(record, separators=(',',':'))+'\n')
                    if result.j is None:
                        unresolved += 1
                    else:
                        defect = result.j-d
                        if best is None or defect > best['defect']:
                            best = dict(defect=defect,d=d,m=m,**asdict(result))
                        degree_best = defect if degree_best is None else max(degree_best,defect)
                profiles.append(degree_best)
                output.flush()  # retain completed degrees if interrupted
            box = dict(stream=name,p=p,max_degree=16,max_m=64,limit=128,
                       checked=17*65,unresolved=unresolved,best=best,
                       max_defect_by_degree=profiles)
            if name == 'lai_sprang':
                box['N'] = 1 << v2(p-1)
            boxes.append(box)
            print(f'{name} F_{p}: max defect {best["defect"]}, unresolved {unresolved}',flush=True)
    summary = dict(python=platform.python_version(),seed=None,
                   method='exhaustive degree/shift boxes via exact affine elimination',
                   runtime_seconds=perf_counter()-started,boxes=boxes,
                   independent_readback=verify(path))
    path.with_suffix('.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps({k:v for k,v in summary.items() if k != 'boxes'},indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path',type=Path)
    parser.add_argument('--verify',action='store_true')
    args = parser.parse_args()
    if args.verify:
        print(json.dumps(verify(args.path),indent=2))
    else:
        run(args.path)
