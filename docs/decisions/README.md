# Decision Records

Architecturally significant decisions, recorded as ADRs
(ADR-0000). This file is the folder's contract; via the
`AGENTS.md`/`CLAUDE.md` symlinks it also
loads automatically as agent instructions when a session works in this
folder (project-organization/folder-scoped-rules).

## Layout

- `0000-record-decisions-as-adrs.md` — the founding decision, shipped
  with the template. It establishes the log itself, so unlike the
  prepackaged set it is not deletable at adoption.
- The rest of the folder root — this project's own decisions, numbered
  `NNNN-short-slug.md` starting at `0001`.
- Topic folders (`project-organization/`, `ai-behavior/`, `code/`,
  `version-control/`) — prepackaged decisions shipped with the project
  template, slug-named (`<short-slug>.md`, no number); `createdAt`
  orders them when order matters. When instantiating the template,
  delete any of these you do not adopt, and remove each deleted
  decision's rule from the root `AGENTS.md`.
- Cite a numbered decision as `ADR-NNNN`; cite a prepackaged one by
  path, `<topic>/<slug>`.

## What belongs here

One file per significant decision — one that affects structure or
quality attributes, or is expensive to reverse.

## What does not belong here

- Cheap-to-reverse choices (a specific lint tool, a formatting style):
  record them as consequences inside the relevant ADR instead.
- Durable knowledge that is not a decision (investigations, observed
  signals): that lives in a typed record folder
  (project-organization/typed-record-folders).
- Operative summaries: each accepted ADR's act-time rule is surfaced in
  the root `AGENTS.md`, not here.

## Adding an entry

1. Copy `adr-template.md` to `NNNN-short-slug.md` at the folder root,
   taking the next free number, zero-padded to four digits. (In the
   template repository itself, new prepackaged decisions go into a
   topic folder as `<short-slug>.md` instead.)
2. Fill in the frontmatter (`title`, `status`, `createdAt`, `updatedAt`)
   and, at minimum: context and problem statement, considered options,
   and the decision outcome with its consequences.
3. Keep the ADR self-contained: a reader gets context, options, decision,
   and consequences without leaving the file.
4. Surface the ADR's act-time rule in the root `AGENTS.md` — triggers at
   root, mechanics here (project-organization/folder-scoped-rules).

## Lifecycle

`status`: `proposed | rejected | accepted | deprecated |
superseded by <ADR id>`

- Never edit the body of an accepted ADR — the log is append-only.
- To change course, write a new ADR that supersedes the old one — a
  project ADR may supersede a prepackaged decision — and set the old
  ADR's `status` line accordingly.
- Allowed edits on an accepted ADR: the `status` line, `updatedAt`, and
  mechanical retargeting of references when a referenced ADR is
  relocated or renamed.
