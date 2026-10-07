module

public import FunctionFieldLittlewood.RootStream

public section

/-!
# Proved root-moment package

The statement matches Challenge.lean, whose module is deliberately not imported.
The proof combines uniform support-stream root enumeration, the polynomial-filter
identity and geometric parity rigidity from the substantive development.
-/

open scoped BigOperators
open Polynomial
open FunctionFieldLittlewood

/-- Complete odd-coefficient root representation and the geometric forced-factor
step, with all field, root, coefficient and moment conditions explicit. -/
theorem FunctionFieldLittlewood.Palomar.root_moment_package
    {p r k s : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 ^ (r + 1) * (2 * k + 1)) (hs : s ∣ 2 ^ r) :
    let A : ℕ → ZMod p := fun u =>
      if u % (2 ^ r) = 0 then ((2 ^ r : ℕ) : ZMod p) * (-1) ^ (u / (2 ^ r)) else 0
    let G : (ZMod p)[X] := ∑ i ∈ Finset.range (2 ^ r / s), X ^ (s * i)
    ∃ z : Fin (2 ^ r) → ZMod p, Function.Injective z ∧
      (∀ i, z i ^ (2 ^ r) = -1) ∧
      (∀ x : ZMod p, x ^ (2 ^ r) = -1 ↔ ∃ i, x = z i) ∧
      (∀ u, A u = ∑ i, z i ^ u) ∧
      (∀ P : (ZMod p)[X], ∀ n,
        (∑ j ∈ Finset.range (P.natDegree + 1), P.coeff j * A (n + j)) =
          ∑ i, z i ^ n * P.eval (z i)) ∧
      (∀ U₀ U₁ : (ZMod p)[X], ∀ n,
        (∀ j : Fin (2 ^ r), ∑ i, z i ^ (n + j.val) *
          (G.eval (z i) * ((U₀.eval (z i)) ^ 2 - z i * (U₁.eval (z i)) ^ 2)) = 0) →
        G * (X ^ (2 ^ r) + 1) ∣ G * U₀ ∧ G * (X ^ (2 ^ r) + 1) ∣ G * U₁) := by
  dsimp only
  have hd : 2 ^ (r + 1) ∣ p - 1 := by
    rw [horder]
    exact dvd_mul_right _ _
  obtain ⟨z, hz, hroot, hcomplete, ha⟩ := RootStream.stream_root_enumeration hd
  refine ⟨z, hz, hroot, hcomplete, ?_, ?_, ?_⟩
  · intro u
    exact (RootStream.stream_odd p r u).symm.trans (ha u)
  · intro P n
    simpa only [RootStream.stream_odd] using RootStream.odd_filter _ z ha P n
  · intro U₀ U₁ n hm
    have horder' : p - 1 = 2 * 2 ^ r * (2 * k + 1) := by
      rw [horder, pow_succ]
      ring
    exact ParityDescent.geometric_parity_forced_factor hp (by positivity) hs
      horder' z hz hroot U₀ U₁ n hm

#print axioms FunctionFieldLittlewood.Palomar.root_moment_package
