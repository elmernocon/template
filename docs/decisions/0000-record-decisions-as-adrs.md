---
title: Record significant decisions as ADRs
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Record Significant Decisions as ADRs

## Context and Problem Statement

This repository is worked on by coding agents over time. Undocumented
decisions drift: a later change silently contradicts an earlier one because
the reasoning was never written down. How do we keep a durable, append-only
record of significant choices that survives across sessions and contributors?

## Considered Options

* Numbered Markdown ADRs in `docs/decisions/`
* Prose documentation (README / wiki) updated in place
* No record; rely on git history and code comments

## Decision Outcome

Chosen option: "Numbered Markdown ADRs in `docs/decisions/`", because it is
in-repo (visible to every agent and contributor), append-only (history is
never rewritten), and cheap to maintain.

Architecturally significant decisions — those affecting structure, quality
attributes, or that are expensive to reverse — are recorded here as numbered
Markdown ADRs (`NNNN-short-slug.md`, based on `adr-template.md`). Once an
ADR is accepted, its body is never rewritten — even when the decision
changes. Instead, write a new ADR that supersedes it and set the old one's
`status` line to `superseded by ADR-XXXX`. The old decision stays in the
log, readable, with its original reasoning intact. Cheap-to-reverse
choices (individual lint/test tools, formatting) are NOT ADRs; they are
recorded as consequences inside a relevant ADR.

### Consequences

* Good, because a newcomer can read `docs/decisions/` in order and
  reconstruct why the system is shaped the way it is.
* Good, because reversing a decision costs one new ADR, not an edit to
  history.
* Bad, because over-recording trivial choices would erode trust in the log;
  we deliberately keep the bar at "significant".
