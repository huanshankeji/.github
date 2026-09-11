---
name: huanshankeji-org-agent-instructions
description: >
  Mandatory @huanshankeji org agent baseline — must load
  general-agent-instructions.md before exploring, planning, or editing
  Kotlin work. Complementary to the matching Cursor rule: Cloud Agents
  often miss plugin rules but do load plugin skills. Skip reading and
  enforcing this skill when that Cursor rule is already read and
  enforced. Use on every Kotlin task in @huanshankeji repos (local,
  Agents Window, and Cloud), even when AGENTS.md already links the doc.
---

# @huanshankeji org agent instructions (mandatory)

This skill is **always applied**. It is not optional guidance.

This skill is complementary to the matching Cursor rule. If that rule is already read and enforced in this session, skip the rest of this skill.

When working on **Kotlin projects** by `@huanshankeji`, you **MUST** load and follow the organization agent baseline **before** exploring, planning, or editing — do **not** skip this fetch because a repo `AGENTS.md` only links to it.

## Canonical source (load the full document)

Prefer an **already available** checkout of `huanshankeji/.github`. Confirm with `git remote` and `docs/general-agent-instructions.md`. If the checkout is a clean `main`, `git fetch` / `git pull` when you can; if it is a dirty worktree, read it as-is.

Look in this order:

1. Workspace / sibling clone of `huanshankeji/.github` — only if that clone is on `main` and has the latest changes pulled. If you cannot verify or update it, use the next option.
2. **This plugin’s hosting repo.** This plugin ships from `huanshankeji/.github` (`plugins/huanshankeji-agent-instructions/`). When Cursor loads this plugin’s skill or rule, Cloud Agents check out that **whole repo**, not only the plugin folder. Read `docs/general-agent-instructions.md` from the same checkout (repo root contains both `docs/` and `plugins/`). Do not clone `.github` again if this tree is already present.
3. Raw GitHub: https://raw.githubusercontent.com/huanshankeji/.github/main/docs/general-agent-instructions.md

Use your available tools (`Read`, `WebFetch`, `gh api`, `curl`, etc.). Treat a failed or skipped load as a blocking error for the task until the document is in context.

## After loading

1. Follow that document’s **Required reading** for the task type.
2. Load linked required docs the same way — do not invent org standards from memory.

## Precedence

When instructions conflict: **repo-local agent docs and maintainers’ task directions win**; the org general agent instructions remain the shared must-follow baseline.
