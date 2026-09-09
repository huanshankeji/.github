# OSS CI and publishing details

Credential mapping, cache flags, and workflow-template notes for [dev-instructions.md](dev-instructions.md#ci-and-publishing).

## Templates

Prefer the `team-ci.yml` / `team-publish.yml` workflow templates over the older inline `kotlin-jvm-ci.yml` / `kotlin-multiplatform-ci.yml` starters (those still omit GPR env and cache encryption).

## Secrets

Create GitHub Actions secrets using uppercase snake case. Reusable workflows map them to `ORG_GRADLE_PROJECT_*` with camelCase Gradle property suffixes (`gprUser` / `gprKey`). Do not map secrets in consumer workflow YAML (`secrets: inherit` on the `uses:` job).

| Purpose | Secret names | Where |
|---|---|---|
| GitHub Packages | `GPR_USER`, `GPR_KEY` | Organization |
| Maven Central + signing (release publish) | `MAVEN_CENTRAL_USERNAME`, `MAVEN_CENTRAL_PASSWORD`, `SIGNING_IN_MEMORY_KEY`, `SIGNING_IN_MEMORY_KEY_PASSWORD` | Organization |
| Configuration-cache encryption | `GRADLE_ENCRYPTION_KEY` (recommended name) | Organization; pass into reusable workflows / `setup-javas-and-gradle` as `cache-encryption-key` |

`setup-gradle@v6` no longer saves/restores project `.gradle/configuration-cache` across jobs; the encryption key is still useful for Gradle’s own CC encryption when that returns.

## Caching

`gradle/actions` v6 Enhanced Caching is the default (no workflow override). Enable caches in the consumer’s `gradle.properties`, not via CLI flags in CI:

| Property | Role |
|---|---|
| `org.gradle.caching=true` | Build cache; what cross-job reuse relies on today |
| `org.gradle.configuration-cache=true` | Speeds up within a job / local; not persisted by `setup-gradle@v6` |
