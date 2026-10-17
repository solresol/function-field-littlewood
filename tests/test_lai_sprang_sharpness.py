"""Regression and mutation controls for the 17 October sharpness witnesses."""
import json
from pathlib import Path
import unittest

from search.lai_sprang_sharpness import (
    cover_cases, cover_parameters, derived_window, direct_rank_exclusion,
    garrett_robertson_witness, kernel, morphism_sequence, paperfolding_level2,
    profile_jumps, rows, scan_cover, terminal_events, verify_garrett_robertson,
    verify_witness, witness,
)


class SharpnessTests(unittest.TestCase):
    def test_small_witnesses_read_back_from_root_sums(self):
        for p, lifted, m, j in ((5, 44, 1244, 52), (13, 316, 5860, 324)):
            w = witness(p)
            self.assertEqual(w['kernel_dimension'], 1)
            result = verify_witness(w)
            self.assertEqual((result['lifted_degree'], result['m'], result['j']),
                             (lifted, m, j))
            self.assertEqual(result['defect'], 8)

    def test_p5_witness_is_the_lean_polynomial(self):
        w = witness(5)
        self.assertEqual(w['V'], [2, 1, 1, 1, 3, 3, 1, 1, 1])
        self.assertEqual(w['S'], [2, 3, 4, 0, 1, 3, 3, 3, 1, 3, 2, 1])

    def test_mutations_are_rejected(self):
        w = witness(5)
        broken = dict(w, S=list(w['S']))
        broken['S'][5] = (broken['S'][5] + 1) % 5
        with self.assertRaises(AssertionError):
            verify_witness(broken)
        with self.assertRaises(AssertionError):
            verify_witness(dict(w, M=w['M'] + 2, m=w['m'] + 8))
        with self.assertRaises(AssertionError):
            verify_witness(dict(w, j=w['j'] - 1))
        # The lift needs the full factor: V(t^4) alone is not a terminal witness.
        S = w['V'] + [0] * 3
        values = rows(5, S, w['M'], len(S) + 1)
        self.assertTrue(any(values[:-1]))

    def test_p5_minimality_two_ways(self):
        self.assertEqual(scan_cover(5, 7)['hits'], [])
        hits = scan_cover(5, 8)['hits']
        self.assertEqual([(h['b'], h['x'], h['e'], h['jump']) for h in hits],
                         [(55, -1, 8, 5), (119, -1, 8, 5)])
        self.assertEqual(direct_rank_exclusion(5, 8), [(55, -1, 8), (119, -1, 8)])
        # The witness shift 311 realises residue 55 with c_320=c_5=-1.
        _, L, P, _ = cover_parameters(4, 8)
        self.assertEqual((311 % P, (311 + 9) % L), (55, 0))

    def test_cover_is_complete_and_holes_are_unique(self):
        N, E = 4, 8
        T, L, P, _ = cover_parameters(N, E)
        self.assertLess(T, L)
        cases = list(cover_cases(N, E))
        self.assertEqual(len({b for b, _ in cases}), P)
        for b, x in cases:
            holes = [i for i in range(1, T + 1) if (b + i) % L == 0]
            self.assertLessEqual(len(holes), 1)
            self.assertEqual(x is None, not holes)

    def test_profile_detects_the_genuine_r1_terminal_window(self):
        # Over F_3, S=1+t at M=1 has rows 0,0,2: a terminal window at e=0.
        s = [sum(rows(3, [1], v, 1)[0] for v in (k, k + 1)) for k in range(1, 6)]
        events = terminal_events(3, 2, 2, s)
        self.assertIn((0, 3), events)

    def test_profile_degrees_match_nullspaces(self):
        # Jump from complexity e of size q means exactly q-1 extra zero rows.
        for b, x in list(cover_cases(4, 8))[:80]:
            s = derived_window(4, 8, b, x)
            jumps, _ = profile_jumps(s, 5)
            for e, q in jumps:
                if 2 * e + q > len(s):
                    continue
                A = [s[k:k + e + 1] for k in range(e + q - 1)]
                if len(A) > e:  # otherwise a kernel exists for dimension reasons
                    self.assertTrue(kernel(A, 5))
                A.append(s[e + q - 1:e + q + e])
                self.assertFalse(kernel(A, 5))

    def test_garrett_robertson_level2_deficiency_eight(self):
        u = morphism_sequence(4096)
        self.assertEqual(u, [paperfolding_level2(k + 1) for k in range(4096)])
        result = verify_garrett_robertson(garrett_robertson_witness())
        self.assertEqual((result['d'], result['j'], result['deficiency']), (64, 72, 8))

    def test_recorded_results_if_present(self):
        path = Path('results/2026-10-17-sharpness.json')
        if not path.exists():
            self.skipTest('dated sharpness record absent')
        data = json.loads(path.read_text())
        self.assertEqual([w['p'] for w in data['witnesses']], [5, 13, 29, 37, 53])
        for w in data['witnesses']:
            self.assertEqual(w['j'] - w['lifted_degree'], 2 * w['N'])
        self.assertEqual([(c['p'], c['excluded_through'], c['hits_below'])
                          for c in data['covers']],
                         [(5, 7, []), (13, 75, []), (29, 325, [])])


if __name__ == '__main__':
    unittest.main()
