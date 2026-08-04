# Huanshankeji Agent Instructions (Cursor plugin)

Cursor plugin that ships an **always-apply** rule requiring agents to load and follow the `@huanshankeji` organization baseline:

[`docs/general-agent-instructions.md`](../../docs/general-agent-instructions.md)

This addresses agents that skip linked org docs from repo-local `AGENTS.md` files (local IDE, Agents Window, and Cloud).

## Contents

| Path | Purpose |
| --- | --- |
| `rules/org-agent-instructions.mdc` | `alwaysApply: true` mandate to fetch/follow the org baseline |

Approach: short mandatory fetch directive (not an embedded copy of the full doc). Source of truth stays in `docs/general-agent-instructions.md`.
