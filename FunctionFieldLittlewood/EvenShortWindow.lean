module

public import FunctionFieldLittlewood.TerminalDetection

@[expose] public section

/-!
The even-shift short-window lemma needed for the rank-four simultaneous
corner transport of 4 November. A binomial multiple of degree at most 2q+1
cannot have 2q zero rows at an even shift. The missing row is justified by
the equal parity budgets; no assertion at odd shifts is made.
-/
namespace FunctionFieldLittlewood.EvenShortWindow
open scoped BigOperators
open Polynomial Matrix WindowMoments ParentWindow ParityDescent DescentStep
  BinomialNonvanishing TerminalDetection

/-- At an even shift, one fewer than degree-many rows suffice in odd degree.
The full two-primary order is required. Lean r=0 includes valuation r=1. -/
theorem stream_even_short_window {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (R : (ZMod p)[X]) (hfactor : (X ^ (2 * 2 ^ r) - 1) ∣ R)
    (n q : ℕ) (hdeg : R.natDegree ≤ 2 * q + 1)
    (hw : ∀ j, 1 ≤ j → j ≤ 2 * q →
      filt R (laiSprangStream p (r + 1)) (2 * n + j) = 0) : R = 0 := by
  by_contra hR
  by_cases hlow : R.natDegree ≤ 2 * q
  · obtain ⟨j, hj, hjd, hjne⟩ := stream_binomial_nonvanishing hp horder R hR hfactor (2 * n)
    exact hjne (hw j hj (hjd.trans hlow))
  have hdeg : R.natDegree = 2 * q + 1 := by omega
  let g : (ZMod p)[X] := X ^ (2 ^ r) - 1
  have hg : g ≠ 0 := by
    simpa [g] using X_pow_sub_C_ne_zero (by positivity : 0 < 2 ^ r) (1 : ZMod p)
  have hgdeg : g.natDegree = 2 ^ r := by
    simp only [g, ← C_1, natDegree_X_pow_sub_C]
  have hexpand : expand (ZMod p) 2 g = X ^ (2 * 2 ^ r) - 1 := by
    simp [g, ← pow_mul]
  obtain ⟨U, hU⟩ := hfactor
  rw [← hexpand] at hU
  let E := g * evenPart U
  let O := g * oddPart U
  have hsplit : R = expand (ZMod p) 2 E + X * expand (ZMod p) 2 O :=
    hU.trans (factored_parity_split g U)
  have hquot := quotient_degree_bounds g (evenPart U) (oddPart U) hg q 1 (by decide)
    (hsplit ▸ hdeg)
  have hrows := parent_windows R E O _ (laiSprangStream_even p (r + 1))
    hsplit q 0 n 0 0 (by decide) (by decide) (by simpa using hw)
  have hpdiv : 2 ^ (r + 1) ∣ p - 1 := by
    refine ⟨2 * k + 1, ?_⟩
    simpa [pow_succ, Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using horder
  obtain ⟨z, hz, hr, _, ha⟩ := RootStream.stream_root_enumeration hpdiv
  have hm := windows_moments (laiSprangStream p (r + 1)) z g
    (evenPart U) (oddPart U) n 0 q q
    (by intro h; have hb := hquot.2 h; rw [hgdeg] at hb; omega)
    (by intro h; have hb := hquot.1 h; rw [hgdeg] at hb; omega)
    (by simpa only [Nat.add_zero, Nat.zero_mul, ha] using hrows.1)
    (by simpa only [Nat.add_zero, Nat.zero_mul, ha] using hrows.2)
  have hf := prime_parity_binomial_dvd hp (by positivity : 0 < 2 ^ r) horder
    z hz hr g (evenPart U) (oddPart U) n
    (by
      intro i hi
      have : Fact (2 < p) := ⟨hp⟩
      simp only [g, eval_sub, eval_pow, eval_X, eval_one, hr i] at hi
      exact ZMod.neg_one_ne_one (sub_eq_zero.mp hi))
    (by simpa using hm)
  have hE' := mul_dvd_mul_left g hf.1
  have hO' := mul_dvd_mul_left g hf.2
  have hO : (X ^ (2 * 2 ^ r) - 1) ∣ O := by
    simpa only [g, binomial_product] using hO'
  have hzE := odd_filter_zero hpdiv E ((dvd_mul_left _ g).trans hE')
  have hlead := leading_child R E O hR hsplit q 1 (by decide) hdeg
  simp only [Nat.one_ne_zero, ↓reduceIte] at hlead
  obtain ⟨j, hj, hjd, hjne⟩ := stream_binomial_nonvanishing hp horder O hlead.1 hO n
  apply hjne
  have h := hrows.2 (j - 1) (by rw [hlead.2] at hjd; omega)
  rw [hzE, add_zero] at h
  convert h using 1; congr 1; omega

/-- The two-column-wider parent used by the simultaneous conic has no
invisible coefficient vector. Singular and empty Hankel blocks are included. -/
theorem stream_even_no_invisible {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (z : Fin (2 * 2 ^ r) → ZMod p) (hi : Function.Injective z)
    (hz : ∀ i, z i ^ (2 * 2 ^ r) = 1) (n q : ℕ)
    (x : Fin (2 * q + 1 + 1) → ZMod p)
    (hrows : BoundaryRelation.block (laiSprangStream p (r + 1))
      (2 * n + 1) (2 * q) (2 * q + 1 + 1) *ᵥ x = 0)
    (heval : (BoundaryRelation.evalMatrix z (2 * q + 1 + 1))ᵀ *ᵥ x = 0) : x = 0 := by
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
  have hP := stream_even_short_window hp horder P hf n q
    (natDegree_le_iff_coeff_eq_zero.mpr (multiplierPolynomial_coeff_above x)) (by
      intro j hj hjd
      have h := congrFun hrows ⟨j - 1, by omega⟩
      simp only [Pi.zero_apply, mulVec, dotProduct, BoundaryRelation.block] at h
      rw [filt_multiplier]
      convert h using 1
      apply Finset.sum_congr rfl
      intro i _
      rw [show 2 * n + 1 + (j - 1) + i.val = 2 * n + j + i.val by omega, mul_comm])
  ext i
  have h := congrArg (fun Q : (ZMod p)[X] => Q.coeff i.val) hP
  simpa only [P, multiplierPolynomial_coeff, coeff_zero, Pi.zero_apply] using h

end FunctionFieldLittlewood.EvenShortWindow
