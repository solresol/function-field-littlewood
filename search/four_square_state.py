"""Recover all eight actual boundary relations from four adjacent squares.

Ordinary proof and hypotheses: results/2026-10-25-sunday-integration.md.
This is a structural identity check, not a reachable-graph or witness search.
Run: python3 -m search.four_square_state
"""
from dataclasses import dataclass
from itertools import product
import json
import platform
from time import perf_counter

from search.correlated_boundary_state import CorrelatedStates, State, check_direct
from search.finite_rank import _Affine
from search.run_rank_experiments import oracle
from search.terminal_boundary_relation import basis, null


SQUARE_INDICES = (0, 3, 4, 7)  # (d,i,i), in lexicographic order


@dataclass(frozen=True)
class FourSquares:
    phase: int
    size_cap: int
    squares: tuple


def compress(state):
    return FourSquares(state.phase, state.size_cap,
                       tuple(state.relations[i] for i in SQUARE_INDICES))


def reconstruct(state, p):
    """On actual tuples: wide = sum of squares; tall = intersection.

    The no-invisible-vector lemma is essential. Arbitrary subspaces, or
    boundary data from arbitrary Hankel streams, need not satisfy the guards.
    No inverse of a square Hankel matrix is used.
    """
    N = len(state.squares[0])
    relations = []
    for small, large in (state.squares[:2], state.squares[2:]):
        assert len(small) == len(large) == N and small != large
        wide = basis(small+large, p)
        tall = basis(null(list(null(small, 2*N, p))
                          + list(null(large, 2*N, p)), 2*N, p), p)
        assert len(wide) == N+1 and len(tall) == N-1
        relations.extend((small, wide, tall, large))
    return State(state.phase, state.size_cap, tuple(relations))


class FourSquareStates(CorrelatedStates):
    """Exact smaller storage, reusing the existing eight-relation transition.

    Reconstruct, apply the proved merge, retain squares. This saves stored
    relations; it makes no claim of a faster transition or feasible enumeration.
    """
    def __init__(self, p):
        super().__init__(p)
        self.initial = compress(self.initial)

    def step(self, state, epsilon, eta):
        full = reconstruct(state, self.engine.p)
        return compress(super().step(full, epsilon, eta))

    def accepts(self, state):
        return (state.size_cap == self.N
                and self.engine.terminal(state.squares[0]))


def check_preimages(engine, t, m, n, relation):
    """Independent affine solver and original root sums for each basis vector."""
    p, N = engine.p, engine.N
    A = [[oracle('lai_sprang', p, t+i+j)*pow(engine.H, -1, p) % p
          for j in range(n)] for i in range(m)]
    U = [[pow(z, i, p) for z in engine.roots] for i in range(m)]
    V = [[pow(z, j, p) for j in range(n)] for z in engine.roots]
    for vector in relation:
        u, v = vector[:N], vector[N:]
        rows = A+V
        rhs = [sum(a*b for a, b in zip(row, u)) % p for row in U]+list(v)
        solver = _Affine(p, n)
        for row, value in zip(rows, rhs):
            solver.add(row, value)
        assert solver.contradiction is None and len(solver.rows) == n
        x = [solver.rows[i][0][-1] for i in range(n)]
        assert all(sum(a*b for a, b in zip(row, x)) % p == value
                   for row, value in zip(rows, rhs))
    return len(relation)


def run():
    started = perf_counter()
    checks = []
    for p in (3, 5, 13, 41, 17):
        machine = FourSquareStates(p)
        parents = children = singular = both_singular = 0
        examples = []
        both_example = None
        # Prescribed small identity checks, not an expanded witness box.
        for q, k in product((0, 1, 2, 3, 7, 8, 15, 31), range(5)):
            state = machine.evaluate(q, k)
            check_direct(machine, reconstruct(state, p), q, k)
            parents += 1
            for d in (0, 1):
                nullities = []
                for n in (k, k+1):
                    A = [[oracle('lai_sprang', p, q+1+d+i+j)
                          for j in range(n)] for i in range(n)]
                    nullities.append(len(null(A, n, p)) if n else 0)
                singular += sum(x > 0 for x in nullities)
                both_singular += int(all(x > 0 for x in nullities))
                if all(x > 0 for x in nullities) and both_example is None:
                    both_example = dict(t=q+1+d, size=k, nullities=nullities)
                if any(nullities) and len(examples) < 3:
                    examples.append(dict(t=q+1+d, size=k, nullities=nullities))
            for epsilon, eta in product(range(2), repeat=2):
                child = machine.step(state, epsilon, eta)
                check_direct(machine, reconstruct(child, p),
                             2*q+epsilon, 2*k+eta)
                children += 1
        checks.append(dict(p=p, N=machine.N, parents=parents, children=children,
                           relations_checked=8*(parents+children),
                           singular_parent_square_blocks=singular,
                           both_singular_parent_pairs=both_singular,
                           singular_examples=examples,
                           both_singular_example=both_example))
    preimages = []
    for p, q, k in ((3, 1, 2), (5, 311, 12), (13, 1465, 80),
                    (41, 255, 11), (5, 0, 0)):
        machine = FourSquareStates(p)
        state = machine.evaluate(q, k)
        full = reconstruct(state, p)
        check_direct(machine, full, q, k)
        count = 0
        for d in (0, 1):
            for i, j in ((0, 1), (1, 0)):
                count += check_preimages(machine.engine, q+1+d, k+i, k+j,
                                         full.relations[4*d+2*i+j])
        preimages.append(dict(p=p, q=q, k=k, rectangle_basis_preimages=count,
                              terminal=machine.accepts(state),
                              inclusive_coefficient_endpoint=q+2*k+2))
    # Friday's collision stays separated by the added size-(k+1) squares.
    machine = FourSquareStates(5)
    states = [machine.evaluate(q, 4) for q in (31, 63)]
    assert states[0].squares[0] == states[1].squares[0]
    assert states[0].squares[2] == states[1].squares[2]
    assert states[0] != states[1]
    distinguishing_squares = [i for i in range(4)
                              if states[0].squares[i] != states[1].squares[i]]
    for epsilon, eta in ((0, 1), (0, 0), (1, 0)):
        states = [machine.step(s, epsilon, eta) for s in states]
    assert [machine.accepts(s) for s in states] == [False, True]
    return dict(python=platform.python_version(), dependencies='standard library',
                seed=None, scope='prescribed reconstruction/transition identities; no search',
                checks=checks, independent_affine_preimages=preimages,
                friday_collision_distinguishing_square_indices=distinguishing_squares,
                friday_continuation_outputs=[False, True],
                runtime_seconds=perf_counter()-started)


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
