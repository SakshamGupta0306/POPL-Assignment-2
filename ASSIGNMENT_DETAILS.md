# CS F301 Principles of Programming Languages: Assignment 2
**Topic:** Logic and Functional Programming (Prolog & Scheme)  
**Time Allowed:** 12 Hours (13:00 – 24:00 on 22nd Nov 2026)  
**Assignment Type:** Group assignment (continuing groups from Assignment 1)  
**Total Marks:** 20 marks  

---

## 1. Ground Rules & Workflow Constraints

* **Strict Time Limit:** 12 hours from release time. No late submissions allowed.
* **AI Tool Policy:** Any generative AI tool may be used, subject to the decomposition rule.
* **Decomposition Rule:**
  * **No single prompt may ask for the complete solution to an entire problem.**
  * **Rule:** One prompt = one unit of work (e.g., one predicate, one function, one test file, or one review).
  * The Git commit history must clearly reflect incremental, section-by-section problem solving.
* **Collaboration:** Strictly within your group only. Sharing prompts, code, or skill files across groups is considered an academic integrity violation.
* **Environment & Versions:**
  * **Prolog:** SWI-Prolog 9.x
  * **Scheme:** Racket 8.x (`#lang racket/base`)
* **Execution & Top-Level Constraints:**
  * **Prolog:**
    * Invocation: `swipl -q -f id_q1.pl -g main -t halt` (runs `main/0`), and for other predicates: `swipl -q -f id_q1.pl -g "<goal>" -t halt`.
    * Files must contain **only definitions**.
    * **Do not** call `halt/0` inside your file.
    * **Do not** use any `initialization` directives.
    * Output must match formatting strictly; do not print extraneous debug text.
  * **Scheme:**
    * Invocation: `racket id_q3.rkt` and `racket id_q4.rkt`.
    * Files must start with `#lang racket/base`.
    * Files must contain **only definitions**.
    * **Do not** call functions at the top level or print anything during loading; the autograder attaches its own calls to the end of the file.

---

## 2. Directory Structure & Deliverables

Submissions must be a single **GitHub repository** (no `.zip` files) with full commit history preserved.

```text
GROUPID/
├── code/
│   ├── id_q1.pl
│   ├── id_q2.pl
│   ├── id_q3.rkt
│   └── id_q4.rkt
├── tests/
│   └── (your own test files, one per problem)
├── skills/
│   ├── prolog-dev/
│   │   └── SKILL.md
│   └── scheme-dev/
│       └── SKILL.md
├── prompts/
│   ├── P1.md
│   ├── P2.md
│   ├── S1.md
│   └── S2.md
└── P1_REPORT.md
```

### Key Deliverables:
1. **Code (`code/`):** 4 solution files (replace `id` with your group ID: `id_q1.pl`, `id_q2.pl`, `id_q3.rkt`, `id_q4.rkt`).
2. **Tests (`tests/`):** Test files for each problem containing provided examples plus your own edge cases.
3. **Skill Files (`skills/`):**
   * Reusable instructions for your AI assistant in folders containing `SKILL.md` with YAML header (`name`, `description`).
   * Required skills:
     * `prolog-dev/SKILL.md`
     * `scheme-dev/SKILL.md`
   * Must include: language & version, coding conventions (naming, declarative/recursive reading), execution/testing commands, self-review checklist, and known failure modes of AI tools for that language.
4. **Prompts (`prompts/`):** Exact prompts given to the AI copied word-for-word (`P1.md`, `P2.md`, `S1.md`, `S2.md`).
5. **P1 Report (`P1_REPORT.md`):** Documents the solution count $N$ found in P1.b for clues 1–8 and explains what it reveals about the puzzle.

---

## 3. Detailed Problem Breakdown & Tasks

---

### P1: Department Assignment Puzzle, Reloaded (Prolog)
* **File:** `code/id_q1.pl`
* **Domain:** 4 friends (`'Alex'`, `'Ben'`, `'Carla'`, `'Dana'`), each with a unique:
  * **Department:** `research`, `development`, `design`, `testing`
  * **Favorite language:** `python`, `java`, `'c++'`, `javascript`
  * **Project:** `'AI'`, `web`, `embedded`, `data`
* **Representation:** A list of 4 terms in fixed order:  
  `[p('Alex', DeptA, LangA, ProjA), p('Ben', DeptB, LangB, ProjB), p('Carla', DeptC, LangC, ProjC), p('Dana', DeptD, LangD, ProjD)]`
* **Clues (Clues 1 to 8):**
  1. The friend who prefers the AI project does not work in research and is not Dana.
  2. Alex does not work in development and does not prefer C++.
  3. The friend working in the testing department likes Python.
  4. Ben prefers web projects and does not work in testing.
  5. The friend whose favorite language is Java works in the design department.
  6. Carla's project preference is not embedded, and her department is not development.
  7. Dana's favorite language is not Java, and she works in research or testing.
  8. The friend who prefers data projects works in research and does not use JavaScript.

#### Clue Clause Specification:
* Implement each clue as a separate clause: `clue(N, Solution)` that succeeds if and only if clue $N$ holds on a fully filled-in `Solution`.

#### Tasks:
* **P1.a (solve):** `main/0` derives and prints one valid solution satisfying clues 1–8 in this exact format:
  ```text
  Alex = [research, python, AI]
  Ben = [development, java, web]
  Carla = [design, c++, embedded]
  Dana = [testing, javascript, data]
  ```
  *(Note: The above values are illustrative only. Do not hardcode.)*
* **P1.b (count):** Define `count_solutions(Active, N)` where `Active` is a list of clue numbers (e.g. `[1,2,3,4,5,6,7,8]`). `N` is the number of solutions satisfying exactly the active clues. Must use `findall/3` or `aggregate_all/3`. Record $N$ and analysis in `P1_REPORT.md`.
* **P1.c (repair):** Add a 9th clue `clue(9, Solution)` such that `count_solutions([1,2,3,4,5,6,7,8,9], N)` yields `N = 1`.
  * Must place the English sentence of the clue as a comment directly above it, formatted as: `% CLUE 9: ...`
  * **Condition:** Must not name any friend directly; reference friends only via attribute values (like Clue 5). Must be true for the kept solution and false for all other solutions of Clues 1–8.

#### Specific Constraints:
* **Forbidden:** `assert`, `retract`, global variables (`b_setval`, `nb_setval`).
* **Allowed libraries:** `lists`, `apply`, `yall`, `aggregate`.
* Do not print anything other than specified.

---

### P2: Form a Valid Arithmetic Equation (Prolog)
* **File:** `code/id_q2.pl`
* **Goal:** Given a list of non-negative integers $[n_1, n_2, \dots, n_k]$, place operators (`+`, `-`, `*`, `/`) and exactly one `=` between numbers (using each number once in original order, with optional parentheses) such that $L = R$ and both sides evaluate to the same integer value.
* **Rules & Expression Grammar:**
  * Split list at index $j$ ($1 \le j < k$): $L$ over $n_1 \dots n_j$, $R$ over $n_{j+1} \dots n_k$.
  * Expression is a single number or two sub-expressions joined by `+`, `-`, `*`, `/`.
  * No unary minus; cannot concatenate digits. Sub-expression values may be negative.
  * **Division Rule:** Division `/` is allowed **only** if exact (integer division with remainder 0) and divisor $\ne 0$. This applies to **all** intermediate divisions.
* **Canonical Output String Format:**
  * Return as SWI-Prolog string (`"..."`, not an atom or code list), no spaces.
  * `*` and `/` have higher precedence than `+` and `-`. Left-associative.
  * **Parentheses Rules:**
    * Single numbers never take parentheses.
    * Left operand parenthesized only if its top operator has **strictly lower** precedence than parent operator.
    * Right operand parenthesized if its top operator has **lower or equal** precedence compared to parent operator.
    * Examples: `(4+2)*3`, `4+2*3`, `8/4*2` for `(8/4)*2`, `8/(4*2)`, `1-2-3` for `(1-2)-3`, `1-(2-3)`, `1+(2+3)` vs `1+2+3`.
* **Tasks:**
  * **P2.a:** `generate_equation(List, Equation)` unifies `Equation` with one valid equation string. Must fail cleanly (no loop, no error) if none exists, or if list length is 0 or 1.
  * **P2.b:** `all_equations(List, Equations)` unifies `Equations` with all unique valid equation strings, without duplicates, sorted via `sort/2`. If none, `Equations = []`.
  * `count_equations(List, N)` returns length of that list.
* **Specific Constraints:**
  * **Forbidden:** `assert`, `retract`, global variables, building a string and parsing it back to evaluate it.
  * **Allowed libraries:** `lists`, `apply`, `yall`, `aggregate`.
  * No printing.

---

### Scheme Rules & Universal Constraints (S1 & S2)
* **Language:** `#lang racket/base`
* **Allowed Built-ins Only:**
  * Special forms & control: `define`, `lambda`, `let`, `let*`, `letrec`, `named let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (`'`).
  * Pairs & lists: `cons`, `car`, `cdr`, `list`, all compositions of `car`/`cdr` up to 4 levels (`cadr`, `cddr`, `caddr`, `cadddr`, `cddddr`, etc.), `null?`, `pair?`, `eq?`, `assq`, `assoc`.
  * Arithmetic & comparison: `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max`.
  * I/O: `display`, `newline` (S2 additionally allows `read`).
* **Strictly Forbidden:**
  * **No** `set!` or mutators.
  * **No** vectors, hash tables, or strings.
  * **No** iteration loops (`do`, `for`).
  * **No standard list helpers:** `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail` are **strictly forbidden** (must implement your own, e.g. `my-reverse`, `my-map`, `my-length`).

---

### S1: Binary Tree Traversals (Scheme)
* **File:** `code/id_q3.rkt`
* **Tree Representation:** `()` or `(value left right)` where `value` is a number or single-character symbol.
* **Definitions & Conventions:**
  * Height of `()` is `0`. Height of node is $1 + \max(\text{height}(left), \text{height}(right))$. Single node height = `1`.
  * Leaf: left and right are both `()`. Empty tree has 0 leaves.
  * Traversals visit left subtree first, then right.
* **Tasks:**
  * **S1.a:** `(print-inorder tree)`: prints list of values in inorder (`left`, `node`, `right`) using `display` followed by `newline`.
  * **S1.b:** `(print-all-traversals tree)`: prints 3 lines:
    1. Inorder: `left`, `node`, `right`
    2. Preorder: `node`, `left`, `right`
    3. Postorder: `left`, `right`, `node`
  * **S1.c:** `(print-height-and-leaves tree)`: prints single line `(height leaf-count)`.
* **Constraints:** Pass state via function arguments; prefer tail recursion where natural. No disallowed built-ins.

---

### S2: Conditionally Insert into a Nested List (Scheme)
* **File:** `code/id_q4.rkt`
* **Goal:** Conditionally insert atom `x` at the front of every list whose original length is $< n$, at all nesting levels.
* **Rules:**
  * Length is measured on top-level elements of that list prior to insertion.
  * Top-level list is treated like every other list.
  * Empty list `()` has length 0; becomes `(x)` if $0 < n$.
  * Elements are atoms (digits or symbols) or lists (no dotted pairs). $n \ge 0$.
* **Tasks:**
  * **S2.a:** `(print-insert-result)` takes no arguments. Uses `read` to read in order: `x`, `lst`, `n` from standard input. Prints resulting list with `display` and `newline`. No prompts or extra text.
  * **S2.b:** Implement `my-length` and `my-map`. Define `(insert-if-short x lst n)` using them.
  * **S2.c:** Implement higher-order function `(make-inserter x len-ok?)` returning a function of 1 argument (`list`) inserting `x` where `(len-ok? len)` is true. Redefine `insert-if-short` using `make-inserter`.
  * *Note:* Final file must contain **a single definition** of `insert-if-short` (the one using `make-inserter`).
* **Performance / Scale Constraints:**
  * Hidden tests include **nesting depth of 100** and lists of **10,000 elements**. Implementations must handle recursion without stack overflow or performance degradation.

---

## 4. Evaluation Rubric

| Component | Description | Marks |
| :--- | :--- | :---: |
| **P1** | Prolog puzzle: solve, count, repair | 3 |
| **P2** | Prolog arithmetic equation | 3 |
| **S1** | Scheme binary tree traversals | 3 |
| **S2** | Scheme conditional insert | 3 |
| **Group Git / Process** | Repository structure, skill files, prompts, tests | 2 |
| **Individual Git Commits**| Per-student commit quality and contribution | 2 |
| **Viva** | Individual understanding and ownership | 4 |
| **Total** | | **20** |

---

## 5. Contact & Support
* **TA:** Mr. Amogh Chatterjee  
* **Email:** `f20230062@hyderabad.bits-pilani.ac.in`

