module

public import FunctionFieldLittlewood.EvenShortWindow
public import FunctionFieldLittlewood.Sharpness

@[expose] public section

#check @FunctionFieldLittlewood.EvenShortWindow.stream_even_short_window
#check @FunctionFieldLittlewood.EvenShortWindow.stream_even_no_invisible
#print axioms FunctionFieldLittlewood.EvenShortWindow.stream_even_short_window
#print axioms FunctionFieldLittlewood.EvenShortWindow.stream_even_no_invisible

open scoped BigOperators
open FunctionFieldLittlewood FunctionFieldLittlewood.EvenShortWindow Polynomial Matrix WindowMoments

namespace FunctionFieldLittlewood.EvenShortWindowAudit

def z3 : Fin 2 → ZMod 3 := ![1, 2]

-- The empty Hankel block is allowed: root evaluation alone is injective.
theorem empty3 (x : Fin 2 → ZMod 3)
    (hv : (BoundaryRelation.evalMatrix z3 2)ᵀ *ᵥ x = 0) : x = 0 := by
  exact stream_even_no_invisible (p := 3) (r := 0) (k := 0)
    (by decide) (by decide) z3 (by decide) (by decide) 0 0 x (by ext i; exact Fin.elim0 i) hv

-- The square Hankel block at t=3,size=4 is singular, yet the wider
-- Hankel/evaluation stack is injective. No square inverse is assumed.
theorem singular3 (x : Fin 6 → ZMod 3)
    (ha : BoundaryRelation.block (laiSprangStream 3 1) 3 4 6 *ᵥ x = 0)
    (hv : (BoundaryRelation.evalMatrix z3 6)ᵀ *ᵥ x = 0) :
    (BoundaryRelation.block (laiSprangStream 3 1) 3 4 4).det = 0 ∧ x = 0 := by
  constructor
  · rw [← laiSprangFast_eq]
    decide +kernel
  · exact stream_even_no_invisible (p := 3) (r := 0) (k := 0)
      (by decide) (by decide) z3 (by decide) (by decide) 1 2 x ha hv

-- A distinct valuation at the previously prescribed p=5,q=62,k=8
-- simultaneous-response parent (t=127,16 rows,18 columns).
example (x : Fin 18 → ZMod 5)
    (ha : BoundaryRelation.block (laiSprangStream 5 2) 127 16 18 *ᵥ x = 0)
    (hv : (BoundaryRelation.evalMatrix (fun i : Fin 4 => (i.val + 1 : ZMod 5)) 18)ᵀ *ᵥ x = 0) :
    x = 0 := by
  exact stream_even_no_invisible (p := 5) (r := 1) (k := 0)
    (by decide) (by decide) _ (by decide) (by decide) 63 8 x ha hv

-- The degree budget cannot be enlarged by one, even for the actual stream.
-- (X²-1)(X²+X+1) has degree four and two zero rows at shift zero over F_3.
theorem extra_column_fails :
    ∃ R : (ZMod 3)[X], R ≠ 0 ∧ (X ^ 2 - 1) ∣ R ∧ R.natDegree = 4 ∧
      (∀ j, 1 ≤ j → j ≤ 2 → filt R (laiSprangStream 3 1) j = 0) := by
  let R : (ZMod 3)[X] := (X ^ 2 - 1) * (X ^ 2 + X + 1)
  have hx : (X ^ 2 - 1 : (ZMod 3)[X]) ≠ 0 := by
    simpa using X_pow_sub_C_ne_zero (by decide : 0 < 2) (1 : ZMod 3)
  have hdA : (X ^ 2 + X : (ZMod 3)[X]).natDegree = 2 := by
    rw [natDegree_add_eq_left_of_natDegree_lt (by simp), natDegree_X_pow]
  have hdB : (X ^ 2 + X + 1 : (ZMod 3)[X]).natDegree = 2 := by
    rw [natDegree_add_eq_left_of_natDegree_lt (by rw [hdA]; simp), hdA]
  have hB : (X ^ 2 + X + 1 : (ZMod 3)[X]) ≠ 0 := by
    intro h
    simp [h] at hdB
  refine ⟨R, mul_ne_zero hx hB, dvd_mul_right _ _, ?_, ?_⟩
  · dsimp [R]
    rw [natDegree_mul hx hB, hdB]
    have hdX : (X ^ 2 - 1 : (ZMod 3)[X]).natDegree = 2 := by
      simpa only [C_1] using (natDegree_X_pow_sub_C (n := 2) (r := (1 : ZMod 3)))
    omega
  · intro j hj hjd
    have hR : R = monomial 4 1 + monomial 3 1 + monomial 1 (-1) + monomial 0 (-1) := by
      simp only [R, monomial_one_right_eq_X_pow, map_neg]
      ring
    rw [hR]
    simp only [filt_add, filt_monomial]
    interval_cases j <;> rw [← laiSprangFast_eq] <;> decide +kernel

#print axioms empty3
#print axioms singular3
#print axioms extra_column_fails

end FunctionFieldLittlewood.EvenShortWindowAudit
