import FunctionFieldLittlewood.Normalisation
import Mathlib.Algebra.Polynomial.Degree.Lemmas
import Mathlib.Algebra.Polynomial.Div

/-!
The coefficient vectors used by the search are genuine polynomials of the
claimed degree. This is a finite polynomial bridge, not a Laurent-series or
norm identification.
-/

namespace FunctionFieldLittlewood

noncomputable section

variable {K : Type*} [Field K] {d : ℕ}

/-- Assemble the finite multiplier using mathlib's polynomial monomials. -/
def multiplierPolynomial (R : Fin (d + 1) → K) : Polynomial K :=
  ∑ i, Polynomial.monomial i.val (R i)

theorem multiplierPolynomial_coeff (R : Fin (d + 1) → K) (i : Fin (d + 1)) :
    (multiplierPolynomial R).coeff i.val = R i := by
  classical
  simp [multiplierPolynomial, Polynomial.coeff_monomial, Fin.val_inj]

theorem multiplierPolynomial_coeff_above (R : Fin (d + 1) → K)
    (n : ℕ) (hn : d < n) : (multiplierPolynomial R).coeff n = 0 := by
  classical
  have hne (i : Fin (d + 1)) : i.val ≠ n := by have := i.isLt; omega
  simp [multiplierPolynomial, Polynomial.coeff_monomial, hne]

theorem multiplierPolynomial_natDegree (R : Fin (d + 1) → K)
    (hd : R (Fin.last d) ≠ 0) : (multiplierPolynomial R).natDegree = d := by
  apply Polynomial.natDegree_eq_of_le_of_coeff_ne_zero
  · exact Polynomial.natDegree_le_iff_coeff_eq_zero.mpr
      (multiplierPolynomial_coeff_above R)
  · simpa using (multiplierPolynomial_coeff R (Fin.last d)) ▸ hd

theorem multiplierPolynomial_not_X_dvd (R : Fin (d + 1) → K)
    (h0 : R 0 ≠ 0) : ¬ Polynomial.X ∣ multiplierPolynomial R := by
  rw [Polynomial.X_dvd_iff]
  simpa using (multiplierPolynomial_coeff R 0) ▸ h0

/-- Every polynomial of degree at most d is recovered from these coefficients. -/
theorem multiplierPolynomial_reconstruct (P : Polynomial K) (hp : P.natDegree ≤ d) :
    multiplierPolynomial (fun i : Fin (d + 1) => P.coeff i.val) = P := by
  apply Polynomial.ext
  intro n
  by_cases hn : n < d + 1
  · exact multiplierPolynomial_coeff _ ⟨n, hn⟩
  · rw [multiplierPolynomial_coeff_above _ n (by omega),
      Polynomial.coeff_eq_zero_of_natDegree_lt (by omega)]

/-- The certificate endpoints give degree d and exclude a hidden factor of X,
including the degree-zero case. -/
theorem certificate_polynomial_endpoints (a : ℕ → K) (R : Fin (d + 1) → K)
    (m j : ℕ) (h : ExactCertificate a R m j) :
    (multiplierPolynomial R).natDegree = d ∧
      (multiplierPolynomial R).coeff 0 ≠ 0 ∧
      ¬ Polynomial.X ∣ multiplierPolynomial R := by
  refine ⟨multiplierPolynomial_natDegree R h.2.2.1, ?_,
    multiplierPolynomial_not_X_dvd R h.2.1⟩
  simpa using (multiplierPolynomial_coeff R 0) ▸ h.2.1

/-- A checked finite optimum applies to every actual degree-d polynomial with
nonzero constant term. The displayed sum is still a finite coefficient formula. -/
theorem optimal_polynomial_nonzero [DecidableEq K] (a : ℕ → K)
    (R : Fin (d + 1) → K) (m j : ℕ) (w : Fin (j + 1) → K)
    (h : checkOptimalCertificate a R m j w = true)
    (P : Polynomial K) (h0 : P.coeff 0 ≠ 0) (hd : P.natDegree = d) :
    ∃ k : ℕ, 0 < k ∧ k ≤ j ∧
      (∑ i : Fin (d + 1), P.coeff i.val * a (m + i.val + k)) ≠ 0 := by
  have hp : P ≠ 0 := by intro hz; exact h0 (by simp [hz])
  have hlead : P.coeff d ≠ 0 := by
    rw [← hd, Polynomial.coeff_natDegree]
    exact Polynomial.leadingCoeff_ne_zero.mpr hp
  exact (checkOptimalCertificate_sound_all a R m j w h).2
    (fun i => P.coeff i.val) h0 hlead

#print axioms multiplierPolynomial_coeff
#print axioms multiplierPolynomial_natDegree
#print axioms multiplierPolynomial_reconstruct
#print axioms certificate_polynomial_endpoints
#print axioms optimal_polynomial_nonzero

end

end FunctionFieldLittlewood
