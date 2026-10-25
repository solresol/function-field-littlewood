"""One-digit target compatibility and a failed one-parity/norm criterion.

Ordinary proofs and scope: results/2026-10-26-terminal-target-preimage.md.
Only prescribed existing paths and small identity controls; no witness search.
Run: python3 -m search.terminal_target_preimage
"""
from itertools import product
import json
import platform
from time import perf_counter

from search.finite_rank import _Affine
from search.four_square_state import FourSquareStates, reconstruct
from search.lai_sprang_descent_check import multiply
from search.run_rank_experiments import oracle
from search.square_state_obstruction import affine_target
from search.terminal_boundary_relation import basis, null


def dot(x, y, p):
    return sum(a*b for a, b in zip(x, y)) % p


def child_systems(machine, state, epsilon, eta):
    """Two affine systems on (x0|Z,x1|Z), with only N unknowns in total.

    The square-root output equations fix vb|Omega^2 = half*e1. Child
    membership is tested using its annihilator, retaining all correlations.
    Only stored squares and phase are read; no stream/size oracle is used.
    """
    if epsilon not in (0, 1) or eta not in (0, 1):
        raise ValueError('transition labels must be binary digits')
    engine = machine.engine
    p, N, H = engine.p, engine.N, engine.H
    full = reconstruct(state, p)
    systems = []
    for a in (0, 1):
        b = (epsilon+1+a) % 2
        other = 1-b
        d = (epsilon+a)//2
        i, j = (eta+1-a)//2, (eta+1-b)//2
        relation = full.relations[4*d+2*i+j]
        exponent = state.phase+(epsilon+a+other)//2
        rows, rhs = [], []
        for h in null(relation, 2*N, p):
            row = [0]*N
            for ell, zidx in enumerate(engine.primitive):
                z = engine.roots[zidx]
                row[other*H+ell] = -h[zidx]*pow(z, exponent, p)*pow(H, -1, p) % p
                row[b*H+ell] = h[N+zidx]
            rows.append(row)
            rhs.append(-h[N+engine.index[1]]*pow(2, -1, p) % p)
        systems.append((rows, rhs))
    return systems


def affine_slice(rows, rhs, p, width):
    """Particular point/directions, or a dot-product-checked inconsistency dual."""
    directions = basis(null(rows, width, p), p)
    solver = _Affine(p, width)
    for row, value in zip(rows, rhs):
        solver.add(row, value)
        if solver.contradiction is not None:
            weights = solver.contradiction['weights']
            assert all(sum(w*r[j] for w, r in zip(weights, rows)) % p == 0
                       for j in range(width))
            assert dot(weights, rhs, p) != 0
            return dict(point=None, directions=directions, dual=weights)
    point = tuple(solver.rows[j][0][-1] if j in solver.rows else 0
                  for j in range(width))
    assert all(dot(row, point, p) == value for row, value in zip(rows, rhs))
    assert all(dot(row, v, p) == 0 for row in rows for v in directions)
    return dict(point=point, directions=directions, dual=None)


def target_preimage(machine, state, epsilon, eta):
    """Exact affine intersection; uniqueness uses the ordinary invisible lemma.

    When both children are feasible, the obstruction is [a1-a0] modulo
    K0+K1. A nonzero class is certified by an annihilating linear functional.
    """
    p, N = machine.engine.p, machine.N
    systems = child_systems(machine, state, epsilon, eta)
    slices = [affine_slice(rows, rhs, p, N) for rows, rhs in systems]
    rows = systems[0][0]+systems[1][0]
    rhs = systems[0][1]+systems[1][1]
    # The homogeneous system would give a parent invisible vector.
    assert len(basis(rows, p)) == N
    joint = affine_slice(rows, rhs, p, N)
    assert not joint['directions']
    obstruction = None
    quotient_dimension = None
    if all(s['point'] is not None for s in slices):
        directions = basis(slices[0]['directions']+slices[1]['directions'], p)
        assert len(directions) == sum(len(s['directions']) for s in slices)
        quotient_dimension = N-len(directions)
        difference = tuple((b-a) % p for a, b in zip(
            slices[0]['point'], slices[1]['point']))
        obstruction = next((h for h in null(directions, N, p)
                            if dot(h, difference, p)), None)
        assert (obstruction is None) == (joint['point'] is not None)
    return dict(slices=slices, point=joint['point'],
                joint_dual=joint['dual'], quotient_dimension=quotient_dimension,
                compatibility_dual=obstruction)


def one_parity_counterexample():
    """Read every claimed row/evaluation directly from original root sums."""
    p, M = 5, 313
    V = [3, 3, 4, 0, 1, 3, 4, 0, 1]
    S = [3, 1, 0, 0, 3, 3, 3, 3, 3, 0, 1, 1]
    assert multiply([1]*4, V, p) == S and S[0] and S[-1]
    engine = FourSquareStates(p).engine
    E, O = S[::2], S[1::2]
    values = lambda poly: [sum(x*pow(z, j, p) for j, x in enumerate(poly)) % p
                           for z in engine.roots]
    assert values(S) == [1, 0, 0, 0]
    ev, ov = values(E), values(O)
    x = [ev[j] for j in engine.primitive]+[ov[j] for j in engine.primitive]
    norm = [(1-z)*pow(z, M//2, p)*(ev[j]**2-z*ov[j]**2) % p
            for j, z in enumerate(engine.roots) if j in engine.primitive]
    assert x == [4, 2, 4, 2] and norm == [1, 1]
    rows = [sum(s*oracle('lai_sprang', p, M+ell+j)
                for j, s in enumerate(S)) % p for ell in range(1, 13)]
    assert rows == [0, 4, 0, 3, 0, 3, 0, 4, 0, 1, 0, 1]
    machine = FourSquareStates(p)
    state = machine.evaluate(156, 6)
    analysis = target_preimage(machine, state, 1, 0)
    assert analysis['slices'][0]['point'] == tuple(x)
    assert analysis['slices'][1]['point'] == (1, 4, 1, 0)
    assert analysis['point'] is None
    assert affine_target(machine, M, len(S)) is None
    return dict(p=p, shift=M, size=len(S), V=V, S=S, E=E, O=O,
                root_moments=values(S), primitive_moments=x,
                weighted_norm_values=norm, original_rows=rows,
                inclusive_original_endpoint=M+2*len(S)-1,
                preimage=analysis)


def run():
    started = perf_counter()
    fields = []
    for p in (3, 5, 13, 41, 17):
        machine = FourSquareStates(p)
        comparisons = feasible_both_rejects = 0
        for q, k in product((0, 1, 2, 3, 7, 8, 15, 31), range(5)):
            state = machine.evaluate(q, k)
            for epsilon, eta in product(range(2), repeat=2):
                result = target_preimage(machine, state, epsilon, eta)
                Q, n = 2*q+epsilon, 2*k+eta
                expected = affine_target(machine, Q, n) is not None
                assert (result['point'] is not None) == expected
                if epsilon == 0:
                    assert expected == (eta == 0 and machine.engine.terminal(state.squares[0]))
                    if expected:
                        assert not any(result['point'])
                feasible_both_rejects += int(not expected and all(
                    s['point'] is not None for s in result['slices']))
                comparisons += 1
        fields.append(dict(p=p, N=machine.N, comparisons=comparisons,
                           independently_feasible_but_reject=feasible_both_rejects))
    controls = []
    for p, M, n, expected in ((3, 1, 2, True), (5, 311, 12, True),
                              (5, 313, 12, False), (13, 1465, 80, True),
                              (13, 1463, 80, False), (5, 249, 36, False),
                              (5, 505, 36, True), (41, 618117, 1916343, True)):
        machine = FourSquareStates(p)
        state = machine.evaluate(M//2, n//2)
        result = target_preimage(machine, state, M % 2, n % 2)
        assert (result['point'] is not None) == expected
        direct = p != 41
        if direct:
            assert (affine_target(machine, M, n) is not None) == expected
        controls.append(dict(p=p, shift=M, size=n, accepted=expected,
                             original_matrix_checked=direct, preimage=result))
    return dict(python=platform.python_version(), dependencies='standard library',
                seed=None, scope='prescribed target identities, compatibility and failed implication; no search',
                fields=fields, existing_path_controls=controls,
                one_parity_norm_counterexample=one_parity_counterexample(),
                runtime_seconds=perf_counter()-started)


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
