"""Exact prime-field prefix optimisation with independently checkable duals.

Streams are callables a(n), n>=1. No value past m+d+limit is requested.
Every multiplier has r_0=1 and r_d!=0. This is a finite calculation only.
"""
from dataclasses import dataclass
from functools import lru_cache
from math import isqrt
from typing import Callable, Optional


@lru_cache(None)
def validate_field(p: int) -> None:
    if p < 2 or any(p % k == 0 for k in range(2, isqrt(p) + 1)):
        raise ValueError('p must be prime')


@dataclass(frozen=True)
class PrefixResult:
    R: tuple[int, ...]
    j: Optional[int]
    zero_prefix: int
    rank: int  # includes r_0=1; rank at the last feasible prefix
    obstruction: Optional[dict]


class _Affine:
    """Incremental RREF, retaining combinations of the original equations."""
    def __init__(self, p, width):
        self.p, self.width = p, width
        self.rows = {}  # pivot -> (augmented row, combination weights)
        self.count = 0
        self.contradiction = None

    def add(self, coefficients, rhs):
        p, width = self.p, self.width
        for _, weights in self.rows.values():
            weights.append(0)
        row = [x % p for x in coefficients] + [rhs % p]
        weights = [0] * self.count + [1]
        self.count += 1
        for pivot, (old, old_weights) in sorted(self.rows.items()):
            factor = row[pivot]
            row = [(x - factor*y) % p for x, y in zip(row, old)]
            weights = [(x - factor*y) % p for x, y in zip(weights, old_weights)]
        pivot = next((i for i in range(width) if row[i]), None)
        if pivot is None:
            if row[-1]:
                self.contradiction = dict(kind='inconsistent', weights=weights)
            return
        inv = pow(row[pivot], -1, p)
        row = [x * inv % p for x in row]
        weights = [x * inv % p for x in weights]
        for old, old_weights in self.rows.values():
            factor = old[pivot]
            old[:] = [(x - factor*y) % p for x, y in zip(old, row)]
            old_weights[:] = [(x - factor*y) % p for x, y in zip(old_weights, weights)]
        self.rows[pivot] = (row, weights)

    def admissible(self):
        if self.contradiction is not None:
            return None, self.contradiction
        particular = [0] * self.width
        for pivot, (row, _) in self.rows.items():
            particular[pivot] = row[-1]
        if particular[-1]:
            return tuple(particular), None
        # If the last coordinate varies, one nullspace direction suffices:
        # particular[-1]=0, so adding it gives a nonzero endpoint even over F_2.
        for free in range(self.width):
            if free in self.rows:
                continue
            direction = [0] * self.width
            direction[free] = 1
            for pivot, (row, _) in self.rows.items():
                direction[pivot] = -row[free] % self.p
            if direction[-1]:
                return tuple((x+y) % self.p for x, y in zip(particular, direction)), None
        # The RREF now contains precisely r_d=0, including its derivation.
        return None, dict(kind='leading_zero', weights=self.rows[self.width-1][1].copy())


def longest_prefix(p: int, a: Callable[[int], int], d: int, m: int,
                   limit: int = 128) -> PrefixResult:
    """Maximise first nonzero index over all admissible degree-d multipliers.

    If j is present, a dual obstruction proves no multiplier vanishes through j;
    R vanishes through j-1 and is nonzero at j. If j is None, R vanishes through
    limit; no exact index, maximality, or infinite vanishing is asserted.
    """
    validate_field(p)
    if d < 0 or m < 0 or limit < 1:
        raise ValueError('d,m must be nonnegative and limit positive')
    system = _Affine(p, d+1)
    system.add([1] + [0]*d, 1)
    previous, _ = system.admissible()
    rank = len(system.rows)
    for k in range(1, limit+1):
        system.add([a(m+i+k) for i in range(d+1)], 0)
        witness, obstruction = system.admissible()
        if witness is None:
            return PrefixResult(previous, k, k-1, rank, obstruction)
        previous, rank = witness, len(system.rows)
    return PrefixResult(previous, None, limit, rank, None)


def check_result(p: int, a: Callable[[int], int], d: int, m: int,
                 limit: int, result: PrefixResult) -> bool:
    """Independent dot-product checker; does not call elimination or rank code.

    Checks witness and dual maximality, or a labelled unresolved zero prefix.
    The diagnostic rank is deliberately not certified by this checker.
    """
    validate_field(p)
    R, j = result.R, result.j
    if d < 0 or m < 0 or limit < 1 or len(R) != d+1 or R[0] % p != 1 or not R[-1] % p:
        return False
    if j is None:
        if result.zero_prefix != limit or result.obstruction is not None:
            return False
        end = limit
    else:
        if not 1 <= j <= limit or result.zero_prefix != j-1:
            return False
        end = j
    values = [sum(r*a(m+i+k) for i, r in enumerate(R)) % p
              for k in range(1, end+1)]
    if any(values[:result.zero_prefix]):
        return False
    if j is None:
        return True
    if not values[-1] or not isinstance(result.obstruction, dict):
        return False
    weights = result.obstruction.get('weights', [])
    if len(weights) != j+1:
        return False
    # Original rows: r_0=1, followed by the j vanishing equations.
    lhs = [(weights[0] if i == 0 else 0) +
           sum(weights[k]*a(m+i+k) for k in range(1, j+1))
           for i in range(d+1)]
    lhs = [x % p for x in lhs]
    rhs = weights[0] % p
    if result.obstruction.get('kind') == 'inconsistent':
        return not any(lhs) and rhs != 0
    if result.obstruction.get('kind') == 'leading_zero':
        return lhs == [0]*d + [1] and rhs == 0
    return False
