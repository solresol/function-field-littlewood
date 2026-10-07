module

public import FunctionFieldLittlewood.RootStream

@[expose] public section

/-! Finite parity-row windows imply the root moments used in parity descent.
The parity split of the original parent polynomial remains a separate step.
The convolution follows Lai--Sprang Section 3 and the 2 October research note. -/
namespace FunctionFieldLittlewood.WindowMoments
open scoped BigOperators
open Polynomial
variable {K : Type*} [Field K]

/-- Forward polynomial filter, including the zero polynomial. -/
noncomputable def filt (P : K[X]) (a : ℕ → K) (n : ℕ) : K :=
  P.sum fun i c => c * a (n + i)

theorem filt_range (P : K[X]) (a : ℕ → K) (n : ℕ) :
    filt P a n = ∑ i ∈ Finset.range (P.natDegree + 1), P.coeff i * a (n + i) :=
  P.sum_over_range (by simp)

@[simp] theorem filt_add (P Q : K[X]) (a : ℕ → K) (n : ℕ) :
    filt (P + Q) a n = filt P a n + filt Q a n := by
  exact sum_add_index _ _ _ (by simp) (by intros; simp [add_mul])

@[simp] theorem filt_monomial (i : ℕ) (c : K) (a : ℕ → K) (n : ℕ) :
    filt (monomial i c) a n = c * a (n + i) := by simp [filt]

theorem filt_seq_add (P : K[X]) (a b : ℕ → K) (n : ℕ) :
    filt P (fun j => a j + b j) n = filt P a n + filt P b n := by
  simp [filt, mul_add, Polynomial.sum_def, Finset.sum_add_distrib]

/-- Composition is multiplication; no truncation or endpoint hypothesis. -/
theorem filt_mul (P Q : K[X]) (a : ℕ → K) (n : ℕ) :
    filt (P * Q) a n = filt P (fun j => filt Q a j) n := by
  induction P using Polynomial.induction_on' with
  | add P R hP hR => simp [add_mul, hP, hR]
  | monomial i c =>
    induction Q using Polynomial.induction_on' with
    | add Q R hQ hR => simp [mul_add, hQ, hR, mul_add]
    | monomial j d => simp [monomial_mul_monomial, Nat.add_assoc, mul_assoc]

/-- Odd-subsequence filtering is a root moment. -/
theorem filt_roots {H : ℕ} (z : Fin H → K) (P : K[X]) (n : ℕ) :
    filt P (fun u => ∑ i, z i ^ u) n = ∑ i, z i ^ n * P.eval (z i) := by
  rw [filt_range]
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  rw [eval_eq_sum_range, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  rw [pow_add]
  ring

/-- Cross-convolving the two parity systems cancels their stream terms.
The hypotheses refer only to the finite rows used by the two filters. -/
theorem cross_moment {H : ℕ} (a : ℕ → K) (z : Fin H → K)
    (g U₀ U₁ : K[X]) (w : ℕ)
    (h₀ : ∀ i ∈ U₁.support,
      filt (g * U₀) a (w + 1 + i) +
        filt (g * U₁) (fun u => ∑ j, z j ^ u) (w + 1 + i) = 0)
    (h₁ : ∀ i ∈ U₀.support,
      filt (g * U₁) a (w + 1 + i) +
        filt (g * U₀) (fun u => ∑ j, z j ^ u) (w + i) = 0) :
    ∑ i, z i ^ w * (g.eval (z i) *
      ((U₀.eval (z i)) ^ 2 - z i * (U₁.eval (z i)) ^ 2)) = 0 := by
  classical
  have he₀ : filt U₁ (fun v => filt (g * U₀) a (v + 1) +
      filt (g * U₁) (fun u => ∑ j, z j ^ u) (v + 1)) w = 0 := by
    rw [filt]
    rw [Polynomial.sum_def]
    apply Finset.sum_eq_zero
    intro i hi
    simp only [show w + i + 1 = w + 1 + i by omega, h₀ i hi, mul_zero]
  have he₁ : filt U₀ (fun v => filt (g * U₁) a (v + 1) +
      filt (g * U₀) (fun u => ∑ j, z j ^ u) v) w = 0 := by
    rw [filt]
    rw [Polynomial.sum_def]
    apply Finset.sum_eq_zero
    intro i hi
    simp only [show w + i + 1 = w + 1 + i by omega, h₁ i hi, mul_zero]
  have shift (P Q : K[X]) (b : ℕ → K) :
      filt P (fun v => filt Q b (v + 1)) w = filt (P * Q) b (w + 1) := by
    rw [filt_mul]
    simp only [filt, Polynomial.sum_def]
    apply Finset.sum_congr rfl
    intro i _
    rw [show w + i + 1 = w + 1 + i by omega]
  rw [filt_seq_add, shift, shift] at he₀
  rw [filt_seq_add, shift, ← filt_mul] at he₁
  have hc : U₁ * (g * U₀) = U₀ * (g * U₁) := by ring
  rw [hc] at he₀
  have he : filt (U₀ * (g * U₀)) (fun u => ∑ j, z j ^ u) w -
      filt (U₁ * (g * U₁)) (fun u => ∑ j, z j ^ u) (w + 1) = 0 := by
    linear_combination he₁ - he₀
  rw [filt_roots, filt_roots, ← Finset.sum_sub_distrib] at he
  convert he using 1
  apply Finset.sum_congr rfl
  intro i _
  simp only [eval_mul, pow_succ]
  ring

/-- Exact finite row budgets produce H consecutive moments. The shift delta
may be any natural number; parity descent uses delta=0 or delta=1. -/
theorem windows_moments {H : ℕ} (a : ℕ → K) (z : Fin H → K)
    (g U₀ U₁ : K[X]) (n delta A B : ℕ)
    (hA : U₁ ≠ 0 → delta + H + U₁.natDegree ≤ A)
    (hB : U₀ ≠ 0 → H + U₀.natDegree ≤ B)
    (h₀ : ∀ l, l < A → filt (g * U₀) a (n + l + 1) +
      filt (g * U₁) (fun u => ∑ i, z i ^ u) (n + l + 1) = 0)
    (h₁ : ∀ l, l < B → filt (g * U₁) a (n + delta + l + 1) +
      filt (g * U₀) (fun u => ∑ i, z i ^ u) (n + delta + l) = 0) :
    ∀ k : Fin H, ∑ i, z i ^ (n + delta + k.val) *
      (g.eval (z i) * ((U₀.eval (z i)) ^ 2 - z i * (U₁.eval (z i)) ^ 2)) = 0 := by
  intro k
  apply cross_moment a z g U₀ U₁ (n + delta + k.val)
  · intro i hi
    have hn : U₁ ≠ 0 := by intro h; simp [h] at hi
    have hd := le_natDegree_of_mem_supp i hi
    have h := h₀ (delta + k.val + i) (by have := hA hn; omega)
    simpa only [Nat.add_assoc, Nat.add_left_comm, Nat.add_comm] using h
  · intro i hi
    have hn : U₀ ≠ 0 := by intro h; simp [h] at hi
    have hd := le_natDegree_of_mem_supp i hi
    have h := h₁ (k.val + i) (by have := hB hn; omega)
    simpa only [Nat.add_assoc, Nat.add_left_comm, Nat.add_comm] using h

/-- The parity-descent budgets for all four degree/shift parities.
Support-index bounds also apply when one quotient is zero. -/
theorem parity_row_budgets (q h s epsilon delta i₀ i₁ : ℕ)
    (he : epsilon ≤ 1) (hd : delta ≤ 1)
    (hi₁ : i₁ + h + 1 ≤ q + epsilon) (hi₀ : i₀ + h ≤ q) :
    delta + (h + s) + i₁ ≤ q + s + epsilon * delta ∧
    (h + s) + i₀ ≤ q + s + epsilon * (1 - delta) := by
  interval_cases epsilon <;> interval_cases delta <;> simp_all <;> omega

/-- Finite parity windows imply the geometric forced factor: no root-moment
vanishing hypothesis remains. Root enumeration and parity rows are still inputs. -/
theorem windows_forced_factor {p H k s : ℕ} [Fact p.Prime] (hp : 2 < p)
    (hH : 0 < H) (hs : s ∣ H) (horder : p - 1 = 2 * H * (2 * k + 1))
    (a : ℕ → ZMod p) (z : Fin H → ZMod p)
    (hz : Function.Injective z) (hr : ∀ i, z i ^ H = -1)
    (U₀ U₁ : (ZMod p)[X]) (n delta A B : ℕ)
    (hA : U₁ ≠ 0 → delta + H + U₁.natDegree ≤ A)
    (hB : U₀ ≠ 0 → H + U₀.natDegree ≤ B)
    (h₀ : ∀ l, l < A →
      filt (ParityDescent.factorQuotient (ZMod p) H s * U₀) a (n + l + 1) +
      filt (ParityDescent.factorQuotient (ZMod p) H s * U₁)
        (fun u => ∑ i, z i ^ u) (n + l + 1) = 0)
    (h₁ : ∀ l, l < B →
      filt (ParityDescent.factorQuotient (ZMod p) H s * U₁) a (n + delta + l + 1) +
      filt (ParityDescent.factorQuotient (ZMod p) H s * U₀)
        (fun u => ∑ i, z i ^ u) (n + delta + l) = 0) :
    (ParityDescent.factorQuotient (ZMod p) H s * (X ^ H + 1)) ∣
      ParityDescent.factorQuotient (ZMod p) H s * U₀ ∧
    (ParityDescent.factorQuotient (ZMod p) H s * (X ^ H + 1)) ∣
      ParityDescent.factorQuotient (ZMod p) H s * U₁ := by
  exact ParityDescent.geometric_parity_forced_factor hp hH hs horder z hz hr
    U₀ U₁ (n + delta)
    (windows_moments a z _ U₀ U₁ n delta A B hA hB h₀ h₁)

/-- For the actual Lai--Sprang stream, finite parity rows force the next
factor with neither root enumeration nor moment equations assumed.
Here r is one less than v₂(p-1), and s is half the parent surplus. -/
theorem stream_windows_forced_factor {p r k s : ℕ} [Fact p.Prime] (hp : 2 < p)
    (hs : s ∣ 2 ^ r) (horder : p - 1 = 2 * 2 ^ r * (2 * k + 1))
    (U₀ U₁ : (ZMod p)[X]) (n delta A B : ℕ)
    (hA : U₁ ≠ 0 → delta + 2 ^ r + U₁.natDegree ≤ A)
    (hB : U₀ ≠ 0 → 2 ^ r + U₀.natDegree ≤ B)
    (h₀ : ∀ l, l < A →
      filt (ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * U₀)
        (laiSprangStream p (r + 1)) (n + l + 1) +
      filt (ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * U₁)
        (fun u => laiSprangStream p (r + 1) (2 * u + 1)) (n + l + 1) = 0)
    (h₁ : ∀ l, l < B →
      filt (ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * U₁)
        (laiSprangStream p (r + 1)) (n + delta + l + 1) +
      filt (ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * U₀)
        (fun u => laiSprangStream p (r + 1) (2 * u + 1)) (n + delta + l) = 0) :
    (ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * (X ^ (2 ^ r) + 1)) ∣
      ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * U₀ ∧
    (ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * (X ^ (2 ^ r) + 1)) ∣
      ParityDescent.factorQuotient (ZMod p) (2 ^ r) s * U₁ := by
  have hd : 2 ^ (r + 1) ∣ p - 1 := by
    refine ⟨2 * k + 1, ?_⟩
    simpa [pow_succ, Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using horder
  obtain ⟨z, hz, hr, _, ha⟩ := RootStream.stream_root_enumeration hd
  simp_rw [ha] at h₀ h₁
  exact windows_forced_factor hp (by positivity) hs horder
    (laiSprangStream p (r + 1)) z hz hr U₀ U₁ n delta A B hA hB h₀ h₁

#print axioms filt_mul
#print axioms cross_moment
#print axioms windows_moments
#print axioms parity_row_budgets
#print axioms windows_forced_factor
#print axioms stream_windows_forced_factor

end FunctionFieldLittlewood.WindowMoments
