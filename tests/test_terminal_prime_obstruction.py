import copy
import itertools
import json
from math import gcd
from pathlib import Path
import unittest
from unittest.mock import patch

from search.run_rank_experiments import oracle
from search.terminal_prime_obstruction import (
    formal_series, normalized_coefficient, parameters, rational_determinant, verify,
)


class PrimeObstructionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data = json.loads(Path('results/2026-10-12-prime-obstruction.json').read_text())

    def test_complete_certificate_without_generation_code(self):
        with patch('search.terminal_prime_obstruction._Affine', side_effect=AssertionError), \
             patch('search.terminal_prime_obstruction.integer_matrix', side_effect=AssertionError), \
             patch('search.terminal_prime_obstruction.normalized_coefficient', side_effect=AssertionError), \
             patch('search.terminal_prime_obstruction.determinant', side_effect=AssertionError):
            result = verify(self.data)
        self.assertEqual([s['cases'] for s in result['scales']], [152, 624, 2528])
        self.assertEqual(sum(s['minors'] for s in result['scales']), 4362)

    def test_corrupt_certificates_are_rejected(self):
        mutations = (
            lambda d: d['scales'].pop(),
            lambda d: d['scales'][0]['records'].pop(),
            lambda d: d['scales'][0]['records'][0].update(M=1),
            lambda d: d['scales'][0]['records'][0].update(x=0),
            lambda d: d['scales'][0]['records'][0].update(common_divisor=0),
            lambda d: d['scales'][0]['records'][0].update(minors=[]),
            lambda d: d['scales'][0]['records'][0]['minors'][0].update(determinant=0),
            lambda d: d['scales'][0]['records'][0]['minors'][0].update(rows=[1, 1, 2]),
            lambda d: d['scales'][0]['records'][0]['minors'][0].update(rows=[1, 2, 7]),
        )
        for mutation in mutations:
            data = copy.deepcopy(self.data)
            mutation(data)
            with self.assertRaises(AssertionError):
                verify(data)

    def test_formal_expansion_matches_original_root_sums(self):
        for N, primes in ((4, (5, 13)), (8, (41,)), (16, (17,))):
            H, _, T, _, period = parameters(N)
            a = formal_series(N, period-1+T)
            for n in range(1, len(a)):
                self.assertEqual(a[n], normalized_coefficient(N, n))
                for p in primes:
                    self.assertEqual(H*a[n] % p, oracle('lai_sprang', p, n))

    def test_wrong_characteristic_is_a_real_rank_failure(self):
        a = formal_series(4, 15)
        A = [[sum(a[4+k+j:4+k+j+4]) for j in range(3)] for k in range(1, 7)]
        self.assertTrue(all(sum(b*c for b, c in zip(row, (1, 2, 2))) % 3 == 0 for row in A))
        common = 0
        for rows in itertools.combinations(A, 3):
            common = gcd(common, rational_determinant(rows))
        self.assertEqual(common, 3)

    def test_fraction_determinant_with_swaps_and_singular_matrices(self):
        matrices = [list(map(list, rows)) for rows in (
            ((0, 2, 1), (3, 0, -1), (1, 4, 2)),
            ((2, 1, 0), (4, 2, 0), (3, 1, -2)),
            ((3, 2, 1), (2, 3, 4), (-1, -2, -3)),
        )]
        for A in matrices:
            expected = 0
            for perm in itertools.permutations(range(3)):
                inversions = sum(perm[i] > perm[j] for i in range(3) for j in range(i+1, 3))
                value = (-1)**inversions
                for i in range(3):
                    value *= A[i][perm[i]]
                expected += value
            self.assertEqual(rational_determinant(A), expected)


if __name__ == '__main__':
    unittest.main()
