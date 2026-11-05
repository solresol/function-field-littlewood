"""The missing corner changes the terminal language of actual stream states."""
from copy import deepcopy
import json
import unittest
from unittest.mock import patch

from search.corner_terminal_selector import DEFAULT, FINAL, WORD, generate, verify


class CornerTerminalSelectorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.saved = json.loads(DEFAULT.read_text())

    def test_independent_response_and_original_coefficient_readback(self):
        with patch('search.compatibility_profile_obstruction.solve', side_effect=AssertionError), \
             patch('search.finite_rank._Affine', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.basis', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.null', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.direct', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.merge', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.recursive', side_effect=AssertionError), \
             patch('search.correlated_boundary_state.CorrelatedStates.step', side_effect=AssertionError):
            summary = verify(self.saved)
        self.assertTrue(summary['terminal_language_separation_proved'])
        self.assertEqual(summary['actual_terminal_outputs'], [True, False])
        self.assertEqual(summary['unique_homogeneous_parameter'], [0, 1])
        self.assertEqual(summary['original_coefficient_endpoints'], [2568, 4616])
        self.assertFalse(summary['abstract_completions_reachable_claimed'])
        by_context = {tuple(n['context']): n for n in self.saved['nodes']}
        # The single-response square is subsequently used in BOTH children.
        single = by_context[126, 18, 18, 1]
        conic = by_context[251, 36, 36, 2]
        self.assertEqual(single['ports'], 1)
        self.assertEqual(conic['ports'], 2)
        self.assertEqual(conic['children'][0], conic['children'][1])

    def test_exact_regeneration(self):
        self.assertEqual(json.loads(json.dumps(generate())), self.saved)

    def test_actual_correlated_paths_and_all_abstract_parameters(self):
        from search.correlated_boundary_state import CorrelatedStates, State
        from search.corner_response_obstruction import DEFAULT as SOURCE
        from search.terminal_boundary_relation import basis
        M = CorrelatedStates(5)
        source = json.loads(SOURCE.read_text())
        states = [M.evaluate(q, 8) for q in (62, 126)]
        self.assertEqual(states[0].relations[:7], states[1].relations[:7])
        for digit in WORD:
            states = [M.step(s, *digit) for s in states]
        self.assertEqual([M.accepts(s) for s in states], [True, False])
        self.assertEqual(states, [M.evaluate(*pair) for pair in FINAL])
        for parameter in (None, *range(5)):
            line = (source['a'] if parameter is None else
                    [(b+parameter*a) % 5 for a, b in zip(source['a'], source['b'])])
            initial = M.evaluate(62, 8)
            relations = list(initial.relations)
            relations[-1] = basis(source['intersection']+[line], 5)
            state = State(initial.phase, initial.size_cap, tuple(relations))
            for digit in WORD:
                state = M.step(state, *digit)
            self.assertEqual(M.accepts(state), parameter == 0)
        # The r=1 comparison remains a control; no new binary candidate.
        r1 = CorrelatedStates(3)
        self.assertTrue(r1.accepts(r1.evaluate(1, 2)))

    def test_certificate_corruptions(self):
        mutations = [
            lambda c: c.__setitem__('source_sha256', '0'*64),
            lambda c: c['word'][0].__setitem__(0, 0),
            lambda c: c['nodes'][-1]['preimages'][0].__setitem__(
                0, (c['nodes'][-1]['preimages'][0][0]+1) % 5),
            lambda c: c['nodes'][-1]['duals'][0].__setitem__(0, 1),
            lambda c: c['nodes'][-1]['annihilator'].pop(),
            lambda c: c['nodes'][-1]['children'].__setitem__(0, len(c['nodes'])-1),
            lambda c: c['slice']['point'].__setitem__(0, 1),
            lambda c: c['slice']['direction_weights'][0].__setitem__(0, 1),
            lambda c: c['bezout'][0]['multiplier'].__setitem__(0, 0),
            lambda c: c['bezout'][0]['rows'].__setitem__(0, 8),
            lambda c: c['zero_solution'].__setitem__(0, 1),
            lambda c: c['infinity_dual'].__setitem__(0, 1),
            lambda c: c['actual'][0]['primal'].__setitem__(0, 0),
            lambda c: c['actual'][1]['dual'].__setitem__(0, 0),
        ]
        for i, mutation in enumerate(mutations):
            with self.subTest(corruption=i):
                altered = deepcopy(self.saved)
                mutation(altered)
                with self.assertRaises(ValueError):
                    verify(altered)


if __name__ == '__main__':
    unittest.main()
