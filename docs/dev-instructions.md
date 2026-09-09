# Development instructions

Rules for versioning, registries, local multi-repo work, and OSS CI. Gradle copy-paste: [dev-instructions-repository-setup.md](dev-instructions-repository-setup.md). CI secret/cache detail: [dev-instructions-ci.md](dev-instructions-ci.md). Library map: [project-hierarchy.md](project-hierarchy.md).

## Multiple Gradle projects (`--no-daemon`)

When working across **multiple Gradle projects** in one session (any `@huanshankeji` repos, including internal clones), pass **`--no-daemon`** on every `./gradlew` invocation, and run `./gradlew --stop` first if daemons are already running. Concurrent daemons can exhaust memory (OOM). Other mitigations are fine if they avoid that.

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

**Maven local is always consulted first** for Huanshankeji artifacts. Stable Gradle plugins use the Plugin Portal instead of Maven Central.

| Dependency kind | Resolution order |
|---|---|
| Public stable (`com.huanshankeji`, release version) | Maven Central (+ existing public repos that are necessary, for example Google) |
| Public `*-dev-commit-*` | Maven local → GitHub Packages |
| Dirty / legacy `-SNAPSHOT` | Maven local only |
| Gradle plugin (stable) | Gradle Plugin Portal |
| Gradle plugin (`*-dev-commit-*`) | Maven local → GitHub Packages |

`dependencyResolutionManagement` must list repositories explicitly. Typical sibling GitHub Packages **library** repos (not gradle-common classpath / plugins):

| Repository | Typical sibling GitHub Packages repos |
| --- | --- |
| **kotlin-common** | _(none — only `mavenCentralExcludingHuanshankeji()`)_ |
| **compose-html-material** | _(none — plus `googleWithContentFiltering()`)_ |
| **compose-multiplatform-html-unified** | `"compose-html-material"` (plus `googleWithContentFiltering()`) |
| **exposed-vertx-sql-client** | `"kotlin-common"`, `"exposed-gadt-mapping"` |

DSL and `classpath-bootstrap`: [dev-instructions-repository-setup.md](dev-instructions-repository-setup.md).

## Local development workflow

1. Downstream needs unpublished upstream changes: `./gradlew publishToMavenLocal` in each upstream. Dirty trees publish `-dirty-SNAPSHOT`; committed `*-dev-commit-*` can use GitHub Packages, but Maven local is still useful before push.
2. Multi-repo `*-dev-commit-*`: publish upstreams to Maven local, verify the chain locally, then push and re-verify on CI.
3. **Final** multi-repo commits: push upstream first; wait for its publish workflow before pushing downstream. Intermediate upstream commits need not wait — leave them unpushed, or push together and accept CI failures until a final upstream-then-downstream push.
4. Apply dependency rules recursively for transitive Huanshankeji dependencies.
5. Local GitHub Packages for `*-dev-commit-*`: `gpr.user` / `gpr.key` in `~/.gradle/gradle.properties` (PAT with `read:packages`). Document in the consumer `CONTRIBUTING.md`. Prefer these dotted names locally; camelCase `gprUser` / `gprKey` are for GitHub Actions (`ORG_GRADLE_PROJECT_*`), not `~/.gradle/gradle.properties`.

## CI and publishing

| Topic | Rule |
|---|---|
| Workflows | Reusable `gradle-ci.yml` and `open-source-convention-gradle-maven-publish.yml` from `huanshankeji/.github` |
| Secrets | `secrets: inherit`; names and mapping in [dev-instructions-ci.md](dev-instructions-ci.md) |
| Publish | All branches (`push: branches: ["**"]`). `release`: `./gradlew publishAndReleaseToMavenCentral`. Otherwise `./gradlew publishAllPublicationsToGitHubPackagesRepository --parallel` |
| JDK / runner | `jdk-versions` = project JVM toolchain; if below 17 also include `17-temurin`. Pass `runs-on` (typically `ubuntu-latest` for JVM OSS publish) |

## Branches

| Branch | Versions |
|---|---|
| **`main`** (and other non-`release`) | Committed `*-dev-commit-*`; mixed dependencies per the tables above; no legacy `-SNAPSHOT` on committed work |
| **`release`** | Stable versions and stable dependencies only |
