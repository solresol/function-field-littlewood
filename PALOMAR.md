# Palomar comparison package

The comparison advertises `FunctionFieldLittlewood.Palomar.root_moment_package`.
[Challenge.lean](Challenge.lean) states it independently using only Mathlib.
[Solution.lean](Solution.lean) proves the same statement using this repository's
root enumeration, coefficient identities and parity rigidity. The modules are
built separately: the Solution does not import the Challenge.

For an odd prime p, let H=2^r and suppose p-1=2H(2k+1). For s dividing H,
write G=(X^H-1)/(X^s-1) as a finite geometric sum. The theorem constructs all
H roots of X^H+1, identifies the explicit odd coefficient sequence and every
polynomial filter with root moments, and proves the following implication:
if H consecutive moments with weights G(z)(U₀(z)^2-zU₁(z)^2) vanish, then
G(X)(X^H+1) divides both G(X)U₀(X) and G(X)U₁(X).

The proof adapts Lai–Sprang's finite-field root-moment method. It does not
derive the moment hypotheses from a parent coefficient window, iterate the
descent, prove the all-degree N-bound, or construct a characteristic-two
counterexample. Combining the existing steps into an independently stated
theorem is verification progress; no mathematical novelty or firstness is claimed.

## Verification

The project is pinned to Lean `v4.35.0-rc2` and Mathlib commit
`065356127b1dc0016f66b7283ce0ce2c4055aa55`, with a committed manifest. Every
tracked Lean source uses the module system. The deliberate `sorry` in the
Challenge is a statement placeholder. It is excluded from the proved
development's sorry count, and must not occur in the Solution's axiom closure.

Build from the repository root:

```sh
lake exe cache get
lake build
lake env lean verification/CatalogueAudit.lean
```

On Linux with bubblewrap installed, run the actual comparison:

```sh
bash scripts/verify-palomar.sh
```

This invokes the pinned toolchain's sandboxed `lake comparator`, registering
its bundled NanoDa and con-ron checkers in a temporary runtime configuration.
The submitted [comparator.json](comparator.json) contains only permitted fields.
No sandbox-bypass option is used. A manually dispatched GitHub Actions workflow,
[Palomar comparison](.github/workflows/palomar.yml), supplies the Linux environment.
Its run must be checked before reporting independent-kernel verification.

Verified on 7 October 2026 at `15ca311e989d36ead9f7eaa99bc8537a2e41ae78`: the full
Lean build and declaration audits passed, and the [Linux verification run](https://github.com/solresol/function-field-littlewood/actions/runs/37551138645)
matched the statements and obtained acceptance from Lean’s default kernel, NanoDa
and con-ron. The [validation record](results/2026-10-07-palomar-validation.json)
and [comparison log](results/2026-10-07-palomar-comparator.txt) retain the evidence.
These checks apply to the combined package, not independent comparison of every
historical catalogue entry.

## Submission boundary

Preparation and successful local/CI checks do not constitute submission or
registration. The metadata must record the exact verification snapshot and
actual outcome. Palomar performs its own mechanical and editorial checks on
the final public commit; its research-interest requirement is a separate decision.
The current source is substantive development, with source attribution and AI
disclosure in [formalization.yaml](formalization.yaml) and [NOTICE](NOTICE).

The submission uses the repository root, `Challenge`, `Solution`,
`comparator.json` and `formalization.yaml`. See the current
[submission guide](https://palomar-registry.org/how-to-submit) and
[submission policy](https://github.com/PalomarRegistry/PalomarPolicy/blob/main/CONTRIBUTING.md).
The older Zenodo v0.1.0 archive remains frozen and excludes this package.
