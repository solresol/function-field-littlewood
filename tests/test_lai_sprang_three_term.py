"""Independent family witnesses, exception, cutoffs and corrupt evidence."""
from copy import deepcopy
from itertools import product
import json
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest
from unittest.mock import patch

from search import lai_sprang_three_term as family
from search.lai_sprang_finite_search import first_fractional_index
from search.run_rank_experiments import oracle

SAVED = Path('results/2026-09-28-three-term.jsonl')


class ThreeTermTests(unittest.TestCase):
    def test_saved_readback_without_generation(self):
        with patch.object(family, 'coeff', side_effect=AssertionError), \
                patch.object(family, 'sparse_index', side_effect=AssertionError), \
                patch.object(family, 'longest_prefix', side_effect=AssertionError):
            result = family.verify(SAVED)
        self.assertEqual((result['witnesses_verified'], result['optima_verified'],
                          result['unresolved']), (17, 8, 0))
        for row in result['cases']:
            if row['N'] == 4:
                self.assertEqual((row['j'], row['optimum_j']), (1, 4))
            elif row['N'] >= 8:
                self.assertEqual(row['j'], 2*row['N'])
            else:
                self.assertEqual(row['defect'], 4)

    def test_sparse_dense_cutoffs_and_tail_locality(self):
        for row in map(json.loads, SAVED.read_text().splitlines()):
            p, d, m, j = (row['p'], row['d'], row['m'], row['witness']['j'])
            def a(n):
                self.assertLessEqual(n, m+d+j)
                return oracle('lai_sprang', p, n)
            self.assertEqual(family.sparse_index(p, a, row['terms'], m, j),
                             row['witness'])
            R = [0]*(d+1)
            for i, c in row['terms']:
                R[i] = c
            self.assertEqual(first_fractional_index(p, tuple(R), m, j), j)
            if j > 1:
                self.assertEqual(family.sparse_index(p, a, row['terms'], m, j-1),
                                 dict(j=None, zero_prefix=j-1, terminal=None))
            changed = lambda n: a(n) if n <= m+d+j else 1
            self.assertEqual(family.sparse_index(p, changed, row['terms'], m, j),
                             row['witness'])

    def test_exhaustive_tiny_generic_streams(self):
        # All F2 length-7 streams and normalised degree-2 multipliers.
        for values in product(range(2), repeat=7):
            a = lambda n: values[n-1]
            for middle in range(2):
                R = [1, middle, 1]
                terms = [[i, c] for i, c in enumerate(R) if c]
                for m in range(2):
                    residual = [sum(R[i]*a(m+i+j) for i in range(3)) % 2
                                for j in range(1, 5)]
                    j = next((k+1 for k, v in enumerate(residual) if v), None)
                    expected = dict(j=j, zero_prefix=4 if j is None else j-1,
                                    terminal=None if j is None else residual[j-1])
                    self.assertEqual(family.sparse_index(2, a, terms, m, 4), expected)

    def test_corrupt_or_incomplete_records_rejected(self):
        original = [json.loads(line) for line in SAVED.read_text().splitlines()]
        mutations = []
        for key in ('j', 'zero_prefix', 'terminal'):
            rows = deepcopy(original)
            rows[0]['witness'][key] += 1
            mutations.append(rows)
        for key in ('p', 'N', 'd', 'm', 'limit'):
            rows = deepcopy(original)
            rows[0][key] += 1
            mutations.append(rows)
        rows = deepcopy(original)
        rows[0]['terms'][-1][1] = 0
        mutations.append(rows)
        rows = deepcopy(original)
        rows[0]['optimum']['obstruction']['weights'] = [0]*5
        mutations.append(rows)
        rows = deepcopy(original)
        rows[0]['optimum'] = None
        mutations.append(rows)
        rows = deepcopy(original)
        rows[-1]['optimum'] = original[0]['optimum']
        mutations.append(rows)
        mutations.extend([original[:-1], original+[original[0]],
                          [original[1], original[0]]+original[2:]])
        with TemporaryDirectory() as temp:
            path = Path(temp)/'bad.jsonl'
            for rows in mutations:
                path.write_text(''.join(json.dumps(r)+'\n' for r in rows))
                with self.assertRaises(ValueError):
                    family.verify(path)

    def test_invalid_inputs_and_no_overwrites(self):
        for terms in ([], [[1, 1]], [[0, 0]], [[0, 3]],
                      [[0, 1], [0, 2]], [[0, 1], [2, 1], [1, 1]]):
            with self.assertRaises(ValueError):
                family.sparse_index(3, lambda n: 0, terms, 0, 4)
        for p, m, limit in ((9, 0, 4), (3, -1, 4), (3, 0, 0)):
            with self.assertRaises(ValueError):
                family.sparse_index(p, lambda n: 0, [[0, 1]], m, limit)
        with TemporaryDirectory() as temp:
            path = Path(temp)/'existing.jsonl'
            path.write_text('preserve me')
            with self.assertRaises(FileExistsError):
                family.run(path)
            self.assertEqual(path.read_text(), 'preserve me')
