module

public import Mathlib.FieldTheory.Finite.Basic
public import Mathlib.Algebra.Polynomial.Eval.Degree

public section

/-!
# Root moments for the Lai–Sprang odd coefficients

This is the independent statement surface for the root-moment component of
the parity-descent method, adapted from Lai–Sprang, arXiv:2606.00633v1, §3.
It imports only Mathlib and defines its coefficient sequence and geometric
factor explicitly inside the statement. It does not import the proof library.

Write H=2^r and N=2H. The condition p-1=N(2k+1) says that N is the full
2-primary part of p-1. The sequence A(u) is the coefficient at index 2u+1
of the Lai–Sprang support stream. G is (X^H-1)/(X^s-1), expressed as a finite
geometric sum. Its use requires s|H, which also implies s>0 since H>0.

The theorem supplies every root of X^H+1, the coefficient and polynomial-filter
identities, and the forced factor in both parity children from H consecutive
weighted moments. Quotients may have zero constant terms. Deriving these moments
from a parent coefficient window and iterating the degree descent are outside
this statement; the all-degree Littlewood bound is not claimed.

The deliberate statement hole below belongs only to the Comparator Challenge.
The separately built Solution must prove exactly this statement with standard
axioms and must not import this module.
-/

open scoped BigOperators
open Polynomial

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
  sorry
