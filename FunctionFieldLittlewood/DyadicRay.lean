module

public import FunctionFieldLittlewood.CorrelatedState

@[expose] public section

/-!
Exact coefficient windows for the reachable dyadic ray of 8 November.
We retain the raw coefficient factor H=2^r. The Lean parameter r is one
less than the usual valuation. No primality or root hypotheses are needed
for the coefficient identities; no terminal acceptance is asserted.
-/
namespace FunctionFieldLittlewood.DyadicRay
open Matrix RootStream BoundaryRelation CorrelatedState

/-- Adding a multiple of the full odd-subsequence period preserves a row. -/
theorem odd_period (p r m u : ℕ) :
    laiSprangStream p (r + 1) (2 * (2 ^ (r + 1) * m + u) + 1) =
      laiSprangStream p (r + 1) (2 * u + 1) := by
  rw [stream_odd, stream_odd]
  have hp : 2 ^ (r + 1) = 2 ^ r * 2 := pow_succ 2 r
  have h : 2 ^ (r + 1) * m + u = u + 2 ^ r * (2 * m) := by rw [hp]; ring
  rw [h, Nat.add_mul_mod_self_left, Nat.add_mul_div_left _ _ (by positivity)]
  simp [pow_add, pow_mul]

/-- All positive interior rows of a sufficiently distant dyadic window
are exact copies of the original infinite stream, not a finite prefix. -/
theorem interior (p r s a n : ℕ) (ha : s + r + 1 ≤ a)
    (hn : 0 < n) (hns : n < 2 ^ s) :
    laiSprangStream p (r + 1) (2 ^ a + n) = laiSprangStream p (r + 1) n := by
  induction s generalizing a n with
  | zero => simp at hns; omega
  | succ s ih =>
    obtain ⟨b, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : a ≠ 0)
    rw [pow_succ] at hns
    by_cases he : n % 2 = 0
    · have hn' : n = 2 * (n / 2) := by omega
      rw [hn', show 2 ^ (b + 1) + 2 * (n / 2) = 2 * (2 ^ b + n / 2) by
        rw [pow_succ]; ring, laiSprangStream_even, laiSprangStream_even]
      exact ih b (n / 2) (by omega) (by omega) (by omega)
    · have hn' : n = 2 * (n / 2) + 1 := by omega
      have hbr : r + 1 ≤ b := by omega
      obtain ⟨d, hd⟩ := Nat.exists_eq_add_of_le hbr
      rw [hn', show 2 ^ (b + 1) + (2 * (n / 2) + 1) =
          2 * (2 ^ b + n / 2) + 1 by rw [pow_succ]; ring]
      rw [hd, pow_add]
      exact odd_period p r (2 ^ d) (n / 2)

/-- The leading power of two always has the raw coefficient H. -/
theorem center (p r a : ℕ) :
    laiSprangStream p (r + 1) (2 ^ a) = ((2 ^ r : ℕ) : ZMod p) := by
  rw [show 2 ^ a = 2 ^ a * 1 by simp, laiSprangStream_dyadic]
  simpa using stream_odd p r 0

/-- The endpoint has sign (-1)^(2^d). In particular its first value
is -H and all subsequent values are H. -/
theorem endpoint (p r s d : ℕ) :
    laiSprangStream p (r + 1) (2 ^ (s + r + 1 + d) + 2 ^ s) =
      ((2 ^ r : ℕ) : ZMod p) * (-1) ^ (2 ^ d) := by
  have h : 2 ^ (s + r + 1 + d) + 2 ^ s =
      2 ^ s * (2 * (2 ^ r * 2 ^ d) + 1) := by
    rw [show s + r + 1 + d = s + (r + d) + 1 by omega, pow_succ, pow_add,
      pow_add]
    ring
  rw [h, laiSprangStream_dyadic, stream_odd]
  simp [Nat.mul_mod_right]

theorem endpoint_first (p r s : ℕ) :
    laiSprangStream p (r + 1) (2 ^ (s + r + 1) + 2 ^ s) =
      -((2 ^ r : ℕ) : ZMod p) := by
  simpa using endpoint p r s 0

theorem endpoint_stable (p r s d : ℕ) :
    laiSprangStream p (r + 1) (2 ^ (s + r + 2 + d) + 2 ^ s) =
      ((2 ^ r : ℕ) : ZMod p) := by
  have h := endpoint p r s (d + 1)
  have hs : (-1 : ZMod p) ^ (2 ^ (d + 1)) = 1 := by
    rw [show 2 ^ (d + 1) = 2 * 2 ^ d by rw [pow_succ]; omega, pow_mul]
    simp
  simpa only [show s + r + 1 + (d + 1) = s + r + 2 + d by omega,
    hs, mul_one] using h

/-- The coefficient just before the center is stable as well. -/
theorem predecessor_step (p r a : ℕ) (ha : r + 2 ≤ a) :
    laiSprangStream p (r + 1) (2 ^ (a + 1) - 1) =
      laiSprangStream p (r + 1) (2 ^ a - 1) := by
  obtain ⟨b, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : a ≠ 0)
  have hb : r + 1 ≤ b := by omega
  obtain ⟨d, hd⟩ := Nat.exists_eq_add_of_le hb
  have hp : 0 < 2 ^ b := by positivity
  rw [show 2 ^ (b + 1 + 1) - 1 = 2 * (2 ^ b + (2 ^ b - 1)) + 1 by
        simp only [pow_succ]; omega,
      show 2 ^ (b + 1) - 1 = 2 * (2 ^ b - 1) + 1 by rw [pow_succ]; omega]
  nth_rw 1 [hd]
  rw [pow_add]
  exact odd_period p r (2 ^ d) (2 ^ b - 1)

theorem predecessor (p r a d : ℕ) (ha : r + 2 ≤ a) :
    laiSprangStream p (r + 1) (2 ^ (a + d) - 1) =
      laiSprangStream p (r + 1) (2 ^ a - 1) := by
  induction d with
  | zero => simp
  | succ d ih =>
    rw [show a + (d + 1) = (a + d) + 1 by omega,
      predecessor_step p r (a + d) (by omega), ih]

/-- The prefix before the final endpoint is constant from the first
ray state onwards. The endpoint itself is deliberately excluded. -/
theorem prefix_window (p r s d j : ℕ) (hj : j ≤ 2 ^ (s + 1)) :
    laiSprangStream p (r + 1) (2 ^ (s + r + 2 + d) - 1 + j) =
      laiSprangStream p (r + 1) (2 ^ (s + r + 2) - 1 + j) := by
  by_cases hj0 : j = 0
  · simpa [hj0] using predecessor p r (s + r + 2) d (by omega)
  have hB : 0 < 2 ^ (s + r + 2) := by positivity
  have hBd : 0 < 2 ^ (s + r + 2 + d) := by positivity
  rw [show 2 ^ (s + r + 2 + d) - 1 + j =
      2 ^ (s + r + 2 + d) + (j - 1) by omega,
    show 2 ^ (s + r + 2) - 1 + j = 2 ^ (s + r + 2) + (j - 1) by omega]
  by_cases hj1 : j = 1
  · simp only [hj1, Nat.sub_self, Nat.add_zero, center]
  · rw [interior p r (s + 1) (s + r + 2 + d) (j - 1) (by omega) (by omega) (by omega),
      interior p r (s + 1) (s + r + 2) (j - 1) (by omega) (by omega) (by omega)]

/-- The complete inclusive coefficient window read by all eight relations
at size 2^s is identical after the first sign change. -/
theorem stable_window (p r s d j : ℕ) (hj : j ≤ 2 ^ (s + 1) + 1) :
    laiSprangStream p (r + 1) (2 ^ (s + r + 3 + d) - 1 + j) =
      laiSprangStream p (r + 1) (2 ^ (s + r + 3) - 1 + j) := by
  by_cases hj0 : j = 0
  · simpa [hj0] using predecessor p r (s + r + 3) d (by omega)
  have hB : 0 < 2 ^ (s + r + 3) := by positivity
  have hBd : 0 < 2 ^ (s + r + 3 + d) := by positivity
  rw [show 2 ^ (s + r + 3 + d) - 1 + j =
      2 ^ (s + r + 3 + d) + (j - 1) by omega,
    show 2 ^ (s + r + 3) - 1 + j = 2 ^ (s + r + 3) + (j - 1) by omega]
  by_cases hj1 : j = 1
  · simp only [hj1, Nat.sub_self, Nat.add_zero, center]
  by_cases hn : j - 1 < 2 ^ (s + 1)
  · rw [interior p r (s + 1) (s + r + 3 + d) (j - 1) (by omega) (by omega) hn,
      interior p r (s + 1) (s + r + 3) (j - 1) (by omega) (by omega) hn]
  · have he : j - 1 = 2 ^ (s + 1) := by omega
    rw [he, show s + r + 3 + d = (s + 1) + r + 2 + d by omega,
      show s + r + 3 = (s + 1) + r + 2 + 0 by omega,
      endpoint_stable, endpoint_stable]

/-- All actual boundary relations stabilize, without an invertibility
assumption. The evaluation coordinates are arbitrary and kept unchanged. -/
theorem tuple_stable {Ω : Type*} [Fintype Ω] (p r s d : ℕ) (z : Ω → ZMod p) :
    tuple (laiSprangStream p (r + 1)) z (2 ^ (s + r + 3 + d) - 2) (2 ^ s) =
      tuple (laiSprangStream p (r + 1)) z (2 ^ (s + r + 3) - 2) (2 ^ s) := by
  funext δ i j
  apply congrArg (fun A => Holds A (evalMatrix z (2 ^ s + i.val))
    (evalMatrix z (2 ^ s + j.val))ᵀ)
  ext u v
  have hB : 2 ≤ 2 ^ (s + r + 3) := by
    have : 0 < 2 ^ (s + r + 2) := by positivity
    rw [show s + r + 3 = s + r + 2 + 1 by omega, pow_succ]
    omega
  have hBd : 2 ≤ 2 ^ (s + r + 3 + d) := by
    have : 0 < 2 ^ (s + r + 2 + d) := by positivity
    rw [show s + r + 3 + d = s + r + 2 + d + 1 by omega, pow_succ]
    omega
  have hδ := δ.isLt
  have hi := i.isLt
  have hj := j.isLt
  have hu := u.isLt
  have hv := v.isLt
  change laiSprangStream p (r + 1) ((2 ^ (s + r + 3 + d) - 2 + 1 + δ.val) + u.val + v.val) =
    laiSprangStream p (r + 1) ((2 ^ (s + r + 3) - 2 + 1 + δ.val) + u.val + v.val)
  rw [show (2 ^ (s + r + 3 + d) - 2 + 1 + δ.val) + u.val + v.val =
      2 ^ (s + r + 3 + d) - 1 + (δ.val + u.val + v.val) by omega,
    show (2 ^ (s + r + 3) - 2 + 1 + δ.val) + u.val + v.val =
      2 ^ (s + r + 3) - 1 + (δ.val + u.val + v.val) by omega]
  apply stable_window
  rw [pow_succ]
  omega

/-- Seven full relations are already constant at the first exponent.
Only the next-shift larger square can read the changing endpoint. -/
theorem seven_relations {Ω : Type*} [Fintype Ω] (p r s d : ℕ)
    (z : Ω → ZMod p) (δ i j : Bit) (h : δ = 0 ∨ i = 0 ∨ j = 0) :
    tuple (laiSprangStream p (r + 1)) z (2 ^ (s + r + 2 + d) - 2) (2 ^ s) δ i j =
      tuple (laiSprangStream p (r + 1)) z (2 ^ (s + r + 2) - 2) (2 ^ s) δ i j := by
  apply congrArg (fun A => Holds A (evalMatrix z (2 ^ s + i.val))
    (evalMatrix z (2 ^ s + j.val))ᵀ)
  ext u v
  have hB : 2 ≤ 2 ^ (s + r + 2) :=
    Nat.pow_le_pow_right (n := 2) (by decide) (by omega : 1 ≤ s + r + 2)
  have hBd : 2 ≤ 2 ^ (s + r + 2 + d) :=
    Nat.pow_le_pow_right (n := 2) (by decide) (by omega : 1 ≤ s + r + 2 + d)
  have hδ := δ.isLt
  have hi := i.isLt
  have hj := j.isLt
  have hu := u.isLt
  have hv := v.isLt
  change laiSprangStream p (r + 1) ((2 ^ (s + r + 2 + d) - 2 + 1 + δ.val) + u.val + v.val) =
    laiSprangStream p (r + 1) ((2 ^ (s + r + 2) - 2 + 1 + δ.val) + u.val + v.val)
  rw [show (2 ^ (s + r + 2 + d) - 2 + 1 + δ.val) + u.val + v.val =
      2 ^ (s + r + 2 + d) - 1 + (δ.val + u.val + v.val) by omega,
    show (2 ^ (s + r + 2) - 2 + 1 + δ.val) + u.val + v.val =
      2 ^ (s + r + 2) - 1 + (δ.val + u.val + v.val) by omega]
  apply prefix_window
  rw [pow_succ]
  rcases h with h | h | h <;> simp only [h, Fin.val_zero] at * <;> omega

/-- Full stored-state stabilization, including phase and capped size.
This is stronger than tuple equality and permits arbitrary shared suffixes. -/
theorem actual_stable {Ω : Type*} [Fintype Ω] (p r s d : ℕ) (z : Ω → ZMod p) :
    actual (laiSprangStream p (r + 1)) z (N := 2 ^ (r + 1)) (by positivity)
      (2 ^ (s + r + 3 + d) - 2) (2 ^ s) =
    actual (laiSprangStream p (r + 1)) z (N := 2 ^ (r + 1)) (by positivity)
      (2 ^ (s + r + 3) - 2) (2 ^ s) := by
  apply State.ext
  · apply Fin.ext
    have hB : 2 ≤ 2 ^ (s + r + 3) :=
      Nat.pow_le_pow_right (n := 2) (by decide) (by omega : 1 ≤ s + r + 3)
    have hBd : 2 ≤ 2 ^ (s + r + 3 + d) :=
      Nat.pow_le_pow_right (n := 2) (by decide) (by omega : 1 ≤ s + r + 3 + d)
    have he : Nat.ModEq (2 ^ (r + 1)) (2 ^ (s + r + 3 + d)) (2 ^ (s + r + 3)) := by
      change _ % _ = _ % _
      rw [show s + r + 3 + d = (r + 1) + (s + 2 + d) by omega,
        show s + r + 3 = (r + 1) + (s + 2) by omega]
      simp [pow_add]
    exact he.sub hBd hB (Nat.ModEq.refl 2)
  · rfl
  · exact tuple_stable p r s d z

/-- The entire actual ray has at most two stored states. Distinctness of
the corner relations is not asserted here. -/
theorem ray_two_states {Ω : Type*} [Fintype Ω] (p r s a : ℕ)
    (z : Ω → ZMod p) (ha : s + r + 2 ≤ a) :
    actual (laiSprangStream p (r + 1)) z (N := 2 ^ (r + 1)) (by positivity)
      (2 ^ a - 2) (2 ^ s) =
      actual (laiSprangStream p (r + 1)) z (by positivity)
        (2 ^ (s + r + 2) - 2) (2 ^ s) ∨
    actual (laiSprangStream p (r + 1)) z (N := 2 ^ (r + 1)) (by positivity)
      (2 ^ a - 2) (2 ^ s) =
      actual (laiSprangStream p (r + 1)) z (by positivity)
        (2 ^ (s + r + 3) - 2) (2 ^ s) := by
  by_cases h : a = s + r + 2
  · exact Or.inl (by rw [h])
  · right
    obtain ⟨d, rfl⟩ := Nat.exists_eq_add_of_le (by omega : s + r + 3 ≤ a)
    exact actual_stable p r s d z

/-- No fixed or prime-dependent shared word can distinguish later exponents
of this ray. This only identifies inputs; it asserts no accepting word. -/
theorem continuation_stable {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (p r s d : ℕ) (z w : Ω → ZMod p) (σ : Ω → Ω) (word : List (Bit × Bit)) :
    word.foldl (step z w σ (N := 2 ^ (r + 1)) (by positivity))
      (actual (laiSprangStream p (r + 1)) z (by positivity)
        (2 ^ (s + r + 3 + d) - 2) (2 ^ s)) =
    word.foldl (step z w σ (N := 2 ^ (r + 1)) (by positivity))
      (actual (laiSprangStream p (r + 1)) z (by positivity)
        (2 ^ (s + r + 3) - 2) (2 ^ s)) :=
  congrArg (word.foldl (step z w σ (by positivity))) (actual_stable p r s d z)

end FunctionFieldLittlewood.DyadicRay
