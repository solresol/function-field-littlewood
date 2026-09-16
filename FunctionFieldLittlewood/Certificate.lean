import Mathlib.Data.Matrix.Mul
import Mathlib.Data.ZMod.Basic

/-!
Finite coefficient certificates for shifted polynomial multiplication.

A stream is indexed by natural numbers, with `a n` representing the coefficient
of `t^(-n)` for `n > 0`. Index zero is unused by the fractional coefficients.
There is no Laurent-series/norm theorem here, nor any global defect bound.
-/

namespace FunctionFieldLittlewood

variable {K : Type*} [CommSemiring K] {d : ℕ}

/-- Coefficient of `t^(-j)` in `t^m (sum_i R_i t^i) (sum_n a_n t^(-n))`.
The intended fractional indices satisfy `0 < j`. -/
def fractionalCoeff (a : ℕ → K) (R : Fin (d + 1) → K) (m j : ℕ) : K :=
  ∑ i, R i * a (m + i.val + j)

/-- The finite Hankel matrix of the first `L` fractional coefficient equations. -/
def hankel (a : ℕ → K) (m d L : ℕ) : Matrix (Fin L) (Fin (d + 1)) K :=
  fun row col => a (m + col.val + (row.val + 1))

theorem hankel_mulVec (a : ℕ → K) (R : Fin (d + 1) → K) (m L : ℕ)
    (row : Fin L) :
    (hankel a m d L).mulVec R row = fractionalCoeff a R m (row.val + 1) := by
  simp [hankel, Matrix.mulVec, dotProduct, fractionalCoeff, mul_comm]

/-- Exact equality of all prefix equations with a matrix kernel condition. -/
theorem hankel_kernel_iff (a : ℕ → K) (R : Fin (d + 1) → K) (m L : ℕ) :
    (hankel a m d L).mulVec R = 0 ↔
      ∀ row : Fin L, fractionalCoeff a R m (row.val + 1) = 0 := by
  constructor
  · intro h row
    have hrow := congrFun h row
    simpa [hankel_mulVec] using hrow
  · intro h
    funext row
    simpa [hankel_mulVec] using h row

/-- A finite, decidable certificate. Both endpoints of R must be nonzero:
this fixes the actual degree and excludes a hidden factor of t. -/
def ExactCertificate (a : ℕ → K) (R : Fin (d + 1) → K) (m j : ℕ) : Prop :=
  0 < j ∧ R 0 ≠ 0 ∧ R (Fin.last d) ≠ 0 ∧
  (∀ row : Fin (j - 1), fractionalCoeff a R m (row.val + 1) = 0) ∧
  fractionalCoeff a R m j ≠ 0

instance [DecidableEq K] (a : ℕ → K) (R : Fin (d + 1) → K) (m j : ℕ) :
    Decidable (ExactCertificate a R m j) := by
  unfold ExactCertificate
  infer_instance

/-- Semantic first-nonzero index, without a finite search cutoff. -/
def FirstNonzero (a : ℕ → K) (R : Fin (d + 1) → K) (m j : ℕ) : Prop :=
  0 < j ∧ fractionalCoeff a R m j ≠ 0 ∧
  ∀ k : ℕ, 0 < k → k < j → fractionalCoeff a R m k = 0

/-- A certificate proves the exact index, not merely a vanishing prefix. -/
theorem certificate_sound (a : ℕ → K) (R : Fin (d + 1) → K) (m j : ℕ)
    (h : ExactCertificate a R m j) : FirstNonzero a R m j := by
  refine ⟨h.1, h.2.2.2.2, ?_⟩
  intro k hk hkj
  have hrow : k - 1 < j - 1 := by omega
  have heq : k - 1 + 1 = k := by omega
  simpa only [heq] using h.2.2.2.1 ⟨k - 1, hrow⟩

/-- Only the finite input prefix through `m + d + j` is inspected. -/
theorem fractionalCoeff_congr_prefix (a b : ℕ → K) (R : Fin (d + 1) → K)
    (m j : ℕ) (h : ∀ n, n ≤ m + d + j → a n = b n) :
    fractionalCoeff a R m j = fractionalCoeff b R m j := by
  apply Finset.sum_congr rfl
  intro i _
  have hi := i.isLt
  rw [h (m + i.val + j) (by omega)]

/-- Extending or replacing the uninspected tail preserves an exact certificate. -/
theorem certificate_congr_prefix (a b : ℕ → K) (R : Fin (d + 1) → K)
    (m j : ℕ) (h : ∀ n, n ≤ m + d + j → a n = b n) :
    ExactCertificate a R m j ↔ ExactCertificate b R m j := by
  have hj := fractionalCoeff_congr_prefix a b R m j h
  have hrow (row : Fin (j - 1)) :
      fractionalCoeff a R m (row.val + 1) =
        fractionalCoeff b R m (row.val + 1) := by
    apply fractionalCoeff_congr_prefix
    intro n hn
    apply h
    have hr := row.isLt
    omega
  simp only [ExactCertificate, hj, hrow]

/-- A Boolean checker whose acceptance entails the semantic first index. -/
def checkCertificate [DecidableEq K] (a : ℕ → K) (R : Fin (d + 1) → K)
    (m j : ℕ) : Bool := decide (ExactCertificate a R m j)

theorem checkCertificate_sound [DecidableEq K] (a : ℕ → K)
    (R : Fin (d + 1) → K) (m j : ℕ) (h : checkCertificate a R m j = true) :
    FirstNonzero a R m j := by
  apply certificate_sound
  exact of_decide_eq_true h

end FunctionFieldLittlewood
