module

public import FunctionFieldLittlewood.BoundaryRelation
public import Mathlib.Data.Fintype.Sets

@[expose] public section

/-!
Correlated eight-relation closure from the ordinary 21 October argument.
All children come from one input tuple. This module uses raw coefficients;
it does not assume Proposition 2.3 or identify target membership with sharpness.
-/
namespace FunctionFieldLittlewood.CorrelatedState
open scoped BigOperators
open Matrix BoundaryRelation

abbrev Bit := Fin 2
abbrev Relation (K Ω : Type*) := (Ω → K) → (Ω → K) → Prop
abbrev Tuple (K Ω : Type*) := Bit → Bit → Bit → Relation K Ω

variable {K Ω : Type*} [CommRing K] [Fintype Ω] [DecidableEq Ω]

def relation (a : ℕ → K) (z : Ω → K) (t m n : ℕ) : Relation K Ω :=
  Holds (block a t m n) (evalMatrix z m) (evalMatrix z n)ᵀ

def tuple (a : ℕ → K) (z : Ω → K) (q k : ℕ) : Tuple K Ω :=
  fun d i j => relation a z (q + 1 + d.val) (k + i.val) (k + j.val)

/-- Exact half-length offsets, including the empty parity group. -/
def half (η i parity : Bit) : Bit :=
  ⟨(η.val + i.val + 1 - parity.val) / 2, by omega⟩

/-- The two outer shift cases have the same child shift for both row parities. -/
def carry (ε d : Bit) : Bit := ⟨(ε.val + d.val) / 2, by omega⟩

theorem half_length (k : ℕ) (η i parity : Bit) :
    (2 * k + η.val + i.val + 1 - parity.val) / 2 = k + (half η i parity).val := by
  dsimp [half]
  omega

def mergeEven (z w : Ω → K) (σ : Ω → Ω) (s : ℕ)
    (R₀ R₁ : Relation K Ω) : Relation K Ω := fun u v =>
  ∃ v₀ v₁,
    R₀ (transport z σ 0 *ᵥ u - diagonal (fun q => w q * z q ^ s) *ᵥ v₁) v₀ ∧
    R₁ (transport z σ 1 *ᵥ u - diagonal (fun q => w q * z q ^ s) *ᵥ v₀) v₁ ∧
    (transport z σ 0)ᵀ *ᵥ v₀ + (transport z σ 1)ᵀ *ᵥ v₁ = v

def mergeOdd (z w : Ω → K) (σ : Ω → Ω) (s : ℕ)
    (R₀ R₁ : Relation K Ω) : Relation K Ω := fun u v =>
  ∃ v₁ v₀,
    R₀ (transport z σ 0 *ᵥ u - diagonal (fun q => w q * z q ^ s) *ᵥ v₀) v₁ ∧
    R₁ (transport z σ 1 *ᵥ u - diagonal (fun q => w q * z q ^ (s + 1)) *ᵥ v₁) v₀ ∧
    (transport z σ 1)ᵀ *ᵥ v₁ + (transport z σ 0)ᵀ *ᵥ v₀ = v

/-- The transition reads one whole tuple and a phase; it cannot mix parents.
The middle case is even-start, and the two outer cases are odd-start. -/
def tupleStep (z w : Ω → K) (σ : Ω → Ω) (phase : ℕ)
    (T : Tuple K Ω) (ε η : Bit) : Tuple K Ω := fun d i j =>
  if ε.val + d.val = 1 then
    mergeEven z w σ (phase + 1)
      (T 0 (half η i 0) (half η j 0))
      (T 1 (half η i 1) (half η j 1))
  else
    mergeOdd z w σ (phase + (carry ε d).val)
      (T (carry ε d) (half η i 0) (half η j 1))
      (T (carry ε d) (half η i 1) (half η j 0))

section Recurrence
variable (a : ℕ → K) (z w : Ω → K) (σ : Ω → Ω)
variable (he : ∀ l, a (2 * l) = a l)
variable (ho : ∀ l, a (2 * l + 1) = ∑ q, w q * z q ^ l)
variable (hσ : ∀ q, z (σ q) = z q ^ 2)
include he ho hσ

theorem relation_even (s m n : ℕ) :
    relation a z (2 * s) m n = mergeEven z w σ s
      (relation a z s ((m + 1) / 2) ((n + 1) / 2))
      (relation a z (s + 1) (m / 2) (n / 2)) := by
  funext u v
  exact propext ((natural_holds_iff a z _ _ _ u v).trans
    (even_merge a z w σ he ho hσ _ _ _ _ _ u v))

theorem relation_odd (s m n : ℕ) :
    relation a z (2 * s + 1) m n = mergeOdd z w σ s
      (relation a z (s + 1) ((m + 1) / 2) (n / 2))
      (relation a z (s + 1) (m / 2) ((n + 1) / 2)) := by
  funext u v
  exact propext ((natural_holds_iff a z _ _ _ u v).trans
    (odd_merge a z w σ he ho hσ _ _ _ _ _ u v))

/-- Unbounded-phase closure, before replacing q by its stored residue. -/
theorem tupleStep_tuple (q k : ℕ) (ε η : Bit) :
    tupleStep z w σ q (tuple a z q k) ε η =
      tuple a z (2 * q + ε.val) (2 * k + η.val) := by
  funext d i j
  have h0 (i : Bit) : (2 * k + η.val + i.val + 1) / 2 =
      k + (half η i 0).val := by simpa using half_length k η i 0
  have h1 (i : Bit) : (2 * k + η.val + i.val) / 2 =
      k + (half η i 1).val := by simpa using half_length k η i 1
  fin_cases ε <;> fin_cases d <;>
    simp only [tupleStep, tuple, carry, Fin.val_zero, Fin.val_one, Fin.reduceFinMk,
      Nat.reduceAdd, Nat.reduceDiv, Nat.reduceEqDiff, ite_true, ite_false, Nat.add_zero]
  · rw [relation_odd a z w σ he ho hσ]
    simp only [h0, h1]
  · rw [show 2 * q + 1 + 1 = 2 * (q + 1) by omega,
      relation_even a z w σ he ho hσ]
    simp only [h0, h1]
  · rw [show 2 * q + 1 + 1 = 2 * (q + 1) by omega,
      relation_even a z w σ he ho hσ]
    simp only [h0, h1]
  · rw [show 2 * q + 1 + 1 + 1 = 2 * (q + 1) + 1 by omega,
      relation_odd a z w σ he ho hσ]
    simp only [h0, h1]

end Recurrence

omit [Fintype Ω] [DecidableEq Ω] in
/-- Root powers only require the stored residue, including both odd offsets. -/
theorem power_phase {N : ℕ} (z : Ω → K) (hz : ∀ x, z x ^ N = 1)
    (q c : ℕ) (x : Ω) : z x ^ (q % N + c) = z x ^ (q + c) := by
  rw [pow_add, pow_add, ← pow_eq_pow_mod q (hz x)]

theorem tupleStep_phase {N : ℕ} (z w : Ω → K) (σ : Ω → Ω)
    (hz : ∀ x, z x ^ N = 1) (q : ℕ) (T : Tuple K Ω) (ε η : Bit) :
    tupleStep z w σ (q % N) T ε η = tupleStep z w σ q T ε η := by
  funext d i j u v
  simp only [tupleStep]
  split_ifs <;> simp only [mergeEven, mergeOdd, Nat.add_assoc, power_phase z hz]

/-- Phase and size are bounded in the type; the eight predicates retain all
forcing and moment coordinates. This is a finite type when K and Ω are finite. -/
@[ext] structure State (K Ω : Type*) (N : ℕ) where
  phase : Fin N
  size : Fin (N + 1)
  relations : Tuple K Ω

noncomputable instance finiteState {N : ℕ} [Finite K] [Finite Ω] : Finite (State K Ω N) := by
  classical
  have : Finite (Ω → K) := inferInstance
  have : Finite (Relation K Ω) := inferInstance
  have : Finite (Bit → Relation K Ω) := inferInstance
  have : Finite (Bit → Bit → Relation K Ω) := inferInstance
  have : Finite (Tuple K Ω) := inferInstance
  apply Finite.of_injective (fun S : State K Ω N => (S.phase, S.size, S.relations))
  intro S T h
  cases S; cases T
  cases h
  rfl

def actual (a : ℕ → K) (z : Ω → K) {N : ℕ} (hN : 0 < N) (q k : ℕ) :
    State K Ω N where
  phase := ⟨q % N, Nat.mod_lt _ hN⟩
  size := ⟨min k N, by omega⟩
  relations := tuple a z q k

def step (z w : Ω → K) (σ : Ω → Ω) {N : ℕ} (hN : 0 < N)
    (S : State K Ω N) (digit : Bit × Bit) : State K Ω N where
  phase := ⟨(2 * S.phase.val + digit.1.val) % N, Nat.mod_lt _ hN⟩
  size := ⟨min (2 * S.size.val + digit.2.val) N, by omega⟩
  relations := tupleStep z w σ S.phase.val S.relations digit.1 digit.2

theorem size_saturation (N k η : ℕ) :
    min (2 * min k N + η) N = min (2 * k + η) N := by omega

section Realization
variable (a : ℕ → K) (z w : Ω → K) (σ : Ω → Ω)
variable (he : ∀ l, a (2 * l) = a l)
variable (ho : ∀ l, a (2 * l + 1) = ∑ q, w q * z q ^ l)
variable (hσ : ∀ q, z (σ q) = z q ^ 2)
variable {N : ℕ} (hN : 0 < N) (hz : ∀ x, z x ^ N = 1)
include he ho hσ hz

/-- Exact closure of one jointly realized state, for every shift and size. -/
theorem step_actual (q k : ℕ) (digit : Bit × Bit) :
    step z w σ hN (actual a z hN q k) digit =
      actual a z hN (2 * q + digit.1.val) (2 * k + digit.2.val) := by
  apply State.ext
  · apply Fin.ext
    dsimp [step, actual]
    simp [Nat.add_mod, Nat.mul_mod]
  · apply Fin.ext
    exact size_saturation N k digit.2.val
  · exact (tupleStep_phase z w σ hz q _ _ _).trans
      (tupleStep_tuple a z w σ he ho hσ q k digit.1 digit.2)

/-- Numerical interpretation of a paired digit word, most significant first. -/
def readPair (qk : ℕ × ℕ) (digit : Bit × Bit) : ℕ × ℕ :=
  (2 * qk.1 + digit.1.val, 2 * qk.2 + digit.2.val)

/-- Word induction retains a single actual pair, without independent children. -/
theorem fold_actual (word : List (Bit × Bit)) (q k : ℕ) :
    word.foldl (step z w σ hN) (actual a z hN q k) =
      actual a z hN (word.foldl readPair (q, k)).1
        (word.foldl readPair (q, k)).2 := by
  induction word generalizing q k with
  | nil => rfl
  | cons digit word ih =>
    simp only [List.foldl_cons, step_actual a z w σ he ho hσ hN hz]
    exact ih _ _

/-- No reachable state from the scalar initial tuple is spurious. -/
theorem reachable_realized (word : List (Bit × Bit)) :
    ∃ q k, word.foldl (step z w σ hN) (actual a z hN 0 0) = actual a z hN q k :=
  ⟨_, _, fold_actual a z w σ he ho hσ hN hz word 0 0⟩

/-- A leading zero pair leaves the full initial state unchanged. -/
theorem leading_zero (word : List (Bit × Bit)) :
    ((0, 0) :: word).foldl (step z w σ hN) (actual a z hN 0 0) =
      word.foldl (step z w σ hN) (actual a z hN 0 0) := by
  simp only [List.foldl_cons, step_actual a z w σ he ho hσ hN hz,
    Fin.val_zero, Nat.mul_zero, Nat.add_zero]

end Realization

/-- Every nonnegative shift/size pair has a common, zero-padded binary word. -/
theorem readPair_surjective (q k : ℕ) :
    ∃ word : List (Bit × Bit), word.foldl readPair (0, 0) = (q, k) := by
  have aux : ∀ s q k, q + k = s →
      ∃ word : List (Bit × Bit), word.foldl readPair (0, 0) = (q, k) := by
    intro s
    induction s using Nat.strong_induction_on with
    | h s ih =>
      intro q k hsum
      by_cases hs : s = 0
      · refine ⟨[], ?_⟩
        have hq : q = 0 := by omega
        have hk : k = 0 := by omega
        simp [hq, hk]
      · obtain ⟨word, hw⟩ := ih (q / 2 + k / 2) (by omega) (q / 2) (k / 2) rfl
        refine ⟨word ++ [(⟨q % 2, by omega⟩, ⟨k % 2, by omega⟩)], ?_⟩
        simp only [List.foldl_append, hw, List.foldl_cons, List.foldl_nil, readPair]
        congr 1 <;> omega
  exact aux (q + k) q k rfl

section ExactReachability
variable (a : ℕ → K) (z w : Ω → K) (σ : Ω → Ω)
variable (he : ∀ l, a (2 * l) = a l)
variable (ho : ∀ l, a (2 * l + 1) = ∑ q, w q * z q ^ l)
variable (hσ : ∀ q, z (σ q) = z q ^ 2)
variable {N : ℕ} (hN : 0 < N) (hz : ∀ x, z x ^ N = 1)
include he ho hσ hz

/-- The reachable set is exactly the actual correlated tuples. This is not a
terminal-existence theorem and does not assume the desired transition identity. -/
theorem reachable_iff (S : State K Ω N) :
    (∃ word : List (Bit × Bit),
      word.foldl (step z w σ hN) (actual a z hN 0 0) = S) ↔
    ∃ q k, actual a z hN q k = S := by
  constructor
  · rintro ⟨word, rfl⟩
    obtain ⟨q, k, h⟩ := reachable_realized a z w σ he ho hσ hN hz word
    exact ⟨q, k, h.symm⟩
  · rintro ⟨q, k, rfl⟩
    obtain ⟨word, hw⟩ := readPair_surjective q k
    refine ⟨word, ?_⟩
    rw [fold_actual a z w σ he ho hσ hN hz, hw]

end ExactReachability

/-- The actual infinite named stream discharges every recurrence hypothesis.
The Lean r is one less than v₂(p-1); r=0 (the usual r=1 comparison) is included.
No Proposition 2.3, rank bound or terminal-existence assumption is used. -/
theorem stream_reachable_iff {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) :
    ∃ z : Fin (2 * 2 ^ r) → ZMod p,
      ∃ σ : Fin (2 * 2 ^ r) → Fin (2 * 2 ^ r),
        Function.Injective z ∧
        (∀ x : ZMod p, x ^ (2 * 2 ^ r) = 1 ↔ ∃ j, x = z j) ∧
        ∀ S : State (ZMod p) (Fin (2 * 2 ^ r)) (2 * 2 ^ r),
          (∃ word : List (Bit × Bit),
            word.foldl (step z (oddWeight (2 ^ r)) σ (by positivity))
              (actual (laiSprangStream p (r + 1)) z (by positivity) 0 0) = S) ↔
          ∃ q k, actual (laiSprangStream p (r + 1)) z (by positivity) q k = S := by
  obtain ⟨z, hi, hc, ⟨σ, hs⟩, ho⟩ := stream_full_root_data hd
  refine ⟨z, σ, hi, hc, ?_⟩
  intro S
  exact reachable_iff (laiSprangStream p (r + 1)) z (oddWeight (2 ^ r)) σ
    (laiSprangStream_even p (r + 1)) ho hs (by positivity)
    (fun x => (hc (z x)).mpr ⟨x, rfl⟩) S

end FunctionFieldLittlewood.CorrelatedState
