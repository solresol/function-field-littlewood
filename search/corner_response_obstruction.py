"""A missing bordering scalar in the fixed F_5 profile collision.

The two actual tuples agree on SEVEN full boundary relations. Their last
square lies between the same tall/wide rectangles but has a different line
in the two-dimensional quotient. See the 1 November Sunday integration.
Generation uses elimination; verification uses only original coefficients,
explicit preimages, rank-minor inverses and echelon reduction.
"""
import argparse
import json
from pathlib import Path

from search.compatibility_affine_obstruction import inverse
from search.compatibility_profile_obstruction import dot, echelon, solve, vector
from search.run_rank_experiments import oracle

P, N, H = 5, 4, 2
ROOTS = (1, 2, 3, 4)
INITIAL = ((62, 8), (126, 8))
SUCCESSORS = ((125, 17), (253, 17))
SECOND = ((251, 35), (507, 35))
CASES = (tuple((q, k, i) for q, k in INITIAL for i in range(4))
         + tuple((q, k, 1) for q, k in SUCCESSORS)
         + tuple((q, k, 0) for q, k in SECOND))
DEFAULT = Path('results/2026-11-01-corner-response-check.json')


def require(condition, message):
    if not condition:
        raise ValueError(message)


def original_system(q, k, square):
    """[-U | A] on (u,x), and V, with A_ij=c_(t+i+j), c=a/H.

    Square indices are (d,i)=(0,0),(0,1),(1,0),(1,1).
    The relation's start is t=q+1+d; size n=k+i.
    """
    t, n = q+1+square//2, k+square % 2
    rows = [[(-pow(z, i, P)) % P for z in ROOTS]
            + [oracle('lai_sprang', P, t+i+j)*pow(H, -1, P) % P
               for j in range(n)] for i in range(n)]
    moments = [[pow(z, j, P) for j in range(n)] for z in ROOTS]
    return rows, moments, t+2*n-2


def combine(weights, rows, width):
    return [sum(w*r[j] for w, r in zip(weights, rows)) % P
            for j in range(width)]


def contains(rows, v):
    """Membership in an already checked reduced-echelon basis; no solving."""
    remainder = list(v)
    for row in rows:
        pivot = next(i for i, x in enumerate(row) if x)
        scale = remainder[pivot]
        remainder = [(x-scale*y) % P for x, y in zip(remainder, row)]
    return not any(remainder)


def generate():
    from search.terminal_boundary_relation import basis, null
    records = []
    for case in CASES:
        rows, moments, _ = original_system(*case)
        n = len(rows)
        projected = [s[:N]+[dot(v, s[N:]) for v in moments]
                     for s in null(rows, N+n, P)]
        relation = basis(projected, P)
        require(len(relation) == N, 'square dimension')
        preimages = []
        for r in relation:
            fixed_u = [[int(i == j) for i in range(N+n)] for j in range(N)]
            fixed_v = [[0]*N+v for v in moments]
            s, failure = solve(rows+fixed_u+fixed_v, [0]*n+list(r))
            require(s is not None and failure is None, 'relation preimage')
            preimages.append(s[N:])
        reduced = basis(rows, P)
        require(len(reduced) == n, 'row rank')
        columns = [next(i for i, x in enumerate(row) if x) for row in reduced]
        minor = [[row[j] for j in columns] for row in rows]
        records.append(dict(case=case, relation=relation, preimages=preimages,
                            rank_columns=columns, rank_inverse=inverse(minor)))
    A, B, C = (records[2]['relation'], records[3]['relation'],
               records[7]['relation'])
    L = basis(null(list(null(A, 2*N, P))+list(null(B, 2*N, P)), 2*N, P), P)
    W = basis(list(A)+list(B), P)
    a = next(r for r in A if not contains(L, r))
    b = next(r for r in B if not contains(L, r))
    c = next(r for r in C if not contains(L, r))
    coefficients, failure = solve(list(map(list, zip(*(list(L)+[a, b])))), list(c))
    require(coefficients is not None and failure is None, 'quotient coordinates')
    return dict(p=P, roots=ROOTS, records=records, intersection=L, sum=W,
                a=a, b=b, c=c, c_coordinates=coefficients,
                right_parameter=coefficients[-2]*pow(coefficients[-1], -1, P) % P)


def verify(certificate):
    """Independently prove exact full relations without elimination/recursion.

    An invertible n-column minor proves rank([-U|A])=n, hence its nullspace
    has dimension N. N independent projected vectors with explicit original
    polynomial preimages then span EXACTLY the boundary relation. This finite
    proof assumes neither Proposition 2.3 nor the parity recurrence.
    """
    require(certificate['p'] == P and tuple(certificate['roots']) == ROOTS,
            'field/root order')
    records = certificate['records']
    require(tuple(tuple(r['case']) for r in records) == CASES, 'case completeness')
    endpoints = []
    for case, record in zip(CASES, records):
        rows, moments, endpoint = original_system(*case)
        n = len(rows)
        R = record['relation']
        echelon(R, 2*N)
        require(len(R) == N and len(record['preimages']) == N, 'relation dimension')
        for r, x in zip(R, record['preimages']):
            vector(x, n)
            require(all(dot(row, list(r[:N])+x) == 0 for row in rows),
                    'original forcing equations')
            require([dot(v, x) for v in moments] == list(r[N:]), 'original moments')
        columns, inv = record['rank_columns'], record['rank_inverse']
        require(len(columns) == n and len(set(columns)) == n
                and all(type(j) is int and 0 <= j < N+n for j in columns),
                'rank column selection')
        require(len(inv) == n, 'rank inverse size')
        for row in inv:
            vector(row, n)
        minor = [[row[j] for j in columns] for row in rows]
        for left, right in ((minor, inv), (inv, minor)):
            for i in range(n):
                for j in range(n):
                    require(sum(left[i][ell]*right[ell][j] for ell in range(n)) % P
                            == int(i == j), 'rank inverse identity')
        # Isotropy is checked as arithmetic too; needed for the quotient lemma.
        require(all(sum(x[i]*y[N+i]-x[N+i]*y[i] for i in range(N)) % P == 0
                    for x in R for y in R), 'square isotropy')
        endpoints.append(endpoint)
    relations = [r['relation'] for r in records]
    require(relations[:3] == relations[4:7], 'three initial squares equal')
    A, B, C = relations[2], relations[3], relations[7]
    require(A != B and A != C and B != C, 'distinct corner completions')
    L, W = certificate['intersection'], certificate['sum']
    echelon(L, 2*N)
    echelon(W, 2*N)
    require(len(L) == N-1 and len(W) == N+1, 'border dimensions')
    require(all(contains(R, v) for R in (A, B, C) for v in L), 'common tall rectangle')
    require(all(contains(W, v) for R in (A, B, C) for v in R), 'common wide rectangle')
    # Distinct N-spaces contained in W have sum W and intersection L.
    require(relations[8] != relations[9], 'successor square separation')
    require(relations[10] != relations[11], 'two-digit full response separation')
    for name, R in (('a', A), ('b', B), ('c', C)):
        v = certificate[name]
        vector(v, 2*N)
        require(contains(R, v) and not contains(L, v), 'quotient representative '+name)
    coefficients = certificate['c_coordinates']
    vector(coefficients, N+1)
    require(combine(coefficients, L+[certificate['a'], certificate['b']], 2*N)
            == certificate['c'], 'quotient identity')
    require(coefficients[-1] != 0, 'finite line chart')
    parameter = coefficients[-2]*pow(coefficients[-1], -1, P) % P
    require(parameter == certificate['right_parameter'] == 4, 'border parameter')
    target = [0]*N+[1, 0, 0, 0]
    require(all(not contains(relations[i], target) for i in (0, 4, 10, 11)),
            'retained terminal rejections')
    return dict(full_relations=len(records), initial_seven_relations_equal=True,
                omitted_square_equal=False, common_tall_dimension=len(L),
                common_wide_dimension=len(W), border_parameters=[0, parameter],
                shared_digit=[1, 1], successor_three_squares_equal=False,
                second_shared_digit=[1, 1], second_full_responses_equal=False,
                terminal_language_separation_proved=False,
                max_original_index=max(endpoints), elimination_used=False,
                state_recurrence_used=False)


def compare_reduced(certificate):
    from search.four_square_state import FourSquareStates, reconstruct
    machine = FourSquareStates(P)
    for record, (q, k, square) in zip(certificate['records'], CASES):
        require(machine.evaluate(q, k).squares[square]
                == tuple(map(tuple, record['relation'])), 'reduced square differs')
    states = [machine.evaluate(*pair) for pair in INITIAL]
    full = [reconstruct(s, P) for s in states]
    require(full[0].relations[:7] == full[1].relations[:7], 'seven relations differ')
    for e, h in ((0, 0), (0, 1), (1, 0), (1, 1)):
        successors = [machine.step(s, e, h) for s in states]
        require(successors[0].squares[0] == successors[1].squares[0],
                'one-digit full response differs')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--generate', action='store_true')
    parser.add_argument('--check-reduced', action='store_true')
    parser.add_argument('--path', type=Path, default=DEFAULT)
    args = parser.parse_args()
    if args.generate:
        result = json.loads(json.dumps(generate()))
        verify(result)
        with args.path.open('x') as output:
            output.write(json.dumps(result, indent=2)+'\n')
    result = json.loads(args.path.read_text())
    summary = verify(result)
    if args.check_reduced:
        compare_reduced(result)
    summary['reduced_states_compared'] = args.check_reduced
    print(json.dumps(summary, indent=2))
