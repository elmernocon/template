---
title: Cross-session knowledge lives in typed record folders
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Cross-Session Knowledge Lives in Typed Record Folders

## Context and Problem Statement

Agent sessions are independent and forgetful. Two kinds of knowledge
already have durable homes: decisions in the ADR log and landed changes
in git history. But much of what a session learns is
neither — an investigation that ended in a dead end, a friction observed
but not acted on, the running state of a recurring job. That knowledge
evaporates when the session ends, and later sessions re-fight settled
battles or re-discover known problems. Where does durable knowledge that
is neither a decision nor a commit live, so the next session can find it?

## Considered Options

* Typed record folders under `docs/`, each carrying its own contract
* A single free-form journal or worklog file
* An external tracker (issues, tickets)
* Nothing — rely on ADRs and git history alone

## Decision Outcome

Chosen option: "Typed record folders, each carrying its own contract",
because a folder whose README states its own rules is discoverable and
usable by a zero-context reader; a free-form journal collects everything
and retrieves nothing; and an external tracker is invisible to a session
that can only see the repository.

The convention — every record type provides:

* **A folder under `docs/`** named for the type (plural noun:
  `docs/<type>/`). `docs/decisions/` is the founding instance of this
  pattern.
* **A contract `README.md`** stating: what the type is for, what belongs
  in it, what does *not* belong and where that goes instead, how to add
  and update an entry, and the entry lifecycle — the legal `status`
  values and what closes an entry.
* **An entry template** (as `adr-template.md` is for ADRs) with YAML
  frontmatter carrying at least `status`, `createdAt`, and `updatedAt`.
* **One entry per distinct subject.** A recurrence of something already
  recorded is appended to its existing entry, never filed as a new one:
  recurrence count is signal, duplicates are noise.
* **An act-time rule in AGENTS.md** — when a session must read the folder
  and when it must write to it — added when the type is created. A record
  folder with no read rule is write-only memory: it accumulates entries
  no session ever consults.

Creating a record type is cheap to reverse and therefore needs no new
ADR; the folder's README is the record of its creation. Retiring one is
an ordinary reviewed change: promote entries still worth keeping
to their new home, delete the folder, remove its AGENTS.md rule.

This template ships no record folders deliberately. Which types a project
needs depends on what its work actually produces; declare a type when its
entries have begun to recur, not speculatively at project start.

### Worked examples

Shapes that recur in agent-driven projects, as starting points:

* `docs/investigations/` — debugging archaeology. Entry: symptom →
  hypotheses tried (including failed ones) → evidence → root cause.
  Statuses: `open | resolved | abandoned`. Read before starting a
  debugging effort; write when one ends, however it ends. `abandoned` is
  the highest-value status — dead ends are exactly what git history
  discards, and re-walking one costs a full session.
* `docs/signals/` — the inbox for observations nobody is acting on now:
  frictions, ideas, suspected bugs. A `kind` frontmatter field beats a
  folder per kind. Statuses: `open | promoted | declined`; a promoted
  entry records where it went — an investigation, an ADR, a commit. The
  promotion path is what lets separate sessions compound.
* `docs/loops/<name>/` — the contract for a recurring autonomous job:
  goal, workflow, boundaries, backlog, timeline of runs. Only once such
  a loop actually exists; the contract is read at the start of every run.

### When the pattern applies — and when it does not

Declare a record type only when all of these hold:

* The knowledge must survive across sessions and contributors, and has
  no existing home.
* Entries share a recognizable shape — if the template cannot be
  written, the type is not ready.
* The act-time rule is expressible: there is a concrete moment in the
  workflow when a session should read the folder, and one when it should
  write to it.
* The folder grows by appending entries, not by rewriting one document.

Do not create a record type for:

* **Facts that already have a home.** Decisions belong in the ADR log;
  landed changes in git history; behavior in tests and code-adjacent
  docs. A worklog type duplicating git history is the canonical mistake:
  one home per fact, cross-references everywhere else.
* **Single-session working state.** Scratch notes die with the session.
* **Rules sessions must follow.** A rule belongs in AGENTS.md — or
  better, in an automated lint check — not in an entry nothing forces
  the next session to read.
* **Volumes that need querying.** When a type outgrows "a session reads
  the folder", it has outgrown flat files; move it to a real tracker and
  retire the type.

### Consequences

* Good, because sessions compound: what one session learns, the next
  finds by listing `docs/` and reading a README, with no human relaying
  context.
* Good, because adding a type costs a README, a template, and one
  AGENTS.md line — no new ADR, no tooling.
* Neutral, because nothing existing changes: `docs/decisions/` already
  follows the convention it founds.
* Bad, because record folders rot in ways code does not — stale
  statuses, entries that should have closed. Each contract must say what
  closes an entry, and entry frontmatter is a natural target for an
  automated lint check once types exist.
* Bad, because the pattern invites speculative types, and an empty or
  stale folder erodes trust in the populated ones. The bar is
  recurrence observed, not recurrence anticipated.

### Confirmation

* Every folder under `docs/` contains a `README.md` contract and an
  entry template.
* Every record type has an act-time rule line in AGENTS.md.
* Entries carry `status`, `createdAt`, `updatedAt` frontmatter with a
  status the folder's contract declares legal — mechanically checkable,
  and worth wiring into the standard lint entry point once the first
  type exists.
