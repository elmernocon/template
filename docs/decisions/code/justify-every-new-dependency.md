---
title: Justify every new third-party dependency
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Justify Every New Third-Party Dependency

## Context and Problem Statement

Dependencies are among the most expensive choices to reverse: they ossify
into APIs, lockfiles, and transitive trees, and each one adds maintenance
and supply-chain exposure. Agents in particular add dependencies eagerly,
because installing a package is locally cheaper than writing code. When may
a third-party dependency be added?

## Considered Options

* Standard library first; every new dependency must be justified
* Unrestricted — add whatever solves the immediate problem
* Allowlist — only pre-approved dependencies

## Decision Outcome

Chosen option: "Standard library first; every new dependency must be
justified", because it keeps the tree small without the upkeep burden an
allowlist would impose on a template.

* Prefer, in order: the standard library, dependencies already in the
  tree, then a new dependency over writing it yourself — except when the
  needed code is small (write it) or the domain is deceptively hard
  (crypto, time zones, parsing untrusted input: use the library).
* Adding a dependency requires justification in the commit body: what it
  is for and why the alternatives above lose. Weigh maintenance health,
  transitive weight, and license.
* Structurally significant dependencies — frameworks, ORMs, anything that
  shapes the architecture around itself — are decisions in their own right
  and get an ADR.

### Consequences

* Good, because the dependency tree stays small, auditable, and easier to
  upgrade.
* Good, because agents get an explicit rule at exactly the moment they
  would otherwise silently install something.
* Bad, because each addition costs a moment of justification, even for
  obviously reasonable ones.
* Bad, because "write it yourself" misapplied produces homegrown crypto
  and date math; the deceptively-hard-domain exception exists for this.
