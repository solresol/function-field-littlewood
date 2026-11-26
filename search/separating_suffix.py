"""Check a shortest recurrent switch/repeat separator over F_5."""
from itertools import product

from search.cycle_exit import child_kernel
from search.fraction_free_block import COMPONENTS, merge, residual, seed
from search.repeated_ray_cycle import projective
from search.terminal_boundary_relation import BoundaryRelations, basis, null
from search.terminal_prime_obstruction import formal_series


def endpoint(initial, n, word):
    q, k = ((initial + 1) << n) - 1, (9 << n) - 1
    for u, v in word:
        q, k = 2*q + u, 2*k + v
    return q+1, k


def exterior_digit(state, q, u, v):
    out = []
    for d, i, j in COMPONENTS:
        phase = (2*q + u + 1 + d) % 8
        children = []
        for a in (0, 1):
            b = (phase+a) % 2
            index = ((u+d+a)//2, (v+i+1-a)//2, (v+j+1-b)//2)
            children.append(state[COMPONENTS.index(index)])
        out.append(dict(projective(merge(*children, 4, phase))))
    return tuple(out)


def run():
    engine = BoundaryRelations(5)
    digits = tuple(product(range(2), repeat=2))
    switch, repeat = (1, 0), (1, 1)
    for initial, first in ((62, 103), (126, 48)):
        for n in range(first, first+15):
            for length in range(3):
                for suffix in product(digits, repeat=length):
                    decisions = []
                    for digit in (switch, repeat):
                        t, k = endpoint(initial, n, (digit,) + suffix)
                        decisions.append(engine.terminal(engine.recursive(t, k, k)))
                    assert decisions[0] == decisions[1]

    q = 126
    state = seed(4, q, 8, formal_series(4, 144))
    for _ in range(50):
        state = exterior_digit(state, q, *repeat)
        q = 2*q+1
    for digit, accepted in ((switch, False), (repeat, True)):
        word = (digit, (0, 1), repeat, repeat)
        form_state, shift = state, q
        for u, v in word:
            form_state = exterior_digit(form_state, shift, u, v)
            shift = 2*shift+u
        t, k = endpoint(126, 50, word)
        assert shift+1 == t
        restricted = [child_kernel(engine, t, k, a)[0] for a in (0, 1)]
        rows = restricted[0] + restricted[1]
        lifts = basis(null(rows, 5, 5), 5)
        assert any(row[0] for row in lifts) == accepted
        assert engine.terminal(engine.recursive(t, k, k)) == accepted
        assert (not any(x % 5 for x in residual(form_state[0], 4).values())) == accepted
        print(digit, 'child row bases', [basis(A, 5) for A in restricted],
              'shared kernel', lifts)


if __name__ == '__main__':
    run()
