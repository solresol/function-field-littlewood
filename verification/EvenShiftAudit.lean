module

public import FunctionFieldLittlewood.EvenShift
public import FunctionFieldLittlewood.Sharpness

@[expose] public section

#print FunctionFieldLittlewood.EvenShift.Terminal

#check @FunctionFieldLittlewood.EvenShift.geometric_double
#check @FunctionFieldLittlewood.EvenShift.stream_even_forced_factor
#check @FunctionFieldLittlewood.EvenShift.terminal_empty
#check @FunctionFieldLittlewood.EvenShift.geometric_eval_one
#check @FunctionFieldLittlewood.EvenShift.binomial_dvd_of_geometric
#check @FunctionFieldLittlewood.EvenShift.order_cast_ne_zero
#check @FunctionFieldLittlewood.EvenShift.terminal_even_odd_size
#check @FunctionFieldLittlewood.EvenShift.geometric_sync_dvd
#check @FunctionFieldLittlewood.EvenShift.terminal_even_double
#check @FunctionFieldLittlewood.EvenShift.target_iff_terminal
#check @FunctionFieldLittlewood.EvenShift.target_even_double
#check @FunctionFieldLittlewood.EvenShift.target_even_odd_size
#check @FunctionFieldLittlewood.EvenShift.terminal_zero_shift
#check @FunctionFieldLittlewood.EvenShift.terminal_odd_representative
#check @FunctionFieldLittlewood.EvenShift.target_exists_odd_iff

#print axioms FunctionFieldLittlewood.EvenShift.geometric_double
#print axioms FunctionFieldLittlewood.EvenShift.stream_even_forced_factor
#print axioms FunctionFieldLittlewood.EvenShift.terminal_empty
#print axioms FunctionFieldLittlewood.EvenShift.geometric_eval_one
#print axioms FunctionFieldLittlewood.EvenShift.binomial_dvd_of_geometric
#print axioms FunctionFieldLittlewood.EvenShift.order_cast_ne_zero
#print axioms FunctionFieldLittlewood.EvenShift.terminal_even_odd_size
#print axioms FunctionFieldLittlewood.EvenShift.geometric_sync_dvd
#print axioms FunctionFieldLittlewood.EvenShift.terminal_even_double
#print axioms FunctionFieldLittlewood.EvenShift.target_iff_terminal
#print axioms FunctionFieldLittlewood.EvenShift.target_even_double
#print axioms FunctionFieldLittlewood.EvenShift.target_even_odd_size
#print axioms FunctionFieldLittlewood.EvenShift.terminal_zero_shift
#print axioms FunctionFieldLittlewood.EvenShift.terminal_odd_representative
#print axioms FunctionFieldLittlewood.EvenShift.target_exists_odd_iff

open scoped BigOperators
open Matrix Polynomial FunctionFieldLittlewood FunctionFieldLittlewood.EvenShift

private def z3 : Fin 2 → ZMod 3 := ![1, 2]

-- Retained r=1 example: raw target at shift 1, size 2. No new witness search.
private theorem target3 : CorrelatedState.relation (laiSprangStream 3 1) z3
    2 2 2 0 (TargetPreimage.target z3) := by
  refine ⟨![2, 2], ?_, ?_⟩
  · rw [← laiSprangFast_eq]
    decide +kernel
  · ext i
    fin_cases i <;> norm_num [mulVec, dotProduct, Fin.sum_univ_two,
      BoundaryRelation.evalMatrix, transpose_apply, TargetPreimage.target, z3,
      show (2 : ZMod 3) ≠ 1 by decide] <;> decide

-- Both directions use actual matrices and the m+1 start, not a finite stream prefix.
private theorem doubled3 : CorrelatedState.relation (laiSprangStream 3 1) z3
    3 4 4 0 (TargetPreimage.target z3) := by
  exact (target_even_double (p := 3) (r := 0) (k := 0) (by decide)
    (by decide) z3 (by decide) (by decide) 1 2).mpr target3

example : CorrelatedState.relation (laiSprangStream 3 1) z3
    2 2 2 0 (TargetPreimage.target z3) := by
  exact (target_even_double (p := 3) (r := 0) (k := 0) (by decide)
    (by decide) z3 (by decide) (by decide) 1 2).mp doubled3

-- Odd size at even shift, empty square, and every size at shift zero.
example (m n : ℕ) : ¬ CorrelatedState.relation (laiSprangStream 3 1) z3
    (2 * m + 1) (2 * n + 1) (2 * n + 1) 0 (TargetPreimage.target z3) := by
  exact target_even_odd_size (p := 3) (r := 0) (k := 0) (by decide)
    (by decide) z3 (by decide) (by decide) m n

example (m : ℕ) : ¬ CorrelatedState.relation (laiSprangStream 3 1) z3
    (m + 1) 0 0 0 (TargetPreimage.target z3) := by
  rw [target_iff_terminal (p := 3) (r := 0) (k := 0) (by decide)
    (by decide) z3 (by decide) (by decide)]
  exact terminal_empty 3 0 m

example (n : ℕ) : ¬ Terminal 3 0 0 n :=
  terminal_zero_shift (p := 3) (r := 0) (k := 0) (by decide) (by decide) n

-- The geometric factor is essential: P=1 has its sole required row zero
-- at even shift 2 over F_5, despite size 1 being odd.
example : fractionalCoeff (laiSprangStream 5 2) (![1] : Fin 1 → ZMod 5) 2 1 = 0 := by
  rw [← laiSprangFast_eq]
  decide +kernel

-- Do not weaken maximal two-primary order to mere divisibility: -1 is square here.
example : IsSquare (-1 : ZMod 5) := ⟨2, by decide⟩

#print axioms target3
#print axioms doubled3
