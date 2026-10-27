"""Five actual target discrepancies span F_5^4, even with fixed labels.

See results/2026-10-28-compatibility-affine-obstruction.md. This is a fixed
structural counterexample, not a witness search. The saved inverses can be
checked from original root sums without elimination or the state recurrence.
"""
import argparse
from itertools import permutations
import json
from math import prod
from pathlib import Path

from search.run_rank_experiments import oracle


P, N, H = 5, 4, 2
ROOTS, PRIMITIVE = (1, 2, 3, 4), (2, 3)
INPUTS = ((31, 4), (63, 4), (155, 6), (63, 8), (127, 8))
DEFAULT = Path('results/2026-10-28-compatibility-affine-check.json')


def require(condition, message):
    if not condition:
        raise ValueError(message)


def matvec(matrix, vector):
    return [sum(x*y for x, y in zip(row, vector)) % P for row in matrix]


def local_system(q, k, side):
    """Original parent parity rows, plus all-root moments, on (x,E) or (x,O).

    Parent (M,n)=(2q+1,2k+1). The four x coordinates are
    E(2),E(3),O(2),O(3); moments on {1,4} are fixed to {1/2,0}.
    side=0 uses odd parent rows and E; side=1 uses even rows and O.
    The opposite polynomial enters only through its two primitive moments.
    """
    require(side in (0, 1) and q >= 0 and k >= N, 'invalid local input')
    size = k+1-side
    other_size = k+side
    M, n = 2*q+1, 2*k+1
    rows, rhs = [], []
    for ell in range(size):
        parent_row = 2*ell+1+side
        exponent = q+1+ell
        row = [0]*N
        for j, z in enumerate(PRIMITIVE):
            row[(1-side)*H+j] = pow(H, -1, P)*pow(z, exponent, P) % P
        row += [oracle('lai_sprang', P, M+parent_row+2*j+side)
                * pow(H, -1, P) % P for j in range(size)]
        # Entrywise check of the eliminated opposite-parity block against the
        # original rational root sums; no recurrence or invisible-vector input.
        for j in range(other_size):
            original = oracle('lai_sprang', P, M+parent_row+2*j+1-side)
            require(original == sum(pow(z, exponent+j, P) for z in PRIMITIVE) % P,
                    'opposite parity identity')
        rows.append(row)
        rhs.append(0)
    for z in ROOTS:
        row = [0]*N
        if z in PRIMITIVE:
            row[side*H+PRIMITIVE.index(z)] = P-1
        rows.append(row+[pow(z, j, P) for j in range(size)])
        rhs.append(pow(2, -1, P) if z == 1 else 0)
    require(len(rows) == len(rows[0]) == N+size, 'non-square local system')
    return rows, rhs


def inverse(matrix):
    """Certificate generation only. Verification checks both matrix products."""
    n = len(matrix)
    a = [row[:]+[int(i == j) for j in range(n)] for i, row in enumerate(matrix)]
    for j in range(n):
        pivot = next(i for i in range(j, n) if a[i][j] % P)
        a[j], a[pivot] = a[pivot], a[j]
        a[j] = [x*pow(a[j][j], -1, P) % P for x in a[j]]
        for i in range(n):
            if i != j:
                scale = a[i][j]
                a[i] = [(x-scale*y) % P for x, y in zip(a[i], a[j])]
    return [row[n:] for row in a]


def determinant(matrix):
    """Independent Leibniz expansion, only for the 4- and 5-dimensional proof."""
    n = len(matrix)
    return sum((-1)**sum(s[i] > s[j] for i in range(n) for j in range(i+1, n))
               * prod(matrix[i][s[i]] for i in range(n))
               for s in permutations(range(n))) % P


def generate():
    records = []
    for q, k in INPUTS:
        children = []
        for side in (0, 1):
            matrix, rhs = local_system(q, k, side)
            inv = inverse(matrix)
            solution = matvec(inv, rhs)
            children.append(dict(inverse=inv, point=solution[:N],
                                 polynomial=solution[N:]))
        delta = [(y-x) % P for x, y in zip(children[0]['point'], children[1]['point'])]
        records.append(dict(q=q, k=k, children=children, difference=delta))
    differences = [r['difference'] for r in records]
    return dict(p=P, N=N, root_order=ROOTS, primitive_order=PRIMITIVE,
                digit=[1, 1], records=records,
                linear_determinant=determinant([differences[i] for i in (0, 1, 2, 4)]),
                affine_determinant=determinant([d+[1] for d in differences]))


def verify(certificate):
    """Check fixed inputs, ten explicit inverses and affine span, without solving."""
    require((certificate['p'], certificate['N']) == (P, N), 'field')
    require(tuple(certificate['root_order']) == ROOTS, 'root order')
    require(tuple(certificate['primitive_order']) == PRIMITIVE, 'primitive order')
    require(certificate['digit'] == [1, 1], 'digit')
    # Discrete Fourier interpolation realizes every prescribed root-moment
    # vector in degree < N, hence within either opposite parity length k>=N.
    for i in range(N):
        for j in range(N):
            require(sum(pow(z, i-j, P) for z in ROOTS)*pow(N, -1, P) % P
                    == int(i == j), 'root interpolation')
    records = certificate['records']
    require(tuple((r['q'], r['k']) for r in records) == INPUTS, 'input completeness')
    differences, endpoints = [], []
    for record in records:
        q, k = record['q'], record['k']
        require((q % N, min(k, N), k % 2) == (3, N, 0), 'discrete labels')
        children = record['children']
        require(len(children) == 2, 'two children')
        for side, child in enumerate(children):
            matrix, rhs = local_system(q, k, side)
            inv, size = child['inverse'], len(matrix)
            require(len(inv) == size and all(len(row) == size for row in inv), 'inverse size')
            require(all(type(x) is int and 0 <= x < P for row in inv for x in row),
                    'inverse residues')
            for a, b in ((matrix, inv), (inv, matrix)):
                for i in range(size):
                    for j in range(size):
                        require(sum(a[i][ell]*b[ell][j] for ell in range(size)) % P
                                == int(i == j), 'inverse identity')
            solution = child['point']+child['polynomial']
            require(len(child['point']) == N and len(solution) == size, 'solution size')
            require(all(type(x) is int and 0 <= x < P for x in solution), 'solution residues')
            require(matvec(matrix, solution) == rhs, 'original local equations')
            require(matvec(inv, rhs) == solution, 'unique local solution')
        delta = [(y-x) % P for x, y in zip(children[0]['point'], children[1]['point'])]
        require(record['difference'] == delta, 'difference')
        differences.append(delta)
        endpoints.append(2*q+4*k+2)  # inclusive original parent stream index
    linear = determinant([differences[i] for i in (0, 1, 2, 4)])
    affine = determinant([d+[1] for d in differences])
    require(linear == certificate['linear_determinant'] == 3, 'linear span')
    require(affine == certificate['affine_determinant'] == 1, 'affine span')
    return dict(records=len(records), inverse_identities=2*2*len(records),
                linear_rank=N, affine_dimension=N, max_original_index=max(endpoints),
                readback_elimination_used=False, readback_recurrence_used=False)


def compare_reduced(certificate):
    """Separate regression: the existing reduced recurrence has the same slices."""
    from search.four_square_state import FourSquareStates
    from search.terminal_target_preimage import target_preimage
    machine = FourSquareStates(P)
    for record in certificate['records']:
        state = machine.evaluate(record['q'], record['k'])
        reduced = target_preimage(machine, state, 1, 1)
        require(reduced['point'] is None and reduced['quotient_dimension'] == N,
                'full-dimensional nonzero obstruction')
        for actual, saved in zip(reduced['slices'], record['children']):
            require(not actual['directions'] and list(actual['point']) == saved['point'],
                    'reduced slice disagrees with original system')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--generate', action='store_true')
    parser.add_argument('--check-reduced', action='store_true')
    parser.add_argument('--path', type=Path, default=DEFAULT)
    args = parser.parse_args()
    if args.generate:
        certificate = generate()
        verify(certificate)
        with args.path.open('x') as output:
            output.write(json.dumps(certificate, indent=2)+'\n')
    certificate = json.loads(args.path.read_text())
    summary = verify(certificate)
    if args.check_reduced:
        compare_reduced(certificate)
    summary['reduced_slices_compared'] = args.check_reduced
    print(json.dumps(summary, indent=2))
