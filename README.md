# POPL Assignment 2: Logic and Functional Programming

This repository contains the implementation, test suites, AI development skills, and prompt logs for **CS F301 Principles of Programming Languages (Assignment 2)**.

**Group ID:** `37`  
All solution files in `code/` follow the pattern `37_q1.pl`, `37_q2.pl`, `37_q3.rkt`, and `37_q4.rkt`.

---

## 1. Prerequisites & Installation

The assignment requires **SWI-Prolog** (for logic programming) and **Racket / Scheme** (for functional programming).

### On Ubuntu / Debian Linux:
```bash
# Update package repositories
sudo apt update

# Install SWI-Prolog and Racket
sudo apt install -y swi-prolog racket
```

### Verification of Installation:
```bash
swipl --version   # Expected: SWI-Prolog version 8.x or 9.x
racket --version  # Expected: Racket v8.x
```

---

## 2. Running the Solution Files

All solution files contain **only definitions** (no `halt/0`, no initialization directives, no top-level prints or execution calls on load).

### Problem 1: Department Assignment Puzzle, Reloaded (`code/37_q1.pl`)

* **Task P1.a (Solve and Print Formatted Solution):**
  Derives one valid assignment satisfying Clues 1 through 8 and prints the exact 4-line format:
  ```bash
  swipl -q -f code/37_q1.pl -g main -t halt
  ```
  **Output:**
  ```text
  Alex = [design, java, AI]
  Ben = [development, javascript, web]
  Carla = [research, c++, data]
  Dana = [testing, python, embedded]
  ```

* **Task P1.b (Count Solutions for Clues 1 to 8):**
  ```bash
  swipl -q -f code/37_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), format('Count N = ~w~n', [N])" -t halt
  ```
  **Output:** `Count N = 3` *(See detailed analysis in `P1_REPORT.md`)*

* **Task P1.c (Count with Clue 9 Repair):**
  ```bash
  swipl -q -f code/37_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9], N), format('Count N = ~w~n', [N])" -t halt
  ```
  **Output:** `Count N = 1`

---

### Problem 2: Form a Valid Arithmetic Equation (`code/37_q2.pl`)

* **Task P2.a (`generate_equation/2`):**
  Finds one valid equation for a list of non-negative integers:
  ```bash
  swipl -q -f code/37_q2.pl -g "generate_equation([4,2,5,3], E), writeln(E)" -t halt
  ```

* **Task P2.b (`all_equations/2` & `count_equations/2`):**
  Returns all valid equations sorted via `sort/2`, without duplicates:
  ```bash
  swipl -q -f code/37_q2.pl -g "all_equations([4,2,5,3], Es), writeln(Es)" -t halt
  ```
  **Output:** `["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3", "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]`

  Count equations:
  ```bash
  swipl -q -f code/37_q2.pl -g "count_equations([4,2,5,3], N), writeln(N)" -t halt
  ```

---

### Problem S1: Binary Tree Traversals (`code/37_q3.rkt`)

The file contains only definitions. The autograder appends test calls to the end of the file.

* **Run via Temporary Concatenation (Grader Simulation):**
  ```bash
  cat code/37_q3.rkt tests/test_q3.rkt > /tmp/run_q3.rkt && racket /tmp/run_q3.rkt && rm /tmp/run_q3.rkt
  ```

* **Run via Racket Interactive Subshell (`enter!`):**
  ```bash
  racket -e '(enter! (file "code/37_q3.rkt"))' -e '
  (define t1 (quote (4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ())))))
  (print-inorder t1)
  (print-all-traversals t1)
  (print-height-and-leaves t1)
  '
  ```

---

### Problem S2: Conditionally Insert into Nested List (`code/37_q4.rkt`)

* **Task S2.a (Read from Stdin and Print Result):**
  Reads atom `x`, list `lst`, and integer `n` from stdin:
  ```bash
  echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket -e '(enter! (file "code/37_q4.rkt"))' -e '(print-insert-result)'
  ```
  **Output:** `((42 1 2) (3 4 5) (42 6) (42))`

* **Call `insert-if-short` directly in Racket:**
  ```bash
  racket -e '(enter! (file "code/37_q4.rkt"))' -e '(display (insert-if-short 7 (quote ()) 3)) (newline)'
  ```
  **Output:** `(7)`

---

## 3. Running the Test Suites

### Test Suite for Problem 1 (`tests/test_q1.pl`)
Runs all test categories (Domain permutations, Clues 1 to 9, Solver output format, Solution counting):
```bash
cd tests && swipl -q -f test_q1.pl -g "run_category_a, run_category_b, run_category_c, run_category_d" -t halt && cd ..
```

### Test Suite for Problem 2 (`tests/test_q2.pl`)
Runs 24 unit and edge-case tests (exact division, zero handling, associativity, precedence, lists of length 0/1):
```bash
swipl -q -f code/37_q2.pl -g "consult('tests/test_q2.pl'), run_tests" -t halt
```

### Test Suite for Problem S1 (`tests/test_q3.rkt`)
Runs binary tree traversal tests including empty trees, skewed trees, and balance properties:
```bash
cat code/37_q3.rkt tests/test_q3.rkt > /tmp/run_q3.rkt && racket /tmp/run_q3.rkt && rm /tmp/run_q3.rkt
```

### Test Suite for Problem S2 (`tests/test_q4.sh`)
Runs 30 comprehensive tests covering assignment examples, empty sublists, helper functions, and large-scale tests (recursion depth 100, lists of 10,000 elements):
```bash
bash tests/test_q4.sh code/37_q4.rkt
```

---

## 4. Repository Structure

```text
.
├── code/
│   ├── 37_q1.pl           # Problem 1: Prolog logic puzzle
│   ├── 37_q2.pl           # Problem 2: Prolog equation generator
│   ├── 37_q3.rkt          # Problem S1: Scheme binary tree traversals
│   └── 37_q4.rkt          # Problem S2: Scheme conditional nested insertion
├── tests/
│   ├── test_q1.pl         # Problem 1 test suite
│   ├── test_q2.pl         # Problem 2 test suite
│   ├── test_q3.rkt        # Problem S1 test calls
│   └── test_q4.sh         # Problem S2 automated test harness
├── skills/
│   ├── prolog-dev/        # Prolog development conventions & checklist
│   │   └── SKILL.md
│   └── scheme-dev/        # Scheme development conventions & checklist
│       └── SKILL.md
├── prompts/
│   ├── P1.md              # AI prompt log for Problem 1
│   ├── P2.md              # AI prompt log for Problem 2
│   ├── S1.md              # AI prompt log for Problem S1
│   └── S2.md              # AI prompt log for Problem S2
├── P1_REPORT.md           # P1.b solution count analysis and Clue 9 justification
├── ASSIGNMENT_DETAILS.md  # Complete problem breakdown & constraints
└── README.md              # Overview, prerequisites, run and test commands
```
