"""The determinant obstruction, independent readback and exact scope."""
from copy import deepcopy
import json
import unittest
from unittest.mock import patch

from search import repeated_linear_obstruction as R
from search.terminal_boundary_relation import BoundaryRelations


class RepeatedLinearObstructionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data = json.loads(R.DEFAULT.read_text())

    def test_regeneration_and_independent_readback(self):
        self.assertEqual(R.generate(), self.data)
        with patch.multiple(R, **{name: unittest.mock.Mock(side_effect=AssertionError(name))
                                for name in ('seed', 'step', 'merge', 'wedge', 'formal_series')}):
            self.assertEqual(R.verify(self.data)['gcd'], 18)

    def test_corrupted_certificate_rejected(self):
        edits = (
            lambda d: d['records'][0].update(determinant=d['records'][0]['determinant']+1),
            lambda d: d['records'][1].update(endpoint_inclusive=1155),
            lambda d: d['records'][0]['contexts'][1].__setitem__(1, 70),
            lambda d: d['bezout'].__setitem__(0, d['bezout'][0]+1),
        )
        for edit in edits:
            data = deepcopy(self.data)
            edit(data)
            with self.assertRaises(ValueError):
                R.verify(data)

    def test_existing_terminal_semantics_including_r1(self):
        # Transversality does not say either relation accepts/rejects tau.
        for p, t, size, accepted in ((3, 2, 2, True), (5, 312, 12, True),
                                      (5, 314, 12, False)):
            E = BoundaryRelations(p)
            direct, invisible = E.direct(t, size, size)
            self.assertEqual(invisible, 0)
            self.assertEqual(E.terminal(direct), accepted)


if __name__ == '__main__':
    unittest.main()
