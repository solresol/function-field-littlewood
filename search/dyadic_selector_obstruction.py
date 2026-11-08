"""Integer obstruction to extending the F_5 selector across N=4 primes.

Proof/scope: results/2026-11-09-selector-specialization.md.  No word search.
Readback needs only the standard library and does not use elimination or the
state recurrence. Optional regeneration uses the already installed SymPy.
"""
import argparse
from functools import reduce
import hashlib
import json
from math import gcd
from pathlib import Path

from search.terminal_prime_obstruction import formal_series


DEFAULT = Path('results/2026-11-09-selector-integer-check.json')
SOURCE = Path('results/2026-11-06-corner-terminal-check.json')
WORD = ((1, 1), (0, 1), (0, 1), (0, 0), (1, 0))
CONTEXTS = ((2001, 5), (4049, 1))
N, SIZE = 4, 284


def require(condition, message):
    if not condition:
        raise ValueError(message)


def integer_system(q, coefficients):
    """A s=b: SIZE zero Hankel rows, then residue sums all equal to one.

    For odd fields with four distinct fourth roots, scale the usual terminal
    polynomial by 4: its root moments become 4 at 1 and 0 elsewhere, exactly
    the residue-sum conditions below. The coefficient endpoint is q+2*SIZE-1.
    """
    A = [[coefficients[q+1+i+j] for j in range(SIZE)] for i in range(SIZE)]
    A += [[int(j % N == a) for j in range(SIZE)] for a in range(N)]
    return A, [0]*SIZE+[1]*N


def verify(data):
    """Check integer identities directly from the generating series expansion."""
    require(data['N'] == N and data['size'] == SIZE, 'fixed scale and size')
    require(data['word'] == [list(digit) for digit in WORD], 'fixed continuation')
    require([(r['q'], r['pairing']) for r in data['records']] == list(CONTEXTS),
            'two prescribed contexts and exact obstruction constants')
    summaries = []
    for record in data['records']:
        q, expected = record['q'], record['pairing']
        endpoint = q+2*SIZE-1
        require(record['endpoint_inclusive'] == endpoint, 'inclusive endpoint')
        coefficients = formal_series(N, endpoint)
        A, b = integer_system(q, coefficients)
        y = record['dual']
        require(len(y) == SIZE+N and all(type(x) is int for x in y), 'integer dual')
        require(all(sum(y[i]*A[i][j] for i in range(SIZE+N)) == 0
                    for j in range(SIZE)), 'integer left annihilator')
        require(sum(x*z for x, z in zip(y, b)) == expected, 'integer target pairing')
        summaries.append(dict(q=q, rows=SIZE+N, columns=SIZE,
                              pairing=expected, endpoint_inclusive=endpoint))

    # Sufficiency in characteristic 5, independent of the earlier verifier.
    x = data['characteristic_five_primal']
    require(len(x) == SIZE and all(type(a) is int and 0 <= a < 5 for a in x),
            'characteristic-five primal')
    A, b = integer_system(2001, formal_series(N, 2001+2*SIZE-1))
    require(all(sum(a*z for a, z in zip(row, x)) % 5 == value
                for row, value in zip(A, b)), 'characteristic-five solution')
    require(x[0] != 0 and x[-1] != 0, 'retained endpoint admissibility')
    return dict(records=summaries, characteristic_five_primal=True,
                conclusion='N=4: first ray state accepts this word iff p=5; stable state never accepts')


def bezout(a, b):
    """Signed exact Euclidean identity; generation only."""
    old_r, r, old_s, s, old_t, t = a, b, 1, 0, 0, 1
    while r:
        quotient = old_r//r
        old_r, r = r, old_r-quotient*r
        old_s, s = s, old_s-quotient*s
        old_t, t = t, old_t-quotient*t
    return ((old_r, old_s, old_t) if old_r >= 0
            else (-old_r, -old_s, -old_t))


def generate():
    """Two prescribed integer kernel computations, not prime/word enumeration.

    Nullspaces in opposite row orders supply different integer sublattices.
    Their combined target-pairing gcd is small. HNF and elementary size
    reductions shorten the certificate; none of these operations is trusted
    by verify(), which checks every final integer identity anew.
    """
    from sympy import Matrix, ZZ
    from sympy.matrices.normalforms import hermite_normal_form
    from sympy.polys.matrices import DomainMatrix
    from search.lai_sprang_sharpness import normalized

    records = []
    for q, expected in CONTEXTS:
        endpoint = q+2*SIZE-1
        coefficients = [0]+[normalized(N, i) for i in range(1, endpoint+1)]
        A, b = integer_system(q, coefficients)
        vectors = []
        for order in (list(range(len(A))), list(reversed(range(len(A))))):
            K = DomainMatrix.from_list([A[i] for i in order], ZZ).transpose().nullspace()
            for row in K.to_list():
                divisor = reduce(gcd, row)
                w = [0]*len(A)
                for i, x in zip(order, row):
                    w[i] = int(x//divisor)
                vectors.append(w)
        lattice = hermite_normal_form(Matrix(vectors).T).T
        vectors = [list(map(int, row)) for row in lattice.tolist()]

        def dot(a, b):
            return sum(x*y for x, y in zip(a, b))

        for _ in range(1000):
            vectors.sort(key=lambda row: dot(row, row))
            changed = False
            for i in range(1, len(vectors)):
                for j in range(i-1, -1, -1):
                    a, d = dot(vectors[i], vectors[j]), dot(vectors[j], vectors[j])
                    quotient = (2*a+d)//(2*d)
                    if quotient:
                        vectors[i] = [x-quotient*y for x, y in zip(vectors[i], vectors[j])]
                        changed = True
            if not changed:
                break
        else:
            raise RuntimeError('certificate size reduction exceeded its bound')
        common, y = 0, [0]*len(A)
        for row in vectors:
            common, s, t = bezout(common, dot(row, b))
            y = [s*x+t*z for x, z in zip(y, row)]
        require(common == expected, 'generated exact pairing gcd')
        records.append(dict(q=q, pairing=common, endpoint_inclusive=endpoint, dual=y))

    source = SOURCE.read_bytes()
    primal = json.loads(source)['actual'][0]
    require((primal['q'], primal['k']) == (2001, SIZE), 'earlier primal context')
    data = dict(N=N, size=SIZE, word=[list(d) for d in WORD], records=records,
                characteristic_five_primal=[N*x % 5 for x in primal['primal']],
                primal_source_sha256=hashlib.sha256(source).hexdigest())
    verify(data)
    return data


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--path', type=Path, default=DEFAULT)
    parser.add_argument('--generate', action='store_true')
    args = parser.parse_args()
    if args.generate:
        data = generate()
        with args.path.open('x') as stream:
            json.dump(data, stream, indent=2)
            stream.write('\n')
    else:
        data = json.loads(args.path.read_text())
    print(json.dumps(verify(data), indent=2))


if __name__ == '__main__':
    main()
