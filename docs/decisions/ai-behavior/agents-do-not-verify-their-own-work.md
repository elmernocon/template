---
title: Agents do not verify their own work
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Agents Do Not Verify Their Own Work

## Context and Problem Statement

The session that produced a change is the worst-placed one to judge it.
It re-reads the code through its own reasoning, so it confirms rather
than tests; it verifies against what it built instead of what was asked,
so spec drift goes unnoticed; and its "I tested it and it works" is a
claim by the party with the strongest interest in the claim being true.
Mechanical checks (lint, tests) catch what machines can catch, but
"does this do what was asked, and nothing else?" needs judgment. Whose?

## Considered Options

* An independent verifier — a fresh session given the spec and the diff
* Author self-review — the producing session verifies its own work
* Human review only
* Mechanical checks only — lint and tests suffice

## Decision Outcome

Chosen option: "An independent verifier", because independence removes
the author's confirmation bias by construction rather than by effort;
self-review asks the biased party to notice its own bias, human-only
review does not scale to agent throughput, and mechanical checks cannot
judge intent.

* Before a change is considered done, it is verified by a session that
  did not produce it: a fresh agent (or a human) given the task
  specification and the diff — not the author's conversation, reasoning,
  or self-assessment. Authors report what they intended; verifiers must
  discover what actually happened.
* The verifier is read-only with respect to the change: it runs lint
  and tests, exercises the changed behavior end-to-end where
  there is behavior to exercise, and reads anything it likes — but it
  reports findings instead of fixing them. Fixes go back to an authoring
  session. A verifier that starts editing has become a second author and
  stops being a check.
* Mechanical checks are the floor, not the job. A passing lint and test
  run is necessary; the verifier exists for what machines do not
  ask: does the change satisfy the spec, does it do anything the spec
  did not ask for, and do the tests it ships actually pin the claimed
  behavior?
* The author's self-assessment is input, never evidence. A change is
  "verified" only when the verifying party is not its author.
* Depth is proportionate — a typo fix needs a glance, a behavioral
  change needs its behavior exercised — but independence is not waived
  for small changes; small is a judgment the author is, again, poorly
  placed to make about its own work.

### Consequences

* Good, because the author-grades-own-homework failure mode is removed
  structurally: no discipline or prompt-craft is needed to counteract a
  bias the process no longer contains.
* Good, because a verifier that only has the spec surfaces spec rot
  early: if it cannot tell from the spec what the change was supposed to
  do, the spec — commit message, task description — was inadequate, and
  that is itself a finding.
* Neutral, because verification costs a second session per change; that
  is the price of evidence rather than testimony.
* Bad, because a verifier without the author's context can flag intended
  behavior as a defect; the remedy is carrying intent in the spec and
  commit message, which taxes authors — deliberately.
* Bad, because landing gains latency: produce, verify, fix, re-verify is
  longer than produce and self-declare. The loop is bounded by keeping
  changes small and atomic.

### Confirmation

* Process, not mechanism: confirmed at review time — the record of a
  landed change (PR review, verification note) shows a verifying party
  other than the authoring session.
* Where agent orchestration allows, the verifier is spawned as a
  separate read-only session given only the spec and the diff.
