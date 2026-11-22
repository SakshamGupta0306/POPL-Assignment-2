# POPL Assignment 2: Logic and Functional Programming

This repository contains the implementation, test suites, AI development skills, and prompt logs for **CS F301 Principles of Programming Languages (Assignment 2)**.

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

## 2. Running Problem 1 (P1: Department Assignment Puzzle, Reloaded)

All Prolog code is strictly defined in `code/id_q1.pl` (no `halt/0`, no initialization directives, only definitions).

### Task P1.a: Solve and Print Formatted Solution
Derives one valid assignment satisfying Clues 1 through 8 and prints the exact 4-line output format:
```bash
swipl -q -f code/id_q1.pl -g main -t halt
```
**Sample Output:**
```text
Alex = [design, java, AI]
Ben = [development, javascript, web]
Carla = [research, c++, data]
Dana = [testing, python, embedded]
```

### Task P1.b: Count Solutions for Clues 1 through 8
Counts the number of valid assignments satisfying Clues 1 to 8:
```bash
swipl -q -f code/id_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), format('Count N = ~w~n', [N])" -t halt
```
**Output:**
```text
Count N = 3
```
*(Detailed analysis is documented in `P1_REPORT.md`)*.

### Task P1.c: Count Unique Solution with Repair Clue (Clue 9)
Counts solutions when Clue 9 is activated alongside Clues 1 to 8, yielding a unique solution ($N = 1$):
```bash
swipl -q -f code/id_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9], N), format('Count N = ~w~n', [N])" -t halt
```
**Output:**
```text
Count N = 1
```

---

## 3. Running Problem 1 Test Suite

A comprehensive test suite covering domain integrity, all individual clues, formatting, and counting is in `tests/test_q1.pl`.

### Run All Category A Tests (Domain & Search Space Integrity):
```bash
cd tests && swipl -q -f test_q1.pl -g run_category_a -t halt
```

### Run All Category B Tests (Unit Tests for Clues 1 to 9):
```bash
cd tests && swipl -q -f test_q1.pl -g run_category_b -t halt
```

### Run All Category C Tests (Solver & Output Formatting):
```bash
cd tests && swipl -q -f test_q1.pl -g run_category_c -t halt
```

### Run All Category D Tests (Counting & Repair Clue):
```bash
cd tests && swipl -q -f test_q1.pl -g run_category_d -t halt
```

---

## 4. Repository Structure

```text
.
├── code/
│   ├── id_q1.pl           # Problem 1: Prolog implementation
│   ├── id_q2.pl           # Problem 2: Prolog equation generator
│   ├── id_q3.rkt          # Problem S1: Scheme binary tree traversals
│   └── id_q4.rkt          # Problem S2: Scheme conditional insertion
├── tests/
│   ├── test_q1.pl         # Problem 1 test suite
│   ├── test_q2.pl         # Problem 2 test suite
│   ├── test_q3.rkt        # Problem S1 test suite
│   └── test_q4.rkt        # Problem S2 test suite
├── skills/
│   ├── prolog-dev/        # Prolog dev guidelines & checklist
│   │   └── SKILL.md
│   └── scheme-dev/        # Scheme dev guidelines & checklist
│       └── SKILL.md
├── prompts/
│   ├── P1.md              # Exact prompt history for Problem 1
│   ├── P2.md              # Exact prompt history for Problem 2
│   ├── S1.md              # Exact prompt history for Problem S1
│   └── S2.md              # Exact prompt history for Problem S2
├── P1_REPORT.md           # Report and analysis on P1.b and P1.c
├── ASSIGNMENT_DETAILS.md  # Complete problem statements & constraints
└── README.md              # Project overview, setup, and run instructions
```
