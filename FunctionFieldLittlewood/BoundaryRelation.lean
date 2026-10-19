module

public import FunctionFieldLittlewood.RootStream
public import Mathlib.Data.Matrix.Block

@[expose] public section

/-!
The algebraic part of the 19 October boundary recurrence. We use the raw named
stream (no division by H). The odd block factors through root evaluations.
The generic merge is an equivalence, including empty and unequal blocks.
No injectivity, dimension, terminal detection, or reachable-state claim is made.
-/
namespace FunctionFieldLittlewood.BoundaryRelation
open scoped BigOperators
open Matrix

variable {K : Type*} [CommRing K]

/-- A rectangular Hankel block; its first index is t, not the shift t-1. -/
def block (a : ℕ → K) (t m n : ℕ) : Matrix (Fin m) (Fin n) K :=
  fun i j => a (t + i.val + j.val)

/-- Evaluation columns, including the constant monomial and empty lengths. -/
def evalMatrix {Ω : Type*} (z : Ω → K) (m : ℕ) : Matrix (Fin m) Ω K :=
  fun i q => z q ^ i.val

/-- Odd-index blocks factor through the finitely many root moments. -/
theorem odd_block_factor {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (a : ℕ → K) (z : Ω → K) (w : Ω → K)
    (ha : ∀ l, a (2 * l + 1) = ∑ q, w q * z q ^ l) (k m n : ℕ) :
    (fun (i : Fin m) (j : Fin n) => a (2 * (k + i.val + j.val) + 1)) =
      evalMatrix z m * diagonal (fun q => w q * z q ^ k) * (evalMatrix z n)ᵀ := by
  ext i j
  rw [mul_apply]
  simp only [ha, mul_diagonal, evalMatrix, transpose_apply]
  apply Finset.sum_congr rfl
  intro q _
  simp only [pow_add]
  ring

/-- Uniform factorization for the actual Lai–Sprang support stream. The Lean
parameter r is one less than the usual valuation. No maximality is required. -/
theorem stream_odd_block_factor {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) :
    ∃ z : Fin (2 ^ r) → ZMod p, Function.Injective z ∧
      (∀ q, z q ^ (2 ^ r) = -1) ∧
      ∀ k m n,
        (fun (i : Fin m) (j : Fin n) =>
          laiSprangStream p (r + 1) (2 * (k + i.val + j.val) + 1)) =
        evalMatrix z m * diagonal (fun q => z q ^ k) * (evalMatrix z n)ᵀ := by
  obtain ⟨z, hz, hr, _, ha⟩ := RootStream.stream_root_enumeration hd
  refine ⟨z, hz, hr, ?_⟩
  intro k m n
  simpa using odd_block_factor (laiSprangStream p (r + 1)) z (fun _ => 1)
    (by simpa using ha) k m n

/-- Each even-index block is exactly a smaller block of the same named stream. -/
theorem stream_even_block (p r k m n : ℕ) :
    (fun (i : Fin m) (j : Fin n) =>
      laiSprangStream p r (2 * (k + i.val + j.val))) =
      block (laiSprangStream p r) k m n := by
  ext i j
  exact laiSprangStream_even p r _

/-- The inclusion of the odd powers into all 2H powers. -/
def oddIndex {H : ℕ} (i : Fin H) : Fin (2 * H) := ⟨2 * i.val + 1, by omega⟩

/-- Weight one on odd powers, zero on the other root coordinates. Written as
a finite pushforward so the root-sum identity needs no choice of inverse. -/
def oddWeight (H : ℕ) (q : Fin (2 * H)) : K :=
  ∑ i : Fin H, if oddIndex i = q then 1 else 0

theorem full_root_sum (ξ : K) (H l : ℕ) :
    (∑ q : Fin (2 * H), oddWeight H q * (ξ ^ q.val) ^ l) =
      ∑ i : Fin H, (ξ ^ (2 * i.val + 1)) ^ l := by
  simp only [oddWeight, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.sum_eq_single (oddIndex i)]
  · simp [oddIndex]
  · intro q _ hq
    simp [Ne.symm hq]
  · simp

/-- The raw named stream admits N distinct, complete root coordinates. The
weight selects the H odd powers; no primitive-only moment compression is used. -/
theorem stream_full_root_data {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) :
    ∃ z : Fin (2 * 2 ^ r) → ZMod p, Function.Injective z ∧
      (∀ x : ZMod p, x ^ (2 * 2 ^ r) = 1 ↔ ∃ q, x = z q) ∧
      (∃ σ : Fin (2 * 2 ^ r) → Fin (2 * 2 ^ r), ∀ q, z (σ q) = z q ^ 2) ∧
      ∀ l, laiSprangStream p (r + 1) (2 * l + 1) =
        ∑ q, oddWeight (2 ^ r) q * z q ^ l := by
  obtain ⟨ξ, hξ⟩ := RootStream.exists_primitive hd
  have hn : 2 ^ (r + 1) = 2 * 2 ^ r := by rw [pow_succ, Nat.mul_comm]
  rw [hn] at hξ
  let z : Fin (2 * 2 ^ r) → ZMod p := fun q => ξ ^ q.val
  have hz : Function.Injective z := by
    intro i j he
    exact Fin.ext (hξ.pow_inj i.isLt j.isLt he)
  have hcomplete (x : ZMod p) : x ^ (2 * 2 ^ r) = 1 ↔ ∃ q, x = z q := by
    constructor
    · intro hx
      obtain ⟨i, hi, he⟩ := hξ.eq_pow_of_pow_eq_one hx
      exact ⟨⟨i, hi⟩, he.symm⟩
    · rintro ⟨q, rfl⟩
      dsimp [z]
      rw [← pow_mul, Nat.mul_comm, pow_mul, hξ.pow_eq_one, one_pow]
  have hs (q) : ∃ q', z q ^ 2 = z q' := by
    apply (hcomplete _).mp
    rw [← pow_mul, Nat.mul_comm 2, pow_mul, (hcomplete _).mpr ⟨q, rfl⟩, one_pow]
  classical
  refine ⟨z, hz, hcomplete, ⟨fun q => (hs q).choose, fun q => (hs q).choose_spec.symm⟩, ?_⟩
  intro l
  rw [show (∑ q, oddWeight (2 ^ r) q * z q ^ l) =
      ∑ i : Fin (2 ^ r), RootStream.oddRoot ξ i ^ l from by simpa [RootStream.oddRoot] using full_root_sum ξ (2 ^ r) l]
  exact (RootStream.stream_odd p r l).trans
    (RootStream.oddRoot_sum (by positivity) hξ l).symm

section Transport
variable {Ω : Type*} [Fintype Ω] [DecidableEq Ω]

/-- Push forcing coefficients along the squaring map, with the parity weight. -/
def transport (z : Ω → K) (σ : Ω → Ω) (a : ℕ) : Matrix Ω Ω K :=
  fun q s => if σ s = q then z s ^ a else 0

/-- Restricting exponential forcing to row parity a is exact, even when
squaring is not injective: all members of each fibre are summed. -/
theorem forcing_transport (z : Ω → K) (σ : Ω → Ω)
    (hσ : ∀ q, z (σ q) = z q ^ 2) (a m : ℕ) :
    evalMatrix z m * transport z σ a =
      (fun (i : Fin m) q => z q ^ (2 * i.val + a)) := by
  ext i q
  simp [mul_apply, transport, evalMatrix, mul_ite, hσ, pow_add, pow_mul]

/-- The transpose transport reconstructs evaluations of a parity subsequence.
Together the a=0 and a=1 terms retain every parent root moment. -/
theorem moment_transport (z : Ω → K) (σ : Ω → Ω)
    (hσ : ∀ q, z (σ q) = z q ^ 2) (a n : ℕ) :
    (transport z σ a)ᵀ * (evalMatrix z n)ᵀ =
      (fun q (j : Fin n) => z q ^ (2 * j.val + a)) := by
  rw [← transpose_mul, forcing_transport z σ hσ]
  rfl

end Transport

section Merge
variable {I₀ I₁ J₀ J₁ Ω : Type*}
variable [Fintype J₀] [Fintype J₁] [Fintype Ω]

/-- Retain forcing u and moments v, not merely the kernel or its dimension. -/
def Holds {I J : Type*} [Fintype J]
    (A : Matrix I J K) (U : Matrix I Ω K) (V : Matrix Ω J K)
    (u v : Ω → K) : Prop :=
  ∃ x, A *ᵥ x = U *ᵥ u ∧ V *ᵥ x = v

/-- Column permutations preserve both equations of the boundary relation. -/
theorem holds_reindex {I J J' : Type*} [Fintype J] [Fintype J']
    (A : Matrix I J K) (U : Matrix I Ω K) (V : Matrix Ω J K)
    (e : J' ≃ J) (u v : Ω → K) :
    Holds (A.submatrix id e) U (V.submatrix id e) u v ↔ Holds A U V u v := by
  constructor
  · rintro ⟨x, ha, hv⟩
    exact ⟨x ∘ e.symm, by simpa only [submatrix_mulVec_equiv, Function.comp_id] using ha,
      by simpa only [submatrix_mulVec_equiv, Function.comp_id] using hv⟩
  · rintro ⟨x, ha, hv⟩
    refine ⟨x ∘ e, ?_, ?_⟩
    · simpa [submatrix_mulVec_equiv, Function.comp_def] using ha
    · simpa [submatrix_mulVec_equiv, Function.comp_def] using hv

def rowJoin (A : Matrix I₀ Ω K) (B : Matrix I₁ Ω K) :
    Matrix (I₀ ⊕ I₁) Ω K := Sum.elim A B

def colJoin (A : Matrix Ω J₀ K) (B : Matrix Ω J₁ K) :
    Matrix Ω (J₀ ⊕ J₁) K := fun q => Sum.elim (A q) (B q)

omit [CommRing K] [Fintype J₀] [Fintype J₁] [Fintype Ω] in
theorem colJoin_swap (A : Matrix Ω J₀ K) (B : Matrix Ω J₁ K) :
    (colJoin A B).submatrix id Sum.swap = colJoin B A := by
  ext q (j | j) <;> rfl

theorem rowJoin_mulVec (A : Matrix I₀ Ω K) (B : Matrix I₁ Ω K) (u : Ω → K) :
    rowJoin A B *ᵥ u = Sum.elim (A *ᵥ u) (B *ᵥ u) := by
  ext i
  cases i <;> rfl

omit [Fintype Ω] in
theorem colJoin_mulVec (A : Matrix Ω J₀ K) (B : Matrix Ω J₁ K)
    (x : J₀ ⊕ J₁ → K) :
    colJoin A B *ᵥ x = A *ᵥ (x ∘ Sum.inl) + B *ᵥ (x ∘ Sum.inr) := by
  ext q
  simp [colJoin, mulVec, dotProduct, Fintype.sum_sum_type]

/-- Exact two-child merge, with only u,v₀,v₁ as retained variables. D maps
forcing to each row parity; E reconstructs parent evaluations. Off-diagonal
blocks are U K V. No inverse, unique reconstruction, or rank assumption occurs.
For odd starting indices the columns are ordered odd-first to put the recursive
even-index blocks on the diagonal. The all-root D/E transport and natural-order reindexing are proved below. -/
theorem merge_iff
    (A₀ : Matrix I₀ J₀ K) (A₁ : Matrix I₁ J₁ K)
    (U₀ : Matrix I₀ Ω K) (U₁ : Matrix I₁ Ω K)
    (V₀ : Matrix Ω J₀ K) (V₁ : Matrix Ω J₁ K)
    (K₀ K₁ D₀ D₁ E₀ E₁ : Matrix Ω Ω K) (u v : Ω → K) :
    Holds (fromBlocks A₀ (U₀ * K₀ * V₁) (U₁ * K₁ * V₀) A₁)
      (rowJoin (U₀ * D₀) (U₁ * D₁))
      (colJoin (E₀ * V₀) (E₁ * V₁)) u v ↔
    ∃ v₀ v₁,
      Holds A₀ U₀ V₀ (D₀ *ᵥ u - K₀ *ᵥ v₁) v₀ ∧
      Holds A₁ U₁ V₁ (D₁ *ᵥ u - K₁ *ᵥ v₀) v₁ ∧
      E₀ *ᵥ v₀ + E₁ *ᵥ v₁ = v := by
  constructor
  · rintro ⟨x, hx, hv⟩
    let x₀ := x ∘ Sum.inl
    let x₁ := x ∘ Sum.inr
    have h₀ : A₀ *ᵥ x₀ + U₀ *ᵥ (K₀ *ᵥ (V₁ *ᵥ x₁)) = U₀ *ᵥ (D₀ *ᵥ u) := by
      simpa only [fromBlocks_mulVec, rowJoin_mulVec, ← mulVec_mulVec,
        Sum.elim_comp_inl, Sum.elim_comp_inr] using
        congrArg (fun f => f ∘ Sum.inl) hx
    have h₁ : U₁ *ᵥ (K₁ *ᵥ (V₀ *ᵥ x₀)) + A₁ *ᵥ x₁ = U₁ *ᵥ (D₁ *ᵥ u) := by
      simpa only [fromBlocks_mulVec, rowJoin_mulVec, ← mulVec_mulVec,
        Sum.elim_comp_inl, Sum.elim_comp_inr] using
        congrArg (fun f => f ∘ Sum.inr) hx
    refine ⟨V₀ *ᵥ x₀, V₁ *ᵥ x₁, ⟨x₀, ?_, rfl⟩, ⟨x₁, ?_, rfl⟩, ?_⟩
    · rw [mulVec_sub]
      exact eq_sub_iff_add_eq.mpr h₀
    · rw [mulVec_sub]
      exact eq_sub_iff_add_eq.mpr (by simpa only [add_comm] using h₁)
    · simpa only [colJoin_mulVec, ← mulVec_mulVec] using hv
  · rintro ⟨v₀, v₁, ⟨x₀, h₀, hv₀⟩, ⟨x₁, h₁, hv₁⟩, hv⟩
    refine ⟨Sum.elim x₀ x₁, ?_, ?_⟩
    · rw [fromBlocks_mulVec, rowJoin_mulVec]
      simp only [← mulVec_mulVec, Sum.elim_comp_inl, Sum.elim_comp_inr, hv₀, hv₁]
      rw [h₀, h₁, mulVec_sub, mulVec_sub, sub_add_cancel, add_sub_cancel]
    · simpa only [colJoin_mulVec, ← mulVec_mulVec, Sum.elim_comp_inl,
        Sum.elim_comp_inr, hv₀, hv₁] using hv

end Merge

section Parity
variable {Ω : Type*} [Fintype Ω] [DecidableEq Ω]

/-- The original natural index of each parity coordinate. The two Fin lengths
are independent, so zero dimensions and either nearly-square endpoint work. -/
def parityIndex {m₀ m₁ : ℕ} : Fin m₀ ⊕ Fin m₁ → ℕ :=
  Sum.elim (fun i => 2 * i.val) (fun i => 2 * i.val + 1)

/-- Exact parity reindexing for an arbitrary length, including zero. -/
def parityEquiv (m : ℕ) : (Fin ((m + 1) / 2) ⊕ Fin (m / 2)) ≃ Fin m where
  toFun i := match i with
    | Sum.inl i => ⟨2 * i.val, by omega⟩
    | Sum.inr i => ⟨2 * i.val + 1, by omega⟩
  invFun j := if h : j.val % 2 = 0 then
      Sum.inl ⟨j.val / 2, by omega⟩
    else Sum.inr ⟨j.val / 2, by omega⟩
  left_inv i := by
    cases i with
    | inl i =>
      simp only [show (2 * i.val) % 2 = 0 by omega, dite_true]
      congr 1
      apply Fin.ext
      simp
    | inr i =>
      simp only [show (2 * i.val + 1) % 2 ≠ 0 by omega, dite_false]
      congr 1
      apply Fin.ext
      dsimp
      omega
  right_inv j := by
    dsimp only
    split_ifs <;> apply Fin.ext <;> dsimp <;> omega

theorem parityEquiv_val (m : ℕ) (i) :
    (parityEquiv m i).val = parityIndex i := by
  cases i <;> rfl

def parityEval (z : Ω → K) (m₀ m₁ : ℕ) : Matrix (Fin m₀ ⊕ Fin m₁) Ω K :=
  fun i q => z q ^ parityIndex i

def parityBlock (a : ℕ → K) (t m₀ m₁ n₀ n₁ : ℕ) :
    Matrix (Fin m₀ ⊕ Fin m₁) (Fin n₀ ⊕ Fin n₁) K :=
  fun i j => a (t + parityIndex i + parityIndex j)

omit [DecidableEq Ω] in
/-- The parity-coordinate relation is exactly the original m-by-n relation.
This fixes both endpoint budgets and does not assume m=n or positive sizes. -/
theorem natural_holds_iff (a : ℕ → K) (z : Ω → K) (t m n : ℕ) (u v : Ω → K) :
    Holds (block a t m n) (evalMatrix z m) (evalMatrix z n)ᵀ u v ↔
    Holds (parityBlock a t ((m + 1) / 2) (m / 2) ((n + 1) / 2) (n / 2))
      (parityEval z ((m + 1) / 2) (m / 2))
      (parityEval z ((n + 1) / 2) (n / 2))ᵀ u v := by
  rw [← holds_reindex _ _ _ (parityEquiv n) u v]
  have hA : (block a t m n).submatrix (parityEquiv m) (parityEquiv n) =
      parityBlock a t ((m + 1) / 2) (m / 2) ((n + 1) / 2) (n / 2) := by
    ext i j
    simp [block, submatrix_apply, parityBlock, parityEquiv_val]
  have hU : (evalMatrix z m).submatrix (parityEquiv m) id =
      parityEval z ((m + 1) / 2) (m / 2) := by
    ext i q
    simp [evalMatrix, submatrix_apply, parityEval, parityEquiv_val]
  have hV : (evalMatrix z n)ᵀ.submatrix id (parityEquiv n) =
      (parityEval z ((n + 1) / 2) (n / 2))ᵀ := by
    ext q j
    simp [evalMatrix, submatrix_apply, parityEval, parityEquiv_val]
  rw [← hA, ← hU, ← hV]
  constructor
  · rintro ⟨x, ha, hv⟩
    refine ⟨x, ?_, hv⟩
    funext i
    exact congrFun ha (parityEquiv m i)
  · rintro ⟨x, ha, hv⟩
    refine ⟨x, ?_, hv⟩
    funext i
    obtain ⟨j, rfl⟩ := (parityEquiv m).surjective i
    exact congrFun ha j

theorem parity_forcing (z : Ω → K) (σ : Ω → Ω)
    (hσ : ∀ q, z (σ q) = z q ^ 2) (m₀ m₁ : ℕ) :
    parityEval z m₀ m₁ =
      rowJoin (evalMatrix z m₀ * transport z σ 0)
        (evalMatrix z m₁ * transport z σ 1) := by
  rw [forcing_transport z σ hσ, forcing_transport z σ hσ]
  ext (i | i) q <;> simp [parityEval, parityIndex, rowJoin]

theorem parity_moments (z : Ω → K) (σ : Ω → Ω)
    (hσ : ∀ q, z (σ q) = z q ^ 2) (n₀ n₁ : ℕ) :
    (parityEval z n₀ n₁)ᵀ =
      colJoin ((transport z σ 0)ᵀ * (evalMatrix z n₀)ᵀ)
        ((transport z σ 1)ᵀ * (evalMatrix z n₁)ᵀ) := by
  rw [moment_transport z σ hσ, moment_transport z σ hσ]
  ext q (j | j) <;> simp [parityEval, parityIndex, colJoin]

/-- Both row budgets are exact; no last row is discarded in this identity. -/
theorem even_blocks (a : ℕ → K) (z w : Ω → K)
    (he : ∀ l, a (2 * l) = a l)
    (ho : ∀ l, a (2 * l + 1) = ∑ q, w q * z q ^ l)
    (k m₀ m₁ n₀ n₁ : ℕ) :
    parityBlock a (2 * k) m₀ m₁ n₀ n₁ =
      fromBlocks (block a k m₀ n₀)
        (evalMatrix z m₀ * diagonal (fun q => w q * z q ^ k) * (evalMatrix z n₁)ᵀ)
        (evalMatrix z m₁ * diagonal (fun q => w q * z q ^ k) * (evalMatrix z n₀)ᵀ)
        (block a (k + 1) m₁ n₁) := by
  rw [← odd_block_factor a z w ho, ← odd_block_factor a z w ho]
  ext (i | i) (j | j) <;>
    dsimp [parityBlock, parityIndex, Matrix.fromBlocks, block]
  · rw [show 2 * k + 2 * i.val + 2 * j.val = 2 * (k + i.val + j.val) by omega, he]
  · congr 1; omega
  · congr 1; omega
  · rw [show 2 * k + (2 * i.val + 1) + (2 * j.val + 1) =
        2 * (k + 1 + i.val + j.val) by omega, he]

/-- At an odd start, swap the column parity groups so recursive blocks stay
on the diagonal. The two odd blocks have different offsets k and k+1. -/
theorem odd_blocks (a : ℕ → K) (z w : Ω → K)
    (he : ∀ l, a (2 * l) = a l)
    (ho : ∀ l, a (2 * l + 1) = ∑ q, w q * z q ^ l)
    (k m₀ m₁ n₀ n₁ : ℕ) :
    (parityBlock a (2 * k + 1) m₀ m₁ n₀ n₁).submatrix id Sum.swap =
      fromBlocks (block a (k + 1) m₀ n₁)
        (evalMatrix z m₀ * diagonal (fun q => w q * z q ^ k) * (evalMatrix z n₀)ᵀ)
        (evalMatrix z m₁ * diagonal (fun q => w q * z q ^ (k + 1)) * (evalMatrix z n₁)ᵀ)
        (block a (k + 1) m₁ n₀) := by
  rw [← odd_block_factor a z w ho, ← odd_block_factor a z w ho]
  ext (i | i) (j | j) <;>
    dsimp [Matrix.submatrix, parityBlock, parityIndex, Matrix.fromBlocks, block]
  · rw [show 2 * k + 1 + 2 * i.val + (2 * j.val + 1) =
        2 * (k + 1 + i.val + j.val) by omega, he]
  · congr 1; omega
  · congr 1; omega
  · rw [show 2 * k + 1 + (2 * i.val + 1) + 2 * j.val =
        2 * (k + 1 + i.val + j.val) by omega, he]

/-- The full exact recurrence at an even starting index, in parity coordinates.
The raw named stream supplies he/ho via its proved even recurrence and
stream_full_root_data. There are exactly three retained Ω-vectors u,v₀,v₁. -/
theorem even_merge (a : ℕ → K) (z w : Ω → K) (σ : Ω → Ω)
    (he : ∀ l, a (2 * l) = a l)
    (ho : ∀ l, a (2 * l + 1) = ∑ q, w q * z q ^ l)
    (hσ : ∀ q, z (σ q) = z q ^ 2)
    (k m₀ m₁ n₀ n₁ : ℕ) (u v : Ω → K) :
    Holds (parityBlock a (2 * k) m₀ m₁ n₀ n₁)
      (parityEval z m₀ m₁) (parityEval z n₀ n₁)ᵀ u v ↔
    ∃ v₀ v₁,
      Holds (block a k m₀ n₀) (evalMatrix z m₀) (evalMatrix z n₀)ᵀ
        (transport z σ 0 *ᵥ u - diagonal (fun q => w q * z q ^ k) *ᵥ v₁) v₀ ∧
      Holds (block a (k + 1) m₁ n₁) (evalMatrix z m₁) (evalMatrix z n₁)ᵀ
        (transport z σ 1 *ᵥ u - diagonal (fun q => w q * z q ^ k) *ᵥ v₀) v₁ ∧
      (transport z σ 0)ᵀ *ᵥ v₀ + (transport z σ 1)ᵀ *ᵥ v₁ = v := by
  rw [even_blocks a z w he ho, parity_forcing z σ hσ, parity_moments z σ hσ]
  exact merge_iff _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- The odd-start recurrence, including the column swap and its moment swap.
The existential order is odd moments first, then even moments. In particular
the second odd-index block uses k+1, not k. -/
theorem odd_merge (a : ℕ → K) (z w : Ω → K) (σ : Ω → Ω)
    (he : ∀ l, a (2 * l) = a l)
    (ho : ∀ l, a (2 * l + 1) = ∑ q, w q * z q ^ l)
    (hσ : ∀ q, z (σ q) = z q ^ 2)
    (k m₀ m₁ n₀ n₁ : ℕ) (u v : Ω → K) :
    Holds (parityBlock a (2 * k + 1) m₀ m₁ n₀ n₁)
      (parityEval z m₀ m₁) (parityEval z n₀ n₁)ᵀ u v ↔
    ∃ v₁ v₀,
      Holds (block a (k + 1) m₀ n₁) (evalMatrix z m₀) (evalMatrix z n₁)ᵀ
        (transport z σ 0 *ᵥ u - diagonal (fun q => w q * z q ^ k) *ᵥ v₀) v₁ ∧
      Holds (block a (k + 1) m₁ n₀) (evalMatrix z m₁) (evalMatrix z n₀)ᵀ
        (transport z σ 1 *ᵥ u - diagonal (fun q => w q * z q ^ (k + 1)) *ᵥ v₁) v₀ ∧
      (transport z σ 1)ᵀ *ᵥ v₁ + (transport z σ 0)ᵀ *ᵥ v₀ = v := by
  rw [← holds_reindex _ _ _ (Equiv.sumComm (Fin n₁) (Fin n₀)) u v]
  change Holds ((parityBlock a (2 * k + 1) m₀ m₁ n₀ n₁).submatrix id Sum.swap)
    (parityEval z m₀ m₁) ((parityEval z n₀ n₁)ᵀ.submatrix id Sum.swap) u v ↔ _
  rw [odd_blocks a z w he ho, parity_forcing z σ hσ, parity_moments z σ hσ,
    colJoin_swap]
  exact merge_iff _ _ _ _ _ _ _ _ _ _ _ _ _ _

end Parity
end FunctionFieldLittlewood.BoundaryRelation
