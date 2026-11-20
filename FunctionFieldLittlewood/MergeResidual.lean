module

public import FunctionFieldLittlewood.TargetPreimage

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

end FunctionFieldLittlewood.TargetPreimage
