"""Exact F_2 polynomial residuals modulo x^M, never an infinite identity proof.

Coefficients are in ascending order and include index zero. This screening
primitive tests a supplied relation A(x)Y^2+B(x)Y+C(x), not all relations.
The fixed baseline experiment has independent recurrence/convolution readback.
"""
import argparse
from hashlib import sha256
import json
from pathlib import Path
import platform
from time import perf_counter

from search.run_rank_experiments import oracle, stream


# Merta 1810.03533v3, equations (2) and (8); paperfolding's repository
# convention is derived separately in the 27 September integration report.
RELATIONS = {
    'thue_morse': ((1, 1, 1, 1), (1, 0, 1), (0, 1)),
    'paperfolding': ((1, 0, 0, 0, 1), (1, 0, 0, 0, 1), (0, 1)),
    'rudin_shapiro': ((1, 1, 0, 0, 1, 1), (1, 0, 0, 0, 1), (0, 0, 0, 1)),
}
PRECISION = 1024
CASES = ('thue_morse', 'paperfolding', 'rudin_shapiro',
         'rudin_shapiro_complement', 'signed_rudin_shapiro_mod2')


def quadratic_residual(prefix, A, B, C):
    """Return exactly coefficients 0,...,M-1; tail beyond M-1 is unused.

    Zero residual means only congruence modulo x^M. A nonzero residual
    disproves this particular supplied identity for every extension of prefix.
    """
    if not prefix or not A or not B or not C:
        raise ValueError('prefix and polynomial vectors must be nonempty')
    if any(type(v) is not int or v not in (0, 1)
           for values in (prefix, A, B, C) for v in values):
        raise ValueError('coefficients must be canonical F_2 integers')
    if not any(A) and not any(B):
        raise ValueError('relation must depend on Y')
    M = len(prefix)
    residual = [0] * M
    # Frobenius: Y(x)^2=Y(x^2). Independent readback uses full convolution.
    for polynomial, dilation in ((A, 2), (B, 1)):
        for shift, value in enumerate(polynomial):
            if value:
                for n in range(max(0, (M-1-shift)//dilation + 1)):
                    residual[shift+dilation*n] ^= prefix[n]
    for n, value in enumerate(C[:M]):
        residual[n] ^= value
    return residual


def _prefix(case, generator):
    if case == 'signed_rudin_shapiro_mod2':
        return [1] * PRECISION
    name = 'rudin_shapiro' if case.endswith('_complement') else case
    # Paperfolding's experimental generator is defined only at positive n.
    values = [0] + [generator(name, 2, n) for n in range(1, PRECISION)]
    return [1-v for v in values] if case.endswith('_complement') else values


def _relation(case):
    return RELATIONS[case if case in RELATIONS else 'rudin_shapiro']


def _record(case, prefix, residual):
    A, B, C = _relation(case)
    return dict(case=case, precision=PRECISION, A=list(A), B=list(B), C=list(C),
                prefix_sha256=sha256(bytes(prefix)).hexdigest(),
                residual_sha256=sha256(bytes(residual)).hexdigest(),
                first_nonzero_residual=next((n for n, v in enumerate(residual) if v), None),
                zero_mod_x_power=not any(residual), infinite_identity_proved_by_check=False)


def convolution_residual(prefix, A, B, C):
    """Independent finite ring arithmetic: ordinary Cauchy square, no Frobenius."""
    M = len(prefix)
    square = [sum(prefix[i]*prefix[n-i] for i in range(n+1)) % 2
              for n in range(M)]
    return [(sum(A[i]*square[n-i] for i in range(min(n+1, len(A)))) +
             sum(B[i]*prefix[n-i] for i in range(min(n+1, len(B)))) +
             (C[n] if n < len(C) else 0)) % 2 for n in range(M)]


def verify(data):
    """Check the complete prescribed cases without the generator/fast residual."""
    started = perf_counter()
    rows = data['records']
    if len(rows) != len(CASES) or [row['case'] for row in rows] != list(CASES):
        raise ValueError('missing, duplicate or unexpected screening cases')
    for row in rows:
        case = row['case']
        prefix = _prefix(case, oracle)
        residual = convolution_residual(prefix, *_relation(case))
        if row != _record(case, prefix, residual):
            raise ValueError('incorrect finite screening record: ' + case)
        expected = 3 if case == 'signed_rudin_shapiro_mod2' else None
        if row['first_nonzero_residual'] != expected:
            raise ValueError('baseline relation or encoding changed: ' + case)
    return dict(records_verified=len(rows), coefficients_per_record=PRECISION,
                runtime_seconds=perf_counter()-started)


def run(path):
    started = perf_counter()
    records = []
    for case in CASES:
        prefix = _prefix(case, stream)
        records.append(_record(case, prefix, quadratic_residual(prefix, *_relation(case))))
    data = dict(python=platform.python_version(), seed=None, records=records,
                runtime_seconds=perf_counter()-started)
    data['independent_readback'] = verify(data)
    with path.open('x') as output:
        json.dump(data, output, indent=2)
        output.write('\n')
    return data['independent_readback']


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', type=Path)
    parser.add_argument('--verify', action='store_true')
    args = parser.parse_args()
    print(json.dumps(verify(json.loads(args.path.read_text())) if args.verify
                     else run(args.path), indent=2))
