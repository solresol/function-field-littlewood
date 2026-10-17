module

public import SharpnessCertificates.P29
public import SharpnessCertificates.P37
public import SharpnessCertificates.P53
public import SharpnessCertificates.P61

@[expose] public section

/-!
Kernel-checked refutations of the auxiliary N-bound for p=29,37,53,61
(N=4), complementing p=5 (Sharpness.lean) and p=13 (ReverseLift.lean) in the
default library. Each module proves `sharpP_refutes_N_bound`: the actual
polynomial Littlewood product of X^(4M) S(t^4) is 2^-8 < 2^-4.
-/
