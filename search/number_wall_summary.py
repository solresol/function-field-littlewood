"""Summarize a number-wall search run of search/number_wall.c (mode 1).

    python3 search/number_wall_summary.py RUN_DIR OUT.json [--factors FILE]

RUN_DIR holds progress*.err (stderr of the run and of any resumed runs, in
order), windows.out (stdout) and optionally a factor-count table written by
a distinct-factor count ("L=<L> positions=<n> distinct=<d> ...").

Recorded: the band histograms of first-seen windows by side, with cell counts
from the logged valid ranges and the random-wall density (p-1)^2 p^-(g+2);
the windows reported; the all-shift exclusion the run implies (below); and
the random-model expected number of side-N windows over distinct cells. The
random-wall density of side-g windows is (p-1)^3/((p+1)p^(g+2)) per cell.

All-shift exclusion. For quotient degree e<=E a terminal window at shift M
reads c_(M+1..M+T), T=2N+2E. With L the least power of two above T and
P=NL, c_(qP+b+i)=c_(b+i) unless L divides b+i; at most one such index h lies
in the window and c_(qP+h)=c(qN+h/L) with 1<=h/L<=N. Every value of
c(qN+w), q>=0, already occurs for some q in [1,N], checked below by brute
force, so every shift has an equivalent shift in [P,(N+1)P). If those shifts
sit inside the framed region at every row e<=E and no side-N window was
reported there, no terminal window of degree <=E exists at any shift. Ranges
only shrink with the row, so it suffices to test the first logged row >= E.
Standard library only.
"""
import argparse
import json
import re
from pathlib import Path

ROW = re.compile(r'^row (\d+) range \[(\d+),(\d+)\] windows (\d+) cuts (\d+) (\S+) cells/s elapsed (\S+)s band(.*)$')
FINAL = re.compile(r'^p=(\d+) N=(\d+) mode=(\d+) C=(\d+) rows=(\d+) windows=(\d+) unframed_cuts=(\d+) final_range=\[(-?\d+),(-?\d+)\]$')


def cnorm(N, n):
    u = n // (n & -n)
    m = (u - 1) % (2 * N)
    return 1 if m == 0 else (-1 if m == N else 0)


def equivalent_q_suffices(N, qmax=1 << 14):
    """Every value of c(qN+w), q>=0, occurs for some q in [1,N] (1<=w<=N)."""
    return all({cnorm(N, q * N + w) for q in range(qmax)} <= {cnorm(N, q * N + w) for q in range(1, N + 1)}
               for w in range(1, N + 1))


def parse(run_dir):
    rows, final, hist_line, resumed = [], None, None, []
    for path in sorted(Path(run_dir).glob('progress*.err')):
        for line in path.read_text().splitlines():
            m = ROW.match(line)
            if m:
                band = {int(g): int(c) for g, c in (t.split(':') for t in m.group(8).split())}
                rows.append(dict(row=int(m.group(1)), lo=int(m.group(2)), hi=int(m.group(3)),
                                 windows=int(m.group(4)), cuts=int(m.group(5)), band=band, file=path.name))
            elif line.startswith('resumed at row'):
                resumed.append(int(line.split()[3]))
            elif FINAL.match(line):
                final = FINAL.match(line)
            elif line.startswith('hist'):
                hist_line = {int(g): int(c) for g, c in (t.split(':') for t in line.split()[1:])}
    windows = [tuple(map(int, l.split()[1:])) for l in (Path(run_dir) / 'windows.out').read_text().splitlines()
               if l.startswith('window')]
    return rows, final, hist_line, resumed, windows


def distinct_profile(path, C):
    """Piecewise-linear distinct-cell count per row from a factor table."""
    pts = [(0, 0.0)]
    for line in Path(path).read_text().splitlines():
        f = dict(t.split('=') for t in line.split())
        L, d = int(f['L']), int(f['distinct'])
        pts.append(((L - 1) // 2, float(d)))
    pts.sort()

    def at(m):
        width = C - 2 * m
        for (m0, d0), (m1, d1) in zip(pts, pts[1:]):
            if m0 <= m <= m1:
                return min(width, d0 + (d1 - d0) * (m - m0) / (m1 - m0))
        return float(width)  # beyond the table every position was distinct
    return at


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('run_dir')
    ap.add_argument('out', type=Path)
    ap.add_argument('--factors')
    ap.add_argument('--p', type=int, default=41)
    ap.add_argument('--C', type=int, default=12000000)
    args = ap.parse_args()
    if args.out.exists():
        raise SystemExit(f'{args.out} exists; refusing to overwrite')
    p, C = args.p, args.C
    N = (p - 1) & -(p - 1)
    rows, final, hist, resumed, windows = parse(args.run_dir)
    # Random-wall density of side-g windows per cell: relative frequencies
    # (p-1)p^-(g+1) from the continued-fraction degree law, normalized so that
    # zero cells (g^2 per window) have density 1/p, the exact probability that
    # a random Hankel determinant over F_p vanishes.
    rho = lambda g: (p - 1) ** 3 / ((p + 1) * p ** (g + 2))
    bands, prev, files = [], dict(row=0, lo=0, hi=C - 1, file=None), []
    for r in rows:
        if r['file'] != prev.get('file') and prev.get('file') is not None and len(files) <= len(resumed):
            # a resumed run counts its first band from the checkpoint row
            prev = dict(prev, row=resumed[len(files) - 1])
        if r['file'] not in files:
            files.append(r['file'])
        if r['row'] <= prev['row']:
            continue
        cells = (r['row'] - prev['row']) * ((prev['hi'] - prev['lo'] + 1) + (r['hi'] - r['lo'] + 1)) / 2
        bands.append(dict(rows=[prev['row'] + 1, r['row']], lo=r['lo'], hi=r['hi'], cells=cells,
                          windows_by_side=r['band'],
                          observed_over_random={g: round(c / (cells * rho(g)), 3) for g, c in r['band'].items()}))
        prev = r
    last_row = int(final.group(5)) if final else (rows[-1]['row'] if rows else 0)
    # all-shift exclusion through the largest E with T=2N+2E < L and (N+1)P inside the region
    exclusion = None  # the largest E that passes covers every smaller degree
    if equivalent_q_suffices(N):
        for k in range(1, 40):
            L = 1 << k
            E = (L - 1 - 2 * N) // 2          # largest E with 2N+2E < L
            P = N * L
            covering = [r for r in rows if r['row'] >= E]
            if E < 0 or E > last_row or not covering:
                continue
            r = covering[0]
            ok = P - 2 >= r['lo'] and (N + 1) * P + E + N + 1 <= r['hi'] and not any(m0 <= E for m0, _, _ in windows)
            if not ok:
                continue
            exclusion = dict(E=E, T=2 * N + 2 * E, L=L, P=P, shifts=[P, (N + 1) * P - 1], checked_at_row=r['row'],
                             lo=r['lo'], hi=r['hi'], strict_cutoff=f'j-d<=N for all d<{N * (N + E)}')
    expected = None
    if args.factors:
        at = distinct_profile(args.factors, C)
        step = max(1, last_row // 20000)
        distinct = sum(at(m) for m in range(0, last_row + 1, step)) * step
        computed = sum(b['cells'] for b in bands)
        expected = dict(distinct_cells=distinct, computed_cells=computed, side_N_density=rho(N),
                        expected_side_N_windows=distinct * rho(N))
    summary = dict(p=p, N=N, C=C, rows_completed=last_row, resumed_at=resumed,
                   final=final.group(0) if final else None, totals_by_side=hist,
                   side_N_windows=[dict(m0=m0, n0=n0, g=g, M=n0 - m0, e=m0) for m0, n0, g in windows],
                   random_density_by_side={g: rho(g) for g in range(1, N + 1)},
                   all_shift_exclusion=exclusion, random_model=expected, bands=bands)
    args.out.write_text(json.dumps(summary, indent=1) + '\n')
    print(json.dumps({k: v for k, v in summary.items() if k != 'bands'}, indent=1))


if __name__ == '__main__':
    main()
