---
title: Keep history linear — trunk-based branches, rebase, fast-forward merges
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Keep History Linear

## Context and Problem Statement

Merge commits and long-lived branches make history hard to read and bisect,
and large divergence makes integration risky. In an agent-first repository,
history is also a primary input for future agents reconstructing intent.
How are branches created, how long do they live, and how do they land?

## Considered Options

* Trunk-based: short-lived branches off the default branch, rebase, then
  fast-forward merge
* GitHub flow with squash merges
* Merge commits (`--no-ff`)

## Decision Outcome

Chosen option: "Trunk-based with rebase and fast-forward merges".

* Branches are cut from the default branch only — never from another
  feature branch.
* Branches are short-lived. To land: rebase onto the default branch, then
  fast-forward merge (`git merge --ff-only`). No merge commits.
* No squash merges. Instead, commits are curated during the rebase
  (reordered, fixed up, reworded) so each lands as authored.
* Hard rule: every commit that lands on the default branch must be atomic
  and buildable — it builds, passes tests, and makes one coherent change.
  Curating the series during rebase is part of landing, not optional
  polish. This is the minimum bar for an agent-first repository: agents
  produce many commits, and only a curated series keeps `git log` and
  `git bisect` trustworthy.
* No long-lived feature branches: large work lands as a sequence of small
  increments that each keep the default branch releasable (feature flags
  or dark code paths when needed).

### Consequences

* Good, because history is linear: `git log` reads top to bottom and
  `git bisect` is reliable at every commit, not just at merge points.
* Good, because no stacked branches means no cascading rebases.
* Bad, because rebased branches must be force-pushed — safe only while
  branches stay short-lived and single-author, which this ADR mandates.
* Bad, because big features must be decomposed rather than parked on a
  branch.
* Bad, because curation costs effort on every landing; this is accepted
  deliberately as the price of a trustworthy history.

### Confirmation

* `git log --merges` on the default branch stays empty.
* Every commit on the default branch passes the standard lint and test
  entry points; verify a series before landing with
  `git rebase main --exec '<lint && test>'`.
* If hosted on GitHub: enable "require linear history" branch protection,
  and land via CLI `git merge --ff-only` (or a merge queue) — the web
  "Rebase and merge" button rewrites SHAs and drops signatures even when a
  fast-forward is possible.
