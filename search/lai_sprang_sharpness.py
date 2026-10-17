"""Terminal witnesses showing the Lai--Sprang constant 2N is attained.

Run from the repository root:

    python3 -m search.lai_sprang_sharpness results/2026-10-17-sharpness.json
    python3 -m search.lai_sprang_sharpness results/2026-10-17-sharpness.json --verify

The ordinary argument is in results/2026-10-17-lai-sprang-sharpness.md.
A terminal window for S=(1+t+...+t^(N-1))V at shift M is a zero window of
length N+deg V for V in the derived stream b_v=c_v+...+c_(v+N-1). Its reverse
lift R=S(t^N), m=NM has exact defect 2N (5 October report).

Generation scans a complete all-shift cover with the Berlekamp--Massey linear
complexity profile: a jump of N+1 from complexity e is exactly a terminal
window at quotient degree e. Each witness V is the reversed connection
polynomial at an actual realizable shift. Readback recomputes original root
sums, the terminal rows, the lifted rows and endpoints without the generator,
its stream formula or the profile. Minimality below each witness is checked a
second way for p=5 by direct rank of every cover matrix, and for p=5,13 the
kernel is one-dimensional. The p=37,53 covers are too large for this Python
profile; search/run_terminal_cover.py runs them with an independent C
Euclidean implementation. Python standard library only; no seed.
"""
import argparse
import json
from pathlib import Path
import platform
from time import perf_counter

from search.run_rank_experiments import oracle


# p: (actual odd shift M, quotient degree e). For p<=53 each e is least over
# ALL shifts: Python covers below for p=5,13,29; the C cover for p=37,53.
# The p=61 witness is least over all shifts by the 18 October raksasa cover.
WITNESSES = {5: (311, 8), 13: (1465, 76), 29: (2501, 326),
             37: (19939, 1134), 53: (40193, 1128), 61: (22815, 2083)}
RECORDED = (5, 13, 29, 37, 53)
PYTHON_COVER = (5, 13, 29)
KERNEL_CHECK = (5, 13)


def v2(n):
    return (n & -n).bit_length() - 1


def normalized(N, n):
    """Lai--Sprang coefficient divided by N/2, as an integer in {0,1,-1}."""
    u = n // (n & -n)
    return 0 if (u - 1) % N else 1 - 2 * (((u - 1) // N) % 2)


def cover_parameters(N, E):
    """Windows for quotient degree <= E read c_(M+1),...,c_(M+T)."""
    T = 2 * N + 2 * E
    L = 1 << T.bit_length()  # smallest power of two exceeding T
    return T, L, N * L, 2 * E + N + 1


def cover_cases(N, E):
    """All (b,x): residue b modulo P=NL, value x at the one index divisible by L.

    For M=qP+b and an index b+i not divisible by L, adding qP=qNL changes the
    odd part by a multiple of 2N, so c is unchanged; T<L leaves at most one
    index divisible by L, whose actual value lies in {0,1,-1}.
    """
    T, L, P, _ = cover_parameters(N, E)
    for b in range(P):
        hole = any((b + i) % L == 0 for i in range(1, T + 1))
        for x in ((0, 1, -1) if hole else (None,)):
            yield b, x


def derived_window(N, E, b, x):
    T, L, _, length = cover_parameters(N, E)
    c = [0] + [x if x is not None and (b + i) % L == 0 else normalized(N, b + i)
               for i in range(1, T + 1)]
    return [sum(c[k:k + N]) for k in range(1, length + 1)]


def profile_jumps(s, p, stop_at=None):
    """Berlekamp--Massey over F_p. Returns (complexity before, jump size) pairs
    and the final complexity. The complexity profile takes exactly the
    continued-fraction denominator degrees as values. With stop_at=e, return
    instead the connection polynomial when complexity e is about to jump."""
    C, B = [1], [1]
    L, shift, last = 0, 1, 1
    jumps = []
    for n, value in enumerate(s):
        d = value % p
        for i in range(1, min(L, len(C) - 1) + 1):
            if C[i]:
                d = (d + C[i] * s[n - i]) % p
        if d == 0:
            shift += 1
            continue
        if stop_at is not None and L == stop_at and 2 * L <= n:
            return (C + [0] * (L + 1 - len(C)))[:L + 1], n + 1 - 2 * L
        coef = d * pow(last, p - 2, p) % p
        old = C[:]
        if len(C) < len(B) + shift:
            C.extend([0] * (len(B) + shift - len(C)))
        for i, y in enumerate(B):
            if y:
                C[i + shift] = (C[i + shift] - coef * y) % p
        if 2 * L <= n:
            jumps.append((L, n + 1 - 2 * L))
            L, B, last, shift = n + 1 - L, old, d, 1
        else:
            shift += 1
    if stop_at is not None:
        raise RuntimeError(('complexity never jumped from', stop_at))
    return jumps, L


def terminal_events(p, N, E, s):
    """Terminal windows with quotient degree <= E in one cover window.

    A profile still at complexity <= E after all 2E+N+1 terms would mean a
    jump of at least N+2 there; it is reported conservatively, never dropped.
    """
    jumps, final = profile_jumps(s, p)
    events = [(e, q) for e, q in jumps if e <= E and q >= N + 1]
    if final <= E:
        events.append((final, None))
    return events


def scan_cover(p, E):
    N = 1 << v2(p - 1)
    hits, cases = [], 0
    for b, x in cover_cases(N, E):
        cases += 1
        for e, q in terminal_events(p, N, E, derived_window(N, E, b, x)):
            hits.append(dict(b=b, x=x, e=e, jump=q))
    return dict(p=p, N=N, max_quotient_degree=E, cases=cases, hits=hits)


def kernel(rows, p):
    """Nullspace basis of an integer matrix modulo p."""
    rows = [[x % p for x in row] for row in rows]
    width, pivots, rank = len(rows[0]), [], 0
    for col in range(width):
        pivot = next((i for i in range(rank, len(rows)) if rows[i][col]), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        inverse = pow(rows[rank][col], p - 2, p)
        rows[rank] = [x * inverse % p for x in rows[rank]]
        for i in range(len(rows)):
            if i != rank and rows[i][col]:
                f = rows[i][col]
                rows[i] = [(x - f * y) % p for x, y in zip(rows[i], rows[rank])]
        pivots.append(col)
        rank += 1
    basis = []
    for free in (c for c in range(width) if c not in pivots):
        v = [0] * width
        v[free] = 1
        for i, col in enumerate(pivots):
            v[col] = -rows[i][free] % p
        basis.append(v)
    return basis


def terminal_matrix(p, M, e):
    N = 1 << v2(p - 1)
    b = lambda v: sum(normalized(N, v + i) for i in range(N))
    return [[b(M + k + j) for j in range(e + 1)] for k in range(1, N + e + 1)]


def polynomial_product(A, B, p):
    out = [0] * (len(A) + len(B) - 1)
    for i, x in enumerate(A):
        for j, y in enumerate(B):
            out[i + j] = (out[i + j] + x * y) % p
    return out


def witness(p):
    M, e = WITNESSES[p]
    N = 1 << v2(p - 1)
    s = [sum(normalized(N, M + k + i) for i in range(N))
         for k in range(1, 2 * e + N + 2)]
    C, jump = profile_jumps(s, p, stop_at=e)
    if jump != N + 1:
        raise RuntimeError(('expected a terminal jump', p, jump))
    V = C[::-1]  # rows sum_j V_j b_(M+k+j) are the recurrence at k+e
    kernel_dimension = None
    if p in KERNEL_CHECK:
        basis = kernel(terminal_matrix(p, M, e), p)
        kernel_dimension = len(basis)
        f = pow(basis[0][-1], p - 2, p) * V[-1] % p
        assert kernel_dimension == 1 and [x * f % p for x in basis[0]] == V
    S = polynomial_product([1] * N, V, p)
    D = len(S) - 1
    return dict(p=p, N=N, M=M, e=e, V=V, S=S, D=D, m=N * M, lifted_degree=N * D,
                j=N * (D + 2), defect=2 * N, kernel_dimension=kernel_dimension)


# Garrett--Robertson (arXiv:2405.14454v2) second-level paperfolding over F_5.
GR_WITNESS = dict(p=5, m=61, d=64, j=72)
GR_RULES = dict(A='AB', B='CD', C='EF', D='GD', E='AH', F='CI', G='EJ', H='CK',
                I='GI', J='CL', K='GK', L='GL')
GR_CODING = dict(A=0, B=0, C=1, D=0, E=2, F=1, G=3, H=2, I=1, J=3, K=2, L=3)


def paperfolding_level2(i):
    """Pi_i=((oddpart(i) mod 8)-1)/2, i>=1 (their Definition 1.3, n=2)."""
    u = i // (i & -i)
    return (u % 8 - 1) // 2


def garrett_robertson_witness():
    p, m, d, j = (GR_WITNESS[k] for k in ('p', 'm', 'd', 'j'))
    A = [[paperfolding_level2(m + k + i) for i in range(d + 1)]
         for k in range(1, j)]
    basis = kernel(A, p)
    if len(basis) != 1:
        raise RuntimeError(('expected a one-dimensional kernel', len(basis)))
    return dict(GR_WITNESS, R=basis[0], kernel_dimension=1)


def morphism_sequence(length):
    """Coding of the fixed point of their Example 4.1 morphism; u_k=Pi_(k+1)."""
    word = 'A'
    while len(word) < length:
        word = ''.join(GR_RULES[c] for c in word)
    return [GR_CODING[c] for c in word[:length]]


def verify_garrett_robertson(w):
    p, m, d, j, R = (w[k] for k in ('p', 'm', 'd', 'j', 'R'))
    assert len(R) == d + 1 and R[0] % p and R[-1] % p
    u = morphism_sequence(m + d + j + 1)  # independent of the oddpart formula
    values = [sum(r * u[m + i + k - 1] for i, r in enumerate(R)) % p
              for k in range(1, j + 1)]
    assert not any(values[:-1]) and values[-1]
    return dict(p=p, m=m, d=d, j=j, deficiency=j - d, value=values[-1])


def generate(cover_fields=PYTHON_COVER, witness_fields=RECORDED):
    started = perf_counter()
    witnesses = [witness(p) for p in witness_fields]
    covers = []
    for p in cover_fields:
        _, e = WITNESSES[p]
        t = perf_counter()
        below = scan_cover(p, e - 1)
        at = scan_cover(p, e)
        covers.append(dict(p=p, excluded_through=e - 1, cases_below=below['cases'],
                           hits_below=below['hits'], cases_at=at['cases'],
                           hits_at=at['hits'], runtime_seconds=perf_counter() - t))
    return dict(python=platform.python_version(), dependencies='standard library',
                seed=None, witnesses=witnesses, covers=covers,
                garrett_robertson=garrett_robertson_witness() if covers else None,
                runtime_seconds=perf_counter() - started)


def rows(p, poly, shift, count, scale=1):
    """Original root-sum rows sum_i poly_i a(shift+scale*i+k), k=1..count."""
    a = lambda n: oracle('lai_sprang', p, n)
    support = [(i, x) for i, x in enumerate(poly) if x % p]
    return [sum(x * a(shift + scale * i + k) for i, x in support) % p
            for k in range(1, count + 1)]


def verify_witness(w):
    p, N, M, V, S, D = (w[k] for k in ('p', 'N', 'M', 'V', 'S', 'D'))
    assert 1 << v2(p - 1) == N and N >= 4 and M % 2 == 1
    assert len(V) == w['e'] + 1 and V[-1] % p and len(S) == D + 1 == N + w['e']
    # Independent division: S/(1+...+t^(N-1)) reproduces V with no remainder.
    remainder, quotient = list(S), [0] * len(V)
    for i in range(len(remainder) - 1, N - 2, -1):
        q = remainder[i] % p
        quotient[i - N + 1] = q
        for k in range(N):
            remainder[i - k] = (remainder[i - k] - q) % p
    assert quotient == [x % p for x in V] and not any(remainder)
    assert S[0] % p and S[-1] % p
    terminal = rows(p, S, M, D + 2)
    assert not any(terminal[:-1]) and terminal[-1], 'terminal window'
    # Lift R=S(t^N) at m=NM. Rows not divisible by N vanish; N*k reproduces k.
    m, j = w['m'], w['j']
    assert m == N * M and j == N * (D + 2) and w['lifted_degree'] == N * D
    lifted = rows(p, S, m, j, scale=N)
    assert not any(lifted[:-1]) and lifted[-1] == terminal[-1], 'lifted index'
    assert j - N * D == 2 * N == w['defect']
    return dict(p=p, N=N, M=M, e=w['e'], terminal_value=terminal[-1],
                lifted_degree=N * D, m=m, j=j, defect=j - N * D,
                largest_original_index=m + N * D + j)


def direct_rank_exclusion(p, E):
    """Second method for small E: no cover matrix has a kernel below E,
    using nullspace computation rather than the complexity profile."""
    N = 1 << v2(p - 1)
    T, L, _, _ = cover_parameters(N, E)
    kernels = []
    for b, x in cover_cases(N, E):
        c = [0] + [x if x is not None and (b + i) % L == 0 else normalized(N, b + i)
                   for i in range(1, T + 1)]
        for e in range(E + 1):
            A = [[sum(c[k + j:k + j + N]) for j in range(e + 1)]
                 for k in range(1, N + e + 1)]
            if kernel(A, p):
                kernels.append((b, x, e))
    return kernels


def verify(data):
    started = perf_counter()
    assert all(WITNESSES[w['p']] == (w['M'], w['e']) for w in data['witnesses'])
    witnesses = [verify_witness(w) for w in data['witnesses']]
    covers = []
    for cover in data['covers']:
        p = cover['p']
        M, e = WITNESSES[p]
        assert cover['excluded_through'] == e - 1 and not cover['hits_below']
        N = 1 << v2(p - 1)
        _, _, P, _ = cover_parameters(N, e)
        # The actual witness shift must appear among the cover hits at e.
        assert any(h['b'] == M % P and h['e'] == e for h in cover['hits_at'])
        covers.append(dict(p=p, excluded_through=e - 1, cases=cover['cases_below']))
    result = dict(witnesses=witnesses, covers=covers)
    if data['covers']:
        p5 = direct_rank_exclusion(5, 8)
        assert {(b, e) for b, _, e in p5} == {(55, 8), (119, 8)}
        result['p5_direct_rank_kernels'] = p5
        result['garrett_robertson'] = verify_garrett_robertson(data['garrett_robertson'])
    result['runtime_seconds'] = perf_counter() - started
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', type=Path)
    parser.add_argument('--verify', action='store_true')
    parser.add_argument('--witness', type=int, action='append',
                        help='generate only these witnesses, without covers')
    args = parser.parse_args()
    if args.verify:
        print(json.dumps(verify(json.loads(args.path.read_text())), indent=2))
        return
    if args.path.exists():
        raise SystemExit(f'refusing to overwrite {args.path}')
    data = generate((), tuple(args.witness)) if args.witness else generate()
    args.path.write_text(json.dumps(data, separators=(',', ':')) + '\n')
    print(json.dumps(dict(witnesses=[(w['p'], w['lifted_degree'], w['m'], w['j'])
                                     for w in data['witnesses']],
                          covers=[(c['p'], c['excluded_through'], c['cases_below'])
                                  for c in data['covers']],
                          runtime_seconds=data['runtime_seconds'])))


if __name__ == '__main__':
    main()
