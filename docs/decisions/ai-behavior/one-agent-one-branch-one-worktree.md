---
title: One agent, one branch, one worktree
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# One Agent, One Branch, One Worktree

## Context and Problem Statement

Multiple agents working concurrently in a single checkout corrupt each
other's work: they edit the same working tree, fight over the index and
HEAD, and mix build artifacts. Landing on the default branch is already
serialized (rebase, fast-forward only); what isolates work in progress?

## Considered Options

* Git worktrees — one per concurrent agent/task
* Full clones per agent
* One shared checkout; agents coordinate socially

## Decision Outcome

Chosen option: "Git worktrees", because they give each agent a private
working directory and branch while sharing one object store and one set of
remotes — cheaper than clones, and safe by construction unlike a shared
checkout.

* Each concurrent task runs in its own worktree on its own branch
  (`git worktree add .worktrees/<branch> -b <branch> main`).
  Two agents never share a working directory.
* Git enforces the core invariant: a branch cannot be checked out in two
  worktrees at once. One agent = one branch = one worktree.
* The primary checkout stays on the default branch and is reserved for
  integration and landing, not for feature work while other
  agents are active.
* Worktrees are ephemeral: `git worktree remove` after the branch lands,
  `git worktree prune` for strays. A lingering worktree is a lingering
  branch, and a trunk-based workflow forbids both.
* Worktrees live in `.worktrees/` at the repository root, which is
  gitignored. In-repo placement keeps worktrees reachable for sandboxed
  agents confined to the project directory; a sibling directory outside
  the repo was rejected for that reason.

### Consequences

* Good, because agent parallelism becomes safe by construction: contention
  moves from the working tree to landing time, where rebase and
  fast-forward-only merges serialize it.
* Good, because worktrees share objects — n agents cost one repository,
  not n clones.
* Neutral, because per-worktree state (untracked files, build caches,
  virtualenvs, node_modules) must be recreated in each worktree; sharing a
  mutable cache across worktrees would reintroduce the collision this ADR
  exists to prevent.
* Bad, because tools that walk the repository tree (linters, file
  watchers, search) will see every active worktree as a copy of the code
  unless they exclude `.worktrees/`; wire exclusions into the standard
  task entry points as needed.
* Bad, because worktrees add lifecycle bookkeeping (create, remove, prune)
  that agents must perform reliably.

### Confirmation

* `.worktrees/` is listed in `.gitignore`.
* `git worktree list` shows only the primary checkout once no tasks are
  active; anything else is a stray to remove.
