# Agent instructions — this repository

This repo is **huanshankeji/.github**: organization profile, shared docs, composite GitHub Actions, and workflow templates. It is **not** a Gradle/Kotlin application. There is no `./gradlew`, dev server, or database to run here.

For organization-wide Kotlin library standards, the public repo catalog, and shared workflows, see [docs/general-agent-instructions.md](docs/general-agent-instructions.md).

The `copilot/` directory is **no longer maintained**. Do not edit files there; use this `AGENTS.md` and `docs/` instead.

## Agent skills

When a task matches a published [Agent Skills](https://agentskills.io) workflow, load and follow that skill instead of improvising steps. Full catalog and installation options are in [docs/general-agent-instructions.md#agent-skills](docs/general-agent-instructions.md#agent-skills).

| Repository | Use for |
| --- | --- |
| [kotlin-skills](https://github.com/huanshankeji/kotlin-skills) | Kotlin, Gradle, and JVM/KMP workflows (for example `gradle-wrapper-update`, `kotlin-debugging-unresolved-reference-file-clash`) |
| [skills](https://github.com/huanshankeji/skills) | General-purpose skills across stacks |

Install with the [skills CLI](https://github.com/vercel-labs/skills):

```bash
npx skills add huanshankeji/kotlin-skills
npx skills add huanshankeji/skills
```

Or copy individual skill folders from a repo’s `skills/` directory into a project-local path (for example `.github/skills/`, `.claude/skills/`, or `.agents/skills/`).

Also see [Kotlin/kotlin-agent-skills](https://github.com/Kotlin/kotlin-agent-skills) for skills maintained by JetBrains.

## Layout

| Path | Purpose |
| --- | --- |
| `actions/` | Composite actions (`setup-javas`, `gradle-test-and-check`, `gradle-dependency-submission`) |
| `workflow-templates/` | Starter CI / Dokka workflows for sibling libraries |
| `docs/` | Kotlin style, dev snapshots, code review, agent baseline |
| `profile/` | GitHub org profile README |

Consumer Kotlin libraries (gradle-common, kotlin-common, etc.) are separate clones. Use JDK and `./gradlew check` per their README. Snapshot chaining is documented in [docs/dev-instructions.md](docs/dev-instructions.md).
