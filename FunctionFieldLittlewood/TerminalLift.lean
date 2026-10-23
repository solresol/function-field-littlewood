module

public import FunctionFieldLittlewood.ParentWindow
public import FunctionFieldLittlewood.FractionalPart

@[expose] public section

/-!
Uniform reverse terminal lift from the 5 October ordinary proof. The geometric
factor kills the odd rows at every permitted dyadic scale. Exact certificates
then lift to actual polynomial products with defect 2N, without per-prime odd-row
checks. Terminal existence and the exact terminal index remain explicit inputs;
no use or assumed version of Lai--Sprang Proposition 2.3 enters these proofs.
-/
namespace FunctionFieldLittlewood.TerminalLift
open scoped BigOperators
open Polynomial WindowMoments

noncomputable section
variable {K : Type*} [Field K]

/-- A binomial multiple kills every odd-row filter, including the zero polynomial. -/
theorem odd_filter_of_dvd {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) (P : (ZMod p)[X])
    (hP : X ^ (2 ^ r) + 1 ∣ P) (w : ℕ) :
    filt P (fun u => laiSprangStream p (r + 1) (2 * u + 1)) w = 0 := by
  obtain ⟨z, _, hr, hf⟩ := RootStream.stream_filtered_root_enumeration hd
  rw [filt_range, hf]
  apply Finset.sum_eq_zero
  intro i _
  obtain ⟨Q, rfl⟩ := hP
  simp [hr i]

/-- A geometric multiple vanishes at every nontrivial N-th root. -/
theorem geometric_eval_zero {N : ℕ} (P : K[X])
    (hP : ParityDescent.factorQuotient K N 1 ∣ P) (z : K)
    (hz : z ^ N = 1) (hne : z ≠ 1) : P.eval z = 0 := by
  obtain ⟨Q, rfl⟩ := hP
  have hgeom := congrArg (fun f : K[X] => f.eval z)
    (ParityDescent.factorQuotient_mul (K := K) (one_dvd N))
  simp only [eval_mul, eval_sub, eval_pow, eval_X, eval_one, pow_one, hz, sub_self] at hgeom
  have hg := (mul_eq_zero.mp hgeom).resolve_right (sub_ne_zero.mpr hne)
  simp [hg]

/-- For s<=r, z^(2^s) is a nontrivial N-th root whenever z^(N/2)=-1.
Consequently the full geometric factor annihilates all odd rows at that scale.
No maximality of the power of two dividing p-1 is required. -/
theorem geometric_dyadic_odd_rows {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) (P : (ZMod p)[X])
    (hP : ParityDescent.factorQuotient (ZMod p) (2 ^ (r + 1)) 1 ∣ P)
    (s : ℕ) (hs : s ≤ r) (w : ℕ) :
    filt (expand (ZMod p) (2 ^ s) P)
      (fun u => laiSprangStream p (r + 1) (2 * u + 1)) w = 0 := by
  obtain ⟨z, _, hr, hf⟩ := RootStream.stream_filtered_root_enumeration hd
  have hp : 2 < p := by
    have hdiv := Nat.le_of_dvd (by have := (Fact.out : p.Prime).two_le; omega) hd
    have hpow : 2 ≤ 2 ^ (r + 1) := by rw [pow_succ]; have := Nat.two_pow_pos r; omega
    omega
  have : Fact (2 < p) := ⟨hp⟩
  rw [filt_range, hf]
  apply Finset.sum_eq_zero
  intro i _
  rw [expand_eval]
  have hN : (z i ^ (2 ^ s)) ^ (2 ^ (r + 1)) = 1 := by
    rw [← pow_mul, Nat.mul_comm, pow_mul, pow_succ, pow_mul, hr i]
    simp
  have hne : z i ^ (2 ^ s) ≠ 1 := by
    intro he
    have hpow : 2 ^ s * 2 ^ (r - s) = 2 ^ r := by rw [← pow_add, Nat.add_sub_of_le hs]
    have hbad : (-1 : ZMod p) = 1 := by
      rw [← hr i, ← hpow, pow_mul, he, one_pow]
    exact ZMod.neg_one_ne_one hbad
  rw [geometric_eval_zero P hP _ hN hne, mul_zero]

/-- The exact all-row lift identity. The endpoint s=r+1 is included; larger
scales would require evaluating the original geometric factor at the root 1. -/
theorem geometric_dyadic_rows {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) (P : (ZMod p)[X])
    (hP : ParityDescent.factorQuotient (ZMod p) (2 ^ (r + 1)) 1 ∣ P)
    (s : ℕ) (hs : s ≤ r + 1) (v : ℕ) :
    filt (expand (ZMod p) (2 ^ s) P) (laiSprangStream p (r + 1)) v =
      if 2 ^ s ∣ v then filt P (laiSprangStream p (r + 1)) (v / 2 ^ s) else 0 := by
  induction s generalizing v with
  | zero => simp
  | succ s ih =>
    rw [pow_succ', ← expand_expand, ParentWindow.filt_expand]
    by_cases he : v % 2 = 0
    · have hseq : (fun i => laiSprangStream p (r + 1) (v + 2 * i)) =
          (fun i => laiSprangStream p (r + 1) (v / 2 + i)) := by
        funext i
        rw [show v + 2 * i = 2 * (v / 2 + i) by omega, laiSprangStream_even]
      rw [hseq]
      have hshift : filt (expand (ZMod p) (2 ^ s) P)
          (fun i => laiSprangStream p (r + 1) (v / 2 + i)) 0 =
          filt (expand (ZMod p) (2 ^ s) P) (laiSprangStream p (r + 1)) (v / 2) := by
        simp [filt]
      rw [hshift, ih (by omega)]
      have hv : v = 2 * (v / 2) := by omega
      have hdvd : 2 * 2 ^ s ∣ v ↔ 2 ^ s ∣ v / 2 := by
        conv_lhs => rw [hv]
        exact Nat.mul_dvd_mul_iff_left (by decide)
      simp only [hdvd, Nat.div_div_eq_div_mul]
    · have hseq : (fun i => laiSprangStream p (r + 1) (v + 2 * i)) =
          (fun i => laiSprangStream p (r + 1) (2 * (v / 2 + i) + 1)) := by
        funext i
        congr 1
        omega
      rw [hseq]
      have hshift : filt (expand (ZMod p) (2 ^ s) P)
          (fun i => laiSprangStream p (r + 1) (2 * (v / 2 + i) + 1)) 0 =
          filt (expand (ZMod p) (2 ^ s) P)
            (fun u => laiSprangStream p (r + 1) (2 * u + 1)) (v / 2) := by
        simp [filt]
      rw [hshift, geometric_dyadic_odd_rows hd P hP s (by omega)]
      have hnd : ¬ 2 * 2 ^ s ∣ v := by
        intro h
        have := (dvd_mul_right 2 (2 ^ s)).trans h
        exact he (Nat.mod_eq_zero_of_dvd this)
      simp [hnd]

/-- The actual coefficient vector of a polynomial, including its leading term. -/
def coefficients (P : K[X]) : Fin (P.natDegree + 1) → K := fun i => P.coeff i.val

theorem coefficients_reconstruct (P : K[X]) : multiplierPolynomial (coefficients P) = P :=
  multiplierPolynomial_reconstruct P le_rfl

theorem fractionalCoeff_coefficients (P : K[X]) (a : ℕ → K) (m k : ℕ) :
    fractionalCoeff a (coefficients P) m k = filt P a (m + k) := by
  rw [fractionalCoeff, filt_range, ← Fin.sum_univ_eq_sum_range]
  apply Finset.sum_congr rfl
  intro i _
  simp only [coefficients]
  rw [show m + i.val + k = m + k + i.val by omega]

/-- Every exact certificate of a geometric multiple lifts at all allowed scales.
Both endpoints and the first nonzero row are transported, not assumed afresh. -/
theorem certificate_dyadic {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) (P : (ZMod p)[X])
    (hP : ParityDescent.factorQuotient (ZMod p) (2 ^ (r + 1)) 1 ∣ P)
    (M j s : ℕ) (hs : s ≤ r + 1)
    (h : ExactCertificate (laiSprangStream p (r + 1)) (coefficients P) M j) :
    ExactCertificate (laiSprangStream p (r + 1))
      (coefficients (expand (ZMod p) (2 ^ s) P)) (2 ^ s * M) (2 ^ s * j) := by
  have hpow : 0 < 2 ^ s := Nat.two_pow_pos s
  obtain ⟨hj, h0, hdg, hrows, hlast⟩ := h
  refine ⟨Nat.mul_pos hpow hj, ?_, ?_, ?_, ?_⟩
  · simpa [coefficients, coeff_expand hpow] using h0
  · simpa [coefficients, natDegree_expand] using hdg
  · intro i
    rw [fractionalCoeff_coefficients, geometric_dyadic_rows hd P hP s hs]
    split_ifs with hv
    · have hk : 2 ^ s ∣ i.val + 1 :=
        (Nat.dvd_add_right (dvd_mul_right (2 ^ s) M)).mp hv
      have hkpos : 0 < (i.val + 1) / 2 ^ s :=
        Nat.div_pos (Nat.le_of_dvd (by omega) hk) hpow
      have hlt : (i.val + 1) / 2 ^ s < j := by
        apply (Nat.div_lt_iff_lt_mul hpow).mpr
        have hb : i.val + 1 < 2 ^ s * j := by have := i.isLt; omega
        simpa only [Nat.mul_comm] using hb
      have hr := hrows ⟨(i.val + 1) / 2 ^ s - 1, by omega⟩
      rw [fractionalCoeff_coefficients] at hr
      have hvdiv : (2 ^ s * M + (i.val + 1)) / 2 ^ s = M + (i.val + 1) / 2 ^ s := by
        rw [Nat.mul_add_div hpow]
      rw [hvdiv]
      simpa only [Nat.sub_add_cancel (by omega : 1 ≤ (i.val + 1) / 2 ^ s)] using hr
    · rfl
  · rw [fractionalCoeff_coefficients, ← Nat.mul_add, geometric_dyadic_rows hd P hP s hs,
      ite_eq_left (dvd_mul_right _ _), Nat.mul_div_cancel_left _ hpow]
    rwa [fractionalCoeff_coefficients] at hlast

/-- An endpoint-admissible terminal certificate with j=deg P+2 gives an actual
polynomial of Littlewood product 2^(-2N), uniformly in p. This is an implication,
not existence of a terminal certificate or the global optimality theorem. -/
theorem terminal_product {p r : ℕ} [Fact p.Prime]
    (hd : 2 ^ (r + 1) ∣ p - 1) (P : (ZMod p)[X])
    (hP : ParityDescent.factorQuotient (ZMod p) (2 ^ (r + 1)) 1 ∣ P)
    (M : ℕ)
    (h : ExactCertificate (laiSprangStream p (r + 1)) (coefficients P) M (P.natDegree + 2)) :
    polynomialLittlewoodProduct (laiSprangStream p (r + 1))
      (X ^ (2 ^ (r + 1) * M) * expand (ZMod p) (2 ^ (r + 1)) P) =
      (2 : ℝ) ^ (-2 * (2 ^ (r + 1) : ℕ) : ℤ) := by
  have hc := certificate_dyadic hd P hP M (P.natDegree + 2) (r + 1) le_rfl h
  have hp := certificate_polynomialLittlewoodProduct _ _ _ _ hc
  rw [coefficients_reconstruct, natDegree_expand] at hp
  rw [hp]
  congr 1
  push_cast
  ring

end
end FunctionFieldLittlewood.TerminalLift
