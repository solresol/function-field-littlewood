module

public import FunctionFieldLittlewood.FastCertificate

@[expose] public section

/-!
Kernel-checked sharpness witnesses for further N=4 primes, via the
natural-number certificate checker of FastCertificate.lean. Each terminal
coefficient list S and stream window W is data from
results/2026-10-17-sharpness.json or results/2026-10-18-sharpness-p61.json;
the window is proved equal to the computed support stream. Row checks are
split into blocks of 100 rows so that each kernel evaluation stays small.
-/

namespace FunctionFieldLittlewood

set_option maxRecDepth 200000

instance factPrime29 : Fact (Nat.Prime 29) := ⟨by decide⟩

/-- Terminal coefficients S=(1+t+t^2+t^3)V, degree 329, at shift 2501. -/
def sharp29S : List ℕ :=
  [16, 21, 21, 28, 9, 6, 26, 13, 5, 25, 8, 26, 8, 17, 28, 2, 13, 28, 0, 5, 14, 14, 4, 15,
    17, 27, 15, 11, 11, 17, 4, 10, 5, 3, 5, 15, 16, 14, 3, 4, 17, 22, 0, 4, 4, 19, 13, 3,
    26, 28, 23, 11, 18, 10, 23, 28, 20, 23, 23, 7, 11, 25, 7, 3, 7, 23, 19, 5, 17, 11, 13, 17,
    9, 9, 15, 15, 18, 1, 13, 4, 7, 27, 13, 6, 25, 20, 10, 0, 6, 16, 22, 14, 4, 8, 18, 3,
    20, 13, 20, 26, 15, 4, 14, 6, 0, 14, 4, 15, 14, 12, 17, 13, 28, 16, 1, 26, 21, 6, 25, 11,
    10, 2, 20, 10, 9, 16, 28, 6, 26, 9, 6, 25, 2, 16, 17, 12, 5, 20, 22, 4, 28, 14, 27, 6,
    1, 26, 26, 7, 7, 26, 16, 14, 24, 5, 0, 17, 26, 28, 3, 25, 6, 23, 6, 8, 14, 23, 25, 8,
    12, 6, 8, 26, 24, 5, 21, 23, 1, 4, 8, 12, 24, 2, 27, 23, 0, 10, 17, 1, 13, 15, 26, 3,
    5, 1, 25, 2, 14, 21, 27, 24, 16, 9, 25, 16, 24, 22, 8, 1, 18, 27, 25, 7, 8, 5, 22, 17,
    6, 6, 27, 16, 13, 24, 8, 22, 10, 8, 16, 19, 28, 10, 27, 7, 18, 19, 24, 13, 22, 6, 23, 4,
    24, 17, 2, 17, 27, 24, 26, 17, 19, 17, 7, 7, 16, 23, 1, 12, 15, 26, 0, 5, 20, 23, 27, 10,
    8, 17, 26, 11, 5, 18, 25, 15, 28, 0, 15, 17, 8, 27, 12, 12, 24, 17, 25, 8, 18, 22, 22, 15,
    1, 2, 21, 13, 11, 1, 28, 28, 16, 0, 28, 23, 13, 25, 11, 6, 21, 20, 8, 27, 22, 7, 25, 8,
    15, 22, 13, 2, 21, 17, 22, 0, 15, 8, 20, 22, 26, 0, 6, 19, 4, 1]

/-- The support stream at indices 2501+1, ..., 2501+660. -/
def sharp29W : List ℕ :=
  [0, 0, 2, 2, 27, 0, 0, 27, 0, 0, 27, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27,
    0, 0, 0, 2, 2, 0, 2, 27, 0, 0, 27, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 27, 27,
    0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 27, 2, 2, 0, 2, 27, 0, 0, 2, 2, 27, 0, 0, 27,
    0, 0, 2, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 2, 2, 2, 0, 2, 27,
    0, 0, 27, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27,
    0, 0, 2, 2, 2, 0, 2, 27, 0, 0, 2, 2, 27, 0, 0, 27, 0, 0, 27, 2, 2, 0, 27, 27,
    0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 2, 27, 0, 0, 27, 2, 27, 0, 0, 27,
    0, 0, 0, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 27, 2, 2, 0, 2, 27,
    0, 0, 2, 2, 27, 0, 0, 27, 0, 0, 2, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27,
    0, 0, 27, 2, 2, 0, 2, 27, 0, 0, 27, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 27, 27,
    0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 2, 27, 0, 0, 2, 2, 27, 0, 0, 27,
    0, 0, 27, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 2, 27,
    0, 0, 27, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27,
    0, 0, 0, 2, 2, 0, 2, 27, 0, 0, 2, 2, 27, 0, 0, 27, 0, 0, 2, 2, 2, 0, 27, 27,
    0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 2, 2, 2, 0, 2, 27, 0, 0, 27, 2, 27, 0, 0, 27,
    0, 0, 0, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 27, 2, 2, 0, 2, 27,
    0, 0, 2, 2, 27, 0, 0, 27, 0, 0, 27, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27,
    0, 0, 0, 2, 2, 0, 2, 27, 0, 0, 27, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 27, 27,
    0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 2, 27, 0, 0, 2, 2, 27, 0, 0, 27,
    0, 0, 2, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 27, 2, 2, 0, 2, 27,
    0, 0, 27, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27,
    0, 0, 0, 2, 2, 0, 2, 27, 0, 0, 2, 2, 27, 0, 0, 27, 0, 0, 27, 2, 2, 0, 27, 27,
    0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 2, 27, 0, 0, 27, 2, 27, 0, 0, 27,
    0, 0, 0, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 2, 27,
    0, 0, 2, 2, 27, 0, 0, 27, 0, 0, 2, 2, 2, 0, 27, 27, 0, 0, 0, 2, 27, 0, 0, 27,
    0, 0, 2, 2, 2, 0, 2, 27, 0, 0, 27, 2, 27, 0, 0, 27, 0, 0, 0, 2, 2, 0, 27, 27,
    0, 0, 0, 2, 27, 0, 0, 27, 0, 0, 2, 2, 2, 0, 2, 27, 0, 0, 2, 2, 27, 0, 0, 27,
    0, 0, 27, 2, 2, 0, 27, 27, 0, 0, 0, 2]

theorem sharp29_window :
    sharp29W = (List.range (2 * 329 + 2)).map (fun j => lsNat 29 2 (2501 + 1 + j)) := by
  decide +kernel

theorem sharp29_rows_0 : ∀ k < 100, dotNat sharp29S (sharp29W.drop (0 + k)) % 29 = 0 := by
  decide +kernel

theorem sharp29_rows_1 : ∀ k < 100, dotNat sharp29S (sharp29W.drop (100 + k)) % 29 = 0 := by
  decide +kernel

theorem sharp29_rows_2 : ∀ k < 100, dotNat sharp29S (sharp29W.drop (200 + k)) % 29 = 0 := by
  decide +kernel

theorem sharp29_rows_3 : ∀ k < 30, dotNat sharp29S (sharp29W.drop (300 + k)) % 29 = 0 := by
  decide +kernel

theorem sharp29_rows : ∀ k < 329 + 1, dotNat sharp29S (sharp29W.drop k) % 29 = 0 := by
  intro k hk
  have h := (forall_lt_concat (P := (fun k => dotNat sharp29S (sharp29W.drop k) % 29 = 0)) (a := 0) sharp29_rows_0
      (forall_lt_concat (P := (fun k => dotNat sharp29S (sharp29W.drop k) % 29 = 0)) (a := 100) sharp29_rows_1
      (forall_lt_concat (P := (fun k => dotNat sharp29S (sharp29W.drop k) % 29 = 0)) (a := 200) sharp29_rows_2
      sharp29_rows_3))) k (by omega)
  simpa using h

theorem sharp29_odd_0 :
    dotNat sharp29S ((List.range (329 + 1)).map (fun i => lsNat 29 2 (2 * (0 + i) + 1))) % 29 = 0 := by
  decide +kernel

theorem sharp29_odd_1 :
    dotNat sharp29S ((List.range (329 + 1)).map (fun i => lsNat 29 2 (2 * (1 + i) + 1))) % 29 = 0 := by
  decide +kernel

theorem sharp29_odd_2 :
    dotNat sharp29S ((List.range (329 + 1)).map (fun i => lsNat 29 2 (2 * (2 + i) + 1))) % 29 = 0 := by
  decide +kernel

theorem sharp29_odd_3 :
    dotNat sharp29S ((List.range (329 + 1)).map (fun i => lsNat 29 2 (2 * (3 + i) + 1))) % 29 = 0 := by
  decide +kernel

theorem sharp29_odd : ∀ u < 4, dotNat sharp29S ((List.range (329 + 1)).map
    (fun i => lsNat 29 2 (2 * (u + i) + 1))) % 29 = 0 := by
  intro u hu
  rcases (by omega : u = 0 ∨ u = 1 ∨ u = 2 ∨ u = 3) with rfl | rfl | rfl | rfl
  · exact sharp29_odd_0
  · exact sharp29_odd_1
  · exact sharp29_odd_2
  · exact sharp29_odd_3

theorem sharp29_odd2_0 :
    dotNat sharp29S ((List.range (329 + 1)).map (fun i => lsNat 29 2 (2 * (0 + 2 * i) + 1))) % 29 = 0 := by
  decide +kernel

theorem sharp29_odd2_1 :
    dotNat sharp29S ((List.range (329 + 1)).map (fun i => lsNat 29 2 (2 * (1 + 2 * i) + 1))) % 29 = 0 := by
  decide +kernel

theorem sharp29_odd2_2 :
    dotNat sharp29S ((List.range (329 + 1)).map (fun i => lsNat 29 2 (2 * (2 + 2 * i) + 1))) % 29 = 0 := by
  decide +kernel

theorem sharp29_odd2_3 :
    dotNat sharp29S ((List.range (329 + 1)).map (fun i => lsNat 29 2 (2 * (3 + 2 * i) + 1))) % 29 = 0 := by
  decide +kernel

theorem sharp29_odd2 : ∀ u < 4, dotNat sharp29S ((List.range (329 + 1)).map
    (fun i => lsNat 29 2 (2 * (u + 2 * i) + 1))) % 29 = 0 := by
  intro u hu
  rcases (by omega : u = 0 ∨ u = 1 ∨ u = 2 ∨ u = 3) with rfl | rfl | rfl | rfl
  · exact sharp29_odd2_0
  · exact sharp29_odd2_1
  · exact sharp29_odd2_2
  · exact sharp29_odd2_3

noncomputable section

/-- The lift S(t^4) at shift 10004: Littlewood product 2^-8 < 2^-4 over F_29. -/
theorem sharp29_polynomial_product :
    polynomialLittlewoodProduct (laiSprangStream 29 2)
      (Polynomial.X ^ (2 * (2 * 2501)) * multiplierPolynomial
        (liftTwo (liftTwo (fun i : Fin (329 + 1) => ((sharp29S.getD i 0 : ℕ) : ZMod 29))))) =
      (2 : ℝ) ^ (-8 : ℤ) :=
  product_of_checks 29 2501 329 sharp29S sharp29W (by decide +kernel) sharp29_window
    (by decide +kernel) (by decide +kernel) sharp29_rows (by decide +kernel)
    sharp29_odd sharp29_odd2

theorem sharp29_refutes_N_bound :
    polynomialLittlewoodProduct (laiSprangStream 29 2)
      (Polynomial.X ^ (2 * (2 * 2501)) * multiplierPolynomial
        (liftTwo (liftTwo (fun i : Fin (329 + 1) => ((sharp29S.getD i 0 : ℕ) : ZMod 29))))) <
      (2 : ℝ) ^ (-(4 : ℤ)) := by
  rw [sharp29_polynomial_product]
  exact zpow_lt_zpow_right₀ (by norm_num) (by norm_num)

end

#print axioms sharp29_polynomial_product
#print axioms sharp29_refutes_N_bound

end FunctionFieldLittlewood
