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

1. When a downstream project needs unpublished upstream changes (classpath / plugin deps such as `gradle-common`, or library deps), run `./gradlew publishToMavenLocal` in each upstream repo so consumers resolve them from Maven local. For **dirty** trees this publishes the `-dirty-SNAPSHOT` artifact; for **committed** `*-dev-commit-*` versions, Maven local is optional if the artifact is already on GitHub Packages, but still useful when iterating before push.
2. Across multiple repos that depend on each other’s `*-dev-commit-*` versions: publish upstreams to Maven local, build and verify the chain locally first, then push and re-verify on CI.
3. For the **final** commits of a multi-repo task, push upstream first and wait for its publish GitHub Actions workflow to finish before pushing downstream, so downstream CI can resolve the new artifacts. When the upstream task has multiple commits, during development (especially for AI agents) skip that upstream-first wait for intermediate / non-final upstream commits — either leave those commits unpushed, or push the related repos together and accept that their CI may fail until you do a final upstream-then-downstream push.
4. Apply dependency rules recursively when configuring transitive Huanshankeji dependencies.
5. To resolve **`*-dev-commit-*`** artifacts from GitHub Packages locally, set `gpr.user` / `gpr.key` in `~/.gradle/gradle.properties` with a PAT that has `read:packages`. Document this in each consumer repo’s `CONTRIBUTING.md` when that repo resolves plugins or libraries from GitHub Packages. Prefer these dotted names locally; camelCase `gprUser` / `gprKey` are mainly for GitHub Actions (`ORG_GRADLE_PROJECT_*`) and should not be set in `~/.gradle/gradle.properties`.

## CI and publishing

- OSS libraries use reusable workflows from `huanshankeji/.github`: `gradle-ci.yml` and `open-source-convention-gradle-maven-publish.yml`. Prefer the `team-ci.yml` / `team-publish.yml` workflow templates over the older inline `kotlin-jvm-ci.yml` / `kotlin-multiplatform-ci.yml` starters (those still omit GPR env and cache encryption).
- Registry credentials: create GitHub Actions secrets using uppercase snake case (GitHub stores secret names in uppercase). Reusable workflows map them to `ORG_GRADLE_PROJECT_*` environment variables with camelCase Gradle property suffixes (`gprUser` / `gprKey`); do not map secrets in consumer workflow YAML (use `secrets: inherit` on the `uses:` job).
  - GitHub Packages (org secrets): `GPR_USER`, `GPR_KEY`
  - Maven Central + signing (org secrets, release publish): `MAVEN_CENTRAL_USERNAME`, `MAVEN_CENTRAL_PASSWORD`, `SIGNING_IN_MEMORY_KEY`, `SIGNING_IN_MEMORY_KEY_PASSWORD`
  - Configuration-cache encryption (org secret, recommended name): `GRADLE_ENCRYPTION_KEY` — pass into reusable workflows / `setup-javas-and-gradle` as `cache-encryption-key`. `setup-gradle@v6` no longer saves/restores project `.gradle/configuration-cache` across jobs (see that action); the key is still useful for Gradle’s own CC encryption when that returns.
- Caching: `gradle/actions` v6 Enhanced Caching is the default (no workflow override). Enable Gradle caches in the consumer’s `gradle.properties` — not via CLI flags in CI:
  - `org.gradle.caching=true` (build cache is what cross-job reuse relies on today)
  - `org.gradle.configuration-cache=true` (speeds up within a job / local; not persisted by `setup-gradle@v6`)
- Publish on all branches (`push: branches: ["**"]`). On `release`: `./gradlew publishAndReleaseToMavenCentral`; otherwise `./gradlew publishAllPublicationsToGitHubPackagesRepository --parallel`.
- Set `jdk-versions` to the project JVM toolchain; if the toolchain is below 17, also include `17-temurin` for Gradle. Pass `runs-on` explicitly (typically `ubuntu-latest` for JVM OSS publish).

## Branches

- **`main`** (and other non-`release` branches): active development; committed `*-dev-commit-*` project versions and mixed dependency versions per the tables above; no legacy `-SNAPSHOT` dependencies on committed work.
- **`release`**: stable versions only; stable dependencies only.
