"""Checks for search/terminal_witness.c: it reproduces the recorded witnesses,
accepts every side-N window of the number wall, and rejects other shifts."""
import json
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


@unittest.skipUnless(shutil.which('cc'), 'needs a C compiler')
class TerminalWitnessTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.tw = Path(cls.tmp.name) / 'terminal_witness'
        cls.wall = Path(cls.tmp.name) / 'number_wall'
        subprocess.run(['cc', '-O2', '-o', str(cls.tw), str(ROOT / 'search' / 'terminal_witness.c')], check=True)
        subprocess.run(['cc', '-O2', '-o', str(cls.wall), str(ROOT / 'search' / 'number_wall.c')], check=True)

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def extract(self, p, M, e, *extra):
        return subprocess.run([str(self.tw), str(p), str(M), str(e), *map(str, extra)],
                              capture_output=True, text=True)

    def test_reproduces_recorded_witnesses(self):
        recorded = json.loads((ROOT / 'results' / '2026-10-17-sharpness.json').read_text())['witnesses']
        for w in recorded:
            if w['p'] not in (5, 13, 29):
                continue
            out = Path(self.tmp.name) / f"w{w['p']}.json"
            r = self.extract(w['p'], w['M'], w['e'], out)
            self.assertEqual(r.returncode, 0, r.stderr)
            got = json.loads(out.read_text())['witnesses'][0]
            for key in ('M', 'e', 'V', 'S', 'D', 'm', 'lifted_degree', 'j', 'defect'):
                self.assertEqual(got[key], w[key], (w['p'], key))

    def test_wall_windows_are_witnesses_and_other_shifts_are_not(self):
        out = subprocess.run([str(self.wall), '5', '4', '1', '3000', '40', '4'],
                             capture_output=True, text=True, check=True).stdout
        windows = [tuple(map(int, line.split()[1:])) for line in out.splitlines()]
        self.assertTrue(windows)
        for m0, n0, g in windows[:40]:
            self.assertEqual(g, 4)
            r = self.extract(5, n0 - m0, m0)
            self.assertEqual(r.returncode, 0, (m0, n0, r.stderr))
        shifts = {n0 - m0 for m0, n0, _ in windows if m0 == 8}
        for M in range(301, 321):
            if M not in shifts:
                self.assertEqual(self.extract(5, M, 8, 'nolift').returncode, 2, M)


if __name__ == '__main__':
    unittest.main()
