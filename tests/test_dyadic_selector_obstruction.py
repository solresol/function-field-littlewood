"""Independent integer readback and controls for selector specialization."""
from copy import deepcopy
import json
import unittest
from unittest.mock import patch

from search.dyadic_selector_obstruction import DEFAULT, WORD, generate, verify
from search.correlated_boundary_state import CorrelatedStates
from search.run_rank_experiments import oracle
from search.terminal_prime_obstruction import formal_series


class DyadicSelectorObstructionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.saved = json.loads(DEFAULT.read_text())

    def test_readback_without_elimination_or_state_recurrence(self):
        with patch.dict('sys.modules', {'sympy': None}), \
             patch('search.lai_sprang_sharpness.normalized', side_effect=AssertionError), \
             patch.object(CorrelatedStates, 'step', side_effect=AssertionError):
            result = verify(self.saved)
        self.assertEqual([r['pairing'] for r in result['records']], [5, 1])
        # An independent original-root-sum control for the entire used window.
        coefficients = formal_series(4, 4616)
        for p in (5, 13):
            for n in range(1, len(coefficients)):
                self.assertEqual(2*coefficients[n] % p, oracle('lai_sprang', p, n))

    def test_corruptions_are_rejected(self):
        mutations = (
            lambda d: d.update(N=2),
            lambda d: d.update(size=283),
            lambda d: d['word'][0].__setitem__(0, 0),
            lambda d: d['records'][0].update(q=2000),
            lambda d: d['records'][0].update(pairing=1),
            lambda d: d['records'][1].update(endpoint_inclusive=4615),
            lambda d: d['records'][0]['dual'].__setitem__(0, d['records'][0]['dual'][0]+1),
            lambda d: d['records'][1]['dual'].pop(),
            lambda d: d['records'].__setitem__(1, deepcopy(d['records'][0])),
            lambda d: d['characteristic_five_primal'].__setitem__(0, 0),
        )
        for i, mutate in enumerate(mutations):
            with self.subTest(corruption=i):
                data = deepcopy(self.saved)
                mutate(data)
                with self.assertRaises(ValueError):
                    verify(data)

    def test_regeneration_and_actual_correlated_paths(self):
        self.assertEqual(generate(), self.saved)
        # Controls, not the proof of the infinitely many-prime conclusion.
        for p in (5, 13, 29):
            machine = CorrelatedStates(p)
            for a in (6, 7, 8):
                state = machine.evaluate((1 << a)-2, 8)
                q, k = (1 << a)-2, 8
                for epsilon, eta in WORD:
                    state = machine.step(state, epsilon, eta)
                    q, k = 2*q+epsilon, 2*k+eta
                self.assertEqual((q, k), (32*(1 << a)-47, 284))
                self.assertEqual(machine.accepts(state), p == 5 and a == 6)


if __name__ == '__main__':
    unittest.main()
