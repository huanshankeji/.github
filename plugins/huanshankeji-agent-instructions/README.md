# Huanshankeji Agent Instructions (Cursor plugin)

Cursor plugin that ships an **always-apply** rule **and** a matching model-invoked skill requiring agents to load and follow the `@huanshankeji` organization baseline:

[`docs/general-agent-instructions.md`](../../docs/general-agent-instructions.md)

This addresses agents that skip linked org docs from repo-local `AGENTS.md` files (local IDE, Agents Window, and Cloud). The skill is complementary to the rule: Cloud Agents often miss plugin rules but do load plugin skills. Skip the skill when the matching rule is already read and enforced.

Keep the rule and skill instruction bodies in sync (skill-only: complementary skip).

## Contents

| Path | Purpose |
| --- | --- |
| `rules/org-agent-instructions.mdc` | `alwaysApply: true` mandate to fetch/follow the org baseline |
| `skills/huanshankeji-org-agent-instructions/SKILL.md` | Same mandate as a model-invoked skill (Cloud and other surfaces that honor plugin skills more reliably than rules) |

Approach: short mandatory fetch directive (not an embedded copy of the full doc). Source of truth stays in `docs/general-agent-instructions.md`.
