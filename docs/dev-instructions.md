# Development instructions

## Project versioning

Versions are resolved by the `com.huanshankeji.git-version` Gradle plugin (from `gradle-common`):

| Context | Version format |
|---|---|
| `release` branch | `MAJOR.MINOR.PATCH` (plain release) |
| Committed dev (any other branch) | `MAJOR.MINOR.PATCH-dev-commit-<full-git-hash>` |
| Dirty working tree | `MAJOR.MINOR.PATCH-dev-commit-<full-git-hash>-dirty-SNAPSHOT` |

Set the semantic base in each repo's `projectBaseVersion` (or equivalent). Do not use branch-suffixed `-SNAPSHOT` versions for committed work.

## Dependency rules

| Your project version | Allowed dependency versions |
|---|---|
| Release (`MAJOR.MINOR.PATCH` on `release`) | Stable release only — not dev-commit, not `-SNAPSHOT` |
| Committed dev-commit | Anything **except** legacy `-SNAPSHOT` coordinates |
| Dirty (`*-dirty-SNAPSHOT`) | Anything while iterating locally |

## Resolving dependencies from registries

Repository order matters. **Maven local is always consulted first** for Huanshankeji artifacts.

| Dependency kind | Resolution order |
|---|---|
| Public stable (`com.huanshankeji`, release version) | Maven Central (+ existing public repos; do not add Google where a repo did not already use it) |
| Public dev-commit | Maven local → GitHub Packages |
| Dirty / legacy `-SNAPSHOT` | Maven local only |
| Gradle plugin (stable) | Gradle Plugin Portal |
| Gradle plugin (dev-commit) | Maven local → GitHub Packages |

Public OSS repos use the `public-open-source-dependency-repositories` settings plugin with an explicit DSL block — no repositories are added by default. Example:

```kotlin
plugins {
    id("public-open-source-dependency-repositories") version "…"
}

publicOpenSourceDependencyRepositories {
    huanshankejiMavenLocal()
    githubPackages(/* each GitHub Packages repo you consume at runtime */)
    mavenCentralExcludingHuanshankejiNonStable()
    // google() only when the project already relied on Google's Maven repository (e.g. Android KMP)
}
```

List only sibling repos whose **runtime** artifacts you resolve from GitHub Packages — not every OSS library needs **kotlin-common**. Examples:

| Repository | Typical `githubPackages(...)` |
| --- | --- |
| **kotlin-common** | _(none — Maven Central / maven local for Huanshankeji artifacts)_ |
| **compose-html-material** | _(none — no runtime Huanshankeji siblings)_ |
| **compose-multiplatform-html-unified** | `"compose-html-material"` |
| **exposed-vertx-sql-client** | `"kotlin-common"`, `"exposed-gadt-mapping"` |

**gradle-common** dev-commit plugins are resolved via `pluginManagement` (Maven local → GitHub Packages for `huanshankeji/gradle-common`), not via `githubPackages(...)` in this block.

Android KMP projects that already used `google()` may keep an explicit `gradle/dependency-repositories.gradle.kts` applied from `settings.gradle.kts` instead of the settings plugin when the plugin interferes with AGP version inference.

## Local development workflow

1. Publish upstream `gradle-common` plugins to Maven local when working on a dev-commit version: `./gradlew publishToMavenLocal` in `gradle-common`.
2. For **dirty** local changes in a dependency, run `publishToMavenLocal` in that dependency project so consumers pick up the `-dirty-SNAPSHOT` artifact.
3. For **committed** dev-commit versions, consumers resolve from Maven local (if present) then GitHub Packages as configured — you do not need `publishToMavenLocal` unless your tree is dirty.
4. Apply dependency rules recursively when configuring transitive Huanshankeji dependencies.

## CI and publishing

- OSS libraries use reusable workflows from `huanshankeji/.github`: `gradle-ci.yml` and `gradle-maven-publish.yml`.
- Registry credentials: create GitHub Actions secrets using uppercase snake case (GitHub stores secret names in uppercase). Reusable workflows map them to `ORG_GRADLE_PROJECT_*` environment variables with camelCase Gradle property suffixes; do not map secrets in consumer workflow YAML (use `secrets: inherit` on the `uses:` job).
  - GitHub Packages (org secrets): `GPR_USER`, `GPR_KEY`
  - Maven Central + signing (org secrets, release publish): `MAVEN_CENTRAL_USERNAME`, `MAVEN_CENTRAL_PASSWORD`, `SIGNING_IN_MEMORY_KEY`, `SIGNING_IN_MEMORY_KEY_PASSWORD`
- Publish on all branches (`push: branches: ["**"]`). On `release`: `./gradlew publishToMavenCentral`; otherwise `./gradlew publishAllPublicationsToGitHubPackagesRepository --parallel`.
- Set `jdk-versions` to the project JVM toolchain; if the toolchain is below 17, also include `17-temurin` for Gradle. Pass `runs-on` explicitly (typically `ubuntu-latest` for JVM OSS publish).

## Branches

- **`dev`**: active development; dev-commit versions and mixed dependency versions per the table above.
- **`main`**: integration; committed dev-commit project version; no legacy `-SNAPSHOT` dependencies.
- **`release`**: stable versions only; stable dependencies only.
