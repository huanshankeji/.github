# Huanshankeji Agent Instructions (Cursor plugin)

Cursor plugin that ships an **always-apply** rule requiring agents to load and follow the `@huanshankeji` organization baseline:

[`docs/general-agent-instructions.md`](../../docs/general-agent-instructions.md)

This addresses agents that skip linked org docs from repo-local `AGENTS.md` files (local IDE, Agents Window, and Cloud).

## Contents

| Path | Purpose |
| --- | --- |
| `rules/org-agent-instructions.mdc` | `alwaysApply: true` mandate to fetch/follow the org baseline |

Approach: short mandatory fetch directive (not an embedded copy of the full doc). Source of truth stays in `docs/general-agent-instructions.md`.

## Install — Team Marketplace (recommended for local + Cloud)

Admins (Cursor Teams / Enterprise):

1. Open **Dashboard → Plugins → Team Marketplaces**.
2. **Import** / **Add Marketplace** from this GitHub repository: `https://github.com/huanshankeji/.github`.
3. Confirm Cursor parses `.cursor-plugin/marketplace.json` and lists **Huanshankeji Agent Instructions**.
4. Set the plugin to **Required** (auto-install; cannot be removed) so local members and **Cloud agents** receive the always-apply rule.
5. Optionally enable marketplace auto-refresh so pushes to this repo update the plugin.

Developers then see the plugin under **Customize → Plugins** (Required plugins install automatically).

## Install — local development

For testing a checkout without Team Marketplace:

1. Symlink or copy `plugins/huanshankeji-agent-instructions` into your Cursor plugins directory (for example `~/.cursor/plugins/local/huanshankeji-agent-instructions`), keeping `.cursor-plugin/plugin.json` and `rules/`.
2. Reload the Cursor window.
3. Confirm **Rules** shows the org agent-instructions rule as **Always Apply**.

Exact local registration paths can vary by Cursor version; Team Marketplace **Required** remains the supported path for Cloud agents.

## Verify

After install, start a new agent session and check that the always-apply rule appears in context. Ask the agent to summarize the org required-reading table from `general-agent-instructions.md` — it should load the document rather than guess.
