"""Odd-digit transport of the missing corner, including projective poles.

Ordinary all-prime proof: results/2026-11-02-odd-corner-transport.md.
The fixed F_5 certificate reuses the independently checked 1 November inputs.
Generation uses elimination; readback uses dot products and inverse minors.
Abstract line completions are not asserted to be reachable stream states.
"""
import argparse
import hashlib
import json
from pathlib import Path

from search.corner_response_obstruction import (
    DEFAULT as SOURCE, contains, require, verify as verify_source,
)
from search.compatibility_profile_obstruction import echelon, vector


DEFAULT = Path('results/2026-11-02-odd-corner-check.json')


def mv(A, x, p):
    return [sum(a*b for a, b in zip(row, x)) % p for row in A]


def maps(p, roots, q):
    """M0, M1, P at t=2q+2 on w=(u,v0,v1); no relation recurrence."""
    N = len(roots)
    index = {z: i for i, z in enumerate(roots)}
    children = []
    for a in (0, 1):
        M = [[0]*(3*N) for _ in range(2*N)]
        for j, z in enumerate(roots):
            M[index[z*z % p]][j] = pow(z, a, p)
            M[N+j][N*(1+a)+j] = 1
            if pow(z, N//2, p) == p-1:
                M[j][N*(2-a)+j] = -pow(z, q+1, p)*pow(N//2, -1, p) % p
        children.append(M)
    P = [[0]*(3*N) for _ in range(2*N)]
    for j, z in enumerate(roots):
        P[j][j] = 1
        P[N+j][N+index[z*z % p]] = 1
        P[N+j][2*N+index[z*z % p]] = z
    return (*children, P)


def pull(rows, M, p):
    return [mv(list(zip(*M)), h, p) for h in rows]


def combination(weights, rows, p):
    return mv(list(zip(*rows)), weights, p)


def rank_record(rows, p):
    from search.terminal_boundary_relation import basis
    from search.compatibility_affine_obstruction import inverse
    reduced = basis(rows, p)
    require(len(reduced) == len(rows), 'generation row independence')
    columns = [next(i for i, x in enumerate(row) if x) for row in reduced]
    return dict(columns=columns, inverse=inverse([[r[j] for j in columns] for r in rows]))


def check_rank(rows, record, p):
    n, width = len(rows), len(rows[0])
    columns, inv = record['columns'], record['inverse']
    require(len(columns) == n and len(set(columns)) == n
            and all(type(j) is int and 0 <= j < width for j in columns), 'minor columns')
    require(len(inv) == n, 'minor inverse size')
    for row in inv:
        vector(row, n)
    minor = [[r[j] for j in columns] for r in rows]
    for A, B in ((minor, inv), (inv, minor)):
        require(all(sum(A[i][k]*B[k][j] for k in range(n)) % p == int(i == j)
                    for i in range(n) for j in range(n)), 'minor inverse products')


def generate():
    from search.terminal_boundary_relation import basis, null
    from search.compatibility_profile_obstruction import solve
    source = json.loads(SOURCE.read_text())
    verify_source(source)
    p, N = 5, 4
    F, L, W = source['records'][1]['relation'], source['intersection'], source['sum']
    M0, M1, P = maps(p, source['roots'], 62)
    Fdual, Wdual = basis(null(F, 2*N, p), p), basis(null(W, 2*N, p), p)
    constraints = pull(Fdual, M0, p)+pull(Wdual, M1, p)
    Ldual = null(L, 2*N, p)
    quotient = pull(Ldual, M1, p)
    S = basis(null(constraints, 3*N, p), p)
    S0 = basis(null(constraints+quotient, 3*N, p), p)
    wide = basis([mv(P, w, p) for w in S], p)
    tall = basis([mv(P, w, p) for w in S0], p)

    def solve_checked(A, rhs):
        x, failure = solve(A, rhs)
        require(x is not None and failure is None, 'generation lift')
        return x

    wide_lifts = [solve_checked(constraints+P, [0]*len(constraints)+list(r)) for r in wide]
    tall_lifts = [solve_checked(constraints+quotient+P,
                               [0]*(len(constraints)+len(quotient))+list(r)) for r in tall]
    lifts = [solve_checked(constraints+quotient,
                           [0]*len(constraints)+mv(Ldual, source[name], p))
             for name in ('a', 'b')]
    chart = []
    for r in wide:
        if len(basis(list(tall)+chart+[r], p)) > len(tall)+len(chart):
            chart.append(r)
        if len(chart) == 2:
            break
    frame = list(tall)+chart
    coordinates = [solve_checked(list(map(list, zip(*frame))), mv(P, w, p)) for w in lifts]
    return dict(source_sha256=hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
                context=dict(p=p, q=62, k=8), forcing_annihilator=Fdual,
                wide_annihilator=Wdual, constraints_rank=rank_record(constraints, p),
                output_wide=wide, wide_preimages=wide_lifts,
                output_tall=tall, tall_preimages=tall_lifts,
                quotient_preimages=lifts, output_chart=chart,
                chart_rank=rank_record(frame, p), output_coordinates=coordinates,
                projective_matrix=[[coordinates[0][-2], coordinates[1][-2]],
                                   [coordinates[0][-1], coordinates[1][-1]]])


def verify(certificate):
    """Finite rank-two proof, with no solving, elimination or state recursion."""
    require(certificate['source_sha256'] == hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
            'source certificate digest')
    source = json.loads(SOURCE.read_text())
    source_summary = verify_source(source)
    require(certificate['context'] == dict(p=5, q=62, k=8), 'fixed context')
    p, N = 5, 4
    F, L, W = source['records'][1]['relation'], source['intersection'], source['sum']
    M0, M1, P = maps(p, source['roots'], 62)
    Fdual, Wdual = certificate['forcing_annihilator'], certificate['wide_annihilator']
    for dual, R, dimension in ((Fdual, F, 4), (Wdual, W, 3)):
        echelon(dual, 2*N)
        require(len(dual) == dimension and all(not any(mv(dual, r, p)) for r in R),
                'complete annihilator')
    constraints = pull(Fdual, M0, p)+pull(Wdual, M1, p)
    check_rank(constraints, certificate['constraints_rank'], p)
    # Seven independent equations in twelve variables: dim S=5.
    wide, tall = certificate['output_wide'], certificate['output_tall']
    for R, lifts, dimension, kernel in (
            (wide, certificate['wide_preimages'], 5, False),
            (tall, certificate['tall_preimages'], 3, True)):
        echelon(R, 2*N)
        require(len(R) == len(lifts) == dimension, 'output dimension')
        for r, w in zip(R, lifts):
            vector(w, 3*N)
            require(contains(F, mv(M0, w, p)) and contains(W, mv(M1, w, p))
                    and mv(P, w, p) == r, 'internal lift')
            require(not kernel or contains(L, mv(M1, w, p)), 'quotient kernel')
    require(all(contains(wide, r) for r in tall), 'nested output borders')
    # Five independent outputs imply that P:S -> output_wide is an isomorphism.
    chart = certificate['output_chart']
    require(len(chart) == 2, 'chart size')
    for r in chart:
        vector(r, 2*N)
        require(contains(wide, r), 'chart in output wide')
    frame = tall+chart
    check_rank(frame, certificate['chart_rank'], p)
    lifts, coordinates = certificate['quotient_preimages'], certificate['output_coordinates']
    require(len(lifts) == len(coordinates) == 2, 'quotient lift completeness')
    outputs = []
    for name, w, coordinate in zip(('a', 'b'), lifts, coordinates):
        vector(w, 3*N)
        vector(coordinate, 5)
        own = mv(M1, w, p)
        require(contains(F, mv(M0, w, p)) and contains(W, own), 'quotient lift in S')
        require(contains(L, [(x-y) % p for x, y in zip(own, source[name])]),
                'input quotient representative')
        out = mv(P, w, p)
        require(combination(coordinate, frame, p) == out, 'output chart coordinates')
        outputs.append(out)
    matrix = [[coordinates[0][-2], coordinates[1][-2]],
              [coordinates[0][-1], coordinates[1][-1]]]
    require(certificate['projective_matrix'] == matrix == [[2, 1], [1, 1]],
            'projective matrix')
    determinant = (matrix[0][0]*matrix[1][1]-matrix[0][1]*matrix[1][0]) % p
    require(determinant == 1, 'rank-two transport')
    # The certified actual output squares are lambda=0 and lambda=4.
    for parameter, record in ((0, source['records'][8]), (4, source['records'][9])):
        R = record['relation']
        line = [(outputs[1][j]+parameter*outputs[0][j]) % p for j in range(2*N)]
        require(all(contains(R, r) for r in tall) and contains(R, line),
                'actual successor realization')
    return dict(internal_dimension=5, fixed_kernel_dimension=3, quotient_rank=2,
                matrix=matrix, determinant=determinant,
                finite_input_images=[1, 4, 0, 3, None], infinity_input_image=2,
                actual_input_parameters=[0, 4], actual_output_parameters=[1, None],
                all_abstract_lines=6, all_completions_reachable_claimed=False,
                original_source_max_index=source_summary['max_original_index'],
                elimination_used=False, state_recurrence_used=False)


def compare(certificate):
    """All six abstract completions at the fixed input; no reachability search."""
    from search.terminal_boundary_relation import BoundaryRelations, basis
    source = json.loads(SOURCE.read_text())
    engine = BoundaryRelations(5)
    F, L = source['records'][1]['relation'], source['intersection']
    P = maps(5, source['roots'], 62)[2]
    alpha, beta = [mv(P, w, 5) for w in certificate['quotient_preimages']]
    outputs = []
    for parameter in (None, 0, 1, 2, 3, 4):
        line = source['a'] if parameter is None else [
            (b+parameter*a) % 5 for a, b in zip(source['a'], source['b'])]
        image_line = alpha if parameter is None else [
            (b+parameter*a) % 5 for a, b in zip(alpha, beta)]
        output = engine.merge(126, (F, basis(L+[line], 5)))
        expected = basis(certificate['output_tall']+[image_line], 5)
        require(output == expected and len(output) == 4, 'whole pencil merge')
        outputs.append(output)
    require(len(set(outputs)) == 6, 'pencil bijection')
    require(tuple(map(tuple, certificate['output_wide'])) == engine.direct(126, 17, 18)[0]
            and tuple(map(tuple, certificate['output_tall'])) == engine.direct(126, 18, 17)[0],
            'original coefficient output borders')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--generate', action='store_true')
    parser.add_argument('--compare', action='store_true')
    parser.add_argument('--path', type=Path, default=DEFAULT)
    args = parser.parse_args()
    if args.generate:
        certificate = json.loads(json.dumps(generate()))
        verify(certificate)
        with args.path.open('x') as output:
            output.write(json.dumps(certificate, indent=2)+'\n')
    certificate = json.loads(args.path.read_text())
    summary = verify(certificate)
    if args.compare:
        compare(certificate)
    summary['all_six_merges_and_original_borders_compared'] = args.compare
    print(json.dumps(summary, indent=2))
