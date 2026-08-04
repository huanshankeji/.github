# Cursor org agent-instructions plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a Team Marketplace–ready Cursor plugin with an always-apply rule that forces agents to load `@huanshankeji` org general agent instructions (approach B).

**Architecture:** Root `.cursor-plugin/marketplace.json` lists one plugin under `plugins/huanshankeji-agent-instructions/` with `rules/org-agent-instructions.mdc` (`alwaysApply: true`). Docs point maintainers at Team Marketplace Required install for local + Cloud.

**Tech Stack:** Cursor plugin manifests (JSON), Cursor rules (`.mdc` frontmatter), Markdown docs in this `.github` repo.

---

### Task 1: Marketplace + plugin manifests

**Files:**
- Create: `.cursor-plugin/marketplace.json`
- Create: `plugins/huanshankeji-agent-instructions/.cursor-plugin/plugin.json`
- Create: `plugins/huanshankeji-agent-instructions/README.md`

- [ ] **Step 1: Create marketplace manifest**

```json
{
  "name": "huanshankeji-plugins",
  "displayName": "Huanshankeji Plugins",
  "owner": {
    "name": "Chengdu Huanshan Technology",
    "email": "chengduhuanshankeji@hotmail.com"
  },
  "metadata": {
    "description": "Cursor plugins for the @huanshankeji open-source organization",
    "version": "0.1.0"
  },
  "plugins": [
    {
      "name": "huanshankeji-agent-instructions",
      "source": "./plugins/huanshankeji-agent-instructions",
      "description": "Always-apply rule that forces loading @huanshankeji org agent instructions"
    }
  ]
}
```

- [ ] **Step 2: Create plugin manifest**

```json
{
  "name": "huanshankeji-agent-instructions",
  "displayName": "Huanshankeji Agent Instructions",
  "version": "0.1.0",
  "description": "Enforced always-apply rule that requires agents to load and follow @huanshankeji org agent instructions.",
  "author": {
    "name": "Chengdu Huanshan Technology"
  },
  "homepage": "https://github.com/huanshankeji/.github",
  "repository": "https://github.com/huanshankeji/.github",
  "keywords": [
    "huanshankeji",
    "agent-instructions",
    "kotlin",
    "rules"
  ],
  "rules": "./rules/"
}
```

- [ ] **Step 3: Write plugin README with local + Team Marketplace / Cloud install steps**

Document: import this repo as Team Marketplace; mark plugin Required for Cloud + team; optional local path install for development.

- [ ] **Step 4: Commit**

```bash
git add .cursor-plugin/marketplace.json plugins/huanshankeji-agent-instructions/.cursor-plugin/plugin.json plugins/huanshankeji-agent-instructions/README.md
git commit -m "Add Cursor marketplace plugin manifests for org agent instructions"
```

### Task 2: Always-apply rule (approach B)

**Files:**
- Create: `plugins/huanshankeji-agent-instructions/rules/org-agent-instructions.mdc`

- [ ] **Step 1: Create the rule**

Frontmatter: `alwaysApply: true` (and a short `description`). Body must:

1. State that the org baseline is mandatory for `@huanshankeji` public Kotlin library work.
2. Require loading `docs/general-agent-instructions.md` from this repo via GitHub blob/raw URL or local clone before other work.
3. Require following that doc’s required-reading and skills sections as applicable.
4. Preserve precedence: repo-local agent docs and maintainer directions win on conflict.

Canonical URLs:

- `https://github.com/huanshankeji/.github/blob/main/docs/general-agent-instructions.md`
- `https://raw.githubusercontent.com/huanshankeji/.github/main/docs/general-agent-instructions.md`

- [ ] **Step 2: Commit**

```bash
git add plugins/huanshankeji-agent-instructions/rules/org-agent-instructions.mdc
git commit -m "Add always-apply rule mandating org agent instructions fetch"
```

### Task 3: Point org docs at the plugin

**Files:**
- Modify: `AGENTS.md`
- Modify: `docs/general-agent-instructions.md`

- [ ] **Step 1: Add a short Cursor plugin section** to both files linking to `plugins/huanshankeji-agent-instructions/README.md`.

- [ ] **Step 2: Commit**

```bash
git add AGENTS.md docs/general-agent-instructions.md
git commit -m "Document Cursor org agent-instructions plugin install"
```

### Task 4: Design/plan docs + verify layout

**Files:**
- Create: `docs/superpowers/specs/2026-08-04-cursor-org-agent-instructions-plugin-design.md`
- Create: `docs/superpowers/plans/2026-08-04-cursor-org-agent-instructions-plugin.md`

- [ ] **Step 1: Ensure design and plan are committed**

- [ ] **Step 2: Validate JSON parses and rule frontmatter has `alwaysApply: true`**

```bash
node -e "JSON.parse(require('fs').readFileSync('.cursor-plugin/marketplace.json','utf8')); JSON.parse(require('fs').readFileSync('plugins/huanshankeji-agent-instructions/.cursor-plugin/plugin.json','utf8')); console.log('ok')"
grep -n 'alwaysApply: true' plugins/huanshankeji-agent-instructions/rules/org-agent-instructions.mdc
```

Expected: `ok` and a matching line in the rule file.

- [ ] **Step 3: Push, open PR, post standalone comment about A/C fallbacks**
