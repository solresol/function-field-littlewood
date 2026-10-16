module

public import FunctionFieldLittlewood.ParityDescent
public import Mathlib.Algebra.Polynomial.Div
public import Mathlib.Algebra.Polynomial.AlgebraMap

@[expose] public section

/-! The sparse-divisor obstruction in the 16 October first-strip argument.
Here H = 2^(r+2), so r starts at zero (H=4). -/
namespace FunctionFieldLittlewood.SparseDivisor
open Polynomial
variable {K : Type*} [Field K]

/-- `a + 2X + X² + X⁴ + ... + X^(H/2) + σ X^H`, H=2^(r+2). -/
noncomputable def sparse (r : ℕ) (a σ : K) : K[X] :=
  match r with
  | 0 => C a + C 2 * X + X ^ 2 + C σ * X ^ 4
  | r + 1 => sparse r a 1 + C σ * X ^ (2 ^ (r + 3))

/-- The recursive definition equals the finite sparse polynomial in the ordinary proof. -/
theorem sparse_eq_sum (r : ℕ) (a σ : K) :
    sparse r a σ = C a + C 2 * X +
      (∑ i ∈ Finset.range (r + 1), (X : K[X]) ^ (2 ^ (i + 1))) +
      C σ * X ^ (2 ^ (r + 2)) := by
  induction r generalizing σ with
  | zero => simp [sparse]
  | succ r ih =>
    rw [sparse, ih]
    simp only [Finset.sum_range_succ, map_one, one_mul]
    ring

lemma sparse_degree (r : ℕ) (a σ : K) (hσ : σ ≠ 0) :
    (sparse r a σ).natDegree = 2 ^ (r + 2) ∧
    (sparse r a σ).leadingCoeff = σ := by
  induction r generalizing σ with
  | zero =>
    have h : (C a + C (2 : K) * X + X ^ 2).natDegree < 4 := by
      compute_degree; omega
    constructor
    · change (C a + C (2 : K) * X + X ^ 2 + C σ * X ^ 4).natDegree = 4
      rw [natDegree_add_eq_right_of_natDegree_lt
        (p := C a + C (2 : K) * X + X ^ 2) (q := C σ * X ^ 4)
        (by simpa only [natDegree_C_mul_X_pow _ _ hσ] using h)]
      exact natDegree_C_mul_X_pow _ _ hσ
    · rw [sparse, leadingCoeff_add_of_degree_lt]
      · simp
      · exact degree_lt_degree (by simpa [natDegree_C_mul_X_pow _ _ hσ] using h)
  | succ r ih =>
    have hd := (ih 1 one_ne_zero).1
    have hp : 0 < 2 ^ (r + 2) := by positivity
    have hlt : (sparse r a 1).natDegree < (C σ * X ^ (2 ^ (r + 3))).natDegree := by
      rw [hd, natDegree_C_mul_X_pow _ _ hσ]
      have he : 2 ^ (r + 3) = 2 ^ (r + 2) * 2 := by rw [show r+3 = (r+2)+1 by omega, pow_succ]
      omega
    constructor
    · simpa [sparse, natDegree_C_mul_X_pow _ _ hσ] using natDegree_add_eq_right_of_natDegree_lt hlt
    · rw [sparse, leadingCoeff_add_of_degree_lt (degree_lt_degree hlt)]
      simp

lemma sparse_reflection (r : ℕ) (a σ : K) :
    sparse r a σ - (sparse r a σ).comp (-X) = C 4 * X := by
  have hp (k : ℕ) : (-X : K[X]) ^ (2 ^ (k + 1)) = X ^ (2 ^ (k + 1)) := by
    rw [pow_succ, mul_comm, pow_mul]
    simp [← pow_mul]
  induction r generalizing σ with
  | zero => simp [sparse, add_comp, mul_comp, pow_comp, C_ofNat]; ring
  | succ r ih =>
    simp only [sparse, add_comp, mul_comp, C_comp, pow_comp, X_comp]
    rw [hp (r + 2)]
    linear_combination ih 1

/-- Above the smallest scale, coefficients through degree six are fixed. -/
lemma sparse_low_coeff (r : ℕ) (a σ : K) (i : ℕ) (hi : i ≤ 6) :
    (sparse (r + 1) a σ).coeff i = (sparse 0 a 1).coeff i := by
  induction r generalizing σ with
  | zero =>
    simp [sparse, coeff_C_mul, coeff_X_pow, show i ≠ 8 by omega]
  | succ r ih =>
    have hp : 8 ≤ 2 ^ (r + 1 + 3) := by
      have := Nat.pow_le_pow_right (n := 2) (by decide) (show 3 ≤ r + 1 + 3 by omega)
      exact this
    change (sparse (r+1) a 1 + C σ * X ^ (2^(r+1+3))).coeff i = _
    rw [coeff_add, coeff_C_mul, coeff_X_pow]
    split_ifs with he
    · omega
    · simpa using ih 1

lemma sparse_reflection_coeff_six (r : ℕ) (a σ : K) :
    (sparse r a σ * (sparse r a σ).comp (-X)).coeff 6 =
      if r = 0 then 2 * σ else 2 := by
  have href := sparse_reflection r a σ
  have hrewrite : (sparse r a σ).comp (-X) = sparse r a σ - C 4 * X := by
    linear_combination -href
  have mul6 (f g : K[X]) : (f*g).coeff 6 =
      f.coeff 0*g.coeff 6 + f.coeff 1*g.coeff 5 + f.coeff 2*g.coeff 4 +
      f.coeff 3*g.coeff 3 + f.coeff 4*g.coeff 2 + f.coeff 5*g.coeff 1 +
      f.coeff 6*g.coeff 0 := by
    have ha : Finset.antidiagonal 6 = {(0,6), (1,5), (2,4), (3,3), (4,2), (5,1), (6,0)} := by decide
    simp [coeff_mul, ha]
    ring
  rw [hrewrite, mul6]
  simp only [coeff_sub, coeff_C_mul, coeff_X]
  cases r with
  | zero => norm_num [sparse, coeff_add, coeff_C_mul, coeff_X_pow, coeff_C, coeff_X]; ring
  | succ r =>
    simp only [sparse_low_coeff r a σ 0 (by omega),
      sparse_low_coeff r a σ 1 (by omega), sparse_low_coeff r a σ 2 (by omega),
      sparse_low_coeff r a σ 3 (by omega), sparse_low_coeff r a σ 4 (by omega),
      sparse_low_coeff r a σ 5 (by omega), sparse_low_coeff r a σ 6 (by omega)]
    norm_num [sparse, coeff_add, coeff_C_mul, coeff_X_pow, coeff_C, coeff_X]

/-- Reflection converts divisibility into an exact product identity. -/
theorem reflection_product (f : K[X]) (H : ℕ) (hH : 0 < H)
    (heven : Even H) (hdeg : f.natDegree = H)
    (hlead : f.leadingCoeff ^ 2 = 1) (hfour : (4 : K) ≠ 0)
    (hdiff : f - f.comp (-X) = C 4 * X)
    (hdiv : f ∣ X ^ (2 * H) + 1) :
    f * f.comp (-X) = X ^ (2 * H) + 1 := by
  have hT : (X ^ (2 * H) + 1 : K[X]).comp (-X) = X ^ (2 * H) + 1 := by
    simp [add_comp, pow_comp, pow_mul]
  have hd : f.comp (-X) ∣ X ^ (2 * H) + 1 := by
    apply (dvd_comp_neg_X_iff _ _).mp
    rwa [hT]
  have hcX : IsCoprime f X := by
    apply IsCoprime.of_isCoprime_of_dvd_left _ hdiv
    apply IsCoprime.add_one_left_of_dvd
    exact dvd_pow_self X (by omega)
  have hc4 : IsCoprime f (C (4 : K)) := by
    exact ⟨0, C (4 : K)⁻¹, by simp [← C_mul, hfour]⟩
  have hc : IsCoprime f (f.comp (-X)) := by
    have hh := hc4.mul_right hcX
    rw [← hdiff] at hh
    exact (IsCoprime.mul_sub_left_right_iff (z := (1 : K[X])) |>.mp
      (by simpa only [mul_one] using hh))
  have hm : (f * f.comp (-X)).Monic := by
    rw [Monic, leadingCoeff_mul, comp_neg_X_leadingCoeff_eq, hdeg,
      heven.neg_one_pow, one_mul]
    simpa [pow_two] using hlead
  have hn : f ≠ 0 := by intro hz; simp [hz] at hdeg; omega
  have hnr : f.comp (-X) ≠ 0 := by simpa using hn
  have ht : (X ^ (2 * H) + 1 : K[X]).Monic := monic_X_pow_add_C _ (by omega)
  apply Eq.symm
  apply eq_of_monic_of_dvd_of_natDegree_le hm ht (hc.mul_dvd hdiv hd)
  rw [natDegree_mul hn hnr, natDegree_comp, natDegree_neg, natDegree_X, mul_one, hdeg]
  compute_degree; omega

/-- Uniform sparse-divisor obstruction; no restriction relating H to the field
characteristic is needed beyond characteristic different from two. -/
theorem sparse_not_dvd (r : ℕ) (a σ : K) (htwo : (2 : K) ≠ 0)
    (hσ : σ ^ 2 = 1) :
    ¬ sparse r a σ ∣ X ^ (2 * 2 ^ (r + 2)) + 1 := by
  intro hdiv
  have hσ0 : σ ≠ 0 := by intro hz; simp [hz] at hσ
  have hfour : (4 : K) ≠ 0 := by
    simpa only [show (2 : K) * 2 = 4 by norm_num] using mul_ne_zero htwo htwo
  have hH : 4 ≤ 2 ^ (r + 2) := by
    exact Nat.pow_le_pow_right (n := 2) (by decide) (by omega : 2 ≤ r + 2)
  have heven : Even (2 ^ (r + 2)) := by
    refine ⟨2 ^ (r + 1), ?_⟩
    rw [show r+2 = (r+1)+1 by omega, pow_succ]
    omega
  obtain ⟨hdeg, hlc⟩ := sparse_degree r a σ hσ0
  have hp := reflection_product (sparse r a σ) (2 ^ (r+2)) (by omega)
    heven hdeg (by rwa [hlc]) hfour (sparse_reflection r a σ) hdiv
  have hc := congrArg (fun f : K[X] => f.coeff 6) hp
  rw [sparse_reflection_coeff_six] at hc
  have hlarge : 6 ≠ 2 * 2 ^ (r + 2) := by omega
  simp only [coeff_add, coeff_X_pow, ite_eq_right hlarge, coeff_one, Nat.reduceEqDiff,
    ite_false, add_zero] at hc
  split_ifs at hc with hr
  · exact mul_ne_zero htwo hσ0 hc
  · exact htwo hc

end FunctionFieldLittlewood.SparseDivisor
