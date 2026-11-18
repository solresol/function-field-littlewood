module

public import FunctionFieldLittlewood.OddDilation
public import FunctionFieldLittlewood.LaiSprangStream

@[expose] public section

open FunctionFieldLittlewood FunctionFieldLittlewood.OddDilation

#check @stream_mul
#print axioms stream_mul
#check @stream_small
#print axioms stream_small
#check @stream_unit_period
#print axioms stream_unit_period
#check @stream_pow
#print axioms stream_pow
#check @row_off_lattice
#print axioms row_off_lattice
#check @row_on_lattice
#print axioms row_on_lattice
#check @stream_window
#print axioms stream_window
#check @base_zero
#print axioms base_zero
#check @base_hit
#print axioms base_hit
#check @binomial_row
#print axioms binomial_row
#check @certificate
#print axioms certificate
#check @first
#print axioms first
#check @binomial_polynomial
#print axioms binomial_polynomial
#check @product
#print axioms product
#check @unbounded_defect
#print axioms unbounded_defect
#check @arbitrarily_large_certificates
#print axioms arbitrarily_large_certificates
#check @arbitrarily_small_products
#print axioms arbitrarily_small_products
#check @power_certificate
#print axioms power_certificate

namespace FunctionFieldLittlewood.OddDilationAudit

-- The whole ternary r=1 family, with no finite scale enumeration.
theorem ternary_all_scales (a : ℕ) :
    ExactCertificate (stream 3 3) (binomial (3 * 3 ^ a)) (3 ^ a) (6 * 3 ^ a) := by
  simpa using power_certificate 3 0 a (by decide)

-- The first supported point is included and the next absent endpoint excluded.
theorem seed_endpoints : stream 3 3 1 = 0 ∧ stream 3 3 4 = 1 ∧
    stream 3 3 7 = 1 ∧ stream 3 3 10 = 0 := by
  norm_num [stream]

-- One row either side of the exact hit prevents an endpoint convention error.
theorem terminal_controls :
    fractionalCoeff (stream 3 3) (binomial 3) 1 5 = 0 ∧
    fractionalCoeff (stream 3 3) (binomial 3) 1 6 = 1 ∧
    ¬ ExactCertificate (stream 3 3) (binomial 3) 1 5 ∧
    ¬ ExactCertificate (stream 3 3) (binomial 3) 1 7 := by
  have hz : fractionalCoeff (stream 3 3) (binomial 3) 1 5 = 0 := by
    have hf := first 3 3 0 (by decide) (by decide) (by decide)
    exact hf.2.2 5 (by decide) (by decide)
  have hh : fractionalCoeff (stream 3 3) (binomial 3) 1 6 = 1 := by
    rw [binomial_row]
    exact base_hit 3 3 (by decide) (by decide) (by decide)
  refine ⟨hz, hh, ?_, ?_⟩
  · intro h
    exact h.2.2.2.2 hz
  · intro h
    have ho : fractionalCoeff (stream 3 3) (binomial 3) 1 6 = 0 :=
      h.2.2.2.1 ⟨5, by decide⟩
    rw [hh] at ho
    exact one_ne_zero ho

-- The positive-defect premise ell>2 matters; this boundary has j=degree.
theorem binary_boundary : ExactCertificate (stream 2 2) (binomial 2) 1 2 := by
  refine ⟨by decide, ?_, ?_, ?_, ?_⟩
  · norm_num [binomial]
  · norm_num [binomial]
  · intro row
    fin_cases row
    rw [binomial_row]
    norm_num [stream]
  · rw [binomial_row]
    norm_num [stream]

-- Retain the distinct odd-characteristic r=1 comparison; no binary claim is
-- inferred from it. This is the already-proved named-stream certificate.
theorem odd_r1_comparison :
    ExactCertificate (laiSprangStream 3 1) comparisonMultiplier 2 6 :=
  laiSprang3_comparison_certificate

#print axioms ternary_all_scales
#print axioms seed_endpoints
#print axioms terminal_controls
#print axioms binary_boundary
#print axioms odd_r1_comparison

end FunctionFieldLittlewood.OddDilationAudit
