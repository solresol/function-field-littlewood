"""Eight correlated relations give a binary finite-state terminal detector.

Ordinary proof: results/2026-10-21-correlated-state.md. This module checks
the derived transitions, not a complete reachable-state enumeration.
State(q,k) stores R_(q+1+d)(k+i,k+j) for d,i,j in {0,1}, q mod N,
and min(k,N). Binary digits are consumed most significant first, with
equal-length zero padding. No full Hankel matrices occur in transitions.
"""
from dataclasses import dataclass
from itertools import product
import json
import platform
from time import perf_counter

from search.terminal_boundary_relation import BoundaryRelations


COMPONENTS = tuple(product(range(2), repeat=3))


@dataclass(frozen=True)
class State:
    phase: int
    size_cap: int
    relations: tuple


class CorrelatedStates:
    def __init__(self, p):
        self.engine = BoundaryRelations(p)
        self.N = self.engine.N
        self.initial = State(0, 0, tuple(
            self.engine.direct(1+d, i, j, independent=False)[0]
            for d, i, j in COMPONENTS))

    def step(self, state, epsilon, eta):
        """State(q,k) -> State(2q+epsilon, 2k+eta), from stored data only."""
        if epsilon not in (0, 1) or eta not in (0, 1):
            raise ValueError('transition labels must be binary digits')
        old = dict(zip(COMPONENTS, state.relations))
        new = []
        for d, i, j in COMPONENTS:
            children = []
            for a in (0, 1):
                b = (epsilon+1+d+a) % 2
                child = ((epsilon+d+a)//2,
                         (eta+i+1-a)//2, (eta+j+1-b)//2)
                assert child in old  # exact offset and endpoint closure
                children.append(old[child])
            t = 2*state.phase+epsilon+1+d
            new.append(self.engine.merge(t, children))
        return State((2*state.phase+epsilon) % self.N,
                     min(2*state.size_cap+eta, self.N), tuple(new))

    def evaluate(self, q, k, leading_zeros=0):
        if min(q, k, leading_zeros) < 0:
            raise ValueError('require nonnegative inputs and padding')
        width = max(q.bit_length(), k.bit_length(), 1)+leading_zeros
        state = self.initial
        for bit in reversed(range(width)):
            state = self.step(state, (q >> bit) & 1, (k >> bit) & 1)
        return state

    def accepts(self, state):
        return (state.size_cap == self.N
                and self.engine.terminal(state.relations[0]))


def check_direct(machine, state, q, k):
    """Compare all components with full matrices from original root sums."""
    assert state.phase == q % machine.N
    assert state.size_cap == min(k, machine.N)
    for component, relation in zip(COMPONENTS, state.relations):
        d, i, j = component
        direct, invisible = machine.engine.direct(q+1+d, k+i, k+j)
        assert relation == direct and invisible == 0, (q, k, component)
        assert len(relation) == machine.N+j-i


def run():
    started = perf_counter()
    checks = []
    for p in (3, 5, 13, 41):
        machine = CorrelatedStates(p)
        assert machine.step(machine.initial, 0, 0) == machine.initial
        count = 0
        for q, k in product((0, 1, 2, 3, 7, 8, 15), range(5)):
            parent = machine.evaluate(q, k)
            check_direct(machine, parent, q, k)
            for epsilon, eta in product(range(2), repeat=2):
                child = machine.step(parent, epsilon, eta)
                check_direct(machine, child, 2*q+epsilon, 2*k+eta)
                count += 1
        checks.append(dict(p=p, N=machine.N, parent_tuples=35,
                           child_tuples=count, relations_checked=8*(35+count)))
    controls = []
    for p, q, k, expected in ((3, 1, 2, True), (5, 311, 12, True),
                               (5, 313, 12, False), (13, 1465, 80, True)):
        machine = CorrelatedStates(p)
        state = machine.evaluate(q, k)
        check_direct(machine, state, q, k)
        assert machine.accepts(state) == expected
        assert machine.evaluate(q, k, leading_zeros=3) == state
        controls.append(dict(p=p, shift=q, square_size=k, terminal=expected))
    return dict(python=platform.python_version(), dependencies='standard library',
                seed=None, scope='transition identity checks; no reachability enumeration',
                small_checks=checks, controls=controls,
                runtime_seconds=perf_counter()-started)


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
