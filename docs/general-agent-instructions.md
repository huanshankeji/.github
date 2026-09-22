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

### Move, split, or match an existing module

| Topic | Document |
| --- | --- |
| Move or split a module, or match a build script to an existing one | [match-existing-code.md](match-existing-code.md) |

### Code review tasks only

| Topic | Document |
| --- | --- |
| Code review behavior | [code-review-instructions.md](code-review-instructions.md) |

Apply the [required reading](#required-reading) for the task type. When instructions conflict, **repo-local agent docs and maintainers’ task directions win** over this file, and this file wins over an upstream skill or template sample.

---

## Editing existing files

When changing a file — Kotlin source, Gradle Kotlin DSL (`*.gradle.kts`), settings scripts, manifests, and config — **preserve existing comments, TODOs, commented-out code, and blank lines** unless the user explicitly asks you to remove or reformat them, or the change inherently requires it (for example, deleting the code a comment describes).

- Do not remove comments, TODOs, or commented-out code on your own judgment — even if they look redundant, outdated, or unnecessary.
- Do not remove or collapse blank lines to “clean up” formatting or shrink the diff.
- Do not reformat unrelated parts of a file (whitespace, line breaks, comment style) while making a focused change.

Keep edits minimal: change only what the task requires, and leave surrounding comments and vertical spacing as you found them.

Change `AGENTS.md`, this `docs/` tree, and skill files only in a task whose subject is those instructions.

When the task moves or splits a module, or matches a build script to an existing one, read [match-existing-code.md](match-existing-code.md) and finish its checklist before treating the task as done.

## Avoid unnecessary changes

Try **not** to make unnecessary changes, especially in PRs. Focus the diff on the task; do not leave behind drive-by cleanup, speculative refactors, or temporary scaffolding that is not part of the requested work.

If possibly unnecessary changes were made during debugging or testing:

1. **Revert / restore them afterwards** once they are no longer needed.
2. If such changes are **uncommitted**, revert / restore **before committing**.
3. If such changes were **committed** and are confirmed unnecessary — especially in a PR — **commit again** to revert / restore.
4. If they are needed for further review or debugging and **cannot** be reverted / restored immediately, leave a **TODO** in the code **and** in the PR description to revert / restore.
