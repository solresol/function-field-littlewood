"""Projective odd-corner transport, including the actual pole and empty r=1."""
from copy import deepcopy
import json
import unittest
from unittest.mock import patch

from search.odd_corner_transport import DEFAULT, compare, generate, maps, mv, pull, verify


class OddCornerTransportTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.saved = json.loads(DEFAULT.read_text())

    def test_independent_readback_and_actual_pole(self):
        with patch('search.compatibility_profile_obstruction.solve', side_effect=AssertionError), \
             patch('search.corner_response_obstruction.solve', side_effect=AssertionError), \
             patch('search.compatibility_affine_obstruction.inverse', side_effect=AssertionError), \
             patch('search.finite_rank._Affine', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.basis', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.null', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.direct', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.merge', side_effect=AssertionError), \
             patch('search.terminal_boundary_relation.BoundaryRelations.recursive', side_effect=AssertionError):
            result = verify(self.saved)
        self.assertEqual(result['matrix'], [[2, 1], [1, 1]])
        self.assertEqual(result['actual_output_parameters'], [1, None])
        self.assertEqual(result['quotient_rank'], 2)
        self.assertFalse(result['all_completions_reachable_claimed'])

    def test_all_six_lines_and_exact_regeneration(self):
        compare(self.saved)
        self.assertEqual(json.loads(json.dumps(generate())), self.saved)

    def test_empty_r1_and_separate_field_borders(self):
        from search.terminal_boundary_relation import BoundaryRelations, basis, null
        # Existing prescribed contexts only, not an extension of the state search.
        for p, q, k in ((3, 0, 0), (3, 1, 2), (13, 7, 4)):
            with self.subTest(p=p, q=q, k=k):
                E = BoundaryRelations(p)
                N = E.N
                F = E.direct(q+1, k+1, k+1)[0]
                L = E.direct(q+2, k+1, k)[0]
                W = E.direct(q+2, k, k+1)[0]
                M0, M1, P = maps(p, E.roots, q)
                equations = pull(null(F, 2*N, p), M0, p)+pull(null(W, 2*N, p), M1, p)
                S = basis(null(equations, 3*N, p), p)
                S0 = basis(null(equations+pull(null(L, 2*N, p), M1, p), 3*N, p), p)
                self.assertEqual((len(S), len(S0)), (N+1, N-1))
                self.assertEqual(basis([mv(P, w, p) for w in S], p),
                                 E.direct(2*q+2, 2*k+1, 2*k+2)[0])
                self.assertEqual(basis([mv(P, w, p) for w in S0], p),
                                 E.direct(2*q+2, 2*k+2, 2*k+1)[0])
                self.assertEqual(len(basis(list(L)+[mv(M1, w, p) for w in S], p)), N+1)
                # The distinguished small square maps to the actual next small square.
                A = E.direct(q+2, k, k)[0]
                self.assertEqual(E.merge(2*q+2, (F, A)),
                                 E.direct(2*q+2, 2*k+1, 2*k+1)[0])

    def test_rank_lift_chart_and_provenance_corruptions(self):
        mutations = [
            lambda c: c['constraints_rank']['inverse'][0].__setitem__(0, 4),
            lambda c: c['chart_rank']['inverse'][0].__setitem__(0, 4),
            lambda c: c['wide_preimages'][0].__setitem__(0, (c['wide_preimages'][0][0]+1) % 5),
            lambda c: c['tall_preimages'][0].__setitem__(0, (c['tall_preimages'][0][0]+1) % 5),
            lambda c: c['quotient_preimages'][0].__setitem__(0, (c['quotient_preimages'][0][0]+1) % 5),
            lambda c: c['output_coordinates'][0].__setitem__(0, (c['output_coordinates'][0][0]+1) % 5),
            lambda c: c['projective_matrix'][1].__setitem__(0, 0),
            lambda c: c['forcing_annihilator'].pop(),
            lambda c: c['output_chart'].pop(),
            lambda c: c.__setitem__('source_sha256', '0'*64),
        ]
        for i, mutation in enumerate(mutations):
            with self.subTest(corruption=i):
                altered = deepcopy(self.saved)
                mutation(altered)
                with self.assertRaises(ValueError):
                    verify(altered)


if __name__ == '__main__':
    unittest.main()
