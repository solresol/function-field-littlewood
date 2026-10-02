import Mathlib.LinearAlgebra.Vandermonde
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Algebra.Ring.GeomSum
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

/-!
The root-moment rigidity step in the factor-aware parity descent of
results/2026-10-02-parity-descent.md, adapting Lai--Sprang Section 3.
This file does not assume or prove the stream's all-degree bound. The parent
window-to-moment identity and the complete descent remain separate obligations.
-/

namespace FunctionFieldLittlewood.ParityDescent

open scoped BigOperators
open Polynomial

variable {K : Type*} [Field K] {H : ℕ}

/-- Consecutive moments starting at any nonnegative exponent determine all
weights, provided the roots are distinct and nonzero. -/
theorem shifted_moments_rigid (z w : Fin H → K) (n : ℕ)
    (hz : Function.Injective z) (hne : ∀ i, z i ≠ 0)
    (hm : ∀ k : Fin H, ∑ i, z i ^ (n + k.val) * w i = 0) :
    ∀ i, w i = 0 := by
  have hv : (fun i => z i ^ n * w i) = 0 := by
    apply Matrix.eq_zero_of_forall_pow_sum_mul_pow_eq_zero hz
    intro k
    convert hm k using 1
    apply Finset.sum_congr rfl
    intro i _
    rw [pow_add]
    ring
  intro i
  have hi : z i ^ n * w i = 0 := congrFun hv i
  exact (mul_eq_zero.mp hi).resolve_left (pow_ne_zero _ (hne i))

/-- The quadratic form x^2-z*y^2 is anisotropic at a nonsquare z. -/
theorem nonsquare_pair_zero (z x y : K) (hz : ¬ IsSquare z)
    (h : x ^ 2 = z * y ^ 2) : x = 0 ∧ y = 0 := by
  have hy : y = 0 := by
    by_contra hy
    apply hz
    refine ⟨x / y, ?_⟩
    rw [div_mul_div_comm]
    apply (eq_div_iff (mul_ne_zero hy hy)).mpr
    simpa only [pow_two] using h.symm
  refine ⟨?_, hy⟩
  have hx : x ^ 2 = 0 := by simpa [hy] using h
  exact eq_zero_of_pow_eq_zero hx

/-- Full root moments force both parity quotients to vanish at every root.
No nonzero constant-coefficient hypothesis is imposed on either quotient. -/
theorem parity_quotients_vanish (z : Fin H → K) (g U₀ U₁ : K[X]) (n : ℕ)
    (hz : Function.Injective z) (hne : ∀ i, z i ≠ 0)
    (hns : ∀ i, ¬ IsSquare (z i)) (hg : ∀ i, g.eval (z i) ≠ 0)
    (hm : ∀ k : Fin H, ∑ i, z i ^ (n + k.val) *
      (g.eval (z i) * ((U₀.eval (z i)) ^ 2 - z i * (U₁.eval (z i)) ^ 2)) = 0) :
    ∀ i, U₀.eval (z i) = 0 ∧ U₁.eval (z i) = 0 := by
  have hw := shifted_moments_rigid z
    (fun i => g.eval (z i) * ((U₀.eval (z i)) ^ 2 - z i * (U₁.eval (z i)) ^ 2))
    n hz hne hm
  intro i
  apply nonsquare_pair_zero (z i) _ _ (hns i)
  exact sub_eq_zero.mp ((mul_eq_zero.mp (hw i)).resolve_left (hg i))

/-- The distinct linear factors really divide both parity quotients. -/
theorem parity_quotients_dvd (z : Fin H → K) (g U₀ U₁ : K[X]) (n : ℕ)
    (hz : Function.Injective z) (hne : ∀ i, z i ≠ 0)
    (hns : ∀ i, ¬ IsSquare (z i)) (hg : ∀ i, g.eval (z i) ≠ 0)
    (hm : ∀ k : Fin H, ∑ i, z i ^ (n + k.val) *
      (g.eval (z i) * ((U₀.eval (z i)) ^ 2 - z i * (U₁.eval (z i)) ^ 2)) = 0) :
    (∏ i, (X - C (z i))) ∣ U₀ ∧ (∏ i, (X - C (z i))) ∣ U₁ := by
  classical
  have hv := parity_quotients_vanish z g U₀ U₁ n hz hne hns hg hm
  have hd (U : K[X]) (hU : ∀ i, U.eval (z i) = 0) :
      (∏ i, (X - C (z i))) ∣ U := by
    apply Finset.prod_dvd_of_coprime
    · intro i _ j _ hij
      exact pairwise_coprime_X_sub_C hz hij
    · intro i _
      exact dvd_iff_isRoot.mpr (hU i)
  exact ⟨hd U₀ (fun i => (hv i).1), hd U₁ (fun i => (hv i).2)⟩

/-- If p-1 = 2H times an odd number, every root of z^H=-1 is a
nonsquare in the prime field. This includes r=1; it does not solve the
terminal case, where the full number of moments is unavailable. -/
theorem prime_root_nonsquare {p H k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (hH : 0 < H) (horder : p - 1 = 2 * H * (2 * k + 1))
    (z : ZMod p) (hz : z ^ H = -1) : z ≠ 0 ∧ ¬ IsSquare z := by
  haveI : Fact (2 < p) := ⟨hp⟩
  have hne : z ≠ 0 := by
    intro he
    simp [he, Nat.ne_of_gt hH] at hz
  refine ⟨hne, ?_⟩
  rintro ⟨y, hy⟩
  have hyne : y ≠ 0 := by intro he; simp [he] at hy; exact hne hy
  have hpow : y ^ (p - 1) = -1 := by
    rw [horder, pow_mul, pow_mul, pow_two, ← hy, hz]
    simp [pow_add, pow_mul]
  exact ZMod.neg_one_ne_one (hpow.symm.trans (ZMod.pow_card_sub_one_eq_one hyne))

/-- H distinct roots of X^H+1 give exactly that monic product. -/
theorem root_product_eq (z : Fin H → K) (hH : 0 < H)
    (hz : Function.Injective z) (hroot : ∀ i, z i ^ H = -1) :
    (∏ i, (X - C (z i))) = X ^ H + 1 := by
  classical
  have hd : (∏ i, (X - C (z i))) ∣ (X ^ H + 1 : K[X]) := by
    apply Finset.prod_dvd_of_coprime
    · intro i _ j _ hij
      exact pairwise_coprime_X_sub_C hz hij
    · intro i _
      apply dvd_iff_isRoot.mpr
      simp [IsRoot.def, hroot i]
  symm
  apply eq_of_monic_of_dvd_of_natDegree_le (monic_prod_X_sub_C z Finset.univ)
    (by simpa using (monic_X_pow_add_C (1 : K) (Nat.ne_of_gt hH))) hd
  simp only [natDegree_finset_prod_X_sub_C_eq_card, Finset.card_univ, Fintype.card_fin]
  exact (natDegree_add_le _ _).trans (by simp)

/-- The prime-field moment block forces the binomial factor in both parity
quotients. The enumeration and the moment block are explicit hypotheses;
nonsquareness and the factor theorem are conclusions of the proof. -/
theorem prime_parity_binomial_dvd {p H k : ℕ} [Fact p.Prime] (hp : 2 < p)
    (hH : 0 < H) (horder : p - 1 = 2 * H * (2 * k + 1))
    (z : Fin H → ZMod p) (hz : Function.Injective z) (hroot : ∀ i, z i ^ H = -1)
    (g U₀ U₁ : (ZMod p)[X]) (n : ℕ) (hg : ∀ i, g.eval (z i) ≠ 0)
    (hm : ∀ j : Fin H, ∑ i, z i ^ (n + j.val) *
      (g.eval (z i) * ((U₀.eval (z i)) ^ 2 - z i * (U₁.eval (z i)) ^ 2)) = 0) :
    (X ^ H + 1) ∣ U₀ ∧ (X ^ H + 1) ∣ U₁ := by
  have hn := fun i => prime_root_nonsquare hp hH horder (z i) (hroot i)
  have hd := parity_quotients_dvd z g U₀ U₁ n hz
    (fun i => (hn i).1) (fun i => (hn i).2) hg hm
  rwa [root_product_eq z hH hz hroot] at hd

/-- The common factor g in the descent cannot vanish at a root: its defining
polynomial factorisation evaluates to -2. No division by z^s-1 is needed. -/
theorem factor_eval_ne_zero {p H s : ℕ} [Fact p.Prime] (hp : 2 < p)
    (g : (ZMod p)[X]) (hfactor : g * (X ^ s - 1) = X ^ H - 1)
    (z : ZMod p) (hz : z ^ H = -1) : g.eval z ≠ 0 := by
  haveI : Fact (2 < p) := ⟨hp⟩
  intro hg
  have he := congrArg (fun P : (ZMod p)[X] => P.eval z) hfactor
  simp only [eval_mul, eval_sub, eval_pow, eval_X, eval_one, hg, zero_mul, hz] at he
  exact ZMod.neg_one_ne_one (sub_eq_zero.mp he.symm)

/-- The polynomial quotient (X^H-1)/(X^s-1), written without division.
In the descent, H=N/2 and this parameter s is half the parent surplus. -/
noncomputable def factorQuotient (K : Type*) [Field K] (H s : ℕ) : K[X] :=
  ∑ i ∈ Finset.range (H / s), X ^ (s * i)

theorem factorQuotient_mul {s : ℕ} (hs : s ∣ H) :
    factorQuotient K H s * (X ^ s - 1) = X ^ H - 1 := by
  simpa only [factorQuotient, ← pow_mul, Nat.mul_div_cancel' hs] using
    (geom_sum_mul (X ^ s : K[X]) (H / s))

/-- The moment-to-forced-factor step for the actual geometric factor g.
The downstream window reduction must supply these H consecutive moments;
there is no assumed vanishing conclusion, nonsquareness, or g nonvanishing. -/
theorem geometric_parity_forced_factor {p H k s : ℕ} [Fact p.Prime] (hp : 2 < p)
    (hH : 0 < H) (hs : s ∣ H) (horder : p - 1 = 2 * H * (2 * k + 1))
    (z : Fin H → ZMod p) (hz : Function.Injective z) (hroot : ∀ i, z i ^ H = -1)
    (U₀ U₁ : (ZMod p)[X]) (n : ℕ)
    (hm : ∀ j : Fin H, ∑ i, z i ^ (n + j.val) *
      ((factorQuotient (ZMod p) H s).eval (z i) *
        ((U₀.eval (z i)) ^ 2 - z i * (U₁.eval (z i)) ^ 2)) = 0) :
    (factorQuotient (ZMod p) H s * (X ^ H + 1)) ∣
        factorQuotient (ZMod p) H s * U₀ ∧
    (factorQuotient (ZMod p) H s * (X ^ H + 1)) ∣
        factorQuotient (ZMod p) H s * U₁ := by
  have hd := prime_parity_binomial_dvd hp hH horder z hz hroot
    (factorQuotient (ZMod p) H s) U₀ U₁ n
    (fun i => factor_eval_ne_zero hp _ (factorQuotient_mul hs) (z i) (hroot i)) hm
  exact ⟨mul_dvd_mul_left _ hd.1, mul_dvd_mul_left _ hd.2⟩

private instance : Fact (Nat.Prime 5) := ⟨by decide⟩

/-- An instantiation at N=4 over F_5, for arbitrary quotients and shift.
Root distinctness, completeness, and nonsquareness are not hypotheses here. -/
theorem prime5_parity_binomial_dvd (U₀ U₁ : (ZMod 5)[X]) (n : ℕ)
    (hm : ∀ j : Fin 2, ∑ i : Fin 2, (![2, 3] i : ZMod 5) ^ (n + j.val) *
      ((U₀.eval (![2, 3] i)) ^ 2 - (![2, 3] i) * (U₁.eval (![2, 3] i)) ^ 2) = 0) :
    (X ^ 2 + 1) ∣ U₀ ∧ (X ^ 2 + 1) ∣ U₁ := by
  apply prime_parity_binomial_dvd (p := 5) (H := 2) (k := 0)
    (by decide) (by decide) (by decide)
    (![2, 3] : Fin 2 → ZMod 5) (by decide) (by decide) 1 U₀ U₁ n
  · simp
  · simpa using hm

/-- Dropping the second moment fails already over F_5: U₀=X-1, U₁=0
give root weights 1 and 4 at roots 2 and 3. This is a counterexample only
to the weakened moment lemma, not to the linked terminal stream statement. -/
theorem one_moment_insufficient :
    (∑ i : Fin 2, (((X - 1 : (ZMod 5)[X]).eval (![2, 3] i)) ^ 2)) = 0 ∧
    (∑ i : Fin 2, (![2, 3] i : ZMod 5) *
      (((X - 1 : (ZMod 5)[X]).eval (![2, 3] i)) ^ 2)) ≠ 0 ∧
    ¬ (X ^ 2 + 1 : (ZMod 5)[X]) ∣ X - 1 := by
  refine ⟨?_, ?_, ?_⟩
  · norm_num [Fin.sum_univ_succ]; decide
  · norm_num [Fin.sum_univ_succ]; decide
  · intro hd
    have hroot : IsRoot (X ^ 2 + 1 : (ZMod 5)[X]) 2 := by
      norm_num [IsRoot.def]; decide
    have hbad : IsRoot (X - 1 : (ZMod 5)[X]) 2 :=
      dvd_iff_isRoot.mp ((dvd_iff_isRoot.mpr hroot).trans hd)
    norm_num [IsRoot.def] at hbad

#print axioms shifted_moments_rigid
#print axioms nonsquare_pair_zero
#print axioms parity_quotients_vanish
#print axioms parity_quotients_dvd
#print axioms prime_root_nonsquare
#print axioms root_product_eq
#print axioms prime_parity_binomial_dvd
#print axioms factor_eval_ne_zero
#print axioms factorQuotient_mul
#print axioms geometric_parity_forced_factor
#print axioms prime5_parity_binomial_dvd
#print axioms one_moment_insufficient

end FunctionFieldLittlewood.ParityDescent
