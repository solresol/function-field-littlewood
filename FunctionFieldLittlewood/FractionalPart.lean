import FunctionFieldLittlewood.LaurentBridge
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Polynomial.Degree.TrailingDegree

/-! Strictly positive x-part for x=t⁻¹, and the base-two size used in this
repository. This is an explicit size function, not an ambient norm instance. -/

namespace FunctionFieldLittlewood
noncomputable section
variable {K : Type*} [CommRing K] {d : ℕ}

/-- Remove all nonpositive x-powers, including the constant term. -/
def fractionalPart (f : LaurentSeries K) : LaurentSeries K :=
  f - HahnSeries.truncLT 1 f

@[simp] theorem fractionalPart_coeff (f : LaurentSeries K) (n : ℤ) :
    (fractionalPart f).coeff n = if 0 < n then f.coeff n else 0 := by
  simp only [fractionalPart, HahnSeries.coeff_sub, HahnSeries.coeff_truncLT]
  split_ifs <;> simp_all <;> omega

@[simp] theorem fractionalPart_zero : fractionalPart (0 : LaurentSeries K) = 0 := by
  simp [fractionalPart]

/-- This criterion includes a vanishing fractional part, with no invented index. -/
theorem fractionalPart_eq_zero_iff (f : LaurentSeries K) :
    fractionalPart f = 0 ↔ ∀ n : ℕ, 0 < n → f.coeff (n : ℤ) = 0 := by
  constructor
  · intro h n hn
    have hc := congrArg (fun g : LaurentSeries K => g.coeff (n : ℤ)) h
    simpa [fractionalPart_coeff, hn] using hc
  · intro h
    ext n
    rw [fractionalPart_coeff, HahnSeries.coeff_zero]
    split_ifs with hn
    · simpa [Int.toNat_of_nonneg (le_of_lt hn)] using h n.toNat (by omega)
    · rfl

/-- Exact positive index gives the actual order of the fractional part. -/
theorem fractionalPart_order (f : LaurentSeries K) (j : ℕ)
    (h : LaurentFirstPositive f j) :
    fractionalPart f ≠ 0 ∧ (fractionalPart f).order = (j : ℤ) := by
  have hj : (fractionalPart f).coeff (j : ℤ) ≠ 0 := by
    simpa [fractionalPart_coeff, h.1] using h.2.1
  have hn := HahnSeries.ne_zero_of_coeff_ne_zero hj
  refine ⟨hn, le_antisymm (HahnSeries.order_le_of_coeff_ne_zero hj) ?_⟩
  by_contra! hlt
  have hz : (fractionalPart f).coeff (fractionalPart f).order = 0 := by
    rw [fractionalPart_coeff]
    split_ifs with hp
    · have hk := h.2.2 (fractionalPart f).order.toNat (by omega) (by omega)
      simpa [Int.toNat_of_nonneg (le_of_lt hp)] using hk
    · rfl
  exact hn (HahnSeries.coeff_order_eq_zero.mp hz)

/-- Base-two t-infinity size in the coordinate x=t⁻¹; zero has size zero. -/
def infinitySize (f : LaurentSeries K) : ℝ :=
  by
    classical
    exact if f = 0 then 0 else (2 : ℝ) ^ (-f.order)

@[simp] theorem infinitySize_zero : infinitySize (0 : LaurentSeries K) = 0 := by
  simp [infinitySize]

theorem fractionalPart_size (f : LaurentSeries K) (j : ℕ)
    (h : LaurentFirstPositive f j) :
    infinitySize (fractionalPart f) = (2 : ℝ) ^ (-(j : ℤ)) := by
  obtain ⟨hne, hord⟩ := fractionalPart_order f j h
  simp [infinitySize, hne, hord]

/-- Reduced Littlewood expression after cancelling the degree/shift factors.
It is defined on an actual Laurent product, including the zero fractional case. -/
def reducedProduct (a : ℕ → K) (R : Fin (d + 1) → K) (m : ℕ) : ℝ :=
  (2 : ℝ) ^ (d : ℤ) * infinitySize (fractionalPart (shiftedLaurent a R m))

theorem firstNonzero_reducedProduct (a : ℕ → K) (R : Fin (d + 1) → K)
    (m j : ℕ) (h : FirstNonzero a R m j) :
    reducedProduct a R m = (2 : ℝ) ^ ((d : ℤ) - j) := by
  rw [reducedProduct, fractionalPart_size _ _ ((firstNonzero_iff_laurent ..).mp h)]
  rw [← zpow_add₀ (by norm_num : (2 : ℝ) ≠ 0)]
  rfl

/-- The intended auxiliary defect inequality uses integers, not truncated
natural subtraction. This equivalence does not assume a uniform bound. -/
theorem reducedProduct_bound_iff (a : ℕ → K) (R : Fin (d + 1) → K)
    (m j N : ℕ) (h : FirstNonzero a R m j) :
    (2 : ℝ) ^ (-(N : ℤ)) ≤ reducedProduct a R m ↔ (j : ℤ) - d ≤ N := by
  rw [firstNonzero_reducedProduct a R m j h,
    zpow_le_zpow_iff_right₀ (by norm_num : (1 : ℝ) < 2)]
  omega

/-- Every nonzero fractional part has a genuine first positive coefficient. -/
theorem exists_laurentFirstPositive (f : LaurentSeries K)
    (h : fractionalPart f ≠ 0) : ∃ j, LaurentFirstPositive f j := by
  have hc := HahnSeries.coeff_order_eq_zero.not.mpr h
  have hp : 0 < (fractionalPart f).order := by
    by_contra! hn
    exact hc (by simp [fractionalPart_coeff, not_lt.mpr hn])
  refine ⟨(fractionalPart f).order.toNat, ?_, ?_, ?_⟩
  · omega
  · simpa [fractionalPart_coeff, Int.toNat_of_nonneg hp.le, hp] using hc
  · intro k hk hkj
    have hz : (fractionalPart f).coeff (k : ℤ) = 0 :=
      HahnSeries.coeff_eq_zero_of_lt_order (by omega)
    simpa [fractionalPart_coeff, hk] using hz

/-- Structural target for the all-degree bound: exclude an endpoint-admissible
multiplier annihilating all of the first d+N rows. No first index is assumed. -/
theorem reducedProduct_bound_iff_nonzero_prefix (a : ℕ → K)
    (R : Fin (d + 1) → K) (m N : ℕ) :
    (2 : ℝ) ^ (-(N : ℤ)) ≤ reducedProduct a R m ↔
      ∃ k : ℕ, 0 < k ∧ k ≤ d + N ∧ fractionalCoeff a R m k ≠ 0 := by
  by_cases hz : fractionalPart (shiftedLaurent a R m) = 0
  · have hcoeff := (fractionalPart_eq_zero_iff _).mp hz
    have hpos : 0 < (2 : ℝ) ^ (-(N : ℤ)) := zpow_pos (by norm_num) _
    constructor
    · intro hb
      simp only [reducedProduct, hz, infinitySize_zero, mul_zero] at hb
      exact (not_le.mpr hpos hb).elim
    · rintro ⟨k, hk, _, hc⟩
      exact (hc (by simpa only [shiftedLaurent_coeff] using hcoeff k hk)).elim
  · obtain ⟨j, hj⟩ := exists_laurentFirstPositive _ hz
    have hf := (firstNonzero_iff_laurent a R m j).mpr hj
    rw [reducedProduct_bound_iff a R m j N hf]
    constructor
    · intro hbound
      exact ⟨j, hf.1, by omega, hf.2.1⟩
    · rintro ⟨k, hk, hbound, hc⟩
      have hjk : j ≤ k := by
        by_contra! hkj
        exact hc (hf.2.2 k hk hkj)
      omega

/-- Cancellation of the shift factors, used after identifying polynomial degrees. -/
theorem shifted_factors_cancel (a : ℕ → K) (R : Fin (d + 1) → K) (m : ℕ) :
    (2 : ℝ) ^ ((d : ℤ) + m) * (2 : ℝ) ^ (-(m : ℤ)) *
      infinitySize (fractionalPart (shiftedLaurent a R m)) = reducedProduct a R m := by
  rw [← zpow_add₀ (by norm_num : (2 : ℝ) ≠ 0)]
  have he : (d : ℤ) + m + -(m : ℤ) = d := by omega
  rw [he]
  rfl

section Field
variable {F : Type*} [Field F]

/-- The product |Q| |Q|_t |<Q Lambda>| with base two. The t-adic exponent is
mathlib's actual polynomial trailing degree, not a supplied shift parameter. -/
def polynomialLittlewoodProduct (a : ℕ → F) (Q : Polynomial F) : ℝ :=
  (2 : ℝ) ^ (Q.natDegree : ℤ) * (2 : ℝ) ^ (-(Q.natTrailingDegree : ℤ)) *
    infinitySize (fractionalPart
      (Q.eval₂ HahnSeries.C (HahnSeries.single (-1 : ℤ) 1 : LaurentSeries F) *
        streamLaurent a))

/-- Endpoint assumptions identify both degree and t-adic order of Q=t^m R. -/
theorem polynomialLittlewoodProduct_eq_reduced (a : ℕ → F)
    (R : Fin (d + 1) → F) (m : ℕ) (h0 : R 0 ≠ 0) (hd : R (Fin.last d) ≠ 0) :
    polynomialLittlewoodProduct a (Polynomial.X ^ m * multiplierPolynomial R) =
      reducedProduct a R m := by
  have hc : (multiplierPolynomial R).coeff 0 ≠ 0 := by
    simpa using (multiplierPolynomial_coeff R 0) ▸ h0
  have hp : multiplierPolynomial R ≠ 0 := by
    intro hz
    exact hc (by simp [hz])
  have ht : (multiplierPolynomial R).natTrailingDegree = 0 :=
    Polynomial.natTrailingDegree_eq_zero.mpr (Or.inr hc)
  have htq : (Polynomial.X ^ m * multiplierPolynomial R).natTrailingDegree = m := by
    rw [mul_comm, Polynomial.natTrailingDegree_mul_X_pow hp, ht, zero_add]
  have hev : (Polynomial.X ^ m * multiplierPolynomial R).eval₂ HahnSeries.C
      (HahnSeries.single (-1 : ℤ) 1 : LaurentSeries F) * streamLaurent a =
        shiftedLaurent a R m := by
    rw [Polynomial.eval₂_mul, Polynomial.eval₂_pow, Polynomial.eval₂_X,
      ← multiplierLaurent_eq_eval]
    simp [HahnSeries.single_pow, shiftedLaurent, mul_assoc]
  rw [polynomialLittlewoodProduct, Polynomial.natDegree_X_pow_mul m hp,
    multiplierPolynomial_natDegree R hd, htq, hev, Nat.cast_add]
  exact shifted_factors_cancel a R m

/-- A finite exact certificate now determines the actual polynomial product. -/
theorem certificate_polynomialLittlewoodProduct (a : ℕ → F)
    (R : Fin (d + 1) → F) (m j : ℕ) (h : ExactCertificate a R m j) :
    polynomialLittlewoodProduct a (Polynomial.X ^ m * multiplierPolynomial R) =
      (2 : ℝ) ^ ((d : ℤ) - j) := by
  rw [polynomialLittlewoodProduct_eq_reduced a R m h.2.1 h.2.2.1]
  exact firstNonzero_reducedProduct a R m j (certificate_sound a R m j h)

/-- The remaining auxiliary bound is precisely a uniform nonvanishing-prefix
statement for endpoint-admissible multipliers. This proves an equivalence only. -/
theorem polynomialLittlewoodProduct_bound_iff (a : ℕ → F)
    (R : Fin (d + 1) → F) (m N : ℕ) (h0 : R 0 ≠ 0) (hd : R (Fin.last d) ≠ 0) :
    (2 : ℝ) ^ (-(N : ℤ)) ≤
      polynomialLittlewoodProduct a (Polynomial.X ^ m * multiplierPolynomial R) ↔
        ∃ k : ℕ, 0 < k ∧ k ≤ d + N ∧ fractionalCoeff a R m k ≠ 0 := by
  rw [polynomialLittlewoodProduct_eq_reduced a R m h0 hd]
  exact reducedProduct_bound_iff_nonzero_prefix a R m N
end Field

#print axioms polynomialLittlewoodProduct_eq_reduced
#print axioms certificate_polynomialLittlewoodProduct
#print axioms polynomialLittlewoodProduct_bound_iff
#print axioms exists_laurentFirstPositive
#print axioms reducedProduct_bound_iff_nonzero_prefix
#print axioms shifted_factors_cancel
#print axioms fractionalPart_eq_zero_iff
#print axioms fractionalPart_order
#print axioms fractionalPart_size
#print axioms firstNonzero_reducedProduct
#print axioms reducedProduct_bound_iff
end
end FunctionFieldLittlewood
