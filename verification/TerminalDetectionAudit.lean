import FunctionFieldLittlewood.TerminalDetection
import FunctionFieldLittlewood.Sharpness

#check @FunctionFieldLittlewood.BinomialNonvanishing.binomial_product
#check @FunctionFieldLittlewood.BinomialNonvanishing.stream_binomial_descent
#check @FunctionFieldLittlewood.BinomialNonvanishing.stream_binomial_nonvanishing
#check @FunctionFieldLittlewood.TerminalDetection.filt_difference
#check @FunctionFieldLittlewood.TerminalDetection.stream_geometric_nonvanishing
#check @FunctionFieldLittlewood.TerminalDetection.geometric_constant
#check @FunctionFieldLittlewood.TerminalDetection.stream_terminal_certificate
#check @FunctionFieldLittlewood.TerminalDetection.unity_root_product
#check @FunctionFieldLittlewood.TerminalDetection.geometric_dvd_of_evaluations
#check @FunctionFieldLittlewood.TerminalDetection.multiplier_eval
#check @FunctionFieldLittlewood.TerminalDetection.filt_multiplier
#check @FunctionFieldLittlewood.TerminalDetection.target_exact_certificate
#check @FunctionFieldLittlewood.TerminalDetection.target_sharp_product
#check @FunctionFieldLittlewood.TerminalDetection.stream_no_invisible

#print axioms FunctionFieldLittlewood.BinomialNonvanishing.binomial_product
#print axioms FunctionFieldLittlewood.BinomialNonvanishing.stream_binomial_descent
#print axioms FunctionFieldLittlewood.BinomialNonvanishing.stream_binomial_nonvanishing
#print axioms FunctionFieldLittlewood.TerminalDetection.filt_difference
#print axioms FunctionFieldLittlewood.TerminalDetection.stream_geometric_nonvanishing
#print axioms FunctionFieldLittlewood.TerminalDetection.geometric_constant
#print axioms FunctionFieldLittlewood.TerminalDetection.stream_terminal_certificate
#print axioms FunctionFieldLittlewood.TerminalDetection.unity_root_product
#print axioms FunctionFieldLittlewood.TerminalDetection.geometric_dvd_of_evaluations
#print axioms FunctionFieldLittlewood.TerminalDetection.multiplier_eval
#print axioms FunctionFieldLittlewood.TerminalDetection.filt_multiplier
#print axioms FunctionFieldLittlewood.TerminalDetection.target_exact_certificate
#print axioms FunctionFieldLittlewood.TerminalDetection.target_sharp_product
#print axioms FunctionFieldLittlewood.TerminalDetection.stream_no_invisible

open scoped BigOperators
open FunctionFieldLittlewood FunctionFieldLittlewood.TerminalDetection
open Matrix Polynomial

private def z3 : Fin 2 → ZMod 3 := ![1, 2]

-- Valuation r=1 (Lean r=0): actual target at shift 1, size 2.
-- This checks raw-stream normalization and the m+1 matrix start index.
private theorem target3 : CorrelatedState.relation (laiSprangStream 3 1) z3
    2 2 2 0 (TargetPreimage.target z3) := by
  refine ⟨![2, 2], ?_, ?_⟩
  · rw [← laiSprangFast_eq]
    decide +kernel
  · ext i
    fin_cases i <;> norm_num [mulVec, dotProduct, Fin.sum_univ_two,
      BoundaryRelation.evalMatrix, transpose_apply, TargetPreimage.target, z3,
      show (2 : ZMod 3) ≠ 1 by decide] <;> decide

example : ∃ P : (ZMod 3)[X], P.natDegree = 1 ∧
    polynomialLittlewoodProduct (laiSprangStream 3 1)
      (X ^ 2 * expand (ZMod 3) 2 P) = (2 : ℝ) ^ (-4 : ℤ) := by
  apply target_sharp_product (p := 3) (r := 0) (k := 0) (by decide)
    (by decide) z3 (by decide) (by decide) 1 1 target3

-- The zero polynomial remains outside the binomial nonvanishing theorem.
example : WindowMoments.filt (0 : (ZMod 3)[X]) (laiSprangStream 3 1) 1 = 0 := by
  simp [WindowMoments.filt]

-- A single-column, zero-row Hankel block is singular. The complete moment
-- equation alone makes its invisible vector zero; no invertibility is assumed.
example (x : Fin 1 → ZMod 3)
    (hv : (BoundaryRelation.evalMatrix z3 1)ᵀ *ᵥ x = 0) : x = 0 := by
  apply stream_no_invisible (p := 3) (r := 0) (k := 0) (by decide)
    (by decide) z3 (by decide) (by decide) 0 0 0 (by decide) x
  · ext i
    exact Fin.elim0 i
  · exact hv

-- The maximal two-primary part is material: -1 is square in F_5.
example : IsSquare (-1 : ZMod 5) := by
  exact ⟨2, by decide⟩

-- Degree-many zero rows occur when the binomial factor is absent: retain
-- the existing p=5 terminal witness, rather than add a new attainment example.
example : ∀ j, 1 ≤ j → j ≤ 11 →
    fractionalCoeff (laiSprangStream 5 2) sharp5Terminal 311 j = 0 := by
  intro j hj hjd
  exact (certificate_sound _ _ _ _ sharp5Terminal_certificate).2.2 j (by omega) (by omega)

-- Removing the full degree+1-row premise is insufficient for an exact
-- terminal certificate: F=1+X at shift zero already has a nonzero first row.
example : fractionalCoeff (laiSprangStream 3 1) (![1, 1] : Fin 2 → ZMod 3) 0 1 ≠ 0 := by
  rw [← laiSprangFast_eq]
  decide +kernel
