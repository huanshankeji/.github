#!/usr/bin/env bash
# Smoke test for huanshankeji/.github — validates Actions metadata and workflow templates.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export PATH="${HOME}/.local/bin:${PATH}"

echo "==> YAML (yamllint, relaxed)"
yamllint -d relaxed actions/ workflow-templates/

echo "==> Workflow templates (actionlint)"
actionlint workflow-templates/*.yml

echo "==> Composite actions (structure)"
python3 << 'PY'
import pathlib, sys, yaml

required = {"name", "runs"}
for path in sorted(pathlib.Path("actions").glob("*/action.yml")):
    data = yaml.safe_load(path.read_text())
    missing = required - set(data)
    if missing:
        print(f"FAIL {path}: missing {missing}", file=sys.stderr)
        sys.exit(1)
    if data.get("runs", {}).get("using") != "composite":
        print(f"FAIL {path}: expected composite action", file=sys.stderr)
        sys.exit(1)
    print(f"OK {path}")
PY

echo "==> Workflow template metadata (JSON)"
python3 << 'PY'
import json, glob
for p in sorted(glob.glob("workflow-templates/*.properties.json")):
    with open(p) as f:
        json.load(f)
    print(f"OK {p}")
PY

echo "==> Markdown relative links"
python3 << 'PY'
import pathlib, re, sys

root = pathlib.Path(".")
md_files = list((root / "docs").glob("*.md")) + [root / "profile/README.md"]
link_re = re.compile(r"\]\(([^)]+)\)")
broken = []
for md in md_files:
    text = md.read_text()
    for m in link_re.finditer(text):
        target = m.group(1).split("#")[0].strip()
        if not target or target.startswith("http"):
            continue
        if not (md.parent / target).resolve().exists():
            broken.append((md, target))
if broken:
    for md, target in broken:
        print(f"BROKEN {md}: {target}", file=sys.stderr)
    sys.exit(1)
print(f"OK {len(md_files)} markdown files")
PY

echo ""
echo "All checks passed."
