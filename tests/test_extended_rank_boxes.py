"""Reject incomplete/corrupt evidence, and check readback without elimination."""
import copy
import json
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest
from unittest.mock import patch

from search import extended_rank_boxes as boxes
from search.finite_rank import longest_prefix
from search.run_rank_experiments import oracle


SAVED = Path('results/2026-09-23-extended-rank.jsonl')


class ExtendedBoxesTests(unittest.TestCase):
    def test_saved_without_solver(self):
        with patch('search.finite_rank._Affine', side_effect=AssertionError('solver called')):
            result = boxes.verify(SAVED)
        self.assertEqual(result['verified'], 5136)
        for s in result['boxes'].values():
            self.assertEqual(s['unresolved'], 0)
            self.assertEqual(sum(s['obstructions'].values()), s['checked'])

    def test_corruption_and_completeness(self):
        rows = [json.loads(line) for line in SAVED.read_text().splitlines()]
        original = rows[0]
        name, p, d, m = (original[k] for k in ('stream', 'p', 'd', 'm'))
        single = ((name, p, d, d, m, m),)
        mutations = []
        for field, value in (('j', 128), ('R', [1]+[0]*d),
                             ('zero_prefix', 128), ('obstruction', None)):
            row = copy.deepcopy(original)
            row['result'][field] = value
            mutations.append([row])
        row = copy.deepcopy(original)
        row['result']['obstruction']['weights'] = [0]*len(row['result']['obstruction']['weights'])
        mutations.append([row])
        for field, value in (('limit', 127), ('m', m+1), ('stream', 'thue_morse')):
            row = copy.deepcopy(original)
            row[field] = value
            mutations.append([row])
        mutations.extend(([], [original, original]))
        with TemporaryDirectory(dir='.') as tmp, patch.object(boxes, 'BOXES', single):
            path = Path(tmp)/'data.jsonl'
            path.write_text(json.dumps(original)+'\n')
            self.assertEqual(boxes.verify(path)['verified'], 1)
            for records in mutations:
                path.write_text(''.join(json.dumps(row)+'\n' for row in records))
                with self.assertRaises(ValueError):
                    boxes.verify(path)

    def test_exact_cutoff_and_locality_for_both_streams(self):
        rows = [json.loads(line) for line in SAVED.read_text().splitlines()]
        for name, p in (('lai_sprang', 17), ('rudin_shapiro', 2)):
            row = max((r for r in rows if r['stream'] == name), key=lambda r:r['result']['j']-r['d'])
            d, m, j = row['d'], row['m'], row['result']['j']
            def a(n):
                self.assertLessEqual(n, m+d+j)
                return oracle(name, p, n)
            result = longest_prefix(p, a, d, m, j)
            self.assertEqual(result.j, j)
            short = longest_prefix(p, a, d, m, j-1)
            self.assertIsNone(short.j)
            self.assertEqual(short.zero_prefix, j-1)


if __name__ == '__main__':
    unittest.main()
