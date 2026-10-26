module

public import FunctionFieldLittlewood.CorrelatedState
public import Mathlib.LinearAlgebra.Quotient.Defs

@[expose] public section

/-!
The target-specialized merge and affine compatibility criterion of 26 October.
This uses the raw stream convention of BoundaryRelation. No no-invisible-vector,
Proposition 2.3, terminal existence, or exact-certificate conclusion is assumed.
-/
namespace FunctionFieldLittlewood.TargetPreimage
open scoped BigOperators
open Matrix BoundaryRelation CorrelatedState

variable {K Ω : Type*} [Field K] [Fintype Ω] [DecidableEq Ω]

/-- The parent target, in the complete root-coordinate system. -/
noncomputable def target (z : Ω → K) : Ω → K := by
  classical
  exact fun q => if z q = 1 then 1 else 0

/-- The fixed part of each child output. -/
noncomputable def alpha (z : Ω → K) : Ω → K := fun q => target z q / 2

/-- The remaining child moments vanish on every square-root coordinate.
Thus their only free coordinates are outside the image of squaring. -/
def Primitive (σ : Ω → Ω) (x : Ω → K) : Prop := ∀ q, x (σ q) = 0

theorem transport_transpose_apply (z : Ω → K) (σ : Ω → Ω)
    (a : ℕ) (v : Ω → K) (q : Ω) :
    ((transport z σ a)ᵀ *ᵥ v) q = z q ^ a * v (σ q) := by
  classical
  simp [mulVec, dotProduct, transpose_apply, transport]

omit [Fintype Ω] [DecidableEq Ω] in
theorem alpha_reconstruct (z : Ω → K) (σ : Ω → Ω)
    (hσ : ∀ q, z (σ q) = z q ^ 2) (h2 : (2 : K) ≠ 0) (q : Ω) :
    alpha z (σ q) + z q * alpha z (σ q) = target z q := by
  classical
  by_cases hq : z q = 1
  · simp [alpha, target, hσ, hq]
    field_simp
    ring
  · by_cases hn : z q = -1
    · have hm : (- (1 : K)) ≠ 1 := by intro he; apply h2; linear_combination -he
      simp [alpha, target, hσ, hn, hm]
    · have hs : z q ^ 2 ≠ 1 := by
        intro hs
        rcases (sq_eq_one_iff).mp hs with h | h
        · exact hq h
        · exact hn h
      simp [alpha, target, hσ, hq, hs]

/-- The output equation fixes both child vectors on the square coordinates.
Negation closure and nonzero roots, rather than an assumed fibre formula,
discharge the two-root argument. This includes the two-root (r=1) case. -/
theorem output_iff (z : Ω → K) (σ : Ω → Ω)
    (hi : Function.Injective z) (hσ : ∀ q, z (σ q) = z q ^ 2)
    (hn : ∀ q, ∃ q', z q' = -z q) (hz : ∀ q, z q ≠ 0)
    (h2 : (2 : K) ≠ 0) (v₀ v₁ : Ω → K) :
    (transport z σ 0)ᵀ *ᵥ v₀ + (transport z σ 1)ᵀ *ᵥ v₁ = target z ↔
      Primitive σ (v₀ - alpha z) ∧ Primitive σ (v₁ - alpha z) := by
  classical
  have component (q) :
      ((transport z σ 0)ᵀ *ᵥ v₀ + (transport z σ 1)ᵀ *ᵥ v₁) q =
        v₀ (σ q) + z q * v₁ (σ q) := by
    simp [transport_transpose_apply]
  constructor
  · intro h
    have values (q) : v₀ (σ q) = alpha z (σ q) ∧ v₁ (σ q) = alpha z (σ q) := by
      obtain ⟨q', hq'⟩ := hn q
      have hs : σ q' = σ q := hi (by rw [hσ, hσ, hq', neg_sq])
      have hq := congrFun h q
      have hq2 := congrFun h q'
      rw [component] at hq hq2
      rw [hs, hq'] at hq2
      have ht : target z q + target z q' = 2 * alpha z (σ q) := by
        by_cases hp : z q = 1
        · have hm : (- (1 : K)) ≠ 1 := by intro he; apply h2; linear_combination -he
          simp [target, alpha, hσ, hq', hp, hm, h2]
        · by_cases hm : z q = -1
          · have hneg : (- (1 : K)) ≠ 1 := by intro he; apply h2; linear_combination -he
            simp [target, alpha, hσ, hq', hm, hneg, h2]
          · have hp' : z q' ≠ 1 := by rw [hq']; intro he; apply hm; linear_combination -he
            have hs' : z q ^ 2 ≠ 1 := by
              intro he
              rcases sq_eq_one_iff.mp he with he | he
              · exact hp he
              · exact hm he
            simp [target, alpha, hσ, hp, hp', hs']
      have hv₀ : v₀ (σ q) = alpha z (σ q) := by
        apply (mul_left_cancel₀ h2)
        linear_combination hq + hq2 + ht
      have hv₁ : v₁ (σ q) = alpha z (σ q) := by
        apply (mul_left_cancel₀ (hz q))
        linear_combination hq - hv₀ - alpha_reconstruct z σ hσ h2 q
      exact ⟨hv₀, hv₁⟩
    exact ⟨fun q => sub_eq_zero.mpr (values q).1,
      fun q => sub_eq_zero.mpr (values q).2⟩
  · rintro ⟨h₀, h₁⟩
    ext q
    rw [component, sub_eq_zero.mp (h₀ q), sub_eq_zero.mp (h₁ q)]
    exact alpha_reconstruct z σ hσ h2 q

/-- Primitive-parts test for the even-start orientation. -/
noncomputable def reducedEven (z w : Ω → K) (σ : Ω → Ω) (s : ℕ)
    (R₀ R₁ : Relation K Ω) : Prop :=
  ∃ x₀ x₁, Primitive σ x₀ ∧ Primitive σ x₁ ∧
    R₀ (-diagonal (fun q => w q * z q ^ s) *ᵥ (alpha z + x₁)) (alpha z + x₀) ∧
    R₁ (-diagonal (fun q => w q * z q ^ s) *ᵥ (alpha z + x₀)) (alpha z + x₁)

/-- Primitive-parts test for the odd-start orientation. -/
noncomputable def reducedOdd (z w : Ω → K) (σ : Ω → Ω) (s : ℕ)
    (R₀ R₁ : Relation K Ω) : Prop :=
  ∃ x₀ x₁, Primitive σ x₀ ∧ Primitive σ x₁ ∧
    R₀ (-diagonal (fun q => w q * z q ^ s) *ᵥ (alpha z + x₀)) (alpha z + x₁) ∧
    R₁ (-diagonal (fun q => w q * z q ^ (s + 1)) *ᵥ (alpha z + x₁)) (alpha z + x₀)

/-- Zero-forcing, even-start merge with only the two primitive parts free.
The two child relations are coupled by the same x₀,x₁. -/
theorem mergeEven_target_iff (z w : Ω → K) (σ : Ω → Ω)
    (hi : Function.Injective z) (hσ : ∀ q, z (σ q) = z q ^ 2)
    (hn : ∀ q, ∃ q', z q' = -z q) (hz : ∀ q, z q ≠ 0)
    (h2 : (2 : K) ≠ 0) (s : ℕ) (R₀ R₁ : Relation K Ω) :
    mergeEven z w σ s R₀ R₁ 0 (target z) ↔ reducedEven z w σ s R₀ R₁ := by
  simp only [mergeEven, reducedEven, mulVec_zero, zero_sub]
  constructor
  · rintro ⟨v₀, v₁, h₀, h₁, hv⟩
    obtain ⟨hp₀, hp₁⟩ := (output_iff z σ hi hσ hn hz h2 v₀ v₁).mp hv
    refine ⟨v₀ - alpha z, v₁ - alpha z, hp₀, hp₁, ?_⟩
    simpa only [add_sub_cancel, neg_mulVec] using And.intro h₀ h₁
  · rintro ⟨x₀, x₁, hp₀, hp₁, h₀, h₁⟩
    refine ⟨alpha z + x₀, alpha z + x₁, ?_, ?_, ?_⟩
    · simpa only [neg_mulVec] using h₀
    · simpa only [neg_mulVec] using h₁
    · apply (output_iff z σ hi hσ hn hz h2 _ _).mpr
      simpa only [add_sub_cancel_left] using And.intro hp₀ hp₁

/-- Odd-start orientation: the first child has odd-column moments and the
second exponent is s+1. No parity endpoint is discarded. -/
theorem mergeOdd_target_iff (z w : Ω → K) (σ : Ω → Ω)
    (hi : Function.Injective z) (hσ : ∀ q, z (σ q) = z q ^ 2)
    (hn : ∀ q, ∃ q', z q' = -z q) (hz : ∀ q, z q ≠ 0)
    (h2 : (2 : K) ≠ 0) (s : ℕ) (R₀ R₁ : Relation K Ω) :
    mergeOdd z w σ s R₀ R₁ 0 (target z) ↔ reducedOdd z w σ s R₀ R₁ := by
  simp only [mergeOdd, reducedOdd, mulVec_zero, zero_sub]
  constructor
  · rintro ⟨v₁, v₀, h₀, h₁, hv⟩
    obtain ⟨hp₀, hp₁⟩ := (output_iff z σ hi hσ hn hz h2 v₀ v₁).mp (by
      simpa only [add_comm] using hv)
    refine ⟨v₀ - alpha z, v₁ - alpha z, hp₀, hp₁, ?_⟩
    simpa only [add_sub_cancel, neg_mulVec] using And.intro h₀ h₁
  · rintro ⟨x₀, x₁, hp₀, hp₁, h₀, h₁⟩
    refine ⟨alpha z + x₁, alpha z + x₀, ?_, ?_, ?_⟩
    · simpa only [neg_mulVec] using h₀
    · simpa only [neg_mulVec] using h₁
    · have h := (output_iff z σ hi hσ hn hz h2 (alpha z + x₀) (alpha z + x₁)).mpr
        (by simpa only [add_sub_cancel_left] using And.intro hp₀ hp₁)
      simpa only [add_comm] using h

/-- One-digit target test on one stored tuple. All four branches retain
their original rectangular endpoints; no four-square reconstruction is assumed. -/
noncomputable def reducedTarget (z w : Ω → K) (σ : Ω → Ω) (phase : ℕ)
    (T : Tuple K Ω) (ε η : Bit) : Prop :=
  if ε = 0 then
    reducedOdd z w σ phase
      (T 0 (half η 0 0) (half η 0 1)) (T 0 (half η 0 1) (half η 0 0))
  else
    reducedEven z w σ (phase + 1)
      (T 0 (half η 0 0) (half η 0 0)) (T 1 (half η 0 1) (half η 0 1))

theorem tupleStep_target_iff (z w : Ω → K) (σ : Ω → Ω)
    (hi : Function.Injective z) (hσ : ∀ q, z (σ q) = z q ^ 2)
    (hn : ∀ q, ∃ q', z q' = -z q) (hz : ∀ q, z q ≠ 0)
    (h2 : (2 : K) ≠ 0) (phase : ℕ) (T : Tuple K Ω) (ε η : Bit) :
    tupleStep z w σ phase T ε η 0 0 0 0 (target z) ↔
      reducedTarget z w σ phase T ε η := by
  fin_cases ε <;>
    simp only [tupleStep, reducedTarget, carry, Fin.val_zero, Fin.val_one,
      Fin.reduceFinMk, Nat.reduceDiv,
      Nat.add_zero, ite_true, ite_false, zero_ne_one, one_ne_zero]
  · exact mergeOdd_target_iff z w σ hi hσ hn hz h2 phase _ _
  · exact mergeEven_target_iff z w σ hi hσ hn hz h2 (phase + 1) _ _

/-- The reduced test is equivalent to target membership for actual infinite
Hankel blocks, for every shift/size digit, including zero and empty blocks. -/
theorem actual_target_iff (a : ℕ → K) (z w : Ω → K) (σ : Ω → Ω)
    (he : ∀ l, a (2 * l) = a l)
    (ho : ∀ l, a (2 * l + 1) = ∑ q, w q * z q ^ l)
    (hi : Function.Injective z) (hσ : ∀ q, z (σ q) = z q ^ 2)
    (hn : ∀ q, ∃ q', z q' = -z q) (hz : ∀ q, z q ≠ 0)
    (h2 : (2 : K) ≠ 0) (q k : ℕ) (ε η : Bit) :
    relation a z (2 * q + ε.val + 1) (2 * k + η.val) (2 * k + η.val)
      0 (target z) ↔ reducedTarget z w σ q (tuple a z q k) ε η := by
  have h := congrArg (fun T : Tuple K Ω => T 0 0 0)
    (tupleStep_tuple a z w σ he ho hσ q k ε η)
  simp only [tuple, Fin.val_zero, Nat.add_zero] at h
  rw [← h]
  exact tupleStep_target_iff z w σ hi hσ hn hz h2 q _ ε η

/-- The complete root list discharges negation closure and nonzero-root
hypotheses. The named stream discharges both coefficient recurrences.
Only the original dyadic divisibility pin is required, including Lean r=0. -/
theorem stream_target_iff {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) :
    ∃ z : Fin (2 * 2 ^ r) → ZMod p,
      ∃ σ : Fin (2 * 2 ^ r) → Fin (2 * 2 ^ r),
        Function.Injective z ∧
        (∀ x : ZMod p, x ^ (2 * 2 ^ r) = 1 ↔ ∃ j, x = z j) ∧
        (∀ j, z (σ j) = z j ^ 2) ∧
        ∀ q k ε η,
          relation (laiSprangStream p (r + 1)) z (2 * q + ε.val + 1)
            (2 * k + η.val) (2 * k + η.val) 0 (target z) ↔
          reducedTarget z (oddWeight (2 ^ r)) σ q
            (tuple (laiSprangStream p (r + 1)) z q k) ε η := by
  obtain ⟨z, hi, hc, ⟨σ, hs⟩, ho⟩ := stream_full_root_data hd
  have root (j) : z j ^ (2 * 2 ^ r) = 1 := (hc _).mpr ⟨j, rfl⟩
  have hn (j) : ∃ j', z j' = -z j := by
    have hneg : (-z j) ^ (2 * 2 ^ r) = 1 := by
      rw [pow_mul, neg_sq, ← pow_mul, root]
    obtain ⟨j', hj'⟩ := (hc _).mp hneg
    exact ⟨j', hj'.symm⟩
  have hz (j) : z j ≠ 0 := by
    intro he
    have h := root j
    rw [he, zero_pow (by positivity)] at h
    exact zero_ne_one h
  have hp : 2 < p := by
    have hp := (Fact.out : p.Prime).two_le
    have hle := Nat.le_of_dvd (by omega : 0 < p - 1) hd
    have : 2 ≤ 2 ^ (r + 1) := by rw [pow_succ]; have := Nat.one_le_pow r 2 (by decide); omega
    omega
  have h2 : (2 : ZMod p) ≠ 0 := by
    intro h
    exact Nat.not_dvd_of_pos_of_lt (by decide : 0 < 2) hp
      ((ZMod.natCast_eq_zero_iff 2 p).mp h)
  refine ⟨z, σ, hi, hc, hs, ?_⟩
  intro q k ε η
  exact actual_target_iff _ z _ σ (laiSprangStream_even p (r + 1)) ho
    hi hs hn hz h2 q k ε η

section Affine
variable {V : Type*} [AddCommGroup V] [Module K V]

/-- The exact remaining obstruction for two nonempty affine slices. -/
theorem affine_intersection_iff (L₀ L₁ : Submodule K V) (a₀ a₁ : V) :
    (∃ x, x - a₀ ∈ L₀ ∧ x - a₁ ∈ L₁) ↔ a₁ - a₀ ∈ L₀ ⊔ L₁ := by
  constructor
  · rintro ⟨x, h₀, h₁⟩
    have h := Submodule.sub_mem_sup h₀ h₁
    convert h using 1; abel
  · intro h
    obtain ⟨u, hu, v, hv, he⟩ := Submodule.mem_sup.mp h
    refine ⟨a₀ + u, ?_, ?_⟩
    · simpa only [add_sub_cancel_left] using hu
    · have hx : a₀ + u - a₁ = -v := by
        calc
          a₀ + u - a₁ = u - (a₁ - a₀) := by abel
          _ = -v := by rw [← he]; abel
      rw [hx]
      exact L₁.neg_mem hv

/-- The obstruction is precisely the zero class in the sum quotient. -/
theorem affine_intersection_quotient_iff (L₀ L₁ : Submodule K V) (a₀ a₁ : V) :
    (∃ x, x - a₀ ∈ L₀ ∧ x - a₁ ∈ L₁) ↔
      (Submodule.Quotient.mk (a₁ - a₀) : V ⧸ (L₀ ⊔ L₁)) = 0 := by
  rw [Submodule.Quotient.mk_eq_zero, affine_intersection_iff]

/-- The quotient class is independent of the two chosen affine representatives. -/
theorem affine_class_representatives (L₀ L₁ : Submodule K V)
    (a₀ a₁ u v : V) (hu : u ∈ L₀) (hv : v ∈ L₁) :
    (Submodule.Quotient.mk ((a₁ + v) - (a₀ + u)) : V ⧸ (L₀ ⊔ L₁)) =
      Submodule.Quotient.mk (a₁ - a₀) := by
  apply (Submodule.Quotient.eq (L₀ ⊔ L₁)).mpr
  rw [show (a₁ + v - (a₀ + u)) - (a₁ - a₀) = v - u by abel]
  exact (L₀ ⊔ L₁).sub_mem (Submodule.mem_sup_right hv) (Submodule.mem_sup_left hu)

/-- Uniqueness is conditional on a proved trivial direction intersection;
it is not an unconditional no-invisible-vector theorem. -/
theorem affine_intersection_unique (L₀ L₁ : Submodule K V)
    (hdis : L₀ ⊓ L₁ = ⊥) (a₀ a₁ x y : V)
    (hx : x - a₀ ∈ L₀ ∧ x - a₁ ∈ L₁)
    (hy : y - a₀ ∈ L₀ ∧ y - a₁ ∈ L₁) : x = y := by
  have hmem : x - y ∈ L₀ ⊓ L₁ := by
    constructor
    · rw [show x - y = (x - a₀) - (y - a₀) by abel]
      exact L₀.sub_mem hx.1 hy.1
    · rw [show x - y = (x - a₁) - (y - a₁) by abel]
      exact L₁.sub_mem hx.2 hy.2
  rw [hdis, Submodule.mem_bot] at hmem
  exact sub_eq_zero.mp hmem

end Affine
end FunctionFieldLittlewood.TargetPreimage
