"""Endpoint, correlation and coordinate-independence checks for the new state."""
import unittest
from unittest.mock import patch

from search.correlated_boundary_state import CorrelatedStates, check_direct
from test_terminal_boundary_relation import reconstruct


class CorrelatedStateTests(unittest.TestCase):
    def test_transition_needs_only_stored_state(self):
        machine = CorrelatedStates(5)
        # Initialization alone may inspect scalar coefficients. No subsequent
        # direct or recursive matrix construction is allowed.
        with patch.object(machine.engine, 'direct', side_effect=AssertionError), \
             patch.object(machine.engine, 'recursive', side_effect=AssertionError):
            state = machine.evaluate(311, 12)
            self.assertTrue(machine.accepts(state))
            self.assertEqual(state, machine.evaluate(311, 12, leading_zeros=3))
        target = [0]*4+[1, 0, 0, 0]
        self.assertEqual(reconstruct(machine.engine, 312, 12, 12, target),
                         [2, 3, 4, 0, 1, 3, 3, 3, 1, 3, 2, 1])

    def test_zero_shift_empty_rectangles_and_size_guard(self):
        machine = CorrelatedStates(5)
        for k in range(5):
            state = machine.evaluate(0, k)
            check_direct(machine, state, 0, k)
            if k < machine.N:
                self.assertFalse(machine.accepts(state))
        self.assertEqual(machine.initial, machine.step(machine.initial, 0, 0))

    def test_shift_phase_is_essential_for_transition(self):
        machine = CorrelatedStates(5)
        state = machine.evaluate(155, 6)
        correct = machine.step(state, 1, 0)
        wrong_phase = type(state)(0, state.size_cap, state.relations)
        wrong = machine.step(wrong_phase, 1, 0)
        self.assertNotEqual(correct.relations, wrong.relations)
        self.assertTrue(machine.accepts(correct))

    def test_domains(self):
        machine = CorrelatedStates(3)
        for args in ((-1, 0), (0, -1), (0, 0, -1)):
            with self.assertRaises(ValueError):
                machine.evaluate(*args)
        with self.assertRaises(ValueError):
            machine.step(machine.initial, 2, 0)


if __name__ == '__main__':
    unittest.main()
