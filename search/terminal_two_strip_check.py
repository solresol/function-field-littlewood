"""Exact checks for the uniform two-residue localization proof (16 October).

Checks identities in the EXISTING N=8,16 abstract covers. No larger rank
search. Independent coefficients come from the integer formal series and all
row identities are read back from original F rows. See the dated proof.
"""
from collections import Counter
import json
import platform
from time import perf_counter

from search.terminal_prime_obstruction import cases, formal_series, parameters


def strip(N, M):
    """Return the proof branch, distinguished boundary B, and offset z."""
    if N < 8 or N & (N-1) or M < 0 or M % 2 != 1:
        raise ValueError('require dyadic N>=8 and a positive odd shift')
    H = N//2
    q = (M+H)//N
    if q % H not in (0, H-1):
        return 'old_gap', None, None
    K = q if q % H == 0 else q+1
    B, z = K*N, M-K*N
    assert -3*H+1 <= z <= H-1
    if z <= -2*H-1:
        branch = 'antiperiodic'
    elif z == -2*H+1 or z == -H+1:
        branch = 'remaining'
    elif z <= -H-1:
        branch = 'two_rows'
    else:
        branch = 'next_gap'
    return branch, B, z


def run():
    start = perf_counter()
    summaries = []
    for N in (8, 16):
        H, _, T, L, period = parameters(N)
        a = formal_series(N, period-1+T)
        counts = Counter()
        for M, x in cases(N):
            if M % 2 == 0:
                continue
            branch, B, z = strip(N, M)
            counts[branch] += 1
            if branch == 'old_gap':
                continue

            def source(n):
                assert M+1 <= n <= M+T
                return x if n % L == 0 else a[n]

            A = [[sum(source(M+k+j+i) for i in range(N))
                  for j in range(H+1)] for k in range(1, 3*H+1)]
            D = [[b-a for a, b in zip(row, nxt)]
                 for row, nxt in zip(A, A[1:])]
            # E_k = D_k + D_(k+N), k=1,...,H-1. Its columns
            # telescope to c_(M+k+j+2N)-c_(M+k+j).
            E = [[a+b for a, b in zip(D[k-1], D[k+N-1])]
                 for k in range(1, H)]
            assert E == [[source(M+k+j+2*N)-source(M+k+j)
                          for j in range(H+1)] for k in range(1, H)]
            if branch == 'antiperiodic':
                alpha = source(B+N)-source(B-N)
                assert E == [[alpha if M+k+j == B-N else 0
                              for j in range(H+1)] for k in range(1, H)]
                k = B-N-M
                assert 1 <= k <= H-1 and E[k-1][0] == alpha
                assert all(v == 0 for v in E[k-1][1:])
                if alpha == 0:
                    def delta(n):
                        return source(n+N)-source(n)
                    sigma = delta(B-H)
                    assert sigma in (-1, 1)
                    f = [delta(B-N+i) for i in range(N)]
                    expected = [0]*N
                    expected[0], expected[1], expected[H] = f[0], 2, sigma
                    power = 2
                    while power < H:
                        expected[power] = 1
                        power *= 2
                    assert f == expected
                    # Explicit reflection product: its x^6 coefficient cannot
                    # vanish in odd characteristic, independently of f[0].
                    product6 = sum(f[i]*f[6-i]*(-1)**(6-i)
                                   for i in range(7) if i < N and 6-i < N)
                    assert product6 == (2*sigma if H == 4 else 2)
                    assert all(not any(row) for row in E)
                    # Check the convolution bridge on every basis vector:
                    # W=x^(H-j), then coefficient i+H of W*f is D[k,j],
                    # interpreting both sides antiperiodically modulo x^N+1.
                    for j in range(H+1):
                        remainder = [0]*N
                        for i, value in enumerate(f):
                            exponent = i+H-j
                            remainder[exponent % N] += value*(-1)**(exponent//N)
                        for k in range(1, N+1):
                            lifted = M+k-(B-N)+H
                            value = remainder[lifted % N]*(-1)**(lifted//N)
                            assert value == D[k-1][j]
            elif branch == 'two_rows':
                k0, k2 = -H-z, 2-H-z
                assert 1 <= k0 < k2 <= H-1
                beta = source(B+2*N)-source(B)
                expected0 = [0]*H+[beta]
                expected2 = [0]*(H-2)+[beta, 0, -2]
                assert E[k0-1] == expected0
                assert E[k2-1] == expected2
            elif branch == 'next_gap':
                t = B+N+2
                first, last = t-M-H, t-M
                assert 1 <= first <= last <= 3*H-1
                square = D[first-1:last]
                assert len(square) == H+1
                assert all(square[i][H-i] == -1 for i in range(H+1))
                assert all(square[i][j] == 0 for i in range(H+1)
                           for j in range(H+1) if i+j > H)
            else:
                assert M % (N*H) in ((1-N) % (N*H), (1-H) % (N*H))
        summaries.append(dict(N=N, e=H, counts=dict(sorted(counts.items())),
                              remaining_residues=[(1-N) % (N*H), (1-H) % (N*H)],
                              modulus=N*H))
    return dict(python=platform.python_version(), dependencies='standard library',
                seed=None, scope='identities in existing abstract covers; proof is ordinary',
                scales=summaries, runtime_seconds=perf_counter()-start)


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
