---
title: Modules expose public APIs and keep internals private
status: accepted
createdAt: 2026-07-03
updatedAt: 2026-07-03
---

# Public APIs, Private Internals

## Context and Problem Statement

The dependency graph constrains which modules may depend on each other;
nothing yet constrains what part of a module they may touch. When any code can
reach into any other module's internals, every refactor risks breaking unknown
callers, and two people or agents cannot safely work inside different
modules at the same time. What may one module depend on in another?

## Considered Options

* Explicit public API per module; everything else is private
* Anything importable is fair game
* Convention only (naming prefixes, docs), with no designated surface

## Decision Outcome

Chosen option: "Explicit public API per module", because it confines
coupling to stable, deliberate surfaces.

* Every module exposes an explicit public API — its intended surface,
  expressed with whatever the language provides: an export list, visibility
  modifiers, a designated api module, or a package index that re-exports
  what is meant to be used — and keeps everything else private.
* Code in one module may depend only on another module's public API, never
  on its private internals.
* Public surfaces are kept small and deliberate: a module that re-exports
  all of its internals has no real boundary at all.

### Consequences

* Good, because a module's insides are freely refactorable as long as its
  public surface stays stable, which bounds the blast radius of any change.
* Good, because multiple people or agents can work inside different
  modules' internals in parallel without colliding — coupling is confined
  to the stable public surfaces.
* Neutral, because each module's public surface must be consciously
  designed rather than emerging by accident.
* Bad, because narrow surfaces sometimes require ceremony (re-exports,
  wrapper functions) that feels heavy in small modules.

### Confirmation

Where the language can enforce visibility, enforce it there. Where it
cannot, a lint rule flagging cross-module use of non-public paths runs
as part of the standard lint entry point; the specific tool is a
cheap-to-reverse choice, not part of this decision.
