# Agent instructions — this repository

This repo is **huanshankeji/.github**: organization profile, shared docs, composite GitHub Actions, and workflow templates. It is **not** a Gradle/Kotlin application. There is no `./gradlew`, dev server, or database to run here.

For organization-wide Kotlin library standards, the public repo catalog, shared workflows, and [agent skills](docs/general-agent-instructions.md#agent-skills), see [docs/general-agent-instructions.md](docs/general-agent-instructions.md).

The `copilot/` directory is **no longer maintained**. Do not edit files there; use this `AGENTS.md` and `docs/` instead.

## Layout

| Path | Purpose |
| --- | --- |
| `actions/` | Composite actions `setup-javas`, `setup-javas-and-gradle`, `gradle-test-and-check` (deprecated), `gradle-dependency-submission` (deprecated) |
| `.github/workflows/` | Reusable workflows `gradle-ci.yml` and `open-source-convention-gradle-maven-publish.yml` |
| `workflow-templates/` | Starter CI / Dokka workflows for sibling libraries |
| `docs/` | Kotlin style, dev snapshots, code review, agent baseline |
| `profile/` | GitHub org profile README |

Consumer Kotlin libraries (gradle-common, kotlin-common, etc.) are separate clones. Use JDK and `./gradlew check` per their README. Snapshot chaining is documented in [docs/dev-instructions.md](docs/dev-instructions.md).
