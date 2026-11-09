module

public import FunctionFieldLittlewood.DyadicRay

@[expose] public section

#check @FunctionFieldLittlewood.DyadicRay.odd_period
#print axioms FunctionFieldLittlewood.DyadicRay.odd_period
#check @FunctionFieldLittlewood.DyadicRay.interior
#print axioms FunctionFieldLittlewood.DyadicRay.interior
#check @FunctionFieldLittlewood.DyadicRay.center
#print axioms FunctionFieldLittlewood.DyadicRay.center
#check @FunctionFieldLittlewood.DyadicRay.endpoint
#print axioms FunctionFieldLittlewood.DyadicRay.endpoint
#check @FunctionFieldLittlewood.DyadicRay.endpoint_first
#print axioms FunctionFieldLittlewood.DyadicRay.endpoint_first
#check @FunctionFieldLittlewood.DyadicRay.endpoint_stable
#print axioms FunctionFieldLittlewood.DyadicRay.endpoint_stable
#check @FunctionFieldLittlewood.DyadicRay.predecessor_step
#print axioms FunctionFieldLittlewood.DyadicRay.predecessor_step
#check @FunctionFieldLittlewood.DyadicRay.predecessor
#print axioms FunctionFieldLittlewood.DyadicRay.predecessor
#check @FunctionFieldLittlewood.DyadicRay.prefix_window
#print axioms FunctionFieldLittlewood.DyadicRay.prefix_window
#check @FunctionFieldLittlewood.DyadicRay.stable_window
#print axioms FunctionFieldLittlewood.DyadicRay.stable_window
#check @FunctionFieldLittlewood.DyadicRay.tuple_stable
#print axioms FunctionFieldLittlewood.DyadicRay.tuple_stable
#check @FunctionFieldLittlewood.DyadicRay.seven_relations
#print axioms FunctionFieldLittlewood.DyadicRay.seven_relations
#check @FunctionFieldLittlewood.DyadicRay.actual_stable
#print axioms FunctionFieldLittlewood.DyadicRay.actual_stable
#check @FunctionFieldLittlewood.DyadicRay.ray_two_states
#print axioms FunctionFieldLittlewood.DyadicRay.ray_two_states
#check @FunctionFieldLittlewood.DyadicRay.continuation_stable
#print axioms FunctionFieldLittlewood.DyadicRay.continuation_stable

open FunctionFieldLittlewood FunctionFieldLittlewood.DyadicRay CorrelatedState
namespace FunctionFieldLittlewood.DyadicRayAudit

def z3 : Fin 2 → ZMod 3 := ![1, 2]
def z5 : Fin 4 → ZMod 5 := fun i => (i.val + 1 : ZMod 5)

-- Usual valuation r=1 and the smallest size k=1, at every stable exponent.
theorem smallest_ray3 (d : ℕ) :
    actual (laiSprangStream 3 1) z3 (N := 2) (by decide) (2 ^ (3 + d) - 2) 1 =
      actual (laiSprangStream 3 1) z3 (by decide) 6 1 := by
  simpa using actual_stable 3 0 0 d z3

-- The previously studied canonical p=5 ray: no finite exponent enumeration.
theorem canonical_ray5 (a : ℕ) (ha : 6 ≤ a) :
    actual (laiSprangStream 5 2) z5 (N := 4) (by decide) (2 ^ a - 2) 8 =
      actual (laiSprangStream 5 2) z5 (by decide) 62 8 ∨
    actual (laiSprangStream 5 2) z5 (N := 4) (by decide) (2 ^ a - 2) 8 =
      actual (laiSprangStream 5 2) z5 (by decide) 126 8 := by
  simpa using ray_two_states 5 1 3 a z5 ha

-- Extending the constant prefix by a single coefficient would be false.
theorem endpoint_change5 :
    laiSprangStream 5 2 80 ≠ laiSprangStream 5 2 144 := by
  have hm := endpoint_first 5 1 4
  have hp := endpoint_stable 5 1 4 0
  norm_num at hm hp
  rw [hm, hp]
  decide

-- The same endpoint issue must be retained in the usual r=1 comparison.
theorem endpoint_change3 :
    laiSprangStream 3 1 6 ≠ laiSprangStream 3 1 10 := by
  have hm := endpoint_first 3 0 1
  have hp := endpoint_stable 3 0 1 0
  norm_num at hm hp
  rw [hm, hp]
  decide

#print axioms smallest_ray3
#print axioms canonical_ray5
#print axioms endpoint_change5
#print axioms endpoint_change3
end FunctionFieldLittlewood.DyadicRayAudit
