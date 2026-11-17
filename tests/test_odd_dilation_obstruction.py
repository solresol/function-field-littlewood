"""Independent normalization, endpoint, and characteristic controls."""
import unittest
from unittest.mock import patch

from search import odd_dilation_obstruction as obstruction
from search.run_rank_experiments import oracle


class OddDilationObstructionTests(unittest.TestCase):
    def test_independent_checkers_do_not_use_unit_formula(self):
        # Independently compare all coefficients, including zeros and endpoints.
        with patch.object(obstruction, 'coefficient', side_effect=AssertionError):
            for ell, r, modulus in ((3, 1, 7), (3, 2, 67), (5, 1, 19), (7, 1, 11)):
                endpoint = 2*ell**(r+1)+1
                self.assertEqual(obstruction.root_oracle(ell, ell**r, modulus, endpoint),
                                 obstruction.rational_series(ell, r, endpoint))

    def test_first_index_and_corrupted_controls(self):
        for ell, r, a in ((3, 1, 0), (3, 2, 2), (5, 1, 2), (7, 1, 1)):
            N, L = ell**r, ell**a
            m, d, j = L, N*L, (ell-1)*N*L
            c = obstruction.rational_series(ell, r, m+d+j+1)

            def exact(shift, exponents, first):
                values = [sum(c[shift+k+i] for i in exponents) % 2
                          for k in range(1, first+1)]
                return not any(values[:-1]) and values[-1] == 1

            self.assertTrue(exact(m, (0, d), j))
            self.assertFalse(exact(m, (0, d), j-1))
            self.assertFalse(exact(m, (0, d), j+1))
            self.assertFalse(exact(m, (0,), j))
            self.assertFalse(exact(m+1, (0, d), j))

    def test_original_r1_comparison(self):
        # The odd-characteristic binary construction is a different stream:
        # (t^2-1), shift 1 has j=degree=2 over F_3, without positive defect.
        values = [(oracle('lai_sprang', 3, 1+k+2)
                   - oracle('lai_sprang', 3, 1+k)) % 3 for k in (1, 2)]
        self.assertEqual(values, [0, 2])


if __name__ == '__main__':
    unittest.main()
