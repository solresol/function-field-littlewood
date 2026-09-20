"""Independent recurrence, sparse/dense comparison and corruption controls."""
from copy import deepcopy
import json
from pathlib import Path
import unittest
from unittest.mock import patch

from search.lai_sprang_finite_search import v2
from search.run_rank_experiments import oracle, stream
from search.thue_morse_dyadic import family, first_index, verify


class DyadicTests(unittest.TestCase):
    def test_adjacent_difference_identity(self):
        for n in range(16384):
            self.assertEqual((oracle('thue_morse', 2, n)
                              + oracle('thue_morse', 2, n+1)) % 2,
                             (1+v2(n+1)) % 2)

    def test_sparse_dense_cutoff_and_inclusive_locality(self):
        for k in range(7):
            row = family(k)
            support, m, j = row['support'], row['m'], row['limit']
            R = [int(i in support) for i in range(row['d']+1)]
            calls = []
            def a(n):
                calls.append(n)
                return stream('thue_morse', 2, n)
            self.assertIsNone(first_index(a, support, m, j-1))
            self.assertEqual(max(calls), m+row['d']+j-1)
            calls.clear()
            self.assertEqual(first_index(a, support, m, j), j)
            self.assertEqual(max(calls), m+row['d']+j)
            values = [sum(r*oracle('thue_morse', 2, m+i+s)
                          for i, r in enumerate(R)) % 2 for s in range(1, j+1)]
            self.assertEqual(values, [0]*(j-1)+[1])
        self.assertEqual(family(0)['support'], [0, 2])

    def test_saved_witnesses_without_elimination(self):
        data = json.loads(Path('results/2026-09-21-thue-morse-dyadic.json').read_text())
        with patch('search.finite_rank._Affine', side_effect=AssertionError('solver called')):
            result = verify(data)
        self.assertEqual(result['witnesses_verified'], 13)
        self.assertEqual(result['optima_verified'], 6)
        for mutation in ('index', 'endpoint', 'middle', 'shift', 'cutoff', 'dual',
                         'missing', 'duplicate', 'defect', 'extra_optimum'):
            bad = deepcopy(data)
            row = bad['witnesses'][3]
            if mutation == 'index': row['j'] -= 1
            elif mutation == 'endpoint': row['support'].pop()
            elif mutation == 'middle': row['support'][1] = 2
            elif mutation == 'shift': row['m'] += 1
            elif mutation == 'cutoff': row['limit'] -= 1
            elif mutation == 'dual':
                weights = row['optimum']['obstruction']['weights']
                weights[:] = [0]*len(weights)
            elif mutation == 'missing': bad['witnesses'].pop()
            elif mutation == 'duplicate': bad['witnesses'].append(row)
            elif mutation == 'defect': row['defect'] += 1
            else: bad['witnesses'][-1]['optimum'] = row['optimum']
            with self.subTest(mutation=mutation), self.assertRaises(ValueError):
                verify(bad)

    def test_invalid_inputs(self):
        for k in (-1, 1.5):
            with self.assertRaises(ValueError): family(k)
        for support, m, limit in (([],0,1), ([1],0,1), ([0,0],0,1),
                                  ([0,2,1],0,1), ([0],-1,1), ([0],0,0)):
            with self.assertRaises(ValueError):
                first_index(lambda n: 0, support, m, limit)
