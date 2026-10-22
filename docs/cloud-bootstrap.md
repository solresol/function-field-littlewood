# Standalone cloud setup

From this repository's root on Linux x86_64, run:

```sh
python3 scripts/bootstrap_lean.py --run lake build
```

This is also the invocation a scheduled task should use before its existing work.
There is no dependency on a thesis checkout, shared package symlinks, or saved
environment configuration. No schedules are created or changed by this command.
Run setup, build, and subsequent task commands sequentially. A concurrent bootstrap
using the same runtime fails immediately on its lock rather than racing.

The default runtime is this checkout's ignored `.research/lean-runtime`. It contains
elan, toolchains, downloaded cache archives, a lock and `env.sh`. Lake materializes
dependencies under the checkout's ignored `.lake`. To choose another isolated
writable location, place the option before `--run`:

```sh
python3 scripts/bootstrap_lean.py --runtime-dir /workspace/littlewood-runtime --run lake build
```

To run further commands in the same task shell:

```sh
source .research/lean-runtime/env.sh
lake env lean --version
# Continue only the task's already authorized work here.
```

Use the chosen runtime's `env.sh` if `--runtime-dir` was supplied. Do not assume that
exports from an earlier task or an earlier process survive. The generated file
first unsets `ELAN_TOOLCHAIN`, `LEAN_SYSROOT` and `LEAN_PATH`. Its exports are the
absolute `ELAN_HOME`, `MATHLIB_CACHE_DIR` and prefixed `PATH`, plus:

```sh
export LEAN_NUM_THREADS=2
export MATHLIB_CACHE_GET_URL=https://cache.mathlib.org/mathlib4
export MATHLIB_CACHE_BASE_URL=https://cache.mathlib.org
```

The two cache variables cover the legacy and current mathlib cache clients. They
select mathlib's public cache endpoint, avoiding direct legacy Azure requests that
the cloud proxy rejected with `CONNECT tunnel failed, response 403`. Cache keys and
the dependency revisions remain those computed from the checked-in sources.

## Pins and failure behavior

The bootstrap downloads only the official Linux x86_64 [elan 4.2.4 release](https://github.com/leanprover/elan/releases/tag/v4.2.4):

```text
https://github.com/leanprover/elan/releases/download/v4.2.4/elan-x86_64-unknown-linux-gnu.tar.gz
SHA-256: 42b94d4244e8353142c456ec0e4ca6528fd898a6c604d4059f494e706e431f63
```

It checks the archive before executing the single expected regular `elan-init`
member, uses `--no-modify-path --default-toolchain none`, and rejects an existing
elan of another version. `lake --version` installs/selects the repository's
`lean-toolchain`; `lake exe cache get` materializes the existing manifest rather
than running `lake update`. The script fetches the Mathlib import closure using the
same targeted strategy as the Palomar workflow. It checks every dependency HEAD
against the manifest and checks that `lean-toolchain`, `lake-manifest.json` and
`lakefile.toml` remain byte-for-byte unchanged, including on failure.

No installer is downloaded on an existing elan 4.2.4 runtime. Repeated cache calls
reuse downloaded artifacts. An inherited `ELAN_TOOLCHAIN`, `LEAN_SYSROOT` or
`LEAN_PATH` is removed for bootstrap/child commands so it cannot override the pins.
Subprocess output is inherited, failures return nonzero, and the task must stop
instead of treating a partial setup as a verified build.

## Resource limits

Start a cold standalone setup with at least **8 GiB free** on both the checkout and
runtime filesystems. A warm setup requires **2 GiB free**. During every subprocess,
the script checks disk once per second and stops its process group if free space
falls below 2 GiB, aggregate resident memory exceeds 12 GiB, or the command runs
longer than 30 minutes. It sends TERM, waits up to ten seconds, then sends KILL if
needed. There is no automatic deletion of caches or unrelated files. These bounds
target a 16 GiB cloud worker; they are not a claim that all future certificates fit.

Use `df -h .` to inspect reserves. A stopped command is an infrastructure/resource
failure, not a proof of any mathematical claim. Do not raise bounds, change pins,
or delete unrelated caches to force a run through without reassessing resources.

## Tests

```sh
python3 -m unittest discover -s tests -p test_bootstrap_lean.py -v
```

These offline tests cover existing-runtime reuse, download/checksum failures, disk
guards, termination, environment sanitization and unchanged-pin checks. Network,
installation and Lake calls are mocked where appropriate; passing them alone does
not establish a successful cold setup. A separate standalone setup/build is needed
to exercise real downloads, toolchain installation, dependency materialization and
cache extraction. A fresh cloud task additionally checks the saved environment's
startup assumptions; no startup configuration is installed by this script.
