---
name: refactor
description: "You MUST use this before any code restructuring, renaming, extracting, reorganizing, simplifying, or architectural overhaul. Ensures correct changes through risk-assessed, incrementally verified steps."
---

# Risk-Assessed Refactoring

## Overview

Improve code structure through incrementally verified changes. Covers everything from renaming a variable to restructuring an architecture — the process scales with risk.

<HARD-GATE>
Do NOT make any structural change until you have assessed its risk level and chosen the matching process. High-risk changes must have a written refactoring plan approved by the user before implementation begins.
</HARD-GATE>

## Risk Levels

Every refactor starts by assessing risk. Pick the matching process:

### Low Risk
- **Examples**: rename, move file, format, reorder imports
- **Constraint**: behavior must not change at all
- **Process**: run tests → make change → run tests → done
- **Gate**: tests pass before and after

### Medium Risk
- **Examples**: extract function, eliminate duplication, merge modules, introduce parameter
- **Constraint**: behavior must not change at all
- **Process**: analyze → shore up tests → plan steps → execute step-by-step with test verification → commit
- **Gate**: tests pass at every step

### High Risk
- **Examples**: architecture restructuring, API redesign, breaking interface changes, cross-module overhaul
- **Constraint**: planned breaking changes allowed — must be explicitly documented
- **Process**: write refactoring plan → user approval → execute phase-by-phase → verify each phase → final acceptance
- **Gate**: plan approved before any code changes; each phase verified before proceeding

## Anti-Pattern: "It's Just A Rename"

Risk assessment is mandatory for every refactor. A "simple rename" that touches a public API used by 3 other services is high-risk. A "complex architectural change" inside an isolated, well-tested module might be medium-risk. Risk depends on blast radius, not apparent complexity.

## Checklist

You MUST create a task for each of these items and complete them in order:

1. **Assess risk level** — classify as Low, Medium, or High based on blast radius
2. **Follow matching process** — Low/Medium/High as defined above
3. **Verify end state** — confirm the refactor achieved its goal without unintended consequences
4. **Commit** — per user preference (one commit, per-step commits, or per-phase commits for High risk)

## Low Risk Process

```
Run tests (must pass) → Make change → Run tests (must pass) → Commit
```

If tests fail after the change, revert and reassess — maybe this isn't low risk after all.

## Medium Risk Process

**Analyze:**
- Understand what the current code does and how it's organized
- Identify the specific structural improvements you'll make

**Shore up tests:**
- Verify existing test coverage is adequate for the areas you'll change
- If coverage is insufficient, add characterization tests first
- Tests must pass before you start refactoring

**Plan steps:**
- Break the refactor into small, independently verifiable steps
- Each step should be small enough to review by eye
- Order steps so each one leaves the code in a working state

**Execute step-by-step:**
- Make one step → run tests → if tests pass, proceed to next step
- If tests fail, revert the step and figure out what went wrong
- Do not batch multiple steps together

**Commit:**
- One commit per logical step, or one commit for the whole refactor — per user preference

## High Risk Process

<HARD-GATE>
You MUST write a refactoring plan and get user approval before making any code changes for High-risk refactors.
</HARD-GATE>

**Write refactoring plan:**
- Document: what you're changing, why, and what the new structure looks like
- List: which behaviors are preserved, which are intentionally changed (breaking changes)
- Sequence: phases of the refactor, each independently deployable/verifiable
- Migration: how existing users/consumers will adapt to breaking changes
- Rollback: how to undo each phase if it goes wrong
- Ask the user for preferred doc location (suggest `docs/plans/YYYY-MM-DD-<topic>-refactor.md`)

**Get approval:**
- Present the plan to the user
- Revise based on feedback
- No code changes until the user explicitly approves the plan

**Execute phase-by-phase:**
- Implement one phase → verify it works → run tests → get user confirmation
- If a phase reveals problems, stop and reassess the plan
- Each phase should leave the system in a usable state

**Final acceptance:**
- Verify all intended changes are complete
- Verify all breaking changes are documented and communicated
- Verify tests pass across all affected areas

**Commit:**
- One commit per phase, or per user preference

## Key Principles

- **Assess risk first** — blast radius determines process, not apparent simplicity
- **Behavior preservation** — Low/Medium risk: behavior must not change. High risk: only planned changes allowed
- **Small steps** — each step/phase small enough to verify by eye or by test
- **No mixed intent** — don't add features while refactoring. Refactor is about structure, not behavior
- **Test-first** — insufficient coverage means stop and add tests before proceeding
- **Reassess if tests fail** — a failed test might mean your risk assessment was wrong
