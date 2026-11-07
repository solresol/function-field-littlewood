"""Exact controls for the ordinary 8 November reachable-family lemma.

These prescribed identity checks are not an attainment or suffix search.
Original root sums are independent of the support formula/state recurrence.
"""
import unittest

from search.correlated_boundary_state import COMPONENTS, CorrelatedStates
from search.lai_sprang_sharpness import normalized, v2
from search.run_rank_experiments import oracle
from search.terminal_boundary_relation import BoundaryRelations, basis, null


CONTEXTS = tuple((p, v2(p-1)+offset)
                 for p in (3, 5, 13, 41) for offset in (1, 2))


def dot(x, y, p):
    return sum(a*b for a, b in zip(x, y)) % p


class DyadicCornerFamilyTests(unittest.TestCase):
    def test_exact_original_coefficient_windows(self):
        for p, s in CONTEXTS:
            r, N, k = v2(p-1), 1 << v2(p-1), 1 << (s-1)
            for a in (s+r, s+r+1, s+r+2):
                with self.subTest(p=p, s=s, a=a):
                    B = 1 << a
                    expected = ([p-1 if N == 2 else 0, 1]
                                + [normalized(N, j) % p for j in range(1, 2*k)]
                                + [p-1 if a == s+r else 1])
                    actual = [oracle('lai_sprang', p, B+j)*pow(N//2, -1, p) % p
                              for j in range(-1, 2*k+1)]
                    self.assertEqual(actual, expected)

    def test_seven_relations_and_full_state_stabilization(self):
        for p, s in CONTEXTS:
            with self.subTest(p=p, s=s):
                r, k = v2(p-1), 1 << (s-1)
                E, M = BoundaryRelations(p), CorrelatedStates(p)
                states = []
                for a in (s+r, s+r+1, s+r+2):
                    q = (1 << a)-2
                    state = M.evaluate(q, k)
                    for (d, i, j), R in zip(COMPONENTS, state.relations):
                        direct, invisible = E.direct(q+1+d, k+i, k+j)
                        self.assertEqual(R, direct)
                        self.assertEqual(invisible, 0)
                    states.append(state)
                self.assertEqual(states[0].relations[:7], states[1].relations[:7])
                self.assertNotEqual(states[0].relations[7], states[1].relations[7])
                self.assertEqual(states[1], states[2])
                self.assertEqual({state.phase for state in states}, {(-2) % E.N})
                self.assertEqual({state.size_cap for state in states}, {E.N})

    def test_endpoint_equations_give_entire_abstract_pencil(self):
        for p, s in CONTEXTS:
            with self.subTest(p=p, s=s):
                E = BoundaryRelations(p)
                N, k, B = E.N, 1 << (s-1), 1 << (s+v2(p-1))
                roots = E.roots
                c = lambda j: oracle('lai_sprang', p, B+j)*pow(N//2, -1, p) % p
                rows = [[-pow(z, i, p) % p for z in roots]
                        + [c(i+j) for j in range(k+1)] for i in range(k)]
                S = null(rows, N+k+1, p)
                # The unknown endpoint is omitted from phi and recorded by psi.
                phi = [-pow(z, k, p) % p for z in roots] + [c(k+j) for j in range(k)]+[0]
                psi = [0]*(N+k)+[1]
                moment_rows = [[pow(z, j, p) for j in range(k+1)] for z in roots]
                frame = [tuple(w[:N])+tuple(dot(row, w[N:], p) for row in moment_rows)
                         for w in S]
                self.assertEqual(len(S), N+1)
                self.assertEqual(len(basis(frame, p)), N+1)
                self.assertTrue(all(dot(row, w, p) == 0 for row in rows for w in S))
                f, g = [dot(phi, w, p) for w in S], [dot(psi, w, p) for w in S]
                self.assertEqual(len(basis([f, g], p)), 2)

                def project(weights):
                    return basis([tuple(sum(a*v[j] for a, v in zip(w, frame)) % p
                                        for j in range(2*N)) for w in weights], p)

                W, L = basis(frame, p), project(null([f, g], N+1, p))
                self.assertEqual(W, E.direct(B, k, k+1)[0])
                self.assertEqual(L, E.direct(B, k+1, k)[0])
                outputs = {}
                for x in (None, *range(p)):
                    equation = g if x is None else [(u+x*v) % p for u, v in zip(f, g)]
                    R = project(null([equation], N+1, p))
                    self.assertEqual(len(R), N)
                    self.assertEqual(basis(R+L, p), R)
                    self.assertEqual(basis(R+W, p), W)
                    outputs[x] = R
                self.assertEqual(len(set(outputs.values())), p+1)
                self.assertEqual(outputs[None], E.direct(B, k, k)[0])
                self.assertEqual(outputs[p-1], E.direct(B, k+1, k+1)[0])
                self.assertEqual(outputs[1], E.direct(2*B, k+1, k+1)[0])


if __name__ == '__main__':
    unittest.main()
