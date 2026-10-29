"""An exact failure of full next-digit affine-slice profile closure.

Fixed F_5 inputs only; see results/2026-10-30-compatibility-profile-obstruction.md.
Certificate generation uses elimination. Readback uses original rational root
sums, primal/dual dot products and echelon guards, without the state recurrence.
"""
import argparse
import json
from pathlib import Path

from search.run_rank_experiments import oracle

P, N, H = 5, 4, 2
ROOTS, PRIMITIVE = (1, 2, 3, 4), (2, 3)
INITIAL = ((62, 8), (126, 8))
SUCCESSORS = ((125, 17), (253, 17))
DIGITS = ((0, 0), (0, 1), (1, 0), (1, 1))
CASES = tuple((q, k, e, h, a) for q, k in INITIAL
              for e, h in DIGITS for a in (0, 1)) + tuple(
                  (q, k, 1, 1, a) for q, k in SUCCESSORS for a in (0, 1))
DEFAULT = Path('results/2026-10-30-compatibility-profile-check.json')


def require(condition, message):
    if not condition:
        raise ValueError(message)


def dot(x, y):
    require(len(x) == len(y), 'dot-product dimensions')
    return sum(a*b for a, b in zip(x, y)) % P


def vector(v, width):
    require(len(v) == width and all(type(x) is int and 0 <= x < P for x in v),
            'vector dimensions/residues')


def local_system(q, k, e, h, a):
    """Original parent rows of parity a, on x=(E(2),E(3),O(2),O(3)).

    Parent shift/size are M=2q+e, n=2k+h. Own polynomial parity is
    b=(e+1+a)%2; the other polynomial contributes only primitive moments.
    Both polynomials have all-root values (1/2,x(2),x(3),0).
    """
    M, n = 2*q+e, 2*k+h
    b = (e+1+a) % 2
    own, other = (n+1-b)//2, (n+b)//2
    rows, rhs = [], []
    for ell in range((n+1-a)//2):
        i = 1+a+2*ell
        exponent = (M+i+1-b-1)//2
        row = [0]*N
        for j, z in enumerate(PRIMITIVE):
            row[(1-b)*H+j] = pow(H, -1, P)*pow(z, exponent, P) % P
        row += [oracle('lai_sprang', P, M+i+2*j+b)*pow(H, -1, P) % P
                for j in range(own)]
        for j in range(other):
            original = oracle('lai_sprang', P, M+i+2*j+1-b)*pow(H, -1, P) % P
            require(original == sum(pow(z, exponent+j, P) for z in PRIMITIVE)
                    * pow(H, -1, P) % P, 'opposite-parity entry')
        rows.append(row)
        rhs.append(0)
    for z in ROOTS:
        row = [0]*N
        if z in PRIMITIVE:
            row[b*H+PRIMITIVE.index(z)] = P-1
        rows.append(row+[pow(z, j, P) for j in range(own)])
        rhs.append(pow(2, -1, P) if z == 1 else 0)
    return rows, rhs


def current_system(q, k):
    rows = [[oracle('lai_sprang', P, q+1+i+j)*pow(H, -1, P) % P
             for j in range(k)] for i in range(k)]
    rows += [[pow(z, j, P) for j in range(k)] for z in ROOTS]
    return rows, [0]*k+[1, 0, 0, 0]


def solve(rows, rhs):
    """Generation only; include a checked, zero-padded inconsistency dual."""
    from search.finite_rank import _Affine
    width = len(rows[0])
    solver = _Affine(P, width)
    for i, (row, value) in enumerate(zip(rows, rhs)):
        solver.add(row, value)
        if solver.contradiction is not None:
            return None, solver.contradiction['weights']+[0]*(len(rows)-i-1)
    return [solver.rows[j][0][-1] if j in solver.rows else 0
            for j in range(width)], None


def generate():
    from search.terminal_boundary_relation import basis, null
    records = []
    for case in CASES:
        A, rhs = local_system(*case)
        width = len(A[0])
        directions = basis([v[:N] for v in null(A, width, P)], P)
        primal = []
        for d in directions:
            extra = [[int(i == j) for i in range(width)] for j in range(N)]
            v, dual = solve(A+extra, [0]*len(A)+list(d))
            require(v is not None and dual is None, 'direction lift')
            primal.append(v)
        annihilator = basis(null(directions, N, P), P)
        duals = []
        for h in annihilator:
            weights, failure = solve(list(map(list, zip(*A))), list(h)+[0]*(width-N))
            require(weights is not None and failure is None, 'annihilator lift')
            duals.append(weights)
        point, failure = solve(A, rhs)
        records.append(dict(case=case, directions=directions, primal=primal,
                            annihilator=annihilator, duals=duals,
                            point=point, failure=failure))
    current = []
    for q, k in INITIAL:
        point, dual = solve(*current_system(q, k))
        require(point is None, 'current rejection')
        current.append(dual)
    return dict(p=P, roots=ROOTS, primitive=PRIMITIVE, records=records,
                current_rejection_duals=current)


def echelon(rows, width):
    pivots = []
    for row in rows:
        vector(row, width)
        require(any(row), 'zero basis row')
        pivot = next(i for i, x in enumerate(row) if x)
        require(row[pivot] == 1, 'basis normalization')
        pivots.append(pivot)
    require(pivots == sorted(set(pivots)), 'basis pivots')
    require(all(row[pivot] == int(i == j) for i, row in enumerate(rows)
                for j, pivot in enumerate(pivots)), 'basis independence')


def linear_combination(weights, A):
    vector(weights, len(A))
    return [dot(weights, list(column)) for column in zip(*A)]


def verify(certificate):
    """No elimination or relation engine: certify each projected affine slice."""
    require(certificate['p'] == P and tuple(certificate['roots']) == ROOTS
            and tuple(certificate['primitive']) == PRIMITIVE, 'field/root order')
    # All root moments are realizable in each opposite polynomial length here.
    require(all(sum(pow(z, i-j, P) for z in ROOTS)*pow(N, -1, P) % P
                == int(i == j) for i in range(N) for j in range(N)),
            'root interpolation')
    records = certificate['records']
    require(tuple(tuple(r['case']) for r in records) == CASES, 'case completeness')
    profiles, endpoints = [], []
    for record, case in zip(records, CASES):
        q, k, e, h, a = case
        A, rhs = local_system(*case)
        width = len(A[0])
        directions, annihilator = record['directions'], record['annihilator']
        echelon(directions, N)
        echelon(annihilator, N)
        require(len(directions)+len(annihilator) == N, 'projected dimension')
        require(len(record['primal']) == len(directions)
                and len(record['duals']) == len(annihilator), 'proof completeness')
        for d, preimage in zip(directions, record['primal']):
            vector(preimage, width)
            require(preimage[:N] == d and all(dot(row, preimage) == 0 for row in A),
                    'homogeneous preimage')
        for hrow, weights in zip(annihilator, record['duals']):
            require(linear_combination(weights, A) == hrow+[0]*(width-N),
                    'projected annihilator')
        point, failure = record['point'], record['failure']
        if point is None:
            require(linear_combination(failure, A) == [0]*width
                    and dot(failure, rhs) != 0, 'infeasibility dual')
        else:
            vector(point, width)
            require(failure is None and [dot(row, point) for row in A] == rhs,
                    'affine preimage')
        profiles.append((None if point is None else point[:N], directions))
        endpoints.append(2*q+e+2*(2*k+h)-1)
    require(profiles[:8] == profiles[8:16], 'initial profile equality')
    require(all(point is None for point, _ in profiles[:16]), 'initial empty slices')
    require(profiles[16:18] != profiles[18:20], 'successor profile separation')
    require(all(point is not None and not directions for point, directions in profiles[16:]),
            'successor singleton slices')
    require(len(certificate['current_rejection_duals']) == 2, 'current completeness')
    for pair, weights in zip(INITIAL, certificate['current_rejection_duals']):
        A, rhs = current_system(*pair)
        require(linear_combination(weights, A) == [0]*len(A[0]) and dot(weights, rhs),
                'current rejection dual')
    return dict(local_systems=len(records), initial_profiles_equal=True,
                shared_digit=[1, 1], successor_profiles_equal=False,
                successor_points=[point for point, _ in profiles[16:]],
                max_original_index=max(endpoints), elimination_used=False,
                state_recurrence_used=False)


def compare_reduced(certificate):
    from search.four_square_state import FourSquareStates
    from search.terminal_target_preimage import target_preimage
    machine = FourSquareStates(P)
    for record, (q, k, e, h, a) in zip(certificate['records'], CASES):
        actual = target_preimage(machine, machine.evaluate(q, k), e, h)['slices'][a]
        point = record['point']
        require(actual['point'] == (None if point is None else tuple(point[:N]))
                and actual['directions'] == tuple(map(tuple, record['directions'])),
                'reduced slice differs')
    require(all(not machine.accepts(machine.evaluate(*pair)) for pair in INITIAL),
            'current acceptance differs')


def discover():
    """Only existing paths, their prefixes and one shared-digit extension."""
    from collections import defaultdict
    from time import perf_counter
    from search.four_square_state import FourSquareStates
    from search.terminal_target_preimage import target_preimage

    def profile(machine, state):
        return tuple(tuple((s['point'], s['directions']) for s in
                           target_preimage(machine, state, e, h)['slices'])
                     for e, h in DIGITS)

    result = []
    for p, paths in ((5, ((311, 12), (313, 12), (249, 36), (505, 36))),
                     (13, ((1465, 80), (1463, 80)))):
        started = perf_counter()
        machine = FourSquareStates(p)
        base, suffixes = set(), set()
        for q, k in paths:
            width = max(q.bit_length(), k.bit_length())
            word = tuple(((q >> b) & 1, (k >> b) & 1) for b in reversed(range(width)))
            suffixes.update(word[-ell:] for ell in range(1, min(5, width)+1))
            while q or k:
                if k >= machine.N:
                    base.add((q, k))
                q, k = q//2, k//2
        inputs = base | {(2*q+e, 2*k+h) for q, k in base for e, h in DIGITS}
        states = {pair: machine.evaluate(*pair) for pair in sorted(inputs)}
        groups = defaultdict(list)
        for (q, k), state in states.items():
            groups[(q % machine.N, k, machine.accepts(state), profile(machine, state))].append((q, k))
        collisions = [g for g in groups.values() if len(g) > 1]
        transition_separations, terminal_separations = [], []
        for group in collisions:
            for e, h in DIGITS:
                next_profiles = {profile(machine, machine.step(states[pair], e, h))
                                 for pair in group}
                if len(next_profiles) > 1:
                    transition_separations.append(dict(inputs=group, digit=(e, h)))
            for word in sorted(suffixes, key=lambda w: (len(w), w)):
                successors = [states[pair] for pair in group]
                for e, h in word:
                    successors = [machine.step(s, e, h) for s in successors]
                if len({machine.accepts(s) for s in successors}) > 1:
                    terminal_separations.append(dict(inputs=group, word=word))
        result.append(dict(p=p, paths=paths, prefixes=len(base), inputs=len(inputs),
                           collisions=collisions, transition_separations=transition_separations,
                           prescribed_suffixes=len(suffixes), terminal_separations=terminal_separations,
                           runtime_seconds=perf_counter()-started))
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--generate', action='store_true')
    parser.add_argument('--check-reduced', action='store_true')
    parser.add_argument('--discover', action='store_true')
    parser.add_argument('--path', type=Path, default=DEFAULT)
    args = parser.parse_args()
    if args.discover:
        print(json.dumps(discover(), indent=2))
        raise SystemExit(0)
    if args.generate:
        certificate = json.loads(json.dumps(generate()))
        verify(certificate)
        with args.path.open('x') as output:
            output.write(json.dumps(certificate, indent=2)+'\n')
    certificate = json.loads(args.path.read_text())
    summary = verify(certificate)
    if args.check_reduced:
        compare_reduced(certificate)
    summary['reduced_slices_compared'] = args.check_reduced
    print(json.dumps(summary, indent=2))
