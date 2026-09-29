"""Support completeness, cancellation boundaries and independent field checks."""
from copy import deepcopy
import json
from pathlib import Path
import unittest
from unittest.mock import patch

from search import lai_sprang_support as support
from search.lai_sprang_three_term import PRIMES
from search.lai_sprang_finite_search import v2
from search.run_rank_experiments import oracle


class SupportTests(unittest.TestCase):
    def test_small_intervals_exhaustively(self):
        # 4*40*41/2=3280 inclusive intervals, including h=0 and k>=4.
        for N in (2, 4, 8, 16):
            for lo in range(1, 41):
                for hi in range(lo, 41):
                    expected = []
                    for n in range(lo, hi+1):
                        u = n
                        while u % 2 == 0:
                            u //= 2
                        if u % N == 1:
                            expected.append((n, (-1)**((u-1)//N)))
                    self.assertEqual(support.support_interval(N, lo, hi), expected)

    def test_five_support_points_and_cancellation(self):
        for N in support.SCALES[1:]:
            row = support.three_term_partition(N)
            self.assertEqual(row['support'], [[10*N+1, 1], [10*N+2, -1],
                             [11*N+1, -1], [12*N+1, 1], [12*N+2, 1]])
            self.assertEqual([e['j'] for e in row['events']],
                             [N-2, N-1, 2*N-2, 2*N-1, 2*N])
            self.assertEqual([e['total'] for e in row['events']], [0, 0, 0, 0, -1])
            self.assertEqual(support.verify_record(row), 2*N)
        self.assertEqual(support.verify_record(support.three_term_partition(4)), 1)

    def test_original_root_sums_on_whole_intervals(self):
        for p in PRIMES:
            N = 1 << v2(p-1)
            row = support.three_term_partition(N)
            points = dict(row['support'])
            for n in range(row['lo'], row['hi']+1):
                self.assertEqual((N//2*points.get(n, 0)) % p,
                                 oracle('lai_sprang', p, n), (p, n))

    def test_saved_readback_independent_and_corruption(self):
        data = json.loads(Path('results/2026-09-30-support-partition.json').read_text())
        with patch.object(support, 'support_interval', side_effect=AssertionError), \
                patch.object(support, 'three_term_partition', side_effect=AssertionError):
            self.assertEqual(support.verify(data)['partitions_checked'], 7)
        mutations = []
        for key in ('lo', 'hi', 'N'):
            bad = deepcopy(data)
            bad['partitions'][1][key] += 1
            mutations.append(bad)
        for field in ('support', 'events'):
            bad = deepcopy(data)
            bad['partitions'][1][field].pop(0)
            mutations.append(bad)
        bad = deepcopy(data)
        bad['partitions'][1]['events'][-1]['total'] = 0
        mutations.append(bad)
        bad = deepcopy(data)
        bad['partitions'][1]['support'][0][1] = -1
        mutations.append(bad)
        mutations.extend([dict(partitions=data['partitions'][:-1]),
                          dict(partitions=data['partitions']+[data['partitions'][0]])])
        for bad in mutations:
            with self.assertRaises(ValueError):
                support.verify(bad)

    def test_invalid_intervals(self):
        for args in ((1, 1, 2), (3, 1, 2), (8, 0, 2), (8, 3, 2)):
            with self.assertRaises(ValueError):
                support.support_interval(*args)
