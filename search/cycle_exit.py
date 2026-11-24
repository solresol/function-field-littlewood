"""Single-digit exits from the two proven cycles over F_5."""
from collections import Counter

from search.fraction_free_block import maps, merge, residual, seed, step
from search.repeated_ray_cycle import projective
from search.terminal_prime_obstruction import formal_series
from search.terminal_boundary_relation import BoundaryRelations, basis, null


def child_kernel(engine, t, size, a):
    """Pull the actual child annihilator back to (h,w) on (f,s)=(0,h*1)."""
    p, N = engine.p, engine.N
    b = (t+a) % 2
    plane = engine.recursive((t+a+b)//2, (size+1-a)//2, (size+1-b)//2)
    residues = []
    for row in plane:
        f = [sum(pow(z, i, p)*v for z, v in zip(engine.roots, row[:N]))
             for i in range(N)]
        s = [sum(pow(z, -i, p)*v for z, v in zip(engine.roots, row[N:]))
             * pow(N, -1, p) for i in range(N)]
        residues.append(f+s)
    mapping = [[sum(row[N:2*N]), *row[2*N:]] for row in maps(N, t % (2*N), a)]
    equations = [[sum(x*y for x, y in zip(h, col)) % p for col in zip(*mapping)]
                 for h in null(residues, 2*N, p)]
    return equations, basis(null(equations, N+1, p), p)


def run():
    engine = BoundaryRelations(5)
    for initial, first in ((62, 103), (126, 48)):
        k, q = 8, initial
        state = seed(4, q, k, formal_series(4, q+18))
        counts = Counter()
        for n in range(first+15):
            # The sole new digit is (1,0). Both children are k by k.
            t, size = 2*q+2, 2*k
            (A, left), (B, right) = [child_kernel(engine, t, size, a) for a in (0, 1)]
            both = basis(null(A+B, 5, 5), 5)
            assert not both
            assert not engine.terminal(engine.recursive(t, size, size))
            if n >= first:
                counts[tuple((len(L), any(row[0] for row in L))
                             for L in (left, right))] += 1
            state = tuple(dict(projective(form)) for form in state)
            parent = merge(state[0], state[4], 4, t % 8)
            assert any(x % 5 for x in residual(parent, 4).values())
            state, _ = step(state, 4, q % 4)
            q, k = 2*q+1, 2*k+1
        print(initial, sorted(counts.items()))


if __name__ == '__main__':
    run()
