import FunctionFieldLittlewood.CorrelatedState

#check @FunctionFieldLittlewood.CorrelatedState.half_length
#check @FunctionFieldLittlewood.CorrelatedState.relation_even
#check @FunctionFieldLittlewood.CorrelatedState.relation_odd
#check @FunctionFieldLittlewood.CorrelatedState.tupleStep_tuple
#check @FunctionFieldLittlewood.CorrelatedState.power_phase
#check @FunctionFieldLittlewood.CorrelatedState.tupleStep_phase
#check @FunctionFieldLittlewood.CorrelatedState.finiteState
#check @FunctionFieldLittlewood.CorrelatedState.size_saturation
#check @FunctionFieldLittlewood.CorrelatedState.step_actual
#check @FunctionFieldLittlewood.CorrelatedState.fold_actual
#check @FunctionFieldLittlewood.CorrelatedState.reachable_realized
#check @FunctionFieldLittlewood.CorrelatedState.leading_zero
#check @FunctionFieldLittlewood.CorrelatedState.readPair_surjective
#check @FunctionFieldLittlewood.CorrelatedState.reachable_iff
#check @FunctionFieldLittlewood.CorrelatedState.stream_reachable_iff

#print axioms FunctionFieldLittlewood.CorrelatedState.half_length
#print axioms FunctionFieldLittlewood.CorrelatedState.relation_even
#print axioms FunctionFieldLittlewood.CorrelatedState.relation_odd
#print axioms FunctionFieldLittlewood.CorrelatedState.tupleStep_tuple
#print axioms FunctionFieldLittlewood.CorrelatedState.power_phase
#print axioms FunctionFieldLittlewood.CorrelatedState.tupleStep_phase
#print axioms FunctionFieldLittlewood.CorrelatedState.finiteState
#print axioms FunctionFieldLittlewood.CorrelatedState.size_saturation
#print axioms FunctionFieldLittlewood.CorrelatedState.step_actual
#print axioms FunctionFieldLittlewood.CorrelatedState.fold_actual
#print axioms FunctionFieldLittlewood.CorrelatedState.reachable_realized
#print axioms FunctionFieldLittlewood.CorrelatedState.leading_zero
#print axioms FunctionFieldLittlewood.CorrelatedState.readPair_surjective
#print axioms FunctionFieldLittlewood.CorrelatedState.reachable_iff
#print axioms FunctionFieldLittlewood.CorrelatedState.stream_reachable_iff

open FunctionFieldLittlewood FunctionFieldLittlewood.CorrelatedState

-- Exact small endpoint controls; no finite search is used as a theorem.
example : (half 0 0 0).val = 0 ∧ (half 0 0 1).val = 0 ∧
    (half 1 1 0).val = 1 ∧ (half 1 1 1).val = 1 := by decide

-- The known p=5 pair (311,12), padded to nine paired bits, is encoded MSB first.
example : ([(1,0),(0,0),(0,0),(1,0),(1,0),(0,1),(1,1),(1,0),(1,0)] :
    List (Bit × Bit)).foldl readPair (0,0) = (311,12) := by decide

-- Off-by-one and missing-size guards remain distinguishable.
example : (carry 1 1).val = 1 ∧ (carry 0 0).val = 0 := by decide
example : min 3 4 ≠ 4 ∧ min 4 4 = 4 := by decide

-- The generic state is finite, including the usual r=1 field/root size.
example : Finite (State (ZMod 3) (Fin 2) 2) := inferInstance
