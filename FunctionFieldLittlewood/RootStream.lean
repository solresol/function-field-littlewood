import FunctionFieldLittlewood.LaiSprangStream
import FunctionFieldLittlewood.ParityDescent
import Mathlib.RingTheory.RootsOfUnity.PrimitiveRoots

/-!
Root enumeration and odd-subsequence identification for the support stream.
This supplies the root formula used in the parity-window argument; it does not
formalise the complete descent or identify the infinite rational-function sum.
-/
namespace FunctionFieldLittlewood
namespace RootStream
open scoped BigOperators
open Polynomial

/-- Finite-field cyclicity supplies a primitive root of every divisor of p-1. -/
theorem exists_primitive {p N : ℕ} [Fact p.Prime]
    (hd : N ∣ p - 1) : ∃ ξ : ZMod p, IsPrimitiveRoot ξ N := by
  obtain ⟨g, hg⟩ := IsCyclic.exists_ofOrder_eq_natCard (α := (ZMod p)ˣ)
  have hg' : IsPrimitiveRoot (g : ZMod p) (p - 1) := by
    apply IsPrimitiveRoot.coe_units_iff.mpr
    apply IsPrimitiveRoot.iff_orderOf.mpr
    simpa only [Nat.card_eq_fintype_card, ZMod.card_units] using hg
  obtain ⟨a, ha⟩ := hd
  exact ⟨(g : ZMod p) ^ a, hg'.pow (by have := (Fact.out : p.Prime).two_le; omega)
    (by simpa [Nat.mul_comm] using ha)⟩

variable {K : Type*} [Field K] {H : ℕ} {ξ : K}

/-- Odd powers enumerate the roots of X^H+1 when ξ has order 2H. -/
def oddRoot (ξ : K) (i : Fin H) : K := ξ ^ (2 * i.val + 1)

theorem half_power (hH : 0 < H) (hξ : IsPrimitiveRoot ξ (2 * H)) :
    ξ ^ H = -1 := by
  exact (hξ.pow (by omega) (by omega : 2 * H = H * 2)).eq_neg_one_of_two_right

theorem oddRoot_pow (hH : 0 < H) (hξ : IsPrimitiveRoot ξ (2 * H)) (i : Fin H) :
    oddRoot ξ i ^ H = -1 := by
  rw [oddRoot, ← pow_mul, Nat.mul_comm (2 * i.val + 1), pow_mul, half_power hH hξ]
  simp [pow_add, pow_mul]

theorem oddRoot_injective (hξ : IsPrimitiveRoot ξ (2 * H)) :
    Function.Injective (oddRoot ξ : Fin H → K) := by
  intro i j hij
  have he := hξ.pow_inj (by omega : 2 * i.val + 1 < 2 * H)
    (by omega : 2 * j.val + 1 < 2 * H) hij
  apply Fin.ext
  omega

/-- The enumeration is complete, not merely a list of distinct roots. -/
theorem oddRoot_complete (hH : 0 < H) (hξ : IsPrimitiveRoot ξ (2 * H)) (z : K) :
    z ^ H = -1 ↔ ∃ i : Fin H, z = oddRoot ξ i := by
  classical
  constructor
  · intro hz
    have he := congrArg (fun P : K[X] => P.eval z)
      (ParityDescent.root_product_eq (oddRoot ξ) hH
        (oddRoot_injective hξ) (oddRoot_pow hH hξ))
    simp only [eval_prod, eval_sub, eval_X, eval_C, eval_add, eval_pow, eval_one, hz,
      neg_add_cancel] at he
    obtain ⟨i, _, hi⟩ := Finset.prod_eq_zero_iff.mp he
    exact ⟨i, sub_eq_zero.mp hi⟩
  · rintro ⟨i, rfl⟩
    exact oddRoot_pow hH hξ i

/-- Root moments equal the explicit sparse, alternating odd subsequence. -/
theorem oddRoot_sum (hH : 0 < H) (hξ : IsPrimitiveRoot ξ (2 * H)) (u : ℕ) :
    (∑ i : Fin H, oddRoot ξ i ^ u) =
      if u % H = 0 then (H : K) * (-1) ^ (u / H) else 0 := by
  classical
  by_cases hu : u % H = 0
  · rw [if_pos hu]
    have hu' : u = H * (u / H) := (Nat.mul_div_cancel' (Nat.dvd_of_mod_eq_zero hu)).symm
    conv_lhs => arg 2; ext i; rw [hu', pow_mul, oddRoot_pow hH hξ]
    simp
  · rw [if_neg hu]
    have h2 : IsPrimitiveRoot (ξ ^ 2) H := hξ.pow (by omega) rfl
    have hx : (ξ ^ 2) ^ u ≠ 1 := by
      intro hx
      exact hu (Nat.mod_eq_zero_of_dvd ((h2.pow_eq_one_iff_dvd u).mp hx))
    have hs : (∑ i ∈ Finset.range H, ((ξ ^ 2) ^ u) ^ i) = 0 := by
      have he := geom_sum_mul ((ξ ^ 2) ^ u) H
      have hp : ((ξ ^ 2) ^ u) ^ H = 1 := by
        rw [← pow_mul, Nat.mul_comm u H, pow_mul, h2.pow_eq_one, one_pow]
      rw [hp, sub_self] at he
      exact (mul_eq_zero.mp he).resolve_right (sub_ne_zero.mpr hx)
    calc
      (∑ i : Fin H, oddRoot ξ i ^ u) =
          ξ ^ u * ∑ i ∈ Finset.range H, ((ξ ^ 2) ^ u) ^ i := by
        rw [← Fin.sum_univ_eq_sum_range, Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro i _
        simp only [oddRoot, pow_add, pow_one, mul_pow, ← pow_mul]
        rw [mul_comm]
        congr 1
        congr 1
        ring
      _ = 0 := by rw [hs, mul_zero]

/-- The named support stream's odd coefficients, without root hypotheses. -/
theorem stream_odd (p r u : ℕ) :
    laiSprangStream p (r + 1) (2 * u + 1) =
      if u % (2 ^ r) = 0 then ((2 ^ r : ℕ) : ZMod p) * (-1) ^ (u / (2 ^ r)) else 0 := by
  have hpow : 2 ^ (r + 1) = 2 * 2 ^ r := by rw [pow_succ, Nat.mul_comm]
  simp only [laiSprangStream, oddCore_odd, show 2 * u + 1 ≠ 0 by omega,
    if_false, Nat.add_sub_cancel, hpow, Nat.mul_mod_mul_left,
    Nat.mul_div_mul_left u (2 ^ r) (by decide : 0 < 2)]
  rw [show 2 * 2 ^ r / 2 = 2 ^ r by omega]
  simp only [mul_eq_zero, OfNat.ofNat_ne_zero, false_or]

/-- Uniform root enumeration and odd-row formula for the actual support stream.
The hypothesis 2^(r+1) | p-1 suffices; maximal 2-adic valuation is unnecessary
for this identity (it is needed later for nonsquareness). -/
theorem stream_root_enumeration {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) :
    ∃ z : Fin (2 ^ r) → ZMod p, Function.Injective z ∧
      (∀ i, z i ^ (2 ^ r) = -1) ∧
      (∀ x : ZMod p, x ^ (2 ^ r) = -1 ↔ ∃ i, x = z i) ∧
      (∀ u, laiSprangStream p (r + 1) (2 * u + 1) = ∑ i, z i ^ u) := by
  obtain ⟨ξ, hξ⟩ := exists_primitive hd
  have hp : 2 ^ (r + 1) = 2 * 2 ^ r := by rw [pow_succ, Nat.mul_comm]
  rw [hp] at hξ
  exact ⟨oddRoot ξ, oddRoot_injective hξ, oddRoot_pow (by positivity) hξ,
    oddRoot_complete (by positivity) hξ, fun u =>
      (stream_odd p r u).trans (oddRoot_sum (by positivity) hξ u).symm⟩

/-- A polynomial filter of the odd subsequence is the required root moment.
The inclusive last stream index is 2*(n+natDegree P)+1. -/
theorem odd_filter (a : ℕ → K) (z : Fin H → K)
    (ha : ∀ u, a (2 * u + 1) = ∑ i, z i ^ u) (P : K[X]) (n : ℕ) :
    (∑ j ∈ Finset.range (P.natDegree + 1), P.coeff j * a (2 * (n + j) + 1)) =
      ∑ i, z i ^ n * P.eval (z i) := by
  simp_rw [ha, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  rw [eval_eq_sum_range, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  rw [pow_add]
  ring

/-- Root hypotheses are discharged uniformly also for every polynomial filter.
This is the E_V(v) formula needed by the parent-window cross-convolution. -/
theorem stream_filtered_root_enumeration {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) :
    ∃ z : Fin (2 ^ r) → ZMod p, Function.Injective z ∧
      (∀ i, z i ^ (2 ^ r) = -1) ∧
      (∀ P : (ZMod p)[X], ∀ n,
        (∑ j ∈ Finset.range (P.natDegree + 1),
          P.coeff j * laiSprangStream p (r + 1) (2 * (n + j) + 1)) =
        ∑ i, z i ^ n * P.eval (z i)) := by
  obtain ⟨z, hz, hroot, _, ha⟩ := stream_root_enumeration hd
  exact ⟨z, hz, hroot, fun P n => odd_filter _ z ha P n⟩

#print axioms odd_filter
#print axioms stream_filtered_root_enumeration
#print axioms exists_primitive
#print axioms half_power
#print axioms oddRoot_pow
#print axioms oddRoot_injective
#print axioms oddRoot_complete
#print axioms oddRoot_sum
#print axioms stream_odd
#print axioms stream_root_enumeration
end RootStream
end FunctionFieldLittlewood
