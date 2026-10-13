"""Check the ordinary dyadic-gap lemma, not a search for larger rank boxes.

Proof: results/2026-10-14-dyadic-gap.md. Only previously studied scales are
used. The constructive minor uses support coefficients; readback uses the
independent integer formal series and original F rows, with exact determinants.
"""
import json
import platform
from collections import Counter
from time import perf_counter

from search.terminal_prime_obstruction import (
    cases, formal_series, normalized_coefficient, parameters,
    rational_determinant,
)


def gap_minor(N, e, M, source):
    """Return consecutive difference-row indices, or None outside the lemma.

    source(n) is the normalized integer coefficient c_n. Returning None says
    only that e+u>=N; it is never a rank-deficiency or terminal-window claim.
    Rows are one-based in A[k,j]=B_(t^j F)(M+k), 1<=k<=N+e.
    """
    if N < 4 or N & (N-1) or e < 0 or M < 0:
        raise ValueError('require dyadic N>=4 and nonnegative degree and shift')
    q, s = divmod(M+e, N)
    even = q if q % 2 == 0 else q+1
    u = min(even & -even, N//2) if even else N//2
    if e+u >= N:
        return None
    if s < u:
        t, side = q*N+u, 'after'
    else:
        t, side = (q+1)*N, 'before'
        if source(t+N) == source(t):
            t += 1
    pivot = source(t+N)-source(t)
    return dict(q=q, u=u, t=t, side=side, pivot=pivot,
                first_row=t-M-e, last_row=t-M)


def check_minor(N, e, M, witness, source):
    """Read back actual original rows; no reliance on the pivot selector."""
    first, last = witness['first_row'], witness['last_row']
    assert 1 <= first <= last <= N+e-1
    assert last-first == e
    assert witness['t'] == M+last
    rows = [[sum(source(M+k+j+i) for i in range(N))
             for j in range(e+1)] for k in range(first, last+2)]
    delta = [[b-a for a, b in zip(row, nxt)]
             for row, nxt in zip(rows, rows[1:])]
    pivot = witness['pivot']
    assert pivot in (-2, -1, 1, 2)
    assert all(delta[i][e-i] == pivot for i in range(e+1))
    assert witness['side'] in ('before', 'after')
    assert all(delta[i][j] == 0 for i in range(e+1) for j in range(e+1)
               if (i+j < e if witness['side'] == 'before' else i+j > e))
    expected = (-1)**(e*(e+1)//2) * pivot**(e+1)
    assert rational_determinant(delta) == expected
    return expected


def run():
    start = perf_counter()
    summaries = []
    for N in (4, 8, 16):
        H, _, T, L, period = parameters(N)
        coefficients = formal_series(N, period-1+T)
        checked, residual, pivots = 0, 0, Counter()
        for M, x in cases(N):
            def source(n):
                return x if n % L == 0 else normalized_coefficient(N, n)

            def independent(n):
                assert M+1 <= n <= M+T
                return x if n % L == 0 else coefficients[n]

            witness = gap_minor(N, H, M, source)
            exceptional = ((M+H)//N) % H in (0, H-1)
            assert (witness is None) == exceptional
            if witness is None:
                residual += 1
            else:
                check_minor(N, H, M, witness, independent)
                checked += 1
                pivots[witness['pivot']] += 1
        # Test the general degree inequality at exact endpoints, on actual
        # streams (no cover theorem is claimed for these additional degrees).
        degree_controls = 0
        degrees = sorted({0, H-1, H, 3*N//4-1, N-2, N-1})
        a = formal_series(N, 3*N-1 + 2*N + 2*max(degrees)-1)
        for e in degrees:
            for M in range(3*N):
                witness = gap_minor(N, e, M, lambda n: normalized_coefficient(N, n))
                if witness is not None:
                    check_minor(N, e, M, witness, a.__getitem__)
                    degree_controls += 1
        summaries.append(dict(N=N, e=H, complete_cover_cases=checked+residual,
                              constructive_minors=checked, residual_cases=residual,
                              pivots=dict(sorted(pivots.items())),
                              degree_control_inputs=dict(degrees=degrees, M=[0, 3*N-1]),
                              degree_controls_checked=degree_controls))

    # Actual stream obstruction to extending this particular triangular-gap
    # argument to every shift, not a failure of full rank or of the N-bound.
    N, e, M = 8, 4, 21
    a = formal_series(N, M+2*N+2*e-1)
    d = [a[n+N]-a[n] for n in range(M+1, M+N+2*e)]
    assert gap_minor(N, e, M, a.__getitem__) is None
    possible_pivots = range(M+e+1, M+N+e)
    assert not any(a[t+N] != a[t] and
                   (all(a[n+N] == a[n] for n in range(t-e, t)) or
                    all(a[n+N] == a[n] for n in range(t+1, t+e+1)))
                   for t in possible_pivots)
    # Full rank is independently certified by this original-row minor.
    rows = [1, 2, 3, 4, 5]
    A = [[sum(a[M+k+j+i] for i in range(N)) for j in range(e+1)] for k in rows]
    determinant = rational_determinant(A)
    # A nonzero integer determinant alone need not work in every characteristic.
    assert determinant % 41 != 0
    return dict(python=platform.python_version(), dependencies='standard library',
                seed=None, scales=summaries,
                gap_failure_control=dict(N=N, e=e, M=M, differences=d,
                                         original_minor_rows=rows,
                                         original_minor_determinant=determinant),
                runtime_seconds=perf_counter()-start)


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
