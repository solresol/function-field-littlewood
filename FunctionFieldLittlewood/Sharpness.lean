module

public import FunctionFieldLittlewood.FractionalPart
public import FunctionFieldLittlewood.LaiSprangStream

@[expose] public section

/-!
The Lai--Sprang constant 2N is attained over F_5 (N=4). A degree-44
multiplier at shift 1244 has exact first fractional index 52 for the infinite
named support stream, so its base-two Littlewood product is 2^-8 < 2^-4.
This refutes the sharper auxiliary bound j-d <= N for p=5.

The multiplier is the reverse lift R(t)=S(t^4) of the terminal witness
S=(1+t+t^2+t^3)(2+t+t^2+t^3+3t^4+3t^5+t^6+t^7+t^8) at shift 311, found and
independently read back by search/lai_sprang_sharpness.py. The kernel checks
both exact certificates below directly; neither the lift lemma nor the search
is trusted. Minimality of degree 44 is an ordinary argument, not formalised.
-/

namespace FunctionFieldLittlewood

/-- Structurally recursive odd part, which the kernel can evaluate. -/
def oddCoreFuel : ℕ → ℕ → ℕ
  | 0, n => n
  | fuel + 1, n => if n = 0 then 0 else if n % 2 = 0 then oddCoreFuel fuel (n / 2) else n

theorem oddCoreFuel_eq (fuel n : ℕ) (h : n ≤ fuel) : oddCoreFuel fuel n = oddCore n := by
  induction fuel generalizing n with
  | zero =>
    obtain rfl : n = 0 := by omega
    simp [oddCoreFuel]
  | succ fuel ih =>
    rw [oddCoreFuel, oddCore]
    by_cases hn : n = 0
    · simp [hn]
    · by_cases he : n % 2 = 0
      · simp only [hn, he, ite_false, ite_true, dite_false]
        exact ih _ (by omega)
      · simp [hn, he]

/-- The support stream with a kernel-evaluable odd part and sign. -/
def laiSprangFast (p r n : ℕ) : ZMod p :=
  if n = 0 then 0
  else if (oddCoreFuel n n - 1) % (2 ^ r) = 0 then
    ((2 ^ r / 2 : ℕ) : ZMod p) * (-1) ^ ((oddCoreFuel n n - 1) / (2 ^ r) % 2)
  else 0

theorem laiSprangFast_eq (p r : ℕ) : laiSprangFast p r = laiSprangStream p r := by
  funext n
  simp only [laiSprangFast, laiSprangStream, oddCoreFuel_eq n n le_rfl,
    ← neg_one_pow_eq_pow_mod_two]

/-- Terminal witness S=(1+t+t^2+t^3)V over F_5, degree 11. -/
def sharp5Terminal (i : Fin 12) : ZMod 5 :=
  ([2, 3, 4, 0, 1, 3, 3, 3, 1, 3, 2, 1] : List (ZMod 5)).getD i.val 0

/-- The quotient V of degree eight. -/
def sharp5Quotient (i : Fin 9) : ZMod 5 :=
  ([2, 1, 1, 1, 3, 3, 1, 1, 1] : List (ZMod 5)).getD i.val 0

/-- S is exactly the product (1+t+t^2+t^3)V, coefficient by coefficient. -/
theorem sharp5Terminal_factor :
    ∀ k : Fin 12, sharp5Terminal k =
      ∑ i : Fin 9, if i.val ≤ k.val ∧ k.val ≤ i.val + 3 then sharp5Quotient i else 0 := by
  decide

/-- The first deg S+1=12 rows vanish at shift 311; row 13 does not. -/
theorem sharp5Terminal_certificate :
    ExactCertificate (laiSprangStream 5 2) sharp5Terminal 311 13 := by
  rw [← laiSprangFast_eq]
  decide +kernel

/-- The reverse lift R(t)=S(t^4), degree 44. -/
def sharp5Lift (i : Fin 45) : ZMod 5 :=
  if i.val % 4 = 0 then sharp5Terminal ⟨i.val / 4, by omega⟩ else 0

/-- Exact first index 52 at shift 1244: defect 52-44=8=2N. -/
theorem sharp5Lift_certificate :
    ExactCertificate (laiSprangStream 5 2) sharp5Lift 1244 52 := by
  rw [← laiSprangFast_eq]
  decide +kernel

theorem sharp5Lift_first :
    FirstNonzero (laiSprangStream 5 2) sharp5Lift 1244 52 :=
  certificate_sound _ _ _ _ sharp5Lift_certificate

instance : Fact (Nat.Prime 5) := ⟨by decide⟩

noncomputable section

/-- The actual polynomial Littlewood product of Q=t^1244 R equals 2^-8. -/
theorem sharp5_polynomial_product :
    polynomialLittlewoodProduct (laiSprangStream 5 2)
      (Polynomial.X ^ 1244 * multiplierPolynomial sharp5Lift) =
        (2 : ℝ) ^ (-8 : ℤ) := by
  simpa using certificate_polynomialLittlewoodProduct _ _ _ _ sharp5Lift_certificate

/-- The sharper auxiliary bound 2^-N, N=4, fails over F_5. -/
theorem sharp5_refutes_N_bound :
    polynomialLittlewoodProduct (laiSprangStream 5 2)
      (Polynomial.X ^ 1244 * multiplierPolynomial sharp5Lift) <
        (2 : ℝ) ^ (-(4 : ℤ)) := by
  rw [sharp5_polynomial_product]
  exact zpow_lt_zpow_right₀ (by norm_num) (by norm_num)

/-- Equivalently, no nonzero row appears among the first d+N=48 rows. -/
theorem sharp5_no_row_within_N :
    ¬ ∃ k : ℕ, 0 < k ∧ k ≤ 44 + 4 ∧ fractionalCoeff (laiSprangStream 5 2) sharp5Lift 1244 k ≠ 0 := by
  rintro ⟨k, hk, hkN, hne⟩
  exact hne (sharp5Lift_first.2.2 k hk (by omega))

end

#print axioms oddCoreFuel_eq
#print axioms laiSprangFast_eq
#print axioms sharp5Terminal_factor
#print axioms sharp5Terminal_certificate
#print axioms sharp5Lift_certificate
#print axioms sharp5_polynomial_product
#print axioms sharp5_refutes_N_bound
#print axioms sharp5_no_row_within_N

end FunctionFieldLittlewood
