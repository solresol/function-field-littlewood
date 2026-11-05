"""A shared suffix selects one missing-corner line in the fixed F_5 pair.

See results/2026-11-06-corner-terminal-selector.md.  The unrolled response
keeps nine independent boundary ports, all constrained by the SAME line.
Generation uses elimination. Readback checks linear primal/dual identities
and a polynomial Bezout identity, without solving or state recursion.
Other abstract completions are not asserted to be reachable stream states.
"""
import argparse
import hashlib
import json
from pathlib import Path

from search.corner_response_obstruction import (
    DEFAULT as SOURCE, contains, require, verify as verify_source,
)
from search.compatibility_profile_obstruction import current_system, echelon, vector
from search.odd_corner_transport import check_rank, maps as even_maps, mv, rank_record
from search.simultaneous_corner_transport import maps as odd_maps


DEFAULT = Path('results/2026-11-06-corner-terminal-check.json')
WORD = ((1, 1), (0, 1), (0, 1), (0, 0), (1, 0))
ROOT = (2002, 284, 284, 5)  # start t, rows, columns, recursion depth
FINAL = ((2001, 284), (4049, 284))
TARGET = [0, 0, 0, 0, 1, 0, 0, 0]


def polynomial(a):
    a = [x % 5 for x in a]
    while a and not a[-1]:
        a.pop()
    return tuple(a)


def add(a, b):
    return polynomial([(a[i] if i < len(a) else 0)
                       + (b[i] if i < len(b) else 0)
                       for i in range(max(len(a), len(b)))])


def multiply(a, b):
    c = [0]*(len(a)+len(b))
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            c[i+j] += x*y
    return polynomial(c)


def determinant(A):
    """Small polynomial determinant by the defining expansion, no division."""
    if len(A) == 1:
        return polynomial(A[0][0])
    result = ()
    for j, value in enumerate(A[0]):
        if polynomial(value):
            term = multiply(value, determinant([r[:j]+r[j+1:] for r in A[1:]]))
            result = add(result, [(-1)**j*x for x in term])
    return result


def children(context):
    t, m, n, depth = context
    return tuple(((t+a+(t+a) % 2)//2, (m+1-a)//2,
                  (n+1-(t+a) % 2)//2, depth-1) for a in (0, 1))


def merge_matrices(t, port_counts):
    """Unprojected parity maps, with all child ports carried independently."""
    roots = (1, 2, 3, 4)
    maps = (even_maps(5, roots, t//2-1) if t % 2 == 0
            else odd_maps(5, roots, (t-3)//2))
    sizes = [2*x for x in port_counts]
    width = 12+sum(sizes)
    inputs = []
    for j, M in enumerate(maps[:2]):
        extended = [r+[0]*sum(sizes) for r in M]
        for i in range(sizes[j]):
            r = [0]*width
            r[12+(sizes[0] if j else 0)+i] = 1
            extended.append(r)
        inputs.append(extended)
    output = [r+[0]*sum(sizes) for r in maps[2]]
    for i in range(sum(sizes)):
        r = [0]*width
        r[12+i] = 1
        output.append(r)
    return inputs, output


def constraints(child_records, inputs):
    return [mv(list(zip(*M)), h, 5)
            for record, M in zip(child_records, inputs) for h in record['annihilator']]


def leaf_vectors(context, source):
    t, m, n, depth = context
    require(depth == 0, 'leaf depth')
    if (t, m, n) == (64, 9, 9):
        return ([r+[0, 0] for r in source['intersection']]
                + [source['a']+[1, 0], source['b']+[0, 1]]), 1
    fixed = {(63, 9, 9): source['records'][1]['relation'],
             (64, 8, 9): source['sum'], (64, 9, 8): source['intersection']}
    require((t, m, n) in fixed, 'prescribed fixed leaf')
    return fixed[t, m, n], 0


def parameter_system(point, directions, parameter):
    """alpha=lambda*beta, or beta=0 at infinity, at EVERY port."""
    def entry(row, i):
        return (row[2*i+1] if parameter is None
                else (row[2*i]-parameter*row[2*i+1]) % 5)
    return ([[entry(r, i) for r in directions] for i in range(len(point)//2)],
            [-entry(point, i) % 5 for i in range(len(point)//2)])


def generate():
    from search.terminal_boundary_relation import basis, null
    from search.compatibility_profile_obstruction import solve
    source = json.loads(SOURCE.read_text())
    verify_source(source)
    nodes, memo = [], {}

    def solved(A, rhs):
        x, dual = solve(A, rhs)
        require(x is not None and dual is None, 'generation linear lift')
        return x

    def build(context):
        if context in memo:
            return memo[context]
        node = dict(context=context)
        if context[-1] == 0:
            rows, count = leaf_vectors(context, source)
            R = basis(rows, 5)
        else:
            indices = [build(c) for c in children(context)]
            child_records = [nodes[i] for i in indices]
            count = sum(r['ports'] for r in child_records)
            inputs, P = merge_matrices(context[0], [r['ports'] for r in child_records])
            B = constraints(child_records, inputs)
            R = basis([mv(P, w, 5) for w in null(B, len(P[0]), 5)], 5)
            node.update(children=indices,
                        preimages=[solved(B+P, [0]*len(B)+list(r)) for r in R])
        H = basis(null(R, 8+2*count, 5), 5)
        node.update(ports=count, relation=R, annihilator=H)
        if context[-1] != 0:
            node['duals'] = [solved(list(zip(*B)), mv(list(zip(*P)), h, 5)) for h in H]
        memo[context] = len(nodes)
        nodes.append(node)
        return memo[context]

    root = build(ROOT)
    R = nodes[root]['relation']
    boundary = list(zip(*[r[:8] for r in R]))
    ports = list(zip(*[r[8:] for r in R]))
    point_weights = solved(boundary, TARGET)
    point = mv(ports, point_weights, 5)
    directions = basis([mv(ports, w, 5) for w in null(boundary, len(R), 5)], 5)
    direction_weights = [solved(boundary+ports, [0]*8+list(r)) for r in directions]
    zero_A, zero_b = parameter_system(point, directions, 0)
    inf_A, inf_b = parameter_system(point, directions, None)
    _, inf_dual = solve(inf_A, inf_b)
    require(inf_dual is not None, 'infinity inconsistency')
    actual = []
    for q, k in FINAL:
        A, rhs = current_system(q, k)
        primal, dual = solve(A, rhs)
        actual.append(dict(q=q, k=k, primal=primal, dual=dual))
    return dict(source_sha256=hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
                word=WORD, nodes=nodes, root=root,
                slice=dict(point=point, point_weights=point_weights,
                           directions=directions, direction_weights=direction_weights,
                           boundary_rank=rank_record(boundary, 5)),
                bezout=[dict(rows=[0, 1, 2, 3, 4, 5], multiplier=[3, 1, 4, 4, 4]),
                        dict(rows=[0, 1, 2, 3, 4, 6], multiplier=[4, 0, 4, 3, 3])],
                zero_solution=solved(zero_A, zero_b), infinity_dual=inf_dual,
                actual=actual)


def check_annihilator(R, H, width):
    echelon(R, width)
    echelon(H, width)
    require(len(R)+len(H) == width, 'annihilator dimension')
    require(all(not any(mv(H, r, 5)) for r in R), 'annihilator products')


def verify(certificate):
    """Independent exact readback: linear identities and polynomial arithmetic."""
    require(certificate['source_sha256'] == hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
            'source digest')
    source = json.loads(SOURCE.read_text())
    source_summary = verify_source(source)
    require(tuple(map(tuple, certificate['word'])) == WORD, 'shared word')
    nodes = certificate['nodes']
    require(type(certificate['root']) is int and certificate['root'] == len(nodes)-1,
            'root index')
    seen = set()
    for i, node in enumerate(nodes):
        context = tuple(node['context'])
        require(len(context) == 4 and all(type(x) is int and x >= 0 for x in context)
                and context not in seen, 'node context')
        seen.add(context)
        R, H, count = node['relation'], node['annihilator'], node['ports']
        require(type(count) is int and 0 <= count <= 9, 'port count')
        check_annihilator(R, H, 8+2*count)
        if context[-1] == 0:
            expected, expected_count = leaf_vectors(context, source)
            require(count == expected_count and len(R) == len(expected)
                    and all(contains(R, r) for r in expected), 'complete leaf response')
            continue
        indices = node['children']
        require(len(indices) == 2 and all(type(j) is int and 0 <= j < i for j in indices),
                'acyclic child indices')
        records = [nodes[j] for j in indices]
        require(tuple(tuple(r['context']) for r in records) == children(context),
                'exact child offsets')
        require(count == sum(r['ports'] for r in records), 'independent child ports')
        inputs, P = merge_matrices(context[0], [r['ports'] for r in records])
        B = constraints(records, inputs)
        require(len(node['preimages']) == len(R), 'response preimage completeness')
        for r, w in zip(R, node['preimages']):
            vector(w, len(P[0]))
            require(not any(mv(B, w, 5)) and mv(P, w, 5) == r, 'response primal')
        require(len(node['duals']) == len(H), 'response dual completeness')
        for h, weights in zip(H, node['duals']):
            vector(weights, len(B))
            require(mv(list(zip(*B)), weights, 5) == mv(list(zip(*P)), h, 5),
                    'response dual')
    top = nodes[-1]
    require(tuple(top['context']) == ROOT and top['ports'] == 9
            and len(top['relation']) == 13, 'root response')
    # All nodes must contribute to the fixed root, rather than certifying
    # irrelevant independent records.
    used = set()
    def visit(i):
        if i not in used:
            used.add(i)
            for j in nodes[i].get('children', []):
                visit(j)
    visit(len(nodes)-1)
    require(len(used) == len(nodes), 'root-connected response')
    R, section = top['relation'], certificate['slice']
    boundary = list(zip(*[r[:8] for r in R]))
    ports = list(zip(*[r[8:] for r in R]))
    check_rank(boundary, section['boundary_rank'], 5)
    point, directions = section['point'], section['directions']
    vector(point, 18)
    echelon(directions, 18)
    require(len(directions) == len(section['direction_weights']) == 5,
            'complete affine directions')
    for weights, out, value in [(section['point_weights'], TARGET, point)]+[
            (w, [0]*8, r) for w, r in zip(section['direction_weights'], directions)]:
        vector(weights, 13)
        require(mv(boundary, weights, 5) == out and mv(ports, weights, 5) == value,
                'affine response lift')
    # Rank(boundary)=8 and dim R=13: its kernel has dimension 5.
    # Five independent projected directions prove that this is the FULL slice.
    augmented = [[polynomial((r[2*i], -r[2*i+1])) for r in directions+[point]]
                 for i in range(9)]
    require(len(certificate['bezout']) == 2, 'two-minor identity')
    total, minors = (), []
    for record in certificate['bezout']:
        indices = record['rows']
        require(len(indices) == 6 and len(set(indices)) == 6
                and all(type(j) is int and 0 <= j < 9 for j in indices), 'minor rows')
        vector(record['multiplier'], 5)
        minor = determinant([augmented[j] for j in indices])
        minors.append(list(minor))
        total = add(total, multiply(record['multiplier'], minor))
    require(total == (0, 1), 'polynomial Bezout identity equals X')
    A, rhs = parameter_system(point, directions, 0)
    vector(certificate['zero_solution'], 5)
    require(mv(A, certificate['zero_solution'], 5) == rhs, 'zero parameter feasible')
    A, rhs = parameter_system(point, directions, None)
    vector(certificate['infinity_dual'], 9)
    require(not any(mv(list(zip(*A)), certificate['infinity_dual'], 5))
            and sum(a*b for a, b in zip(certificate['infinity_dual'], rhs)) % 5 != 0,
            'infinity rejected')
    require(len(certificate['actual']) == 2, 'actual case completeness')
    endpoints = []
    for record, pair, accepted in zip(certificate['actual'], FINAL, (True, False)):
        require((record['q'], record['k']) == pair, 'actual terminal input')
        q, k = pair
        A, rhs = current_system(q, k)
        if accepted:
            x = record['primal']
            vector(x, k)
            require(record['dual'] is None and x[0] != 0 and x[-1] != 0
                    and mv(A, x, 5) == rhs, 'original terminal primal')
        else:
            weights = record['dual']
            vector(weights, len(A))
            require(record['primal'] is None
                    and not any(mv(list(zip(*A)), weights, 5))
                    and sum(a*b for a, b in zip(weights, rhs)) % 5 != 0,
                    'original terminal dual')
        endpoints.append(q+2*k-1)
    for initial, expected in zip((62, 126), FINAL):
        q, k = initial, 8
        for epsilon, eta in WORD:
            q, k = 2*q+epsilon, 2*k+eta
        require((q, k) == expected, 'actual shared continuation')
    return dict(initial_seven_relations_equal=source_summary['initial_seven_relations_equal'],
                actual_initial_parameters=[0, 4], word=WORD, final_inputs=FINAL,
                actual_terminal_outputs=[True, False], terminal_language_separation_proved=True,
                response_nodes=len(nodes), independent_ports=9, affine_slice_dimension=5,
                minor_polynomials=minors, bezout_sum=[0, 1],
                unique_homogeneous_parameter=[0, 1],
                selector_valid_over_every_F5_extension=True,
                original_coefficient_endpoints=endpoints,
                abstract_completions_reachable_claimed=False,
                elimination_used=False, state_recurrence_used=False)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--generate', action='store_true')
    parser.add_argument('--path', type=Path, default=DEFAULT)
    args = parser.parse_args()
    if args.generate:
        certificate = json.loads(json.dumps(generate()))
        verify(certificate)
        with args.path.open('x') as output:
            output.write(json.dumps(certificate, indent=2)+'\n')
    print(json.dumps(verify(json.loads(args.path.read_text())), indent=2))
