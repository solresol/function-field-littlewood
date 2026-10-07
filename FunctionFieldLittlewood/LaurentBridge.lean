module

public import FunctionFieldLittlewood.PolynomialBridge
public import Mathlib.RingTheory.LaurentSeries

@[expose] public section

/-!
Actual Laurent multiplication in the variable x = t⁻¹. A stream gives the power
series sum a_n x^n, and polynomial multipliers in t have negative x-exponents.
Positive x-exponents are the fractional t-part. No norm theorem or identification
with the original Lai--Sprang root-sum expression is assumed here.
-/

namespace FunctionFieldLittlewood

noncomputable section

variable {K : Type*} [CommSemiring K] {d : ℕ}

/-- Embed the full coefficient stream in mathlib's Laurent series in x=t⁻¹.
The value a_0 is allowed; it cannot affect any positive fractional coefficient. -/
def streamLaurent (a : ℕ → K) : LaurentSeries K :=
  HahnSeries.ofPowerSeries ℤ K (PowerSeries.mk a)

@[simp] theorem streamLaurent_coeff (a : ℕ → K) (n : ℕ) :
    (streamLaurent a).coeff (n : ℤ) = a n := by
  simp [streamLaurent, HahnSeries.ofPowerSeries_apply_coeff]

/-- The Laurent polynomial R(t)=sum R_i x^(-i). -/
def multiplierLaurent (R : Fin (d + 1) → K) : LaurentSeries K :=
  ∑ i, HahnSeries.single (-(i.val : ℤ)) (R i)

/-- The genuine product t^m R(t) Lambda(t), expressed with x=t⁻¹. -/
def shiftedLaurent (a : ℕ → K) (R : Fin (d + 1) → K) (m : ℕ) :
    LaurentSeries K :=
  HahnSeries.single (-(m : ℤ)) 1 * (multiplierLaurent R * streamLaurent a)

/-- The exact finite sum is the coefficient of the actual Laurent product.
This holds even at j=0, with no endpoint or field assumptions. -/
theorem shiftedLaurent_coeff (a : ℕ → K) (R : Fin (d + 1) → K) (m j : ℕ) :
    (shiftedLaurent a R m).coeff (j : ℤ) = fractionalCoeff a R m j := by
  simp only [shiftedLaurent, HahnSeries.coeff_single_mul, one_mul,
    multiplierLaurent, Finset.sum_mul, HahnSeries.coeff_sum, fractionalCoeff]
  apply Finset.sum_congr rfl
  intro i _
  have he : (j : ℤ) - -(m : ℤ) - -(i.val : ℤ) = ((m + i.val + j : ℕ) : ℤ) := by
    push_cast
    omega
  rw [he, streamLaurent_coeff]

/-- First nonzero positive x-coefficient (the fractional part in t). This does
not assert that j is the order of the full product, which may have poles. -/
def LaurentFirstPositive (f : LaurentSeries K) (j : ℕ) : Prop :=
  0 < j ∧ f.coeff (j : ℤ) ≠ 0 ∧
    ∀ k : ℕ, 0 < k → k < j → f.coeff (k : ℤ) = 0

theorem firstNonzero_iff_laurent (a : ℕ → K) (R : Fin (d + 1) → K) (m j : ℕ) :
    FirstNonzero a R m j ↔ LaurentFirstPositive (shiftedLaurent a R m) j := by
  simp only [FirstNonzero, LaurentFirstPositive, shiftedLaurent_coeff]

theorem certificate_laurent_sound (a : ℕ → K) (R : Fin (d + 1) → K) (m j : ℕ)
    (h : ExactCertificate a R m j) :
    LaurentFirstPositive (shiftedLaurent a R m) j :=
  (firstNonzero_iff_laurent a R m j).mp (certificate_sound a R m j h)

/-- The existing Hankel equations describe vanishing of actual Laurent
coefficients, without making a rank or endpoint claim. -/
theorem hankel_kernel_iff_laurent (a : ℕ → K) (R : Fin (d + 1) → K) (m L : ℕ) :
    (hankel a m d L).mulVec R = 0 ↔
      ∀ row : Fin L, (shiftedLaurent a R m).coeff ((row.val + 1 : ℕ) : ℤ) = 0 := by
  simpa only [shiftedLaurent_coeff] using hankel_kernel_iff a R m L

section Field
variable {F : Type*} [Field F]

/-- The Laurent multiplier is evaluation of the previously constructed actual
polynomial at x⁻¹, not just a newly named coefficient vector. -/
theorem multiplierLaurent_eq_eval (R : Fin (d + 1) → F) :
    multiplierLaurent R = (multiplierPolynomial R).eval₂ HahnSeries.C
      (HahnSeries.single (-1 : ℤ) 1 : LaurentSeries F) := by
  classical
  simp [multiplierLaurent, multiplierPolynomial, Polynomial.eval₂_finsetSum,
    HahnSeries.single_pow, HahnSeries.C_apply, HahnSeries.single_mul_single]

/-- An accepted primal/dual certificate bounds the positive Laurent index for
all endpoint-nonzero multipliers, including characteristic two. -/
theorem optimal_laurent_nonzero [DecidableEq F] (a : ℕ → F)
    (R : Fin (d + 1) → F) (m j : ℕ) (w : Fin (j + 1) → F)
    (h : checkOptimalCertificate a R m j w = true)
    (S : Fin (d + 1) → F) (h0 : S 0 ≠ 0) (hd : S (Fin.last d) ≠ 0) :
    ∃ k : ℕ, 0 < k ∧ k ≤ j ∧ (shiftedLaurent a S m).coeff (k : ℤ) ≠ 0 := by
  simpa only [shiftedLaurent_coeff] using
    (checkOptimalCertificate_sound_all a R m j w h).2 S h0 hd
/-- The same upper bound quantified over genuine degree-d polynomials. -/
theorem optimal_laurent_polynomial [DecidableEq F] (a : ℕ → F)
    (R : Fin (d + 1) → F) (m j : ℕ) (w : Fin (j + 1) → F)
    (h : checkOptimalCertificate a R m j w = true)
    (P : Polynomial F) (h0 : P.coeff 0 ≠ 0) (hd : P.natDegree = d) :
    ∃ k : ℕ, 0 < k ∧ k ≤ j ∧
      (HahnSeries.single (-(m : ℤ)) 1 *
        (P.eval₂ HahnSeries.C (HahnSeries.single (-1 : ℤ) 1 : LaurentSeries F) *
          streamLaurent a)).coeff (k : ℤ) ≠ 0 := by
  have hp := multiplierPolynomial_reconstruct P (le_of_eq hd)
  have he := multiplierLaurent_eq_eval (fun i : Fin (d + 1) => P.coeff i.val)
  rw [hp] at he
  have hcoeff (k : ℕ) := shiftedLaurent_coeff a
    (fun i : Fin (d + 1) => P.coeff i.val) m k
  simp only [shiftedLaurent, he, fractionalCoeff] at hcoeff
  simpa only [hcoeff] using optimal_polynomial_nonzero a R m j w h P h0 hd
end Field

#print axioms streamLaurent_coeff
#print axioms shiftedLaurent_coeff
#print axioms firstNonzero_iff_laurent
#print axioms certificate_laurent_sound
#print axioms multiplierLaurent_eq_eval
#print axioms hankel_kernel_iff_laurent
#print axioms optimal_laurent_polynomial
#print axioms optimal_laurent_nonzero

end
end FunctionFieldLittlewood
