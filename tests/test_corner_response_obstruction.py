"""Independent original-coefficient proof of the missing bordering scalar."""
from copy import deepcopy
import json
import unittest
from unittest.mock import patch

from search.corner_response_obstruction import DEFAULT, compare_reduced, generate, verify


class CornerResponseTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.saved = json.loads(DEFAULT.read_text())

    def test_readback_without_elimination_or_recurrence(self):
        with patch('search.corner_response_obstruction.solve', side_effect=AssertionError), \
             patch('search.corner_response_obstruction.inverse', side_effect=AssertionError), \
             patch('search.finite_rank._Affine', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.basis', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.null', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.direct', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.merge', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.recursive', side_effect=AssertionError):
            result = verify(self.saved)
        self.assertEqual(result['full_relations'], 12)
        self.assertEqual(result['border_parameters'], [0, 4])
        self.assertEqual(result['max_original_index'], 576)
        self.assertFalse(result['terminal_language_separation_proved'])

    def test_reduced_state_and_original_coefficient_agreement(self):
        compare_reduced(self.saved)

    def test_exact_regeneration(self):
        self.assertEqual(json.loads(json.dumps(generate())), self.saved)

    def test_first_square_child_table_including_empty_and_r1(self):
        from search.four_square_state import FourSquareStates
        from search.terminal_boundary_relation import basis, null
        for p in (3, 5, 13, 41, 17):
            machine = FourSquareStates(p)
            for q, k in ((0, 0), (1, 0), (1, 2), (31, 4), (62, 8), (126, 8)):
                state = machine.evaluate(q, k)
                B00, B01, B10, _ = state.squares
                wide = basis(B00+B01, p)
                tall = basis(null(list(null(B00, 2*machine.N, p))
                                  +list(null(B01, 2*machine.N, p)),
                                  2*machine.N, p), p)
                table = (((0, 0), (B00, B00)), ((0, 1), (tall, wide)),
                         ((1, 0), (B00, B10)), ((1, 1), (B01, B10)))
                for (e, h), children in table:
                    response = machine.engine.merge(2*state.phase+e+1, children)
                    self.assertEqual(response, machine.step(state, e, h).squares[0])

    def test_rank_preimage_border_and_completeness_corruptions(self):
        corruptions = []
        for name in ('rank_inverse', 'preimages', 'relation'):
            altered = deepcopy(self.saved)
            row = altered['records'][0][name][0]
            row[0] = (row[0]+1) % 5
            corruptions.append(altered)
        for name in ('intersection', 'sum'):
            altered = deepcopy(self.saved)
            altered[name].pop()
            corruptions.append(altered)
        for name in ('c_coordinates', 'a'):
            altered = deepcopy(self.saved)
            altered[name][0] = (altered[name][0]+1) % 5
            corruptions.append(altered)
        altered = deepcopy(self.saved)
        altered['right_parameter'] = 0
        corruptions.append(altered)
        altered = deepcopy(self.saved)
        altered['records'].pop()
        corruptions.append(altered)
        altered = deepcopy(self.saved)
        altered['roots'] = [1, 3, 2, 4]
        corruptions.append(altered)
        for i, altered in enumerate(corruptions):
            with self.subTest(corruption=i), self.assertRaises(ValueError):
                verify(altered)


if __name__ == '__main__':
    unittest.main()
