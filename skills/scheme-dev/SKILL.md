---
name: scheme-dev
description: Development guide, conventions, and review checklist for Racket/Scheme tasks
---

# Scheme Development Guide

## Environment & Version
- **Language:** Scheme / Racket
- **Header:** `#lang racket/base`
- **Target Implementation:** Racket 8.x
- **Standard Execution Format:**
  - Running file: `racket code/<id>_q3.rkt`
  - The autograder appends its own test calls to the end of the file.

## Allowed Built-ins
**Only** the following primitives may be used:
- **Core forms:** `define`, `lambda`, `let`, `let*`, `letrec`, `named let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (`'`).
- **Pairs & Lists:** `cons`, `car`, `cdr`, `list`, all compositions of `car` and `cdr` up to 4 levels (`cadr`, `cddr`, `caddr`, `cadddr`, `cddddr`, etc.), `null?`, `pair?`, `eq?`, `assq`, `assoc`.
- **Arithmetic & Comparison:** `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max`.
- **I/O:** `display`, `newline` (S2 additionally allows `read`).

## Forbidden Constructs
- **No mutation:** `set!`, `set-car!`, `set-cdr!`, or any mutable constructs.
- **No data structures outside lists/symbols/numbers:** No vectors, hash tables, or strings.
- **No loops:** `do`, `for`, `for/list`, etc.
- **No standard library utilities:** `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail` are strictly forbidden.
- *Any needed helper must be implemented manually using only allowed built-ins (e.g., `my-length`, `my-map`, `my-reverse`).*

## Coding Conventions
1. **Clean Definitions:**
   - Do **not** call your functions at the top level.
   - Do **not** print anything when the file is loaded.
2. **Recursion Style:**
   - Prefer tail recursion with accumulator arguments where natural.
   - Ensure handling of large inputs (e.g., list length 10,000, recursion depth 100) without running into stack overflows.
3. **Indentation and Naming:**
   - Idiomatic Lisp kebab-case (`insert-if-short`, `my-length`).
   - Clean recursive reading documented in comments.

## Self-Review Checklist
Before finalizing any Scheme code:
- [ ] Does the file start with `#lang racket/base`?
- [ ] Are all functions purely functional with zero mutations (`set!`)?
- [ ] Are all built-ins strictly within the permitted list? (Check: no `length`, no `append`, no `map`).
- [ ] Does the file avoid top-level function invocations and unwanted I/O during loading?
- [ ] Are base cases for empty lists `()` properly checked with `null?`?
- [ ] Can the code handle recursion depth up to 100 and lists up to 10,000 elements?

## Known AI Failure Modes in Scheme
1. **Accidental Built-in Usage:** Defaulting to built-ins like `length`, `append`, `reverse`, or `map` instead of implementing custom versions.
2. **Top-Level Execution Calls:** Leaving example calls like `(print-inorder t1)` active at the top level of the file.
3. **Stack Overflow on Deep/Large Lists:** Non-tail-recursive implementations failing on large lists (10,000 elements) or deep nesting (depth 100).
4. **Improper Empty List Handling:** Treating empty list `()` as an atom or failing to handle `()` when inserting conditionally.

