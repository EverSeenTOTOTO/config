---
name: refactor
description: "You MUST use this before any code restructuring. Ensures changes align with domain boundaries, preserve behavioral intent, and are incrementally verified."
---

# Domain-Aligned Refactoring

## Overview

Improve code structure by aligning it with domain boundaries and mental models. Refactoring is not just moving code; it's ensuring the codebase accurately reflects the ubiquitous language and domain logic.

Start by assessing the risk and domain impact. Low-risk changes are technical hygiene; medium/high-risk changes often indicate a mismatch between the domain model and the code that needs structural correction.

<HARD-GATE>
Do NOT make any structural change until you have assessed its risk/impact level and chosen the matching process. High-impact changes must have a written refactoring plan approved by the user before implementation begins.
</HARD-GATE>

## Risk & Impact Matrix

Assess the refactor based on **Technical Blast Radius** and **Domain Boundary Impact**. Pick the matching process.

| Level | Examples | Domain Impact | Process & Gate |
|-------|----------|---------------|----------------|
| **Low** | Rename variable/method, format, reorder imports | None (within same aggregate/concept) | Run tests → Change → Run tests → Done. Gate: Tests pass. |
| **Medium** | Extract function/value object, move logic into aggregate, eliminate duplication | Minor (clarifying existing concepts, enriching models) | Analyze domain → Shore up tests → Step-by-step → Verify. Gate: Tests pass at every step. |
| **High** | Split/merge bounded contexts, change aggregate roots, alter context maps, API redesign | Major (shifting domain boundaries, changing ubiquitous language) | Write refactoring plan → User approval → Phase-by-phase. Gate: Plan approved; phases verified. |

## Anti-Patterns

1. **"It's Just A Rename"**: Risk depends on blast radius and domain alignment. Renaming a public API used across contexts is High risk. Renaming a local variable is Low risk.
2. **"Refactor Without Model Alignment"**: Moving logic around without asking *why* it was leaking. If domain logic is scattered, the refactor must pull it into the appropriate aggregate/entity, not just extract a helper function.
3. **"Breaking Aggregate Boundaries"**: High risk. Do not split an aggregate without understanding the transactional consistency boundaries defined by the domain.

## Checklist

You MUST create a task for each of these items and complete them in order:

1. **Assess risk & domain impact** — Classify as Low, Medium, or High using the matrix.
2. **Identify domain misalignment** — Is logic leaking outside its aggregate? Is a concept misnamed?
3. **Follow matching process** — Low/Medium/High as defined above.
4. **Verify end state** — Confirm the refactor achieved domain alignment and structural improvement without unintended consequences.
5. **Commit** — Per user preference.

## The Processes

### Low Risk Process
*Focus: Technical hygiene without domain impact.*

1. Run tests (must pass)
2. Make change (e.g., rename to match ubiquitous language)
3. Run tests (must pass)
4. Commit

If tests fail, revert and reassess risk level.

### Medium Risk Process
*Focus: Clarifying domain concepts and localizing logic.*

1. **Analyze Domain Alignment**: Understand why the structure is wrong. Is logic outside its aggregate? Is a Value Object treated as a primitive?
2. **Shore up tests**: Ensure test coverage for the behavior you are moving/clarifying.
3. **Plan steps**: Break into small steps (e.g., "Move validation into Entity", "Introduce Value Object").
4. **Execute step-by-step**: Make one step → run tests → proceed. Do not batch.
5. **Commit**: Per user preference.

### High Risk Process
*Focus: Shifting domain boundaries and architectural alignment.*

<HARD-GATE>
You MUST write a refactoring plan and get user approval before making any code changes for High-risk refactors.
</HARD-GATE>

1. **Write refactoring plan**:
   - **Domain Motivation**: Why are the boundaries shifting? (e.g., "We realized 'Order' and 'Payment' are separate bounded contexts, not one aggregate").
   - **New Structure**: How the new domain model maps to code (Aggregates, Entities, Context Map).
   - **Behavioral Impact**: What is preserved, what is intentionally changed.
   - **Migration**: How consumers adapt.
   - **Rollback**: How to undo.
   - *Suggest doc location: `docs/plans/YYYY-MM-DD-<topic>-refactor.md`*

2. **Get approval**: Present plan, revise, no code changes until approved.

3. **Execute phase-by-phase**:
   - Implement one phase → verify → run tests → get user confirmation.
   - Each phase should leave the system in a usable state.

4. **Final acceptance & Commit**: Verify alignment and commit.

## Key Principles

- **Domain Alignment First** — Refactor to align code with the domain model, not just for technical aesthetics.
- **Respect Boundaries** — Bounded contexts and aggregate boundaries are structural load-bearing walls. Modifying them is High Risk.
- **Ubiquitous Language in Code** — Renames and extractions should make the code read like the domain language.
- **Behavior Preservation** — Low/Medium risk: behavior must not change. High risk: only planned domain shifts allowed.
- **Small Steps** — Each step/phase small enough to verify by eye or by test.
- **No Mixed Intent** — Don't add features while refactoring. Refactor is about structure and alignment, not new behavior.
