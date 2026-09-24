"""Independent recurrence identities, exact locality and corruption controls."""
from copy import deepcopy
import json
from pathlib import Path
import unittest
from unittest.mock import patch

from search.rudin_shapiro_dyadic import family, verify
from search.run_rank_experiments import oracle, stream
from search.thue_morse_dyadic import first_index


class RudinShapiroTests(unittest.TestCase):
    def test_binary_block_identity(self):
        # All splits in these boxes, including leading zero padding of the low block.
        b = lambda n: stream('rudin_shapiro', 2, n)
        for k in range(1, 9):
            L = 1 << k
            for q in range(32):
                for s in range(L):
                    self.assertEqual(b(q*L+s), (b(q)+b(s)+(q%2)*(s//(L//2))) % 2)

    def test_four_block_scaling_at_every_residue(self):
        b = lambda n: oracle('rudin_shapiro', 2, n)
        for k in range(9):
            L = 1 << k
            support = family(k)['support']
            for n in range(32*L):
                actual = sum(b(n+i) for i in support) % 2
                expected = 0 if (n+1) % L else b((n+1)//L-1)^b((n+1)//L+3)
                self.assertEqual(actual, expected)

    def test_sparse_dense_cutoff_and_locality(self):
        self.assertEqual(family(0)['support'], [0, 4])
        for k in range(7):
            row = family(k)
            m, j, d, support = (row[x] for x in ('m', 'limit', 'd', 'support'))
            calls = []
            def a(n):
                calls.append(n)
                return stream('rudin_shapiro', 2, n)
            self.assertIsNone(first_index(a, support, m, j-1))
            self.assertEqual(max(calls), m+d+j-1)
            calls.clear()
            self.assertEqual(first_index(a, support, m, j), j)
            self.assertEqual(max(calls), m+d+j)
            R = [int(i in support) for i in range(d+1)]
            values = [sum(r*oracle('rudin_shapiro', 2, m+i+s)
                          for i, r in enumerate(R)) % 2 for s in range(1, j+1)]
            self.assertEqual(values, [0]*(j-1)+[1])
            self.assertEqual(first_index(lambda n: 1-a(n), support, m, j), j)

    def test_saved_without_generator_or_solver_and_mutations(self):
        data = json.loads(Path('results/2026-09-25-rudin-shapiro-dyadic.json').read_text())
        with patch('search.finite_rank._Affine', side_effect=AssertionError('solver called')), \
                patch('search.rudin_shapiro_dyadic.stream', side_effect=AssertionError('generator called')):
            result = verify(data)
        self.assertEqual(result['witnesses_verified'], 13)
        self.assertEqual(result['optima_verified'], 5)
        for mutation in ('index', 'endpoint', 'middle', 'shift', 'cutoff', 'dual',
                         'missing', 'duplicate', 'defect', 'extra_optimum', 'false_zero'):
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
            elif mutation == 'false_zero': row['optimum']['zero_prefix'] += 1
            else: bad['witnesses'][-1]['optimum'] = row['optimum']
            with self.subTest(mutation=mutation), self.assertRaises(ValueError):
                verify(bad)

    def test_invalid_scale(self):
        for k in (-1, 1.5, True):
            with self.assertRaises(ValueError): family(k)
