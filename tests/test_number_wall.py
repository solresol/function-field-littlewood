"""Checks for search/number_wall.c: direct Toeplitz determinants and the
correspondence of side-N windows with terminal windows found by the profile."""
import random
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

from search.lai_sprang_sharpness import normalized, terminal_events

SOURCE = Path(__file__).resolve().parents[1] / 'search' / 'number_wall.c'


def det_mod(rows, p):
    a = [r[:] for r in rows]
    n, d = len(a), 1
    for c in range(n):
        piv = next((i for i in range(c, n) if a[i][c] % p), None)
        if piv is None:
            return 0
        if piv != c:
            a[c], a[piv] = a[piv], a[c]
            d = -d
        d = d * a[c][c] % p
        inv = pow(a[c][c], p - 2, p)
        for i in range(c + 1, n):
            f = a[i][c] * inv % p
            if f:
                for j in range(c, n):
                    a[i][j] = (a[i][j] - f * a[c][j]) % p
    return d % p


@unittest.skipUnless(shutil.which('cc'), 'needs a C compiler')
class NumberWallTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'number_wall'
        subprocess.run(['cc', '-O2', '-o', str(cls.binary), str(SOURCE)], check=True)

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_wall(self, args, stdin=''):
        return subprocess.run([str(self.binary)] + [str(x) for x in args], input=stdin,
                              capture_output=True, text=True, check=True).stdout

    def test_wall_equals_toeplitz_determinants_with_windows(self):
        rng = random.Random(7)
        checked, largest = 0, 0
        for _ in range(60):
            p = rng.choice([3, 5, 7, 11])
            seq = [0 if rng.random() < rng.random() * 0.85 else rng.randrange(p)
                   for _ in range(rng.randint(15, 40))]
            out = self.run_wall([p, 4, 2, len(seq), len(seq) // 2, 2, 'dump'],
                                ' '.join(map(str, seq)))
            for line in out.splitlines():
                if line.startswith('window'):
                    largest = max(largest, int(line.split()[3]))
                if not line.startswith('row'):
                    continue
                head, values = line.split(':')
                m = int(head.split()[1])
                lo = int(head.split('[')[1].split(',')[0])
                for i, v in enumerate(map(int, values.split())):
                    n = lo + i
                    if n - m < 0 or n + m >= len(seq):
                        continue
                    T = [[seq[n + a - b] for b in range(m + 1)] for a in range(m + 1)]
                    self.assertEqual(v, det_mod(T, p), (p, seq, m, n))
                    checked += 1
        self.assertGreater(checked, 5000)
        self.assertGreaterEqual(largest, 5)  # frame equations were exercised

    def test_side_four_windows_are_terminal_windows_p5(self):
        p, N, C, R = 5, 4, 4000, 60
        out = self.run_wall([p, N, 1, C, R, 4])
        wall = {(int(n0) - int(m0), int(m0)) for _, m0, n0, g in
                (line.split() for line in out.splitlines()) if g == '4'}
        self.assertTrue(all(g == '4' for *_, g in (l.split() for l in out.splitlines())))
        # Profile on actual shifts, restricted to windows comfortably inside the wall.
        profile = set()
        for M in range(400, 3000):
            s = [sum(normalized(N, M + k + i) for i in range(N)) for k in range(1, 2 * 50 + N + 2)]
            profile |= {(M, e) for e, q in terminal_events(p, N, 50, s) if q}
        inside = {(M, d) for M, d in wall if 400 <= M < 3000 and d <= 50}
        self.assertEqual(inside, profile)
        self.assertTrue(profile)


if __name__ == '__main__':
    unittest.main()
