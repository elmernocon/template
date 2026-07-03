---
title: Documentation changes with the code
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Documentation Changes with the Code

## Context and Problem Statement

In-repository documentation that no longer matches the code actively
misleads the next reader — especially an agent, which orients itself by
reading it. Deferred "docs passes" rarely happen, so drift accumulates.
When is documentation updated?

## Considered Options

* Docs are updated in the same change that makes them inaccurate
* Periodic documentation passes
* No prose documentation; code only

## Decision Outcome

Chosen option: "Updated in the same change", because deferred accuracy
work never happens; the anti-drift principle applied elsewhere in this
log to structure and behavior applies equally to explanation.

* When a change makes in-repository documentation inaccurate — a README, a
  module's usage notes, an interface description — that documentation is
  updated in the same change, not in a "docs pass" later.
* Documentation kept next to the code is part of the definition of done
  for any change that affects it.
* The rule assumes docs live in the repo. A project that deliberately
  maintains docs out-of-repo on a separate cadence may reasonably
  supersede this decision.

### Consequences

* Good, because in-repo docs stay trustworthy enough to orient by, for
  humans and agents alike.
* Good, because the cost of accuracy is paid in small increments by the
  person with the most context, not in a large deferred pass by someone
  without it.
* Neutral, because the rule is scoped to docs the change actually makes
  inaccurate — it does not demand new documentation.
* Bad, because every change's definition of done grows a "which docs does
  this touch?" check that reviewers and agents must remember to make.
