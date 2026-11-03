"""Independent rank-four certificate and the complete diagonal pencil."""
from copy import deepcopy
from itertools import combinations
import json
import unittest
from unittest.mock import patch

from search.simultaneous_corner_transport import DEFAULT, compare, generate, maps, verify
from search.odd_corner_transport import mv, pull


class SimultaneousCornerTransportTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.saved = json.loads(DEFAULT.read_text())

    def test_independent_readback(self):
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
        self.assertEqual(result['quotient_rank'], 4)
        self.assertEqual(result['common_core_dimension'], 2)
        self.assertEqual(result['actual_original_endpoints'], [161, 289])
        self.assertFalse(result['all_completions_reachable_claimed'])

    def test_exact_regeneration_and_six_merges(self):
        self.assertEqual(json.loads(json.dumps(generate())), self.saved)
        compare(self.saved)

    def test_no_projection_exception_in_prescribed_empty_r1_and_separate_field(self):
        from search.terminal_boundary_relation import BoundaryRelations, basis, null
        # Prescribed contexts from the preceding single-response test only.
        for p, q, k in ((3, 0, 0), (3, 1, 2), (13, 7, 4)):
            with self.subTest(p=p, q=q, k=k):
                E = BoundaryRelations(p)
                N, t = E.N, 2*q+3
                A = E.direct(q+2, k, k)[0]
                B = E.direct(q+2, k+1, k+1)[0]
                L = basis(null(list(null(A, 2*N, p))+list(null(B, 2*N, p)), 2*N, p), p)
                W = basis(A+B, p)
                a = next(x for x in A if len(basis(L+(x,), p)) > N-1)
                b = next(x for x in B if len(basis(L+(a, x), p)) > N)
                M0, M1, P = maps(p, E.roots, q)
                equations = pull(null(W, 2*N, p), M0, p)+pull(null(W, 2*N, p), M1, p)
                S = basis(null(equations, 3*N, p), p)
                kernel = null(equations+P, 3*N, p)
                SL = basis(null(pull(null(L, 2*N, p), M0, p)
                                +pull(null(L, 2*N, p), M1, p), 3*N, p), p)
                self.assertEqual((len(S), len(SL), len(kernel)), (N+2, N-2, 0))
                wide = basis([mv(P, w, p) for w in S], p)
                core = basis([mv(P, w, p) for w in SL], p)
                self.assertEqual(wide, E.direct(t, 2*k, 2*k+2)[0])
                self.assertEqual(core, E.direct(t, 2*k+2, 2*k)[0])
                self.assertEqual(E.direct(t, 2*k, 2*k+2)[1], 0)
                planes = []
                for parameter in (None, *range(p)):
                    line = a if parameter is None else tuple((y+parameter*x) % p
                                                            for x, y in zip(a, b))
                    C = basis(L+(line,), p)
                    plane = E.merge(t, (C, C))
                    self.assertEqual(len(plane), N)
                    self.assertEqual(basis(plane+core, p), plane)
                    planes.append(plane)
                # Different parameters share only the N-2 core. In particular
                # this family cannot be a pencil with an N-1 common core.
                for left, right in combinations(planes, 2):
                    self.assertEqual(basis(left+right, p), wide)
                self.assertEqual(len(set(planes)), p+1)
                actual = E.merge(t, (B, B))
                self.assertEqual(actual, E.direct(t, 2*k+2, 2*k+2)[0])

    def test_certificate_corruptions(self):
        mutations = [
            lambda c: c.__setitem__('source_sha256', '0'*64),
            lambda c: c['wide_annihilator'].pop(),
            lambda c: c['constraints_rank']['inverse'][0].__setitem__(0, 0),
            lambda c: c['output_rank']['inverse'][0].__setitem__(0, 0),
            lambda c: c['core_preimages'][0].__setitem__(0, (c['core_preimages'][0][0]+1) % 5),
            lambda c: c['quotient_preimages'][0].__setitem__(0, (c['quotient_preimages'][0][0]+1) % 5),
            lambda c: c['quotient_outputs'][0].__setitem__(0, (c['quotient_outputs'][0][0]+1) % 5),
            lambda c: c['actual'][0]['preimages'][0].__setitem__(0, (c['actual'][0]['preimages'][0][0]+1) % 5),
            lambda c: c['actual'][0]['row_rank']['inverse'][0].__setitem__(0, 4),
            lambda c: c['actual'][1].__setitem__('parameter', 0),
        ]
        for i, mutation in enumerate(mutations):
            with self.subTest(corruption=i):
                altered = deepcopy(self.saved)
                mutation(altered)
                with self.assertRaises(ValueError):
                    verify(altered)


if __name__ == '__main__':
    unittest.main()
