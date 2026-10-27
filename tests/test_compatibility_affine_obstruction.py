"""Independent readback and corruption controls for the five-state obstruction."""
from copy import deepcopy
import json
from pathlib import Path
import unittest
from unittest.mock import patch

from search.compatibility_affine_obstruction import (
    DEFAULT, compare_reduced, generate, verify,
)


class CompatibilityAffineObstructionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.saved = json.loads(Path(DEFAULT).read_text())

    def test_saved_proof_without_elimination_or_state_recursion(self):
        with patch('search.compatibility_affine_obstruction.inverse', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.basis', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.merge', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.direct', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.recursive', side_effect=AssertionError):
            summary = verify(self.saved)
        self.assertEqual(summary['affine_dimension'], 4)
        self.assertEqual(summary['linear_rank'], 4)
        self.assertEqual(summary['max_original_index'], 336)

    def test_reduced_slices_match_independent_original_systems(self):
        compare_reduced(self.saved)

    def test_inverse_point_root_and_completeness_corruptions_rejected(self):
        corruptions = []
        altered = deepcopy(self.saved)
        altered['records'][0]['children'][0]['inverse'][0][0] ^= 1
        corruptions.append(altered)
        altered = deepcopy(self.saved)
        altered['records'][1]['children'][1]['point'][0] ^= 1
        corruptions.append(altered)
        altered = deepcopy(self.saved)
        altered['primitive_order'] = [3, 2]
        corruptions.append(altered)
        altered = deepcopy(self.saved)
        altered['records'].pop()
        corruptions.append(altered)
        altered = deepcopy(self.saved)
        altered['records'][3]['difference'][0] ^= 1
        corruptions.append(altered)
        for i, altered in enumerate(corruptions):
            with self.subTest(corruption=i), self.assertRaises(ValueError):
                verify(altered)

    def test_saved_certificate_reproduces_exactly(self):
        self.assertEqual(json.loads(json.dumps(generate())), self.saved)


if __name__ == '__main__':
    unittest.main()
