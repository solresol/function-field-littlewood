module

public import FunctionFieldLittlewood.TerminalDetection
public import Mathlib.LinearAlgebra.Dual.Lemmas

@[expose] public section

/-!
Bordered reconstruction of actual Lai--Sprang boundary relations. The generic
argument needs only injectivity of the wide stacked Hankel/evaluation map.
The named stream discharges that hypothesis by the proved Proposition 2.3.
No Hankel inverse, terminal acceptance, or relation dimension is assumed.
-/
namespace FunctionFieldLittlewood.BorderedRelation
open scoped BigOperators
open Matrix BoundaryRelation

variable {K Ω : Type*} [Field K] [Fintype Ω]

/-- The existing forcing/moment predicate as a linear subspace. -/
def space (a : ℕ → K) (z : Ω → K) (t m n : ℕ) :
    Submodule K ((Ω → K) × (Ω → K)) where
  carrier := {uv | CorrelatedState.relation a z t m n uv.1 uv.2}
  zero_mem' := ⟨0, by simp, by simp⟩
  add_mem' := by
    rintro uv uv' ⟨x, hx, hv⟩ ⟨x', hx', hv'⟩
    exact ⟨x + x', by simp [mulVec_add, hx, hx'], by simp [mulVec_add, hv, hv']⟩
  smul_mem' := by
    rintro c uv ⟨x, hx, hv⟩
    exact ⟨c • x, by simp [mulVec_smul, hx], by simp [mulVec_smul, hv]⟩

@[simp] theorem mem_space (a : ℕ → K) (z : Ω → K) (t m n : ℕ)
    (uv : (Ω → K) × (Ω → K)) :
    uv ∈ space a z t m n ↔ CorrelatedState.relation a z t m n uv.1 uv.2 := Iff.rfl

theorem block_snoc (a : ℕ → K) (t m n : ℕ) (x : Fin n → K) (y : K) (i : Fin m) :
    (block a t m (n + 1) *ᵥ Fin.snoc x y) i =
      (block a t m n *ᵥ x) i + a (t + i.val + n) * y := by
  simp [mulVec, dotProduct, Fin.sum_univ_castSucc, block]

omit [Fintype Ω] in
theorem eval_snoc (z : Ω → K) (n : ℕ) (x : Fin n → K) (y : K) (q : Ω) :
    ((evalMatrix z (n + 1))ᵀ *ᵥ Fin.snoc x y) q =
      ((evalMatrix z n)ᵀ *ᵥ x) q + z q ^ n * y := by
  simp [mulVec, dotProduct, Fin.sum_univ_castSucc, evalMatrix]

theorem block_castSucc (a : ℕ → K) (t m n : ℕ) (x : Fin n → K) (i : Fin m) :
    (block a t (m + 1) n *ᵥ x) i.castSucc = (block a t m n *ᵥ x) i := rfl

theorem eval_castSucc (z : Ω → K) (m : ℕ) (u : Ω → K) (i : Fin m) :
    (evalMatrix z (m + 1) *ᵥ u) i.castSucc = (evalMatrix z m *ᵥ u) i := rfl

/-- The special-stream property actually needed by bordering: coefficient
preimages of every wide boundary pair are unique, including zero rows. -/
def NoInvisible (a : ℕ → K) (z : Ω → K) (t k : ℕ) : Prop :=
  ∀ x : Fin (k + 1) → K,
    block a t k (k + 1) *ᵥ x = 0 → (evalMatrix z (k + 1))ᵀ *ᵥ x = 0 → x = 0

omit [Fintype Ω] in
theorem wide_preimage_unique (a : ℕ → K) (z : Ω → K) (t k : ℕ)
    (hn : NoInvisible a z t k) (x y : Fin (k + 1) → K)
    (ha : block a t k (k + 1) *ᵥ x = block a t k (k + 1) *ᵥ y)
    (hv : (evalMatrix z (k + 1))ᵀ *ᵥ x = (evalMatrix z (k + 1))ᵀ *ᵥ y) : x = y := by
  exact sub_eq_zero.mp (hn (x - y) (by rw [mulVec_sub, ha, sub_self])
    (by rw [mulVec_sub, hv, sub_self]))

private theorem dual_apply (φ : (Fin k → K) →ₗ[K] K) (x : Fin k → K) :
    φ x = (fun i => φ (Pi.single i 1)) ⬝ᵥ x := by
  conv_lhs => rw [← LinearMap.sum_single_apply (fun _ : Fin k => K) x]
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro i _
  rw [show Pi.single i (x i) = x i • Pi.single i (1 : K) by
      ext j
      by_cases hj : j = i <;> simp [hj],
    map_smul, smul_eq_mul, mul_comm]

/-- Some small-square solution has a nonzero final-row defect. Otherwise
duality constructs a nonzero invisible vector in the wide block. -/
theorem border_defect_exists (a : ℕ → K) (z : Ω → K) (t k : ℕ)
    (hn : NoInvisible a z t k) :
    ∃ (x : Fin k → K) (u : Ω → K),
      block a t k k *ᵥ x = evalMatrix z k *ᵥ u ∧
      (∑ i, a (t + k + i.val) * x i) - (∑ q, z q ^ k * u q) ≠ 0 := by
  classical
  let A := block a t k k
  let U := evalMatrix z k
  let b : Fin k → K := fun i => a (t + k + i.val)
  let w : Ω → K := fun q => z q ^ k
  let C : ((Fin k → K) × (Ω → K)) →ₗ[K] (Fin k → K) :=
    A.mulVecLin.comp (LinearMap.fst K _ _) - U.mulVecLin.comp (LinearMap.snd K _ _)
  let d : ((Fin k → K) × (Ω → K)) →ₗ[K] K :=
    (dotProductBilin K K b).comp (LinearMap.fst K _ _) -
      (dotProductBilin K K w).comp (LinearMap.snd K _ _)
  by_contra! h
  have hd : d ∈ (LinearMap.ker C).dualAnnihilator := by
    rw [Submodule.mem_dualAnnihilator]
    rintro ⟨x, u⟩ hx
    have hc : A *ᵥ x = U *ᵥ u := sub_eq_zero.mp hx
    exact h x u hc
  rw [← LinearMap.range_dualMap_eq_dualAnnihilator_ker] at hd
  obtain ⟨φ, hφ⟩ := hd
  let l : Fin k → K := fun i => φ (Pi.single i 1)
  have he (x : Fin k → K) (u : Ω → K) :
      l ⬝ᵥ (A *ᵥ x - U *ᵥ u) = b ⬝ᵥ x - w ⬝ᵥ u := by
    have hh := congrArg (fun f : Module.Dual K ((Fin k → K) × (Ω → K)) => f (x, u)) hφ
    change φ (A *ᵥ x - U *ᵥ u) = b ⬝ᵥ x - w ⬝ᵥ u at hh
    rw [dual_apply] at hh
    exact hh
  have hb (i : Fin k) : (A *ᵥ l) i = b i := by
    have hh := he (Pi.single i 1) 0
    simp only [mulVec_single_one, mulVec_zero, sub_zero, dotProduct_zero,
      dotProduct_single_one] at hh
    simpa only [mulVec, dotProduct, Matrix.col, transpose_apply, A, block, Nat.add_assoc, Nat.add_left_comm,
      Nat.add_comm, mul_comm] using hh
  have hw (q : Ω) : ((evalMatrix z k)ᵀ *ᵥ l) q = w q := by
    have hh := he 0 (Pi.single q 1)
    simp only [mulVec_zero, mulVec_single_one, zero_sub, dotProduct_neg,
      dotProduct_zero, dotProduct_single_one, neg_inj] at hh
    simpa only [mulVec, dotProduct, transpose_apply, Matrix.col, U, mul_comm] using hh
  have hx : @Fin.snoc k (fun _ => K) (-l) 1 = 0 := by
    apply hn
    · ext i
      rw [block_snoc, mulVec_neg, Pi.neg_apply]
      change -(A *ᵥ l) i + a (t + i.val + k) * 1 = 0
      rw [hb]
      simp [b, Nat.add_left_comm, Nat.add_comm]
    · ext q
      rw [eval_snoc, mulVec_neg, Pi.neg_apply, hw]
      simp [w]
  have hh := congrFun hx (Fin.last k)
  simp at hh

theorem small_le_wide (a : ℕ → K) (z : Ω → K) (t k : ℕ) :
    space a z t k k ≤ space a z t k (k + 1) := by
  rintro uv ⟨x, hx, hv⟩
  refine ⟨Fin.snoc x 0, ?_, ?_⟩
  · ext i
    simpa [block_snoc] using congrFun hx i
  · ext q
    simpa [eval_snoc] using congrFun hv q

theorem large_le_wide (a : ℕ → K) (z : Ω → K) (t k : ℕ) :
    space a z t (k + 1) (k + 1) ≤ space a z t k (k + 1) := by
  rintro uv ⟨x, hx, hv⟩
  refine ⟨x, ?_, hv⟩
  ext i
  exact congrFun hx i.castSucc

theorem tall_le_small (a : ℕ → K) (z : Ω → K) (t k : ℕ) :
    space a z t (k + 1) k ≤ space a z t k k := by
  rintro uv ⟨x, hx, hv⟩
  refine ⟨x, ?_, hv⟩
  ext i
  exact congrFun hx i.castSucc

theorem tall_le_large (a : ℕ → K) (z : Ω → K) (t k : ℕ) :
    space a z t (k + 1) k ≤ space a z t (k + 1) (k + 1) := by
  rintro uv ⟨x, hx, hv⟩
  refine ⟨Fin.snoc x 0, ?_, ?_⟩
  · ext i
    simpa [block_snoc] using congrFun hx i
  · ext q
    simpa [eval_snoc] using congrFun hv q

/-- Intersection reconstructs the tall relation using unique wide preimages. -/
theorem tall_eq_inf (a : ℕ → K) (z : Ω → K) (t k : ℕ)
    (hn : NoInvisible a z t k) :
    space a z t (k + 1) k = space a z t k k ⊓ space a z t (k + 1) (k + 1) := by
  apply le_antisymm
  · exact le_inf (tall_le_small a z t k) (tall_le_large a z t k)
  · rintro uv ⟨hs, hl⟩
    obtain ⟨x, hx, hv⟩ := hs
    obtain ⟨y, hy, hyv⟩ := hl
    have he : y = Fin.snoc x 0 := by
      apply wide_preimage_unique a z t k hn
      · ext i
        rw [block_snoc]
        simpa only [block_castSucc, mul_zero, add_zero] using
          (congrFun hy i.castSucc).trans (congrFun hx i).symm
      · ext q
        rw [eval_snoc]
        simpa using (congrFun hyv q).trans (congrFun hv q).symm
    refine ⟨x, ?_, hv⟩
    ext i
    have hh := congrFun hy i
    rw [he, block_snoc] at hh
    simpa using hh

/-- The final equation omitted from a wide block. -/
def defect (a : ℕ → K) (z : Ω → K) (t k : ℕ)
    (x : Fin (k + 1) → K) (u : Ω → K) : K :=
  (block a t (k + 1) (k + 1) *ᵥ x) (Fin.last k) -
    (evalMatrix z (k + 1) *ᵥ u) (Fin.last k)

theorem defect_pad (a : ℕ → K) (z : Ω → K) (t k : ℕ)
    (x : Fin k → K) (u : Ω → K) :
    defect a z t k (Fin.snoc x 0) u =
      (∑ i, a (t + k + i.val) * x i) - (∑ q, z q ^ k * u q) := by
  unfold defect
  rw [block_snoc]
  simp [mulVec, dotProduct, block, evalMatrix]

theorem defect_sub_smul (a : ℕ → K) (z : Ω → K) (t k : ℕ)
    (x y : Fin (k + 1) → K) (u v : Ω → K) (c : K) :
    defect a z t k (x - c • y) (u - c • v) =
      defect a z t k x u - c * defect a z t k y v := by
  simp only [defect, mulVec_sub, mulVec_smul, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  ring

theorem large_of_defect_zero (a : ℕ → K) (z : Ω → K) (t k : ℕ)
    (x : Fin (k + 1) → K) (u v : Ω → K)
    (hx : block a t k (k + 1) *ᵥ x = evalMatrix z k *ᵥ u)
    (hv : (evalMatrix z (k + 1))ᵀ *ᵥ x = v)
    (hd : defect a z t k x u = 0) : (u, v) ∈ space a z t (k + 1) (k + 1) := by
  refine ⟨x, ?_, hv⟩
  ext i
  refine Fin.lastCases ?_ (fun j => congrFun hx j) i
  exact sub_eq_zero.mp hd

/-- The sum identity is constructive: one nonzero border defect corrects the
missing final row of any wide solution. No dimension formula is used. -/
theorem wide_eq_sup (a : ℕ → K) (z : Ω → K) (t k : ℕ)
    (hn : NoInvisible a z t k) :
    space a z t k (k + 1) = space a z t k k ⊔ space a z t (k + 1) (k + 1) := by
  apply le_antisymm
  · obtain ⟨s, u₀, hs, hd⟩ := border_defect_exists a z t k hn
    let y : Fin (k + 1) → K := Fin.snoc s 0
    let v₀ := (evalMatrix z k)ᵀ *ᵥ s
    have hsmall : (u₀, v₀) ∈ space a z t k k := ⟨s, hs, rfl⟩
    have hy : block a t k (k + 1) *ᵥ y = evalMatrix z k *ᵥ u₀ := by
      ext i
      simpa [y, block_snoc] using congrFun hs i
    have hyv : (evalMatrix z (k + 1))ᵀ *ᵥ y = v₀ := by
      ext q
      simp [y, v₀, eval_snoc]
    have hyne : defect a z t k y u₀ ≠ 0 := by simpa only [y, defect_pad] using hd
    rintro ⟨u, v⟩ ⟨x, hx, hv⟩
    let c := defect a z t k x u / defect a z t k y u₀
    have hl : (u - c • u₀, v - c • v₀) ∈ space a z t (k + 1) (k + 1) := by
      apply large_of_defect_zero a z t k (x - c • y)
      · rw [mulVec_sub, mulVec_smul, hx, hy, mulVec_sub, mulVec_smul]
      · rw [mulVec_sub, mulVec_smul, hv, hyv]
      · rw [defect_sub_smul]
        exact sub_eq_zero.mpr (div_mul_cancel₀ _ hyne).symm
    apply Submodule.mem_sup.mpr
    refine ⟨c • (u₀, v₀), (space a z t k k).smul_mem c hsmall,
      (u - c • u₀, v - c • v₀), hl, ?_⟩
    ext <;> simp
  · exact sup_le (small_le_wide a z t k) (large_le_wide a z t k)

/-- Equality of the adjacent squares would erase the nonzero border defect. -/
theorem adjacent_ne (a : ℕ → K) (z : Ω → K) (t k : ℕ)
    (hn : NoInvisible a z t k) : space a z t k k ≠ space a z t (k + 1) (k + 1) := by
  obtain ⟨x, u, hx, hd⟩ := border_defect_exists a z t k hn
  intro he
  have hs : (u, (evalMatrix z k)ᵀ *ᵥ x) ∈ space a z t k k := ⟨x, hx, rfl⟩
  rw [he] at hs
  obtain ⟨y, hy, hv⟩ := hs
  have heq : y = Fin.snoc x 0 := by
    apply wide_preimage_unique a z t k hn
    · ext i
      rw [block_snoc]
      simpa only [block_castSucc, mul_zero, add_zero] using
        (congrFun hy i.castSucc).trans (congrFun hx i).symm
    · ext q
      rw [eval_snoc]
      simpa using congrFun hv q
  have hz : defect a z t k (Fin.snoc x 0) u = 0 := by
    rw [← heq]
    exact sub_eq_zero.mpr (congrFun hy (Fin.last k))
  exact hd ((defect_pad a z t k x u).symm.trans hz)

/-- Every admissible prime, all shifts, empty sizes, and r=1. The parameter r
is one less than the usual two-adic valuation, as in the existing modules. -/
theorem stream_noInvisible {p r l : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * l + 1))
    (z : Fin (2 * 2 ^ r) → ZMod p) (hi : Function.Injective z)
    (hz : ∀ i, z i ^ (2 * 2 ^ r) = 1) (m k : ℕ) :
    NoInvisible (laiSprangStream p (r + 1)) z (m + 1) k := by
  intro x hx hv
  exact TerminalDetection.stream_no_invisible hp horder z hi hz m k k le_rfl x hx hv

/-- Exact adjacent-square reconstruction for the infinite named stream, with
the stacked-injectivity premise proved rather than assumed. -/
theorem stream_bordered_reconstruction {p r l : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * l + 1))
    (z : Fin (2 * 2 ^ r) → ZMod p) (hi : Function.Injective z)
    (hz : ∀ i, z i ^ (2 * 2 ^ r) = 1) (m k : ℕ) :
    let a := laiSprangStream p (r + 1)
    space a z (m + 1) k k ≠ space a z (m + 1) (k + 1) (k + 1) ∧
    space a z (m + 1) k (k + 1) =
      space a z (m + 1) k k ⊔ space a z (m + 1) (k + 1) (k + 1) ∧
    space a z (m + 1) (k + 1) k =
      space a z (m + 1) k k ⊓ space a z (m + 1) (k + 1) (k + 1) := by
  have hn := stream_noInvisible hp horder z hi hz m k
  exact ⟨adjacent_ne _ z _ k hn, wide_eq_sup _ z _ k hn, tall_eq_inf _ z _ k hn⟩

/-- Four actual square subspaces determine all eight predicates, even when
the two realized states have different shifts and sizes. This does not combine
independently chosen child relations or assert terminal reachability. -/
theorem stream_tuple_eq_of_squares {p r l : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * l + 1))
    (z : Fin (2 * 2 ^ r) → ZMod p) (hi : Function.Injective z)
    (hz : ∀ i, z i ^ (2 * 2 ^ r) = 1) (q k q' k' : ℕ)
    (hs : ∀ d i : CorrelatedState.Bit,
      space (laiSprangStream p (r + 1)) z (q + 1 + d.val) (k + i.val) (k + i.val) =
      space (laiSprangStream p (r + 1)) z (q' + 1 + d.val) (k' + i.val) (k' + i.val)) :
    CorrelatedState.tuple (laiSprangStream p (r + 1)) z q k =
      CorrelatedState.tuple (laiSprangStream p (r + 1)) z q' k' := by
  have he (d i j : CorrelatedState.Bit) :
      space (laiSprangStream p (r + 1)) z (q + 1 + d.val) (k + i.val) (k + j.val) =
      space (laiSprangStream p (r + 1)) z (q' + 1 + d.val) (k' + i.val) (k' + j.val) := by
    have hn := stream_noInvisible hp horder z hi hz (q + d.val) k
    have hn' := stream_noInvisible hp horder z hi hz (q' + d.val) k'
    have hw := wide_eq_sup _ z _ k hn
    have hw' := wide_eq_sup _ z _ k' hn'
    have ht := tall_eq_inf _ z _ k hn
    have ht' := tall_eq_inf _ z _ k' hn'
    simp only [Nat.add_right_comm q d.val 1] at hn hw ht
    simp only [Nat.add_right_comm q' d.val 1] at hn' hw' ht'
    have h0 := hs d 0
    have h1 := hs d 1
    simp only [Fin.val_zero, Fin.val_one, Nat.add_zero] at h0 h1
    fin_cases i <;> fin_cases j
    · exact h0
    · simpa only [Fin.val_zero, Fin.val_one, Nat.add_zero] using
        hw.trans ((congrArg₂ (· ⊔ ·) h0 h1).trans hw'.symm)
    · simpa only [Fin.val_zero, Fin.val_one, Nat.add_zero] using
        ht.trans ((congrArg₂ (· ⊓ ·) h0 h1).trans ht'.symm)
    · exact h1
  funext d i j u v
  exact propext (show (u, v) ∈ space _ z _ _ _ ↔ (u, v) ∈ space _ z _ _ _ from
    (he d i j) ▸ Iff.rfl)

end FunctionFieldLittlewood.BorderedRelation
