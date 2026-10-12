# Daily research automation

The **Function-field Littlewood research** automation runs on **raksasa** in
`/home/gregb/devel/function-field-littlewood`. Its nominal schedule is every day
at **08:20 Australia/Sydney**; the scheduler may offset the actual start slightly.
It uses `gpt-6-astra` with high reasoning effort and works in the local checkout.

The saved prompt retains the research priorities, stopping points, validation
requirements and weekly pattern from udara: computation on Monday, Wednesday
and Friday; Lean formalisation on Tuesday, Thursday and Saturday; integration
on Sunday. Each run must preserve unrelated work and commit and push verified
increments when safe.

The live configuration and research memory are outside Git:

- Configuration: `/home/gregb/.codex/automations/function-field-littlewood-research/automation.toml`
- Memory: `/home/gregb/.codex/automations/function-field-littlewood-research/memory.md`

Keep raksasa powered on with the desktop app running for local scheduled work,
as described in the [scheduled task documentation](https://learn.chatgpt.com/docs/automations?surface=app).

## Migration on 12 October 2026

The checkout was fast-forwarded from `aca9047` to
`0d954683a8a5c26173d872fcb8eab1b63ea101cb`, matching clean udara/main and
origin/main. The latest ignored research scratch files were copied as well.
All 75,819 bytes of the existing automation memory were copied unchanged before
appending a host handoff note. Its original SHA256 was
`39ab62469b357141eed18aa5e8c908e00e5da65a5030dca84516cf5707a467e5`.

The local automation was activated with the original prompt, schedule, model,
reasoning effort and notification settings. Only the working-directory path
and project binding changed. The udara copy was then paused in both its saved
configuration and scheduler database, with both next-run timestamps cleared.
Its historical runs and original memory remain available there.

Pre-migration backups are under
`~/.codex/backups/function-field-littlewood-migration-2026-10-12/` on both hosts.
The first local scheduled run is nominally 13 October 2026 at 08:20 AEDT.

Local validation passed after installing the pinned Linux Lean toolchain and
fetching the pinned dependency cache:

- `python3 -m unittest discover -s tests`: all 50 tests passed.
- `lake build`: completed successfully with Lean `v4.35.0-rc2` and mathlib
  `065356127b1dc0016f66b7283ce0ce2c4055aa55`. The existing isolated Challenge
  statement placeholder remains; no proof source or dependency pin changed.
