module

public import FunctionFieldLittlewood.Certificate

@[expose] public section

/-!
Soundness of the two dual formats emitted by `search/finite_rank.py`.
Weights have length `L+1`: entry zero weights `R 0 = 1`, and entry `k+1`
weights the fractional coefficient at `k+1`. No elimination or rank is trusted.
-/

namespace FunctionFieldLittlewood

variable {K : Type*} [CommSemiring K] {d L : ℕ}

/-- Coefficients of the weighted sum of the normalisation and prefix rows. -/
def dualRow (a : ℕ → K) (m : ℕ) (w : Fin (L + 1) → K)
    (i : Fin (d + 1)) : K :=
  (if i = 0 then w 0 else 0) +
    ∑ k : Fin L, w k.succ * a (m + i.val + (k.val + 1))

/-- Evaluate the weighted row on an arbitrary multiplier. -/
theorem dualRow_eval (a : ℕ → K) (m : ℕ) (w : Fin (L + 1) → K)
    (R : Fin (d + 1) → K) :
    (∑ i, dualRow a m w i * R i) =
      w 0 * R 0 + ∑ k : Fin L, w k.succ * fractionalCoeff a R m (k.val + 1) := by
  simp only [dualRow, add_mul, Finset.sum_add_distrib, Finset.sum_mul]
  congr 1
  · simp
  · rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro k _
    simp only [fractionalCoeff, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    ac_rfl

/-- A normalised multiplier annihilating the prefix evaluates the dual to w_0. -/
theorem dualRow_eval_of_prefix (a : ℕ → K) (m : ℕ) (w : Fin (L + 1) → K)
    (R : Fin (d + 1) → K) (h0 : R 0 = 1)
    (hz : ∀ k : Fin L, fractionalCoeff a R m (k.val + 1) = 0) :
    (∑ i, dualRow a m w i * R i) = w 0 := by
  rw [dualRow_eval]
  simp [h0, hz]

/-- Exactly the two independently checked Python obstruction formats. -/
def DualObstruction (a : ℕ → K) (m d L : ℕ) (w : Fin (L + 1) → K) : Prop :=
  ((∀ i : Fin (d + 1), dualRow a m w i = 0) ∧ w 0 ≠ 0) ∨
  ((∀ i : Fin (d + 1), dualRow a m w i = if i = Fin.last d then 1 else 0) ∧
    w 0 = 0)

instance [DecidableEq K] (a : ℕ → K) (m d L : ℕ) (w : Fin (L + 1) → K) :
    Decidable (DualObstruction a m d L w) := by
  unfold DualObstruction
  infer_instance

/-- A checked dual rules out every admissible multiplier vanishing through L. -/
theorem dualObstruction_sound (a : ℕ → K) (m : ℕ) (w : Fin (L + 1) → K)
    (h : DualObstruction a m d L w) (R : Fin (d + 1) → K)
    (h0 : R 0 = 1) (hd : R (Fin.last d) ≠ 0) :
    ¬ (∀ k : Fin L, fractionalCoeff a R m (k.val + 1) = 0) := by
  intro hz
  have he := dualRow_eval_of_prefix a m w R h0 hz
  rcases h with ⟨hrow, hw⟩ | ⟨hrow, hw⟩
  · have : (0 : K) = w 0 := by simpa [hrow] using he
    exact hw this.symm
  · have : R (Fin.last d) = w 0 := by simpa [hrow] using he
    exact hd (this.trans hw)

/-- Finite primal/dual acceptance; it does not check the diagnostic rank. -/
def checkOptimalCertificate [DecidableEq K] (a : ℕ → K)
    (R : Fin (d + 1) → K) (m j : ℕ) (w : Fin (j + 1) → K) : Bool :=
  decide (ExactCertificate a R m j ∧ R 0 = 1 ∧ DualObstruction a m d j w)

/-- Acceptance proves attainment and that every admissible multiplier has a
nonzero coefficient by j. This includes multipliers with no supplied exact index. -/
theorem checkOptimalCertificate_sound [DecidableEq K] (a : ℕ → K)
    (R : Fin (d + 1) → K) (m j : ℕ) (w : Fin (j + 1) → K)
    (h : checkOptimalCertificate a R m j w = true) :
    FirstNonzero a R m j ∧
      ∀ S : Fin (d + 1) → K, S 0 = 1 → S (Fin.last d) ≠ 0 →
        ∃ k : ℕ, 0 < k ∧ k ≤ j ∧ fractionalCoeff a S m k ≠ 0 := by
  have hc : ExactCertificate a R m j ∧ R 0 = 1 ∧ DualObstruction a m d j w :=
    of_decide_eq_true h
  refine ⟨certificate_sound _ _ _ _ hc.1, ?_⟩
  intro S h0 hd
  have hn := dualObstruction_sound a m w hc.2.2 S h0 hd
  classical
  obtain ⟨k, hk⟩ := not_forall.mp hn
  refine ⟨k.val + 1, by omega, ?_, hk⟩
  have := k.isLt
  omega

/-- In particular every other exact first index at these d,m is at most j. -/
theorem optimal_first_le [DecidableEq K] (a : ℕ → K)
    (R : Fin (d + 1) → K) (m j : ℕ) (w : Fin (j + 1) → K)
    (h : checkOptimalCertificate a R m j w = true)
    (S : Fin (d + 1) → K) (h0 : S 0 = 1) (hd : S (Fin.last d) ≠ 0)
    (ell : ℕ) (hs : FirstNonzero a S m ell) : ell ≤ j := by
  obtain ⟨k, hk, hkj, hn⟩ := (checkOptimalCertificate_sound a R m j w h).2 S h0 hd
  by_contra he
  exact hn (hs.2.2 k hk (by omega))

/-- A dual, like a primal certificate, only inspects the inclusive finite prefix. -/
theorem dualRow_congr_prefix (a b : ℕ → K) (m : ℕ) (w : Fin (L + 1) → K)
    (h : ∀ n, n ≤ m + d + L → a n = b n) (i : Fin (d + 1)) :
    dualRow a m w i = dualRow b m w i := by
  unfold dualRow
  congr 1
  apply Finset.sum_congr rfl
  intro k _
  have hi := i.isLt
  have hk := k.isLt
  rw [h _ (by omega)]

/-- Replacing the uninspected tail preserves the full finite optimality checker. -/
theorem checkOptimalCertificate_congr_prefix [DecidableEq K] (a b : ℕ → K)
    (R : Fin (d + 1) → K) (m j : ℕ) (w : Fin (j + 1) → K)
    (h : ∀ n, n ≤ m + d + j → a n = b n) :
    checkOptimalCertificate a R m j w = checkOptimalCertificate b R m j w := by
  have hc := certificate_congr_prefix a b R m j h
  have hd : DualObstruction a m d j w ↔ DualObstruction b m d j w := by
    simp only [DualObstruction, dualRow_congr_prefix a b m w h]
  simp only [checkOptimalCertificate, hc, hd]

end FunctionFieldLittlewood
