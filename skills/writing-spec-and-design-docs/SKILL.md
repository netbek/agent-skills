---
name: writing-spec-and-design-docs
description: Write or revise a feature spec and design doc before implementation. Use when the user asks for a spec, design doc, feature plan, or says "spec this", "design this", or "write the plan docs".
---

# Writing Spec and Design Docs

Write two files for a feature. The spec states **what** the system must do.
The design states **how** it will be built. Both live under one feature folder.

## File locations

```text
docs/plans/<feature-kebab>/spec.md
docs/plans/<feature-kebab>/design.md
```

Rules:

- `<feature-kebab>` is lowercase words joined with hyphens (for example `bucketed-incremental`).
- Always write both files when this skill fires. A trivial feature still gets a short design (Context plus one decision) rather than no design.
- Create the folder if it is missing. Never write these docs anywhere else.
- Do not create any other planning artifact. Motivation, scope, and impact fold into spec Purpose and design Context/Goals.

## When to use this skill

Use it for behavior changes with real stakes: new features, new subsystems,
interface changes, or risky rework.

Do not invoke it for:

- Typo fixes, pure renames with no behavior change, or formatting-only edits.
- Feasibility spikes where the output is an answer, not kept code.
- Small bounded edits to an existing flow. Those get a short in-chat design
  (approach, files touched, how to test) and an approval, with no files.

If the request spans independent subsystems, stop and propose splitting it into
separate `<feature-kebab>` folders first. One folder has one intent statable in
one sentence. If describing it needs "and also", split it.

## Workflow

Follow these steps in order. Each step ends when its completion criterion holds.

### 1. Explore the codebase read-only

Read the code, tests, configuration, and docs the feature touches. Ground scope,
approach, and acceptance in what you find. Separate observed behavior from
assumptions and proposed additions. Note conflicts with existing behavior instead
of silently picking a side. Keep exploration proportional; do follow-up digging
only for unresolved questions that would change what gets built.

Done when: you can name the modules, interfaces, and tests the feature touches,
or state exactly what is unavailable and why it blocks.

### 2. Clarify material ambiguity

Ask about anything that would change scope, externally observable behavior,
compatibility, or acceptance criteria. Ask one question at a time; prefer
multiple choice where possible. For minor details, make a reasonable assumption
and record it in the docs instead of asking.

Done when: no open question would change the spec, the approach, or acceptance.

### 3. Sharpen the vocabulary

Challenge fuzzy or overloaded terms before drafting. Define each canonical term
once in design Terminology. The spec uses those terms without redefining them.
When the user contradicts an established project term, call it out and resolve
it now.

Done when: every domain term in the spec points to one agreed meaning.

### 4. Propose approaches, then draft spec first

For anything with a genuine trade-off, present 2-3 approaches with trade-offs
and your recommendation before locking decisions. Then draft `spec.md` before
`design.md`. The spec constrains the design; the design must not silently
narrow the spec.

Done when: the chosen approach is recorded with its rejected alternatives.

### 5. Self-review, then stop for approval

Run the review checklist in full and fix violations inline. Then present a
summary with file paths and stop. Wait for explicit approval of the docs before
any build step.

## Planning boundary

This skill produces planning artifacts only. The request that triggered it
authorizes planning only, even if it also asks to build. Do not write product
code, scaffold, install product dependencies, or start implementation in the
same turn. After presenting the docs, stop and wait for a new explicit request
to build.

## spec.md

A spec is a behavior contract, not an implementation plan. It says what the
system does in terms anyone could check, not how it is built.

Template:

```markdown
# <Feature> Specification

## Purpose

<2-4 sentences: the problem and the outcome. No HOW.>

## Requirements

### Requirement: <Name>

<One observable behavior. One normative keyword.>

#### Scenario: <case name>

- **WHEN** <condition>
- **THEN** <observable outcome>
- **AND** <further outcome>
```

Strict rules. Fix violations before requesting review:

- Title is `# <Feature> Specification`.
- `## Purpose` is substantive prose (2-4 sentences), never a placeholder.
- Each `### Requirement:` states exactly one observable behavior with exactly
  one normative keyword: `SHALL` or `MUST` (default to `SHALL`). Never use
  `SHOULD` or `MAY` unless a justified exception is genuinely intended.
- Scenarios use exactly four hashes (`#### Scenario:`). Bullets or three
  hashes are errors.
- Every requirement has at least one scenario, and every scenario exercises its
  requirement with a concrete condition and outcome. Cover the happy path plus
  the edge and error cases that matter. Name each case (`Rejected expired
  token`), never `Test 2`.
- A tester who has never seen the code could tell whether each requirement
  passed. If not, sharpen it.
- No implementation detail in the spec: no file paths, class or function names,
  libraries, schemas, or step-by-step plans. Quick test: if the implementation
  could change without changing externally visible behavior, it does not belong
  here. That material belongs in `design.md`.
- No delta sections. Each spec is a complete standalone contract, not a list of
  edits to another document.

## design.md

The design records the approach and the reasoning behind it: the context it
assumes, the decisions taken, the alternatives rejected, and how it will be
verified.

Template:

```markdown
# <Feature> Design

## Context

<Current state and constraints that shape the approach.>

## Goals

1. <What this design achieves.>
2. ...

## Non-goals

- <Explicitly out of scope.>

## Terminology

| Term | Meaning |
|------|---------|
| <term> | <agreed meaning> |

## Architecture

<Diagram and numbered flows. Where two paths exist, describe each.>

## Code layout

| Module | Responsibility |
|--------|----------------|
| <path> | <what it owns> |

## Design decisions

### D1: <title>

**Decision.** <What was chosen.>

**Rationale.** <Why this over the alternatives.>

**Consequences.** <Costs, limits, and follow-on effects.>

## Alternatives considered

| Alternative | Why rejected |
|-------------|--------------|
| <option> | <reason> |

## Test strategy

| Layer | Scope | Examples |
|-------|-------|----------|
| <layer> | <what it covers> | <concrete cases> |

## Open questions

- <Only genuinely deferrable unknowns: answerable later without changing the
  spec, the approach, or acceptance. Blocking unknowns are resolved now, not
  listed here. Omit this section if empty.>

## References

- <Related docs, analyses, upstream code.>
```

Guidance:

- Optional sections (include only when the feature needs them): state or
  lifecycle tables, concurrency and correctness analysis, a configuration
  reference table, an error reference table with exact message strings. When
  used, the spec defers to them by link (terms to Terminology, message wording
  to the error reference) instead of duplicating them.
- Decisions record hard-to-reverse, surprising, or genuinely traded-off choices
  only. The obvious path needs no entry. Each entry keeps all three parts:
  Decision, Rationale, Consequences. Alternatives that are worth remembering go
  in the table so nobody re-proposes them in six months.
- Keep interfaces small: fewer entry points, simpler parameters, complexity
  hidden behind the interface. Say where each interface lives and what varies
  across it.
- Focus on architecture and approach, not line-by-line implementation. If a
  section would only restate the spec, point to the spec instead.

## Frozen spec, living design

After the user approves the docs:

- `spec.md` is frozen. Typo and clarification fixes that change no behavior are
  free. Any behavior change is appended as a dated entry under a trailing
  `## Amendments` section (what changed, why, and any migration), with the spec
  version bumped and re-approved. Never rewrite approved requirements silently.
- `design.md` is living. Update it freely as implementation learning demands.
  If a design edit requires a spec behavior change, amend the spec first.

The header of each file states its status: spec records its frozen version,
approver, and date; design records its last update date.

## Review checklist

Run this before presenting the docs. Fix every failure inline; do not present
docs with known violations.

- [ ] One intent statable in one sentence; nothing extra crept into scope.
- [ ] Purpose matches what was asked; Non-goals name the nearest tempting
  additions that are excluded.
- [ ] Every requirement is one observable behavior with one `SHALL`/`MUST`.
- [ ] Every requirement has at least one scenario that actually exercises it;
  edge and error cases are covered, not just the happy path.
- [ ] The case the requester cares about most has a named scenario.
- [ ] No implementation detail in the spec; file paths and code shape live in
  design Code layout only.
- [ ] Terms are defined once in design Terminology and used consistently.
- [ ] Every design decision has Decision, Rationale, and Consequences;
  rejected alternatives worth remembering are recorded.
- [ ] Open questions hold only deferrable unknowns; nothing listed there would
  change the spec, the approach, or acceptance.
- [ ] No placeholders: no TBD, TODO, empty sections, or vague requirements.

## Presentation

After the checklist passes, report:

- Feature folder and both file paths.
- One-paragraph summary of what the spec guarantees and what the design chose.
- Assumptions made and open questions deferred.
- Prompt: "Please review both docs. Tell me what to change, or approve to
  proceed. I will not start implementation until you approve in a separate
  request."

## Red flags

| Thought | Reality |
|---------|---------|
| "Too simple to need docs" | Then do not invoke this skill. Write the in-chat design or the code. |
| "One file is simpler" | One file couples two lifecycles. Keep spec and design separate. |
| "Implementation detail clarifies the spec" | It makes the spec go stale with the code. Move it to design. |
| "This scenario restates the requirement" | It tests nothing. Rewrite it as a concrete condition and outcome. |
| "They approved the idea, so the docs are approved" | Approval of an idea approves nothing. Approval happens on the written docs. |
| "I'll start building while they read" | The gate is the approval, not the draft. Present, then stop. |
