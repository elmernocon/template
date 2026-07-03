---
title: Behavioral changes ship with their tests
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Behavioral Changes Ship with Their Tests

## Context and Problem Statement

Requiring every commit to pass the test suite only proves that existing
tests still pass; it says nothing about whether new behavior is covered at
all. Untested behavior can be silently broken by any later change, and
"tests as a follow-up" rarely happens. When must tests accompany a change?

## Considered Options

* Tests for the changed behavior land in the same commit or PR
* Tests as follow-up work
* A global coverage threshold

## Decision Outcome

Chosen option: "Tests land in the same commit or PR", because it ties
verification to the moment the behavior is defined, when intent is
clearest.

* A change that alters what the code does — new behavior, a bug fix, a
  changed output — must include tests for that behavior in the same commit
  or PR, not as a follow-up.
* The test suite is the executable specification of what the system is
  supposed to do, and it runs as part of the standard verification
  command.
* The rule is scoped to behavioral change: pure refactors rely on existing
  tests; documentation- or config-only changes need no new tests.
* The goal is confidence and regression protection, not padding the suite
  with low-value tests.

### Consequences

* Good, because "the code compiles" is upgraded to "the behavior is
  verified" for every change that lands.
* Good, because a fixed bug stays fixed: its test fails if the behavior
  ever regresses.
* Neutral, because "behavioral vs. refactor" takes judgment at the margins;
  when in doubt, write the test.
* Bad, because the rule can tempt low-value tests written only to satisfy
  it; the stated goal above is the guard against that.
