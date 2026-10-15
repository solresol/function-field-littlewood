"""Controls for the ordinary two-residue boundary argument."""
import unittest
from unittest.mock import patch

from search.terminal_prime_obstruction import formal_series
from search.terminal_two_strip_check import run, strip


class TerminalTwoStripTests(unittest.TestCase):
    def test_original_row_identities(self):
        result = run()
        self.assertEqual([s['remaining_residues'] for s in result['scales']],
                         [[25, 29], [113, 121]])
        self.assertEqual([s['counts']['remaining'] for s in result['scales']], [48, 48])

    def test_partition_and_row_budget_endpoints(self):
        for N in (8, 16, 32):
            H, B = N//2, N*N//2
            residual = []
            for z in range(-3*H+1, H, 2):
                branch, boundary, offset = strip(N, B+z)
                self.assertEqual((boundary, offset), (B, z))
                if branch == 'remaining':
                    residual.append(z)
                elif branch == 'antiperiodic':
                    self.assertTrue(1 <= -N-z <= H-1)
                elif branch == 'two_rows':
                    self.assertTrue(1 <= -H-z < 2-H-z <= H-1)
                elif branch == 'next_gap':
                    self.assertTrue(1 <= N+2-z-H <= N+2-z <= 3*H-1)
                else:
                    self.fail(branch)
            self.assertEqual(residual, [1-N, 1-H])
        for args in [(4, 1), (12, 1), (8, 0), (8, -1), (8, 2)]:
            with self.assertRaises(ValueError):
                strip(*args)

    def test_corrupted_stream_rejected(self):
        def bad_series(N, endpoint):
            a = formal_series(N, endpoint)
            a[N+2] += 1
            return a
        with patch('search.terminal_two_strip_check.formal_series', side_effect=bad_series):
            with self.assertRaises(AssertionError):
                run()


if __name__ == '__main__':
    unittest.main()
