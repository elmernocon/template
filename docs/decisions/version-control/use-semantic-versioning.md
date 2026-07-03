---
title: Version releases with Semantic Versioning
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Version Releases with Semantic Versioning

## Context and Problem Statement

Instantiated projects need a versioning scheme whose numbers carry meaning
for consumers and can be produced mechanically by agents. Commit history
here is already structured so that the nature of each change is
machine-readable. How are versions assigned?

## Considered Options

* Semantic Versioning 2.0.0
* Calendar versioning (CalVer)
* Ad-hoc version numbers

## Decision Outcome

Chosen option: "Semantic Versioning 2.0.0" (<https://semver.org>), because
it is the scheme Conventional Commits is designed to feed: the required
bump derives mechanically from history.

* Versions are `MAJOR.MINOR.PATCH`: `fix:` → PATCH, `feat:` → MINOR, any
  `!` / `BREAKING CHANGE:` → MAJOR.
* Releases are annotated git tags `vX.Y.Z` on the default branch.
* Pre-1.0 (`0.y.z`) means the public API is not yet stable; breaking
  changes bump MINOR. Reaching `1.0.0` is a deliberate stability promise,
  not an accumulation.
* Release automation (semantic-release, release-please, ...) is a
  cheap-to-reverse tooling choice, not part of this decision.

### Consequences

* Good, because a consumer can read risk from a version bump, and an agent
  can compute the bump from `git log` alone.
* Good, because tags on a linear history make every release reproducible
  from a single commit.
* Neutral, because applications without a public API still benefit from
  tagged releases, but "breaking" becomes a judgment call about observable
  behavior.
* Bad, because MAJOR bumps depend on honestly marking changes as breaking;
  this decision leans entirely on commit-message discipline.
