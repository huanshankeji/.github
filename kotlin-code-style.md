# Our Kotlin code style

1. Try to golf the code, prefer `also`, `apply`, `let`, `run` to `if`-`else` when they shorten the code, and try all of them and use the shortest one.
1. In most cases, don't create a variable if it is only used only once, unless extracting variables greatly improves readability. However, when you seeing existing code using or not using variables used only once, don't try to change it unless you are a maintainer and decides on a better way.
