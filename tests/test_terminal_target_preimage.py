"""Acceptance pruning, coupled feasibility, and the actual one-parity failure."""
import unittest
from unittest.mock import patch

from search.four_square_state import FourSquareStates
from search.run_rank_experiments import oracle
from search.square_state_obstruction import affine_target
from search.terminal_target_preimage import (
    dot, one_parity_counterexample, target_preimage,
)


class TerminalTargetPreimageTests(unittest.TestCase):
    def test_even_shift_stripping_and_exact_normalized_polynomial(self):
        for p, M, n in ((3, 1, 2), (5, 311, 12), (13, 1465, 80)):
            machine = FourSquareStates(p)
            state = machine.evaluate(M, n)
            with patch.object(machine.engine, 'direct', side_effect=AssertionError), \
                 patch.object(machine.engine, 'recursive', side_effect=AssertionError):
                even = target_preimage(machine, state, 0, 0)
                odd = target_preimage(machine, state, 0, 1)
            self.assertEqual(even['point'], (0,)*machine.N)
            self.assertIsNone(odd['point'])
            T = affine_target(machine, M, n)
            S = [x*pow(2, -1, p) % p for x in T for _ in (0, 1)]
            self.assertEqual(affine_target(machine, 2*M, 2*n), S)
            self.assertIsNone(affine_target(machine, 2*M, 2*n+1))
            self.assertNotEqual(sum(x*oracle('lai_sprang', p, 2*M+2*n+1+j)
                                   for j, x in enumerate(S)) % p, 0)

    def test_one_parity_and_full_norm_still_leave_a_nonzero_compatibility_class(self):
        certificate = one_parity_counterexample()
        result = certificate['preimage']
        self.assertEqual([s['point'] for s in result['slices']],
                         [(4, 2, 4, 2), (1, 4, 1, 0)])
        self.assertEqual([s['directions'] for s in result['slices']], [(), ()])
        self.assertEqual(result['quotient_dimension'], 4)
        difference = [(b-a) % 5 for a, b in zip(
            result['slices'][0]['point'], result['slices'][1]['point'])]
        self.assertNotEqual(dot(result['compatibility_dual'], difference, 5), 0)
        self.assertEqual(certificate['weighted_norm_values'], [1, 1])
        self.assertEqual(certificate['original_rows'][::2], [0]*6)
        self.assertTrue(all(certificate['original_rows'][1::2]))

    def test_existing_odd_size_acceptance_is_preserved(self):
        # Existing p=41 witness; tests the (1,1) branch without a giant matrix.
        machine = FourSquareStates(41)
        state = machine.evaluate(309058, 958171)
        with patch.object(machine.engine, 'direct', side_effect=AssertionError), \
             patch.object(machine.engine, 'recursive', side_effect=AssertionError):
            result = target_preimage(machine, state, 1, 1)
        self.assertEqual(result['point'], (13, 15, 3, 22, 19, 2, 1, 14))
        self.assertEqual(result['slices'][0]['point'], result['slices'][1]['point'])


if __name__ == '__main__':
    unittest.main()
