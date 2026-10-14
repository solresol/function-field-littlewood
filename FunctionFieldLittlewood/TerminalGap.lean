module

public import FunctionFieldLittlewood.DescentStep
public import Mathlib.Algebra.Polynomial.Degree.TrailingDegree

@[expose] public section

/-! Original-row gap obstruction for terminal geometric-factor multiples.
The support argument follows the ordinary 14 October proof. -/
namespace FunctionFieldLittlewood.TerminalGap
open Polynomial WindowMoments ParityDescent
variable {K : Type*} [Field K]

/-- A nonzero filter cannot vanish across a pivot with a degree-length gap
on either side. The exact original difference-row budget is included. -/
theorem gap_obstruction (V : K[X]) (hV : V ≠ 0) (b : ℕ → K)
    (M N t : ℕ) (hlo : M + V.natDegree < t)
    (hhi : t < M + N + V.natDegree) (hpivot : b t ≠ 0)
    (hgap : (∀ i, t < i → i ≤ t + V.natDegree → b i = 0) ∨
      (∀ i, t - V.natDegree ≤ i → i < t → b i = 0)) :
    ∃ k, 1 ≤ k ∧ k < N + V.natDegree ∧ filt V b (M + k) ≠ 0 := by
  classical
  rcases hgap with ha | hb
  · let h := V.natTrailingDegree
    have hh : h ≤ V.natDegree := natTrailingDegree_le_natDegree V
    refine ⟨t - h - M, by omega, by omega, ?_⟩
    rw [show M + (t - h - M) = t - h by omega, filt_range]
    have he : (∑ i ∈ Finset.range (V.natDegree + 1), V.coeff i * b (t - h + i)) =
        V.coeff h * b t := by
      rw [Finset.sum_eq_single h]
      · rw [Nat.sub_add_cancel (by omega : h ≤ t)]
      · intro i hi hne
        have hi' := Finset.mem_range.mp hi
        by_cases hil : i < h
        · rw [coeff_eq_zero_of_lt_natTrailingDegree hil, zero_mul]
        · rw [ha _ (by omega) (by omega), mul_zero]
      · intro hn
        exact False.elim (hn (Finset.mem_range.mpr (by omega)))
    rw [he]
    exact mul_ne_zero (coeff_natTrailingDegree_ne_zero.mpr hV) hpivot
  · refine ⟨t - V.natDegree - M, by omega, by omega, ?_⟩
    rw [show M + (t - V.natDegree - M) = t - V.natDegree by omega, filt_range]
    have he : (∑ i ∈ Finset.range (V.natDegree + 1),
        V.coeff i * b (t - V.natDegree + i)) = V.leadingCoeff * b t := by
      rw [Finset.sum_eq_single V.natDegree]
      · rw [Nat.sub_add_cancel (by omega : V.natDegree ≤ t), coeff_natDegree]
      · intro i hi hne
        have hi' := Finset.mem_range.mp hi
        rw [hb _ (by omega) (by omega), mul_zero]
      · simp
    rw [he]
    exact mul_ne_zero (leadingCoeff_ne_zero.mpr hV) hpivot

/-- Telescoping connects the difference stream directly to original rows. -/
theorem terminal_difference (V : K[X]) (a : ℕ → K) (N n : ℕ) :
    filt (factorQuotient K N 1 * V) a (n + 1) -
      filt (factorQuotient K N 1 * V) a n =
      filt V (fun i => a (i + N) - a i) n := by
  have hgeom : factorQuotient K N 1 * (X - 1) = X ^ N - 1 := by
    simpa using factorQuotient_mul (K := K) (one_dvd N)
  have hpoly : (X - 1) * (factorQuotient K N 1 * V) = V * (X ^ N - 1) := by
    rw [← hgeom]; ring
  have hf := congrArg (fun P => filt P a n) hpoly
  have sub (P Q : K[X]) (v : ℕ) :
      filt (P - Q) a v = filt P a v - filt Q a v := by
    have hh := filt_add (P - Q) Q a v
    rw [sub_add_cancel] at hh
    exact eq_sub_of_add_eq hh.symm
  have power (i v : ℕ) : filt (X ^ i : K[X]) a v = a (v + i) := by
    rw [← monomial_one_right_eq_X_pow, filt_monomial, one_mul]
  simp only [sub_mul, one_mul, sub, ParentWindow.filt_X_mul] at hf
  rw [filt_mul V (X ^ N - 1)] at hf
  simpa only [sub, power, show (1 : K[X]) = X ^ 0 by simp, power, Nat.add_zero]
    using hf

/-- A nonzero supported coefficient has a dyadic support representation. -/
theorem support_rep {p r n : ℕ} (hn : laiSprangStream p r n ≠ 0) :
    ∃ k h, n = 2 ^ k * (1 + 2 ^ r * h) := by
  induction n using Nat.strong_induction_on with
  | h n ih =>
    have hn0 : n ≠ 0 := by intro hz; simp [hz] at hn
    by_cases he : n % 2 = 0
    · have hhalf : n = 2 * (n / 2) := by omega
      have hh : laiSprangStream p r (n / 2) ≠ 0 := by
        rw [hhalf, laiSprangStream_even] at hn
        exact hn
      obtain ⟨k, h, hk⟩ := ih (n / 2) (Nat.div_lt_self (by omega) (by decide)) hh
      refine ⟨k + 1, h, ?_⟩
      rw [hhalf, hk, pow_succ]; ring
    · have ho : oddCore n = n := by rw [oddCore]; simp [hn0, he]
      have hm : (n - 1) % 2 ^ r = 0 := by
        by_contra hh
        simp [laiSprangStream, hn0, ho, hh] at hn
      refine ⟨0, (n - 1) / 2 ^ r, ?_⟩
      have := Nat.mod_add_div (n - 1) (2 ^ r)
      simp only [pow_zero, one_mul]
      omega

/-- The upper half of each open N-block has no supported coefficients. -/
theorem stream_upper_gap (p r q s : ℕ) (hs : 2 ^ r < s) (hsN : s < 2 ^ (r + 1)) :
    laiSprangStream p (r + 1) (q * 2 ^ (r + 1) + s) = 0 := by
  by_contra hn
  obtain ⟨k, h, hk⟩ := support_rep hn
  have hmod : (2 ^ k) % (2 ^ (r + 1)) = s := by
    have := congrArg (fun n => n % 2 ^ (r + 1)) hk
    simpa [Nat.mul_add, Nat.add_mod, Nat.mul_mod, Nat.mod_eq_of_lt hsN] using this.symm
  by_cases hkr : k < r + 1
  · have hpow : 2 ^ k ≤ 2 ^ r := Nat.pow_le_pow_right (by decide) (by omega)
    have hlt : 2 ^ k < 2 ^ (r + 1) := by rw [pow_succ]; omega
    rw [Nat.mod_eq_of_lt hlt] at hmod
    omega
  · have hd : 2 ^ (r + 1) ∣ 2 ^ k := pow_dvd_pow 2 (by omega)
    rw [Nat.mod_eq_zero_of_dvd hd] at hmod
    omega

/-- Sparse upper half-blocks provide an available one-sided pivot. -/
theorem block_pivot (b : ℕ → K) (H e M : ℕ) (hH : 2 ≤ H) (he : e < H)
    (hfirst : ∀ q, b (q * (2 * H) + 1) ≠ 0)
    (hsecond : ∀ q, b (q * (2 * H) + 2) ≠ 0)
    (hzero : ∀ q s, H < s → s < 2 * H → b (q * (2 * H) + s) = 0) :
    ∃ t, M + e < t ∧ t < M + 2 * H + e ∧ b t ≠ 0 ∧
      ((∀ i, t < i → i ≤ t + e → b i = 0) ∨
       (∀ i, t - e ≤ i → i < t → b i = 0)) := by
  classical
  let q := (M + e) / (2 * H)
  let s := (M + e) % (2 * H)
  have hdecomp : M + e = q * (2 * H) + s := by
    dsimp [q, s]
    have := Nat.mod_add_div (M + e) (2 * H)
    nlinarith
  have hs : s < 2 * H := Nat.mod_lt _ (by omega)
  let S := (Finset.range (2 * H)).filter (fun i => b (q * (2 * H) + i) ≠ 0)
  have htwo : 2 ∈ S := Finset.mem_filter.mpr
    ⟨Finset.mem_range.mpr (by omega), hsecond q⟩
  have hne : S.Nonempty := ⟨2, htwo⟩
  let u := S.max' hne
  have huS : u ∈ S := Finset.max'_mem S hne
  obtain ⟨huN, hup⟩ := Finset.mem_filter.mp huS
  have hu2 : 2 ≤ u := Finset.le_max' S 2 htwo
  have huH : u ≤ H := by
    by_contra h
    exact hup (hzero q u (by omega) (Finset.mem_range.mp huN))
  have htail : ∀ i, u < i → i < 2 * H → b (q * (2 * H) + i) = 0 := by
    intro i hi hiN
    by_contra hn
    have hiS : i ∈ S := Finset.mem_filter.mpr ⟨Finset.mem_range.mpr hiN, hn⟩
    have := Finset.le_max' S i hiS
    omega
  by_cases hsu : s < u
  · refine ⟨q * (2 * H) + u, by omega, by omega, hup, Or.inl ?_⟩
    intro i hi hie
    have hh := htail (i - q * (2 * H)) (by omega) (by omega)
    simpa only [Nat.add_sub_of_le (by omega : q * (2 * H) ≤ i)] using hh
  · have hnext : (q + 1) * (2 * H) = q * (2 * H) + 2 * H := by ring
    by_cases hp : b ((q + 1) * (2 * H)) = 0
    · refine ⟨(q + 1) * (2 * H) + 1, ?_, ?_, hfirst (q + 1), Or.inr ?_⟩
      · rw [hnext]; omega
      · rw [hnext]; omega
      · intro i hi hit
        by_cases hie : i = (q + 1) * (2 * H)
        · simpa only [hie] using hp
        · have hh := htail (i - q * (2 * H)) (by rw [hnext] at *; omega) (by rw [hnext] at *; omega)
          simpa only [Nat.add_sub_of_le (by rw [hnext] at *; omega : q * (2 * H) ≤ i)] using hh
    · refine ⟨(q + 1) * (2 * H), ?_, ?_, hp, Or.inr ?_⟩
      · rw [hnext]; omega
      · rw [hnext]; omega
      · intro i hi hit
        have hh := htail (i - q * (2 * H)) (by rw [hnext] at *; omega) (by rw [hnext] at *; omega)
        simpa only [Nat.add_sub_of_le (by rw [hnext] at *; omega : q * (2 * H) ≤ i)] using hh

/-- Values on the always-supported odd progression. -/
theorem stream_block_one (p r q : ℕ) :
    laiSprangStream p (r + 1) (q * 2 ^ (r + 1) + 1) =
      ((2 ^ r : ℕ) : ZMod p) * (-1) ^ q := by
  rw [show q * 2 ^ (r + 1) + 1 = 2 * (q * 2 ^ r) + 1 by rw [pow_succ]; ring,
    RootStream.stream_odd]
  simp

/-- The midpoint-plus-one progression is unsupported when N≥4. -/
theorem stream_block_midpoint (p r q : ℕ) :
    laiSprangStream p (r + 2) (q * 2 ^ (r + 2) + 2 ^ (r + 1) + 1) = 0 := by
  apply stream_upper_gap p (r + 1) q (2 ^ (r + 1) + 1) (by omega)
  have hp : 0 < 2 ^ r := by positivity
  simp only [pow_succ]
  omega

/-- Adjacent terminal-row differences have nonzero offsets one and two. -/
theorem stream_difference_pivots {p : ℕ} [Fact p.Prime] (hp : 2 < p) (r q : ℕ) :
    let N := 2 ^ (r + 2)
    let a := laiSprangStream p (r + 2)
    a (q * N + 1 + N) - a (q * N + 1) ≠ 0 ∧
      a (q * N + 2 + N) - a (q * N + 2) ≠ 0 := by
  dsimp only
  have htwo : (2 : ZMod p) ≠ 0 := by
    intro h
    have : p ∣ 2 := (ZMod.natCast_eq_zero_iff 2 p).mp h
    have := Nat.le_of_dvd (by decide : 0 < 2) this
    omega
  have hH : ((2 ^ (r + 1) : ℕ) : ZMod p) ≠ 0 := by
    simpa only [Nat.cast_pow, Nat.cast_ofNat] using pow_ne_zero (r + 1) htwo
  constructor
  · rw [show q * 2 ^ (r + 2) + 1 + 2 ^ (r + 2) =
      (q + 1) * 2 ^ (r + 2) + 1 by ring, stream_block_one, stream_block_one,
      pow_succ (-1 : ZMod p) q]
    have he : ((2 ^ (r + 1) : ℕ) : ZMod p) * ((-1) ^ q * (-1)) -
        ((2 ^ (r + 1) : ℕ) : ZMod p) * (-1) ^ q =
        -2 * (((2 ^ (r + 1) : ℕ) : ZMod p) * (-1) ^ q) := by ring
    rw [he]
    exact mul_ne_zero (neg_ne_zero.mpr htwo) (mul_ne_zero hH (pow_ne_zero _ (neg_ne_zero.mpr one_ne_zero)))
  · have half (j : ℕ) : laiSprangStream p (r + 2) (j * 2 ^ (r + 2) + 2) =
        laiSprangStream p (r + 2) (j * 2 ^ (r + 1) + 1) := by
      rw [show j * 2 ^ (r + 2) + 2 = 2 * (j * 2 ^ (r + 1) + 1) by
        rw [show r + 2 = (r + 1) + 1 by omega, pow_succ]; ring,
        laiSprangStream_even]
    rw [show q * 2 ^ (r + 2) + 2 + 2 ^ (r + 2) =
      (q + 1) * 2 ^ (r + 2) + 2 by ring, half, half]
    rcases Nat.even_or_odd q with ⟨l, hl⟩ | ⟨l, hl⟩
    · have heq : q = 2 * l := by omega
      rw [heq,
        show (2 * l + 1) * 2 ^ (r + 1) + 1 =
          l * 2 ^ (r + 2) + 2 ^ (r + 1) + 1 by rw [show r + 2 = (r + 1) + 1 by omega, pow_succ]; ring,
        show 2 * l * 2 ^ (r + 1) + 1 = l * 2 ^ (r + 2) + 1 by
          rw [show r + 2 = (r + 1) + 1 by omega, pow_succ]; ring,
        stream_block_midpoint, stream_block_one, zero_sub]
      exact neg_ne_zero.mpr (mul_ne_zero hH (pow_ne_zero _ (neg_ne_zero.mpr one_ne_zero)))
    · have heq : q = 2 * l + 1 := by omega
      rw [heq,
        show (2 * l + 1 + 1) * 2 ^ (r + 1) + 1 = (l + 1) * 2 ^ (r + 2) + 1 by
          rw [show r + 2 = (r + 1) + 1 by omega, pow_succ]; ring,
        show (2 * l + 1) * 2 ^ (r + 1) + 1 =
          l * 2 ^ (r + 2) + 2 ^ (r + 1) + 1 by rw [show r + 2 = (r + 1) + 1 by omega, pow_succ]; ring,
        stream_block_one, stream_block_midpoint, sub_zero]
      exact mul_ne_zero hH (pow_ne_zero _ (neg_ne_zero.mpr one_ne_zero))

/-- Every nonzero low-degree terminal quotient has a nonzero ORIGINAL row.
This holds for every odd prime, without requiring N to divide p-1. -/
theorem terminal_nonvanishing {p : ℕ} [Fact p.Prime] (hp : 2 < p)
    (r : ℕ) (V : (ZMod p)[X]) (hV : V ≠ 0) (M : ℕ)
    (he : V.natDegree < 2 ^ (r + 1)) :
    ∃ k, 1 ≤ k ∧ k ≤ 2 ^ (r + 2) + V.natDegree ∧
      filt (factorQuotient (ZMod p) (2 ^ (r + 2)) 1 * V)
        (laiSprangStream p (r + 2)) (M + k) ≠ 0 := by
  let a := laiSprangStream p (r + 2)
  let b := fun i => a (i + 2 ^ (r + 2)) - a i
  have hN : 2 ^ (r + 2) = 2 * 2 ^ (r + 1) := by
    rw [show r + 2 = (r + 1) + 1 by omega, pow_succ]; ring
  have hpiv := stream_difference_pivots hp r
  have hb1 : ∀ q, b (q * (2 * 2 ^ (r + 1)) + 1) ≠ 0 := by
    intro q
    simpa only [b, a, ← hN] using (hpiv q).1
  have hb2 : ∀ q, b (q * (2 * 2 ^ (r + 1)) + 2) ≠ 0 := by
    intro q
    simpa only [b, a, ← hN] using (hpiv q).2
  have hb0 : ∀ q s, 2 ^ (r + 1) < s → s < 2 * 2 ^ (r + 1) →
      b (q * (2 * 2 ^ (r + 1)) + s) = 0 := by
    intro q s hs hsN
    simp only [b, a, ← hN]
    rw [show q * 2 ^ (r + 2) + s + 2 ^ (r + 2) =
      (q + 1) * 2 ^ (r + 2) + s by ring,
      stream_upper_gap p (r + 1) (q + 1) s hs (hN ▸ hsN),
      stream_upper_gap p (r + 1) q s hs (hN ▸ hsN), sub_self]
  have hH : 2 ≤ 2 ^ (r + 1) := by
    have : 0 < 2 ^ r := by positivity
    rw [pow_succ]; omega
  obtain ⟨t, htlo, hthi, hbt, hgap⟩ :=
    block_pivot b (2 ^ (r + 1)) V.natDegree M hH he hb1 hb2 hb0
  obtain ⟨k, hk, hkN, hrow⟩ := gap_obstruction V hV b M (2 ^ (r + 2)) t
    htlo (by simpa only [hN] using hthi) hbt hgap
  by_contra! hw
  have h₀ := hw k hk (by omega)
  have h₁ := hw (k + 1) (by omega) (by omega)
  have hd := terminal_difference V a (2 ^ (r + 2)) (M + k)
  rw [show M + k + 1 = M + (k + 1) by omega, h₁, h₀, sub_self] at hd
  exact hrow hd.symm

/-- A terminal zero window forces quotient degree at least N/2. -/
theorem terminal_degree_bound {p : ℕ} [Fact p.Prime] (hp : 2 < p)
    (r : ℕ) (S : (ZMod p)[X]) (hS : S ≠ 0)
    (hf : factorQuotient (ZMod p) (2 ^ (r + 2)) 1 ∣ S) (M : ℕ)
    (hw : ∀ i, 1 ≤ i → i ≤ S.natDegree + 1 →
      filt S (laiSprangStream p (r + 2)) (M + i) = 0) :
    2 ^ (r + 2) + 2 ^ (r + 1) - 1 ≤ S.natDegree := by
  obtain ⟨V, rfl⟩ := hf
  have hV : V ≠ 0 := by intro hz; simp [hz] at hS
  have hg := ParentWindow.factorQuotient_degree (K := ZMod p)
    (by positivity : 0 < 2 ^ (r + 2)) (one_dvd (2 ^ (r + 2)))
  have hdeg := natDegree_mul hg.1 hV
  by_contra hn
  have he : V.natDegree < 2 ^ (r + 1) := by omega
  obtain ⟨i, hi, himax, hin⟩ := terminal_nonvanishing hp r V hV M he
  exact hin (hw i hi (by omega))

/-- Iteration with the proved original-row terminal bound as its base. -/
theorem iterated_degree_bound {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ (r + 1) * (2 * k + 1))
    (j : ℕ) (hj : j ≤ r + 2) (R : (ZMod p)[X]) (hR : R ≠ 0)
    (hfactor : factorQuotient (ZMod p) (2 ^ (r + 2)) (2 ^ j) ∣ R)
    (m : ℕ) (hw : ∀ i, 1 ≤ i → i ≤ R.natDegree + 2 ^ j →
      filt R (laiSprangStream p (r + 2)) (m + i) = 0) :
    2 ^ j * (2 ^ (r + 2) + 2 ^ (r + 1) - 1) ≤ R.natDegree := by
  induction j generalizing R m with
  | zero =>
    simpa only [pow_zero, one_mul] using
      terminal_degree_bound hp r R hR (by simpa only [pow_zero] using hfactor) m
        (by simpa only [pow_zero] using hw)
  | succ j ih =>
    have hs : 2 ^ j ∣ 2 ^ (r + 1) := pow_dvd_pow 2 (by omega)
    have hpow : 2 ^ (j + 1) = 2 * 2 ^ j := by rw [pow_succ, Nat.mul_comm]
    have hN : 2 ^ (r + 2) = 2 * 2 ^ (r + 1) := by
      rw [show r + 2 = (r + 1) + 1 by omega, pow_succ]; ring
    have hm : 2 * (m / 2) + m % 2 = m := by omega
    obtain ⟨S, hS, hdegS, hfS, hwS⟩ := DescentStep.stream_descent_step hp hs horder R hR
      (by simpa only [hN, hpow] using hfactor)
      (R.natDegree / 2) (m / 2) (R.natDegree % 2) (m % 2)
      (by omega) (by omega) (by omega)
      (by simpa only [hm, ← hpow] using hw)
    have hb := ih (by omega) S hS (by simpa only [hN] using hfS)
      (m / 2 + R.natDegree % 2 * (m % 2)) (by simpa only [hdegS] using hwS)
    rw [hdegS] at hb
    rw [hpow, mul_assoc]
    omega

/-- The stronger all-shift cutoff N(3N/2-1), for valuation at least two.
Here N=2^(r+2); neither the all-degree bound nor a terminal hypothesis is assumed. -/
theorem stream_nonvanishing_below_cutoff {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ (r + 1) * (2 * k + 1))
    (R : (ZMod p)[X]) (hR : R ≠ 0) (m : ℕ)
    (hdeg : R.natDegree < 2 ^ (r + 2) * (2 ^ (r + 2) + 2 ^ (r + 1) - 1)) :
    ∃ i, 1 ≤ i ∧ i ≤ R.natDegree + 2 ^ (r + 2) ∧
      filt R (laiSprangStream p (r + 2)) (m + i) ≠ 0 := by
  by_contra! hw
  have hf : factorQuotient (ZMod p) (2 ^ (r + 2)) (2 ^ (r + 2)) = 1 := by
    rw [factorQuotient, Nat.div_self (by positivity)]
    simp
  exact (not_lt_of_ge (iterated_degree_bound hp horder (r + 2) le_rfl R hR
    (by rw [hf]; exact one_dvd R) m hw)) hdeg

#print axioms terminal_nonvanishing
#print axioms terminal_degree_bound
#print axioms stream_nonvanishing_below_cutoff

end FunctionFieldLittlewood.TerminalGap
