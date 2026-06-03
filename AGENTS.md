# Agent instructions — this repository

This repo is **huanshankeji/.github**: organization profile, shared docs, composite GitHub Actions, and workflow templates. It is **not** a Gradle/Kotlin application. There is no `./gradlew`, dev server, or database to run here.

For organization-wide Kotlin library standards and the public repo catalog, see [docs/general-agent-instructions.md](docs/general-agent-instructions.md).

## Local validation (lint / test equivalent)

Contributors validate YAML and metadata before pushing:

```bash
./scripts/validate.sh
```

| Check | Tool |
| --- | --- |
| Workflow templates | [actionlint](https://github.com/rhysd/actionlint) on `workflow-templates/*.yml` |
| Composite actions | Python + PyYAML (actionlint expects workflow shape; do not pass `actions/*/action.yml` directly) |
| YAML style | [yamllint](https://github.com/adrienverge/yamllint) (`relaxed` config inline in script) |
| Template metadata | `json.load` on `workflow-templates/*.properties.json` |
| Doc links | Relative links in `docs/` and `profile/README.md` |

There is no `./gradlew build` or `./gradlew check` in this tree. Consumer Kotlin repos use the templates under `workflow-templates/` and actions under `actions/`.

## Layout

| Path | Purpose |
| --- | --- |
| `actions/` | Composite actions (`setup-javas`, `gradle-test-and-check`, `gradle-dependency-submission`) |
| `workflow-templates/` | Starter CI / Dokka workflows for sibling libraries |
| `docs/` | Kotlin style, dev snapshots, code review, agent baseline |
| `profile/` | GitHub org profile README |

## Cursor Cloud specific instructions

- **No runtime services** are required for this repo (no Postgres, no Gradle daemon for local work).
- **Validation tools:** `actionlint` is installed at `/usr/local/bin/actionlint` (v1.7.7). `yamllint` is installed via `pip3 install --user` (ensure `~/.local/bin` is on `PATH`).
- **“Run the app”** means run `./scripts/validate.sh` — that is the project’s smoke test.
- **Sibling Kotlin libraries** (gradle-common, kotlin-common, etc.) are separate clones; use JDK + `./gradlew check` per their README. Snapshot chaining is documented in [docs/dev-instructions.md](docs/dev-instructions.md).
- **actionlint caveat:** Run it only on `workflow-templates/*.yml`. Composite `actions/*/action.yml` files are validated by the script’s PyYAML structural check instead.
