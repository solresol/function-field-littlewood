"""Run the C terminal-window cover over prescribed primes and degree bounds.

    python3 -m search.run_terminal_cover results/2026-10-17-terminal-cover.json
    python3 -m search.run_terminal_cover results/2026-10-17-terminal-cover.json --verify

Requires a C compiler (cc). The C program uses Euclidean continued fractions;
the Python generator in search/lai_sprang_sharpness.py uses Berlekamp--Massey.
Every reported minimal degree is a complete all-shift statement only for the
listed bound E; an empty hit list proves nothing beyond E. Verification
reruns the small-field covers in Python and compares the hit lists exactly.
"""
import argparse
from concurrent.futures import ThreadPoolExecutor
import json
import os
from pathlib import Path
import platform
import re
import subprocess
import tempfile
from time import perf_counter

from search.lai_sprang_sharpness import cover_parameters, scan_cover, v2


SOURCE = Path(__file__).with_name('terminal_cover.c')


def admissible(N, upper):
    primes = [p for p in range(3, upper)
              if all(p % q for q in range(2, int(p ** 0.5) + 1))]
    return [p for p in primes if 1 << v2(p - 1) == N]


JOBS = ([(p, 250) for p in admissible(4, 1200)]
        + [(29, 1000), (37, 2000), (53, 2000), (61, 2000)]
        + [(p, 250) for p in admissible(8, 140)]
        + [(p, 250) for p in admissible(16, 120)])
CHUNKS = 64
LINE = re.compile(r'b=(\d+) x=(none|0|1|-1) e=(\d+) pq=(\d+|rational)$')


def compile_cover(directory):
    binary = Path(directory) / 'terminal_cover'
    subprocess.run(['cc', '-O2', '-o', str(binary), str(SOURCE)], check=True)
    return binary


def run_job(binary, p, E, workers):
    N = 1 << v2(p - 1)
    _, _, period, _ = cover_parameters(N, E)
    bounds = [period * i // CHUNKS for i in range(CHUNKS + 1)]
    started = perf_counter()

    def chunk(i):
        out = subprocess.run([str(binary), str(p), str(N), str(E),
                              str(bounds[i]), str(bounds[i + 1])],
                             check=True, capture_output=True, text=True)
        summary = out.stderr.strip().splitlines()[-1]
        cases = int(re.search(r'cases=(\d+)', summary).group(1))
        hits = []
        for line in out.stdout.splitlines():
            b, x, e, q = LINE.match(line).groups()
            hits.append(dict(b=int(b), x=None if x == 'none' else int(x),
                             e=int(e), jump=None if q == 'rational' else int(q)))
        return cases, hits

    with ThreadPoolExecutor(workers) as pool:
        parts = list(pool.map(chunk, range(CHUNKS)))
    hits = sorted((h for _, part in parts for h in part),
                  key=lambda h: (h['e'], h['b'], str(h['x'])))
    return dict(p=p, N=N, max_quotient_degree=E, period=period,
                cases=sum(c for c, _ in parts), hits=hits,
                least_quotient_degree=hits[0]['e'] if hits else None,
                runtime_seconds=perf_counter() - started)


def generate(workers):
    started = perf_counter()
    with tempfile.TemporaryDirectory() as directory:
        binary = compile_cover(directory)
        compiler = subprocess.run(['cc', '--version'], capture_output=True,
                                  text=True).stdout.splitlines()[0]
        jobs = [run_job(binary, p, E, workers) for p, E in JOBS]
    return dict(python=platform.python_version(), compiler=compiler,
                source='search/terminal_cover.c', seed=None, jobs=jobs,
                runtime_seconds=perf_counter() - started)


def verify(data):
    """Recompute the cheap N=4 covers with the independent Python profile."""
    started = perf_counter()
    assert [(j['p'], j['max_quotient_degree']) for j in data['jobs']] == JOBS
    compared = []
    for job in data['jobs']:
        p, E = job['p'], job['max_quotient_degree']
        if p not in (5, 13) or E != 250:
            continue
        python = scan_cover(p, E)
        key = lambda h: (h['e'], h['b'], str(h['x']))
        assert python['cases'] == job['cases']
        assert sorted(python['hits'], key=key) == job['hits']
        compared.append(dict(p=p, E=E, cases=job['cases'], hits=len(job['hits'])))
    summary = [dict(p=j['p'], N=j['N'], E=j['max_quotient_degree'],
                    least=j['least_quotient_degree'], hits=len(j['hits']))
               for j in data['jobs']]
    return dict(python_cross_checks=compared, summary=summary,
                runtime_seconds=perf_counter() - started)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', type=Path)
    parser.add_argument('--verify', action='store_true')
    parser.add_argument('--workers', type=int, default=os.cpu_count() or 1)
    args = parser.parse_args()
    if args.verify:
        print(json.dumps(verify(json.loads(args.path.read_text())), indent=2))
        return
    if args.path.exists():
        raise SystemExit(f'refusing to overwrite {args.path}')
    data = generate(args.workers)
    args.path.write_text(json.dumps(data, separators=(',', ':')) + '\n')
    print(json.dumps([(j['p'], j['max_quotient_degree'], j['least_quotient_degree'])
                      for j in data['jobs']]))


if __name__ == '__main__':
    main()
