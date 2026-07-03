# AGENTS.md

## Decision records

Significant decisions are recorded as ADRs in `docs/decisions/`:
numbered decisions (`NNNN-short-slug.md`) at the folder root — the
founding `0000-record-decisions-as-adrs.md`, then the project's own
from `0001` — and prepackaged decisions shipped with this template,
slug-named, in topic folders (`project-organization/`, `ai-behavior/`,
`code/`, `version-control/`).

- The rules in this file are the operative summaries of the accepted
  ADRs. Before a structural or hard-to-reverse change, or when a rule
  needs its reasoning, read the relevant ADR — each is self-contained,
  so one is never more than one file away.
- When you make a significant decision (affects structure or quality
  attributes, or is expensive to reverse), record it as a new ADR and
  surface its act-time rule in this file.
- This file holds global rules and act-time triggers only. The
  mechanics of working inside a governed folder (entry format,
  numbering, lifecycle) live in that folder's contract `README.md`,
  symlinked as `AGENTS.md` and `CLAUDE.md` so it loads when a session
  works there (project-organization/folder-scoped-rules). A rule that
  must fire before a session has reason to enter the folder stays here.

## Knowledge records

- Durable knowledge that is neither a decision nor a commit (e.g.
  investigations, observed signals) lives in typed record folders under
  `docs/` — one folder per type, each with a contract `README.md`
  (symlinked as `AGENTS.md`/`CLAUDE.md`,
  project-organization/folder-scoped-rules), an entry template, and
  `status`/date frontmatter on every entry
  (project-organization/typed-record-folders). Read a folder's README
  before adding to it.
- This template ships no record folders. Declare a type only when its
  entries have begun to recur, and surface its read/write rule here
  when you create it. One home per fact: decisions → ADRs, landed
  changes → git history.

## Code

- The module dependency graph is a DAG — no import cycles, at any
  granularity (code/structure-code-as-a-dag).
- Depend only on other modules' public APIs, never their private
  internals (code/public-apis-private-internals).
- Mark temporary code with `TEMP(YYYY-MM-DD): <reason, what to do at
  expiry>`; expired or dateless markers fail `make lint`
  (code/temporary-code-is-marked-and-expires).
- A violated invariant is a bug: assert it and crash loudly at the
  point of violation — never silently correct, default, or
  log-and-continue an impossible state. Expected failures (I/O, user
  input) are ordinary error handling. Assertions stay enabled in
  production (code/assert-invariants-and-fail-fast).

## Tasks

- `make lint`, `make test`, and `make format` are the canonical entry
  points for project tasks
  (project-organization/make-targets-are-the-task-interface). Wire new
  tooling into these targets rather than documenting raw commands
  elsewhere.

## Verification

- Never verify your own change. Before a change is done, a fresh
  session (or human) that did not write it checks the diff against the
  task spec: `make lint test` is the floor, exercising the changed
  behavior is the job. The verifier is read-only — it reports findings,
  it does not fix (ai-behavior/agents-do-not-verify-their-own-work).

## Worktrees

- Concurrent work happens in per-task worktrees under `.worktrees/`
  (gitignored), one branch per worktree
  (ai-behavior/one-agent-one-branch-one-worktree). Remove the worktree
  after its branch lands.

## Commits

- Messages follow Conventional Commits
  (version-control/use-conventional-commits).
- Every commit that lands on `main` must be atomic and buildable — it
  builds, passes tests, and makes one coherent change
  (version-control/keep-history-linear). Curate the series before
  landing; verify with `git rebase main --exec 'make lint test'`.
- A behavioral change (new behavior, bug fix, changed output) includes
  tests for that behavior in the same commit
  (code/behavioral-changes-ship-with-tests).
- Documentation made inaccurate by a change is updated in that same
  change (project-organization/docs-change-with-the-code).

## Releases

- Versions are SemVer, derived mechanically from commit history and
  applied as annotated `vX.Y.Z` tags
  (version-control/use-semantic-versioning).

## Dependencies

- Standard library first. A new third-party dependency needs a
  justification in the commit body; structurally significant ones get
  their own ADR (code/justify-every-new-dependency).
