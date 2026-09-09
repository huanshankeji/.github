# Agent instructions — Huanshankeji

Instructions for AI coding agents working on **Kotlin projects** by [Chengdu Huanshan Technology](https://github.com/huanshankeji) (`@huanshankeji`). We focus on [Kotlin Multiplatform](https://kotlinlang.org/docs/multiplatform.html), [Vert.x](https://vertx.io/), functional programming, and type-safety.

---

## Required reading

### Every Kotlin coding task

| Topic | Document |
| --- | --- |
| Kotlin formatting and idioms | [kotlin-code-style.md](kotlin-code-style.md) |
| Engineering principles (FP, types, modularity) | [kotlin-coding-and-software-engineering-guidelines.md](kotlin-coding-and-software-engineering-guidelines.md) |

### Sibling dependencies, new modules, which repo to clone or touch, or multi-repo / cross-repo work

| Topic | Document |
| --- | --- |
| Open-source library map | [project-hierarchy.md](project-hierarchy.md) |

### Snapshot, multi-repo, registry, CI, or publish work

| Topic | Document |
| --- | --- |
| Versioning, registries, `--no-daemon`, local workflow, OSS CI | [dev-instructions.md](dev-instructions.md) |

### Code review tasks only

| Topic | Document |
| --- | --- |
| Code review behavior | [code-review-instructions.md](code-review-instructions.md) |

Apply the [required reading](#required-reading) for the task type. When instructions conflict, **repo-local agent docs and maintainers’ task directions win**; this file provides the shared baseline.

---

## Editing existing files

When changing code, **preserve existing comments and blank lines** unless the user explicitly asks you to remove or reformat them, or the change inherently requires it (for example, deleting the code a comment describes).

- Do not remove comments on your own judgment — even if they look redundant, outdated, or unnecessary.
- Do not remove or collapse blank lines to “clean up” formatting or shrink the diff.
- Do not reformat unrelated parts of a file (whitespace, line breaks, comment style) while making a focused change.

Keep edits minimal: change only what the task requires, and leave surrounding comments and vertical spacing as you found them.

## Avoid unnecessary changes

Try **not** to make unnecessary changes, especially in PRs. Focus the diff on the task; do not leave behind drive-by cleanup, speculative refactors, or temporary scaffolding that is not part of the requested work.

If possibly unnecessary changes were made during debugging or testing:

1. **Revert / restore them afterwards** once they are no longer needed.
2. If such changes are **uncommitted**, revert / restore **before committing**.
3. If such changes were **committed** and are confirmed unnecessary — especially in a PR — **commit again** to revert / restore.
4. If they are needed for further review or debugging and **cannot** be reverted / restored immediately, leave a **TODO** in the code **and** in the PR description to revert / restore.
