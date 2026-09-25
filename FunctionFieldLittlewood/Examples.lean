import FunctionFieldLittlewood.Certificate

namespace FunctionFieldLittlewood

/-- A small characteristic-2 fixture, deliberately not a main-conjecture candidate.
The arbitrary tail demonstrates that the witness only depends on a prefix. -/
def binaryFixture (n : ℕ) : ZMod 2 := if n ≤ 3 then 1 else 0

def binaryMultiplier : Fin 2 → ZMod 2 := fun _ => 1

theorem binary_certificate : ExactCertificate binaryFixture binaryMultiplier 0 3 := by
  decide

theorem binary_first : FirstNonzero binaryFixture binaryMultiplier 0 3 :=
  certificate_sound _ _ _ _ binary_certificate

/-- Recorded Lai--Sprang F_3 coefficients through index 10, padded with zero.
This file proves a prefix statement. LaiSprangStream.lean additionally checks the
corresponding certificate directly on the infinite support-formula stream. -/
def ternaryPrefix (n : ℕ) : ZMod 3 :=
  match n with
  | 1 => 1 | 2 => 1 | 3 => 2 | 4 => 1 | 5 => 1
  | 6 => 2 | 7 => 2 | 8 => 1 | 9 => 1 | 10 => 1
  | _ => 0

def comparisonMultiplier : Fin 3 → ZMod 3 := fun i => if i.val = 1 then 0 else 1

theorem comparison_certificate :
    ExactCertificate ternaryPrefix comparisonMultiplier 2 6 := by
  decide

/-- Any infinite stream agreeing through 10 inherits the exact index 6. -/
theorem comparison_first_of_prefix (a : ℕ → ZMod 3)
    (h : ∀ n, n ≤ 10 → ternaryPrefix n = a n) :
    FirstNonzero a comparisonMultiplier 2 6 := by
  apply certificate_sound
  exact (certificate_congr_prefix _ _ _ _ _ h).mp comparison_certificate

/-- Negative controls check the terminal index and the actual degree. -/
example : ¬ ExactCertificate binaryFixture binaryMultiplier 0 2 := by decide
example : ¬ ExactCertificate binaryFixture binaryMultiplier 0 4 := by decide
example : ¬ ExactCertificate binaryFixture
    (fun i : Fin 2 => if i.val = 0 then 1 else 0) 0 1 := by decide
example : ¬ ExactCertificate binaryFixture
    (fun i : Fin 2 => if i.val = 0 then 0 else 1) 0 1 := by decide

#print axioms certificate_sound
#print axioms certificate_congr_prefix
#print axioms hankel_kernel_iff
#print axioms checkCertificate_sound
#print axioms binary_certificate
#print axioms comparison_certificate
#print axioms comparison_first_of_prefix

end FunctionFieldLittlewood
