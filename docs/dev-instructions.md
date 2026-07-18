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
| Release (`MAJOR.MINOR.PATCH` on `release`) | Stable release only — not `*-dev-commit-*`, not `-SNAPSHOT` |
| Committed `*-dev-commit-*` | Anything **except** legacy `-SNAPSHOT` coordinates |
| Dirty (`*-dirty-SNAPSHOT`) | Anything while iterating locally |

## Resolving dependencies from registries

Repository order matters. **Maven local is always consulted first** for Huanshankeji artifacts.

| Dependency kind | Resolution order |
|---|---|
| Public stable (`com.huanshankeji`, release version) | Maven Central (+ existing public repos that are necessary, for example Google) |
| Public `*-dev-commit-*` | Maven local → GitHub Packages |
| Dirty / legacy `-SNAPSHOT` | Maven local only |
| Gradle plugin (stable) | Gradle Plugin Portal |
| Gradle plugin (`*-dev-commit-*`) | Maven local → GitHub Packages |

Plugins follow the same registry rules as libraries, except the Gradle Plugin Portal replaces Maven Central for stable plugins. Early classpath setup (`pluginManagement` / `buildSrc`) cannot call `gradle-common` repository helpers yet (chicken-and-egg), so each consumer duplicates a simplified block in `gradle/classpath-bootstrap.gradle.kts` with:

1. Gradle Plugin Portal (stable plugins)
2. Maven local → GitHub Packages, only for `huanshankeji/gradle-common` `*-dev-commit-*` artifacts including snapshots

For project / library dependency resolution, configure repositories explicitly in `dependencyResolutionManagement` — nothing adds them by default. Typical pattern:

```kotlin
@file:OptIn(com.huanshankeji.GradleCommonExperimentalApi::class)

import com.huanshankeji.artifacts.mavenRepositoryHandlerContext
import com.huanshankeji.team.artifacts.mavenCentralExcludingHuanshankeji
import com.huanshankeji.team.gitversioning.opensourcemavenconvention.githubpackages.huanshankejiGithubPackagesOpenSourceMavenConventionProjectRepositories

dependencyResolutionManagement {
    repositories {
        mavenCentralExcludingHuanshankeji()
        // googleWithContentFiltering() — only when the project needs Google's Maven repository
        mavenRepositoryHandlerContext(providers, ::uri) {
            // each GitHub Packages sibling whose library artifacts you resolve
            huanshankejiGithubPackagesOpenSourceMavenConventionProjectRepositories("kotlin-common")
        }
    }
}
```

`huanshankejiGithubPackagesOpenSourceMavenConventionProjectRepositories` wires Maven local (SNAPSHOT + `*-dev-commit-*`), GitHub Packages (`*-dev-commit-*`), and Maven Central (releases) for that sibling. List only siblings whose **library** artifacts you resolve (as opposed to **gradle-common** classpath / plugin deps) — not every OSS library needs **kotlin-common**. Examples:

| Repository | Typical sibling GitHub Packages repos |
| --- | --- |
| **kotlin-common** | _(none — only `mavenCentralExcludingHuanshankeji()`)_ |
| **compose-html-material** | _(none — plus `googleWithContentFiltering()`)_ |
| **compose-multiplatform-html-unified** | `"compose-html-material"` (plus `googleWithContentFiltering()`) |
| **exposed-vertx-sql-client** | `"kotlin-common"`, `"exposed-gadt-mapping"` |

**gradle-common** plugins are resolved via `pluginManagement` / `buildSrc` through `classpath-bootstrap`, not via the sibling block above.

## Local development workflow

1. Publish upstream `gradle-common` plugins to Maven local when working on a `*-dev-commit-*` version: `./gradlew publishToMavenLocal` in `gradle-common`.
2. For **dirty** local changes in a dependency, run `publishToMavenLocal` in that dependency project so consumers pick up the `-dirty-SNAPSHOT` artifact.
3. For **committed** `*-dev-commit-*` versions, consumers resolve from Maven local (if present) then GitHub Packages as configured — you do not need `publishToMavenLocal` unless your tree is dirty.
4. Apply dependency rules recursively when configuring transitive Huanshankeji dependencies.
5. To resolve **`*-dev-commit-*`** artifacts from GitHub Packages locally, set `gpr.user` / `gpr.key` in `~/.gradle/gradle.properties` with a PAT that has `read:packages`. Document this in each consumer repo’s `CONTRIBUTING.md` when that repo resolves plugins or libraries from GitHub Packages.

## CI and publishing

- OSS libraries use reusable workflows from `huanshankeji/.github`: `gradle-ci.yml` and `open-source-convention-gradle-maven-publish.yml`.
- Registry credentials: create GitHub Actions secrets using uppercase snake case (GitHub stores secret names in uppercase). Reusable workflows map them to `ORG_GRADLE_PROJECT_*` environment variables with camelCase Gradle property suffixes; do not map secrets in consumer workflow YAML (use `secrets: inherit` on the `uses:` job).
  - GitHub Packages (org secrets): `GPR_USER`, `GPR_KEY`
  - Maven Central + signing (org secrets, release publish): `MAVEN_CENTRAL_USERNAME`, `MAVEN_CENTRAL_PASSWORD`, `SIGNING_IN_MEMORY_KEY`, `SIGNING_IN_MEMORY_KEY_PASSWORD`
  - Configuration-cache encryption for the Actions cache (org secret): `GRADLE_ENCRYPTION_KEY` (passed into `setup-gradle` / `dependency-submission` as `cache-encryption-key`)
- Caching: `gradle/actions` v6 Enhanced Caching is the default (no workflow override). Enable Gradle caches in the consumer’s `gradle.properties` — not via CLI flags in CI:
  - `org.gradle.caching=true`
  - `org.gradle.configuration-cache=true`

- Publish on all branches (`push: branches: ["**"]`). On `release`: `./gradlew publishToMavenCentral`; otherwise `./gradlew publishAllPublicationsToGitHubPackagesRepository --parallel`.
- Set `jdk-versions` to the project JVM toolchain; if the toolchain is below 17, also include `17-temurin` for Gradle. Pass `runs-on` explicitly (typically `ubuntu-latest` for JVM OSS publish).

## Branches

- **`main`** (and other non-`release` branches): active development; committed `*-dev-commit-*` project versions and mixed dependency versions per the tables above; no legacy `-SNAPSHOT` dependencies on committed work.
- **`release`**: stable versions only; stable dependencies only.
