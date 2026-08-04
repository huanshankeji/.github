# Huanshankeji Agent Instructions (Cursor plugin)

Cursor plugin that ships an **always-apply** rule requiring agents to load and follow the `@huanshankeji` organization baseline:

[`docs/general-agent-instructions.md`](../../docs/general-agent-instructions.md)

This addresses agents that skip linked org docs from repo-local `AGENTS.md` files (local IDE, Agents Window, and Cloud).

## Contents

| Path | Purpose |
| --- | --- |
| `rules/org-agent-instructions.mdc` | `alwaysApply: true` mandate to fetch/follow the org baseline |

Approach: short mandatory fetch directive (not an embedded copy of the full doc). Source of truth stays in `docs/general-agent-instructions.md`.

## Install — Team Marketplace (Teams / Enterprise; local + Cloud)

Admins (Cursor **Teams** / **Enterprise** only — not Pro / Pro+):

1. Open **Dashboard → Plugins → Team Marketplaces** (or Desktop **Settings → Plugins** import, if available on your plan).
2. Import this GitHub repository root: `https://github.com/huanshankeji/.github` (must be a branch that already contains `.cursor-plugin/marketplace.json`, normally `main` after merge).
3. Confirm Cursor parses marketplace name `huanshankeji-plugins` and lists **Huanshankeji Agent Instructions**.
4. Set the plugin to **Required** so local members and **Cloud agents** receive the always-apply rule.
5. Optionally enable marketplace auto-refresh so pushes update the plugin.

**Do not** expect paste-install to work against `main` before this plugin is merged: Cursor reads the default branch. The repo name `.github` is not a valid marketplace id if Cursor falls back to it — the manifest `name` must be kebab-case (`huanshankeji-plugins`).

## Install — local test (any plan, including Pro+; works before merge)

Official local path: put the **plugin directory** (not the whole `.github` repo) at `~/.cursor/plugins/local/<name>/` with `.cursor-plugin/plugin.json` at that root.

Plugin folder on the PR branch:

https://github.com/huanshankeji/.github/tree/cursor/org-agent-instructions-plugin-be52/plugins/huanshankeji-agent-instructions

```bash
git clone -b cursor/org-agent-instructions-plugin-be52 \
  https://github.com/huanshankeji/.github.git huanshankeji-github
mkdir -p ~/.cursor/plugins/local
ln -sfn "$(pwd)/huanshankeji-github/plugins/huanshankeji-agent-instructions" \
  ~/.cursor/plugins/local/huanshankeji-agent-instructions
```

Then **Developer: Reload Window**. Confirm **Settings → Rules** shows the org agent-instructions rule as **Always Apply**.

Team Marketplace **Required** remains the path for Cloud agent enforcement.

## Verify

After install, start a new agent session and check that the always-apply rule appears in context. Ask the agent to summarize the org required-reading table from `general-agent-instructions.md` — it should load the document rather than guess.
