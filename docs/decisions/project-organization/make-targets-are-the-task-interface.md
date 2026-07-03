---
title: Make targets are the canonical task interface
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Make Targets Are the Canonical Task Interface

## Context and Problem Statement

Agents and humans need one stable way to format, lint, and test any project
instantiated from this template, without knowing its language or toolchain.
The rule that every landed commit must build and pass tests is only
checkable if that interface exists everywhere. What is the canonical entry
point for project tasks?

## Considered Options

* Make targets (`make format`, `make lint`, `make test`)
* Language-native runners (npm scripts, cargo, tox, ...)
* A dedicated task runner (`just`, `task`, ...)
* Commands documented in the README

## Decision Outcome

Chosen option: "Make targets", because `make` is ubiquitous, preinstalled or
trivially available on macOS and Linux, and language-agnostic — the same
three commands work in every instantiated project regardless of stack.

* Every project exposes at least `make format`, `make lint`, and
  `make test`. The template ships them as stubs; instantiation wires them
  to the chosen toolchain.
* The targets are the contract; the tools behind them are cheap-to-reverse
  consequences and may change freely without changing the interface.
* CI runs the same targets, so "passes locally" and "passes in CI" cannot
  diverge.
* New project-wide tasks are added as Make targets first, not as
  tool-specific incantations documented elsewhere.

### Consequences

* Good, because any agent can verify any commit with `make lint test`
  without knowing the stack — the buildable-commit rule relies on this.
* Good, because swapping a linter or test runner touches only the Makefile.
* Neutral, because Make serves here as a task dispatcher, not a build
  system; recipes should stay thin wrappers around the real tools.
* Bad, because Make has sharp edges (tab-sensitive syntax, `.PHONY`
  bookkeeping) and is not preinstalled on Windows.

## More Information

A derived project that prefers a different task runner should supersede
this ADR with its choice rather than delete it: other ADRs' confirmation
steps invoke `make lint` and `make test`, so replace the interface and
amend them (or keep the target names as thin aliases). Only the tool is
negotiable, not the existence of the interface.
