"""Independent root-sum oracle and cutoff/normalisation regression checks."""
import json
from pathlib import Path
import unittest

from search.lai_sprang_finite_search import (
    coeff, exhaustive_small, first_fractional_index, oddpart, v2,
    verify_r1_witness,
)


def root_sum_coeff(p, n):
    # Expand the original rational summands, rather than using the simplified
    # support/sign formula: n = 2^k (2*l+1), coefficient = sum_zeta zeta^l.
    N = 1 << v2(p - 1)
    roots = [z for z in range(p) if pow(z, N // 2, p) == p - 1]
    k = 0
    total = 0
    while 1 << k <= n:
        if n % (1 << k) == 0 and (n // (1 << k)) % 2 == 1:
            exponent = (n // (1 << k) - 1) // 2
            total += sum(pow(z, exponent, p) for z in roots)
        k += 1
    return total % p


def check_witness(p, R, m, j):
    if not R or R[0] % p == 0 or R[-1] % p == 0 or m < 0 or j < 1:
        return False
    values = [sum(r * root_sum_coeff(p, m + i + k)
                  for i, r in enumerate(R)) % p for k in range(1, j + 1)]
    return all(x == 0 for x in values[:-1]) and values[-1] != 0


class SearchTests(unittest.TestCase):
    def test_coefficients_against_original_root_sum(self):
        for p in (3, 5, 7, 11, 13, 17, 19, 23, 31, 41):
            for n in range(1, 257):
                self.assertEqual(coeff(p, n), root_sum_coeff(p, n), (p, n))

    def test_r1_comparison_and_certificate_mutations(self):
        for p in (3, 7, 11, 19, 23, 31):
            self.assertEqual(verify_r1_witness(p), (6, 4))
            self.assertTrue(check_witness(p, (1, 0, 1), 2, 6))
            self.assertFalse(check_witness(p, (1, 0, 1), 2, 5))
            self.assertFalse(check_witness(p, (1, 0, 1), 2, 7))
            self.assertFalse(check_witness(p, (1, 0, 0), 2, 6))

    def test_cutoff_is_not_an_exact_index(self):
        self.assertIsNone(first_fractional_index(3, (1, 0, 1), 2, limit=5))
        self.assertEqual(first_fractional_index(3, (1, 0, 1), 2, limit=6), 6)
        result = exhaustive_small(5, 1, 3, limit=1)
        self.assertEqual(result.checked, 20)  # (max_m+1) * p^max_degree
        self.assertGreater(result.unresolved, 0)
        self.assertIsNotNone(result.first_unresolved)

    def test_small_box_and_scaling(self):
        result = exhaustive_small(5, 2, 4, limit=32)
        self.assertEqual(result.checked, 125)
        self.assertEqual(result.unresolved, 0)
        defect, p, d, m, R, j = result.best
        self.assertEqual(defect, j - d)
        self.assertTrue(check_witness(p, R, m, j))
        for scalar in range(1, p):
            self.assertEqual(first_fractional_index(p, tuple(scalar*r for r in R), m), j)

    def test_invalid_input(self):
        for p in (0, 1, 2, 9, 15):
            with self.assertRaises(ValueError):
                coeff(p, 1)
        for f in (oddpart, v2):
            with self.assertRaises(ValueError):
                f(0)
        for R in ((), (0,), (1, 5), (5, 1)):
            with self.assertRaises(ValueError):
                first_fractional_index(5, R, 0)
        with self.assertRaises(ValueError):
            exhaustive_small(5, -1, 2)

    def test_recorded_results_if_present(self):
        path = Path('results/2026-09-17-exact-search.json')
        if not path.exists():
            self.skipTest('run the bounded search first')
        data = json.loads(path.read_text())
        for box in data['boxes']:
            self.assertEqual(box['checked'], (box['max_m'] + 1) * box['p'] ** box['max_degree'])
            self.assertEqual(box['unresolved'], 0)
            defect, p, d, m, R, j = box['best']
            self.assertEqual(defect, j - d)
            self.assertEqual(d, len(R) - 1)
            self.assertTrue(check_witness(p, R, m, j))
            self.assertLessEqual(defect, box['N'])

    def test_degree_zero_sharp_gaps_and_cutoffs(self):
        from search.degree_zero_gaps import PRIMES
        from search.finite_rank import longest_prefix, check_result
        for p in PRIMES:
            N = 1 << v2(p-1)
            m = 5*N+1
            self.assertTrue(check_witness(p, (1,), m, N))
            self.assertEqual(root_sum_coeff(p, m+N), N//2)
            self.assertIsNone(first_fractional_index(p, (1,), m, N-1))
            self.assertEqual(first_fractional_index(p, (1,), m, N), N)
            unresolved = longest_prefix(p, lambda n: coeff(p, n), 0, m, N-1)
            self.assertIsNone(unresolved.j)
            self.assertTrue(check_result(p, lambda n: root_sum_coeff(p, n),
                                         0, m, N-1, unresolved))

    def test_saved_degree_zero_certificates_and_mutations(self):
        from copy import deepcopy
        from search.degree_zero_gaps import verify
        data = json.loads(Path('results/2026-09-20-degree-zero-gaps.json').read_text())
        self.assertEqual(verify(data), dict(witnesses_verified=7, shifts_verified=129,
                         unresolved=0, p17_max_index=16, p17_first_attaining_shift=81))
        for mutation in ('terminal', 'dual', 'box', 'missing'):
            bad = deepcopy(data)
            if mutation == 'terminal':
                bad['witnesses'][0]['result']['j'] -= 1
            elif mutation == 'dual':
                weights = bad['witnesses'][0]['result']['obstruction']['weights']
                weights[:] = [0]*len(weights)
            elif mutation == 'box':
                bad['p17_shift_box']['indices'][81] = 15
            else:
                bad['witnesses'].pop()
            with self.assertRaises(ValueError):
                verify(bad)


if __name__ == '__main__':
    unittest.main()
