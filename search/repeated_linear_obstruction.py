"""A common fixed linear invariant cannot separate the two N=4 block rays.

Proof and precise scope: results/2026-11-16-linear-invariant-obstruction.md.
Two determinants and their Bezout identity certify transversality in every
admissible characteristic. This is not a terminal or repetition-length search.
Generation uses the existing fraction-free merge; independent readback uses
original integer coefficient windows and Fraction determinants, without merges.
"""
import argparse
import json
from pathlib import Path
from time import perf_counter

from search.dyadic_selector_obstruction import bezout
from search.fraction_free_block import merge, seed, step, wedge
from search.lai_sprang_sharpness import normalized
from search.terminal_prime_obstruction import formal_series, rational_determinant


DEFAULT = Path('results/2026-11-16-linear-invariant-certificate.json')
INPUTS = (62, 126)
N = 4


def require(condition, message):
    if not condition:
        raise ValueError(message)


def contexts(q0):
    """The first phase-3 input and one image of the fixed map, only."""
    return ((4*(q0+1)-1, 35), (8*(q0+1)-1, 71))


def joint_matrix(q0):
    """114 equations on (f[4],s[4],x[35],y[71]).

    The two original first-square blocks share the *same* boundary (f,s).
    Their raw shifts are q+1, so their last indices are q+2*k-1 inclusive.
    The final four equations of each block are actual residue sums, not a
    terminal target. No boundary vector, determinant or pivot is normalized.
    """
    pairs = contexts(q0)
    width = 2*N+sum(k for _, k in pairs)
    rows, offset = [], 2*N
    for q, k in pairs:
        for i in range(k):
            row = [0]*width
            row[i % N] = -1
            for j in range(k):
                row[offset+j] = normalized(N, q+1+i+j)
            rows.append(row)
        for a in range(N):
            row = [0]*width
            row[N+a] = -1
            for j in range(k):
                row[offset+j] = int(j % N == a)
            rows.append(row)
        offset += k
    assert len(rows) == width == 114
    return rows


def generate():
    records = []
    for q0 in INPUTS:
        state = seed(N, q0, 8, formal_series(N, q0+18))
        phase = q0 % N
        for _ in range(2):
            state, phase = step(state, N, phase)
        assert phase == 3
        # A00 at phase 3 uses exactly A11 and B00, at raw shift 0 mod 8.
        image = merge(state[3], state[4], N, 0)
        top = wedge(state[0], image)
        assert set(top) == {255}
        records.append(dict(q0=q0, contexts=[list(c) for c in contexts(q0)],
                            determinant=top[255],
                            endpoint_inclusive=max(q+2*k-1 for q, k in contexts(q0))))
    g, a, b = bezout(*(r['determinant'] for r in records))
    assert g == 18
    return dict(N=N, phase=3, records=records, bezout=[a, b], gcd=g)


def verify(data):
    """Independent integer readback; no exterior propagation or field samples."""
    require(data['N'] == N and data['phase'] == 3, 'fixed scale and phase')
    require([r['q0'] for r in data['records']] == list(INPUTS), 'two prescribed inputs')
    values = []
    for record in data['records']:
        q0 = record['q0']
        require(record['contexts'] == [list(c) for c in contexts(q0)], 'exact contexts')
        require(record['endpoint_inclusive'] == max(q+2*k-1 for q, k in contexts(q0)),
                'inclusive coefficient endpoint')
        value = record['determinant']
        require(type(value) is int and value != 0, 'nonzero integer determinant')
        require(rational_determinant(joint_matrix(q0)) == value,
                'direct original-window determinant')
        values.append(value)
    weights = data['bezout']
    require(len(weights) == 2 and all(type(x) is int for x in weights), 'integer weights')
    require(data['gcd'] == 18 and sum(a*b for a, b in zip(weights, values)) == 18,
            'Bezout identity equals 18')
    require(all(value % 18 == 0 for value in values), 'both determinants divisible by 18')
    return dict(determinants=values, gcd=18, direct_matrices=[114, 114],
                endpoint_inclusive=1156,
                conclusion='Every N=4 admissible prime has a transverse consecutive pair; '
                           'no proper fixed linear boundary envelope contains both rays.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--generate', action='store_true')
    parser.add_argument('--certificate', type=Path, default=DEFAULT)
    args = parser.parse_args()
    started = perf_counter()
    if args.generate:
        data = generate()
        result = verify(data)
        args.certificate.write_text(json.dumps(data, indent=2)+'\n')
    else:
        result = verify(json.loads(args.certificate.read_text()))
    print(json.dumps(dict(result=result, seconds=perf_counter()-started,
                          dependencies='Python standard library', seed=None), indent=2))


if __name__ == '__main__':
    main()
