---
title: Structure code as a directed acyclic graph
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Structure Code as a Directed Acyclic Graph

## Context and Problem Statement

As code is added, modules accumulate dependencies on one another. Without a
rule, cycles appear: two modules import each other, changes ripple
unpredictably, and no unit can be tested or extracted in isolation. What
shape must the dependency graph of this codebase keep?

## Considered Options

* Enforce a directed acyclic graph (DAG) of dependencies
* Fixed named layers (layered architecture)
* No constraint

## Decision Outcome

Chosen option: "Enforce a DAG", because it gives the essential property —
no cycles — without prescribing a rigid layer taxonomy up front; layering
can still emerge naturally within a DAG.

* Dependencies between modules/packages must form a directed acyclic graph:
  no import cycles, direct or transitive, at any level of granularity
  (package, module, file).
* When two modules need each other, extract the shared part into a new
  module both depend on. Dependencies point "down"; shared code sinks.
* The constraint is mechanically enforced, not aspirational: a
  dependency-analysis check runs as part of the standard lint entry point
  and fails on any cycle. Enforcement is part of this decision; the
  specific tool is not.

### Consequences

* Good, because any module can be understood, tested, or extracted knowing
  only its (acyclic) dependencies.
* Good, because change impact flows in one direction — toward dependents,
  never around a loop.
* Neutral, because shared code tends to sink into small leaf modules over
  time.
* Bad, because the "obvious" place for new code is sometimes forbidden (it
  would create a cycle) and an extraction or inversion is required instead.

### Confirmation

A dependency-analysis / import-cycle checker for the instantiated project's
language runs as part of the standard lint entry point and fails the
build on any cycle, so the DAG cannot silently regress. Which tool
provides the check is a cheap-to-reverse choice, not part of this
decision.
