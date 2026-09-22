# Match existing code

Use this when a task moves or splits a module, or makes a build script match one that already exists.

The checklist at the end is the finish line.

## Canonical file

The canonical file is the file the result should match.

- The task names it, or
- It is the existing file on the default branch of this repository, or of the repository that already has the pattern.

Copy from the default branch, or from the commit the task names. Leave an open pull request, a feature branch, and an upstream skill sample unused as the source to copy.

Done when you can name the path and the ref.

## Steps

1. Read the canonical file and the file you will change. When splitting or moving, also read the file as it is before the split.

   Done when those texts have been read.

2. Transplant lines. Each line of the original is kept, moved, or removed because the task makes that line obsolete. Keep comments, TODOs, blank lines, and the existing order of blocks (`plugins`, dependencies, `include`).

   Done when every original line is accounted for.

3. Reuse a name, plugin id, catalog entry, or convention that already exists. Add a helper, task, or plugin id only when the canonical file has no way to express that behavior.

   Done when every new declaration is copied from the canonical file or required by the task.

4. Run the repository’s usual check command.

   Done when the check succeeds and steps 2 and 3 still hold.

## While transplanting

- Copy plugin ids, `include` order, and dependency order from the canonical file when it already has an order.
- Keep a short or relative name that already works.
- Put a version or coordinate in the existing version file or catalog.
- Before adding configuration, look for a convention plugin or catalog that already sets it.
- When two modules differ on purpose, copy the module the task names.
- When several repositories must match, change the repository that owns the canonical file first. Point later repositories at that file on its default branch.

## Checklist

- [ ] Canonical path and ref named
- [ ] Every original line kept, moved, or removed because the task makes it obsolete
- [ ] Every new declaration copied from the canonical file or required by the task
- [ ] Check command succeeded after the three items above
