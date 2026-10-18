/* Extract and verify a Lai--Sprang terminal witness at a given shift.

   Usage: terminal_witness p M e [out.json] [nolift]

   N=2^v2(p-1). A zero window of side N with top-left (m0,n0) in the number
   wall of the derived stream (search/number_wall.c, mode 1) is a terminal
   window at shift M=n0-m0 and quotient degree e=m0. This program runs
   Berlekamp--Massey on s_k=b_(M+k), k=1..2e+N+1, with b_v=c_v+...+c_(v+N-1)
   and c the normalized stream, and stops where the linear complexity e is
   about to jump; the jump must be N+1. V is the reversed connection
   polynomial (monic of degree e) and S=(1+t+...+t^(N-1))V, D=deg S. This
   mirrors witness() in search/lai_sprang_sharpness.py.

   Readback uses only the root-sum definition of the original stream,
   a(n)=sum over z with z^(N/2)=-1 of z^((u-1)/2), u the odd part of n (the
   oracle in search/run_rank_experiments.py): rows sum_i S_i a(M+i+k) vanish
   for k=1..D+1 and row D+2 is nonzero; the lift R=S(t^N) at m=NM has rows
   sum_i S_i a(m+Ni+k) vanishing for k=1..j-1, j=N(D+2), and row j equal to
   terminal row D+2, so the defect is j-ND=2N. S/(1+...+t^(N-1)) is divided
   out again and must return V with no remainder. Two mutations (one
   coefficient of S, and the shift M+2) must each be rejected.
   Exit status 0 only if every check passes. Compile: cc -O3 -march=native
   -fopenmp. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

static long P, N;

static long powm(long a, long e) {
  long r = 1; a %= P; if (a < 0) a += P;
  while (e) { if (e & 1) r = r * a % P; a = a * a % P; e >>= 1; }
  return r;
}
static long cnorm(long n) { /* normalized Lai--Sprang coefficient in {0,1,-1} */
  long o = n; while (o % 2 == 0) o /= 2;
  long m = (o - 1) % (2 * N);
  return m == 0 ? 1 : (m == N ? -1 : 0);
}
static long ROOTS[256], NROOTS;
static uint8_t root_sum(long n) { /* original coefficient a(n) modulo p, n >= 1 */
  long u = n; while (u % 2 == 0) u /= 2;
  long t = 0;
  for (long i = 0; i < NROOTS; i++) t += powm(ROOTS[i], (u - 1) / 2);
  return (uint8_t)(t % P);
}

/* sum_i x[i] y[i] modulo P */
static long dot(const uint8_t *x, const uint8_t *y, long n) {
  uint64_t total = 0;
  #pragma omp parallel for reduction(+:total) schedule(static) if (n > 200000)
  for (long b = 0; b < n; b += 32768) {
    long e = b + 32768 < n ? b + 32768 : n;
    uint32_t acc = 0;
    for (long i = b; i < e; i++) acc += (uint32_t)x[i] * y[i];
    total += acc % (uint32_t)P;
  }
  return (long)(total % (uint64_t)P);
}
/* y[i] = (y[i] + k x[i]) mod P, exact division by P via a 2^24 reciprocal */
static void axpy(uint8_t *y, const uint8_t *x, long n, uint32_t k) {
  const uint32_t mu = (uint32_t)(((1u << 24) + P - 1) / P), pp = (uint32_t)P;
  #pragma omp parallel for schedule(static) if (n > 200000)
  for (long i = 0; i < n; i++) {
    uint32_t v = y[i] + k * x[i];
    y[i] = (uint8_t)(v - ((v * mu) >> 24) * pp);
  }
}

static double now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec + 1e-9 * t.tv_nsec; }

/* Rows sum_i S_i a(shift+scale*i+k), k=1..count, from root sums. Returns the
   first nonzero row (1-based), or 0 if all vanish, with its value in *val.
   Row k=r+scale*q reads a(shift+r+scale*(i+q)), so each residue r uses one
   contiguous table. */
static long first_row(const uint8_t *S, long D, long shift, long scale, long count, long *val) {
  long first = 0;
  for (long r = 0; r < scale && r <= count; r++) {
    long q0 = r == 0 ? 1 : 0, qmax = (count - r) / scale;
    if (qmax < q0) continue;
    long len = D + qmax + 1;
    uint8_t *A = malloc((size_t)len);
    long *row = malloc(sizeof(long) * (size_t)(qmax + 1));
    #pragma omp parallel for schedule(static)
    for (long x = 0; x < len; x++) A[x] = root_sum(shift + r + scale * x);
    #pragma omp parallel for schedule(dynamic, 64)
    for (long q = q0; q <= qmax; q++) row[q] = dot(S, A + q, D + 1);
    for (long q = q0; q <= qmax; q++)
      if (row[q]) { long k = r + scale * q; if (!first || k < first) { first = k; *val = row[q]; } break; }
    free(A); free(row);
  }
  return first;
}

int main(int argc, char **argv) {
  if (argc < 4) { fprintf(stderr, "usage: terminal_witness p M e [out.json] [nolift]\n"); return 1; }
  P = atol(argv[1]); long M = atol(argv[2]), e = atol(argv[3]);
  const char *out = argc > 4 && strcmp(argv[4], "nolift") ? argv[4] : NULL;
  int lift = 1;
  for (int i = 4; i < argc; i++) if (!strcmp(argv[i], "nolift")) lift = 0;
  if (P < 3 || P > 255 || M < 0 || e < 0) { fprintf(stderr, "need odd prime p < 256, M >= 0, e >= 0\n"); return 1; }
  for (long a = 2; a * a <= P; a++) if (P % a == 0) { fprintf(stderr, "p is not prime\n"); return 1; }
  N = (P - 1) & -(P - 1);
  for (long z = 1; z < P; z++) if (powm(z, N / 2) == P - 1) ROOTS[NROOTS++] = z;
  double t0 = now();

  /* Berlekamp--Massey, as profile_jumps(s, p, stop_at=e) */
  long T = 2 * e + N + 1;
  uint8_t *s = malloc((size_t)T), *sr = malloc((size_t)T + 1);
  for (long k = 1; k <= T; k++) {
    long v = 0; for (long i = 0; i < N; i++) v += cnorm(M + k + i);
    v %= P; if (v < 0) v += P; s[k - 1] = (uint8_t)v;
  }
  for (long j = 0; j < T; j++) sr[j] = s[T - 1 - j];
  long cap = T + 2;
  uint8_t *Cp = calloc((size_t)cap, 1), *Bp = calloc((size_t)cap, 1), *Tp = calloc((size_t)cap, 1);
  Cp[0] = Bp[0] = 1;
  long lenC = 1, lenB = 1, L = 0, shift = 1, last = 1, jump = -1;
  for (long n = 0; n < T; n++) {
    long lim = L < lenC - 1 ? L : lenC - 1;
    long d = (s[n] + (lim > 0 ? dot(Cp + 1, sr + (T - n), lim) : 0)) % P;
    if (d == 0) { shift++; continue; }
    if (L == e && 2 * L <= n) { jump = n + 1 - 2 * L; break; }
    long coef = d * powm(last, P - 2) % P;
    int grow = 2 * L <= n;
    if (grow) { memcpy(Tp, Cp, (size_t)lenC); }
    long oldlen = lenC;
    if (lenC < lenB + shift) { memset(Cp + lenC, 0, (size_t)(lenB + shift - lenC)); lenC = lenB + shift; }
    axpy(Cp + shift, Bp, lenB, (uint32_t)((P - coef) % P));
    if (grow) {
      L = n + 1 - L; last = d; shift = 1;
      uint8_t *x = Bp; Bp = Tp; Tp = x; lenB = oldlen;
    } else shift++;
  }
  double t_bm = now() - t0;
  if (jump != N + 1) { fprintf(stderr, "FAIL: complexity %ld jumps by %ld, not N+1=%ld\n", e, jump, N + 1); return 2; }
  uint8_t *V = calloc((size_t)e + 1, 1);
  for (long i = 0; i <= e; i++) V[i] = i < lenC ? Cp[e - i] : 0;   /* reversed, V_e = 1 */
  long D = e + N - 1;
  uint8_t *S = calloc((size_t)D + 1, 1);
  for (long k = 0; k <= D; k++) {
    long t = 0;
    for (long i = k - N + 1 < 0 ? 0 : k - N + 1; i <= k && i <= e; i++) t += V[i];
    S[k] = (uint8_t)(t % P);
  }
  int ok = V[e] == 1 && S[0] && S[D];
  /* independent division by 1+...+t^(N-1) */
  long *rem = malloc(sizeof(long) * (size_t)(D + 1));
  for (long k = 0; k <= D; k++) rem[k] = S[k];
  for (long i = D; i >= N - 1; i--) {
    long q = rem[i] % P;
    if (q != V[i - N + 1]) ok = 0;
    for (long k = 0; k < N; k++) rem[i - k] = ((rem[i - k] - q) % P + P) % P;
  }
  for (long k = 0; k <= D; k++) if (rem[k]) ok = 0;
  if (!ok) { fprintf(stderr, "FAIL: endpoints or division\n"); return 2; }

  long tval = 0, lval = 0, m = N * M, j = N * (D + 2);
  long first = first_row(S, D, M, 1, D + 2, &tval);
  if (first != D + 2) { fprintf(stderr, "FAIL: first nonzero terminal row %ld, expected %ld\n", first, D + 2); return 2; }
  double t_rows = now() - t0;
  if (lift) {
    long lf = first_row(S, D, m, N, j, &lval);
    if (lf != j || lval != tval) { fprintf(stderr, "FAIL: first nonzero lifted row %ld value %ld\n", lf, lval); return 2; }
  }
  double t_lift = now() - t0;
  /* mutations must be rejected */
  long dummy;
  S[D / 2] = (uint8_t)((S[D / 2] + 1) % P);
  int rej_coef = first_row(S, D, M, 1, D + 2, &dummy) != D + 2;
  S[D / 2] = (uint8_t)((S[D / 2] + P - 1) % P);
  int rej_shift = first_row(S, D, M + 2, 1, D + 2, &dummy) != D + 2;
  if (!(rej_coef && rej_shift)) { fprintf(stderr, "FAIL: a mutation was accepted\n"); return 2; }
  double total = now() - t0;
  fprintf(stderr, "p=%ld N=%ld M=%ld e=%ld D=%ld terminal_value=%ld m=%ld lifted_degree=%ld j=%ld defect=%ld lift_checked=%d "
          "bm=%.1fs rows=%.1fs lift=%.1fs total=%.1fs\n", P, N, M, e, D, tval, m, N * D, j, j - N * D, lift,
          t_bm, t_rows - t_bm, t_lift - t_rows, total);
  if (out) {
    FILE *fp = fopen(out, "w"); if (!fp) { perror(out); return 1; }
    fprintf(fp, "{\"generator\":\"search/terminal_witness.c\",\"seed\":null,\"witnesses\":[{\"p\":%ld,\"N\":%ld,\"M\":%ld,\"e\":%ld,\"V\":[", P, N, M, e);
    for (long i = 0; i <= e; i++) fprintf(fp, "%s%d", i ? "," : "", V[i]);
    fprintf(fp, "],\"S\":[");
    for (long i = 0; i <= D; i++) fprintf(fp, "%s%d", i ? "," : "", S[i]);
    fprintf(fp, "],\"D\":%ld,\"m\":%ld,\"lifted_degree\":%ld,\"j\":%ld,\"defect\":%ld,\"kernel_dimension\":null,"
            "\"jump\":%ld,\"terminal_value\":%ld,\"lift_checked\":%s,\"largest_original_index\":%ld,"
            "\"mutations_rejected\":[\"coefficient\",\"shift\"]}],\"runtime_seconds\":%.1f}\n",
            D, m, N * D, j, j - N * D, jump, tval, lift ? "true" : "false", lift ? m + N * D + j : M + 2 * D + 2, total);
    fclose(fp);
  }
  return 0;
}
