"""The same corner line in both odd-parent children gives a conic.

Ordinary all-prime proof: results/2026-11-04-simultaneous-corner.md.
This fixed F_5 certificate reuses the 1 November inputs. Readback needs no
elimination or recurrence. Abstract pencil completions need not be reachable.
"""
import argparse
import hashlib
import json
from pathlib import Path

from search.corner_response_obstruction import (
    DEFAULT as SOURCE, contains, original_system, require, verify as verify_source,
)
from search.compatibility_profile_obstruction import echelon, vector
from search.odd_corner_transport import check_rank, mv, pull, rank_record


DEFAULT = Path('results/2026-11-04-simultaneous-corner-check.json')
ACTUAL = ((125, 17, 3), (253, 17, 3))


def maps(p, roots, q):
    """M0,M1,P for odd start t=2q+3, ordered by row parity."""
    N = len(roots)
    index = {z: i for i, z in enumerate(roots)}
    children = []
    for a in (0, 1):
        M = [[0]*(3*N) for _ in range(2*N)]
        for j, z in enumerate(roots):
            M[index[z*z % p]][j] = pow(z, a, p)
            M[N+j][N*(2-a)+j] = 1
            if pow(z, N//2, p) == p-1:
                M[j][N*(1+a)+j] = -pow(z, q+1+a, p)*pow(N//2, -1, p) % p
        children.append(M)
    P = [[0]*(3*N) for _ in range(2*N)]
    for j, z in enumerate(roots):
        P[j][j] = 1
        P[N+j][N+index[z*z % p]] = 1
        P[N+j][2*N+index[z*z % p]] = z
    return (*children, P)


def generate():
    from search.terminal_boundary_relation import basis, null
    from search.compatibility_profile_obstruction import solve
    source = json.loads(SOURCE.read_text())
    verify_source(source)
    L, W = source['intersection'], source['sum']
    M0, M1, P = maps(5, source['roots'], 62)
    dualW, dualL = basis(null(W, 8, 5), 5), null(L, 8, 5)
    constraints = pull(dualW, M0, 5)+pull(dualW, M1, 5)
    Q = pull(dualL, M0, 5)+pull(dualL, M1, 5)
    internal_core = basis(null(constraints+Q, 12, 5), 5)
    core = basis([mv(P, w, 5) for w in internal_core], 5)

    def solve_checked(A, rhs):
        w, failure = solve(A, rhs)
        require(w is not None and failure is None, 'generation lift')
        return w

    core_lifts = [solve_checked(constraints+Q+P, [0]*(len(constraints)+len(Q))+list(r))
                  for r in core]
    quotient_lifts = []
    for name, side in (('a', 0), ('a', 1), ('b', 0), ('b', 1)):
        rhs = [0]*len(constraints)
        for j in (0, 1):
            rhs += mv(dualL, source[name], 5) if side == j else [0]*len(dualL)
        quotient_lifts.append(solve_checked(constraints+Q, rhs))
    outputs = [mv(P, w, 5) for w in quotient_lifts]
    actual = []
    for parameter, case in zip((0, 4), ACTUAL):
        lines = [[(outputs[2+j][i]+parameter*outputs[j][i]) % 5
                  for i in range(8)] for j in (0, 1)]
        R = basis(list(core)+lines, 5)
        rows, moments, _ = original_system(*case)
        n = len(rows)
        fixed_u = [[int(i == j) for i in range(4+n)] for j in range(4)]
        fixed_v = [[0]*4+v for v in moments]
        preimages = [solve_checked(rows+fixed_u+fixed_v, [0]*n+list(r))[4:] for r in R]
        actual.append(dict(case=case, parameter=parameter, relation=R,
                           preimages=preimages, row_rank=rank_record(rows, 5)))
    return dict(source_sha256=hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
                context=dict(p=5, q=62, k=8), wide_annihilator=dualW,
                constraints_rank=rank_record(constraints, 5), output_core=core,
                core_preimages=core_lifts, quotient_preimages=quotient_lifts,
                quotient_outputs=outputs, output_rank=rank_record(list(core)+outputs, 5),
                actual=actual)


def verify(certificate):
    """Rank-four quotient proof using dot products and inverse minors only."""
    require(certificate['source_sha256'] == hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
            'source digest')
    source_summary = verify_source(json.loads(SOURCE.read_text()))
    source = json.loads(SOURCE.read_text())
    require(certificate['context'] == dict(p=5, q=62, k=8), 'context')
    L, W = source['intersection'], source['sum']
    M0, M1, P = maps(5, source['roots'], 62)
    dual = certificate['wide_annihilator']
    echelon(dual, 8)
    require(len(dual) == 3 and all(not any(mv(dual, r, 5)) for r in W),
            'complete wide annihilator')
    constraints = pull(dual, M0, 5)+pull(dual, M1, 5)
    check_rank(constraints, certificate['constraints_rank'], 5)
    # Six independent equations in twelve variables give dim S_W=6.
    core, outputs = certificate['output_core'], certificate['quotient_outputs']
    echelon(core, 8)
    require(len(core) == len(certificate['core_preimages']) == 2, 'core dimension')
    require(len(outputs) == len(certificate['quotient_preimages']) == 4,
            'four quotient lifts')
    for r, w in zip(core+outputs,
                    certificate['core_preimages']+certificate['quotient_preimages']):
        vector(r, 8)
        vector(w, 12)
        require(contains(W, mv(M0, w, 5)) and contains(W, mv(M1, w, 5)), 'lift in S_W')
        require(mv(P, w, 5) == r, 'output projection')
    check_rank(core+outputs, certificate['output_rank'], 5)
    # Six independent outputs prove P injective, with no binomial theorem assumed.
    for w in certificate['core_preimages']:
        require(contains(L, mv(M0, w, 5)) and contains(L, mv(M1, w, 5)), 'core kernel')
    for w, (name, side) in zip(certificate['quotient_preimages'],
                               (('a', 0), ('a', 1), ('b', 0), ('b', 1))):
        for j, M in enumerate((M0, M1)):
            expected = source[name] if side == j else [0]*8
            require(contains(L, [(x-y) % 5 for x, y in zip(mv(M, w, 5), expected)]),
                    'input quotient coordinates')
    # Quotient images are the four standard basis vectors. Thus S_L has
    # dimension two and these are full quotient isomorphisms, not fitted values.
    require(len(certificate['actual']) == 2, 'actual case completeness')
    endpoints = []
    for record, case, parameter in zip(certificate['actual'], ACTUAL, (0, 4)):
        require(tuple(record['case']) == case and record['parameter'] == parameter,
                'actual case')
        rows, moments, endpoint = original_system(*case)
        R, n = record['relation'], len(rows)
        echelon(R, 8)
        require(len(R) == len(record['preimages']) == 4, 'actual relation dimension')
        for r, x in zip(R, record['preimages']):
            vector(x, n)
            require(not any(mv(rows, list(r[:4])+x, 5)), 'original coefficient equations')
            require(mv(moments, x, 5) == r[4:], 'original moments')
        check_rank(rows, record['row_rank'], 5)
        require(all(contains(R, r) for r in core), 'actual common core')
        require(all(contains(R, [(outputs[2+j][i]+parameter*outputs[j][i]) % 5
                                 for i in range(8)]) for j in (0, 1)),
                'actual conic realization')
        endpoints.append(endpoint)
    return dict(internal_dimension=6, common_core_dimension=2, quotient_rank=4,
                plucker_coordinate_order=['01', '02', '03', '12', '13', '23'],
                plucker_formula=['s^2', '0', 's*t', '-s*t', '0', 't^2'],
                actual_parameters=[0, 4], actual_original_endpoints=endpoints,
                inherited_original_max_index=source_summary['max_original_index'],
                all_completions_reachable_claimed=False, elimination_used=False,
                state_recurrence_used=False)


def compare(certificate):
    """All six abstract lines; actual wide/tall parents from original coefficients."""
    from search.terminal_boundary_relation import BoundaryRelations, basis
    source = json.loads(SOURCE.read_text())
    E = BoundaryRelations(5)
    L, core = source['intersection'], certificate['output_core']
    a0, a1, b0, b1 = certificate['quotient_outputs']
    outputs = []
    for parameter in (None, 0, 1, 2, 3, 4):
        line = source['a'] if parameter is None else [
            (b+parameter*a) % 5 for a, b in zip(source['a'], source['b'])]
        C = basis(L+[line], 5)
        lines = [a0, a1] if parameter is None else [
            [(b+parameter*a) % 5 for a, b in zip(x, y)]
            for x, y in ((a0, b0), (a1, b1))]
        output = E.merge(127, (C, C))
        require(output == basis(core+lines, 5) and len(output) == 4, 'whole conic merge')
        outputs.append(output)
    require(len(set(outputs)) == 6, 'conic injectivity')
    require(basis(core+[a0, a1, b0, b1], 5) == E.direct(127, 16, 18)[0], 'wide parent')
    require(tuple(map(tuple, core)) == E.direct(127, 18, 16)[0], 'tall parent')
    for record, (q, k, _) in zip(certificate['actual'], ACTUAL):
        require(tuple(map(tuple, record['relation'])) == E.direct(q+2, k+1, k+1)[0],
                'actual independent direct comparison')


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
