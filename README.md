# Template

A repository template for agent-driven projects. It ships four things:

- **`AGENTS.md`** (symlinked as `CLAUDE.md`) — the operative rules
  agents load every session: global rules and act-time triggers, each
  backed by a decision record.
- **`docs/decisions/`** — the decision log (ADRs) behind those rules:
  the founding `0000-record-decisions-as-adrs.md`, plus prepackaged
  defaults grouped by topic: `project-organization/`, `ai-behavior/`,
  `code/`, `version-control/`. The folder's `README.md` is its
  contract.
- **`Makefile`** — `make format`, `make lint`, and `make test` as the
  canonical task entry points, with one shipped check (expired
  `TEMP(YYYY-MM-DD)` markers fail `make lint`) and its tests.
- **`.github/workflows/ci.yml`** — CI that runs the same `make lint`
  and `make test` entry points on every pull request and push to
  `main`, so "passes locally" and "passes in CI" cannot diverge.

## Using this template

1. Clone it (or "Use this template" on GitHub).
2. Wire your stack into the Makefile targets as it takes shape; keep
   the TEMP-marker check.
3. Record your project's first decision as
   `docs/decisions/0001-<short-slug>.md` and surface its rule in
   `AGENTS.md`.
