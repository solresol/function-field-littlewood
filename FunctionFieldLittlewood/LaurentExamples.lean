module

public import FunctionFieldLittlewood.LaurentBridge
public import FunctionFieldLittlewood.BinaryStream
public import FunctionFieldLittlewood.LaiSprangStream

@[expose] public section

/-! Named infinite-stream witnesses transported to actual Laurent multiplication.
These are coefficient statements, not norm or main-conjecture theorems. -/

namespace FunctionFieldLittlewood
noncomputable section

theorem thueMorse_laurent_first :
    LaurentFirstPositive (shiftedLaurent thueMorse Saved.thueMorseR 15) 24 :=
  (firstNonzero_iff_laurent _ _ _ _).mp thueMorse_named_optimal.1

theorem laiSprang17_laurent_sharp :
    LaurentFirstPositive
      (shiftedLaurent (laiSprangStream 17 4) (fun _ : Fin 1 => 1) 81) 16 :=
  certificate_laurent_sound _ _ _ _ laiSprang17_sharp_certificate

theorem laiSprang3_laurent_comparison :
    LaurentFirstPositive
      (shiftedLaurent (laiSprangStream 3 1) comparisonMultiplier 2) 6 :=
  certificate_laurent_sound _ _ _ _ laiSprang3_comparison_certificate

/-- Optimality now concerns actual Laurent evaluation of every degree-nine
polynomial with nonzero constant term on the named binary stream. -/
theorem thueMorse_laurent_polynomial_optimal (P : Polynomial (ZMod 2))
    (h0 : P.coeff 0 ≠ 0) (hd : P.natDegree = 9) :
    ∃ k : ℕ, 0 < k ∧ k ≤ 24 ∧
      (HahnSeries.single (-15 : ℤ) 1 *
        (P.eval₂ HahnSeries.C (HahnSeries.single (-1 : ℤ) 1 : LaurentSeries (ZMod 2)) *
          streamLaurent thueMorse)).coeff (k : ℤ) ≠ 0 :=
  optimal_laurent_polynomial _ _ _ _ _ thueMorse_named_accepted P h0 hd

-- Shift-sign control: a_3=1 is shifted to positive index 1 by t²=x⁻².
example : (shiftedLaurent (fun n => if n = 3 then (1 : ZMod 2) else 0)
    (fun _ : Fin 1 => 1) 2).coeff (1 : ℤ) = 1 := by
  simpa [fractionalCoeff] using
    shiftedLaurent_coeff (fun n => if n = 3 then (1 : ZMod 2) else 0)
      (fun _ : Fin 1 => 1) 2 1

-- A nonzero a_0 is not a fractional coefficient, including at degree/shift zero.
example (k : ℕ) (hk : 0 < k) :
    (shiftedLaurent (fun n => if n = 0 then (1 : ZMod 2) else 0)
      (fun _ : Fin 1 => 1) 0).coeff (k : ℤ) = 0 := by
  rw [shiftedLaurent_coeff]
  simp [fractionalCoeff, Nat.ne_of_gt hk]

-- The zero index cannot be an accepted first positive index.
example (f : LaurentSeries (ZMod 2)) : ¬ LaurentFirstPositive f 0 := by
  simp [LaurentFirstPositive]

-- Check the terminal boundary after transport, rather than a vanishing prefix only.
example : (shiftedLaurent (laiSprangStream 17 4) (fun _ : Fin 1 => 1) 81).coeff
    (15 : ℤ) = 0 :=
  laiSprang17_laurent_sharp.2.2 15 (by decide) (by decide)
example : (shiftedLaurent (laiSprangStream 17 4) (fun _ : Fin 1 => 1) 81).coeff
    (16 : ℤ) ≠ 0 := laiSprang17_laurent_sharp.2.1

#print axioms thueMorse_laurent_first
#print axioms laiSprang17_laurent_sharp
#print axioms laiSprang3_laurent_comparison
#print axioms thueMorse_laurent_polynomial_optimal

end
end FunctionFieldLittlewood
