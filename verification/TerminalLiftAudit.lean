import FunctionFieldLittlewood.TerminalLift
import FunctionFieldLittlewood.Sharpness

#check @FunctionFieldLittlewood.TerminalLift.odd_filter_of_dvd
#check @FunctionFieldLittlewood.TerminalLift.geometric_eval_zero
#check @FunctionFieldLittlewood.TerminalLift.geometric_dyadic_odd_rows
#check @FunctionFieldLittlewood.TerminalLift.geometric_dyadic_rows
#check @FunctionFieldLittlewood.TerminalLift.coefficients
#check @FunctionFieldLittlewood.TerminalLift.coefficients_reconstruct
#check @FunctionFieldLittlewood.TerminalLift.fractionalCoeff_coefficients
#check @FunctionFieldLittlewood.TerminalLift.certificate_dyadic
#check @FunctionFieldLittlewood.TerminalLift.terminal_product

#print axioms FunctionFieldLittlewood.TerminalLift.odd_filter_of_dvd
#print axioms FunctionFieldLittlewood.TerminalLift.geometric_eval_zero
#print axioms FunctionFieldLittlewood.TerminalLift.geometric_dyadic_odd_rows
#print axioms FunctionFieldLittlewood.TerminalLift.geometric_dyadic_rows
#print axioms FunctionFieldLittlewood.TerminalLift.coefficients
#print axioms FunctionFieldLittlewood.TerminalLift.coefficients_reconstruct
#print axioms FunctionFieldLittlewood.TerminalLift.fractionalCoeff_coefficients
#print axioms FunctionFieldLittlewood.TerminalLift.certificate_dyadic
#print axioms FunctionFieldLittlewood.TerminalLift.terminal_product

open scoped BigOperators
open FunctionFieldLittlewood FunctionFieldLittlewood.TerminalLift Polynomial

-- The usual valuation-r=1 comparison is included: F=1+X at shift 1.
example : polynomialLittlewoodProduct (laiSprangStream 3 1)
    (X ^ 2 * expand (ZMod 3) 2 (X + 1)) = (2 : ℝ) ^ (-4 : ℤ) := by
  have hf : ParityDescent.factorQuotient (ZMod 3) 2 1 ∣ (X + 1 : (ZMod 3)[X]) := by
    have he : ParityDescent.factorQuotient (ZMod 3) 2 1 = X + 1 := by
      norm_num [ParityDescent.factorQuotient, Finset.sum_range_succ, add_comm]
    rw [he]
  have hc : ExactCertificate (laiSprangStream 3 1) (coefficients (X + 1)) 1
      ((X + 1 : (ZMod 3)[X]).natDegree + 2) := by
    have hdeg : (X + 1 : (ZMod 3)[X]).natDegree = 1 := by
      simpa only [C_1] using (natDegree_X_add_C (1 : ZMod 3))
    rw [← laiSprangFast_eq]
    have control (d : ℕ) (hd : d = 1) :
        ExactCertificate (laiSprangFast 3 1)
          (fun i : Fin (d + 1) => (X + 1 : (ZMod 3)[X]).coeff i.val) 1 (d + 2) := by
      subst d
      simp only [coeff_add, coeff_X, coeff_one]
      decide +kernel
    exact control _ hdeg
  simpa using terminal_product (r := 0) (by decide) (X + 1) hf 1 hc

-- Absolute row zero and s=0 are included, without a nonzero P hypothesis.
example : WindowMoments.filt (expand (ZMod 5) 1 0) (laiSprangStream 5 2) 0 = 0 := by
  simp [WindowMoments.filt]

-- First forbidden scale for F_5, N=4: the odd row of F(X^8) is 3, not 0.
-- Independent kernel evaluation of the original stream, not the lift identity.
example : (∑ i : Fin 4, laiSprangStream 5 2 (1 + 8 * i.val)) = 3 := by
  rw [← laiSprangFast_eq]
  decide +kernel

-- Omitting part of F fails even at the permitted final scale N.
example : laiSprangStream 5 2 1 + laiSprangStream 5 2 9 = 4 := by
  rw [← laiSprangFast_eq]
  decide +kernel

-- No geometric factor: the odd row of 1(X^2) is nonzero.
example : laiSprangStream 5 2 1 ≠ 0 := by
  rw [← laiSprangFast_eq]
  decide +kernel
