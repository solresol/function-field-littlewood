import FunctionFieldLittlewood.PolynomialBridge
import FunctionFieldLittlewood.Examples
import FunctionFieldLittlewood.SavedCertificates
import Mathlib.Algebra.Field.ZMod

namespace FunctionFieldLittlewood

instance : Fact (Nat.Prime 17) := ⟨by decide⟩

/-- A nontrivial scalar change in F_3 preserves the recorded index. -/
theorem scaled_comparison_certificate :
    ExactCertificate ternaryPrefix (fun i => (2 : ZMod 3) * comparisonMultiplier i) 2 6 :=
  (exactCertificate_scale_iff _ _ _ (by decide) _ _).mpr comparison_certificate

example : normaliseMultiplier (fun i => (2 : ZMod 3) * comparisonMultiplier i) =
    comparisonMultiplier := by decide

/-- Zero scaling is excluded: it destroys the endpoints and terminal coefficient. -/
example : ¬ ExactCertificate ternaryPrefix
    (fun i => (0 : ZMod 3) * comparisonMultiplier i) 2 6 := by decide

example : (multiplierPolynomial comparisonMultiplier).natDegree = 2 :=
  multiplierPolynomial_natDegree _ (by decide)

example : (multiplierPolynomial Saved.laiSprang17R).natDegree = 0 ∧
    ¬ Polynomial.X ∣ multiplierPolynomial Saved.laiSprang17R :=
  ⟨multiplierPolynomial_natDegree _ (by decide),
    multiplierPolynomial_not_X_dvd _ (by decide)⟩

/-- The binary saved optimum now quantifies over actual polynomials.
The stream here is still the saved prefix padded by zero. -/
theorem binary_polynomial_optimal (P : Polynomial (ZMod 2))
    (h0 : P.coeff 0 ≠ 0) (hd : P.natDegree = 9) :
    ∃ k : ℕ, 0 < k ∧ k ≤ 24 ∧
      (∑ i : Fin 10, P.coeff i.val * Saved.thueMorsePrefix (15 + i.val + k)) ≠ 0 :=
  optimal_polynomial_nonzero _ _ _ _ _ Saved.thueMorse_accepted P h0 hd

/-- All 16 nonzero scalar multiples are covered in the F_17 degree-zero case. -/
theorem odd_polynomial_optimal (P : Polynomial (ZMod 17))
    (h0 : P.coeff 0 ≠ 0) (hd : P.natDegree = 0) :
    ∃ k : ℕ, 0 < k ∧ k ≤ 15 ∧
      (∑ i : Fin 1, P.coeff i.val * Saved.laiSprang17Prefix (17 + i.val + k)) ≠ 0 :=
  optimal_polynomial_nonzero _ _ _ _ _ Saved.laiSprang17_accepted P h0 hd

#print axioms scaled_comparison_certificate
#print axioms binary_polynomial_optimal
#print axioms odd_polynomial_optimal

end FunctionFieldLittlewood
