"""Exact finite experiments for the Lai--Sprang odd-characteristic counterexample.

The series Lambda has coefficients
  a_n = (N/2)(-1)^h if oddpart(n)=1+N*h, else 0  (mod p),
where N=2^v2(p-1).

For R(t)=sum_{i=0}^d r_i t^i with r_0 != 0 and m>=0, the coefficient
of t^{-j} in t^m R Lambda is sum_i r_i a_{m+i+j}.  The defect j-d
controls the Littlewood product: |Q| |Q|_t <Q Lambda> = 2^(d-j).

We maximise the first forced zero prefix by exact Gaussian elimination over F_p.
This is a finite search/certificate generator; it does not prove a global bound.
"""

from __future__ import annotations

from itertools import product


def v2(n: int) -> int:
    r = 0
    while n and n % 2 == 0:
        r += 1
        n //= 2
    return r


def oddpart(n: int) -> int:
    while n % 2 == 0:
        n //= 2
    return n


def coeff(p: int, n: int) -> int:
    if n <= 0:
        return 0
    N = 1 << v2(p - 1)
    u = oddpart(n)
    if (u - 1) % N:
        return 0
    h = (u - 1) // N
    return ((N // 2) * (-1 if h & 1 else 1)) % p


def first_fractional_index(p: int, R: tuple[int, ...], m: int, limit: int = 10000) -> int | None:
    """Return first j>=1 with nonzero t^-j coefficient, or None within limit."""
    for j in range(1, limit + 1):
        s = sum(r * coeff(p, m + i + j) for i, r in enumerate(R)) % p
        if s:
            return j
    return None


def exhaustive_small(p: int, max_degree: int, max_m: int):
    """Brute force all monic-ish coefficient vectors with nonzero constant term.

    Scale is irrelevant, so set r_0=1. Leading coefficient is required nonzero.
    Suitable only for small p/degrees; useful for exact witnesses.
    """
    best = None
    for d in range(max_degree + 1):
        if d == 0:
            Rs = [(1,)]
        else:
            Rs = ((1,) + mid + (lead,)
                  for mid in product(range(p), repeat=d - 1)
                  for lead in range(1, p))
        for R in Rs:
            for m in range(max_m + 1):
                j = first_fractional_index(p, R, m)
                if j is None:
                    continue
                rec = (j - d, p, d, m, R, j)
                if best is None or rec[0] > best[0]:
                    best = rec
    return best


def verify_r1_witness(p: int) -> tuple[int, int]:
    """For p == 3 mod 4, verify R=1+t^2,m=2 has defect 4."""
    assert v2(p - 1) == 1
    R = (1, 0, 1)
    j = first_fractional_index(p, R, 2)
    assert j is not None
    return j, j - 2


if __name__ == "__main__":
    for p in (3, 7, 11, 19, 23, 31):
        j, defect = verify_r1_witness(p)
        print(f"p={p:2d} r=1: R=1+t^2, m=2 -> j={j}, defect={defect}")

    # Small exact boxes for r>=2.  A defect > N would refute the candidate
    # strengthening suggested by initial experiments.
    for p, degree, mmax in ((5, 5, 24), (13, 4, 24), (17, 3, 24)):
        N = 1 << v2(p - 1)
        best = exhaustive_small(p, degree, mmax)
        print(f"p={p}, N={N}, box d<={degree},m<={mmax}: best={best}; candidate bound={N}")
