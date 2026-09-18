"""Exhaustive small stream oracles and independent dual-certificate checks."""
from dataclasses import replace
from itertools import product
import unittest
from pathlib import Path

from search.finite_rank import longest_prefix, check_result
from search.lai_sprang_finite_search import coeff


def enumerate_indices(p, a, d, m, limit):
    for tail in product(range(p), repeat=d):
        R = (1,) + tail
        if R[-1] == 0:
            continue
        yield next((j for j in range(1, limit+1)
                    if sum(r*a(m+i+j) for i, r in enumerate(R)) % p), None)


class RankTests(unittest.TestCase):
    def compare(self, p, a, d, m, limit):
        result = longest_prefix(p, a, d, m, limit)
        indices = list(enumerate_indices(p, a, d, m, limit))
        expected = None if None in indices else max(indices)
        self.assertEqual(result.j, expected, (p, d, m, limit))
        self.assertTrue(check_result(p, a, d, m, limit, result))
        return result

    def test_every_tiny_stream(self):
        # Every length-7 binary stream, both shifts and d<=3; every length-5
        # ternary stream, both shifts and d<=2. Short limits exercise cutoffs.
        for p, length, max_d in ((2, 7, 3), (3, 5, 2)):
            for stream in product(range(p), repeat=length):
                a = lambda n: stream[n-1]
                for m in (0, 1):
                    for d in range(max_d+1):
                        self.compare(p, a, d, m, length-m-d)

    def test_lai_sprang_tiny_boxes(self):
        for p in (3, 5, 13, 17):
            for d in range(4):
                for m in range(9):
                    self.compare(p, lambda n: coeff(p, n), d, m, 32)

    def test_endpoint_obstruction_and_mutations(self):
        # H=[0,1]: nontrivial kernel exists, but its leading coefficient is zero.
        a = lambda n: int(n == 2)
        result = self.compare(2, a, 1, 0, 3)
        self.assertEqual(result.obstruction['kind'], 'leading_zero')
        for bad in (replace(result, R=(1, 0)), replace(result, j=2),
                    replace(result, obstruction={'kind':'inconsistent', 'weights':[0, 0]}),
                    replace(result, obstruction={'kind':'leading_zero', 'weights':[1, 0]})):
            self.assertFalse(check_result(2, a, 1, 0, 3, bad))

    def test_inclusive_prefix_and_tail_invariance(self):
        calls = []
        def a(n):
            calls.append(n)
            return coeff(5, n)
        result = longest_prefix(5, a, 4, 8, 32)
        self.assertLessEqual(max(calls), 8+4+32)
        end = 8+4+(result.j or 32)
        b = lambda n: a(n) if n <= end else 999
        self.assertTrue(check_result(5, b, 4, 8, 32, result))

    def test_unresolved_is_only_a_prefix(self):
        result = longest_prefix(2, lambda n: 0, 3, 2, 4)
        self.assertIsNone(result.j)
        self.assertTrue(check_result(2, lambda n: 0, 3, 2, 4, result))
        self.assertFalse(check_result(2, lambda n: 0, 3, 2, 4,
                                     replace(result, j=4, zero_prefix=3)))

    def test_saved_certificates(self):
        from search.run_rank_experiments import verify
        result = verify(Path('results/2026-09-18-rank-search.jsonl'))
        self.assertEqual(result['verified'], 7735)
        self.assertEqual(result['unresolved'], 0)

    def test_invalid_input(self):
        for p, d, m, limit in ((1,0,0,1),(4,0,0,1),(2,-1,0,1),(2,0,-1,1),(2,0,0,0)):
            with self.assertRaises(ValueError):
                longest_prefix(p, lambda n: 0, d, m, limit)


if __name__ == '__main__':
    unittest.main()
