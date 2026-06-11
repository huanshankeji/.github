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
| Internal stable or dev-commit | Maven local → GitLab project registry |
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
    githubPackages("kotlin-common") // add each GitHub Packages repo you need
    mavenCentralExcludingHuanshankejiNonStable()
    // google() only when the project already relied on Google's Maven repository (e.g. Android KMP)
}
```

Internal repos duplicate prefix-based filtering in their own `settings.gradle.kts` or `gradle/dependency-repositories.gradle.kts` (not in published plugins).

Android KMP projects that already used `google()` may keep an explicit `gradle/dependency-repositories.gradle.kts` applied from `settings.gradle.kts` instead of the settings plugin when the plugin interferes with AGP version inference.

## Local development workflow

1. Publish upstream `gradle-common` plugins to Maven local when working on a dev-commit version: `./gradlew publishToMavenLocal` in `gradle-common`.
2. For **dirty** local changes in a dependency, run `publishToMavenLocal` in that dependency project so consumers pick up the `-dirty-SNAPSHOT` artifact.
3. For **committed** dev-commit versions, consumers resolve from Maven local (if present) then GitHub Packages or GitLab as configured — you do not need `publishToMavenLocal` unless your tree is dirty.
4. Apply dependency rules recursively when configuring transitive Huanshankeji dependencies.

## CI and publishing

- Consumer repos use reusable workflows from `huanshankeji/.github`: `ci.yml` (check + dependency submission) and `gradle-maven-publish.yml` (`./gradlew publish --parallel`).
- GitHub Packages auth in workflows: secrets `GH_ACTOR` and `GH_TOKEN` (mapped to `USERNAME` / `TOKEN` for Gradle). GitLab: `GITLAB_PRIVATE_TOKEN`.
- OSS libraries on `main`: publish dev-commit to GitHub Packages. On `release`: publish stable to Maven Central (automatic release) and GitHub Packages.
- Internal libraries: publish dev-commit and stable to GitLab from GitHub Actions.
- Maven Central signing and credentials apply only on `release` builds.

## Branches

- **`dev`**: active development; dev-commit versions and mixed dependency versions per the table above.
- **`main`**: integration; committed dev-commit project version; no legacy `-SNAPSHOT` dependencies.
- **`release`**: stable versions only; stable dependencies only.
