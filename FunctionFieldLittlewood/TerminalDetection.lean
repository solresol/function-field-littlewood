module

public import FunctionFieldLittlewood.BinomialNonvanishing
public import FunctionFieldLittlewood.TargetPreimage
public import FunctionFieldLittlewood.TerminalLift

@[expose] public section

/-!
From actual boundary targets to exact terminal certificates and sharp products.
Nonvanishing comes from the proved coefficient-row Proposition 2.3; no target
existence or no-invisible-vector statement is assumed. The remaining uniform
sharpness question is whether any target is reached for each odd prime.
-/
namespace FunctionFieldLittlewood.TerminalDetection
open scoped BigOperators
open Polynomial Matrix WindowMoments ParityDescent BinomialNonvanishing TerminalLift

variable {K : Type*} [Field K]

theorem filt_difference (P : K[X]) (a : ℕ → K) (v : ℕ) :
    filt ((X - 1) * P) a v = filt P a (v + 1) - filt P a v := by
  have hmono : (X - 1 : K[X]) = monomial 1 1 + monomial 0 (-1) := by
    simp only [monomial_zero_left, monomial_one_one_eq_X, map_neg, C_1]
    ring
  rw [filt_mul, hmono, filt_add, filt_monomial, filt_monomial]
  simp [sub_eq_add_neg]

/-- The geometric factor converts degree+2 zero rows into the forbidden
degree-many zero rows for an X^N-1 multiple. -/
theorem stream_geometric_nonvanishing {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (P : (ZMod p)[X]) (hP : P ≠ 0)
    (hf : factorQuotient (ZMod p) (2 * 2 ^ r) 1 ∣ P) (m : ℕ) :
    ∃ j, 1 ≤ j ∧ j ≤ P.natDegree + 2 ∧
      filt P (laiSprangStream p (r + 1)) (m + j) ≠ 0 := by
  have hx : (X - 1 : (ZMod p)[X]) ≠ 0 := by
    simpa using X_sub_C_ne_zero (1 : ZMod p)
  have hQ : (X - 1) * P ≠ 0 := mul_ne_zero hx hP
  have hdQ : ((X - 1) * P).natDegree = P.natDegree + 1 := by
    rw [natDegree_mul hx hP]
    simp only [← C_1, natDegree_X_sub_C]
    omega
  have hfQ : (X ^ (2 * 2 ^ r) - 1) ∣ (X - 1) * P := by
    obtain ⟨U, rfl⟩ := hf
    refine ⟨U, ?_⟩
    rw [← factorQuotient_mul (K := ZMod p) (one_dvd (2 * 2 ^ r))]
    simp only [pow_one]
    ring
  obtain ⟨j, hj, hjd, hjne⟩ := stream_binomial_nonvanishing hp horder _ hQ hfQ m
  by_contra! hw
  apply hjne
  rw [filt_difference, show m + j + 1 = m + (j + 1) by omega,
    hw (j + 1) (by omega) (by omega), hw j hj (by omega), sub_self]

theorem geometric_constant {N : ℕ} (hN : 0 < N) :
    (factorQuotient K N 1).coeff 0 = 1 := by
  classical
  simp [factorQuotient, coeff_X_pow, hN]

/-- A nonzero geometric multiple with degree+1 zero rows has no hidden
factor X, and its next row is nonzero. This supplies both certificate endpoints. -/
theorem stream_terminal_certificate {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (P : (ZMod p)[X]) (hP : P ≠ 0)
    (hf : factorQuotient (ZMod p) (2 * 2 ^ r) 1 ∣ P) (m : ℕ)
    (hw : ∀ j, 1 ≤ j → j ≤ P.natDegree + 1 →
      filt P (laiSprangStream p (r + 1)) (m + j) = 0) :
    ExactCertificate (laiSprangStream p (r + 1)) (coefficients P) m (P.natDegree + 2) := by
  have hc : P.coeff 0 ≠ 0 := by
    intro hc
    obtain ⟨V, hV⟩ := hf
    have hV0 : V.coeff 0 = 0 := by
      rw [hV, mul_coeff_zero, geometric_constant (by positivity : 0 < 2 * 2 ^ r),
        one_mul] at hc
      exact hc
    obtain ⟨U, hU⟩ := X_dvd_iff.mpr hV0
    let T := factorQuotient (ZMod p) (2 * 2 ^ r) 1 * U
    have hPT : P = X * T := by rw [hV, hU]; dsimp [T]; ring
    have hT : T ≠ 0 := by intro ht; apply hP; simp [hPT, ht]
    have hdT : P.natDegree = T.natDegree + 1 := by
      rw [hPT, natDegree_mul (X_ne_zero) hT, natDegree_X]
      omega
    obtain ⟨j, hj, hjd, hjne⟩ := stream_geometric_nonvanishing hp horder T hT
      (dvd_mul_right _ U) (m + 1)
    apply hjne
    have hh := hw j hj (by omega)
    rw [hPT, ParentWindow.filt_X_mul] at hh
    simpa only [Nat.add_assoc, Nat.add_left_comm, Nat.add_comm] using hh
  obtain ⟨j, hj, hjd, hjne⟩ := stream_geometric_nonvanishing hp horder P hP hf m
  have hjexact : j = P.natDegree + 2 := by
    by_contra h
    exact hjne (hw j hj (by omega))
  refine ⟨by omega, hc, ?_, ?_, ?_⟩
  · simpa only [coefficients, Fin.val_last, coeff_natDegree] using leadingCoeff_ne_zero.mpr hP
  · intro i
    rw [fractionalCoeff_coefficients]
    exact hw (i.val + 1) (by omega) (by have := i.isLt; omega)
  · rw [fractionalCoeff_coefficients]
    exact hjexact ▸ hjne

/-- Complete distinct N-th roots give the full binomial factor. -/
theorem unity_root_product {N : ℕ} (hN : 0 < N) (z : Fin N → K)
    (hi : Function.Injective z) (hz : ∀ i, z i ^ N = 1) :
    (∏ i, (X - C (z i))) = X ^ N - 1 := by
  classical
  have hd : (∏ i, (X - C (z i))) ∣ (X ^ N - 1 : K[X]) := by
    apply Finset.prod_dvd_of_coprime
    · intro i _ j _ hij
      exact pairwise_coprime_X_sub_C hi hij
    · intro i _
      apply dvd_iff_isRoot.mpr
      simp [IsRoot.def, hz i]
  symm
  apply eq_of_monic_of_dvd_of_natDegree_le (monic_prod_X_sub_C z Finset.univ)
    (by simpa only [C_1] using monic_X_pow_sub_C (1 : K) (Nat.ne_of_gt hN)) hd
  simp only [natDegree_finsetProd_X_sub_C_eq_card, Finset.card_univ, Fintype.card_fin]
  simp only [← C_1, natDegree_X_pow_sub_C]
  exact le_rfl

/-- Zero evaluations at all nontrivial N-th roots force F_N divisibility.
The value at the root 1 is unrestricted. -/
theorem geometric_dvd_of_evaluations {N : ℕ} (hN : 0 < N) (z : Fin N → K)
    (hi : Function.Injective z) (hz : ∀ i, z i ^ N = 1) (P : K[X])
    (hv : ∀ i, z i ≠ 1 → P.eval (z i) = 0) :
    factorQuotient K N 1 ∣ P := by
  classical
  have hd : (∏ i, (X - C (z i))) ∣ ((X - 1) * P) := by
    apply Finset.prod_dvd_of_coprime
    · intro i _ j _ hij
      exact pairwise_coprime_X_sub_C hi hij
    · intro i _
      apply dvd_iff_isRoot.mpr
      by_cases he : z i = 1
      · simp [IsRoot.def, he]
      · simp [IsRoot.def, hv i he]
  rw [unity_root_product hN z hi hz,
    ← factorQuotient_mul (K := K) (one_dvd N)] at hd
  simp only [pow_one] at hd
  have hx : (X - 1 : K[X]) ≠ 0 := by simpa using X_sub_C_ne_zero (1 : K)
  exact (mul_dvd_mul_iff_left hx).mp (by simpa only [mul_comm] using hd)

theorem multiplier_eval {d : ℕ} (x : Fin (d + 1) → K) (z : K) :
    (multiplierPolynomial x).eval z = ∑ i, z ^ i.val * x i := by
  simp [multiplierPolynomial, eval_finsetSum, mul_comm]

theorem filt_multiplier {d : ℕ} (x : Fin (d + 1) → K) (a : ℕ → K) (v : ℕ) :
    filt (multiplierPolynomial x) a v = ∑ i, x i * a (v + i.val) := by
  classical
  have hf (s : Finset (Fin (d + 1))) :
      filt (∑ i ∈ s, monomial i.val (x i)) a v = ∑ i ∈ s, x i * a (v + i.val) := by
    induction s using Finset.induction_on with
    | empty => simp [filt]
    | @insert i s hi ih => simp only [Finset.sum_insert hi, filt_add, filt_monomial, ih]
  simpa only [multiplierPolynomial] using hf Finset.univ

/-- Target membership in the actual square relation supplies a geometric
multiple, exact full degree, both nonzero endpoints and the exact next row.
No rank, endpoint, first-nonzero or Proposition 2.3 assumption is present. -/
theorem target_exact_certificate {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (z : Fin (2 * 2 ^ r) → ZMod p) (hi : Function.Injective z)
    (hz : ∀ x : ZMod p, x ^ (2 * 2 ^ r) = 1 ↔ ∃ i, x = z i)
    (m d : ℕ)
    (ht : CorrelatedState.relation (laiSprangStream p (r + 1)) z
      (m + 1) (d + 1) (d + 1) 0 (TargetPreimage.target z)) :
    ∃ P : (ZMod p)[X], P.natDegree = d ∧
      factorQuotient (ZMod p) (2 * 2 ^ r) 1 ∣ P ∧
      ExactCertificate (laiSprangStream p (r + 1)) (coefficients P) m (d + 2) := by
  obtain ⟨x, hrows, heval⟩ := ht
  let P := multiplierPolynomial x
  have hv (i) : P.eval (z i) = TargetPreimage.target z i := by
    simpa only [P, multiplier_eval, mulVec, dotProduct, transpose_apply,
      BoundaryRelation.evalMatrix] using congrFun heval i
  have hf : factorQuotient (ZMod p) (2 * 2 ^ r) 1 ∣ P := by
    apply geometric_dvd_of_evaluations (by positivity) z hi
      (fun i => (hz _).mpr ⟨i, rfl⟩) P
    intro i hne
    simp only [hv, TargetPreimage.target, ite_eq_right hne]
  have hP : P ≠ 0 := by
    obtain ⟨i, hi1⟩ := (hz 1).mp (by simp)
    intro hP
    have h := hv i
    simp [hP, TargetPreimage.target, ← hi1] at h
  have hle : P.natDegree ≤ d :=
    natDegree_le_iff_coeff_eq_zero.mpr (multiplierPolynomial_coeff_above x)
  have hw (j : ℕ) (hj : 1 ≤ j) (hjd : j ≤ d + 1) :
      filt P (laiSprangStream p (r + 1)) (m + j) = 0 := by
    have h := congrFun hrows ⟨j - 1, by omega⟩
    simp only [Pi.zero_apply, mulVec, dotProduct, BoundaryRelation.block,
      mul_zero, Finset.sum_const_zero] at h
    rw [filt_multiplier]
    convert h using 1
    apply Finset.sum_congr rfl
    intro i _
    rw [show m + 1 + (j - 1) + i.val = m + j + i.val by omega, mul_comm]
  have hdegree : P.natDegree = d := by
    by_contra hd
    obtain ⟨j, hj, hjd, hjne⟩ := stream_geometric_nonvanishing hp horder P hP hf m
    exact hjne (hw j hj (by omega))
  refine ⟨P, hdegree, hf, ?_⟩
  have hc := stream_terminal_certificate hp horder P hP hf m
    (fun j hj hjd => hw j hj (by omega))
  simpa only [hdegree] using hc

/-- The accepted boundary target now gives an actual multiplier attaining the
Lai--Sprang constant. Acceptance itself remains an explicit hypothesis. -/
theorem target_sharp_product {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (z : Fin (2 * 2 ^ r) → ZMod p) (hi : Function.Injective z)
    (hz : ∀ x : ZMod p, x ^ (2 * 2 ^ r) = 1 ↔ ∃ i, x = z i)
    (m d : ℕ)
    (ht : CorrelatedState.relation (laiSprangStream p (r + 1)) z
      (m + 1) (d + 1) (d + 1) 0 (TargetPreimage.target z)) :
    ∃ P : (ZMod p)[X], P.natDegree = d ∧
      polynomialLittlewoodProduct (laiSprangStream p (r + 1))
        (X ^ (2 ^ (r + 1) * m) * expand (ZMod p) (2 ^ (r + 1)) P) =
        (2 : ℝ) ^ (-2 * (2 ^ (r + 1) : ℕ) : ℤ) := by
  obtain ⟨P, hdeg, hf, hc⟩ := target_exact_certificate hp horder z hi hz m d ht
  have hN : 2 ^ (r + 1) = 2 * 2 ^ r := by rw [pow_succ, Nat.mul_comm]
  have hd : 2 ^ (r + 1) ∣ p - 1 := ⟨2 * k + 1, by simpa only [hN] using horder⟩
  refine ⟨P, hdeg, terminal_product hd P (by simpa only [hN] using hf) m ?_⟩
  simpa only [hdeg] using hc

/-- The stacked actual Hankel/evaluation map has trivial kernel whenever
there are at least columns-1 rows, including singular Hankel blocks.
This is the no-invisible-vector input needed by bordered reconstruction. -/
theorem stream_no_invisible {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (z : Fin (2 * 2 ^ r) → ZMod p) (hi : Function.Injective z)
    (hz : ∀ i, z i ^ (2 * 2 ^ r) = 1) (m L d : ℕ) (hlen : d ≤ L)
    (x : Fin (d + 1) → ZMod p)
    (hrows : BoundaryRelation.block (laiSprangStream p (r + 1)) (m + 1) L (d + 1) *ᵥ x = 0)
    (heval : (BoundaryRelation.evalMatrix z (d + 1))ᵀ *ᵥ x = 0) : x = 0 := by
  classical
  let P := multiplierPolynomial x
  have hv (i) : P.eval (z i) = 0 := by
    simpa only [P, multiplier_eval, mulVec, dotProduct, transpose_apply,
      BoundaryRelation.evalMatrix, Pi.zero_apply] using congrFun heval i
  have hf : (X ^ (2 * 2 ^ r) - 1) ∣ P := by
    rw [← unity_root_product (by positivity) z hi hz]
    apply Finset.prod_dvd_of_coprime
    · intro i _ j _ hij
      exact pairwise_coprime_X_sub_C hi hij
    · intro i _
      exact dvd_iff_isRoot.mpr (hv i)
  have hP : P = 0 := by
    by_contra hP
    have hle : P.natDegree ≤ d :=
      natDegree_le_iff_coeff_eq_zero.mpr (multiplierPolynomial_coeff_above x)
    obtain ⟨j, hj, hjd, hjne⟩ := stream_binomial_nonvanishing hp horder P hP hf m
    apply hjne
    have h := congrFun hrows ⟨j - 1, by omega⟩
    simp only [Pi.zero_apply, mulVec, dotProduct, BoundaryRelation.block] at h
    rw [filt_multiplier]
    convert h using 1
    apply Finset.sum_congr rfl
    intro i _
    rw [show m + 1 + (j - 1) + i.val = m + j + i.val by omega, mul_comm]
  ext i
  have h := congrArg (fun Q : (ZMod p)[X] => Q.coeff i.val) hP
  simpa only [P, multiplierPolynomial_coeff, coeff_zero, Pi.zero_apply] using h

end FunctionFieldLittlewood.TerminalDetection
