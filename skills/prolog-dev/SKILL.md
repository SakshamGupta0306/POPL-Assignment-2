---
name: prolog-dev
description: Development guide, conventions, and review checklist for SWI-Prolog tasks
---

# Prolog Development Guide

## Environment & Version
- **Language:** Prolog
- **Target Implementation:** SWI-Prolog 9.x
- **Standard Execution Format:**
  - Running main: `swipl -q -f code/<id>_q1.pl -g main -t halt`
  - Running queries / predicates: `swipl -q -f code/<id>_q1.pl -g "<goal>" -t halt`

## Coding Conventions
1. **Clean Definitions Only:**
   - Files must contain **only definitions** (rules and facts).
   - **Never** call `halt/0` inside solution files.
   - **Never** use `:- initialization(...)` directives.
2. **Naming & Structure:**
   - Predicate names: `snake_case/Arity`.
   - Variables: `CamelCase` starting with uppercase letter.
   - Document declarative and procedural meaning for every non-trivial predicate.
3. **Restricted Built-ins & Libraries:**
   - **Forbidden:** `assert/1`, `retract/1`, `retractall/1`, global assignment variables (`b_setval/2`, `nb_setval/2`).
   - **Allowed libraries:** `library(lists)`, `library(apply)`, `library(yall)`, `library(aggregate)`.
   - Never build an expression string and parse it back into a term just to evaluate it.
4. **I/O Rules:**
   - Never print extraneous debugging or informational statements.
   - For `main/0` (P1.a), print strictly the expected format without extra headers/trailers.

## How to Run and Test Code
- Run from the repository root. Replace `<id>` with the group ID.
- Run `main`: `swipl -q -f code/<id>_q1.pl -g main -t halt`
- Run any predicate: `swipl -q -f code/<id>_q2.pl -g "all_equations([4,2,5,3], Es), print(Es), nl" -t halt`
- Run the test files (they live in `tests/`, never in `code/`):
  - P1: `cd tests && swipl -q -f test_q1.pl -g "run_category_a,run_category_b,run_category_c,run_category_d" -t halt`
  - P2: `swipl -q -f code/<id>_q2.pl -g "consult('tests/test_q2.pl'), run_tests" -t halt`
- Every assignment example must appear as a test, plus edge cases: empty list, one element, no solution, duplicates, exact and inexact division, division by zero, negative intermediate values.
- Test failure as well as success: use `\+ Goal` for goals that must fail.
- Before finishing, grep the file for `assert`, `retract`, `halt`, `initialization`, `nb_setval`, `b_setval`, `term_to_atom`, `term_string`.

## Self-Review Checklist
Before finalizing any Prolog code:
- [ ] Are all rules purely declarative where possible?
- [ ] Are all base cases handled before or properly ordered with recursive steps?
- [ ] Is negation/cut handled safely to avoid unintended failure or choice-point leaks?
- [ ] Does the predicate fail cleanly without looping or throwing unexpected runtime exceptions?
- [ ] Are there zero calls to `assert`, `retract`, `halt/0`, or initialization directives?
- [ ] Are all output formats (strings vs atoms) strictly adhering to the specification?

## Known AI Failure Modes in Prolog
1. **Accidental Infinite Recursion:** AI frequently fails to ensure terminating conditions on generated sublists or terms.
2. **Misuse of String vs Atom:** Using atoms (`'...'`) when strings (`"..."`) are required, or code lists.
3. **Choice Point Leakage:** Leaving unwanted choice points leading to duplicate answers on backtracking.
4. **Evaluation via String Manipulation:** Attempting to construct string equations and evaluating via `term_string/2` or `atom_to_term/3` instead of evaluating expression trees directly.
5. **Unrequested Output:** Adding `format/2` or `print/1` debugging lines that survive into the final file.
6. **Global State Reliance:** Attempting to use global variables (`nb_setval`) or dynamic database assertion instead of accumulators or `findall/3`/`aggregate_all/3`.