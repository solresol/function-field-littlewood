"""Full integral compatibility for the prescribed repeated (1,1) block.

Proof, scope and specialization argument:
results/2026-11-15-fraction-free-integration.md. This is a division-free
implementation of the existing boundary recurrence, not an accepting-word
theorem. No normalization or content division is permitted in propagation.
The executable checks ONLY the already studied lengths 0,1,2, plus existing
accepted/rejected semantic controls. No search, Smith form or dependency.
"""
from functools import lru_cache, reduce
from math import gcd
from time import perf_counter
import json


COMPONENTS = tuple((d, i, j) for d in (0, 1) for i in (0, 1) for j in (0, 1))


def wedge(A, B):
    out = {}
    for a, x in A.items():
        for b, y in B.items():
            if a & b:
                continue
            sign, c = 1, a
            while c:
                bit = c & -c
                if (b & (bit-1)).bit_count() % 2:
                    sign = -sign
                c -= bit
            out[a | b] = out.get(a | b, 0) + sign*x*y
    return {a: x for a, x in out.items() if x}


def row_form(row):
    return {1 << j: x for j, x in enumerate(row) if x}


def rows_form(rows):
    out = {0: 1}
    for row in rows:
        out = wedge(out, row_form(row))
    return out


def eliminate(form, first, count):
    interior = ((1 << count)-1) << first
    return {mask ^ interior: x for mask, x in form.items()
            if mask & interior == interior}


def seed(N, q, k, coefficients):
    """Eliminate the polynomial coefficients from the actual finite window.

    Boundary order is (periodic forcing f, residue sums s); the internal
    polynomial vector is last. The inclusive endpoint for the whole tuple
    is q+2*k+2. This seed construction is used at fixed small input only.
    """
    result = []
    for d, i, j in COMPONENTS:
        m, n, t = k+i, k+j, q+1+d
        rows = [[-int(a == h % N) for a in range(N)] + [0]*N
                + [coefficients[t+h+ell] for ell in range(n)] for h in range(m)]
        rows += [[0]*N + [-int(a == ell) for a in range(N)]
                 + [int(b % N == ell) for b in range(n)] for ell in range(N)]
        result.append(eliminate(rows_form(rows), 2*N, n))
    return tuple(result)


@lru_cache(None)
def maps(N, t, a):
    """Pullback child (f,s) to parent (f,s,w), using a unimodular split."""
    H = N//2
    b = (t+a) % 2
    other = 1-b
    h = (t+a+other-1)//2
    s = []
    for parity in (0, 1):
        for j in range(N):
            row = [0]*(3*N)
            if j < H:
                row[N+2*j+parity] = 1
                row[2*N+parity*H+j] = -1
            else:
                row[2*N+parity*H+j-H] = 1
            s.append(row)
    out = []
    alpha = lambda u: (0 if u % H else (-1)**((u//H) % 2))
    for i in range(N):
        row = [0]*(3*N)
        row[(2*i+a) % N] = 1
        for j in range(N):
            row = [x-alpha((h+i+j) % N)*y for x, y in zip(row, s[other*N+j])]
        out.append(row)
    out += s[b*N:(b+1)*N]
    return tuple(tuple(row) for row in out)


@lru_cache(None)
def mask_pullback(N, t, a, mask):
    rows = maps(N, t, a)
    return rows_form([row for j, row in enumerate(rows) if mask >> j & 1])


def pullback(form, N, t, a):
    out = {}
    for mask, x in form.items():
        for b, y in mask_pullback(N, t, a, mask).items():
            out[b] = out.get(b, 0) + x*y
    return {a: x for a, x in out.items() if x}


def merge(A, B, N, t):
    return eliminate(wedge(pullback(A, N, t, 0), pullback(B, N, t, 1)), 2*N, N)


def step(state, N, phase):
    """Only digit (1,1), retaining the full jointly realized eight-tuple."""
    out = []
    for d, i, j in COMPONENTS:
        children = []
        for a in (0, 1):
            b = (2+d+a) % 2
            delta, ri, cj = (1+d+a)//2, (i+2-a)//2, (j+2-b)//2
            children.append(state[4*delta+2*ri+cj])
        out.append(merge(*children, N, (2*phase+2+d) % (2*N)))
    return tuple(out), (2*phase+1) % N


def residual(form, N):
    """Interior product with (f=0,s=(1,...,1)); all coordinates retained."""
    out = {}
    for mask, x in form.items():
        for j in range(N, 2*N):
            if mask >> j & 1:
                b = mask ^ (1 << j)
                sign = (-1)**((mask & ((1 << j)-1)).bit_count())
                out[b] = out.get(b, 0) + sign*x
    return {a: x for a, x in out.items() if x}


def check_form(form, N, q, k, component, p):
    """Compare the whole annihilator plane with original-root-sum relations."""
    from search.terminal_boundary_relation import BoundaryRelations, null
    E = BoundaryRelations(p)
    assert E.N == N
    d, i, j = component
    direct, invisible = E.direct(q+1+d, k+i, k+j)
    assert not invisible
    basis = []
    for v in direct:
        f = [sum(pow(z, a, p)*v[ell] for ell, z in enumerate(E.roots)) % p
             for a in range(N)]
        s = [sum(pow(z, (-a) % N, p)*v[N+ell]
                 for ell, z in enumerate(E.roots))*pow(N, -1, p) % p for a in range(N)]
        basis.append(f+s)
    expected = {mask: x % p for mask, x in rows_form(null(basis, 2*N, p)).items() if x % p}
    actual = {mask: x % p for mask, x in form.items() if x % p}
    assert actual and expected
    pivot = next(iter(expected))
    factor = actual.get(pivot, 0)*pow(expected[pivot], -1, p) % p
    assert factor and actual == {mask: x*factor % p for mask, x in expected.items()}


def run():
    from search.terminal_prime_obstruction import formal_series
    started = perf_counter()
    records = []
    N = 4
    for q in (62, 126):
        k, phase = 8, q % N
        state = seed(N, q, k, formal_series(N, q+2*k+2))
        for m in range(3):
            for p in (5, 13):
                for component, form in zip(COMPONENTS, state):
                    check_form(form, N, q, k, component, p)
            records.append(dict(m=m, q=q, k=k,
                                content=[reduce(gcd, f.values(), 0) for f in state],
                                residual_gcd=reduce(gcd, residual(state[0], N).values(), 0),
                                bits=max(abs(x).bit_length() for f in state for x in f.values())))
            if m < 2:
                state, phase = step(state, N, phase)
                q, k = 2*q+1, 2*k+1
    # Necessary accepted/rejected controls from existing evidence, no new lengths.
    for N, p, q, k, accepted in ((2, 3, 1, 2, True), (4, 5, 311, 12, True),
                                 (4, 5, 313, 12, False)):
        state = seed(N, q, k, formal_series(N, q+2*k+2))
        check_form(state[0], N, q, k, (0, 0, 0), p)
        assert (not any(x % p for x in residual(state[0], N).values())) == accepted
    return dict(records=records, whole_relation_comparisons=96,
                original_coefficient_endpoint_inclusive=579,
                existing_terminal_controls=3, python_dependencies='standard library',
                seed=None, scope='identity controls at pre-existing lengths; no all-length decision',
                seconds=perf_counter()-started)


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
