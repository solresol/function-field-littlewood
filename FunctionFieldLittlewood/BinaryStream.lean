import FunctionFieldLittlewood.SavedCertificates
import FunctionFieldLittlewood.PolynomialBridge
import Mathlib.Algebra.Field.ZMod
import Mathlib.Data.Nat.Digits.Defs

/-!
The infinite binary digit-parity stream and its adjacent-difference recurrences.
This identifies finite saved certificates with a named infinite stream. It does
not formalise the all-scale dyadic witness or a Laurent-series norm statement.
-/

namespace FunctionFieldLittlewood

/-- Binary digit sum reduced in F_2, with a_0 = 0. Positive indices agree with
the Python `thue_morse` stream; this is not the signed multiplicative encoding. -/
def thueMorse (n : ℕ) : ZMod 2 := (Nat.digits 2 n).sum

@[simp] theorem thueMorse_zero : thueMorse 0 = 0 := by
  simp [thueMorse]

theorem thueMorse_even (n : ℕ) : thueMorse (2 * n) = thueMorse n := by
  by_cases hn : n = 0
  · simp [hn]
  · have h := Nat.digits_add 2 (by decide) 0 n (by decide) (Or.inr hn)
    simpa [thueMorse] using congrArg (fun l : List ℕ => (l.sum : ZMod 2)) h

theorem thueMorse_odd (n : ℕ) : thueMorse (2 * n + 1) = 1 + thueMorse n := by
  have h := Nat.digits_add 2 (by decide) 1 n (by decide) (Or.inl (by decide))
  simpa [thueMorse, Nat.add_comm] using
    congrArg (fun l : List ℕ => (l.sum : ZMod 2)) h

/-- The binary recurrences uniquely identify the digit-parity stream at every
index, rather than only at the finite prefix used by a certificate. -/
theorem thueMorse_unique (a : ℕ → ZMod 2) (h0 : a 0 = 0)
    (he : ∀ n, a (2 * n) = a n) (ho : ∀ n, a (2 * n + 1) = 1 + a n) :
    a = thueMorse := by
  funext n
  induction n using Nat.strong_induction_on with
  | h n ih =>
    by_cases hn : n = 0
    · simpa [hn] using h0
    · have hlt : n / 2 < n := Nat.div_lt_self (by omega) (by decide)
      have hi := ih (n / 2) hlt
      by_cases hp : n % 2 = 0
      · have hn' : n = 2 * (n / 2) := by omega
        calc a n = a (n / 2) := by conv_lhs => rw [hn', he]
             _ = thueMorse (n / 2) := hi
             _ = thueMorse n := by conv_rhs => rw [hn', thueMorse_even]
      · have hn' : n = 2 * (n / 2) + 1 := by omega
        calc a n = 1 + a (n / 2) := by conv_lhs => rw [hn', ho]
             _ = 1 + thueMorse (n / 2) := by rw [hi]
             _ = thueMorse n := by conv_rhs => rw [hn', thueMorse_odd]

/-- Adjacent sum is also adjacent difference in characteristic two. -/
def thueMorseDifference (n : ℕ) : ZMod 2 := thueMorse n + thueMorse (n + 1)

private theorem binary_add_self (x : ZMod 2) : x + x = 0 := by
  have h : (2 : ZMod 2) = 0 := by decide
  simpa only [two_mul, zero_mul] using congrArg (fun c : ZMod 2 => c * x) h

theorem thueMorseDifference_even (n : ℕ) : thueMorseDifference (2 * n) = 1 := by
  simp only [thueMorseDifference, thueMorse_even, thueMorse_odd]
  rw [← add_assoc, add_comm (thueMorse n) 1, add_assoc, binary_add_self, add_zero]

theorem thueMorseDifference_odd (n : ℕ) :
    thueMorseDifference (2 * n + 1) = 1 + thueMorseDifference n := by
  unfold thueMorseDifference
  rw [thueMorse_odd, show 2 * n + 1 + 1 = 2 * (n + 1) by omega,
    thueMorse_even, add_assoc]

set_option maxRecDepth 10000 in
set_option maxHeartbeats 2000000 in
theorem thueMorse_saved_prefix :
    ∀ n, n ≤ 48 → Saved.thueMorsePrefix n = thueMorse n := by
  have h : ∀ n : Fin 49, Saved.thueMorsePrefix n.val = thueMorse n.val := by
    norm_num [Fin.forall_fin_succ, Saved.thueMorsePrefix, thueMorse,
      Nat.digits, Nat.digitsAux]
    decide
  intro n hn
  exact h ⟨n, by omega⟩

theorem thueMorse_named_accepted :
    checkOptimalCertificate thueMorse Saved.thueMorseR 15 24
      Saved.thueMorseWeights = true := by
  rw [← checkOptimalCertificate_congr_prefix Saved.thueMorsePrefix thueMorse
    Saved.thueMorseR 15 24 Saved.thueMorseWeights thueMorse_saved_prefix]
  exact Saved.thueMorse_accepted

/-- The saved multiplier attains j=24 on the actual infinite digit-parity stream,
and every admissible degree-nine multiplier has a nonzero coefficient by 24. -/
theorem thueMorse_named_optimal :
    FirstNonzero thueMorse Saved.thueMorseR 15 24 ∧
      ∀ S : Fin 10 → ZMod 2, S 0 ≠ 0 → S (Fin.last 9) ≠ 0 →
        ∃ k : ℕ, 0 < k ∧ k ≤ 24 ∧ fractionalCoeff thueMorse S 15 k ≠ 0 :=
  checkOptimalCertificate_sound_all _ _ _ _ _ thueMorse_named_accepted

theorem thueMorse_named_polynomial_optimal (P : Polynomial (ZMod 2))
    (h0 : P.coeff 0 ≠ 0) (hd : P.natDegree = 9) :
    ∃ k : ℕ, 0 < k ∧ k ≤ 24 ∧
      (∑ i : Fin 10, P.coeff i.val * thueMorse (15 + i.val + k)) ≠ 0 :=
  optimal_polynomial_nonzero _ _ _ _ _ thueMorse_named_accepted P h0 hd

-- Convention controls: the complemented stream and the zero-padded tail differ.
example : thueMorse 0 ≠ (1 : ZMod 2) := by simp
example : Saved.thueMorsePrefix 49 ≠ thueMorse 49 := by
  norm_num [Saved.thueMorsePrefix, thueMorse, Nat.digits, Nat.digitsAux]
  decide

#print axioms thueMorse_even
#print axioms thueMorse_odd
#print axioms thueMorse_unique
#print axioms thueMorseDifference_even
#print axioms thueMorseDifference_odd
#print axioms thueMorse_saved_prefix
#print axioms thueMorse_named_accepted
#print axioms thueMorse_named_optimal
#print axioms thueMorse_named_polynomial_optimal

end FunctionFieldLittlewood
