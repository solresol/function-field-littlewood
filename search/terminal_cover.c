/* All-shift terminal-window cover for the Lai--Sprang derived stream.

   Optional accelerator and independent cross-check for
   search/lai_sprang_sharpness.py. Python drives it through
   search/run_terminal_cover.py; see results/2026-10-17-lai-sprang-sharpness.md.

   Usage: terminal_cover p N E [blo bhi]

   For quotient degree e <= E a terminal window at shift M reads
   c_(M+1),...,c_(M+T), T=2N+2E. With L=2^l>T and P=NL, c_(qP+b+i)=c_(b+i)
   except at the (at most one) index divisible by L, replaced by x in {0,1,-1}.
   For each residue b in [blo,bhi) and each x, run the Euclidean continued
   fraction of sum_k s_k t^(-k), s_k=c_k+...+c_(k+N-1), k=1,...,2E+N+1, and
   print every partial quotient of degree >= N+1 at convergent degree <= E.
   This uses polynomial division, not the Berlekamp--Massey profile used by
   the Python generator. A truncated series that becomes rational at degree
   <= E is printed as a conservative event, never dropped.

   Output lines: "b=<b> x=<none|0|1|-1> e=<e> pq=<degree>"; one summary line
   is written to stderr. Arithmetic is exact modulo the prime p < 2^31. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int64_t P;
static long N;

static int64_t inv_mod(int64_t a) {
  int64_t r = 1, e = P - 2;
  a %= P;
  if (a < 0) a += P;
  while (e) {
    if (e & 1) r = r * a % P;
    a = a * a % P;
    e >>= 1;
  }
  return r;
}

/* Lai--Sprang coefficient divided by N/2. */
static int normalized(long n) {
  long o = n;
  while (o % 2 == 0) o /= 2;
  long m = (o - 1) % (2 * N);
  return m == 0 ? 1 : (m == N ? -1 : 0);
}

int main(int argc, char **argv) {
  if (argc < 4) {
    fprintf(stderr, "usage: p N E [blo bhi]\n");
    return 1;
  }
  setvbuf(stdout, NULL, _IOLBF, 0);
  P = atoll(argv[1]);
  N = atol(argv[2]);
  int E = atoi(argv[3]);
  int T = 2 * N + 2 * E;
  long L = 1;
  while (L <= T) L *= 2;
  long period = N * L;
  int length = 2 * E + N + 1;
  long blo = argc > 4 ? atol(argv[4]) : 0;
  long bhi = argc > 5 ? atol(argv[5]) : period;
  if (bhi > period) bhi = period;
  int64_t *A = malloc((length + 2) * sizeof(int64_t));
  int64_t *B = malloc((length + 2) * sizeof(int64_t));
  int64_t *c = malloc((T + 2) * sizeof(int64_t));
  long cases = 0, hits = 0;
  int least = -1;
  for (long b = blo; b < bhi; b++) {
    long hole = -1;
    for (long i = 1; i <= T; i++)
      if ((b + i) % L == 0) { hole = i; break; }
    int variants = hole < 0 ? 1 : 3;
    for (int v = 0; v < variants; v++) {
      cases++;
      for (long i = 1; i <= T; i++) c[i] = normalized(b + i);
      if (hole >= 0) c[hole] = v == 0 ? 0 : (v == 1 ? 1 : -1);
      memset(A, 0, (length + 2) * sizeof(int64_t));
      A[length] = 1; /* t^length */
      for (int k = 1; k <= length; k++) {
        int64_t s = 0;
        for (long i = 0; i < N; i++) s += c[k + i];
        s %= P;
        if (s < 0) s += P;
        B[length - k] = s;
      }
      int dx = length, dy = length - 1;
      while (dy >= 0 && B[dy] == 0) dy--;
      int64_t *X = A, *Y = B;
      const char *xs = hole < 0 ? "none" : (v == 0 ? "0" : (v == 1 ? "1" : "-1"));
      /* Partial quotient deg(X)-deg(Y) at convergent degree length-deg(X) is
         valid for the infinite series while deg X + deg Y >= length. */
      while (dy >= 0 && dx + dy >= length) {
        int q = dx - dy, e = length - dx;
        if (e > E) break;
        if (q >= N + 1) {
          hits++;
          if (least < 0 || e < least) least = e;
          printf("b=%ld x=%s e=%d pq=%d\n", b, xs, e, q);
        }
        int64_t inverse = inv_mod(Y[dy]);
        for (int i = dx; i >= dy; i--) {
          int64_t f = X[i] * inverse % P;
          if (f == 0) continue;
          int64_t g = P - f;
          int off = i - dy;
          for (int j = 0; j <= dy; j++) X[off + j] = (X[off + j] + g * Y[j]) % P;
        }
        int nd = dy - 1;
        while (nd >= 0 && X[nd] == 0) nd--;
        int64_t *swap = X;
        X = Y; Y = swap; dx = dy; dy = nd;
      }
      if (dy < 0 && length - dx <= E && length + 1 - 2 * (length - dx) >= N + 1) {
        int e = length - dx;
        hits++;
        if (least < 0 || e < least) least = e;
        printf("b=%ld x=%s e=%d pq=rational\n", b, xs, e);
      }
    }
  }
  fprintf(stderr, "p=%lld N=%ld E=%d T=%d L=%ld P=%ld b=[%ld,%ld) cases=%ld hits=%ld least_e=%d\n",
          (long long)P, N, E, T, L, period, blo, bhi, cases, hits, least);
  return 0;
}
