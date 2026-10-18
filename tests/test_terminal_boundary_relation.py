"""Independent affine reconstruction and negative controls for boundary states."""
import unittest
from unittest.mock import patch

from search.finite_rank import _Affine
from search.run_rank_experiments import oracle
from search.terminal_boundary_relation import BoundaryRelations


def reconstruct(engine, t, m, n, state_vector):
    """Use a different solver, then check the solution with plain dot products."""
    p, N = engine.p, engine.N
    u, v = state_vector[:N], state_vector[N:]
    rows = [[oracle('lai_sprang', p, t+i+j)*pow(engine.H, -1, p) % p
             for j in range(n)] for i in range(m)]
    rhs = [sum(pow(z, i, p)*w for z, w in zip(engine.roots, u)) % p
           for i in range(m)]
    rows += [[pow(z, j, p) for j in range(n)] for z in engine.roots]
    rhs += list(v)
    system = _Affine(p, n)
    for row, value in zip(rows, rhs):
        system.add(row, value)
    if system.contradiction is not None:
        return None
    if len(system.rows) != n:
        raise AssertionError('invisible kernel: reconstruction is not unique')
    x = [system.rows[i][0][-1] for i in range(n)]
    assert all(sum(a*b for a, b in zip(row, x)) % p == value % p
               for row, value in zip(rows, rhs))
    return x


class BoundaryRelationTests(unittest.TestCase):
    def test_relation_basis_has_independent_unique_preimages(self):
        for p, t, m, n in ((3, 2, 2, 2), (5, 312, 12, 12),
                           (5, 313, 12, 13), (13, 1466, 80, 80),
                           (41, 255, 12, 11), (41, 256, 11, 12)):
            engine = BoundaryRelations(p)
            relation = engine.recursive(t, m, n)
            self.assertEqual(len(relation), engine.N+n-m)
            for vector in relation:
                self.assertIsNotNone(reconstruct(engine, t, m, n, vector))

    def test_terminal_target_recovers_known_polynomial_and_rejects_mutations(self):
        engine = BoundaryRelations(5)
        target = [0]*4+[1, 0, 0, 0]
        self.assertEqual(reconstruct(engine, 312, 12, 12, target),
                         [2, 3, 4, 0, 1, 3, 3, 3, 1, 3, 2, 1])
        self.assertIsNone(reconstruct(engine, 314, 12, 12, target))
        self.assertIsNone(reconstruct(engine, 312, 13, 12, target))
        self.assertIsNone(reconstruct(engine, 312, 12, 12, [0]*4+[1, 1, 0, 0]))

    def test_recursion_only_reads_scalar_hankel_bases(self):
        engine = BoundaryRelations(5)
        direct = engine.direct

        def guarded(t, m, n, independent=True):
            self.assertLessEqual(max(m, n), 1)
            return direct(t, m, n, independent)

        with patch.object(engine, 'direct', side_effect=guarded):
            self.assertTrue(engine.terminal(engine.recursive(312, 12, 12)))
        self.assertEqual(engine.max_merge_variables, 12)

    def test_domains_and_empty_blocks(self):
        for p in (2, 9, 15):
            with self.assertRaises(ValueError):
                BoundaryRelations(p)
        engine = BoundaryRelations(5)
        for args in ((0, 1, 1), (1, -1, 0), (1, 1, 3)):
            with self.assertRaises(ValueError):
                engine.recursive(*args)
        for m, n in ((0, 0), (0, 1), (1, 0)):
            self.assertEqual(engine.recursive(1, m, n), engine.direct(1, m, n)[0])


if __name__ == '__main__':
    unittest.main()
