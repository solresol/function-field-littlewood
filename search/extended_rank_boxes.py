"""Two bounded follow-up boxes with independent, completeness-checked readback.

Run from the repository root with python3 -m search.extended_rank_boxes PATH.
No global bound or infinite-stream conclusion follows from these finite boxes.
"""
import argparse
from collections import Counter
from dataclasses import asdict
import json
from pathlib import Path
import platform
from time import perf_counter

from search.finite_rank import PrefixResult, check_result, longest_prefix
from search.run_rank_experiments import oracle, stream

# Inclusive bounds, disjoint from the 18 September boxes.
BOXES = (
    ('lai_sprang', 17, 1, 16, 65, 256),
    ('rudin_shapiro', 2, 17, 32, 0, 128),
)
LIMIT = 128


def inputs():
    return {(name, p, d, m) for name, p, d0, d1, m0, m1 in BOXES
            for d in range(d0, d1+1) for m in range(m0, m1+1)}


def verify(path):
    """Read only certificates; regenerate streams independently, never optimise."""
    started, seen, expected = perf_counter(), set(), inputs()
    stats = {}
    for line in path.read_text().splitlines():
        row = json.loads(line)
        key = tuple(row[k] for k in ('stream', 'p', 'd', 'm'))
        if key not in expected or key in seen or row['limit'] != LIMIT:
            raise ValueError('unexpected, duplicate input or cutoff')
        seen.add(key)
        name, p, d, m = key
        result = PrefixResult(**row['result'])
        if not check_result(p, lambda n: oracle(name, p, n), d, m, LIMIT, result):
            raise ValueError(f'invalid certificate: {key}')
        tag = f'{name}_F{p}'
        if tag not in stats:
            stats[tag] = dict(checked=0, unresolved=0, best=None,
                             max_defect_by_degree={}, obstructions=Counter(),
                             attaining_best=0, largest_prefix_index=0)
        s = stats[tag]
        s['checked'] += 1
        s['largest_prefix_index'] = max(s['largest_prefix_index'],
                                       m+d+(result.j or LIMIT))
        if result.j is None:
            s['unresolved'] += 1
            continue
        s['obstructions'][result.obstruction['kind']] += 1
        defect = result.j-d
        s['max_defect_by_degree'][d] = max(defect, s['max_defect_by_degree'].get(d, defect))
        if s['best'] is None or defect > s['best']['defect']:
            s['best'] = dict(d=d, m=m, defect=defect, **asdict(result))
            s['attaining_best'] = 0
        if defect == s['best']['defect']:
            s['attaining_best'] += 1
    if seen != expected:
        raise ValueError('missing box inputs')
    return dict(verified=len(seen), boxes=stats,
                runtime_seconds=perf_counter()-started)


def run(path):
    summary_path = path.with_suffix('.json')
    if path == summary_path or summary_path.exists():
        raise FileExistsError('use a new JSONL path and an absent JSON summary')
    started = perf_counter()
    with path.open('x') as output:
        for name, p, d0, d1, m0, m1 in BOXES:
            for d in range(d0, d1+1):
                for m in range(m0, m1+1):
                    result = longest_prefix(p, lambda n: stream(name, p, n), d, m, LIMIT)
                    row = dict(stream=name, p=p, d=d, m=m, limit=LIMIT, result=asdict(result))
                    output.write(json.dumps(row, separators=(',', ':'))+'\n')
                output.flush()  # completed degrees survive interruption
    elapsed = perf_counter()-started
    readback = verify(path)
    summary = dict(python=platform.python_version(), seed=None, boxes=BOXES,
                   limit=LIMIT, method='exact affine optimisation, all multipliers per input',
                   search_runtime_seconds=elapsed, independent_readback=readback)
    with summary_path.open('x') as output:
        output.write(json.dumps(summary, indent=2)+'\n')
    return summary


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', type=Path)
    parser.add_argument('--verify', action='store_true')
    args = parser.parse_args()
    print(json.dumps(verify(args.path) if args.verify else run(args.path), indent=2))
