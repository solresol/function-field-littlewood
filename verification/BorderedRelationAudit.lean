module

public import FunctionFieldLittlewood.BorderedRelation
public import FunctionFieldLittlewood.Sharpness

@[expose] public section

#check @FunctionFieldLittlewood.BorderedRelation.mem_space
#check @FunctionFieldLittlewood.BorderedRelation.wide_preimage_unique
#check @FunctionFieldLittlewood.BorderedRelation.border_defect_exists
#check @FunctionFieldLittlewood.BorderedRelation.tall_eq_inf
#check @FunctionFieldLittlewood.BorderedRelation.wide_eq_sup
#check @FunctionFieldLittlewood.BorderedRelation.adjacent_ne
#check @FunctionFieldLittlewood.BorderedRelation.stream_noInvisible
#check @FunctionFieldLittlewood.BorderedRelation.stream_bordered_reconstruction
#check @FunctionFieldLittlewood.BorderedRelation.stream_tuple_eq_of_squares

#print axioms FunctionFieldLittlewood.BorderedRelation.mem_space
#print axioms FunctionFieldLittlewood.BorderedRelation.wide_preimage_unique
#print axioms FunctionFieldLittlewood.BorderedRelation.border_defect_exists
#print axioms FunctionFieldLittlewood.BorderedRelation.tall_eq_inf
#print axioms FunctionFieldLittlewood.BorderedRelation.wide_eq_sup
#print axioms FunctionFieldLittlewood.BorderedRelation.adjacent_ne
#print axioms FunctionFieldLittlewood.BorderedRelation.stream_noInvisible
#print axioms FunctionFieldLittlewood.BorderedRelation.stream_bordered_reconstruction
#print axioms FunctionFieldLittlewood.BorderedRelation.stream_tuple_eq_of_squares

open scoped BigOperators
open FunctionFieldLittlewood FunctionFieldLittlewood.BorderedRelation Matrix

namespace FunctionFieldLittlewood.BorderedRelationAudit

def z3 : Fin 2 → ZMod 3 := ![1, 2]

-- Empty small square and singular zero-row wide block, at the r=1 boundary.
theorem bordered_empty3 :
    space (laiSprangStream 3 1) z3 1 0 0 ≠ space (laiSprangStream 3 1) z3 1 1 1 ∧
    space (laiSprangStream 3 1) z3 1 0 1 =
      space (laiSprangStream 3 1) z3 1 0 0 ⊔ space (laiSprangStream 3 1) z3 1 1 1 ∧
    space (laiSprangStream 3 1) z3 1 1 0 =
      space (laiSprangStream 3 1) z3 1 0 0 ⊓ space (laiSprangStream 3 1) z3 1 1 1 := by
  exact stream_bordered_reconstruction (p := 3) (r := 0) (l := 0)
    (by decide) (by decide) z3 (by decide) (by decide) 0 0

-- At t=2 the size-two Hankel block is [[1,2],[2,1]], hence singular.
-- The reconstruction still follows from the actual stream theorem.
theorem bordered_singular3 :
    (BoundaryRelation.block (laiSprangStream 3 1) 2 2 2).det = 0 ∧
    space (laiSprangStream 3 1) z3 2 2 3 =
      space (laiSprangStream 3 1) z3 2 2 2 ⊔ space (laiSprangStream 3 1) z3 2 3 3 := by
  constructor
  · rw [← laiSprangFast_eq]
    decide +kernel
  · exact (stream_bordered_reconstruction (p := 3) (r := 0) (l := 0)
      (by decide) (by decide) z3 (by decide) (by decide) 1 2).2.1

-- A different field and valuation: the theorem is not an F_3-only computation.
example : space (laiSprangStream 5 2) (fun i : Fin 4 => (i.val + 1 : ZMod 5)) 63 8 8 ≠
    space (laiSprangStream 5 2) (fun i : Fin 4 => (i.val + 1 : ZMod 5)) 63 9 9 := by
  exact (stream_bordered_reconstruction (p := 5) (r := 1) (l := 0)
    (by decide) (by decide) _ (by decide) (by decide) 62 8).1

-- Dropping the stream/injectivity premise really fails: X^2-1 is invisible
-- for the zero stream at these two roots, and the adjacent squares agree.
theorem zero_stream_invisible : ¬ NoInvisible (fun _ => (0 : ZMod 3)) z3 1 2 := by
  intro hn
  have hh := hn ![2, 0, 1] (by decide +kernel) (by decide +kernel)
  have h0 := congrFun hh 0
  exact (by decide : (2 : ZMod 3) ≠ 0) h0

theorem zero_stream_adjacent_equal :
    space (fun _ => (0 : ZMod 3)) z3 1 2 2 = space (fun _ => (0 : ZMod 3)) z3 1 3 3 := by
  ext ⟨u, v⟩
  change CorrelatedState.relation _ _ _ _ _ u v ↔ CorrelatedState.relation _ _ _ _ _ u v
  have hh : ∀ u v : Fin 2 → ZMod 3,
      CorrelatedState.relation (fun _ => 0) z3 1 2 2 u v ↔
      CorrelatedState.relation (fun _ => 0) z3 1 3 3 u v := by
    unfold CorrelatedState.relation BoundaryRelation.Holds
    decide +kernel
  exact hh u v

#print axioms bordered_empty3
#print axioms bordered_singular3
#print axioms zero_stream_invisible
#print axioms zero_stream_adjacent_equal

end FunctionFieldLittlewood.BorderedRelationAudit
