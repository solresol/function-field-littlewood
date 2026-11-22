"""Check the two all-length N=4 ray exclusions at p=5 by two recurrences."""

from search.fraction_free_block import COMPONENTS, residual, seed, step
from search.terminal_boundary_relation import BoundaryRelations
from search.terminal_prime_obstruction import formal_series
from search.two_merge_split import split_line


def projective(form):
    entries = sorted((mask, x % 5) for mask, x in form.items() if x % 5)
    assert entries, "exterior specialization lost rank"
    scale = pow(entries[0][1], -1, 5)
    return tuple((mask, x * scale % 5) for mask, x in entries)


def verify(initial, first, repeat, line_successors):
    engine = BoundaryRelations(5)
    q, k = initial, 8
    state = seed(4, q, k, formal_series(4, q + 2*k + 2))
    phase = q % 4
    exterior_seen, relation_seen = {}, {}
    transitions = {}
    collisions = []
    prior = prior_lines = None
    for n in range(repeat + 1):
        forms = tuple(projective(f) for f in state)
        state = tuple(dict(f) for f in forms)
        planes = tuple(engine.recursive(q+1+d, k+i, k+j) for d, i, j in COMPONENTS)
        if n == 0:
            for plane, (d, i, j) in zip(planes, COMPONENTS):
                assert engine.direct(q+1+d, k+i, k+j) == (plane, 0)
        assert not engine.terminal(planes[0])
        assert any(x % 5 for x in residual(state[0], 4).values())
        assert phase == q % 4
        if n == repeat:
            assert exterior_seen[phase, forms] == relation_seen[phase, planes] == first
        else:
            assert (phase, forms) not in exterior_seen and (phase, planes) not in relation_seen
            exterior_seen[phase, forms] = relation_seen[phase, planes] = n
        if phase == 3:
            lines = [split_line(state[j], a) for a, j in enumerate((3, 4))]
            # The zero ideal means all ten 2-by-2 minors vanish, even at rank loss.
            u, v = lines
            unit = any((u[i]*v[j]-u[j]*v[i]) % 5 for j in range(5) for i in range(j))
            pair = tuple(projective(dict(enumerate(line))) if any(x % 5 for x in line)
                         else () for line in lines)
            if prior_lines is not None and all(prior_lines):
                previous = line_successors.setdefault(prior_lines, ((initial, n-1), unit))
                if previous[1] != unit:
                    collisions.append((previous[0], (initial, n-1)))
            prior_lines = pair
            if prior is not None:
                transitions.setdefault((prior, unit), n-1)
            prior = unit
        if n == repeat:
            break
        state, phase = step(state, 4, phase)
        q, k = 2*q+1, 2*k+1
    if initial == 62:
        assert transitions[True, True] == 2 and transitions[True, False] == 6
    print(initial, first, repeat, transitions, "line collisions", collisions)


if __name__ == '__main__':
    successors = {}
    verify(62, 103, 118, successors)
    verify(126, 48, 63, successors)
