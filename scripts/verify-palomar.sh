#!/usr/bin/env bash
set -euo pipefail

# Follow the toolchain-bundled verification route documented by PalomarTemplate.
# The protected runtime configuration is temporary and is never submitted.
cd "$(dirname "$0")/.."
if [ "$(uname -s)" != Linux ]; then
  echo "Palomar's sandboxed Comparator check requires Linux and bubblewrap." >&2
  exit 1
fi
command -v bwrap >/dev/null
prefix=$(lean --print-prefix)
for tool in lake leanexport leanchecker nanoda_bin con-ron; do
  test -x "$prefix/bin/$tool" || {
    echo "Pinned toolchain does not provide $tool" >&2
    exit 1
  }
done
config=$(mktemp)
trap 'rm -f "$config"' EXIT
python3 - "$prefix" "$config" <<'PY'
import json
from pathlib import Path
import sys

prefix, destination = sys.argv[1:]
config = json.loads(Path('comparator.json').read_text())
if 'external_kernels' in config:
    raise SystemExit('external_kernels is not a permitted submission field')
config.pop('enable_nanoda', None)
config['external_kernels'] = {
    'nanoda': [f'{prefix}/bin/nanoda_bin'],
    'con-ron': [f'{prefix}/bin/con-ron'],
}
Path(destination).write_text(json.dumps(config, indent=2) + '\n')
PY
lake comparator --config "$config"
