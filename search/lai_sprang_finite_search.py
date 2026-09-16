"""Exact finite experiments for the Lai--Sprang odd-characteristic counterexample.

The series Lambda has coefficients
  a_n = (N/2)(-1)^h if oddpart(n)=1+N*h, else 0  (mod p),
where N=2^v2(p-1).

For R(t)=sum_{i=0}^d r_i t^i with r_0 != 0 and m>=0, the coefficient
of t^{-j} in t^m R Lambda is sum_i r_i a_{m+i+j}.  The defect j-d
controls the Littlewood product: |Q| |Q|_t <Q Lambda> = 2^(d-j).

We enumerate normalised coefficient vectors over F_p (no rank solver yet).
A cutoff without a nonzero coefficient is unresolved, never an exact index.
This finite search does not prove a global bound.
"""

from __future__ import annotations

from itertools import product
from dataclasses import asdict, dataclass
from functools import lru_cache
from math import isqrt
import json
import platform
from time import perf_counter


@lru_cache(maxsize=None)
def validate_prime(p: int) -> None:
    """The Lai--Sprang coefficient formula here requires an odd prime."""
    if p < 3 or p % 2 == 0 or any(p % k == 0 for k in range(3, isqrt(p) + 1, 2)):
        raise ValueError("p must be an odd prime")


def v2(n: int) -> int:
    if n <= 0:
        raise ValueError("v2 requires a positive integer")
    r = 0
    while n and n % 2 == 0:
        r += 1
        n //= 2
    return r


def oddpart(n: int) -> int:
    if n <= 0:
        raise ValueError("oddpart requires a positive integer")
    while n % 2 == 0:
        n //= 2
    return n


def coeff(p: int, n: int) -> int:
    validate_prime(p)
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
    validate_prime(p)
    if m < 0 or limit < 1:
        raise ValueError("m must be nonnegative and limit positive")
    if not R or R[0] % p == 0 or R[-1] % p == 0:
        raise ValueError("R must have nonzero constant and leading coefficients")
    for j in range(1, limit + 1):
        s = sum(r * coeff(p, m + i + j) for i, r in enumerate(R)) % p
        if s:
            return j
    return None


@dataclass(frozen=True)
class SearchResult:
    # best is (defect, p, degree, m, R, j), among resolved inputs only.
    best: tuple | None
    checked: int
    unresolved: int
    first_unresolved: tuple | None
    limit: int


def exhaustive_small(p: int, max_degree: int, max_m: int, limit: int = 10000) -> SearchResult:
    """Brute force all normalised coefficient vectors with nonzero constant term.

    Scale is irrelevant, so set r_0=1. Leading coefficient is required nonzero.
    Suitable only for small p/degrees; useful for exact witnesses.
    No bound on the full box is certified if unresolved is nonzero.
    """
    validate_prime(p)
    if max_degree < 0 or max_m < 0 or limit < 1:
        raise ValueError("degrees/shifts must be nonnegative and limit positive")
    best = None
    checked = unresolved = 0
    first_unresolved = None
    for d in range(max_degree + 1):
        if d == 0:
            Rs = [(1,)]
        else:
            Rs = ((1,) + mid + (lead,)
                  for mid in product(range(p), repeat=d - 1)
                  for lead in range(1, p))
        for R in Rs:
            for m in range(max_m + 1):
                checked += 1
                j = first_fractional_index(p, R, m, limit)
                if j is None:
                    unresolved += 1
                    if first_unresolved is None:
                        first_unresolved = (d, m, R)
                    continue
                rec = (j - d, p, d, m, R, j)
                if best is None or rec[0] > best[0]:
                    best = rec
    return SearchResult(best, checked, unresolved, first_unresolved, limit)


def verify_r1_witness(p: int) -> tuple[int, int]:
    """For p == 3 mod 4, verify R=1+t^2,m=2 has defect 4."""
    assert v2(p - 1) == 1
    R = (1, 0, 1)
    j = first_fractional_index(p, R, 2)
    assert j is not None
    assert j == 6
    return j, j - 2


if __name__ == "__main__":
    started = perf_counter()
    comparisons = []
    for p in (3, 7, 11, 19, 23, 31):
        j, defect = verify_r1_witness(p)
        comparisons.append(dict(p=p, R=(1, 0, 1), m=2, j=j, defect=defect))

    # Small exact boxes for r>=2.  A defect > N would refute the candidate
    # strengthening suggested by initial experiments.
    boxes = []
    for p, degree, mmax in ((5, 5, 24), (13, 4, 24), (17, 3, 24)):
        N = 1 << v2(p - 1)
        result = exhaustive_small(p, degree, mmax)
        boxes.append(dict(p=p, N=N, max_degree=degree, max_m=mmax, **asdict(result)))
    print(json.dumps(dict(python=platform.python_version(), seed=None,
                          method="exhaustive normalised coefficient enumeration",
                          r1=comparisons, boxes=boxes,
                          runtime_seconds=perf_counter() - started), indent=2))
