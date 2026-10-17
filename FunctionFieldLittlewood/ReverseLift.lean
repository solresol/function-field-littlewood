module

public import FunctionFieldLittlewood.Sharpness

@[expose] public section

/-!
The reverse lift of the 5 October report in certificate form. For any stream
with a(2n)=a(n), doubling the exponents of a multiplier doubles its shift and
its exact first index, provided the odd rows vanish. For the named support
stream the odd coefficients a(2u+1) are periodic in u with period 2^r, so the
odd-row condition at every shift reduces to finitely many residues.

As an application, the p=13 terminal witness of quotient degree 76 lifts to a
degree-316 multiplier at shift 5860 with exact index 324: product 2^-8 < 2^-4.
The terminal certificate (81 rows) and the odd-row residues are decided by the
kernel; the lifted 323-row certificate is derived, not evaluated.
-/

namespace FunctionFieldLittlewood

variable {K : Type*} [CommRing K]

/-- R(t) ↦ R(t^2) as a coefficient vector. -/
def liftTwo {d : ℕ} (R : Fin (d + 1) → K) : Fin (2 * d + 1) → K :=
  fun i => if i.val % 2 = 0 then R ⟨i.val / 2, by omega⟩ else 0

/-- j ↦ 2j as an embedding of coefficient positions. -/
def doubleEmb (d : ℕ) : Fin (d + 1) ↪ Fin (2 * d + 1) :=
  ⟨fun j => ⟨2 * j.val, by omega⟩, by
    intro x y h
    simp only [Fin.mk.injEq] at h
    ext
    omega⟩

/-- The lifted row is the original sum at doubled indices. -/
theorem fractionalCoeff_liftTwo {d : ℕ} (a : ℕ → K) (R : Fin (d + 1) → K) (m k : ℕ) :
    fractionalCoeff a (liftTwo R) (2 * m) k = ∑ i : Fin (d + 1), R i * a (2 * m + 2 * i.val + k) := by
  classical
  unfold fractionalCoeff
  symm
  calc ∑ i : Fin (d + 1), R i * a (2 * m + 2 * i.val + k)
      = ∑ i : Fin (d + 1), liftTwo R (doubleEmb d i) *
          a (2 * m + (doubleEmb d i).val + k) := by
        apply Finset.sum_congr rfl
        intro i _
        have hR : liftTwo R (doubleEmb d i) = R i := by
          simp only [liftTwo, doubleEmb, Function.Embedding.coeFn_mk, Nat.mul_mod_right, ite_true]
          congr 1
          ext
          simp
        rw [hR]
        rfl
    _ = ∑ i ∈ Finset.univ.map (doubleEmb d), liftTwo R i * a (2 * m + i.val + k) := by
        rw [Finset.sum_map]
    _ = ∑ i, liftTwo R i * a (2 * m + i.val + k) := by
        apply Finset.sum_subset (Finset.subset_univ _)
        intro i _ hi
        have hodd : i.val % 2 = 1 := by
          by_contra hc
          apply hi
          simp only [Finset.mem_map, Finset.mem_univ, true_and]
          refine ⟨⟨i.val / 2, by omega⟩, ?_⟩
          ext
          simp only [doubleEmb, Function.Embedding.coeFn_mk]
          omega
        simp [liftTwo, hodd]

/-- Exact certificates double when the odd rows vanish at every shift. -/
theorem certificate_liftTwo {d : ℕ} (a : ℕ → K) (R : Fin (d + 1) → K) (m j : ℕ)
    (heven : ∀ n, a (2 * n) = a n)
    (hodd : ∀ w, ∑ i : Fin (d + 1), R i * a (2 * (w + i.val) + 1) = 0)
    (h : ExactCertificate a R m j) : ExactCertificate a (liftTwo R) (2 * m) (2 * j) := by
  obtain ⟨hj, h0, hd, hrows, hlast⟩ := h
  have row (k : ℕ) : fractionalCoeff a (liftTwo R) (2 * m) k =
      if k % 2 = 0 then fractionalCoeff a R m (k / 2) else 0 := by
    rw [fractionalCoeff_liftTwo]
    split_ifs with hk
    · unfold fractionalCoeff
      apply Finset.sum_congr rfl
      intro i _
      rw [show 2 * m + 2 * i.val + k = 2 * (m + i.val + k / 2) by omega, heven]
    · have := hodd (m + k / 2)
      rw [← this]
      apply Finset.sum_congr rfl
      intro i _
      rw [show 2 * m + 2 * i.val + k = 2 * (m + k / 2 + i.val) + 1 by omega]
  refine ⟨by omega, ?_, ?_, ?_, ?_⟩
  · simpa [liftTwo] using h0
  · have : (Fin.last (2 * d)).val % 2 = 0 := by simp
    simp only [liftTwo, this, ite_true]
    convert hd using 2
    ext
    simp
  · intro r
    rw [row]
    split_ifs with hr
    · have hlt : (r.val + 1) / 2 - 1 < j - 1 := by have := r.isLt; omega
      have := hrows ⟨(r.val + 1) / 2 - 1, hlt⟩
      simpa [show (r.val + 1) / 2 - 1 + 1 = (r.val + 1) / 2 by omega] using this
    · rfl
  · rw [row]
    simpa [Nat.mul_div_cancel_left j (by norm_num : 0 < 2)] using hlast

/-- Odd support coefficients are periodic: a(2(u+2^r)+1)=a(2u+1). -/
theorem laiSprangStream_odd_period (p r u : ℕ) :
    laiSprangStream p r (2 * (u + 2 ^ r) + 1) = laiSprangStream p r (2 * u + 1) := by
  have hpos : 0 < 2 ^ r := Nat.two_pow_pos r
  unfold laiSprangStream
  rw [oddCore_odd, oddCore_odd]
  have hmod : (2 * (u + 2 ^ r) + 1 - 1) % 2 ^ r = (2 * u + 1 - 1) % 2 ^ r := by
    rw [Nat.add_sub_cancel, Nat.add_sub_cancel, show 2 * (u + 2 ^ r) = 2 * u + 2 * 2 ^ r by ring,
      Nat.add_mul_mod_self_right]
  have hdiv : (2 * (u + 2 ^ r) + 1 - 1) / 2 ^ r = (2 * u + 1 - 1) / 2 ^ r + 2 := by
    rw [Nat.add_sub_cancel, Nat.add_sub_cancel, show 2 * (u + 2 ^ r) = 2 * u + 2 * 2 ^ r by ring,
      Nat.add_mul_div_right _ _ hpos]
  simp only [hmod, hdiv, pow_add, neg_one_sq, mul_one, Nat.add_one_ne_zero, ite_false]

/-- A shift-periodic family of sums vanishes everywhere if it vanishes on one period. -/
theorem forall_of_periodic {g : ℕ → K} (P : ℕ) (hP : 0 < P) (hper : ∀ w, g (w + P) = g w)
    (hbase : ∀ w < P, g w = 0) : ∀ w, g w = 0 := by
  intro w
  induction w using Nat.strong_induction_on with
  | _ w ih =>
    by_cases hw : w < P
    · exact hbase w hw
    · obtain ⟨v, rfl⟩ : ∃ v, w = v + P := ⟨w - P, by omega⟩
      rw [hper]
      exact ih v (by omega)

/-- For the named stream, odd-row vanishing at all shifts reduces to w < 2^r. -/
theorem stream_odd_rows {d : ℕ} (p r : ℕ) (R : Fin (d + 1) → ZMod p)
    (hbase : ∀ w < 2 ^ r, ∑ i : Fin (d + 1), R i * laiSprangStream p r (2 * (w + i.val) + 1) = 0) :
    ∀ w, ∑ i : Fin (d + 1), R i * laiSprangStream p r (2 * (w + i.val) + 1) = 0 := by
  apply forall_of_periodic (2 ^ r) (Nat.two_pow_pos r) _ hbase
  intro w
  apply Finset.sum_congr rfl
  intro i _
  rw [show w + 2 ^ r + i.val = (w + i.val) + 2 ^ r by ring, laiSprangStream_odd_period]

/-! The p=13 witness: S=(1+t+t^2+t^3)V, deg V=76, at the odd shift 1465. -/

def sharp13Terminal (i : Fin 80) : ZMod 13 :=
  ([7, 7, 7, 5, 5, 5, 6, 6, 2, 2, 3, 9, 4, 4, 0, 7, 2, 2, 1, 10, 7, 7, 3, 11, 11, 11, 10, 0, 4,
    4, 9, 4, 9, 9, 11, 7, 4, 4, 10, 7, 12, 12, 7, 1, 9, 9, 1, 0, 11, 11, 0, 11, 9, 9, 12, 8, 5,
    5, 6, 12, 9, 9, 5, 10, 0, 0, 0, 12, 8, 8, 10, 9, 10, 10, 11, 2, 4, 4, 7, 1] : List (ZMod 13)).getD i.val 0

theorem sharp13Terminal_certificate :
    ExactCertificate (laiSprangStream 13 2) sharp13Terminal 1465 81 := by
  rw [← laiSprangFast_eq]
  decide +kernel

theorem sharp13_odd_rows :
    ∀ w, ∑ i : Fin 80, sharp13Terminal i * laiSprangStream 13 2 (2 * (w + i.val) + 1) = 0 := by
  apply stream_odd_rows
  rw [← laiSprangFast_eq]
  decide +kernel

theorem sharp13_odd_rows_two :
    ∀ w, ∑ i : Fin (2 * 79 + 1), liftTwo sharp13Terminal i *
      laiSprangStream 13 2 (2 * (w + i.val) + 1) = 0 := by
  apply stream_odd_rows
  rw [← laiSprangFast_eq]
  decide +kernel

/-- The reverse lift S(t^4) at shift 4*1465 has exact index 4*81. -/
theorem sharp13Lift_certificate :
    ExactCertificate (laiSprangStream 13 2) (liftTwo (liftTwo sharp13Terminal))
      (2 * (2 * 1465)) (2 * (2 * 81)) := by
  apply certificate_liftTwo _ _ _ _ (laiSprangStream_even 13 2) sharp13_odd_rows_two
  exact certificate_liftTwo _ _ _ _ (laiSprangStream_even 13 2) sharp13_odd_rows
    sharp13Terminal_certificate

instance : Fact (Nat.Prime 13) := ⟨by decide⟩

noncomputable section

theorem sharp13_polynomial_product :
    polynomialLittlewoodProduct (laiSprangStream 13 2)
      (Polynomial.X ^ (2 * (2 * 1465)) * multiplierPolynomial (liftTwo (liftTwo sharp13Terminal))) =
        (2 : ℝ) ^ (-8 : ℤ) := by
  rw [certificate_polynomialLittlewoodProduct _ _ _ _ sharp13Lift_certificate]
  norm_num

theorem sharp13_refutes_N_bound :
    polynomialLittlewoodProduct (laiSprangStream 13 2)
      (Polynomial.X ^ (2 * (2 * 1465)) * multiplierPolynomial (liftTwo (liftTwo sharp13Terminal))) <
        (2 : ℝ) ^ (-(4 : ℤ)) := by
  rw [sharp13_polynomial_product]
  exact zpow_lt_zpow_right₀ (by norm_num) (by norm_num)

end

#print axioms doubleEmb
#print axioms fractionalCoeff_liftTwo
#print axioms certificate_liftTwo
#print axioms laiSprangStream_odd_period
#print axioms stream_odd_rows
#print axioms sharp13Terminal_certificate
#print axioms sharp13_odd_rows
#print axioms sharp13_odd_rows_two
#print axioms sharp13Lift_certificate
#print axioms sharp13_polynomial_product
#print axioms sharp13_refutes_N_bound

end FunctionFieldLittlewood
