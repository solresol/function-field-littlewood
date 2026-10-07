module

public import FunctionFieldLittlewood.DualCertificate
public import Mathlib.Algebra.Field.Basic

@[expose] public section

/-!
Nonzero scalar normalisation preserves finite certificates over every field,
including characteristic two. This removes the `S 0 = 1` restriction from the
semantic optimality conclusion; it does not certify an infinite defect bound.
-/

namespace FunctionFieldLittlewood

variable {K : Type*} [Field K] {d : ℕ}

theorem fractionalCoeff_scale (a : ℕ → K) (R : Fin (d + 1) → K)
    (c : K) (m j : ℕ) :
    fractionalCoeff a (fun i => c * R i) m j = c * fractionalCoeff a R m j := by
  simp only [fractionalCoeff, Finset.mul_sum, mul_assoc]

theorem firstNonzero_scale_iff (a : ℕ → K) (R : Fin (d + 1) → K)
    (c : K) (hc : c ≠ 0) (m j : ℕ) :
    FirstNonzero a (fun i => c * R i) m j ↔ FirstNonzero a R m j := by
  simp [FirstNonzero, fractionalCoeff_scale, hc]

theorem exactCertificate_scale_iff (a : ℕ → K) (R : Fin (d + 1) → K)
    (c : K) (hc : c ≠ 0) (m j : ℕ) :
    ExactCertificate a (fun i => c * R i) m j ↔ ExactCertificate a R m j := by
  simp [ExactCertificate, fractionalCoeff_scale, hc]

/-- Divide every coefficient by the nonzero constant coefficient. -/
def normaliseMultiplier (R : Fin (d + 1) → K) : Fin (d + 1) → K :=
  fun i => (R 0)⁻¹ * R i

theorem normaliseMultiplier_zero (R : Fin (d + 1) → K) (h0 : R 0 ≠ 0) :
    normaliseMultiplier R 0 = 1 := by
  exact inv_mul_cancel₀ h0

theorem normaliseMultiplier_last (R : Fin (d + 1) → K)
    (h0 : R 0 ≠ 0) (hd : R (Fin.last d) ≠ 0) :
    normaliseMultiplier R (Fin.last d) ≠ 0 :=
  mul_ne_zero (inv_ne_zero h0) hd

theorem exactCertificate_normalise_iff (a : ℕ → K) (R : Fin (d + 1) → K)
    (h0 : R 0 ≠ 0) (m j : ℕ) :
    ExactCertificate a (normaliseMultiplier R) m j ↔ ExactCertificate a R m j :=
  exactCertificate_scale_iff a R _ (inv_ne_zero h0) m j

/-- A checked normalised optimum bounds every multiplier with both endpoints
nonzero, without requiring a supplied first index for the competing multiplier. -/
theorem checkOptimalCertificate_sound_all [DecidableEq K] (a : ℕ → K)
    (R : Fin (d + 1) → K) (m j : ℕ) (w : Fin (j + 1) → K)
    (h : checkOptimalCertificate a R m j w = true) :
    FirstNonzero a R m j ∧
      ∀ S : Fin (d + 1) → K, S 0 ≠ 0 → S (Fin.last d) ≠ 0 →
        ∃ k : ℕ, 0 < k ∧ k ≤ j ∧ fractionalCoeff a S m k ≠ 0 := by
  obtain ⟨hr, hb⟩ := checkOptimalCertificate_sound a R m j w h
  refine ⟨hr, ?_⟩
  intro S h0 hd
  obtain ⟨k, hk, hkj, hn⟩ := hb (normaliseMultiplier S)
    (normaliseMultiplier_zero S h0) (normaliseMultiplier_last S h0 hd)
  refine ⟨k, hk, hkj, ?_⟩
  intro hz
  apply hn
  change fractionalCoeff a (fun i => (S 0)⁻¹ * S i) m k = 0
  rw [fractionalCoeff_scale, hz, mul_zero]

theorem optimal_first_le_all [DecidableEq K] (a : ℕ → K)
    (R : Fin (d + 1) → K) (m j : ℕ) (w : Fin (j + 1) → K)
    (h : checkOptimalCertificate a R m j w = true)
    (S : Fin (d + 1) → K) (h0 : S 0 ≠ 0) (hd : S (Fin.last d) ≠ 0)
    (ell : ℕ) (hs : FirstNonzero a S m ell) : ell ≤ j := by
  obtain ⟨k, hk, hkj, hn⟩ := (checkOptimalCertificate_sound_all a R m j w h).2 S h0 hd
  by_contra he
  exact hn (hs.2.2 k hk (by omega))

#print axioms exactCertificate_scale_iff
#print axioms exactCertificate_normalise_iff
#print axioms checkOptimalCertificate_sound_all
#print axioms optimal_first_le_all

end FunctionFieldLittlewood
