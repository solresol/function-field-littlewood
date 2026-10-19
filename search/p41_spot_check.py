"""Independent spot-check of the p=41 witness with the repository's Python root-sum oracle.

    python3 search/p41_spot_check.py results/2026-10-19-sharpness-p41.json.gz

Checks S=(1+...+t^7)V, 20 terminal rows (row D+2=38) and five lifted rows.
About two minutes; standard library only.
"""
import gzip, json, random, sys, time
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from search.run_rank_experiments import oracle  # noqa: E402
path = sys.argv[1]
w = json.load(gzip.open(path) if path.endswith('.gz') else open(path))['witnesses'][0]
p, N, M, e, V, S, D = (w[k] for k in ('p', 'N', 'M', 'e', 'V', 'S', 'D'))
t0 = time.time()
assert len(V) == e + 1 and V[-1] == 1 and len(S) == D + 1 == e + N and S[0] and S[-1]
# S = (1+...+t^(N-1)) V by prefix sums, and division back
pre = [0]
for x in V: pre.append(pre[-1] + x)
assert all(S[k] == (pre[min(k, e) + 1] - pre[max(0, k - N + 1)]) % p for k in range(D + 1))
lo, hi = M + 1, M + 2 * D + 2
A = [oracle('lai_sprang', p, n) for n in range(lo, hi + 1)]
print('oracle values computed', round(time.time() - t0), 's')
def row(k):  # sum_i S_i a(M+i+k)
    off = k - 1
    return sum(s * A[i + off] for i, s in enumerate(S) if s) % p
rng = random.Random(41)
ks = [1, 2, 3, 100, D // 2, D - 1, D, D + 1, D + 2] + [rng.randint(1, D + 1) for _ in range(12)]
res = {k: row(k) for k in ks}
print('terminal rows', {k: v for k, v in sorted(res.items())})
assert all(v == 0 for k, v in res.items() if k <= D + 1) and res[D + 2] == w['terminal_value'] == 38
m, j = w['m'], w['j']
def lifted(k):
    return sum(s * oracle('lai_sprang', p, m + N * i + k) for i, s in enumerate(S) if s) % p
lk = {k: lifted(k) for k in (j, j - 1, j - 8, 3, N * (D // 2) + 5)}
print('lifted rows', lk)
assert lk[j] == 38 and all(v == 0 for k, v in lk.items() if k != j)
print('spot-check passed', round(time.time() - t0), 's')
