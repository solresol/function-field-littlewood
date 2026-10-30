module

public import FunctionFieldLittlewood.TerminalDetection

@[expose] public section

/-!
Even-shift terminal stripping from the ordinary argument of 26 October.
The full two-primary order is essential. The infinite named stream is used;
no terminal existence or target sharpness statement is assumed.
-/
namespace FunctionFieldLittlewood.EvenShift
open scoped BigOperators
open Polynomial WindowMoments ParentWindow ParityDescent DescentStep TerminalDetection

variable {K : Type*} [Field K]

/-- Splitting a geometric sum into even and odd powers. -/
theorem geometric_double (H : ℕ) :
    factorQuotient K (2 * H) 1 =
      expand K 2 (factorQuotient K H 1) * (1 + X) := by
  apply mul_right_cancel₀ (show (X - 1 : K[X]) ≠ 0 by
    simpa using X_sub_C_ne_zero (1 : K))
  rw [show expand K 2 (factorQuotient K H 1) * (1 + X) * (X - 1) =
      expand K 2 (factorQuotient K H 1 * (X - 1)) by
    simp only [map_mul, map_sub, map_one, expand_X]
    ring]
  rw [show (X - 1 : K[X]) = X ^ 1 - 1 by simp,
    factorQuotient_mul (one_dvd H), factorQuotient_mul (one_dvd (2 * H))]
  simp [pow_mul]

/-- At an even shift, a geometric multiple with degree+1 zero rows has
geometric multiples as both parity components. This includes H=1. -/
theorem stream_even_forced_factor {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (P : (ZMod p)[X])
    (hf : factorQuotient (ZMod p) (2 * 2 ^ r) 1 ∣ P)
    (q n epsilon : ℕ) (he : epsilon ≤ 1)
    (hdeg : P.natDegree = 2 * q + epsilon)
    (hw : ∀ j, 1 ≤ j → j ≤ P.natDegree + 1 →
      filt P (laiSprangStream p (r + 1)) (2 * n + j) = 0) :
    ∃ E O : (ZMod p)[X],
      P = expand (ZMod p) 2 E + X * expand (ZMod p) 2 O ∧
      factorQuotient (ZMod p) (2 * 2 ^ r) 1 ∣ E ∧
      factorQuotient (ZMod p) (2 * 2 ^ r) 1 ∣ O ∧
      (∀ j, 1 ≤ j → j ≤ q + epsilon →
        filt E (laiSprangStream p (r + 1)) (n + j) = 0) ∧
      (∀ j, 1 ≤ j → j ≤ q + 1 →
        filt O (laiSprangStream p (r + 1)) (n + j) = 0) := by
  let g := factorQuotient (ZMod p) (2 ^ r) 1
  obtain ⟨V, hV⟩ := hf
  let U := (1 + X) * V
  have hPU : P = expand (ZMod p) 2 g * U := by
    rw [hV, geometric_double]
    dsimp [g, U]
    ring
  let E := g * evenPart U
  let O := g * oddPart U
  have hsplit : P = expand (ZMod p) 2 E + X * expand (ZMod p) 2 O :=
    hPU.trans (factored_parity_split g U)
  obtain ⟨hg, hgdeg⟩ := factorQuotient_degree (K := ZMod p)
    (by positivity : 0 < 2 ^ r) (one_dvd (2 ^ r))
  have hquot := quotient_degree_bounds g (evenPart U) (oddPart U) hg q epsilon he
    (hsplit ▸ hdeg)
  have hpdiv : 2 ^ (r + 1) ∣ p - 1 := by
    refine ⟨2 * k + 1, ?_⟩
    simpa [pow_succ, Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using horder
  obtain ⟨z, hz, hr, _, ha⟩ := RootStream.stream_root_enumeration hpdiv
  have hrowsE (l : ℕ) (hl : l < q + epsilon) :
      filt E (laiSprangStream p (r + 1)) (n + l + 1) +
        filt O (fun u => ∑ i, z i ^ u) (n + l + 1) = 0 := by
    have h := hw (2 * l + 2) (by omega) (by rw [hdeg]; omega)
    rw [hsplit, show 2 * n + (2 * l + 2) = 2 * (n + l + 1) by omega,
      filt_parity_even E O _ (laiSprangStream_even p (r + 1))] at h
    simpa only [ha] using h
  have hrowsO (l : ℕ) (hl : l < q + 1) :
      filt O (laiSprangStream p (r + 1)) (n + l + 1) +
        filt E (fun u => ∑ i, z i ^ u) (n + l) = 0 := by
    have h := hw (2 * l + 1) (by omega) (by rw [hdeg]; omega)
    rw [hsplit, show 2 * n + (2 * l + 1) = 2 * (n + l) + 1 by omega,
      filt_parity_odd E O _ (laiSprangStream_even p (r + 1))] at h
    simpa only [ha] using h
  have hm := windows_moments (laiSprangStream p (r + 1)) z g
    (evenPart U) (oddPart U) n 0 (q + epsilon) (q + 1)
    (by intro h; have := hquot.2 h; dsimp [g] at *; omega)
    (by intro h; have := hquot.1 h; dsimp [g] at *; omega)
    hrowsE (by simpa only [Nat.add_zero] using hrowsO)
  have hf' := geometric_parity_forced_factor hp (by positivity : 0 < 2 ^ r)
    (one_dvd (2 ^ r)) horder z hz hr (evenPart U) (oddPart U) n
    (by simpa only [Nat.add_zero] using hm)
  rw [factorQuotient_next (by positivity : 0 < 2 ^ r) (one_dvd (2 ^ r))] at hf'
  have hfE : factorQuotient (ZMod p) (2 * 2 ^ r) 1 ∣ E := hf'.1
  have hfO : factorQuotient (ZMod p) (2 * 2 ^ r) 1 ∣ O := hf'.2
  have hbin : (X ^ (2 ^ r) + 1 : (ZMod p)[X]) ∣ factorQuotient (ZMod p) (2 * 2 ^ r) 1 := by
    rw [← factorQuotient_next (by positivity : 0 < 2 ^ r) (one_dvd (2 ^ r))]
    exact dvd_mul_left _ _
  have hzE := odd_filter_zero hpdiv E (hbin.trans hfE)
  have hzO := odd_filter_zero hpdiv O (hbin.trans hfO)
  refine ⟨E, O, hsplit, hfE, hfO, ?_, ?_⟩
  · intro j hj hjq
    have h := hrowsE (j - 1) (by omega)
    simp_rw [← ha] at h
    rw [hzO, add_zero] at h
    simpa only [Nat.sub_add_cancel hj, Nat.add_assoc] using h
  · intro j hj hjq
    have h := hrowsO (j - 1) (by omega)
    simp_rw [← ha] at h
    rw [hzE, add_zero] at h
    simpa only [Nat.sub_add_cancel hj, Nat.add_assoc] using h

/-- A terminal event of size n, without choosing a scalar normalization.
The full degree and n zero rows are part of the definition; the exact next
nonzero row and nonzero constant endpoint follow from TerminalDetection. -/
def Terminal (p r m n : ℕ) [Fact p.Prime] : Prop :=
  ∃ P : (ZMod p)[X], P ≠ 0 ∧ P.natDegree + 1 = n ∧
    factorQuotient (ZMod p) (2 * 2 ^ r) 1 ∣ P ∧
    ∀ j, 1 ≤ j → j ≤ n → filt P (laiSprangStream p (r + 1)) (m + j) = 0

theorem terminal_empty (p r m : ℕ) [Fact p.Prime] : ¬ Terminal p r m 0 := by
  rintro ⟨P, _, hdeg, _⟩
  omega

theorem geometric_eval_one (N : ℕ) : (factorQuotient K N 1).eval 1 = (N : K) := by
  simp [factorQuotient]

/-- A geometric multiple vanishing also at 1 has the full binomial factor. -/
theorem binomial_dvd_of_geometric {N : ℕ} (hN : (N : K) ≠ 0)
    (P : K[X]) (hf : factorQuotient K N 1 ∣ P) (h1 : P.eval 1 = 0) :
    (X ^ N - 1) ∣ P := by
  obtain ⟨U, hU⟩ := hf
  have hU1 : U.eval 1 = 0 := by
    rw [hU, eval_mul, geometric_eval_one] at h1
    exact (mul_eq_zero.mp h1).resolve_left hN
  obtain ⟨V, hV⟩ := dvd_iff_isRoot.mpr hU1
  refine ⟨V, ?_⟩
  rw [hU, hV, ← mul_assoc]
  simpa only [C_1, pow_one] using congrArg (fun Q : K[X] => Q * V)
    (factorQuotient_mul (K := K) (one_dvd N))

theorem order_cast_ne_zero {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1)) :
    ((2 * 2 ^ r : ℕ) : ZMod p) ≠ 0 := by
  have hpos := Nat.two_pow_pos r
  have hle : 2 * 2 ^ r ≤ 2 * 2 ^ r * (2 * k + 1) := by
    exact Nat.le_mul_of_pos_right _ (by omega)
  have hlt : 2 * 2 ^ r < p := by omega
  intro h
  exact Nat.not_dvd_of_pos_of_lt (by positivity) hlt
    ((ZMod.natCast_eq_zero_iff (2 * 2 ^ r) p).mp h)

/-- Odd sizes cannot occur at even shifts. In particular, this does not
silently assume H>=2 in the one-root (usual valuation r=1) comparison. -/
theorem terminal_even_odd_size {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1)) (m n : ℕ) :
    ¬ Terminal p r (2 * m) (2 * n + 1) := by
  rintro ⟨P, hP, hdeg, hf, hw⟩
  have hd : P.natDegree = 2 * n := by omega
  obtain ⟨E, O, hs, hfE, hfO, hwE, hwO⟩ := stream_even_forced_factor hp horder P hf
    n m 0 (by decide) (by simpa using hd) (fun j hj hjd => hw j hj (by omega))
  have hO : O = 0 := by
    by_contra hO
    have hb := (split_degree_bounds P E O hs).2 hO
    obtain ⟨j, hj, hjd, hjne⟩ := stream_geometric_nonvanishing hp horder O hO hfO m
    exact hjne (hwO j hj (by omega))
  have hneg : (- (1 : ZMod p)) ≠ 1 := by
    have : Fact (2 < p) := ⟨hp⟩
    exact ZMod.neg_one_ne_one
  have hPm := TerminalLift.geometric_eval_zero P hf (-1)
    (by rw [pow_mul]; simp) hneg
  have hP1 : P.eval 1 = 0 := by
    simpa [hs, hO, expand_eval] using hPm
  have hbin := binomial_dvd_of_geometric (order_cast_ne_zero hp horder) P hf hP1
  obtain ⟨j, hj, hjd, hjne⟩ := BinomialNonvanishing.stream_binomial_nonvanishing
    hp horder P hP hbin (2 * m)
  exact hjne (hw j hj (by omega))

/-- The synchronized lift preserves the geometric factor. This is not the
reverse lift P(X^N): both the shift and size double in the terminal recurrence. -/
theorem geometric_sync_dvd {N : ℕ} (hN : 0 < N) (P : K[X])
    (hf : factorQuotient K N 1 ∣ P) :
    factorQuotient K N 1 ∣ (1 + X) * expand K 2 P := by
  obtain ⟨V, rfl⟩ := hf
  refine ⟨(X ^ N + 1) * expand K 2 V, ?_⟩
  calc
    (1 + X) * expand K 2 (factorQuotient K N 1 * V) =
        factorQuotient K (2 * N) 1 * expand K 2 V := by
      rw [geometric_double, map_mul]
      ring
    _ = factorQuotient K N 1 * ((X ^ N + 1) * expand K 2 V) := by
      rw [← factorQuotient_next hN (one_dvd N)]
      ring

/-- Exact even-shift/size stripping, with all empty and r=1 endpoints.
This proves an equivalence of existence statements, not uniform existence. -/
theorem terminal_even_double {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1)) (m n : ℕ) :
    Terminal p r (2 * m) (2 * n) ↔ Terminal p r m n := by
  constructor
  · rintro ⟨P, hP, hdeg, hf, hw⟩
    cases n with
    | zero => omega
    | succ d =>
      have hd : P.natDegree = 2 * d + 1 := by omega
      obtain ⟨E, O, hs, hfE, hfO, _, hwO⟩ := stream_even_forced_factor hp horder P hf
        d m 1 (by decide) hd (fun j hj hjd => hw j hj (by omega))
      have hl := leading_child P E O hP hs d 1 (by decide) hd
      simp only [Nat.one_ne_zero, ite_false] at hl
      exact ⟨O, hl.1, by omega, hfO, hwO⟩
  · rintro ⟨P, hP, hdeg, hf, hw⟩
    let S := (1 + X) * expand (ZMod p) 2 P
    have hx : (1 + X : (ZMod p)[X]) ≠ 0 := by
      simpa only [add_comm, ← C_1] using X_add_C_ne_zero (1 : ZMod p)
    have hex : expand (ZMod p) 2 P ≠ 0 := (expand_ne_zero (by decide)).mpr hP
    have hS : S ≠ 0 := mul_ne_zero hx hex
    have hdS : S.natDegree + 1 = 2 * n := by
      dsimp only [S]
      rw [natDegree_mul hx hex, natDegree_expand,
        show (1 + X : (ZMod p)[X]).natDegree = 1 by
          simpa only [add_comm, ← C_1] using natDegree_X_add_C (1 : ZMod p)]
      omega
    have hpdiv : 2 ^ (r + 1) ∣ p - 1 := by
      refine ⟨2 * k + 1, ?_⟩
      simpa [pow_succ, Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using horder
    have hbin : (X ^ (2 ^ r) + 1 : (ZMod p)[X]) ∣
        factorQuotient (ZMod p) (2 * 2 ^ r) 1 := by
      rw [← factorQuotient_next (by positivity : 0 < 2 ^ r) (one_dvd (2 ^ r))]
      exact dvd_mul_left _ _
    have hzP := odd_filter_zero hpdiv P (hbin.trans hf)
    have hsplit : S = expand (ZMod p) 2 P + X * expand (ZMod p) 2 P := by
      dsimp [S]; ring
    refine ⟨S, hS, hdS, geometric_sync_dvd (by positivity) P hf, ?_⟩
    intro j hj hjn
    by_cases he : j % 2 = 0
    · rw [hsplit, show 2 * m + j = 2 * (m + j / 2) by omega,
        filt_parity_even P P _ (laiSprangStream_even p (r + 1)), hzP, add_zero]
      exact hw (j / 2) (by omega) (by omega)
    · rw [hsplit, show 2 * m + j = 2 * (m + j / 2) + 1 by omega,
        filt_parity_odd P P _ (laiSprangStream_even p (r + 1)), hzP, add_zero]
      simpa only [Nat.add_assoc] using hw (j / 2 + 1) (by omega) (by omega)

/-- The polynomial event has exactly the same meaning as the actual boundary
target. Scaling at 1 is justified by proved binomial nonvanishing; it is not
an additional normalization or endpoint hypothesis. The empty size is included. -/
theorem target_iff_terminal {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (z : Fin (2 * 2 ^ r) → ZMod p) (hi : Function.Injective z)
    (hz : ∀ x : ZMod p, x ^ (2 * 2 ^ r) = 1 ↔ ∃ i, x = z i)
    (m n : ℕ) :
    CorrelatedState.relation (laiSprangStream p (r + 1)) z (m + 1) n n
      0 (TargetPreimage.target z) ↔ Terminal p r m n := by
  classical
  constructor
  · intro ht
    cases n with
    | zero =>
      obtain ⟨i, hi1⟩ := (hz 1).mp (by simp)
      obtain ⟨x, _, hv⟩ := ht
      have hh := congrFun hv i
      simp [Matrix.mulVec, dotProduct, TargetPreimage.target, ← hi1] at hh
    | succ d =>
      obtain ⟨P, hdeg, hf, hc⟩ := target_exact_certificate hp horder z hi hz m d ht
      have hP : P ≠ 0 := by
        intro hP
        have h0 := hc.2.1
        simp [hP, TerminalLift.coefficients] at h0
      refine ⟨P, hP, by omega, hf, ?_⟩
      intro j hj hjd
      have hh := (certificate_sound _ _ _ _ hc).2.2 j (by omega) (by omega)
      simpa only [TerminalLift.fractionalCoeff_coefficients] using hh
  · rintro ⟨P, hP, hdeg, hf, hw⟩
    have h1 : P.eval 1 ≠ 0 := by
      intro h1
      have hbin := binomial_dvd_of_geometric (order_cast_ne_zero hp horder) P hf h1
      obtain ⟨j, hj, hjd, hjne⟩ := BinomialNonvanishing.stream_binomial_nonvanishing
        hp horder P hP hbin m
      exact hjne (hw j hj (by omega))
    rw [← hdeg]
    refine ⟨fun i => (P.eval 1)⁻¹ * P.coeff i.val, ?_, ?_⟩
    · ext row
      have hh := hw (row.val + 1) (by omega) (by have := row.isLt; omega)
      have hfilter := filt_multiplier (TerminalLift.coefficients P)
        (laiSprangStream p (r + 1)) (m + (row.val + 1))
      rw [TerminalLift.coefficients_reconstruct] at hfilter
      rw [hfilter] at hh
      simp only [Matrix.mulVec, dotProduct, BoundaryRelation.block, Pi.zero_apply,
        mul_zero, Finset.sum_const_zero]
      calc
        ∑ i : Fin (P.natDegree + 1),
            laiSprangStream p (r + 1) (m + 1 + row.val + i.val) *
              ((P.eval 1)⁻¹ * P.coeff i.val) =
            (P.eval 1)⁻¹ * ∑ i : Fin (P.natDegree + 1),
              P.coeff i.val * laiSprangStream p (r + 1) (m + (row.val + 1) + i.val) := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i _
          rw [show m + 1 + row.val + i.val = m + (row.val + 1) + i.val by omega]
          ring
        _ = 0 := by
          simpa only [TerminalLift.coefficients, mul_zero] using
            congrArg (fun v : ZMod p => (P.eval 1)⁻¹ * v) hh
    · ext q
      have heval := multiplier_eval (TerminalLift.coefficients P) (z q)
      rw [TerminalLift.coefficients_reconstruct] at heval
      simp only [Matrix.mulVec, dotProduct, Matrix.transpose_apply, BoundaryRelation.evalMatrix]
      calc
        ∑ i : Fin (P.natDegree + 1), z q ^ i.val * ((P.eval 1)⁻¹ * P.coeff i.val) =
            (P.eval 1)⁻¹ * ∑ i : Fin (P.natDegree + 1), z q ^ i.val * P.coeff i.val := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i _
          ring
        _ = (P.eval 1)⁻¹ * P.eval (z q) := by
          rw [heval]
          rfl
        _ = TargetPreimage.target z q := by
          by_cases hq : z q = 1
          · simp [hq, TargetPreimage.target, h1]
          · rw [TerminalLift.geometric_eval_zero P hf (z q)
              ((hz _).mpr ⟨q, rfl⟩) hq]
            simp [TargetPreimage.target, hq]

/-- Exact stripping on the stored boundary-target predicate, for all sizes. -/
theorem target_even_double {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (z : Fin (2 * 2 ^ r) → ZMod p) (hi : Function.Injective z)
    (hz : ∀ x : ZMod p, x ^ (2 * 2 ^ r) = 1 ↔ ∃ i, x = z i)
    (m n : ℕ) :
    CorrelatedState.relation (laiSprangStream p (r + 1)) z (2 * m + 1) (2 * n) (2 * n)
      0 (TargetPreimage.target z) ↔
    CorrelatedState.relation (laiSprangStream p (r + 1)) z (m + 1) n n
      0 (TargetPreimage.target z) := by
  rw [target_iff_terminal hp horder z hi hz, target_iff_terminal hp horder z hi hz]
  exact terminal_even_double hp horder m n

/-- An even-shift square of odd size never accepts the target. -/
theorem target_even_odd_size {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (z : Fin (2 * 2 ^ r) → ZMod p) (hi : Function.Injective z)
    (hz : ∀ x : ZMod p, x ^ (2 * 2 ^ r) = 1 ↔ ∃ i, x = z i)
    (m n : ℕ) :
    ¬ CorrelatedState.relation (laiSprangStream p (r + 1)) z
      (2 * m + 1) (2 * n + 1) (2 * n + 1) 0 (TargetPreimage.target z) := by
  rw [target_iff_terminal hp horder z hi hz]
  exact terminal_even_odd_size hp horder m n

/-- Size descent excludes every terminal event at shift zero. -/
theorem terminal_zero_shift {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1)) (n : ℕ) :
    ¬ Terminal p r 0 n := by
  induction n using Nat.strong_induction_on with
  | h n ih =>
    intro ht
    by_cases hn : n = 0
    · exact terminal_empty p r 0 (hn ▸ ht)
    by_cases he : n % 2 = 0
    · have ht' := (terminal_even_double hp horder 0 (n / 2)).mp
        (by simpa only [Nat.mul_zero, show 2 * (n / 2) = n by omega] using ht)
      exact ih (n / 2) (by omega) ht'
    · apply terminal_even_odd_size hp horder 0 (n / 2)
      simpa only [Nat.mul_zero, show 2 * (n / 2) + 1 = n by omega] using ht

/-- Every event descends to an odd-shift event, preserving the same power
of two in its shift and size. The existence of any event is still an input. -/
theorem terminal_odd_representative {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1)) (m n : ℕ)
    (ht : Terminal p r m n) :
    ∃ s u v : ℕ, Odd u ∧ m = 2 ^ s * u ∧ n = 2 ^ s * v ∧ Terminal p r u v := by
  induction m using Nat.strong_induction_on generalizing n with
  | h m ih =>
    have hm : m ≠ 0 := by intro hm; exact terminal_zero_shift hp horder n (hm ▸ ht)
    by_cases he : m % 2 = 0
    · have hn : n % 2 = 0 := by
        by_contra hn
        apply terminal_even_odd_size hp horder (m / 2) (n / 2)
        simpa only [show 2 * (m / 2) = m by omega,
          show 2 * (n / 2) + 1 = n by omega] using ht
      have ht' := (terminal_even_double hp horder (m / 2) (n / 2)).mp
        (by simpa only [show 2 * (m / 2) = m by omega,
          show 2 * (n / 2) = n by omega] using ht)
      obtain ⟨s, u, v, hu, hmu, hnv, huv⟩ := ih (m / 2) (by omega) (n / 2) ht'
      refine ⟨s + 1, u, v, hu, ?_, ?_, huv⟩
      · calc
          m = 2 * (m / 2) := by omega
          _ = 2 ^ (s + 1) * u := by rw [hmu, pow_succ]; ring
      · calc
          n = 2 * (n / 2) := by omega
          _ = 2 ^ (s + 1) * v := by rw [hnv, pow_succ]; ring
    · exact ⟨0, m, n, ⟨m / 2, by omega⟩, by simp, by simp, ht⟩

/-- Boundary-target existence reduces to the remaining odd-shift problem.
This neither constructs an accepting word nor assumes one exists. -/
theorem target_exists_odd_iff {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (z : Fin (2 * 2 ^ r) → ZMod p) (hi : Function.Injective z)
    (hz : ∀ x : ZMod p, x ^ (2 * 2 ^ r) = 1 ↔ ∃ i, x = z i) :
    (∃ m n, CorrelatedState.relation (laiSprangStream p (r + 1)) z (m + 1) n n
      0 (TargetPreimage.target z)) ↔
    (∃ m n, Odd m ∧ CorrelatedState.relation (laiSprangStream p (r + 1)) z (m + 1) n n
      0 (TargetPreimage.target z)) := by
  constructor
  · rintro ⟨m, n, ht⟩
    have h := (target_iff_terminal hp horder z hi hz m n).mp ht
    obtain ⟨_, u, v, hu, _, _, huv⟩ := terminal_odd_representative hp horder m n h
    exact ⟨u, v, hu, (target_iff_terminal hp horder z hi hz u v).mpr huv⟩
  · rintro ⟨m, n, _, ht⟩
    exact ⟨m, n, ht⟩

end FunctionFieldLittlewood.EvenShift
