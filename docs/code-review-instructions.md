# Code review instructions

Instructions to follow during code review.

- Don't suggest removing code commented out in the latest changes or the pull request.

  Code is commented out for a reason. Don't suggest removing code that is newly commented out in the latest changes or the pull request. Only suggest if it's confirmed stale code.

- Flag possibly unnecessary changes left from debugging or testing (especially in PRs), unless they are clearly marked with a TODO to revert / restore. See [Avoid unnecessary changes](general-agent-instructions.md#avoid-unnecessary-changes).

- When a change moves or splits a module, or rewrites a build script, review [match-existing-code.md](match-existing-code.md). That checklist is the review; a passing build does not replace it.

- Flag edits to `AGENTS.md`, org instruction docs, or skill files that arrive inside an implementation change. Those files change in a task whose subject is the instructions.
