import FunctionFieldLittlewood.TargetPreimage

#check @FunctionFieldLittlewood.TargetPreimage.transport_transpose_apply
#check @FunctionFieldLittlewood.TargetPreimage.alpha_reconstruct
#check @FunctionFieldLittlewood.TargetPreimage.output_iff
#check @FunctionFieldLittlewood.TargetPreimage.mergeEven_target_iff
#check @FunctionFieldLittlewood.TargetPreimage.mergeOdd_target_iff
#check @FunctionFieldLittlewood.TargetPreimage.tupleStep_target_iff
#check @FunctionFieldLittlewood.TargetPreimage.actual_target_iff
#check @FunctionFieldLittlewood.TargetPreimage.stream_target_iff
#check @FunctionFieldLittlewood.TargetPreimage.affine_intersection_iff
#check @FunctionFieldLittlewood.TargetPreimage.affine_intersection_quotient_iff
#check @FunctionFieldLittlewood.TargetPreimage.affine_intersection_unique

#print axioms FunctionFieldLittlewood.TargetPreimage.transport_transpose_apply
#print axioms FunctionFieldLittlewood.TargetPreimage.alpha_reconstruct
#print axioms FunctionFieldLittlewood.TargetPreimage.output_iff
#print axioms FunctionFieldLittlewood.TargetPreimage.mergeEven_target_iff
#print axioms FunctionFieldLittlewood.TargetPreimage.mergeOdd_target_iff
#print axioms FunctionFieldLittlewood.TargetPreimage.tupleStep_target_iff
#print axioms FunctionFieldLittlewood.TargetPreimage.actual_target_iff
#print axioms FunctionFieldLittlewood.TargetPreimage.stream_target_iff
#print axioms FunctionFieldLittlewood.TargetPreimage.affine_intersection_iff
#print axioms FunctionFieldLittlewood.TargetPreimage.affine_intersection_quotient_iff
#check @FunctionFieldLittlewood.TargetPreimage.affine_class_representatives
#print axioms FunctionFieldLittlewood.TargetPreimage.affine_class_representatives
#print axioms FunctionFieldLittlewood.TargetPreimage.affine_intersection_unique

open Matrix FunctionFieldLittlewood FunctionFieldLittlewood.BoundaryRelation
open FunctionFieldLittlewood.CorrelatedState FunctionFieldLittlewood.TargetPreimage

variable {K Ω V : Type*} [Field K] [Fintype Ω] [DecidableEq Ω]
variable [AddCommGroup V] [Module K V]

-- All four branch endpoints, including unequal rectangular lengths.
example (z w : Ω → K)
    (σ : Ω → Ω) (s : ℕ) (T : Tuple K Ω) :
    reducedTarget z w σ s T 0 0 = reducedOdd z w σ s (T 0 0 0) (T 0 0 0) := rfl
example (z w : Ω → K)
    (σ : Ω → Ω) (s : ℕ) (T : Tuple K Ω) :
    reducedTarget z w σ s T 0 1 = reducedOdd z w σ s (T 0 1 0) (T 0 0 1) := rfl
example (z w : Ω → K)
    (σ : Ω → Ω) (s : ℕ) (T : Tuple K Ω) :
    reducedTarget z w σ s T 1 0 = reducedEven z w σ (s+1) (T 0 0 0) (T 1 0 0) := rfl
example (z w : Ω → K)
    (σ : Ω → Ω) (s : ℕ) (T : Tuple K Ω) :
    reducedTarget z w σ s T 1 1 = reducedEven z w σ (s+1) (T 0 1 1) (T 1 0 0) := rfl

private def z3 (i : Fin 2) : ZMod 3 := if i = 0 then 1 else -1
private def square3 (_ : Fin 2) : Fin 2 := 0

-- The r=1 output equation leaves the nonsquare moments free.
example : (transport z3 square3 0)ᵀ *ᵥ ![2, 1] +
    (transport z3 square3 1)ᵀ *ᵥ ![2, 0] = target z3 := by
  apply (output_iff z3 square3 (by decide +kernel) (by decide +kernel)
    (by decide +kernel) (by decide +kernel) (by decide +kernel) _ _).mpr
  constructor <;> intro q <;> norm_num [square3, alpha, target, z3] <;> decide +kernel

-- Altering the forced square coordinate is rejected.
example : ¬ ((transport z3 square3 0)ᵀ *ᵥ ![0, 1] +
    (transport z3 square3 1)ᵀ *ᵥ ![2, 0] = target z3) := by
  rw [output_iff z3 square3 (by decide +kernel) (by decide +kernel)
    (by decide +kernel) (by decide +kernel) (by decide +kernel)]
  intro h
  have h0 := h.1 0
  norm_num [square3, alpha, target, z3] at h0
  exact (by decide : (2 : ZMod 3) ≠ 0) h0

-- Empty blocks do not carry the nonzero target.
example : ¬ relation (laiSprangStream 3 1) z3 1 0 0 0 (target z3) := by
  rintro ⟨x, _, hv⟩
  have h := congrFun hv 0
  simp [evalMatrix, mulVec, dotProduct, target, z3] at h

-- Feasible singleton slices can disagree: local feasibility is insufficient.
example : ¬ ∃ x : ZMod 5, x - 1 ∈ (⊥ : Submodule (ZMod 5) (ZMod 5)) ∧
    x - 2 ∈ (⊥ : Submodule (ZMod 5) (ZMod 5)) := by
  rw [affine_intersection_iff]
  norm_num

-- Moving an affine representative within its direction leaves compatibility unchanged.
example (L₀ L₁ : Submodule K V)
    (a₀ a₁ u : V) (hu : u ∈ L₀) :
    a₁ - (a₀ + u) ∈ L₀ ⊔ L₁ ↔ a₁ - a₀ ∈ L₀ ⊔ L₁ := by
  have hm : u ∈ L₀ ⊔ L₁ := Submodule.mem_sup_left hu
  constructor
  · intro h
    convert (L₀ ⊔ L₁).add_mem h hm using 1; abel
  · intro h
    convert (L₀ ⊔ L₁).sub_mem h hm using 1; abel

-- Named stream specialization explicitly includes the usual r=1 case.
example : ∃ z : Fin 2 → ZMod 3, ∃ σ : Fin 2 → Fin 2,
    Function.Injective z ∧
    (∀ x : ZMod 3, x ^ 2 = 1 ↔ ∃ j, x = z j) ∧
    (∀ j, z (σ j) = z j ^ 2) ∧
    ∀ q k ε η,
      relation (laiSprangStream 3 1) z (2*q+ε.val+1) (2*k+η.val) (2*k+η.val)
        0 (target z) ↔
      reducedTarget z (oddWeight 1) σ q (tuple (laiSprangStream 3 1) z q k) ε η := by
  simpa using stream_target_iff (p := 3) (r := 0) (by decide)
