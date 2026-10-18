/* Reference version of search/number_wall.c (17 October 2026), kept for the
   comparison tests: it records every window's frame as rows are produced.
   Number wall of a sequence over F_p (p < 256) with Lunnon's frame theorems.

   W[m][n] = det(S[n+i-j])_{0<=i,j<=m} (Toeplitz), W[-1][n]=1, W[-2][n]=0.
   Rows are produced by the cross rule
       W[m][n] = (W[m-1][n]^2 - W[m-1][n-1] W[m-1][n+1]) / W[m-2][n]
   and, below a g x g zero window with inner frame A (top), B (left),
   C (right), D (bottom) and outer frame E, F, G, H, by the second and third
   frame equations (Lunnon 2001; Garrett--Robertson arXiv:2405.14454 Thm 2.6):
       D_k = (-1)^(g k) B_k C_k / A_k,
       H_k = (D_k / R) (Q E_k / A_k + (-1)^k P F_k / B_k - (-1)^k S G_k / C_k),
   with ratios P=A1/A0, Q=B1/B0, R=C1/C0, S=D1/D0. A and B start at the top-left
   corner; C and D at the bottom-right corner.

   Usage: number_wall p N mode C R report [dump]
     mode 1: S_j = b_(j+1), b_v = c_v+...+c_(v+N-1) (Lai--Sprang derived stream)
     mode 0: S_j = c_(j+1); mode 2: S_j read from stdin (C integers)
   Computes rows 0..R over columns 0..C-1 and prints every window of side
   >= report as "window m0 n0 g". Row m is valid on a range that shrinks by one
   column per row, and further past any zero window whose frame would leave the
   computed region; results hold only inside the reported ranges. In the
   derived wall a side-N window with top-left (m0,n0) is a terminal window at
   shift M=n0-m0 and quotient degree m0 (its Hankel diagonal is n-m=M).
   With dump, prints every row. Compile with -fopenmp for parallel rows. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef GMAX
#define GMAX 64
#endif
typedef struct {
  int m0, n0, g;
  uint8_t E[GMAX + 2], A[GMAX + 2], F[GMAX + 2], B[GMAX + 2], C[GMAX + 2], G[GMAX + 2], D[GMAX + 2];
} Window;

static int P_MOD;
static uint8_t MUL[256][256], INV[256], NEG[256];
static inline int subm(int a, int b) { int r = a - b; return r < 0 ? r + P_MOD : r; }
static inline int addm(int a, int b) { int r = a + b; return r >= P_MOD ? r - P_MOD : r; }

static long NN;
static int cnorm(long n) {
  long o = n; while (o % 2 == 0) o /= 2;
  long m = (o - 1) % (2 * NN);
  return m == 0 ? 1 : (m == NN ? -1 : 0);
}

static Window *W = NULL; static int32_t nw = 0, capw = 0;
static int32_t *freelist = NULL; static int32_t nfree = 0, capfree = 0;
static int32_t *active = NULL; static int32_t nactive = 0, capactive = 0;
static int32_t new_window(void) {
  int32_t id;
  if (nfree) id = freelist[--nfree];
  else {
    if (nw == capw) { capw = capw ? 2 * capw : 4096; W = realloc(W, (size_t)capw * sizeof(Window)); }
    id = nw++;
  }
  if (nactive == capactive) { capactive = capactive ? 2 * capactive : 4096;
    active = realloc(active, (size_t)capactive * sizeof(int32_t)); }
  active[nactive++] = id;
  return id;
}
static void release(int32_t id) {
  if (nfree == capfree) { capfree = capfree ? 2 * capfree : 4096;
    freelist = realloc(freelist, (size_t)capfree * sizeof(int32_t)); }
  freelist[nfree++] = id;
}

int main(int argc, char **argv) {
  if (argc < 7) { fprintf(stderr, "usage: p N mode C R report [dump]\n"); return 1; }
  P_MOD = atoi(argv[1]); NN = atol(argv[2]); int mode = atoi(argv[3]);
  long C = atol(argv[4]); long R = atol(argv[5]); int report = atoi(argv[6]);
  int dump = argc > 7;
  if (P_MOD < 2 || P_MOD > 255) { fprintf(stderr, "p must be < 256\n"); return 1; }
  for (int a = 0; a < P_MOD; a++) {
    NEG[a] = a ? P_MOD - a : 0;
    for (int b = 0; b < P_MOD; b++) { MUL[a][b] = a * b % P_MOD; if (a * b % P_MOD == 1) INV[a] = b; }
  }
  uint8_t *r2 = malloc(C), *r1 = malloc(C), *r0 = malloc(C);
  int32_t *w2 = malloc(C * 4), *w1 = malloc(C * 4), *w0 = malloc(C * 4);
  for (long n = 0; n < C; n++) { r2[n] = 0; r1[n] = 1; w2[n] = w1[n] = -1; }
  for (long n = 0; n < C; n++) {
    long v;
    if (mode == 2) { if (scanf("%ld", &v) != 1) v = 0; }
    else if (mode == 0) v = cnorm(n + 1);
    else { v = 0; for (long i = 0; i < NN; i++) v += cnorm(n + 1 + i); }
    v %= P_MOD; if (v < 0) v += P_MOD; r0[n] = (uint8_t)v; w0[n] = -1;
  }
  long lo1 = 0, hi1 = C - 1, lo2 = 0, hi2 = C - 1, lo0 = 0, hi0 = C - 1;
  long m = 0, windows_total = 0, unframed_cuts = 0;
  for (;;) {
    /* detect new windows in row m */
    long n = lo0;
    while (n <= hi0) {
      if (r0[n] != 0 || w0[n] >= 0) { n++; continue; }
      long a = n; while (n <= hi0 && r0[n] == 0 && w0[n] < 0) n++;
      long b = n - 1; int g = (int)(b - a + 1);
      int framed = a > lo0 && b < hi0 && a - 2 >= lo1 && b + 2 <= hi1 &&
                   a - 1 >= lo2 && b + 1 <= hi2 && g <= GMAX;
      if (!framed) {
        unframed_cuts++;
        if (a - lo0 <= hi0 - b) { lo0 = b + 1; n = lo0; } else { hi0 = a - 1; }
        continue;
      }
      int32_t id = new_window(); Window *x = &W[id]; windows_total++;
      x->m0 = (int)m; x->n0 = (int)a; x->g = g;
      for (int k = 0; k <= g + 1; k++) { x->E[k] = r2[a - 1 + k]; x->A[k] = r1[a - 1 + k]; }
      x->B[0] = x->A[0]; x->F[0] = r1[a - 2];
      x->C[g + 1] = x->A[g + 1]; x->G[g + 1] = r1[b + 2];
      for (long c = a; c <= b; c++) w0[c] = id;
      if (g >= report) printf("window %ld %ld %d\n", m, a, g);
    }
    /* record frame columns of active windows from row m; retire finished ones.
       A window stays active through its H row (t = g+1), then is released. */
    int32_t keep = 0;
    for (int32_t i = 0; i < nactive; i++) {
      int32_t id = active[i]; Window *x = &W[id];
      int g = x->g > 0 ? x->g : -x->g - 1;
      long t = m - x->m0;
      if (t > g) { release(id); continue; }
      if (x->g > 0) {
        long a = x->n0, b = x->n0 + g - 1;
        if (a - 2 < lo0 || b + 2 > hi0) x->g = -g - 1; /* frame left the valid range */
        else {
          x->B[t + 1] = r0[a - 1]; x->F[t + 1] = r0[a - 2];
          x->C[g - t] = r0[b + 1]; x->G[g - t] = r0[b + 2];
          if (t == g) for (int k = 0; k <= g + 1; k++) x->D[k] = r0[b + 1 - k];
        }
      }
      active[keep++] = id;
    }
    nactive = keep;
    if (dump) { printf("row %ld [%ld,%ld]:", m, lo0, hi0); for (long c = lo0; c <= hi0; c++) printf(" %d", r0[c]); printf("\n"); }
    if (m == R || lo0 + 1 > hi0 - 1) break;
    uint8_t *tb = r2; r2 = r1; r1 = r0; r0 = tb;
    int32_t *tl = w2; w2 = w1; w1 = w0; w0 = tl;
    lo2 = lo1; hi2 = hi1; lo1 = lo0; hi1 = hi0;
    lo0 = lo1 + 1; hi0 = hi1 - 1; m++;
    long mm = m;
    #pragma omp parallel for schedule(static)
    for (long c = lo0; c <= hi0; c++) {
      w0[c] = -1;
      int32_t id1 = w1[c];
      if (r1[c] == 0 && id1 >= 0) {
        int g1 = W[id1].g > 0 ? W[id1].g : -W[id1].g - 1;
        if (mm <= W[id1].m0 + g1 - 1) { r0[c] = 0; w0[c] = id1; continue; }
      }
      int d2 = r2[c];
      if (d2 != 0) {
        r0[c] = MUL[subm(MUL[r1[c]][r1[c]], MUL[r1[c - 1]][r1[c + 1]])][INV[d2]];
        continue;
      }
      int32_t id = w2[c];
      if (id < 0 || W[id].g <= 0) { r0[c] = 0; w0[c] = -2; continue; } /* unframed zero */
      Window *x = &W[id]; int g = x->g; int k = (int)(x->n0 + g - c);
      if (mm == x->m0 + g) {
        int v = MUL[MUL[x->B[k]][x->C[k]]][INV[x->A[k]]];
        r0[c] = ((long)g * k) % 2 ? NEG[v] : v;
      } else if (mm == x->m0 + g + 1) {
        int Pr = MUL[x->A[1]][INV[x->A[0]]], Q = MUL[x->B[1]][INV[x->B[0]]];
        int Rr = MUL[x->C[1]][INV[x->C[0]]], S = MUL[x->D[1]][INV[x->D[0]]];
        int t1 = MUL[MUL[Q][x->E[k]]][INV[x->A[k]]];
        int t2 = MUL[MUL[Pr][x->F[k]]][INV[x->B[k]]];
        int t3 = MUL[MUL[S][x->G[k]]][INV[x->C[k]]];
        int s = k % 2 ? subm(t3, t2) : subm(t2, t3);
        r0[c] = MUL[MUL[x->D[k]][INV[Rr]]][addm(t1, s)];
      } else { r0[c] = 0; w0[c] = id; }
    }
    for (long c = lo0; c <= hi0; c++) if (w0[c] == -2) {
      unframed_cuts++;
      if (c - lo0 < hi0 - c) lo0 = c + 1; else { hi0 = c - 1; break; }
    }
    if (m % 20000 == 0) { fprintf(stderr, "row %ld range [%ld,%ld] active %d\n", m, lo0, hi0, nactive); fflush(stdout); }
  }
  fprintf(stderr, "p=%d N=%ld mode=%d C=%ld rows=%ld windows=%ld unframed_cuts=%ld final_range=[%ld,%ld]\n",
          P_MOD, NN, mode, C, m, windows_total, unframed_cuts, lo0, hi0);
  return 0;
}
