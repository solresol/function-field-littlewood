import FunctionFieldLittlewood.BoundaryRelation

#check @FunctionFieldLittlewood.BoundaryRelation.odd_block_factor
#check @FunctionFieldLittlewood.BoundaryRelation.stream_odd_block_factor
#check @FunctionFieldLittlewood.BoundaryRelation.stream_even_block
#check @FunctionFieldLittlewood.BoundaryRelation.full_root_sum
#check @FunctionFieldLittlewood.BoundaryRelation.stream_full_root_data
#check @FunctionFieldLittlewood.BoundaryRelation.forcing_transport
#check @FunctionFieldLittlewood.BoundaryRelation.moment_transport
#check @FunctionFieldLittlewood.BoundaryRelation.holds_reindex
#check @FunctionFieldLittlewood.BoundaryRelation.colJoin_swap
#check @FunctionFieldLittlewood.BoundaryRelation.rowJoin_mulVec
#check @FunctionFieldLittlewood.BoundaryRelation.colJoin_mulVec
#check @FunctionFieldLittlewood.BoundaryRelation.merge_iff
#check @FunctionFieldLittlewood.BoundaryRelation.parityEquiv_val
#check @FunctionFieldLittlewood.BoundaryRelation.natural_holds_iff
#check @FunctionFieldLittlewood.BoundaryRelation.parity_forcing
#check @FunctionFieldLittlewood.BoundaryRelation.parity_moments
#check @FunctionFieldLittlewood.BoundaryRelation.even_blocks
#check @FunctionFieldLittlewood.BoundaryRelation.odd_blocks
#check @FunctionFieldLittlewood.BoundaryRelation.even_merge
#check @FunctionFieldLittlewood.BoundaryRelation.odd_merge

#print axioms FunctionFieldLittlewood.BoundaryRelation.odd_block_factor
#print axioms FunctionFieldLittlewood.BoundaryRelation.stream_odd_block_factor
#print axioms FunctionFieldLittlewood.BoundaryRelation.stream_even_block
#print axioms FunctionFieldLittlewood.BoundaryRelation.full_root_sum
#print axioms FunctionFieldLittlewood.BoundaryRelation.stream_full_root_data
#print axioms FunctionFieldLittlewood.BoundaryRelation.forcing_transport
#print axioms FunctionFieldLittlewood.BoundaryRelation.moment_transport
#print axioms FunctionFieldLittlewood.BoundaryRelation.holds_reindex
#print axioms FunctionFieldLittlewood.BoundaryRelation.colJoin_swap
#print axioms FunctionFieldLittlewood.BoundaryRelation.rowJoin_mulVec
#print axioms FunctionFieldLittlewood.BoundaryRelation.colJoin_mulVec
#print axioms FunctionFieldLittlewood.BoundaryRelation.merge_iff
#print axioms FunctionFieldLittlewood.BoundaryRelation.parityEquiv_val
#print axioms FunctionFieldLittlewood.BoundaryRelation.natural_holds_iff
#print axioms FunctionFieldLittlewood.BoundaryRelation.parity_forcing
#print axioms FunctionFieldLittlewood.BoundaryRelation.parity_moments
#print axioms FunctionFieldLittlewood.BoundaryRelation.even_blocks
#print axioms FunctionFieldLittlewood.BoundaryRelation.odd_blocks
#print axioms FunctionFieldLittlewood.BoundaryRelation.even_merge
#print axioms FunctionFieldLittlewood.BoundaryRelation.odd_merge

-- Semantic controls: the odd-start off-diagonal blocks really have distinct
-- offsets, and empty systems retain arbitrary forcing but force zero moments.
open FunctionFieldLittlewood FunctionFieldLittlewood.BoundaryRelation Matrix

example : laiSprangStream 5 2 1 ≠ laiSprangStream 5 2 3 := by
  norm_num [laiSprangStream, oddCore]
  decide

example (a : ℕ → ZMod 5) (z : Fin 4 → ZMod 5) (u v : Fin 4 → ZMod 5) :
    Holds (block a 1 0 0) (evalMatrix z 0) (evalMatrix z 0)ᵀ u v ↔ v = 0 := by
  constructor
  · rintro ⟨x, _, hv⟩
    simpa [Matrix.mulVec, dotProduct] using hv.symm
  · intro hv
    subst v
    refine ⟨Fin.elim0, ?_, ?_⟩
    · funext i; exact Fin.elim0 i
    · simp

-- r=1 remains included: the named data theorem has no r>=2 hypothesis.
example : ∃ z : Fin 2 → ZMod 3, Function.Injective z ∧
    (∀ x : ZMod 3, x ^ 2 = 1 ↔ ∃ q, x = z q) ∧
    (∃ σ : Fin 2 → Fin 2, ∀ q, z (σ q) = z q ^ 2) ∧
    ∀ l, laiSprangStream 3 1 (2 * l + 1) =
      ∑ q, oddWeight 1 q * z q ^ l := by
  exact stream_full_root_data (p := 3) (r := 0) (by decide)
