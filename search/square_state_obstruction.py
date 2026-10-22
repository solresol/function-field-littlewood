"""Exact counterexample to square-only compression; no witness-box search.

Run python3 -m search.square_state_obstruction. See the dated ordinary proof.
"""
import json
import platform
from time import perf_counter

from search.correlated_boundary_state import CorrelatedStates, COMPONENTS, check_direct
from search.finite_rank import _Affine
from search.run_rank_experiments import oracle


def affine_target(machine, q, k):
    """Independent original-root-sum equations for (u,v)=(0,e_1).

    Rows use the inclusive endpoint q+2k-1; root moments use all N roots.
    Inconsistency proves rejection. A returned vector is checked by dot products.
    """
    engine = machine.engine
    p = engine.p
    rows = [[oracle('lai_sprang', p, q+1+i+j)*pow(engine.H, -1, p) % p
             for j in range(k)] for i in range(k)]
    rows += [[pow(z, j, p) for j in range(k)] for z in engine.roots]
    rhs = [0]*k+[int(z == 1) for z in engine.roots]
    solver = _Affine(p, k)
    for row, value in zip(rows, rhs):
        solver.add(row, value)
        if solver.contradiction is not None:
            weights = solver.contradiction['weights']
            used = len(weights)
            assert all(sum(w*r[j] for w, r in zip(weights, rows[:used])) % p == 0
                       for j in range(k))
            assert sum(w*b for w, b in zip(weights, rhs[:used])) % p != 0
            return None
    assert len(solver.rows) == k
    x = [solver.rows[i][0][-1] for i in range(k)]
    assert all(sum(a*b for a, b in zip(row, x)) % p == value
               for row, value in zip(rows, rhs))
    return x


def run():
    started = perf_counter()
    machine = CorrelatedStates(5)
    inputs = [(31, 4), (63, 4)]
    states = [machine.evaluate(*pair) for pair in inputs]
    a, b = states
    assert (a.phase, a.size_cap, a.relations[0]) == (
        b.phase, b.size_cap, b.relations[0])
    # Even adjoining the next-shift square fails on the same pair.
    assert a.relations[4] == b.relations[4]
    assert a != b
    initial_relation = a.relations[0]
    word = ((0, 1), (0, 0), (1, 0))
    trace = []
    witnesses = None
    for depth in range(4):
        for pair, state in zip(inputs, states):
            check_direct(machine, state, *pair)
        affine = [affine_target(machine, *pair) for pair in inputs]
        accepted = [machine.accepts(s) for s in states]
        assert accepted == [x is not None for x in affine]
        trace.append(dict(inputs=inputs, phase=states[0].phase,
                          size_cap=states[0].size_cap, accepts=accepted,
                          square_equal=states[0].relations[0] == states[1].relations[0],
                          differing_components=[c for c, x, y in zip(
                              COMPONENTS, states[0].relations, states[1].relations) if x != y]))
        if depth == 3:
            witnesses = affine
            break
        epsilon, eta = word[depth]
        inputs = [(2*q+epsilon, 2*k+eta) for q, k in inputs]
        states = [machine.step(s, epsilon, eta) for s in states]
        assert states == [machine.evaluate(*pair) for pair in inputs]
    assert [r['square_equal'] for r in trace] == [True, True, True, False]
    assert trace[-1]['accepts'] == [False, True]
    assert witnesses[1][0] and witnesses[1][-1]
    # Preserve the settled r=1 comparison as a control, not a new search.
    r1 = CorrelatedStates(3)
    assert r1.accepts(r1.evaluate(1, 2))
    return dict(p=5, N=4, initial_square=initial_relation, word=word,
                trace=trace, final_target_vectors=witnesses, r1_control=True,
                python=platform.python_version(), dependencies='standard library',
                seed=None, runtime_seconds=perf_counter()-started,
                scope='fixed compression counterexample; not an existence search')


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
