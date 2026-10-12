module

public import FunctionFieldLittlewood.ParentWindow

@[expose] public section

/-! Complete factor-aware descent for the Lai--Sprang support stream.
This assembles the ordinary argument of 2 October; it does not settle the
terminal all-degree question. No constant-coefficient assumption is used. -/
namespace FunctionFieldLittlewood.DescentStep
open Polynomial WindowMoments ParentWindow ParityDescent
variable {K : Type*} [Field K]

/-- The next geometric factor, as a polynomial identity without division. -/
theorem factorQuotient_next {H s : ℕ} (hH : 0 < H) (hs : s ∣ H) :
    factorQuotient K H s * (X ^ H + 1) = factorQuotient K (2 * H) s := by
  have hspos := Nat.pos_of_dvd_of_pos hs hH
  apply mul_right_cancel₀ (show (X ^ s - 1 : K[X]) ≠ 0 by
    simpa using X_pow_sub_C_ne_zero hspos (1 : K))
  calc
    (factorQuotient K H s * (X ^ H + 1)) * (X ^ s - 1) =
        (factorQuotient K H s * (X ^ s - 1)) * (X ^ H + 1) := by ring
    _ = (X ^ H - 1) * (X ^ H + 1) := by rw [factorQuotient_mul hs]
    _ = X ^ (2 * H) - 1 := by rw [pow_mul]; ring
    _ = factorQuotient K (2 * H) s * (X ^ s - 1) :=
      (factorQuotient_mul (hs.trans (dvd_mul_left H 2))).symm

/-- Divisibility kills every odd-subsequence filter, even at shift zero. -/
theorem odd_filter_zero {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) (P : (ZMod p)[X])
    (hP : (X ^ (2 ^ r) + 1) ∣ P) (v : ℕ) :
    filt P (fun i => laiSprangStream p (r + 1) (2 * i + 1)) v = 0 := by
  obtain ⟨z, _, hz, _, ha⟩ := RootStream.stream_root_enumeration hd
  simp_rw [ha]
  rw [filt_roots]
  apply Finset.sum_eq_zero
  intro i _
  obtain ⟨Q, rfl⟩ := hP
  simp [hz i]

/-- The parity matching the parent's leading exponent has exact half degree. -/
theorem leading_child (R E O : K[X]) (hR : R ≠ 0)
    (hsplit : R = expand K 2 E + X * expand K 2 O)
    (q epsilon : ℕ) (he : epsilon ≤ 1) (hdeg : R.natDegree = 2 * q + epsilon) :
    (if epsilon = 0 then E else O) ≠ 0 ∧
      (if epsilon = 0 then E else O).natDegree = q := by
  have hc : R.coeff (2 * q + epsilon) ≠ 0 := by
    rw [← hdeg, coeff_natDegree]
    exact leadingCoeff_ne_zero.mpr hR
  have hb := split_degree_bounds R E O hsplit
  interval_cases epsilon
  · simp only [Nat.add_zero] at hdeg hc
    rw [hsplit, split_coeff_even] at hc
    have hn : E ≠ 0 := by intro hz; simp [hz] at hc
    have hlo := le_natDegree_of_ne_zero hc
    have hhi := hb.1 hn
    simp only [↓reduceIte]
    exact ⟨hn, by omega⟩
  · rw [hsplit, split_coeff_odd] at hc
    have hn : O ≠ 0 := by intro hz; simp [hz] at hc
    have hlo := le_natDegree_of_ne_zero hc
    have hhi := hb.2 hn
    simp only [Nat.one_ne_zero, ↓reduceIte]
    exact ⟨hn, by omega⟩

/-- A complete surplus-2s to surplus-s step, including exact child shift.
The parameter r here is one less than v₂(p-1). -/
theorem stream_descent_step {p r k s : ℕ} [Fact p.Prime] (hp : 2 < p)
    (hs : s ∣ 2 ^ r) (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (R : (ZMod p)[X]) (hR : R ≠ 0)
    (hfactor : factorQuotient (ZMod p) (2 * 2 ^ r) (2 * s) ∣ R)
    (q n epsilon delta : ℕ) (he : epsilon ≤ 1) (hd : delta ≤ 1)
    (hdeg : R.natDegree = 2 * q + epsilon)
    (hw : ∀ j, 1 ≤ j → j ≤ R.natDegree + 2 * s →
      filt R (laiSprangStream p (r + 1)) (2 * n + delta + j) = 0) :
    ∃ S : (ZMod p)[X], S ≠ 0 ∧ S.natDegree = q ∧
      factorQuotient (ZMod p) (2 * 2 ^ r) s ∣ S ∧
      ∀ j, 1 ≤ j → j ≤ q + s →
        filt S (laiSprangStream p (r + 1)) (n + epsilon * delta + j) = 0 := by
  obtain ⟨U, hU⟩ := hfactor
  rw [← factorQuotient_expand] at hU
  let g := factorQuotient (ZMod p) (2 ^ r) s
  let E := g * evenPart U
  let O := g * oddPart U
  have hsplit : R = expand (ZMod p) 2 E + X * expand (ZMod p) 2 O :=
    hU.trans (factored_parity_split g U)
  have hf := stream_parent_forced_factor hp hs horder U q n epsilon delta he hd
    (hU ▸ hdeg) (fun j hj hmax => hU ▸ hw j hj (hdeg ▸ hmax))
  have hE : (X ^ (2 ^ r) + 1) ∣ E := (dvd_mul_left _ g).trans hf.1
  have hO : (X ^ (2 ^ r) + 1) ∣ O := (dvd_mul_left _ g).trans hf.2
  have hpdiv : 2 ^ (r + 1) ∣ p - 1 := by
    refine ⟨2 * k + 1, ?_⟩
    simpa [pow_succ, Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using horder
  have hzE := odd_filter_zero hpdiv E hE
  have hzO := odd_filter_zero hpdiv O hO
  have hrows := parent_windows R E O _ (laiSprangStream_even p (r + 1))
    hsplit q s n epsilon delta he hd (fun j hj hm => hw j hj (hdeg ▸ hm))
  have hlead := leading_child R E O hR hsplit q epsilon he hdeg
  refine ⟨if epsilon = 0 then E else O, hlead.1, hlead.2, ?_, ?_⟩
  · rw [← factorQuotient_next (by positivity : 0 < 2 ^ r) hs]
    split_ifs
    · exact hf.1
    · exact hf.2
  · intro j hj hm
    interval_cases epsilon
    · simp only [↓reduceIte, Nat.zero_mul, Nat.add_zero]
      have h := hrows.1 (j - 1) (by omega)
      rw [hzO, add_zero] at h
      convert h using 1; congr 1; omega
    · simp only [Nat.one_ne_zero, ↓reduceIte, Nat.one_mul]
      have h := hrows.2 (j - 1) (by omega)
      rw [hzE, add_zero] at h
      convert h using 1; congr 1; omega

/-- Iterate the complete step down to surplus one. The terminal factor alone
forces the degree threshold; no terminal nonvanishing assertion is assumed. -/
theorem iterated_degree_bound {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (j : ℕ) (hj : j ≤ r + 1) (R : (ZMod p)[X]) (hR : R ≠ 0)
    (hfactor : factorQuotient (ZMod p) (2 * 2 ^ r) (2 ^ j) ∣ R)
    (m : ℕ) (hw : ∀ i, 1 ≤ i → i ≤ R.natDegree + 2 ^ j →
      filt R (laiSprangStream p (r + 1)) (m + i) = 0) :
    2 ^ j * (2 * 2 ^ r - 1) ≤ R.natDegree := by
  induction j generalizing R m with
  | zero =>
    have hg := factorQuotient_degree (K := ZMod p)
      (by positivity : 0 < 2 * 2 ^ r) (one_dvd (2 * 2 ^ r))
    have hb := natDegree_le_of_dvd hfactor hR
    simp only [pow_zero, one_mul] at *
    omega
  | succ j ih =>
    have hs : 2 ^ j ∣ 2 ^ r := pow_dvd_pow 2 (by omega)
    have hpow : 2 ^ (j + 1) = 2 * 2 ^ j := by rw [pow_succ, Nat.mul_comm]
    have hm : 2 * (m / 2) + m % 2 = m := by omega
    obtain ⟨S, hS, hdegS, hfS, hwS⟩ := stream_descent_step hp hs horder R hR
      (hpow ▸ hfactor) (R.natDegree / 2) (m / 2) (R.natDegree % 2) (m % 2)
      (by omega) (by omega) (by omega)
      (by simpa only [hm, ← hpow] using hw)
    have hb := ih (by omega) S hS hfS (m / 2 + R.natDegree % 2 * (m % 2))
      (by simpa only [hdegS] using hwS)
    rw [hdegS] at hb
    rw [hpow, mul_assoc]
    omega

/-- A nonzero polynomial with d+N zero fractional rows must have d≥N(N-1).
This is uniform in every nonnegative shift and requires no endpoint condition.
Here N=2^(r+1); the theorem includes the r=1 valuation comparison (Lean r=0). -/
theorem stream_degree_bound {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (R : (ZMod p)[X]) (hR : R ≠ 0) (m : ℕ)
    (hw : ∀ i, 1 ≤ i → i ≤ R.natDegree + 2 ^ (r + 1) →
      filt R (laiSprangStream p (r + 1)) (m + i) = 0) :
    2 ^ (r + 1) * (2 ^ (r + 1) - 1) ≤ R.natDegree := by
  have hpow : 2 ^ (r + 1) = 2 * 2 ^ r := by rw [pow_succ, Nat.mul_comm]
  have hf : factorQuotient (ZMod p) (2 * 2 ^ r) (2 ^ (r + 1)) = 1 := by
    rw [← hpow, factorQuotient, Nat.div_self (by positivity)]
    simp
  have h := iterated_degree_bound hp horder (r + 1) le_rfl R hR
    (by rw [hf]; exact one_dvd R) m hw
  simpa only [← hpow] using h

/-- The auxiliary bound, in finite nonvanishing form, below the degree cutoff. -/
theorem stream_nonvanishing_below_cutoff {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (R : (ZMod p)[X]) (hR : R ≠ 0) (m : ℕ)
    (hdeg : R.natDegree < 2 ^ (r + 1) * (2 ^ (r + 1) - 1)) :
    ∃ i, 1 ≤ i ∧ i ≤ R.natDegree + 2 ^ (r + 1) ∧
      filt R (laiSprangStream p (r + 1)) (m + i) ≠ 0 := by
  by_contra! h
  exact (not_lt_of_ge (stream_degree_bound hp horder R hR m h)) hdeg

#print axioms stream_descent_step
#print axioms iterated_degree_bound
#print axioms stream_degree_bound
#print axioms stream_nonvanishing_below_cutoff

end FunctionFieldLittlewood.DescentStep
