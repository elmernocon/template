---
title: Assert invariants and fail fast
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Assert Invariants and Fail Fast

## Context and Problem Statement

Code that encodes only the happy path lets impossible states travel: a bug
surfaces far from its cause, or never surfaces — data quietly corrupted, a
fallback silently taken. Agents amplify this; they tend toward defensive
defaults and catch-and-continue blocks that keep a program limping when it
should stop. How do hidden assumptions become visible, and violations loud?

## Considered Options

* Negative space programming: state invariants as executable checks, fail
  fast on violation
* Defensive programming: handle every state, keep running
* Happy path only; rely on tests to catch the rest

## Decision Outcome

Chosen option: "Negative space programming" — define the program by what
must never happen, and make the machine enforce it.

* Invariants are stated as executable checks at the point they are
  assumed: preconditions, postconditions, unreachable branches. Where the
  language can express the constraint in types instead (sum types,
  non-nullable references, parse-don't-validate at boundaries), prefer
  making the invalid state unrepresentable over checking it at runtime.
* A violated invariant is a bug, and bugs fail fast: crash loudly at the
  point of violation. Never silently correct, default, log-and-continue,
  or otherwise handle an impossible state "gracefully" — a crash is
  recoverable, corruption is not.
* Bugs are distinct from expected failures. I/O errors, bad user input,
  and unavailable networks are ordinary control flow, handled as errors.
  The assertion machinery is reserved for states the code declares
  impossible.
* External input is validated at the boundary and parsed into internal
  types that can only hold valid values; past the boundary, code trusts
  its types and asserts its assumptions.
* Assertions stay enabled in production. Disabling a specific check
  requires a measured performance justification, recorded where the check
  is disabled — never a blanket strip.

### Consequences

* Good, because bugs surface at their cause instead of downstream, which
  is the difference between a one-line fix and an investigation.
* Good, because invariants are specification an agent reads at the exact
  point it is editing — and a tripwire that detonates immediately when an
  agent violates an assumption it never read.
* Good, because "handle the impossible state gracefully" is now a
  rejectable defect in review, not a style preference.
* Neutral, because the bug/expected-failure boundary takes judgment at the
  margins; when in doubt, treat it as expected and handle it.
* Bad, because fail-fast makes failures user-visible; the system needs a
  supervision or restart story, and a crash in production is a loud event.
  This is accepted deliberately: better a loud stop than quiet corruption.

### Confirmation

Not fully mechanizable. What can be wired in, is: the test suite runs
with assertions enabled, and release builds do not strip them; where the
ecosystem has lints for swallowed errors or empty catch blocks, they run
as part of the standard lint entry point. The rest is review: any code
that catches an impossible state and continues is a defect.
