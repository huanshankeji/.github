# Design: Cursor plugin for `@huanshankeji` org agent instructions

## Problem

Repo-local `AGENTS.md` files often only **link** to [`docs/general-agent-instructions.md`](../../general-agent-instructions.md). Local and Cloud agents frequently skip that fetch and miss the organization must-follow baseline.

## Goal

Ship a Cursor plugin installable via **Team Marketplace** (local IDE / Agent Window) and for **Cloud agents** (mark plugin **Required**), with an **always-apply** rule that forces agents to load and follow the org general agent instructions.

## Chosen approach: B (mandatory fetch directive)

The always-apply rule is a short, hard mandate: before other work on `@huanshankeji` open-source Kotlin libraries, agents **must** load the canonical org doc from this repository (GitHub URL / raw URL / clone path) and follow it. The rule does **not** embed the full baseline text.

### Alternatives considered (not chosen)

| Approach | Summary | Why not now |
| --- | --- | --- |
| **A** | Embed full `general-agent-instructions.md` in the rule | Larger always-on context; needs sync tooling. Prefer if B is still skipped. |
| **C** | Embed baseline **plus** required-reading docs (code style, dev-instructions, engineering guidelines) | Highest fidelity, highest token cost every session. Prefer if A still leaves gaps. |

## Architecture

- Multi-plugin marketplace layout at repo root (Cursor Team Marketplace import of `huanshankeji/.github`).
- One plugin: `huanshankeji-agent-instructions`.
- One rule: `rules/org-agent-instructions.mdc` with `alwaysApply: true`.
- Install docs in the plugin README; brief pointers from root `AGENTS.md` and `docs/general-agent-instructions.md`.

## Rule behavior

1. Always applied in every agent session when the plugin is installed.
2. Instructs the agent that org baseline is mandatory, not optional.
3. Names the canonical source: `https://github.com/huanshankeji/.github/blob/main/docs/general-agent-instructions.md` (and raw equivalent).
4. Requires loading that document (and then its required-reading links as applicable) before Kotlin open-source work.
5. States precedence: repo-local agent docs and maintainer task directions win on conflict; this is the shared baseline.

## Non-goals

- Embedding full doc bodies (A/C).
- Publishing to the public Cursor Marketplace (Team Marketplace / local install is enough).
- Changing Kotlin library repos’ `AGENTS.md` files in this change.

## Success criteria

- Team Marketplace can import this repo and list the plugin.
- With the plugin installed (Required for Cloud), new agent sessions include the always-apply rule.
- The rule text clearly forces fetching/following `general-agent-instructions.md`.
