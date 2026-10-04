"""Exact checks for the 5 October terminal lift, not a counterexample search.

Run python3 -m search.terminal_lift_check. All-scale claims are proved in the
accompanying report. Original coefficients are independently expanded from roots.
"""
import json
import platform
from time import perf_counter

from search.lai_sprang_descent_check import multiply
from search.lai_sprang_finite_search import coeff, v2
from search.run_rank_experiments import oracle


def run():
    started = perf_counter()
    vectors = [(1,), (0, 1), (1, 2), (1, 0, 2, 1), (1, 1, 0, 0, 1)]
    fields = []
    checks = 0
    controls = []
    for p in (3, 5, 13, 41, 17):
        r = v2(p-1)
        N, H = 1 << r, 1 << (r-1)
        end = 4*N+1+N*(N+3)
        original = [0]+[oracle('lai_sprang', p, n) for n in range(1, end+1)]
        assert all(original[n] == coeff(p, n) for n in range(1, end+1))
        count = 0
        for V in vectors:
            S = multiply([1]*N, V, p)
            for i in range(r+1):
                L = 1 << i
                for n in range(1, 4*N+2):
                    left = sum(x*original[n+L*k] for k, x in enumerate(S)) % p
                    right = (sum(x*coeff(p, n//L+k) for k, x in enumerate(S)) % p
                             if n % L == 0 else 0)
                    assert left == right, (p, V, i, n)
                    count += 1
        fields.append(dict(p=p, N=N, dilation_exponents=[0, r],
                           absolute_row_range=[1, 4*N+1],
                           lift_identity_endpoint=end,
                           inclusive_original_endpoint=max(end, 1+2*N*(N-1)),
                           checks=count))
        checks += count
        # The first omitted scale fails: S(t^(2N)) at row 1 equals H*S(1).
        over_scale = sum(oracle('lai_sprang', p, 1+2*N*k) for k in range(N)) % p
        assert over_scale == H*N % p and over_scale != 0
        # A smaller geometric factor omits the -1 root and fails at scale N.
        partial = [int(k % 2 == 0) for k in range(N-1)]
        missing_factor = sum(x*original[1+N*k] for k, x in enumerate(partial)) % p
        assert missing_factor == H*H % p and missing_factor != 0
        # No geometric factor at all: the odd row of 1(t^2) does not vanish.
        assert original[1] == H % p and original[1] != 0
        controls.append(dict(p=p, beyond_scale_nonzero=over_scale,
                             missing_factor_nonzero=missing_factor))
    # Retain the actual r=1 terminal failure and its exact reverse lift.
    terminal = [sum(oracle('lai_sprang', 3, 1+k+i) for i in (0, 1)) % 3
                for k in range(1, 4)]
    lifted = [sum(oracle('lai_sprang', 3, 2+k+i) for i in (0, 2)) % 3
              for k in range(1, 7)]
    assert terminal == [0, 0, 2]
    assert lifted == [0, 0, 0, 0, 0, 2]
    # Minimal-counterexample reduction budgets; no false-premise implication
    # is counted as a checked stream counterexample.
    budgets = []
    for e in range(8):
        d = 3+e  # N=4; the counts depend only on d parity.
        q, eps = divmod(d, 2)
        for delta in (0, 1):
            A, B = (d+1+delta)//2, (d+2-delta)//2
            if eps:
                assert B >= q+1
            elif delta:
                assert A >= q+1
            else:
                assert A == q and B == q+1
            budgets.append([e, delta, A, B])
    return dict(python=platform.python_version(), seed=None,
                scope='prescribed identity and boundary checks; no optimiser or search',
                quotient_vectors=vectors, fields=fields, identity_checks=checks,
                negative_controls=controls, r1_terminal_rows=terminal,
                r1_lifted_rows=lifted, row_budgets=budgets,
                runtime_seconds=perf_counter()-started)


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
