# Development instructions

## About snapshot dependencies of our library projects

When you encounter a dependency of a snapshot version under our group prefix `com.huanshankeji` in a consuming project, follow these steps:

- Make sure you have the dependency project locally.
- Run `publishToMavenLocal` in the dependency project to make the consuming project build.
- Prefer `dev` branches over `main` and other branches in the dependency project.
- If the code of one branch causes the consuming project not to build, try switching to other branches in the dependency project, preferably those with newer commits.

Apply this process recursively: if you encounter a snapshot dependency in the dependency project, treat that project as a consuming project and configure its dependencies the same way.
