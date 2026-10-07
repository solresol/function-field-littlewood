module

public import FunctionFieldLittlewood.FractionalPart
public import FunctionFieldLittlewood.LaiSprangStream

@[expose] public section

/-! Boundary controls for the product bridge. Named witnesses are existing
regressions, not additional attainment evidence or new counterexamples. -/
namespace FunctionFieldLittlewood
noncomputable section

-- A pole and a constant term must both disappear from the fractional part.
example (F : Type*) [Field F] (a b : F) :
    fractionalPart (HahnSeries.single (-3 : ℤ) a + HahnSeries.single 0 b :
      LaurentSeries F) = 0 := by
  apply (fractionalPart_eq_zero_iff _).mpr
  intro n hn
  simp [HahnSeries.coeff_add, ne_of_gt hn,
    show (n : ℤ) ≠ -3 by omega]

-- The zero fractional part has size zero, not 2^0 from the total order convention.
example : infinitySize (fractionalPart (0 : LaurentSeries (ZMod 3))) = 0 := by simp

-- Boundary j=1: a constant term is discarded; the positive monomial survives.
example : infinitySize (fractionalPart
    (HahnSeries.single 0 1 + HahnSeries.single 1 1 : LaurentSeries (ZMod 3))) =
      (2 : ℝ) ^ (-1 : ℤ) := by
  apply fractionalPart_size _ 1
  refine ⟨by decide, ?_, ?_⟩
  · simp [HahnSeries.coeff_add]
  · intro k hk hlt
    omega

-- No first index exists for the zero stream; the bound must reject it.
example (d m N : ℕ) (R : Fin (d + 1) → ZMod 3) :
    ¬ (2 : ℝ) ^ (-(N : ℤ)) ≤ reducedProduct (fun _ => 0) R m := by
  rw [reducedProduct_bound_iff_nonzero_prefix]
  simp [fractionalCoeff]

-- An index below the degree gives a positive exponent, not truncated subtraction.
example (a : ℕ → ZMod 3) (R : Fin 4 → ZMod 3) (m : ℕ)
    (h : FirstNonzero a R m 1) : reducedProduct a R m = 4 := by
  rw [firstNonzero_reducedProduct a R m 1 h]
  norm_num

/-- The previously proved sharp F_17 certificate gives product 2^-16. -/
theorem laiSprang17_polynomial_product :
    polynomialLittlewoodProduct (laiSprangStream 17 4)
      (Polynomial.X ^ 81 * multiplierPolynomial (fun _ : Fin 1 => 1)) =
        (2 : ℝ) ^ (-16 : ℤ) := by
  simpa using certificate_polynomialLittlewoodProduct _ _ _ _
    laiSprang17_sharp_certificate

/-- Preserve r=1: degree two, index six gives 2^-4, below 2^-N for N=2. -/
theorem laiSprang3_polynomial_product :
    polynomialLittlewoodProduct (laiSprangStream 3 1)
      (Polynomial.X ^ 2 * multiplierPolynomial comparisonMultiplier) =
        (2 : ℝ) ^ (-4 : ℤ) := by
  simpa using certificate_polynomialLittlewoodProduct _ _ _ _
    laiSprang3_comparison_certificate

#print axioms laiSprang17_polynomial_product
#print axioms laiSprang3_polynomial_product
end
end FunctionFieldLittlewood
