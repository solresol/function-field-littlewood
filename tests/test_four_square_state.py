"""Singular, empty and correlation controls for four-square reconstruction."""
import unittest
from unittest.mock import patch

from search.correlated_boundary_state import CorrelatedStates
from search.four_square_state import FourSquareStates, compress, reconstruct
from search.terminal_boundary_relation import BoundaryRelations


class FourSquareTests(unittest.TestCase):
    def test_reconstructs_known_singular_and_empty_tuples(self):
        for p, q, k in ((3, 1, 2), (5, 311, 12), (13, 1465, 80),
                        (41, 255, 11), (5, 0, 0)):
            machine = CorrelatedStates(p)
            full = machine.evaluate(q, k)
            self.assertEqual(reconstruct(compress(full), p), full)

    def test_transitions_use_stored_squares_and_keep_old_collision_distinct(self):
        machine = FourSquareStates(5)
        with patch.object(machine.engine, 'direct', side_effect=AssertionError), \
             patch.object(machine.engine, 'recursive', side_effect=AssertionError):
            self.assertTrue(machine.accepts(machine.evaluate(311, 12)))
            self.assertEqual(machine.evaluate(311, 12, leading_zeros=3),
                             machine.evaluate(311, 12))
            states = [machine.evaluate(q, 4) for q in (31, 63)]
            self.assertNotEqual(states[0], states[1])
            for epsilon, eta in ((0, 1), (0, 0), (1, 0)):
                states = [machine.step(s, epsilon, eta) for s in states]
            self.assertEqual([machine.accepts(s) for s in states], [False, True])

    def test_no_invisible_vector_hypothesis_cannot_be_dropped(self):
        engine = BoundaryRelations(5)
        # Zero stream: X^4-1 is invisible. Adjacent squares now coincide;
        # their sum has dimension N, rather than the required N+1.
        with patch('search.terminal_boundary_relation.oracle', return_value=0):
            small, _ = engine.direct(1, 4, 4)
            large, invisible = engine.direct(1, 5, 5)
        self.assertEqual(small, large)
        self.assertEqual(invisible, 1)


if __name__ == '__main__':
    unittest.main()
