import copy
import unittest

from search.run_rank_experiments import oracle
from search.terminal_gap_check import check_minor, gap_minor, run
from search.terminal_prime_obstruction import formal_series, normalized_coefficient


class TerminalGapTests(unittest.TestCase):
    def test_constructive_minors_and_exact_failure_control(self):
        result = run()
        self.assertEqual([s['constructive_minors'] for s in result['scales']],
                         [0, 304, 1888])
        self.assertEqual(result['gap_failure_control']['original_minor_determinant'], 12)

    def test_large_shifts_with_independent_original_root_sums(self):
        for N, p in ((4, 5), (4, 13), (8, 41), (16, 17)):
            for e in (N//2-1, N//2):
                for offset in (0, 1, N-1, N, 2*N-1, 2*N):
                    M = (1 << 55)*N + offset
                    witness = gap_minor(N, e, M, lambda n: normalized_coefficient(N, n))
                    if witness is None:
                        continue

                    def independent(n):
                        value = oracle('lai_sprang', p, n)*pow(N//2, -1, p) % p
                        self.assertIn(value, (0, 1, p-1))
                        return -1 if value == p-1 else value

                    check_minor(N, e, M, witness, independent)

    def test_corrupt_minor_and_endpoint_rejected(self):
        N, e, M = 8, 4, 8
        a = formal_series(N, M+2*N+2*e-1)
        witness = gap_minor(N, e, M, a.__getitem__)
        self.assertIsNotNone(witness)
        for key, value in (('pivot', 3), ('pivot', -witness['pivot']),
                           ('first_row', 0), ('last_row', N+e),
                           ('t', witness['t']+1), ('side', 'invalid')):
            bad = copy.deepcopy(witness)
            bad[key] = value
            with self.assertRaises(AssertionError):
                check_minor(N, e, M, bad, a.__getitem__)

    def test_r1_is_outside_the_hypotheses_and_still_fails(self):
        with self.assertRaises(ValueError):
            gap_minor(2, 0, 1, lambda n: normalized_coefficient(2, n))
        rows = [sum(oracle('lai_sprang', 3, 1+k+i) for i in range(2)) % 3
                for k in (1, 2, 3)]
        self.assertEqual(rows, [0, 0, 2])


if __name__ == '__main__':
    unittest.main()
