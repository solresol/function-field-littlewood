"""Finite cover of ALL shifts at quotient degree H=N/2, in four fixed fields.

The ordinary covering argument is in results/2026-10-11-sunday-integration.md.
Generation reuses affine elimination only to select a square minor. Verification
uses original root sums and an independent integer Bareiss determinant.
"""
import argparse
import json
import platform
from pathlib import Path
from time import perf_counter

from search.finite_rank import _Affine
from search.lai_sprang_finite_search import coeff, v2
from search.run_rank_experiments import oracle


FIELDS = (5, 13, 41, 17)


def parameters(p):
    N = 1 << v2(p - 1)
    H = N // 2
    D = N - 1 + H
    length = 2 * D + 1
    L = 1 << length.bit_length()
    return N, H, D, length, L, N * L


def cases(p):
    _, H, _, length, L, period = parameters(p)
    for M in range(period):
        holes = [i for i in range(1, length + 1) if (M + i) % L == 0]
        assert len(holes) <= 1
        for x in ((0, H % p, -H % p) if holes else (None,)):
            yield M, x


def matrix(p, M, x, independent=False):
    N, H, D, length, L, _ = parameters(p)
    source = (lambda n: oracle('lai_sprang', p, n)) if independent else (
        lambda n: coeff(p, n))
    a = [0] + [x if (M + i) % L == 0 else source(M + i)
               for i in range(1, length + 1)]
    # Column j is B_(t^j F)(M+k), k=1,...,D+1. The inclusive
    # last original coefficient is M+(D+1)+H+(N-1)=M+2D+1.
    return [[sum(a[k + j + i] for i in range(N)) % p
             for j in range(H + 1)] for k in range(1, D + 2)]


def determinant(rows):
    """Exact integer determinant; no finite-field elimination dependency."""
    a = [row[:] for row in rows]
    sign, previous = 1, 1
    for k in range(len(a) - 1):
        pivot_row = next((i for i in range(k, len(a)) if a[i][k]), None)
        if pivot_row is None:
            return 0
        if pivot_row != k:
            a[k], a[pivot_row] = a[pivot_row], a[k]
            sign = -sign
        pivot = a[k][k]
        for i in range(k + 1, len(a)):
            for j in range(k + 1, len(a)):
                numerator = a[i][j] * pivot - a[i][k] * a[k][j]
                assert numerator % previous == 0
                a[i][j] = numerator // previous
            a[i][k] = 0
        previous = pivot
    return sign * a[-1][-1]


def generate():
    started = perf_counter()
    fields = []
    for p in FIELDS:
        N, H, D, length, L, period = parameters(p)
        records = []
        for M, x in cases(p):
            rows = matrix(p, M, x)
            system = _Affine(p, H + 1)
            selected = []
            for i, row in enumerate(rows):
                old_rank = len(system.rows)
                system.add(row, 0)
                if len(system.rows) > old_rank:
                    selected.append(i + 1)
                if len(selected) == H + 1:
                    break
            if len(selected) != H + 1:
                raise RuntimeError(('cover did not exclude this case', p, M, x))
            det = determinant([rows[i - 1] for i in selected]) % p
            assert det != 0
            records.append(dict(M=M, x=x, rows=selected, determinant_mod_p=det))
        fields.append(dict(p=p, N=N, H=H, D=D, interval_length=length,
                           L=L, period=period, records=records))
    return dict(python=platform.python_version(), dependencies='standard library',
                seed=None, scope='complete abstract shift cover at degree H',
                fields=fields, runtime_seconds=perf_counter() - started)


def verify(data):
    assert [f['p'] for f in data['fields']] == list(FIELDS)
    count = 0
    for field in data['fields']:
        p = field['p']
        N, H, D, length, L, period = parameters(p)
        assert [field[k] for k in ('N', 'H', 'D', 'interval_length', 'L', 'period')] == [
            N, H, D, length, L, period]
        records = field['records']
        assert [(r['M'], r['x']) for r in records] == list(cases(p))
        for record in records:
            selected = record['rows']
            assert len(selected) == len(set(selected)) == H + 1
            assert all(1 <= i <= D + 1 for i in selected)
            rows = matrix(p, record['M'], record['x'], independent=True)
            det = determinant([rows[i - 1] for i in selected]) % p
            assert 0 < det == record['determinant_mod_p'] < p
            count += 1
    return count


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', type=Path)
    parser.add_argument('--verify', action='store_true')
    args = parser.parse_args()
    if args.verify:
        started = perf_counter()
        count = verify(json.loads(args.path.read_text()))
        print(json.dumps(dict(verified_minors=count, runtime_seconds=perf_counter()-started)))
    else:
        data = generate()
        args.path.write_text(json.dumps(data, separators=(',', ':')) + '\n')
        print(json.dumps(dict(records=sum(len(f['records']) for f in data['fields']),
                              runtime_seconds=data['runtime_seconds'])))


if __name__ == '__main__':
    main()
