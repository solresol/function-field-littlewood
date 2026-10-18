/* Distinct factors of length L among positions 1..X-L+1 of the Lai--Sprang
   derived stream b_v=c_v+...+c_(v+N-1) (c normalized, values 0,+-1).

   Usage: factor_counts N X L...   (prints one line per L)

   A number-wall cell W[m][n] of S_j=b_(j+1) depends only on the factor
   b_(n-m+1..n+m+1), so the distinct cells of row m of a width-X wall number
   at most the distinct factors of length 2m+1 among positions 1..X-2m.
   search/number_wall_summary.py integrates these counts into the expected
   number of side-N windows. Factors are compared through a polynomial hash
   modulo the prime 2^61-1 with a fixed base; a collision could only lower
   a count, which keeps that estimate conservative. Compile: cc -O2. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
static const uint64_t MOD = (1ULL << 61) - 1;
static uint64_t mulm(uint64_t a, uint64_t b) { __uint128_t z = (__uint128_t)a * b; uint64_t lo = (uint64_t)(z & MOD), hi = (uint64_t)(z >> 61); uint64_t r = lo + hi; return r >= MOD ? r - MOD : r; }
static long NN;
static long cnorm(long n) { long o = n; while (o % 2 == 0) o /= 2; long m = (o - 1) % (2 * NN); return m == 0 ? 1 : (m == NN ? -1 : 0); }
static int cmp(const void *a, const void *b) { uint64_t x = *(const uint64_t *)a, y = *(const uint64_t *)b; return x < y ? -1 : x > y; }
int main(int argc, char **argv) {
  NN = atol(argv[1]); long X = atol(argv[2]);
  int8_t *b = malloc(X + 2);
  for (long v = 1; v <= X; v++) { long s = 0; for (long i = 0; i < NN; i++) s += cnorm(v + i); b[v] = (int8_t)s; }
  uint64_t B = 0x1234567890abcdfULL % MOD, *h = malloc(sizeof(uint64_t) * X);
  for (int a = 3; a < argc; a++) {
    long L = atol(argv[a]); if (L > X) continue;
    uint64_t BL = 1; for (long i = 0; i < L; i++) BL = mulm(BL, B);
    uint64_t cur = 0; long n = 0;
    for (long v = 1; v <= X; v++) {
      cur = mulm(cur, B) + (uint64_t)(b[v] + 16); if (cur >= MOD) cur -= MOD;
      if (v > L) { uint64_t sub = mulm(BL, (uint64_t)(b[v - L] + 16)); cur = cur >= sub ? cur - sub : cur + MOD - sub; }
      if (v >= L) h[n++] = cur;
    }
    qsort(h, n, sizeof *h, cmp);
    long d = n ? 1 : 0; for (long i = 1; i < n; i++) d += h[i] != h[i - 1];
    printf("L=%ld positions=%ld distinct=%ld distinct/L=%.3f\n", L, n, d, (double)d / L);
    fflush(stdout);
  }
  return 0;
}
