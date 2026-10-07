module

public import FunctionFieldLittlewood.BridgeExamples

@[expose] public section

/-!
The support-formula coefficient stream used by the exact Python experiments.
For its Lai--Sprang interpretation, p is an odd prime and r = v_2(p-1).
The definition is total for all parameters; no interpretation is asserted for
other parameters. Identification with the original infinite root-sum Laurent
series and the Laurent norm bridge remain separate obligations. The generic
coefficient bridge is proved separately in LaurentBridge.lean.
-/

namespace FunctionFieldLittlewood

/-- Remove factors of two, with the total convention oddCore 0 = 0. -/
def oddCore (n : ℕ) : ℕ :=
  if h : n = 0 then 0
  else if n % 2 = 0 then oddCore (n / 2) else n
termination_by n
decreasing_by exact Nat.div_lt_self (Nat.pos_of_ne_zero h) (by decide)

@[simp] theorem oddCore_zero : oddCore 0 = 0 := by rw [oddCore]; simp

theorem oddCore_even (n : ℕ) : oddCore (2 * n) = oddCore n := by
  by_cases hn : n = 0
  · simp [hn]
  · rw [oddCore]
    simp [hn]

theorem oddCore_odd (n : ℕ) : oddCore (2 * n + 1) = 2 * n + 1 := by
  rw [oddCore]
  simp [Nat.add_mod]

/-- This proves the odd-part convention for every binary valuation and odd part. -/
theorem oddCore_dyadic (k h : ℕ) :
    oddCore (2 ^ k * (2 * h + 1)) = 2 * h + 1 := by
  induction k with
  | zero => simpa using oddCore_odd h
  | succ k ih =>
    rw [pow_succ, Nat.mul_comm (2 ^ k) 2, Nat.mul_assoc, oddCore_even, ih]

/-- N=2^r support formula, with a_0=0. Positive indices match the search's
`coeff(p,n)` when r=v_2(p-1); no infinite root-sum equality is assumed. -/
def laiSprangStream (p r n : ℕ) : ZMod p :=
  if n = 0 then 0
  else if (oddCore n - 1) % (2 ^ r) = 0 then
    ((2 ^ r / 2 : ℕ) : ZMod p) * (-1) ^ ((oddCore n - 1) / (2 ^ r))
  else 0

@[simp] theorem laiSprangStream_zero (p r : ℕ) : laiSprangStream p r 0 = 0 := by
  simp [laiSprangStream]

theorem laiSprangStream_even (p r n : ℕ) :
    laiSprangStream p r (2 * n) = laiSprangStream p r n := by
  simp [laiSprangStream, oddCore_even]

theorem laiSprangStream_dyadic (p r k n : ℕ) :
    laiSprangStream p r (2 ^ k * n) = laiSprangStream p r n := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [pow_succ, Nat.mul_comm (2 ^ k) 2, Nat.mul_assoc, laiSprangStream_even, ih]

set_option maxRecDepth 10000
set_option maxHeartbeats 2000000

theorem laiSprang17_saved_prefix :
    ∀ n, n ≤ 32 → Saved.laiSprang17Prefix n = laiSprangStream 17 4 n := by
  have h : ∀ n : Fin 33,
      Saved.laiSprang17Prefix n.val = laiSprangStream 17 4 n.val := by
    intro n
    fin_cases n <;> norm_num [Saved.laiSprang17Prefix, laiSprangStream, oddCore]
    all_goals decide
  intro n hn
  exact h ⟨n, by omega⟩

theorem laiSprang17_named_accepted :
    checkOptimalCertificate (laiSprangStream 17 4) Saved.laiSprang17R 17 15
      Saved.laiSprang17Weights = true := by
  rw [← checkOptimalCertificate_congr_prefix Saved.laiSprang17Prefix
    (laiSprangStream 17 4) Saved.laiSprang17R 17 15
    Saved.laiSprang17Weights laiSprang17_saved_prefix]
  exact Saved.laiSprang17_accepted

theorem laiSprang17_named_optimal :
    FirstNonzero (laiSprangStream 17 4) Saved.laiSprang17R 17 15 ∧
      ∀ S : Fin 1 → ZMod 17, S 0 ≠ 0 → S (Fin.last 0) ≠ 0 →
        ∃ k : ℕ, 0 < k ∧ k ≤ 15 ∧ fractionalCoeff (laiSprangStream 17 4) S 17 k ≠ 0 :=
  checkOptimalCertificate_sound_all _ _ _ _ _ laiSprang17_named_accepted

/-- The later degree-zero sharpness witness, on the infinite support stream. -/
theorem laiSprang17_sharp_certificate :
    ExactCertificate (laiSprangStream 17 4) (fun _ : Fin 1 => 1) 81 16 := by
  refine ⟨by decide, by decide, by decide, ?_, ?_⟩
  · intro row
    fin_cases row <;> norm_num [fractionalCoeff, laiSprangStream, oddCore]
  · norm_num [fractionalCoeff, laiSprangStream, oddCore]
    decide

theorem laiSprang17_sharp_first :
    FirstNonzero (laiSprangStream 17 4) (fun _ : Fin 1 => 1) 81 16 :=
  certificate_sound _ _ _ _ laiSprang17_sharp_certificate

/-- Preserve the r=1 comparison on a named stream, not a zero-padded fixture. -/
theorem laiSprang3_comparison_certificate :
    ExactCertificate (laiSprangStream 3 1) comparisonMultiplier 2 6 := by
  refine ⟨by decide, by decide, by decide, ?_, ?_⟩
  · intro row
    fin_cases row <;>
      simp only [fractionalCoeff, Fin.sum_univ_succ, Fin.sum_univ_zero] <;>
      norm_num [comparisonMultiplier, laiSprangStream, oddCore]
  · simp only [fractionalCoeff, Fin.sum_univ_succ, Fin.sum_univ_zero]
    norm_num [comparisonMultiplier, laiSprangStream, oddCore]
    decide

theorem laiSprang3_comparison_first :
    FirstNonzero (laiSprangStream 3 1) comparisonMultiplier 2 6 :=
  certificate_sound _ _ _ _ laiSprang3_comparison_certificate

-- The zero-padded prefix is not the infinite stream; the terminal index matters.
example : Saved.laiSprang17Prefix 33 ≠ laiSprangStream 17 4 33 := by
  norm_num [Saved.laiSprang17Prefix, laiSprangStream, oddCore]
  decide
example : fractionalCoeff (laiSprangStream 17 4) (fun _ : Fin 1 => 1) 81 15 = 0 := by
  norm_num [fractionalCoeff, laiSprangStream, oddCore]
example : fractionalCoeff (laiSprangStream 17 4) (fun _ : Fin 1 => 1) 81 16 ≠ 0 := by
  norm_num [fractionalCoeff, laiSprangStream, oddCore]
  decide

#print axioms oddCore_dyadic
#print axioms laiSprangStream_dyadic
#print axioms laiSprang17_saved_prefix
#print axioms laiSprang17_named_accepted
#print axioms laiSprang17_named_optimal
#print axioms laiSprang17_sharp_certificate
#print axioms laiSprang17_sharp_first
#print axioms laiSprang3_comparison_certificate
#print axioms laiSprang3_comparison_first

end FunctionFieldLittlewood
