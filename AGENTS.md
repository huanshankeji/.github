# Agent instructions — this repository

This repo is **huanshankeji/.github**: organization profile, shared docs, composite GitHub Actions, and workflow templates. It is **not** a Gradle/Kotlin application. There is no `./gradlew`, dev server, or database to run here.

The `copilot/` directory is **no longer maintained**. Do not edit files there; use this `AGENTS.md` and `docs/` instead.

## Layout

| Path | Purpose |
| --- | --- |
| `actions/` | Composite actions `setup-javas`, `setup-javas-and-gradle`, `gradle-test-and-check` (deprecated), `gradle-dependency-submission` (deprecated) |
| `.github/workflows/` | Reusable workflows `gradle-ci.yml` and `open-source-convention-gradle-maven-publish.yml` |
| `workflow-templates/` | Starter CI / Dokka workflows for sibling libraries |
| `docs/` | Org docs — see [docs/README.md](docs/README.md) |
| `plugins/` | Cursor Team Marketplace plugin(s), including org agent-instructions always-apply rule |
| `.cursor-plugin/` | Marketplace manifest for importing this repo as a Cursor Team Marketplace |
| `profile/` | GitHub org profile README |
