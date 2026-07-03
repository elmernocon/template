---
title: Folder-scoped rules load from the folder's contract README
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Folder-Scoped Rules

## Context and Problem Statement

Some rules are global — they must be in front of an agent from the
first token of every session. Others are folder-scoped: how to number
an ADR, what frontmatter a record entry carries, when an entry closes.
Putting every folder's mechanics in the root instructions file bloats
what every session must read; putting them only in prose documentation
means no harness ever loads them. Where do the rules of a governed
folder live, so they reach an agent exactly when it works there?

## Considered Options

* The folder's contract `README.md`, symlinked as `AGENTS.md` and
  `CLAUDE.md`
* Everything in the root `AGENTS.md`
* Separate per-folder agent instruction files alongside the README
* Prose documentation only; rely on agents finding and reading it

## Decision Outcome

Chosen option: "Contract `README.md`, symlinked as `AGENTS.md` and
`CLAUDE.md`", because agent harnesses automatically load per-directory
instruction files when a session works under a folder — the symlinks
let one canonical document serve humans (`README.md`) and agents
(`AGENTS.md`/`CLAUDE.md`) without duplication, whereas separate agent
files would drift from the README they mirror.

* A governed folder — one with entry formats, numbering, or lifecycle
  rules of its own — keeps those rules in its `README.md`. The README
  is the canonical file; `AGENTS.md` is a relative symlink to it, and
  `CLAUDE.md` a relative symlink to `AGENTS.md`. Supporting another
  harness's filename is one more link in the chain; edits land in one
  place.
* Division of labor with the root file: the root `AGENTS.md` holds
  global rules and act-time triggers — anything that must fire before
  a session has a reason to enter the folder. The folder README holds
  the mechanics of working inside it. "Record significant decisions as
  ADRs" is a trigger and lives at root; "number it `NNNN`, zero-padded
  to four digits" is mechanics and lives in the folder.
* The repository root applies the same mechanism to its own rules
  file: `AGENTS.md` is canonical and `CLAUDE.md` is a symlink to it.

### Consequences

* Good, because rules arrive with locality: a session editing
  `docs/decisions/` gets that folder's contract loaded for it, and the
  root file stays small enough to be read in full every session.
* Good, because the human-facing README and the agent-facing
  instruction files cannot drift apart: they are one file.
* Bad, because the design leans on symlinks: Windows checkouts need
  symlink support enabled, and any host or packaging step that
  materializes symlinks as plain files (archive exports, some
  repository-templating flows) silently breaks the loading. Verify
  the symlinks survive whenever the repository changes hosts or
  packaging.
* Bad, because a folder-scoped file cannot carry a rule that must fire
  before a session enters the folder; deciding which side of the split
  each rule falls on takes judgment per rule.

### Confirmation

Every governed folder contains a `README.md` plus `AGENTS.md` and
`CLAUDE.md` symlinks that resolve to it — `docs/decisions/` is the
founding instance — and the repository root contains the
`CLAUDE.md → AGENTS.md` link.
