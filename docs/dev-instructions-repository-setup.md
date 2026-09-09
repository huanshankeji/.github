# Gradle repository setup (examples)

Copy-paste and classpath details for [dev-instructions.md](dev-instructions.md#resolving-dependencies-from-registries). Prefer the tables there; use this file when adding or editing repository blocks.

Early classpath setup (`pluginManagement` / `buildSrc`) cannot call `gradle-common` repository helpers yet, so each consumer duplicates a simplified block in `gradle/classpath-bootstrap.gradle.kts`:

1. Gradle Plugin Portal (stable plugins)
2. Maven local → GitHub Packages, only for `huanshankeji/gradle-common` `*-dev-commit-*` artifacts including snapshots

For project / library dependency resolution, configure repositories explicitly in `dependencyResolutionManagement` — nothing adds them by default:

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

`huanshankejiGithubPackagesOpenSourceMavenConventionProjectRepositories` wires Maven local (SNAPSHOT + `*-dev-commit-*`), GitHub Packages (`*-dev-commit-*`), and Maven Central (releases) for that sibling. List only siblings whose **library** artifacts you resolve (not **gradle-common** classpath / plugin deps). **gradle-common** plugins resolve via `pluginManagement` / `buildSrc` through `classpath-bootstrap`, not the sibling block above.
