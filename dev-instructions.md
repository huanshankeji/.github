# Development instructions

When you encounter a dependency of a snapshot version under our group prefix `com.huanshankeji` in a consuming project, you should make sure you have the dependency project locally and run `publishToMavenLocal` in it first to make the consuming project build. Prefer `dev` branches over `main` and other branches in the dependency project. An if the code of one branch causes the consuming project not to build, try switching to other branches in the dependency project, preferably those with newer commits.

Do this recursively, which is to say, if you encounter a snapshot dependency in the dependency project, treat the dependency project as another consuming project and configure its dependency projects in this way too.
