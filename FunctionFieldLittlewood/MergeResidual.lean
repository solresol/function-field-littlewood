module

public import FunctionFieldLittlewood.TargetPreimage
public import Mathlib.LinearAlgebra.Matrix.ToLin

@[expose] public section

namespace FunctionFieldLittlewood.TargetPreimage

variable {K Z W V E : Type*} [Field K]
  [AddCommGroup Z] [Module K Z] [AddCommGroup W] [Module K W]
  [AddCommGroup V] [Module K V] [AddCommGroup E] [Module K E]

/-- Eliminate an internal split from a system of stacked boundary equations. -/
noncomputable def residual (U : V →ₗ[K] E) (A : Z →ₗ[K] E) :
    Z →ₗ[K] E ⧸ LinearMap.range U :=
  (LinearMap.range U).mkQ.comp A

theorem residual_eq_iff (U : V →ₗ[K] E) (A : Z →ₗ[K] E) (B : W →ₗ[K] E)
    (z : Z) (w : W) :
    residual U A z = residual U B w ↔ ∃ x, U x = A z - B w := by
  exact Submodule.Quotient.eq (LinearMap.range U)

variable {V' E' : Type*} [AddCommGroup V'] [Module K V']
  [AddCommGroup E'] [Module K E']

/-- Each child stacks its two sets of pulled-back equations. Its inner split is
private, while both children use the same outer split. Taking the range of
the paired outer map preserves this correlation even when a child is singular. -/
theorem two_merge_residual_iff
    (U₀ : V →ₗ[K] E) (U₁ : V' →ₗ[K] E')
    (A₀ : Z →ₗ[K] E) (A₁ : Z →ₗ[K] E')
    (B₀ : W →ₗ[K] E) (B₁ : W →ₗ[K] E') (z : Z) :
    residual ((residual U₀ B₀).prod (residual U₁ B₁))
      ((residual U₀ A₀).prod (residual U₁ A₁)) z = 0 ↔
    ∃ w x₀ x₁, U₀ x₀ = A₀ z - B₀ w ∧ U₁ x₁ = A₁ z - B₁ w := by
  change (Submodule.Quotient.mk _ : _ ⧸ LinearMap.range ((residual U₀ B₀).prod (residual U₁ B₁))) = 0 ↔ _
  rw [Submodule.Quotient.mk_eq_zero]
  constructor
  · rintro ⟨w, hw⟩
    obtain ⟨x₀, h₀⟩ := (residual_eq_iff U₀ A₀ B₀ z w).mp (congrArg Prod.fst hw.symm)
    obtain ⟨x₁, h₁⟩ := (residual_eq_iff U₁ A₁ B₁ z w).mp (congrArg Prod.snd hw.symm)
    exact ⟨w, x₀, x₁, h₀, h₁⟩
  · rintro ⟨w, x₀, x₁, h₀, h₁⟩
    exact ⟨w, Prod.ext ((residual_eq_iff U₀ A₀ B₀ z w).mpr ⟨x₀, h₀⟩).symm
      ((residual_eq_iff U₁ A₁ B₁ z w).mpr ⟨x₁, h₁⟩).symm⟩

/-- Intersect a homogeneous split line with the target chart h = 1.
The equation for the split uses no division. -/
theorem mem_line_slice_iff (d : K) (v w : W) :
    ((1 : K), w) ∈ Submodule.span K {(d, v)} ↔ d ≠ 0 ∧ d • w = v := by
  rw [Submodule.mem_span_singleton]
  constructor
  · rintro ⟨a, ha⟩
    have h : a * d = 1 := congrArg Prod.fst ha
    have hw : a • v = w := congrArg Prod.snd ha
    refine ⟨fun hd => by simp [hd] at h, ?_⟩
    rw [← hw, smul_smul, mul_comm, h, one_smul]
  · rintro ⟨hd, rfl⟩
    exact ⟨d⁻¹, Prod.ext (inv_mul_cancel₀ hd) (by
      change d⁻¹ • d • w = w
      rw [smul_smul, inv_mul_cancel₀ hd, one_smul])⟩

/-- Evaluate the shared-split residual at a target z once both projected child
relations on the affine slice have certified homogeneous generators. -/
theorem two_merge_line_slice_iff
    (U₀ : V →ₗ[K] E) (U₁ : V' →ₗ[K] E')
    (A₀ : Z →ₗ[K] E) (A₁ : Z →ₗ[K] E')
    (B₀ : W →ₗ[K] E) (B₁ : W →ₗ[K] E') (z : Z)
    (d₀ d₁ : K) (v₀ v₁ : W)
    (h₀ : ∀ w, (∃ x, U₀ x = A₀ z - B₀ w) ↔
      ((1 : K), w) ∈ Submodule.span K {(d₀, v₀)})
    (h₁ : ∀ w, (∃ x, U₁ x = A₁ z - B₁ w) ↔
      ((1 : K), w) ∈ Submodule.span K {(d₁, v₁)}) :
    residual ((residual U₀ B₀).prod (residual U₁ B₁))
      ((residual U₀ A₀).prod (residual U₁ A₁)) z = 0 ↔
      d₀ ≠ 0 ∧ d₁ ≠ 0 ∧ d₀ • v₁ = d₁ • v₀ := by
  rw [two_merge_residual_iff]
  constructor
  · rintro ⟨w, x₀, x₁, e₀, e₁⟩
    obtain ⟨hd₀, rfl⟩ := (mem_line_slice_iff ..).mp ((h₀ w).mp ⟨x₀, e₀⟩)
    obtain ⟨hd₁, rfl⟩ := (mem_line_slice_iff ..).mp ((h₁ w).mp ⟨x₁, e₁⟩)
    exact ⟨hd₀, hd₁, smul_comm ..⟩
  · rintro ⟨hd₀, hd₁, he⟩
    let w := d₀⁻¹ • v₀
    have e₀ : d₀ • w = v₀ := by simp [w, smul_smul, hd₀]
    have e₁ : d₁ • w = v₁ := by
      change d₁ • d₀⁻¹ • v₀ = v₁
      rw [smul_comm d₁, ← he, smul_smul, inv_mul_cancel₀ hd₀, one_smul]
    obtain ⟨x₀, f₀⟩ := (h₀ w).mpr ((mem_line_slice_iff ..).mpr ⟨hd₀, e₀⟩)
    obtain ⟨x₁, f₁⟩ := (h₁ w).mpr ((mem_line_slice_iff ..).mpr ⟨hd₁, e₁⟩)
    exact ⟨w, x₀, x₁, f₀, f₁⟩

/-- On the chart h = 1 each child imposes c + A w = 0. Stack rows before
taking the column span so the two children use the same split coefficients.
The digit switch has four split coordinates; neither child needs maximal rank. -/
theorem shared_split_iff_stacked_column_span {I J S : Type*} [Fintype S]
    (A : Matrix I S K) (B : Matrix J S K) (c : I → K) (d : J → K) :
    (∃ w, c + A.mulVec w = 0 ∧ d + B.mulVec w = 0) ↔
      Sum.elim c d ∈ Submodule.span K
        (Set.range (Matrix.col (Sum.elim A B : Matrix (I ⊕ J) S K))) := by
  classical
  rw [← Matrix.range_mulVecLin (Sum.elim A B : Matrix (I ⊕ J) S K)]
  constructor
  · rintro ⟨w, ha, hb⟩
    refine ⟨-w, ?_⟩
    funext i
    cases i with
    | inl i =>
      change A.mulVec (-w) i = c i
      rw [Matrix.mulVec_neg]
      exact congrFun (eq_neg_of_add_eq_zero_left ha).symm i
    | inr j =>
      change B.mulVec (-w) j = d j
      rw [Matrix.mulVec_neg]
      exact congrFun (eq_neg_of_add_eq_zero_left hb).symm j
  · rintro ⟨v, hv⟩
    refine ⟨-v, ?_, ?_⟩
    · rw [Matrix.mulVec_neg]
      have ha : A.mulVec v = c := funext fun i => congrFun hv (Sum.inl i)
      simp [ha]
    · rw [Matrix.mulVec_neg]
      have hb : B.mulVec v = d := funext fun j => congrFun hv (Sum.inr j)
      simp [hb]

end FunctionFieldLittlewood.TargetPreimage
