import copy
import itertools
import json
from pathlib import Path
import unittest
from unittest.mock import patch

from search.terminal_boundary_cover import (
    FIELDS, determinant, parameters, verify,
)
from search.lai_sprang_finite_search import coeff
from search.run_rank_experiments import oracle


class BoundaryCoverTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data = json.loads(Path('results/2026-10-11-boundary-cover.json').read_text())

    def test_saved_minors_without_generator_or_elimination(self):
        with patch('search.terminal_boundary_cover._Affine', side_effect=AssertionError), \
             patch('search.terminal_boundary_cover.coeff', side_effect=AssertionError):
            self.assertEqual(verify(self.data), 3456)

    def test_corruption_and_coverage_controls(self):
        mutations = (
            lambda d: d['fields'][0]['records'].pop(),
            lambda d: d['fields'][0]['records'].append(d['fields'][0]['records'][0]),
            lambda d: d['fields'][0]['records'][0].update(determinant_mod_p=0),
            lambda d: d['fields'][0]['records'][0].update(rows=[1, 1, 2]),
            lambda d: d['fields'][0]['records'][0].update(rows=[1, 2, 7]),
            lambda d: d['fields'][0]['records'][0].update(x=1),
            lambda d: d['fields'][0].update(interval_length=10),
        )
        for mutate in mutations:
            data = copy.deepcopy(self.data)
            mutate(data)
            with self.assertRaises(AssertionError):
                verify(data)

    def test_period_cover_at_large_shifts_and_inclusive_endpoint(self):
        for p in FIELDS:
            N, H, D, length, L, period = parameters(p)
            self.assertEqual(length, D + 1 + H + N - 1)
            self.assertLess(length, L)
            # Includes a hole at the first and at the last inclusive index.
            for residue in (0, L-1, L-length, period-1):
                for q in (0, 1, 2, 1 << 54):
                    M = q * period + residue
                    holes = 0
                    for i in range(1, length+1):
                        value = oracle('lai_sprang', p, M+i)
                        if (residue+i) % L:
                            self.assertEqual(value, coeff(p, residue+i))
                        else:
                            holes += 1
                            self.assertIn(value, (0, H % p, -H % p))
                    self.assertLessEqual(holes, 1)

    def test_bareiss_against_permutation_formula(self):
        for entries in itertools.product((-1, 0, 1), repeat=4):
            a, b, c, d = entries
            self.assertEqual(determinant([[a, b], [c, d]]), a*d-b*c)
        for rows in ([[0, 2, 1], [3, 0, -1], [1, 4, 2]],
                     [[2, 1, 0], [4, 2, 0], [3, 1, -2]]):
            expected = 0
            for perm in itertools.permutations(range(3)):
                inversions = sum(perm[i] > perm[j] for i in range(3) for j in range(i+1, 3))
                value = (-1)**inversions
                for i in range(3):
                    value *= rows[i][perm[i]]
                expected += value
            self.assertEqual(determinant(rows), expected)


if __name__ == '__main__':
    unittest.main()
