/* Number wall of a sequence over F_p (p < 256) with Lunnon's frame theorems.

   W[m][n] = det(S[n+i-j])_{0<=i,j<=m} (Toeplitz), W[-1][n]=1, W[-2][n]=0.
   Rows are produced by the cross rule
       W[m][n] = (W[m-1][n]^2 - W[m-1][n-1] W[m-1][n+1]) / W[m-2][n]
   and, below a g x g zero window with inner frame A (top), B (left),
   C (right), D (bottom) and outer frame E, F, G, H, by the second and third
   frame equations (Lunnon 2001; Garrett--Robertson arXiv:2405.14454 Thm 2.6):
       D_k = (-1)^(g k) B_k C_k / A_k,
       H_k = (D_k / R) (Q E_k / A_k + (-1)^k P F_k / B_k - (-1)^k S G_k / C_k),
   with ratios P=A1/A0, Q=B1/B0, R=C1/C0, S=D1/D0. A and B start at the top-left
   corner; C and D at the bottom-right corner. For an isolated zero (g=1) these
   combine, using D_1=-B_1 C_1/A_1, to
       H = (C0 (F A1^2 - B1^2 E) + A0 B1^2 G) / (A0 A1^2).

   Usage: number_wall p N mode C R report [options]
     mode 1: S_j = b_(j+1), b_v = c_v+...+c_(v+N-1) (Lai--Sprang derived stream)
     mode 0: S_j = c_(j+1); mode 2: S_j read from stdin (C integers)
   Computes rows 0..R over columns 0..C-1 and prints every window of side
   >= report as "window m0 n0 g". Row m is valid on a range that shrinks by one
   column per row, and further past any zero window whose frame would leave the
   computed region; results hold only inside the reported ranges. In the
   derived wall a side-N window with top-left (m0,n0) is a terminal window at
   shift M=n0-m0 and quotient degree m0 (its Hankel diagonal is n-m=M).
   Options: dump (print every row), gmax=G (largest window handled, default
   64), check (also run the serial window detection on every row and abort on
   any difference), ckpt=PATH and ckpt_secs=S (checkpoint every S seconds,
   default 1800), resume=PATH, progress=K (status line every K rows), stop (end
   after the first row that reports a window), maxsecs=S (end after S seconds;
   with ckpt a final checkpoint allows resuming).

   Design. Only the last gmax+4 rows are kept, in a ring. A cell whose divisor
   W[m-2][n] is zero lies below a window; the window is found in place (scan up
   to its top row, then across that row) and its frame values are read from the
   ring, so no window records are kept. Rows are computed in parallel column
   chunks (AVX2 when available; NW_CHUNKS sets the number per row, default four
   per thread), and each chunk also counts the new windows in its columns. Cuts of the valid range occur only near its ends; they follow
   exactly the rules of the earlier record-based version (search/number_wall_ref.c),
   so both print identical output. Compile: cc -O3 -march=native -fopenmp. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#ifdef _OPENMP
#include <omp.h>
#endif
#ifdef __AVX2__
#include <immintrin.h>
#endif

static int P, GMAX = 64, K, REPORT;
static long C, NN, R;
static uint32_t PP;
static uint8_t INV[256];
static uint64_t FM;
static uint8_t *ring;
static size_t stride;
static long *LO, *HI;

static inline uint32_t modp(uint32_t x) { /* Lemire's fastmod, exact for 32-bit x */
  return (uint32_t)(((__uint128_t)(FM * x) * (uint32_t)P) >> 64);
}
static inline int slot(long r) { return (int)((r + 2) % K); }
static inline uint8_t *ROW(long r) { return ring + (size_t)slot(r) * stride + 64; }
#define W(r, c) (ROW(r)[c])
#define LOr(r) LO[slot(r)]
#define HIr(r) HI[slot(r)]

static long cnorm(long n) {
  long o = n; while (o % 2 == 0) o /= 2;
  long m = (o - 1) % (2 * NN);
  return m == 0 ? 1 : (m == NN ? -1 : 0);
}

/* W(m,c) when W(m-2,c)=0: from the window containing (m-2,c), whose frame is
   read from the ring. Returns -1 when the record-based version would have
   lost the window's frame (it left the valid range by row m-1), or when the
   geometry is inconsistent; the caller then cuts the valid range. */
static int special(long m, long c) {
  const uint8_t *u2 = ROW(m - 2);
  if (W(m - 3, c) && u2[c - 1] && u2[c + 1]) { /* isolated zero: H row */
    if (c - 2 < LOr(m - 1) || c + 2 > HIr(m - 1)) return -1;
    const uint8_t *u3 = ROW(m - 3);
    uint32_t A0 = u3[c - 1], A1 = u3[c], B1 = u2[c - 1], F1 = u2[c - 2], G1 = u2[c + 2];
    uint32_t E1 = W(m - 4, c), C0 = W(m - 1, c + 1);
    uint32_t a2 = A1 * A1, b2 = B1 * B1;
    uint32_t x = modp(F1 * a2) + P - modp(b2 * E1);
    uint32_t num = modp(C0 * x + A0 * modp(b2 * G1));
    return (int)modp(num * INV[modp(A0 * a2)]);
  }
  long r = m - 2;
  while (W(r - 1, c) == 0) if (m - --r > GMAX + 2) return -1;
  long m0 = r, a = c, b = c;
  const uint8_t *top = ROW(m0);
  while (a > LOr(m0) && top[a - 1] == 0) a--;
  while (b < HIr(m0) && top[b + 1] == 0) b++;
  if (a == LOr(m0) || b == HIr(m0)) return -1;
  int g = (int)(b - a + 1);
  long t = m - m0;
  if (t < g) return 0;                                   /* inside the window */
  if (t > g + 1 || g > GMAX || a - 2 < LOr(m - 1) || b + 2 > HIr(m - 1)) return -1;
  int k = (int)(b + 1 - c);
  uint32_t Ak = W(m0 - 1, a - 1 + k), Bk = W(m0 - 1 + k, a - 1), Ck = W(m0 + g - k, b + 1);
  if (t == g) {                                          /* inner bottom frame D */
    uint32_t v = modp(modp(Bk * Ck) * INV[Ak]);
    return ((long)g * k) % 2 && v ? (int)(P - v) : (int)v;
  }
  uint32_t A0 = W(m0 - 1, a - 1), A1 = W(m0 - 1, a), B1 = W(m0, a - 1);   /* outer frame H */
  uint32_t C0 = W(m0 + g, b + 1), C1 = W(m0 + g - 1, b + 1), D1 = W(m0 + g, b);
  uint32_t Dk = W(m0 + g, b + 1 - k), Ek = W(m0 - 2, a - 1 + k);
  uint32_t Fk = W(m0 - 1 + k, a - 2), Gk = W(m0 + g - k, b + 2);
  uint32_t Pr = modp(A1 * INV[A0]), Q = modp(B1 * INV[A0]);
  uint32_t Rr = modp(C1 * INV[C0]), S = modp(D1 * INV[C0]);
  uint32_t t1 = modp(modp(Q * Ek) * INV[Ak]);
  uint32_t t2 = modp(modp(Pr * Fk) * INV[Bk]);
  uint32_t t3 = modp(modp(S * Gk) * INV[Ck]);
  uint32_t s = k % 2 ? t3 + P - t2 : t2 + P - t3;
  return (int)modp(modp(Dk * INV[Rr]) * (t1 + s));
}

/* ---- per-chunk state: invalid cells, and new windows in the chunk ---- */
typedef struct { long *a; int *g; long n, cap; } RunList;
static void push_run(RunList *L, long a, int g) {
  if (L->n == L->cap) {
    L->cap = L->cap ? 2 * L->cap : 64;
    L->a = realloc(L->a, (size_t)L->cap * sizeof(long));
    L->g = realloc(L->g, (size_t)L->cap * sizeof(int));
  }
  L->a[L->n] = a; L->g[L->n] = g; L->n++;
}
typedef struct {
  RunList inval;   /* cells that must be cut (g unused) */
  RunList rep;     /* runs with g >= REPORT or g > GMAX, increasing a */
  long *hist;      /* hist[g] for 1<=g<=GMAX, hist[GMAX+1] for larger */
  long s, e, prefix, suf_a, suf_len, big;
  long run_a, run_len;
} Chunk;
static Chunk *CH;

static inline void run_done(Chunk *ch, long a, long g) {
  if (a == ch->s) { ch->prefix = g; return; }   /* may continue the previous chunk */
  ch->hist[g > GMAX ? GMAX + 1 : g]++;
  if (g > GMAX) ch->big++;
  if (g >= REPORT || g > GMAX) push_run(&ch->rep, a, (int)g);
}
/* bits of x (nbits <= 32) mark cells that are zero with a nonzero cell above */
static inline void det_block(Chunk *ch, long base, uint64_t x, int nbits) {
  if (!ch->run_len && !(x & (x >> 1)) && !(x >> (nbits - 1)) && base != ch->s && REPORT > 1) {
    ch->hist[1] += __builtin_popcountll(x);   /* only isolated new zeros, none at the ends */
    return;
  }
  if (ch->run_len) {
    int t1 = __builtin_ctzll(~x);
    if (t1 >= nbits) { ch->run_len += nbits; return; }
    ch->run_len += t1; run_done(ch, ch->run_a, ch->run_len); ch->run_len = 0;
    x &= ~((1ull << t1) - 1);
  }
  while (x) {
    int s = __builtin_ctzll(x);
    int l = __builtin_ctzll(~(x >> s));
    if (s + l >= nbits) { ch->run_a = base + s; ch->run_len = nbits - s; return; }
    run_done(ch, base + s, l);
    x &= ~(((1ull << l) - 1) << s);
  }
}

static inline uint32_t cross(const uint8_t *r1, const uint8_t *r2, long c) {
  uint32_t x = (uint32_t)r1[c] * r1[c] + PP - (uint32_t)r1[c - 1] * r1[c + 1];
  return modp(modp(x) * INV[r2[c]]);
}

#ifdef __AVX2__
static int USE_AVX2;
static __m256i TBL[8], V_P, V_PP, V_MU, V_70, V_16[8];
static int NTBL;
static inline __m256i inv32(__m256i d) {
  __m256i r = _mm256_setzero_si256();
  for (int j = 0; j < NTBL; j++)
    r = _mm256_or_si256(r, _mm256_shuffle_epi8(TBL[j],
          _mm256_adds_epu8(_mm256_sub_epi8(d, V_16[j]), V_70)));
  return r;
}
static inline __m256i red16(__m256i x) { /* x < 65536 -> x mod P */
  __m256i q = _mm256_mulhi_epu16(x, V_MU);
  __m256i r = _mm256_sub_epi16(x, _mm256_mullo_epi16(q, V_P));
  return _mm256_min_epu16(r, _mm256_sub_epi16(r, V_P));
}
static inline __m256i cross16(__m256i a, __m256i l, __m256i r, __m256i iv) {
  __m256i x = _mm256_add_epi16(_mm256_mullo_epi16(a, a), _mm256_sub_epi16(V_PP, _mm256_mullo_epi16(l, r)));
  return red16(_mm256_mullo_epi16(red16(x), iv));
}
#define LD16(p) _mm256_cvtepu8_epi16(_mm_loadu_si128((const __m128i *)(p)))
#define LO16(v) _mm256_cvtepu8_epi16(_mm256_castsi256_si128(v))
#define HI16(v) _mm256_cvtepu8_epi16(_mm256_extracti128_si256(v, 1))
#define PACK(a, b) _mm256_permute4x64_epi64(_mm256_packus_epi16(a, b), 0xD8)
/* numerator and denominator of the isolated-zero formula for H, 16 lanes */
static inline __m256i hiso16(__m256i A0, __m256i A1, __m256i B1, __m256i E1, __m256i F1,
                             __m256i G1, __m256i C0, __m256i *den) {
  __m256i a2 = red16(_mm256_mullo_epi16(A1, A1)), b2 = red16(_mm256_mullo_epi16(B1, B1));
  __m256i t = red16(_mm256_add_epi16(_mm256_mullo_epi16(F1, a2), _mm256_sub_epi16(V_PP, _mm256_mullo_epi16(b2, E1))));
  __m256i v = red16(_mm256_mullo_epi16(A0, b2));
  *den = red16(_mm256_mullo_epi16(A0, a2));
  return red16(_mm256_add_epi16(_mm256_mullo_epi16(C0, t), _mm256_mullo_epi16(v, G1)));
}
#endif

static void kernel_chunk(long m, Chunk *ch) {
  uint8_t *r0 = ROW(m);
  const uint8_t *r1 = ROW(m - 1), *r2 = ROW(m - 2);
  ch->inval.n = ch->rep.n = 0; ch->prefix = ch->suf_len = ch->big = 0; ch->run_len = 0;
  memset(ch->hist, 0, (size_t)(GMAX + 2) * sizeof(long));
  long c = ch->s, e = ch->e;
#ifdef __AVX2__
  if (USE_AVX2) {
    const __m256i zero = _mm256_setzero_si256();
    const uint8_t *r3 = ROW(m - 3), *r4 = m >= 2 ? ROW(m - 4) : NULL;
    long lo1 = LOr(m - 1), hi1 = HIr(m - 1);
    for (; c + 31 <= e; c += 32) {
      __m256i d = _mm256_loadu_si256((const __m256i *)(r2 + c));
      __m256i ctr = _mm256_loadu_si256((const __m256i *)(r1 + c));
      __m256i iv = inv32(d);
      __m256i lo = cross16(LO16(ctr), LD16(r1 + c - 1), LD16(r1 + c + 1), LO16(iv));
      __m256i hi = cross16(HI16(ctr), LD16(r1 + c + 15), LD16(r1 + c + 17), HI16(iv));
      __m256i res = PACK(lo, hi);
      __m256i dz = _mm256_cmpeq_epi8(d, zero);
      uint32_t zd = (uint32_t)_mm256_movemask_epi8(dz);
      if (zd && r4 && c - 2 >= lo1 && c + 33 <= hi1) {  /* isolated zeros two rows up: H in SIMD */
        __m256i A1 = _mm256_loadu_si256((const __m256i *)(r3 + c));
        __m256i B1 = _mm256_loadu_si256((const __m256i *)(r2 + c - 1));
        __m256i Rn = _mm256_loadu_si256((const __m256i *)(r2 + c + 1));
        __m256i iso = _mm256_andnot_si256(_mm256_or_si256(_mm256_or_si256(_mm256_cmpeq_epi8(A1, zero),
                        _mm256_cmpeq_epi8(B1, zero)), _mm256_cmpeq_epi8(Rn, zero)), dz);
        uint32_t im = (uint32_t)_mm256_movemask_epi8(iso);
        if (im) {
          __m256i dl, dh;
          __m256i nl = hiso16(LD16(r3 + c - 1), LO16(A1), LO16(B1), LD16(r4 + c), LD16(r2 + c - 2),
                              LD16(r2 + c + 2), LD16(r1 + c + 1), &dl);
          __m256i nh = hiso16(LD16(r3 + c + 15), HI16(A1), HI16(B1), LD16(r4 + c + 16), LD16(r2 + c + 14),
                              LD16(r2 + c + 18), LD16(r1 + c + 17), &dh);
          __m256i ivd = inv32(PACK(dl, dh));
          __m256i H = PACK(red16(_mm256_mullo_epi16(nl, LO16(ivd))), red16(_mm256_mullo_epi16(nh, HI16(ivd))));
          res = _mm256_blendv_epi8(res, H, iso);
          zd &= ~im;
        }
      }
      _mm256_storeu_si256((__m256i *)(r0 + c), res);
      uint32_t zr = (uint32_t)_mm256_movemask_epi8(_mm256_cmpeq_epi8(res, zero));
      uint32_t zu = (uint32_t)_mm256_movemask_epi8(_mm256_cmpeq_epi8(ctr, zero));
      while (zd) {
        int i = __builtin_ctz(zd); zd &= zd - 1;
        int v = special(m, c + i);
        if (v < 0) { push_run(&ch->inval, c + i, 0); v = 0; }
        r0[c + i] = (uint8_t)v;
        zr = v ? zr & ~(1u << i) : zr | (1u << i);
      }
      det_block(ch, c, zr & ~zu, 32);
    }
  }
#endif
  while (c <= e) {
    int nb = e - c + 1 < 32 ? (int)(e - c + 1) : 32;
    uint64_t x = 0;
    for (int i = 0; i < nb; i++) {
      long cc = c + i; int v;
      if (r2[cc]) v = (int)cross(r1, r2, cc);
      else { v = special(m, cc); if (v < 0) { push_run(&ch->inval, cc, 0); v = 0; } }
      r0[cc] = (uint8_t)v;
      if (!v && r1[cc]) x |= 1ull << i;
    }
    det_block(ch, c, x, nb);
    c += nb;
  }
  if (ch->run_len) {
    if (ch->run_a == ch->s) ch->prefix = ch->run_len;
    else { ch->suf_a = ch->run_a; ch->suf_len = ch->run_len; }
  }
}

/* ---- window detection with the exact rules of the record-based version ---- */
static long windows_total, unframed_cuts, *HIST;
typedef struct { long count, cuts, lo, hi; int stopped; long *hist; RunList rep; } Det;
static Det DS, DF; /* serial and fast results for row m */
static long *MIDH; static RunList MIDREP;
static void det_reset(Det *d, long lo, long hi) {
  d->count = d->cuts = 0; d->lo = lo; d->hi = hi; d->stopped = 0; d->rep.n = 0;
  memset(d->hist, 0, (size_t)(GMAX + 2) * sizeof(long));
}
/* Runs of new zeros in row m with start a in [from,to] (a run containing
   `from` that began earlier is skipped), processed left to right: a run
   whose frame is not inside the valid range cuts it on its nearer side; a cut
   on the right ends the row. */
static void det_serial(Det *d, long m, long from, long to) {
  const uint8_t *r0 = ROW(m), *r1 = ROW(m - 1);
  long lo1 = LOr(m - 1), hi1 = HIr(m - 1), lo2 = LOr(m - 2), hi2 = HIr(m - 2);
  long n = from;
  if (n > d->lo) while (n <= d->hi && !r0[n] && r1[n] && !r0[n - 1] && r1[n - 1]) n++;
  while (n <= d->hi && n <= to) {
    if (r0[n] || !r1[n]) { n++; continue; }
    long a = n; while (n <= d->hi && !r0[n] && r1[n]) n++;
    long b = n - 1, g = b - a + 1;
    int framed = a > d->lo && b < d->hi && a - 2 >= lo1 && b + 2 <= hi1 &&
                 a - 1 >= lo2 && b + 1 <= hi2 && g <= GMAX;
    if (!framed) {
      d->cuts++;
      if (a - d->lo <= d->hi - b) { d->lo = b + 1; n = d->lo; }
      else { d->hi = a - 1; d->stopped = 1; return; }
      continue;
    }
    d->count++; d->hist[g]++;
    if (g >= REPORT) push_run(&d->rep, a, (int)g);
  }
}
/* Subtract from hist the fused-view runs (maximal new-zero runs inside
   [lo,hi]) whose start lies in [from,to]. */
static void det_subtract(long *hist, long m, long lo, long hi, long from, long to) {
  const uint8_t *r0 = ROW(m), *r1 = ROW(m - 1);
  long n = from;
  if (n > lo) while (n <= hi && !r0[n] && r1[n] && !r0[n - 1] && r1[n - 1]) n++;
  while (n <= hi && n <= to) {
    if (r0[n] || !r1[n]) { n++; continue; }
    long a = n; while (n <= hi && !r0[n] && r1[n]) n++;
    long g = n - a; hist[g > GMAX ? GMAX + 1 : g]--;
  }
}
static int CHECK, DUMP, STOP;
static void det_commit(Det *d, long m) {
  windows_total += d->count; unframed_cuts += d->cuts;
  for (int g = 0; g <= GMAX + 1; g++) HIST[g] += d->hist[g];
  for (long i = 0; i < d->rep.n; i++) printf("window %ld %ld %d\n", m, d->rep.a[i], d->rep.g[i]);
  if (d->rep.n && STOP) { fflush(stdout); STOP = 2; }
  LOr(m) = d->lo; HIr(m) = d->hi;
}
static int det_equal(const Det *x, const Det *y) {
  if (x->count != y->count || x->cuts != y->cuts || x->lo != y->lo || x->hi != y->hi ||
      x->rep.n != y->rep.n) return 0;
  for (int g = 0; g <= GMAX + 1; g++) if (x->hist[g] != y->hist[g]) return 0;
  for (long i = 0; i < x->rep.n; i++)
    if (x->rep.a[i] != y->rep.a[i] || x->rep.g[i] != y->rep.g[i]) return 0;
  return 1;
}

static void finish(Det *f, long *big, long a, long g) {
  f->hist[g > GMAX ? GMAX + 1 : g]++;
  if (g > GMAX) (*big)++;
  if (g >= REPORT || g > GMAX) push_run(&f->rep, a, (int)g);
}

static int NCHUNKS = 1;   /* chunks per row; threads take them dynamically */
static long MINCHUNK = 8192;
static void compute_row(long m) {
  long lo = LOr(m - 1) + 1, hi = HIr(m - 1) - 1, len = hi - lo + 1;
  int nch = (int)(len / MINCHUNK); if (nch > NCHUNKS) nch = NCHUNKS; if (nch < 1) nch = 1;
  for (int i = 0; i < nch; i++) {
    long s = lo + len * i / nch, e = lo + len * (i + 1) / nch - 1;
    if (i > 0) s = (s + 63) & ~63L;
    if (i < nch - 1) e = ((lo + len * (i + 1) / nch + 63) & ~63L) - 1;
    CH[i].s = s; CH[i].e = e;
  }
  #pragma omp parallel for schedule(dynamic, 1)
  for (int i = 0; i < nch; i++) kernel_chunk(m, &CH[i]);
  /* cuts for cells whose window frame was lost */
  for (int i = 0; i < nch; i++)
    for (long j = 0; j < CH[i].inval.n; j++) {
      long c = CH[i].inval.a[j];
      if (c < lo || c > hi) continue;
      unframed_cuts++;
      if (c - lo < hi - c) lo = c + 1; else { hi = c - 1; goto cut_done; }
    }
cut_done:;
  /* fused counts over [s0, e_last], merging runs across chunk boundaries */
  long lo_pre = CH[0].s, hi_pre = CH[nch - 1].e, big = 0;
  Det *f = &DF; det_reset(f, lo, hi);
  long carry_a = 0, carry_len = 0;
  for (int i = 0; i < nch; i++) {
    Chunk *ch = &CH[i]; long clen = ch->e - ch->s + 1;
    if (clen <= 0) continue;
    if (carry_len) {
      if (ch->prefix == clen) { carry_len += clen; continue; }
      finish(f, &big, carry_a, carry_len + ch->prefix); carry_len = 0;
    } else if (ch->prefix == clen) { carry_a = ch->s; carry_len = clen; continue; }
    else if (ch->prefix) finish(f, &big, ch->s, ch->prefix);
    for (int g = 0; g <= GMAX + 1; g++) f->hist[g] += ch->hist[g];
    big += ch->big;
    for (long j = 0; j < ch->rep.n; j++) push_run(&f->rep, ch->rep.a[j], ch->rep.g[j]);
    if (ch->suf_len) { carry_a = ch->suf_a; carry_len = ch->suf_len; }
  }
  if (carry_len) finish(f, &big, carry_a, carry_len);
  long Z = 2L * GMAX + 16, xL = lo + Z, xR = hi - Z;
  int fast = big == 0 && xR - xL > 2 * Z;
  if (fast) {
    det_subtract(f->hist, m, lo_pre, hi_pre, lo_pre, xL - 1);
    det_subtract(f->hist, m, lo_pre, hi_pre, xR + 1, hi_pre);
    MIDREP.n = 0;  /* interior runs: all framed, counted by the chunks */
    for (long j = 0; j < f->rep.n; j++)
      if (f->rep.a[j] >= xL && f->rep.a[j] <= xR) push_run(&MIDREP, f->rep.a[j], f->rep.g[j]);
    memcpy(MIDH, f->hist, (size_t)(GMAX + 2) * sizeof(long));
    det_reset(f, lo, hi);
    det_serial(f, m, lo, xL - 1);
    if (!f->stopped) {
      for (int g = 1; g <= GMAX; g++) { f->hist[g] += MIDH[g]; f->count += MIDH[g]; }
      for (long j = 0; j < MIDREP.n; j++) push_run(&f->rep, MIDREP.a[j], MIDREP.g[j]);
      det_serial(f, m, xR + 1, f->hi);
    }
  }
  if (!fast || CHECK) {
    det_reset(&DS, lo, hi);
    det_serial(&DS, m, lo, hi);
    if (fast && !det_equal(&DS, f)) {
      fprintf(stderr, "CHECK FAILED at row %ld: fast count %ld cuts %ld [%ld,%ld], serial %ld %ld [%ld,%ld]\n",
              m, f->count, f->cuts, f->lo, f->hi, DS.count, DS.cuts, DS.lo, DS.hi);
      exit(3);
    }
    if (!fast) { det_commit(&DS, m); return; }
  }
  det_commit(f, m);
}

static void dump_row(long m) {
  printf("row %ld [%ld,%ld]:", m, LOr(m), HIr(m));
  const uint8_t *r = ROW(m);
  for (long c = LOr(m); c <= HIr(m); c++) printf(" %d", r[c]);
  printf("\n");
}

/* ---- checkpoints: the ring rows still needed, with ranges and counters ---- */
static const char MAGIC[8] = "NWCKPT1";
static int save_ckpt(const char *path, long m, int mode) {
  char tmp[4096]; snprintf(tmp, sizeof tmp, "%s.tmp", path);
  FILE *fp = fopen(tmp, "wb"); if (!fp) return -1;
  int64_t h[12] = {P, NN, mode, C, R, REPORT, GMAX, m, windows_total, unframed_cuts, K, 0};
  fwrite(MAGIC, 1, 8, fp); fwrite(h, sizeof h, 1, fp);
  fwrite(HIST, sizeof(long), (size_t)GMAX + 2, fp);
  for (long r = m - K + 1; r <= m; r++) {
    if (r < -2) continue;
    int64_t lh[3] = {r, LOr(r), HIr(r)};
    fwrite(lh, sizeof lh, 1, fp);
    if (HIr(r) >= LOr(r)) fwrite(ROW(r) + LOr(r), 1, (size_t)(HIr(r) - LOr(r) + 1), fp);
  }
  int ok = fflush(fp) == 0 && ferror(fp) == 0;
  ok = fclose(fp) == 0 && ok;
  if (!ok || rename(tmp, path)) return -1;
  return 0;
}
static long load_ckpt(const char *path, int mode) {
  FILE *fp = fopen(path, "rb"); if (!fp) { perror(path); exit(1); }
  char mg[8]; int64_t h[12];
  if (fread(mg, 1, 8, fp) != 8 || memcmp(mg, MAGIC, 8) || fread(h, sizeof h, 1, fp) != 1) { fprintf(stderr, "bad checkpoint\n"); exit(1); }
  if (h[0] != P || h[1] != NN || h[2] != mode || h[3] != C || h[5] != REPORT || h[6] != GMAX || h[10] != K) {
    fprintf(stderr, "checkpoint parameters differ\n"); exit(1);
  }
  long m = (long)h[7]; windows_total = (long)h[8]; unframed_cuts = (long)h[9];
  if (fread(HIST, sizeof(long), (size_t)GMAX + 2, fp) != (size_t)GMAX + 2) { fprintf(stderr, "bad checkpoint\n"); exit(1); }
  for (long r = m - K + 1; r <= m; r++) {
    if (r < -2) continue;
    int64_t lh[3];
    if (fread(lh, sizeof lh, 1, fp) != 1 || lh[0] != r) { fprintf(stderr, "bad checkpoint row\n"); exit(1); }
    LOr(r) = (long)lh[1]; HIr(r) = (long)lh[2];
    if (lh[2] >= lh[1] && fread(ROW(r) + lh[1], 1, (size_t)(lh[2] - lh[1] + 1), fp) != (size_t)(lh[2] - lh[1] + 1)) {
      fprintf(stderr, "short checkpoint\n"); exit(1);
    }
  }
  fclose(fp);
  return m;
}

static double now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec + 1e-9 * t.tv_nsec; }

int main(int argc, char **argv) {
  if (argc < 7) { fprintf(stderr, "usage: p N mode C R report [dump] [gmax=G] [check] [stop] [maxsecs=S] [ckpt=PATH] [ckpt_secs=S] [resume=PATH] [progress=K]\n"); return 1; }
  P = atoi(argv[1]); NN = atol(argv[2]); int mode = atoi(argv[3]);
  C = atol(argv[4]); R = atol(argv[5]); REPORT = atoi(argv[6]);
  const char *ckpt = NULL, *resume = NULL; double ckpt_secs = 1800, maxsecs = 0; long progress = 20000;
  for (int i = 7; i < argc; i++) {
    if (!strcmp(argv[i], "dump")) DUMP = 1;
    else if (!strcmp(argv[i], "check")) CHECK = 1;
    else if (!strcmp(argv[i], "stop")) STOP = 1;
    else if (!strncmp(argv[i], "gmax=", 5)) GMAX = atoi(argv[i] + 5);
    else if (!strncmp(argv[i], "ckpt=", 5)) ckpt = argv[i] + 5;
    else if (!strncmp(argv[i], "ckpt_secs=", 10)) ckpt_secs = atof(argv[i] + 10);
    else if (!strncmp(argv[i], "resume=", 7)) resume = argv[i] + 7;
    else if (!strncmp(argv[i], "progress=", 9)) progress = atol(argv[i] + 9);
    else if (!strncmp(argv[i], "maxsecs=", 8)) maxsecs = atof(argv[i] + 8);
    else { fprintf(stderr, "unknown option %s\n", argv[i]); return 1; }
  }
  if (P < 2 || P > 255) { fprintf(stderr, "p must be < 256\n"); return 1; }
  if (GMAX < 1 || C < 1) { fprintf(stderr, "bad gmax or C\n"); return 1; }
  PP = (uint32_t)(P * P); FM = UINT64_C(0xFFFFFFFFFFFFFFFF) / (uint32_t)P + 1;
  for (int a = 0; a < 256; a++) INV[a] = 0;
  for (int a = 1; a < P; a++) for (int b = 1; b < P; b++) if (a * b % P == 1) INV[a] = (uint8_t)b;
#ifdef _OPENMP
  NCHUNKS = 4 * omp_get_max_threads();   /* spare chunks absorb slow threads on a shared box */
#endif
  if (getenv("NW_CHUNKS")) NCHUNKS = atoi(getenv("NW_CHUNKS"));
  if (getenv("NW_MINCHUNK")) MINCHUNK = atol(getenv("NW_MINCHUNK"));
  if (NCHUNKS < 1 || MINCHUNK < 64) { fprintf(stderr, "bad NW_CHUNKS or NW_MINCHUNK\n"); return 1; }
#ifdef __AVX2__
  USE_AVX2 = P <= 127 && !getenv("NW_SCALAR");
  if (USE_AVX2) {
    NTBL = (P + 15) / 16;
    for (int j = 0; j < NTBL; j++) {
      uint8_t t[32];
      for (int i = 0; i < 16; i++) t[i] = t[i + 16] = 16 * j + i < P ? INV[16 * j + i] : 0;
      TBL[j] = _mm256_loadu_si256((const __m256i *)t);
      V_16[j] = _mm256_set1_epi8((char)(16 * j));
    }
    V_P = _mm256_set1_epi16((short)P); V_PP = _mm256_set1_epi16((short)PP);
    V_MU = _mm256_set1_epi16((short)(65536 / P)); V_70 = _mm256_set1_epi8(0x70);
  }
#endif
  K = GMAX + 4;
  stride = ((size_t)C + 128 + 63) & ~(size_t)63;
  ring = aligned_alloc(64, (size_t)K * stride);
  LO = calloc((size_t)K, sizeof(long)); HI = calloc((size_t)K, sizeof(long));
  HIST = calloc((size_t)GMAX + 2, sizeof(long));
  DS.hist = calloc((size_t)GMAX + 2, sizeof(long)); DF.hist = calloc((size_t)GMAX + 2, sizeof(long));
  MIDH = calloc((size_t)GMAX + 2, sizeof(long));
  CH = calloc((size_t)NCHUNKS, sizeof(Chunk));
  for (int i = 0; i < NCHUNKS; i++) CH[i].hist = calloc((size_t)GMAX + 2, sizeof(long));
  if (!ring || !LO || !HI || !HIST || !CH) { fprintf(stderr, "out of memory\n"); return 1; }
  memset(ring, 0, (size_t)K * stride);
  long m;
  if (resume) {
    m = load_ckpt(resume, mode);
    fprintf(stderr, "resumed at row %ld range [%ld,%ld]\n", m, LOr(m), HIr(m));
  } else {
    memset(ROW(-2), 0, (size_t)C); memset(ROW(-1), 1, (size_t)C);
    LOr(-2) = LOr(-1) = 0; HIr(-2) = HIr(-1) = C - 1;
    uint8_t *r0 = ROW(0);
    for (long n = 0; n < C; n++) {
      long v;
      if (mode == 2) { if (scanf("%ld", &v) != 1) v = 0; }
      else if (mode == 0) v = cnorm(n + 1);
      else { v = 0; for (long i = 0; i < NN; i++) v += cnorm(n + 1 + i); }
      v %= P; if (v < 0) v += P; r0[n] = (uint8_t)v;
    }
    m = 0;
    det_reset(&DS, 0, C - 1); det_serial(&DS, 0, 0, C - 1); det_commit(&DS, 0);
    if (DUMP) dump_row(0);
  }
  double t0 = now(), tck = t0, cells = 0;
  long *band = calloc((size_t)GMAX + 2, sizeof(long));
  memcpy(band, HIST, (size_t)(GMAX + 2) * sizeof(long));
  for (;;) {
    if (m == R || LOr(m) + 1 > HIr(m) - 1 || STOP == 2) break;
    if (maxsecs > 0 && now() - t0 >= maxsecs) { fprintf(stderr, "time limit reached at row %ld\n", m); break; }
    m++;
    cells += (double)(HIr(m - 1) - LOr(m - 1) - 1);
    compute_row(m);
    if (DUMP) dump_row(m);
    if (m % progress == 0 || (ckpt && now() - tck >= ckpt_secs)) {
      double t = now();
      if (m % progress == 0) {
        fprintf(stderr, "row %ld range [%ld,%ld] windows %ld cuts %ld %.3g cells/s elapsed %.0fs band", m, LOr(m), HIr(m),
                windows_total, unframed_cuts, cells / (t - t0), t - t0);
        for (int g = 1; g <= GMAX + 1; g++) {   /* windows first seen in this band of rows */
          if (HIST[g] != band[g]) fprintf(stderr, " %d:%ld", g, HIST[g] - band[g]);
          band[g] = HIST[g];
        }
        fprintf(stderr, "\n");
      }
      fflush(stdout);
      if (ckpt && t - tck >= ckpt_secs) {
        if (save_ckpt(ckpt, m, mode)) fprintf(stderr, "checkpoint write failed at row %ld\n", m);
        else fprintf(stderr, "checkpoint row %ld\n", m);
        tck = now();
      }
    }
  }
  if (ckpt && save_ckpt(ckpt, m, mode)) fprintf(stderr, "final checkpoint write failed\n");
  fflush(stdout);
  fprintf(stderr, "p=%d N=%ld mode=%d C=%ld rows=%ld windows=%ld unframed_cuts=%ld final_range=[%ld,%ld]\n",
          P, NN, mode, C, m, windows_total, unframed_cuts, LOr(m), HIr(m));
  fprintf(stderr, "hist");
  for (int g = 1; g <= GMAX + 1; g++) if (HIST[g]) fprintf(stderr, " %d:%ld", g, HIST[g]);
  fprintf(stderr, "\nelapsed %.1fs cells %.4g rate %.4g cells/s\n", now() - t0, cells, cells / (now() - t0 + 1e-9));
  return 0;
}
