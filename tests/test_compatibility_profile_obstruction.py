"""Independent arithmetic and corruption checks for the fixed profile collision."""
from copy import deepcopy
import json
import unittest
from unittest.mock import patch

from search.compatibility_profile_obstruction import (
    DEFAULT, compare_reduced, generate, verify,
)


class CompatibilityProfileObstructionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.saved = json.loads(DEFAULT.read_text())

    def test_readback_without_elimination_or_relation_engine(self):
        with patch('search.compatibility_profile_obstruction.solve', side_effect=AssertionError), \
             patch('search.finite_rank._Affine', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.basis', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.null', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.direct', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.merge', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.recursive', side_effect=AssertionError):
            summary = verify(self.saved)
        self.assertEqual(summary['local_systems'], 20)
        self.assertEqual(summary['max_original_index'], 576)
        self.assertTrue(summary['initial_profiles_equal'])
        self.assertFalse(summary['successor_profiles_equal'])

    def test_agrees_with_reduced_state_slices(self):
        compare_reduced(self.saved)

    def test_original_certificates_regenerate_exactly(self):
        self.assertEqual(json.loads(json.dumps(generate())), self.saved)

    def test_primal_dual_point_root_and_completeness_corruptions(self):
        corruptions = []
        for field in ('failure', 'primal', 'duals'):
            altered = deepcopy(self.saved)
            values = altered['records'][0][field]
            if field == 'failure':
                values[0] = (values[0]+1) % 5
            else:
                values[0][0] = (values[0][0]+1) % 5
            corruptions.append(altered)
        altered = deepcopy(self.saved)
        altered['records'][16]['point'][0] ^= 1
        corruptions.append(altered)
        altered = deepcopy(self.saved)
        altered['current_rejection_duals'][0][0] ^= 1
        corruptions.append(altered)
        altered = deepcopy(self.saved)
        altered['primitive'] = [3, 2]
        corruptions.append(altered)
        altered = deepcopy(self.saved)
        altered['records'].pop()
        corruptions.append(altered)
        for i, altered in enumerate(corruptions):
            with self.subTest(corruption=i), self.assertRaises(ValueError):
                verify(altered)


if __name__ == '__main__':
    unittest.main()
