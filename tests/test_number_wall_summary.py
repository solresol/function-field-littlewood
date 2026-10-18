"""Checks for search/number_wall_summary.py: the shift equivalence behind its
all-shift exclusion, and the summary of a small run."""
import json
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'search'))
from number_wall_summary import equivalent_q_suffices  # noqa: E402


@unittest.skipUnless(shutil.which('cc'), 'needs a C compiler')
class NumberWallSummaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.wall = Path(cls.tmp.name) / 'number_wall'
        subprocess.run(['cc', '-O2', '-o', str(cls.wall), str(ROOT / 'search' / 'number_wall.c')], check=True)

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def test_every_value_of_the_hole_occurs_for_q_at_most_N(self):
        for N in (2, 4, 8, 16, 32):
            self.assertTrue(equivalent_q_suffices(N), N)

    def test_terminal_windows_recur_in_the_equivalent_shift_range(self):
        """At p=5, every side-4 window of degree <= E=27 (L=64, P=256) at any
        computed shift reappears at some shift q'P+(M mod P) with 1<=q'<=N."""
        N, P, E = 4, 256, 27
        out = subprocess.run([str(self.wall), '5', '4', '1', '12000', '40', '4'],
                             capture_output=True, text=True, check=True).stdout
        wins = {(n0 - m0, m0) for m0, n0, g in (map(int, l.split()[1:]) for l in out.splitlines())}
        hits = [(M, e) for M, e in wins if e <= E and 300 <= M < 11000]
        self.assertGreater(len(hits), 100)
        for M, e in hits:
            self.assertTrue(any((q * P + M % P, e) in wins for q in range(1, N + 1)), (M, e))

    def test_summary_of_a_small_run(self):
        run = Path(self.tmp.name) / 'run'
        run.mkdir()
        with open(run / 'windows.out', 'w') as out, open(run / 'progress.err', 'w') as err:
            subprocess.run([str(self.wall), '13', '4', '1', '6000', '2900', '4', 'progress=100'],
                           stdout=out, stderr=err, check=True)
        target = Path(self.tmp.name) / 'summary.json'
        subprocess.run([sys.executable, str(ROOT / 'search' / 'number_wall_summary.py'), str(run), str(target),
                        '--p', '13', '--C', '6000'], capture_output=True, check=True)
        s = json.loads(target.read_text())
        self.assertEqual(s['N'], 4)
        self.assertTrue(s['side_N_windows'])            # p=13 attains 2N at e=76
        self.assertTrue(all(w['g'] == 4 for w in s['side_N_windows']))
        self.assertEqual(min(w['e'] for w in s['side_N_windows']), 76)
        # the first window at degree 76 caps the exclusion below the next power-of-two step
        self.assertEqual(s['all_shift_exclusion']['E'], 59)
        # bands count windows first seen after row 0, through the last logged row 2900
        self.assertEqual(sum(b['windows_by_side'].get('4', 0) for b in s['bands']),
                         sum(1 for w in s['side_N_windows'] if w['e'] >= 1))


if __name__ == '__main__':
    unittest.main()
