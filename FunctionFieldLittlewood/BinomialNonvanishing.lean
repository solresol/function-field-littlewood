module

public import FunctionFieldLittlewood.DescentStep

@[expose] public section

/-!
Coefficient-row form of Lai--Sprang, arXiv:2606.00633v1, Proposition 2.3.
Unlike the surplus-halving cutoff, this descent preserves X^N-1 and needs
only degree-many zero rows. The argument uses the infinite named support
stream; it does not identify it with the full rational-function Laurent sum.
-/
namespace FunctionFieldLittlewood.BinomialNonvanishing
open scoped BigOperators
open Polynomial WindowMoments ParentWindow ParityDescent DescentStep

variable {K : Type*} [Field K]

theorem binomial_product (H : ℕ) :
    (X ^ H - 1 : K[X]) * (X ^ H + 1) = X ^ (2 * H) - 1 := by
  rw [pow_mul]
  ring

/-- A degree-many zero window for an X^N-1 multiple descends to a
nonzero half-degree X^N-1 multiple. Every shift/degree parity is retained. -/
theorem stream_binomial_descent {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (R : (ZMod p)[X]) (hR : R ≠ 0)
    (hfactor : (X ^ (2 * 2 ^ r) - 1) ∣ R)
    (q n epsilon delta : ℕ) (he : epsilon ≤ 1) (hd : delta ≤ 1)
    (hdeg : R.natDegree = 2 * q + epsilon)
    (hw : ∀ j, 1 ≤ j → j ≤ R.natDegree →
      filt R (laiSprangStream p (r + 1)) (2 * n + delta + j) = 0) :
    ∃ S : (ZMod p)[X], S ≠ 0 ∧ S.natDegree = q ∧
      (X ^ (2 * 2 ^ r) - 1) ∣ S ∧
      ∀ j, 1 ≤ j → j ≤ q →
        filt S (laiSprangStream p (r + 1)) (n + epsilon * delta + j) = 0 := by
  let g : (ZMod p)[X] := X ^ (2 ^ r) - 1
  have hg : g ≠ 0 := by
    simpa [g] using X_pow_sub_C_ne_zero (by positivity : 0 < 2 ^ r) (1 : ZMod p)
  have hgdeg : g.natDegree = 2 ^ r := by
    simp only [g, ← C_1, natDegree_X_pow_sub_C]
  have hexpand : expand (ZMod p) 2 g = X ^ (2 * 2 ^ r) - 1 := by
    simp [g, ← pow_mul]
  obtain ⟨U, hU⟩ := hfactor
  rw [← hexpand] at hU
  let E := g * evenPart U
  let O := g * oddPart U
  have hsplit : R = expand (ZMod p) 2 E + X * expand (ZMod p) 2 O :=
    hU.trans (factored_parity_split g U)
  have hquot := quotient_degree_bounds g (evenPart U) (oddPart U) hg q epsilon he
    (hsplit ▸ hdeg)
  have hrows := parent_windows R E O _ (laiSprangStream_even p (r + 1))
    hsplit q 0 n epsilon delta he hd (by
      simpa only [Nat.add_zero, Nat.mul_zero, hdeg] using hw)
  have hpdiv : 2 ^ (r + 1) ∣ p - 1 := by
    refine ⟨2 * k + 1, ?_⟩
    simpa [pow_succ, Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using horder
  obtain ⟨z, hz, hr, _, ha⟩ := RootStream.stream_root_enumeration hpdiv
  have hm := windows_moments (laiSprangStream p (r + 1)) z g
    (evenPart U) (oddPart U) n delta (q + epsilon * delta)
    (q + epsilon * (1 - delta))
    (by
      intro h
      have hb := hquot.2 h
      rw [hgdeg] at hb
      interval_cases epsilon <;> interval_cases delta <;> simp_all <;> omega)
    (by
      intro h
      have hb := hquot.1 h
      rw [hgdeg] at hb
      omega)
    (by simpa only [Nat.add_zero, ha] using hrows.1)
    (by simpa only [Nat.add_zero, ha] using hrows.2)
  have hf := prime_parity_binomial_dvd hp (by positivity : 0 < 2 ^ r) horder
    z hz hr g (evenPart U) (oddPart U) (n + delta)
    (by
      intro i hi
      have : Fact (2 < p) := ⟨hp⟩
      simp only [g, eval_sub, eval_pow, eval_X, eval_one, hr i] at hi
      exact ZMod.neg_one_ne_one (sub_eq_zero.mp hi))
    (by simpa only [Nat.add_assoc] using hm)
  have hE' := mul_dvd_mul_left g hf.1
  have hO' := mul_dvd_mul_left g hf.2
  have hE : (X ^ (2 * 2 ^ r) - 1) ∣ E := by
    simpa only [g, binomial_product] using hE'
  have hO : (X ^ (2 * 2 ^ r) - 1) ∣ O := by
    simpa only [g, binomial_product] using hO'
  have hzE := odd_filter_zero hpdiv E ((dvd_mul_left _ g).trans hE')
  have hzO := odd_filter_zero hpdiv O ((dvd_mul_left _ g).trans hO')
  have hlead := leading_child R E O hR hsplit q epsilon he hdeg
  refine ⟨if epsilon = 0 then E else O, hlead.1, hlead.2, ?_, ?_⟩
  · split_ifs
    · exact hE
    · exact hO
  · intro j hj hmj
    interval_cases epsilon
    · simp only [↓reduceIte, Nat.zero_mul, Nat.add_zero]
      have h := hrows.1 (j - 1) (by omega)
      rw [hzO, add_zero] at h
      convert h using 1; congr 1; omega
    · simp only [Nat.one_ne_zero, ↓reduceIte, Nat.one_mul]
      have h := hrows.2 (j - 1) (by omega)
      rw [hzE, add_zero] at h
      convert h using 1; congr 1; omega

/-- Proposition 2.3 in finite coefficient-row form, proved by strict
degree descent. No endpoint or target-existence hypothesis is imposed. -/
theorem stream_binomial_nonvanishing {p r k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (R : (ZMod p)[X]) (hR : R ≠ 0)
    (hfactor : (X ^ (2 * 2 ^ r) - 1) ∣ R) (m : ℕ) :
    ∃ j, 1 ≤ j ∧ j ≤ R.natDegree ∧
      filt R (laiSprangStream p (r + 1)) (m + j) ≠ 0 := by
  suffices ∀ d, ∀ R : (ZMod p)[X], R.natDegree = d → R ≠ 0 →
      (X ^ (2 * 2 ^ r) - 1) ∣ R → ∀ m,
      ¬ (∀ j, 1 ≤ j → j ≤ d →
        filt R (laiSprangStream p (r + 1)) (m + j) = 0) by
    by_contra! hw
    exact this R.natDegree R rfl hR hfactor m hw
  intro d
  induction d using Nat.strong_induction_on with
  | h d ih =>
    intro R hdeg hR hfactor m hw
    have hN := natDegree_le_of_dvd hfactor hR
    have hNd : (X ^ (2 * 2 ^ r) - 1 : (ZMod p)[X]).natDegree = 2 * 2 ^ r := by
      simp only [← C_1, natDegree_X_pow_sub_C]
    rw [hNd, hdeg] at hN
    have hpos := Nat.two_pow_pos r
    obtain ⟨S, hS, hdS, hfS, hwS⟩ := stream_binomial_descent hp horder R hR hfactor
      (d / 2) (m / 2) (d % 2) (m % 2) (by omega) (by omega)
      (by omega) (by simpa only [show 2 * (m / 2) + m % 2 = m by omega, hdeg] using hw)
    exact ih (d / 2) (by omega) S hdS hS hfS
      (m / 2 + d % 2 * (m % 2)) hwS

end FunctionFieldLittlewood.BinomialNonvanishing
