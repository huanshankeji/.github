# Our Kotlin code style

1. Try to golf the code, prefer `also`, `apply`, `let`, `run` to `if`-`else` when they are idiomatic Kotlin and they shorten the code, and try all of them and use the shortest one.
1. In most cases, don't create a variable if it is used only once, unless extracting variables greatly improves readability. However, when you see existing code using or not using variables used only once, don't try to change it unless you are a maintainer and decide on a better way.
1. For a long comment paragraph that spans multiple lines, use block comments instead of multiple lines of single-line comments.
1. Trailing newline: follow Kotlin's default IntelliJ IDEA convention — omit a trailing newline for a single-class file, include one for files with multiple top-level definitions, and do not add or remove an existing trailing newline when editing a file (to avoid unnecessary git diff churn).
