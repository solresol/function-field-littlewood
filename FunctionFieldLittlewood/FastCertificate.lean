module

public import FunctionFieldLittlewood.ReverseLift

@[expose] public section

/-!
Large exact certificates with natural-number arithmetic. Rows are list dot
products against a precomputed window of the support stream, so the kernel
evaluates each stream coefficient once and each row by structural recursion.
`certificate_of_check` turns the finite checks into `ExactCertificate`, and
`product_of_checks` combines them with two reverse lifts (N=4) to obtain the
Littlewood product 2^-8 for the actual polynomial X^(4M) S(t^4).
-/

namespace FunctionFieldLittlewood

/-- The support stream as a residue in [0,p). -/
def lsNat (p r n : ℕ) : ℕ :=
  if n = 0 then 0
  else if (oddCoreFuel n n - 1) % 2 ^ r = 0 then
    (if (oddCoreFuel n n - 1) / 2 ^ r % 2 = 0 then 2 ^ r / 2 else p - (2 ^ r / 2) % p) % p
  else 0

theorem lsNat_cast (p r n : ℕ) [NeZero p] :
    ((lsNat p r n : ℕ) : ZMod p) = laiSprangStream p r n := by
  rw [← laiSprangFast_eq]
  unfold lsNat laiSprangFast
  split_ifs with h0 h1 h2
  · simp
  · rw [ZMod.natCast_mod, h2, pow_zero, mul_one]
  · have h2' : (oddCoreFuel n n - 1) / 2 ^ r % 2 = 1 := by omega
    have hle : (2 ^ r / 2) % p ≤ p := le_of_lt (Nat.mod_lt _ (Nat.pos_of_ne_zero (NeZero.ne p)))
    rw [ZMod.natCast_mod, h2', pow_one, mul_neg_one, Nat.cast_sub hle, ZMod.natCast_self,
      ZMod.natCast_mod, zero_sub]
  · simp

/-- Structural dot product. -/
def dotNat : List ℕ → List ℕ → ℕ
  | x :: xs, y :: ys => x * y + dotNat xs ys
  | _, _ => 0

theorem dotNat_eq_sum (xs ys : List ℕ) (h : xs.length ≤ ys.length) :
    dotNat xs ys = ∑ i ∈ Finset.range xs.length, xs.getD i 0 * ys.getD i 0 := by
  induction xs generalizing ys with
  | nil => simp [dotNat]
  | cons x xs ih =>
    cases ys with
    | nil => simp at h
    | cons y ys =>
      simp only [List.length_cons, Nat.add_le_add_iff_right] at h
      rw [dotNat, ih ys h, List.length_cons, Finset.sum_range_succ']
      simp [add_comm]

/-- A finite sum against a coefficient list is a dot product, after casting. -/
theorem sum_eq_dot {d : ℕ} (p : ℕ) (S : List ℕ) (hS : S.length = d + 1) (h : ℕ → ℕ) :
    ∑ i : Fin (d + 1), ((S.getD i 0 : ℕ) : ZMod p) * ((h i : ℕ) : ZMod p) =
      ((dotNat S ((List.range (d + 1)).map h) : ℕ) : ZMod p) := by
  rw [dotNat_eq_sum _ _ (by simp [hS]), Nat.cast_sum, hS,
    ← Fin.sum_univ_eq_sum_range (fun i => ((S.getD i 0 * ((List.range (d + 1)).map h).getD i 0 : ℕ) : ZMod p))]
  apply Finset.sum_congr rfl
  intro i _
  have hi := i.isLt
  simp [List.getD_eq_getElem?_getD, hi]

theorem natCast_ne_zero_of_mod {p x : ℕ} (h : x % p ≠ 0) : ((x : ℕ) : ZMod p) ≠ 0 := by
  rw [Ne, ZMod.natCast_eq_zero_iff]
  exact fun hd => h (Nat.mod_eq_zero_of_dvd hd)

theorem natCast_eq_zero_of_mod {p x : ℕ} (h : x % p = 0) : ((x : ℕ) : ZMod p) = 0 := by
  rw [ZMod.natCast_eq_zero_iff]
  exact Nat.dvd_of_mod_eq_zero h

/-- Join two consecutive ranges of a bounded universal statement. Large
finite checks are split into separate declarations with this lemma, keeping
each kernel evaluation small. -/
theorem forall_lt_concat {P : ℕ → Prop} {a b c : ℕ} (h1 : ∀ k < b, P (a + k))
    (h2 : ∀ k < c, P (a + b + k)) : ∀ k < b + c, P (a + k) := by
  intro k hk
  by_cases hkb : k < b
  · exact h1 k hkb
  · have := h2 (k - b) (by omega)
    rwa [show a + b + (k - b) = a + k by omega] at this

/-- Finite natural-number checks give an exact certificate for the named stream. -/
theorem certificate_of_check (p r M d : ℕ) [NeZero p] (S w : List ℕ) (hS : S.length = d + 1)
    (hw : w = (List.range (2 * d + 2)).map (fun j => lsNat p r (M + 1 + j)))
    (h0 : S.getD 0 0 % p ≠ 0) (hd : S.getD d 0 % p ≠ 0)
    (hrows : ∀ k < d + 1, dotNat S (w.drop k) % p = 0)
    (hlast : dotNat S (w.drop (d + 1)) % p ≠ 0) :
    ExactCertificate (laiSprangStream p r) (fun i : Fin (d + 1) => ((S.getD i 0 : ℕ) : ZMod p))
      M (d + 2) := by
  have row (k : ℕ) (hk : k ≤ d + 1) :
      fractionalCoeff (laiSprangStream p r) (fun i : Fin (d + 1) => ((S.getD i 0 : ℕ) : ZMod p))
        M (k + 1) = ((dotNat S (w.drop k) : ℕ) : ZMod p) := by
    have hget : ∀ i < d + 1, (w.drop k).getD i 0 = lsNat p r (M + i + (k + 1)) := by
      intro i hi
      subst hw
      rw [List.getD_eq_getElem?_getD, List.getElem?_drop, List.getElem?_map,
        List.getElem?_range (by omega)]
      simp only [Option.map_some, Option.getD_some]
      congr 1
      omega
    have hlen : S.length ≤ (w.drop k).length := by
      subst hw
      simp only [List.length_drop, List.length_map, List.length_range, hS]
      omega
    rw [dotNat_eq_sum _ _ hlen, Nat.cast_sum, hS]
    unfold fractionalCoeff
    rw [show (∑ i : Fin (d + 1), ((S.getD i 0 : ℕ) : ZMod p) *
        laiSprangStream p r (M + i.val + (k + 1))) = ∑ i ∈ Finset.range (d + 1),
        ((S.getD i 0 : ℕ) : ZMod p) * laiSprangStream p r (M + i + (k + 1)) from
      Fin.sum_univ_eq_sum_range (fun i => ((S.getD i 0 : ℕ) : ZMod p) *
        laiSprangStream p r (M + i + (k + 1))) (d + 1)]
    apply Finset.sum_congr rfl
    intro i hi
    rw [Nat.cast_mul, hget i (Finset.mem_range.mp hi), lsNat_cast]
  refine ⟨by omega, natCast_ne_zero_of_mod h0, ?_, ?_, ?_⟩
  · simpa using natCast_ne_zero_of_mod hd
  · intro r'
    have := r'.isLt
    rw [row r'.val (by omega)]
    exact natCast_eq_zero_of_mod (hrows r'.val (by omega))
  · rw [show d + 2 = (d + 1) + 1 by omega, row (d + 1) le_rfl]
    exact natCast_ne_zero_of_mod hlast

/-- Reindex a sum over a lifted vector to the original coefficients. -/
theorem sum_liftTwo {K : Type*} [CommRing K] {d : ℕ} (R : Fin (d + 1) → K) (f : ℕ → K) :
    ∑ i : Fin (2 * d + 1), liftTwo R i * f i.val = ∑ j : Fin (d + 1), R j * f (2 * j.val) := by
  classical
  symm
  calc ∑ j : Fin (d + 1), R j * f (2 * j.val)
      = ∑ j : Fin (d + 1), liftTwo R (doubleEmb d j) * f (doubleEmb d j).val := by
        apply Finset.sum_congr rfl
        intro j _
        have hR : liftTwo R (doubleEmb d j) = R j := by
          simp only [liftTwo, doubleEmb, Function.Embedding.coeFn_mk, Nat.mul_mod_right, ite_true]
          congr 1
          ext
          simp
        rw [hR]
        rfl
    _ = ∑ i ∈ Finset.univ.map (doubleEmb d), liftTwo R i * f i.val := by rw [Finset.sum_map]
    _ = ∑ i, liftTwo R i * f i.val := by
        apply Finset.sum_subset (Finset.subset_univ _)
        intro i _ hi
        have hodd : i.val % 2 = 1 := by
          by_contra hc
          apply hi
          simp only [Finset.mem_map, Finset.mem_univ, true_and]
          refine ⟨⟨i.val / 2, by omega⟩, ?_⟩
          ext
          simp only [doubleEmb, Function.Embedding.coeFn_mk]
          omega
        simp [liftTwo, hodd]

noncomputable section

/-- N=4: natural-number checks of a terminal window and its odd-row residues
give the Littlewood product 2^-8 for the lifted polynomial. -/
theorem product_of_checks (p M d : ℕ) [Fact p.Prime] (S w : List ℕ) (hS : S.length = d + 1)
    (hw : w = (List.range (2 * d + 2)).map (fun j => lsNat p 2 (M + 1 + j)))
    (h0 : S.getD 0 0 % p ≠ 0) (hd : S.getD d 0 % p ≠ 0)
    (hrows : ∀ k < d + 1, dotNat S (w.drop k) % p = 0)
    (hlast : dotNat S (w.drop (d + 1)) % p ≠ 0)
    (hodd1 : ∀ u < 4, dotNat S ((List.range (d + 1)).map
      (fun i => lsNat p 2 (2 * (u + i) + 1))) % p = 0)
    (hodd2 : ∀ u < 4, dotNat S ((List.range (d + 1)).map
      (fun i => lsNat p 2 (2 * (u + 2 * i) + 1))) % p = 0) :
    polynomialLittlewoodProduct (laiSprangStream p 2)
      (Polynomial.X ^ (2 * (2 * M)) *
        multiplierPolynomial (liftTwo (liftTwo (fun i : Fin (d + 1) => ((S.getD i 0 : ℕ) : ZMod p))))) =
      (2 : ℝ) ^ (-8 : ℤ) := by
  have : NeZero p := ⟨(Fact.out : p.Prime).ne_zero⟩
  set R : Fin (d + 1) → ZMod p := fun i => ((S.getD i 0 : ℕ) : ZMod p) with hRdef
  have hterm := certificate_of_check p 2 M d S w hS hw h0 hd hrows hlast
  have hodd_R : ∀ u, ∑ i : Fin (d + 1), R i * laiSprangStream p 2 (2 * (u + i.val) + 1) = 0 := by
    apply stream_odd_rows
    intro u hu
    have := sum_eq_dot p S hS (fun i => lsNat p 2 (2 * (u + i) + 1))
    simp only [lsNat_cast] at this
    rw [this]
    exact natCast_eq_zero_of_mod (hodd1 u (by simpa using hu))
  have hodd_L : ∀ u, ∑ i : Fin (2 * d + 1), liftTwo R i *
      laiSprangStream p 2 (2 * (u + i.val) + 1) = 0 := by
    apply stream_odd_rows
    intro u hu
    rw [sum_liftTwo R (fun i => laiSprangStream p 2 (2 * (u + i) + 1))]
    have := sum_eq_dot p S hS (fun i => lsNat p 2 (2 * (u + 2 * i) + 1))
    simp only [lsNat_cast] at this
    rw [this]
    exact natCast_eq_zero_of_mod (hodd2 u (by simpa using hu))
  have hcert := certificate_liftTwo _ _ _ _ (laiSprangStream_even p 2) hodd_L
    (certificate_liftTwo _ _ _ _ (laiSprangStream_even p 2) hodd_R hterm)
  rw [certificate_polynomialLittlewoodProduct _ _ _ _ hcert]
  congr 1
  push_cast
  ring

end

#print axioms forall_lt_concat
#print axioms lsNat_cast
#print axioms dotNat_eq_sum
#print axioms sum_eq_dot
#print axioms certificate_of_check
#print axioms sum_liftTwo
#print axioms product_of_checks

end FunctionFieldLittlewood
