module

public import FunctionFieldLittlewood.FractionalPart
public import Mathlib.Algebra.Field.ZMod

@[expose] public section

/-!
Characteristic-two odd-dilation stream from the 18 November ordinary argument.
The definition uses the unit-part coefficient formula, not a finite prefix.
Identification with the infinite primitive-root sum is not assumed or formalised.
The cancellation theorem below concerns this actual infinite support stream.
All reused project sources and mathlib are Apache-2.0.
-/

namespace FunctionFieldLittlewood.OddDilation

/-- Strip factors of `ell` and test the two support residues; index zero is zero.
Intended parameters are odd prime `ell` and `N=ell^r`, `r>=1`. -/
def stream (ell N n : ℕ) : ZMod 2 :=
  if _hn : n = 0 then 0
  else if _he : 1 < ell ∧ n % ell = 0 then stream ell N (n / ell)
  else if n % N = 1 ∧ n % (ell * N) ≠ 1 then 1 else 0
termination_by n
decreasing_by exact Nat.div_lt_self (Nat.pos_of_ne_zero _hn) _he.1

@[simp] theorem stream_zero (ell N : ℕ) : stream ell N 0 = 0 := by
  rw [stream]; simp

theorem stream_mul (ell N n : ℕ) (he : 1 < ell) :
    stream ell N (ell * n) = stream ell N n := by
  by_cases hn : n = 0
  · simp [hn]
  · rw [stream]
    simp [he, hn, Nat.ne_of_gt (lt_trans Nat.zero_lt_one he)]

theorem stream_unit (ell N n : ℕ) (hn : n % ell ≠ 0) :
    stream ell N n = if n % N = 1 ∧ n % (ell * N) ≠ 1 then 1 else 0 := by
  rw [stream]
  have hz : n ≠ 0 := by intro h; simp [h] at hn
  simp [hz, hn]

/-- No positive coefficient occurs at or before N. -/
theorem stream_small (ell N n : ℕ) (he : 1 < ell) (hN : 1 < N) (hn : n ≤ N) :
    stream ell N n = 0 := by
  induction n using Nat.strong_induction_on with
  | h n ih =>
    by_cases hz : n = 0
    · simp [hz]
    · rw [stream, dite_eq_right hz]
      split_ifs with hd hs
      · exact ih (n / ell) (Nat.div_lt_self (by omega) he)
          (le_trans (Nat.div_le_self _ _) hn)
      · by_cases hlt : n < N
        · have hnmod : n % N = n := Nat.mod_eq_of_lt hlt
          have hn1 : n = 1 := by simpa [hnmod] using hs.1
          have hbig : 1 < ell * N := by nlinarith
          simp [hn1, Nat.mod_eq_of_lt hbig] at hs
        · have : n = N := by omega
          simp [this] at hs
      · rfl

/-- Unit residues have period ell*N, independently of the dilation depth. -/
theorem stream_unit_period (ell N n k : ℕ)
    (hn : n % ell ≠ 0) :
    stream ell N (n + ell * N * k) = stream ell N n := by
  have hu : (n + ell * N * k) % ell ≠ 0 := by
    simpa [Nat.add_mod, Nat.mul_mod] using hn
  rw [stream_unit _ _ _ hu, stream_unit _ _ _ hn]
  simp [Nat.add_mod, Nat.mul_mod]

theorem stream_pow (ell N a n : ℕ) (he : 1 < ell) :
    stream ell N (ell ^ a * n) = stream ell N n := by
  induction a with
  | zero => simp
  | succ a ih =>
    rw [pow_succ, Nat.mul_comm (ell ^ a) ell, Nat.mul_assoc, stream_mul _ _ _ he, ih]

private theorem add_self (z : ZMod 2) : z + z = 0 := by
  have h : (2 : ZMod 2) = 0 := by decide
  simpa only [two_mul, zero_mul] using congrArg (fun c : ZMod 2 => c * z) h

/-- The binomial filter cancels at every off-lattice row, with no finite cutoff. -/
theorem row_off_lattice (ell N a h : ℕ) (he : 1 < ell)
    (hh : ¬ ell ^ a ∣ h) :
    stream ell N (ell ^ a + h) + stream ell N ((N + 1) * ell ^ a + h) = 0 := by
  induction a generalizing h with
  | zero => simp at hh
  | succ a ih =>
    have he0 : ell ≠ 0 := by omega
    by_cases hd : ell ∣ h
    · obtain ⟨k, rfl⟩ := hd
      have hk : ¬ ell ^ a ∣ k := by
        intro hk
        apply hh
        simpa [pow_succ, Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc]
          using Nat.mul_dvd_mul_left ell hk
      have h1 : ell ^ (a + 1) + ell * k = ell * (ell ^ a + k) := by ring
      have h2 : (N + 1) * ell ^ (a + 1) + ell * k =
          ell * ((N + 1) * ell ^ a + k) := by ring
      rw [h1, h2, stream_mul _ _ _ he, stream_mul _ _ _ he]
      exact ih k hk
    · have hu : (ell ^ (a + 1) + h) % ell ≠ 0 := by
        simpa [pow_succ, Nat.add_mod, Nat.mul_mod] using
          (mt Nat.dvd_of_mod_eq_zero hd : h % ell ≠ 0)
      have hp := stream_unit_period ell N (ell ^ (a + 1) + h) (ell ^ a) hu
      have hid : ell ^ (a + 1) + h + ell * N * ell ^ a =
          (N + 1) * ell ^ (a + 1) + h := by ring
      rw [hid] at hp
      rw [hp, add_self]

/-- On the dilation lattice, every filtered row is exactly the base row. -/
theorem row_on_lattice (ell N a k : ℕ) (he : 1 < ell) :
    stream ell N (ell ^ a + ell ^ a * k) +
      stream ell N ((N + 1) * ell ^ a + ell ^ a * k) =
    stream ell N (1 + k) + stream ell N (N + 1 + k) := by
  have h1 : ell ^ a + ell ^ a * k = ell ^ a * (1 + k) := by ring
  have h2 : (N + 1) * ell ^ a + ell ^ a * k = ell ^ a * (N + 1 + k) := by ring
  rw [h1, h2, stream_pow _ _ _ _ he, stream_pow _ _ _ _ he]

/-- The inclusive base window; both absent endpoints are part of the statement. -/
theorem stream_window (ell N n : ℕ) (he : 1 < ell) (hN : 1 < N)
    (hd : ell ∣ N) (hn : n ≤ ell * N + 1) :
    stream ell N n = if n % N = 1 ∧ N < n ∧ n < ell * N + 1 then 1 else 0 := by
  by_cases hs : n ≤ N
  · rw [stream_small ell N n he hN hs]
    simp [not_lt_of_ge hs]
  · have hs' : N < n := by omega
    by_cases hz : n % ell = 0
    · have hq : n / ell ≤ N := by
        apply Nat.le_of_lt_succ
        apply (Nat.div_lt_iff_lt_mul (by omega : 0 < ell)).mpr
        nlinarith
      have hz' : n ≠ 0 := by omega
      rw [stream, dite_eq_right hz', dite_eq_left ⟨he, hz⟩,
        stream_small ell N (n / ell) he hN hq]
      have hm : n % N ≠ 1 := by
        intro hm
        have hx := Nat.mod_mod_of_dvd n hd
        rw [hm, Nat.mod_eq_of_lt he, hz] at hx
        omega
      simp [hm]
    · rw [stream_unit ell N n hz]
      by_cases hl : n < ell * N
      · have hm : n % (ell * N) ≠ 1 := by
          rw [Nat.mod_eq_of_lt hl]
          omega
        simp [hm, hs', show n < ell * N + 1 by omega]
      · have hcases : n = ell * N ∨ n = ell * N + 1 := by omega
        rcases hcases with rfl | rfl
        · simp
        · have hbig : 1 < ell * N := by nlinarith
          simp [Nat.add_mod, Nat.mod_eq_of_lt hN, Nat.mod_eq_of_lt hbig]

/-- The precise vanishing prefix at scale one, without a search bound. -/
theorem base_zero (ell N k : ℕ) (he : 2 < ell) (hN : 1 < N)
    (hd : ell ∣ N) (hk : 0 < k) (hlt : k < (ell - 1) * N) :
    stream ell N (1 + k) + stream ell N (N + 1 + k) = 0 := by
  have he' : 1 < ell := by omega
  have hsum : (ell - 1) * N + N = ell * N := by
    rw [← Nat.add_one_mul, Nat.sub_add_cancel (by omega : 1 ≤ ell)]
  rw [stream_window ell N (1 + k) he' hN hd (by omega),
    stream_window ell N (N + 1 + k) he' hN hd (by omega)]
  have hm : (N + 1 + k) % N = (1 + k) % N := by
    simp [Nat.add_mod, Nat.add_assoc]
  have hb : (1 + k) % N = 1 → N < 1 + k := by
    intro hr
    by_contra hn
    have hle : 1 + k ≤ N := by omega
    rcases lt_or_eq_of_le hle with hl | hl
    · rw [Nat.mod_eq_of_lt hl] at hr
      omega
    · rw [hl, Nat.mod_self] at hr
      omega
  by_cases hr : (1 + k) % N = 1
  · simp [hr, hm, hb hr, show N < N + 1 + k by omega,
      show 1 + k < ell * N + 1 by omega,
      show N + 1 + k < ell * N + 1 by omega]
    decide
  · simp [hr, hm]

/-- The terminal row is one, so the bound above is an exact first index. -/
theorem base_hit (ell N : ℕ) (he : 2 < ell) (hN : 1 < N) (hd : ell ∣ N) :
    stream ell N (1 + (ell - 1) * N) +
      stream ell N (N + 1 + (ell - 1) * N) = 1 := by
  have he' : 1 < ell := by omega
  have hsum : (ell - 1) * N + N = ell * N := by
    rw [← Nat.add_one_mul, Nat.sub_add_cancel (by omega : 1 ≤ ell)]
  have hbig : N < (ell - 1) * N := by nlinarith
  rw [stream_window ell N (1 + (ell - 1) * N) he' hN hd (by omega),
    stream_window ell N (N + 1 + (ell - 1) * N) he' hN hd (by omega)]
  simp [Nat.add_mod, Nat.mod_eq_of_lt hN, show
    N < 1 + (ell - 1) * N by omega, show
    1 + (ell - 1) * N < ell * N + 1 by omega, show
    ¬ N + 1 + (ell - 1) * N < ell * N + 1 by omega]

/-- Coefficient vector of 1+t^d; the endpoint condition is proved separately. -/
def binomial (d : ℕ) (i : Fin (d + 1)) : ZMod 2 :=
  (if i = 0 then 1 else 0) + (if i = Fin.last d then 1 else 0)

theorem binomial_row (a : ℕ → ZMod 2) (d m k : ℕ) :
    fractionalCoeff a (binomial d) m k = a (m + k) + a (m + d + k) := by
  classical
  simp [fractionalCoeff, binomial, add_mul, Finset.sum_add_distrib]

/-- Exact certificate for every scale, on the infinite named coefficient stream.
This even holds for all integer ell>2 and ell|N, without primality. -/
theorem certificate (ell N a : ℕ) (he : 2 < ell) (hN : 1 < N) (hd : ell ∣ N) :
    ExactCertificate (stream ell N) (binomial (N * ell ^ a))
      (ell ^ a) ((ell - 1) * N * ell ^ a) := by
  have he' : 1 < ell := by omega
  have hp : 0 < ell ^ a := pow_pos (by omega) _
  have hdpos : 0 < N * ell ^ a := Nat.mul_pos (by omega) hp
  have hjpos : 0 < (ell - 1) * N * ell ^ a :=
    Nat.mul_pos (Nat.mul_pos (by omega) (by omega)) hp
  have hzlast : (0 : Fin (N * ell ^ a + 1)) ≠ Fin.last (N * ell ^ a) := by
    intro h
    have := congrArg Fin.val h
    simp only [Fin.val_zero, Fin.val_last] at this
    omega
  refine ⟨hjpos, ?_, ?_, ?_, ?_⟩
  · simp [binomial, hzlast]
  · simp [binomial, Ne.symm hzlast]
  · intro row
    rw [binomial_row]
    have hk : 0 < row.val + 1 := by omega
    have hlt : row.val + 1 < (ell - 1) * N * ell ^ a := by have := row.isLt; omega
    have hid : ell ^ a + N * ell ^ a + (row.val + 1) =
        (N + 1) * ell ^ a + (row.val + 1) := by ring
    rw [hid]
    by_cases hl : ell ^ a ∣ row.val + 1
    · obtain ⟨k, hk'⟩ := hl
      rw [hk', row_on_lattice _ _ _ _ he']
      apply base_zero ell N k he hN hd
      · nlinarith
      · nlinarith
    · exact row_off_lattice ell N a (row.val + 1) he' hl
  · rw [binomial_row]
    have hid : ell ^ a + N * ell ^ a + (ell - 1) * N * ell ^ a =
        (N + 1) * ell ^ a + ell ^ a * ((ell - 1) * N) := by ring
    rw [hid, show (ell - 1) * N * ell ^ a = ell ^ a * ((ell - 1) * N) by ring,
      row_on_lattice _ _ _ _ he', base_hit _ _ he hN hd]
    decide

theorem first (ell N a : ℕ) (he : 2 < ell) (hN : 1 < N) (hd : ell ∣ N) :
    FirstNonzero (stream ell N) (binomial (N * ell ^ a))
      (ell ^ a) ((ell - 1) * N * ell ^ a) :=
  certificate_sound _ _ _ _ (certificate ell N a he hN hd)

/-- The actual polynomial assembled from the vector is exactly 1+t^d. -/
theorem binomial_polynomial (d : ℕ) :
    multiplierPolynomial (binomial d) = 1 + Polynomial.X ^ d := by
  classical
  have hs (j : Fin (d + 1)) :
      (∑ i : Fin (d + 1), Polynomial.monomial i.val
        (if i = j then (1 : ZMod 2) else 0)) = Polynomial.X ^ j.val := by
    rw [Finset.sum_eq_single j]
    · simp [Polynomial.monomial_one_right_eq_X_pow]
    · intro b _ hb
      simp [hb]
    · simp
  unfold multiplierPolynomial binomial
  simp only [map_add, Finset.sum_add_distrib, hs, Fin.val_zero, Fin.val_last, pow_zero]

/-- Product for an actual polynomial and Laurent series, with the shift's t-adic
order cancelled by the existing endpoint-aware bridge. -/
theorem product (ell N a : ℕ) (he : 2 < ell) (hN : 1 < N) (hd : ell ∣ N) :
    polynomialLittlewoodProduct (stream ell N)
      (Polynomial.X ^ (ell ^ a) * (1 + Polynomial.X ^ (N * ell ^ a))) =
      (2 : ℝ) ^ (-(((ell - 2) * N * ell ^ a : ℕ) : ℤ)) := by
  rw [← binomial_polynomial,
    certificate_polynomialLittlewoodProduct _ _ _ _ (certificate ell N a he hN hd)]
  congr 1
  simp only [Nat.cast_mul, Nat.cast_sub (by omega : 1 ≤ ell),
    Nat.cast_sub (by omega : 2 ≤ ell)]
  ring

/-- Defects grow beyond every fixed bound; this is not finite agreement. -/
theorem unbounded_defect (ell N B : ℕ) (he : 2 < ell) (hN : 1 < N) :
    ∃ a, N * ell ^ a + B < (ell - 1) * N * ell ^ a := by
  refine ⟨B, ?_⟩
  have hg : B < ell ^ B := Nat.lt_pow_self (by omega)
  have hf : 2 * N ≤ (ell - 1) * N := Nat.mul_le_mul_right N (by omega)
  nlinarith [pow_pos (by omega : 0 < ell) B]

/-- A negative answer to the characteristic-two counterexample screen, in the
exact certificate formulation for the actual support stream. -/
theorem arbitrarily_large_certificates (ell N B : ℕ)
    (he : 2 < ell) (hN : 1 < N) (hd : ell ∣ N) :
    ∃ a, ExactCertificate (stream ell N) (binomial (N * ell ^ a))
      (ell ^ a) ((ell - 1) * N * ell ^ a) ∧
      N * ell ^ a + B < (ell - 1) * N * ell ^ a := by
  obtain ⟨a, ha⟩ := unbounded_defect ell N B he hN
  exact ⟨a, certificate ell N a he hN hd, ha⟩

/-- Nonzero polynomial witnesses have products below every prescribed dyadic
threshold. This discharges the negative construction screen over F_2. -/
theorem arbitrarily_small_products (ell N B : ℕ)
    (he : 2 < ell) (hN : 1 < N) (hd : ell ∣ N) :
    ∃ Q : Polynomial (ZMod 2), Q ≠ 0 ∧
      polynomialLittlewoodProduct (stream ell N) Q < (2 : ℝ) ^ (-(B : ℤ)) := by
  obtain ⟨a, ha⟩ := unbounded_defect ell N B he hN
  let R := binomial (N * ell ^ a)
  have hc := certificate ell N a he hN hd
  have hR : multiplierPolynomial R ≠ 0 := by
    intro hz
    have hv := multiplierPolynomial_coeff R 0
    rw [hz, Polynomial.coeff_zero] at hv
    exact hc.2.1 hv.symm
  refine ⟨Polynomial.X ^ (ell ^ a) * multiplierPolynomial R,
    mul_ne_zero (pow_ne_zero _ Polynomial.X_ne_zero) hR, ?_⟩
  rw [certificate_polynomialLittlewoodProduct _ _ _ _ hc,
    zpow_lt_zpow_iff_right₀ (by norm_num : (1 : ℝ) < 2)]
  have hh : ((N * ell ^ a : ℕ) : ℤ) + (B : ℤ) <
      (((ell - 1) * N * ell ^ a : ℕ) : ℤ) := by exact_mod_cast ha
  omega

/-- The intended family N=ell^r, r>=1. The Lean parameter is r-1. -/
theorem power_certificate (ell r a : ℕ) (he : 2 < ell) :
    ExactCertificate (stream ell (ell ^ (r + 1)))
      (binomial (ell ^ (r + 1) * ell ^ a)) (ell ^ a)
      ((ell - 1) * ell ^ (r + 1) * ell ^ a) := by
  apply certificate ell (ell ^ (r + 1)) a he
  · exact one_lt_pow₀ (by omega : 1 < ell) (by omega)
  · exact ⟨ell ^ r, by rw [pow_succ]; ring⟩

end FunctionFieldLittlewood.OddDilation
