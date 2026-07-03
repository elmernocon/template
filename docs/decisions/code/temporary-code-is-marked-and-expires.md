---
title: Temporary code is marked and expires
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Temporary Code Is Marked and Expires

## Context and Problem Statement

Some code is written to be deleted: shims during a migration, workarounds
for an upstream bug, dark-launch scaffolding, hardcoded values pending real
configuration. Left unmarked, "for now" silently becomes forever — nothing
distinguishes deliberate scaffolding from load-bearing code, and nothing
ever forces the question "is this still needed?". Agents make this worse:
they write temporary code readily and have no memory of having done so.
How is temporary code kept temporary?

## Considered Options

* A greppable marker with a mandatory expiration date, enforced by lint
* Plain TODO comments
* Tracker tickets ("remove after #123 closes")
* Nothing — rely on review and memory

## Decision Outcome

Chosen option: "Greppable marker with a mandatory expiration date", because
it is self-contained (no tracker dependency), machine-checkable, and turns
silent rot into a build failure.

* Temporary code is marked at the site with a comment containing
  `TEMP(YYYY-MM-DD): <reason, and what to do at expiry>` — e.g.
  `TEMP(2026-09-30): remove shim once the v2 API is fully rolled out`.
* The marker is one greppable token: `grep -rn "TEMP("` finds every piece
  of temporary code in the repository, and the ISO date makes the list
  sortable.
* Enforcement is part of this decision: a check wired into the standard
  lint entry point fails the build on any marker whose date has passed
  or that lacks a parseable date. The specific tool is not.
* An expired marker forces a deliberate, review-visible choice: delete the
  code, or extend the date in a commit whose message says why.
* Scope: TEMP is only for code that must eventually be removed. Open-ended
  ideas and improvements remain ordinary TODOs and need no date — forcing
  dates onto aspirations would train everyone to invent fake ones.

### Consequences

* Good, because "for now" code carries its own removal deadline, and the
  build — not human memory — enforces it.
* Good, because an agent can be pointed at `grep -rn "TEMP("` and asked to
  sweep: each marker states its own cleanup instructions.
* Neutral, because deadlines will get extended; the mechanism does not
  prevent that, it only makes it a visible decision instead of drift.
* Bad, because date pressure can tempt under-marking — leaving temporary
  code unlabeled entirely; review must watch for unmarked "for now" code.
