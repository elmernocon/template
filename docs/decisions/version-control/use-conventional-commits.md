---
title: Use Conventional Commits for commit messages
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Use Conventional Commits for Commit Messages

## Context and Problem Statement

Commit history is a primary record of change intent, read by humans and
agents and machine-processed for changelogs and versioning. Free-form
messages make that record inconsistent and unparseable. What convention
should commit messages follow?

## Considered Options

* Conventional Commits 1.0.0
* Free-form messages
* A custom in-house convention

## Decision Outcome

Chosen option: "Conventional Commits 1.0.0"
(<https://www.conventionalcommits.org/en/v1.0.0/>), because it is a widely
understood standard with existing tooling, and agents can follow it from a
one-line instruction.

* Format: `<type>[optional scope][!]: <description>`, with optional body
  and footers.
* Types: `feat`, `fix`, `build`, `chore`, `ci`, `docs`, `style`,
  `refactor`, `perf`, `test`.
* Breaking changes are marked with `!` after the type/scope and/or a
  `BREAKING CHANGE:` footer.

### Consequences

* Good, because history is scannable and changelogs / semver bumps can be
  derived mechanically.
* Good, because each commit is forced to have a single classifiable
  purpose, which encourages atomic commits.
* Bad, because each commit costs a moment of classification; enforcement
  tooling (commitlint or similar) is a cheap-to-reverse choice, not part of
  this decision.
