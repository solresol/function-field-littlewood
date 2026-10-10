module

public import FunctionFieldLittlewood.WindowMoments
public import Mathlib.Algebra.Polynomial.Expand

@[expose] public section

/-! Actual parent rows give the finite parity windows used in the descent.
The argument follows the parity split in Lai--Sprang Section 3, with the
factor-aware row counts of results/2026-10-02-parity-descent.md. -/
namespace FunctionFieldLittlewood.ParentWindow
open Polynomial WindowMoments
variable {K : Type*} [Field K]

/-- Canonical even and odd coefficient polynomials; no endpoint assumption. -/
noncomputable def evenPart (R : K[X]) : K[X] := contract 2 R
noncomputable def oddPart (R : K[X]) : K[X] := contract 2 R.divX

@[simp] theorem coeff_evenPart (R : K[X]) (i : ℕ) :
    (evenPart R).coeff i = R.coeff (2 * i) := by
  simp [evenPart, coeff_contract, Nat.mul_comm]

@[simp] theorem coeff_oddPart (R : K[X]) (i : ℕ) :
    (oddPart R).coeff i = R.coeff (2 * i + 1) := by
  simp [oddPart, coeff_contract, coeff_divX, Nat.mul_comm]

theorem parity_split (R : K[X]) :
    R = expand K 2 (evenPart R) + X * expand K 2 (oddPart R) := by
  ext i
  rcases Nat.even_or_odd i with ⟨j, rfl⟩ | ⟨j, rfl⟩
  · cases j with
    | zero => simp [coeff_expand]
    | succ j =>
      rw [coeff_add, show j + 1 + (j + 1) = (2 * j + 1) + 1 by omega,
        coeff_X_mul]
      simp [coeff_expand, show ¬ 2 ∣ 2 * j + 1 by omega]
      congr 1; omega
  · rw [coeff_add, coeff_X_mul]
    simp [coeff_expand, show ¬ 2 ∣ 2 * j + 1 by omega]

/-- Filtering a substituted polynomial simply doubles its coefficient indices. -/
theorem filt_expand (P : K[X]) (a : ℕ → K) (v : ℕ) :
    filt (expand K 2 P) a v = filt P (fun i => a (v + 2 * i)) 0 := by
  induction P using Polynomial.induction_on' with
  | add P Q hP hQ => simp [map_add, hP, hQ]
  | monomial i c => simp [expand_monomial, Nat.mul_comm]

theorem filt_X_mul (P : K[X]) (a : ℕ → K) (v : ℕ) :
    filt (X * P) a v = filt P a (v + 1) := by
  rw [filt_mul, ← monomial_one_one_eq_X, filt_monomial, one_mul]

theorem filt_parity_even (E O : K[X]) (a : ℕ → K)
    (ha : ∀ v, a (2 * v) = a v) (v : ℕ) :
    filt (expand K 2 E + X * expand K 2 O) a (2 * v) =
      filt E a v + filt O (fun i => a (2 * i + 1)) v := by
  rw [filt_add, filt_X_mul, filt_expand, filt_expand]
  simp only [filt, Polynomial.sum_def, Nat.zero_add]
  congr 1
  · apply Finset.sum_congr rfl
    intro i _
    rw [show 2 * v + 2 * i = 2 * (v + i) by omega, ha]
  · apply Finset.sum_congr rfl
    intro i _
    rw [show 2 * v + 1 + 2 * i = 2 * (v + i) + 1 by omega]

theorem filt_parity_odd (E O : K[X]) (a : ℕ → K)
    (ha : ∀ v, a (2 * v) = a v) (v : ℕ) :
    filt (expand K 2 E + X * expand K 2 O) a (2 * v + 1) =
      filt O a (v + 1) + filt E (fun i => a (2 * i + 1)) v := by
  rw [filt_add, filt_X_mul, filt_expand, filt_expand, add_comm]
  simp only [filt, Polynomial.sum_def, Nat.zero_add]
  congr 1
  · apply Finset.sum_congr rfl
    intro i _
    rw [show 2 * v + 1 + 1 + 2 * i = 2 * (v + 1 + i) by omega, ha]
  · apply Finset.sum_congr rfl
    intro i _
    rw [show 2 * v + 1 + 2 * i = 2 * (v + i) + 1 by omega]

/-- Exact extraction from a parent window of 2q+epsilon+2s rows.
Both degree and shift parities are included, as are zero components and n=0. -/
theorem parent_windows (R E O : K[X]) (a : ℕ → K)
    (ha : ∀ v, a (2 * v) = a v)
    (hR : R = expand K 2 E + X * expand K 2 O)
    (q s n epsilon delta : ℕ) (he : epsilon ≤ 1) (hd : delta ≤ 1)
    (hw : ∀ k, 1 ≤ k → k ≤ 2 * q + epsilon + 2 * s →
      filt R a (2 * n + delta + k) = 0) :
    (∀ l, l < q + s + epsilon * delta →
      filt E a (n + l + 1) +
        filt O (fun i => a (2 * i + 1)) (n + l + 1) = 0) ∧
    (∀ l, l < q + s + epsilon * (1 - delta) →
      filt O a (n + delta + l + 1) +
        filt E (fun i => a (2 * i + 1)) (n + delta + l) = 0) := by
  constructor
  · intro l hl
    have h := hw (2 * l + 2 - delta) (by omega) (by
      interval_cases epsilon <;> interval_cases delta <;> simp_all <;> omega)
    rw [hR, show 2 * n + delta + (2 * l + 2 - delta) =
      2 * (n + l + 1) by omega, filt_parity_even E O a ha] at h
    exact h
  · intro l hl
    have h := hw (2 * l + delta + 1) (by omega) (by
      interval_cases epsilon <;> interval_cases delta <;> simp_all <;> omega)
    rw [hR, show 2 * n + delta + (2 * l + delta + 1) =
      2 * (n + delta + l) + 1 by omega, filt_parity_odd E O a ha] at h
    exact h

/-- A common expanded factor passes to both canonical parity components. -/
theorem factored_parity_split (g U : K[X]) :
    expand K 2 g * U = expand K 2 (g * evenPart U) +
      X * expand K 2 (g * oddPart U) := by
  conv_lhs => rw [parity_split U]
  simp only [map_mul]
  ring

theorem split_coeff_even (E O : K[X]) (i : ℕ) :
    (expand K 2 E + X * expand K 2 O).coeff (2 * i) = E.coeff i := by
  cases i with
  | zero => simp [coeff_expand]
  | succ i =>
    rw [coeff_add, show 2 * (i + 1) = (2 * i + 1) + 1 by omega, coeff_X_mul]
    simp [coeff_expand, show ¬ 2 ∣ 2 * i + 1 by omega]
    congr 1; omega

theorem split_coeff_odd (E O : K[X]) (i : ℕ) :
    (expand K 2 E + X * expand K 2 O).coeff (2 * i + 1) = O.coeff i := by
  rw [coeff_add, coeff_X_mul]
  simp [coeff_expand, show ¬ 2 ∣ 2 * i + 1 by omega]

/-- Degree bounds are obtained from the actual parent's coefficients.
Only a nonzero component is assigned a degree bound. -/
theorem split_degree_bounds (R E O : K[X])
    (hR : R = expand K 2 E + X * expand K 2 O) :
    (E ≠ 0 → 2 * E.natDegree ≤ R.natDegree) ∧
    (O ≠ 0 → 2 * O.natDegree + 1 ≤ R.natDegree) := by
  constructor
  · intro hE
    apply le_natDegree_of_ne_zero
    rw [hR, split_coeff_even]
    simpa only [coeff_natDegree] using leadingCoeff_ne_zero.mpr hE
  · intro hO
    apply le_natDegree_of_ne_zero
    rw [hR, split_coeff_odd]
    simpa only [coeff_natDegree] using leadingCoeff_ne_zero.mpr hO

/-- Quotient degree bounds needed by the finite convolution, derived rather
than assumed; g is nonzero and h is its exact degree. -/
theorem quotient_degree_bounds (g U₀ U₁ : K[X]) (hg : g ≠ 0)
    (q epsilon : ℕ) (he : epsilon ≤ 1)
    (hdeg : (expand K 2 (g * U₀) + X * expand K 2 (g * U₁)).natDegree =
      2 * q + epsilon) :
    (U₀ ≠ 0 → U₀.natDegree + g.natDegree ≤ q) ∧
    (U₁ ≠ 0 → U₁.natDegree + g.natDegree + 1 ≤ q + epsilon) := by
  have h := split_degree_bounds _ (g * U₀) (g * U₁) rfl
  constructor
  · intro hU
    have hb := h.1 (mul_ne_zero hg hU)
    rw [hdeg, natDegree_mul hg hU] at hb
    omega
  · intro hU
    have hb := h.2 (mul_ne_zero hg hU)
    rw [hdeg, natDegree_mul hg hU] at hb
    omega

/-- The parent's expanded common factor is precisely F_(2s). -/
theorem factorQuotient_expand (H s : ℕ) :
    expand K 2 (ParityDescent.factorQuotient K H s) =
      ParityDescent.factorQuotient K (2 * H) (2 * s) := by
  simp only [ParityDescent.factorQuotient, map_sum, map_pow, expand_X,
    Nat.mul_div_mul_left _ _ (by decide : 0 < 2), ← pow_mul]
  apply Finset.sum_congr rfl
  intro i _
  rw [Nat.mul_assoc]

/-- The geometric quotient has its expected degree, including s=H. -/
theorem factorQuotient_degree {H s : ℕ} (hH : 0 < H) (hs : s ∣ H) :
    ParityDescent.factorQuotient K H s ≠ 0 ∧
      (ParityDescent.factorQuotient K H s).natDegree + s = H := by
  have hspos : 0 < s := Nat.pos_of_dvd_of_pos hs hH
  have hprod := ParityDescent.factorQuotient_mul (K := K) hs
  have hright : (X ^ H - 1 : K[X]) ≠ 0 := by
    simpa using X_pow_sub_C_ne_zero hH (1 : K)
  have hleft : (X ^ s - 1 : K[X]) ≠ 0 := by
    simpa using X_pow_sub_C_ne_zero hspos (1 : K)
  have hg : ParityDescent.factorQuotient K H s ≠ 0 := by
    intro hz
    rw [hz, zero_mul] at hprod
    exact hright hprod.symm
  refine ⟨hg, ?_⟩
  have hd := congrArg Polynomial.natDegree hprod
  rw [natDegree_mul hg hleft] at hd
  simpa only [← C_1, natDegree_X_pow_sub_C] using hd

/-- A factored parent window forces the next factor in both canonical children.
No parity-row, quotient-degree or root-moment hypothesis is assumed.
The Lean r is one less than v₂(p-1); the parent surplus is 2s. -/
theorem stream_parent_forced_factor {p r k s : ℕ} [Fact p.Prime] (hp : 2 < p)
    (hs : s ∣ 2 ^ r) (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (U : (ZMod p)[X]) (q n epsilon delta : ℕ)
    (he : epsilon ≤ 1) (hd : delta ≤ 1)
    (hdeg : (expand (ZMod p) 2 (ParityDescent.factorQuotient (ZMod p) (2 ^ r) s)
      * U).natDegree = 2 * q + epsilon)
    (hw : ∀ j, 1 ≤ j → j ≤ 2 * q + epsilon + 2 * s →
      filt (expand (ZMod p) 2 (ParityDescent.factorQuotient (ZMod p) (2 ^ r) s) * U)
        (laiSprangStream p (r + 1)) (2 * n + delta + j) = 0) :
    (ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * (X ^ (2 ^ r) + 1)) ∣
      ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * evenPart U ∧
    (ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * (X ^ (2 ^ r) + 1)) ∣
      ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * oddPart U := by
  let g := ParityDescent.factorQuotient (ZMod p) (2 ^ r) s
  have hg := factorQuotient_degree (K := ZMod p) (by positivity : 0 < 2 ^ r) hs
  have hsplit := factored_parity_split g U
  have hquot := quotient_degree_bounds g (evenPart U) (oddPart U) hg.1 q epsilon he
    (hsplit ▸ hdeg)
  have hrows := parent_windows _ (g * evenPart U) (g * oddPart U)
    (laiSprangStream p (r + 1)) (laiSprangStream_even p (r + 1))
    hsplit q s n epsilon delta he hd hw
  apply WindowMoments.stream_windows_forced_factor hp hs horder
    (evenPart U) (oddPart U) n delta
    (q + s + epsilon * delta) (q + s + epsilon * (1 - delta))
  · intro hU
    have hb := hquot.2 hU
    have hgdeg : g.natDegree + s = 2 ^ r := hg.2
    interval_cases epsilon <;> interval_cases delta <;> simp_all <;> omega
  · intro hU
    have hb := hquot.1 hU
    have hgdeg : g.natDegree + s = 2 ^ r := hg.2
    omega
  · exact hrows.1
  · exact hrows.2

#print axioms parity_split
#print axioms parent_windows
#print axioms quotient_degree_bounds
#print axioms factorQuotient_degree
#print axioms factorQuotient_expand
#print axioms stream_parent_forced_factor

end FunctionFieldLittlewood.ParentWindow
