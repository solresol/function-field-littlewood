"""Finite screening soundness controls, including indistinguishable bad tails."""
from copy import deepcopy
from itertools import product
import json
from pathlib import Path
import unittest
from unittest.mock import patch

from search.binary_quadratic_screen import (
    RELATIONS, convolution_residual, quadratic_residual, verify,
)
from search.run_rank_experiments import oracle


class QuadraticScreenTests(unittest.TestCase):
    def test_all_small_prefixes_and_relations(self):
        polynomials = list(product((0, 1), repeat=2))
        for prefix in product((0, 1), repeat=5):
            for A, B, C in product(polynomials, repeat=3):
                if any(A) or any(B):
                    self.assertEqual(quadratic_residual(prefix, A, B, C),
                                     convolution_residual(prefix, A, B, C))

    def test_tail_and_inclusive_endpoint(self):
        A, B, C = RELATIONS['rudin_shapiro']
        prefix = [oracle('rudin_shapiro', 2, n) for n in range(66)]
        prefix[64] ^= 1
        self.assertFalse(any(quadratic_residual(prefix[:64], A, B, C)))
        self.assertEqual(quadratic_residual(prefix[:65], A, B, C)[64], 1)
        prefix[65] ^= 1
        self.assertEqual(quadratic_residual(prefix[:65], A, B, C)[64], 1)

    def test_invalid_inputs_and_polynomial_truncation(self):
        for prefix in ([], [2], [-1], [True], [1.0]):
            with self.assertRaises(ValueError):
                quadratic_residual(prefix, [1], [1], [0])
        for relation in (([], [1], [0]), ([0], [0], [1]), ([1], [2], [0])):
            with self.assertRaises(ValueError): quadratic_residual([0], *relation)
        self.assertEqual(quadratic_residual([1], [0, 0, 1], [1], [0, 1]), [1])

    def test_saved_independent_readback_and_corruption(self):
        data = json.loads(Path('results/2026-09-27-binary-quadratic-screen.json').read_text())
        with patch('search.binary_quadratic_screen.stream', side_effect=AssertionError), \
                patch('search.binary_quadratic_screen.quadratic_residual', side_effect=AssertionError):
            self.assertEqual(verify(data)['records_verified'], 5)
        for key, value in (('precision', 1023), ('A', [1]), ('prefix_sha256', ''),
                           ('first_nonzero_residual', 7), ('zero_mod_x_power', False),
                           ('infinite_identity_proved_by_check', True)):
            bad = deepcopy(data)
            bad['records'][0][key] = value
            with self.subTest(key=key), self.assertRaises(ValueError): verify(bad)
        for rows in (data['records'][:-1], data['records'] + data['records'][:1],
                     list(reversed(data['records']))):
            with self.assertRaises(ValueError): verify(dict(records=rows))
