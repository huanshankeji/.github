# Development instructions

## Publish snapshot dependencies of our library projects to Maven local

When you encounter a dependency of a snapshot version under our group prefix `com.huanshankeji` in a consuming project, follow these steps:

- Make sure you have the dependency project locally.
- Switch to the corresponding branch or check out the corresponding commit in the dependency project. Prefer the `dev` branch over the `main` branch in the dependency project if `dev` is ahead of `main`, unless otherwise instructed.
- Run `publishToMavenLocal` in the dependency project to make the consuming project build.
- If the code of one branch causes the consuming project not to build, try:
   - as already mentioned above, switching to `main` if `dev` doesn't work or exist;
   - checking out the recent commit messages of the consuming project to see if there is related commit or branch information;
   - switching a branch with the same name as this one;
   - switching to other branches in the dependency project, preferably those with newer commits;
   - asking the maintainer which branch of the dependency project the consuming project currently depends on.

Apply this process recursively: if you encounter a snapshot dependency in the dependency project, treat that project as a consuming project and configure its dependencies the same way.
