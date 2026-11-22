# P1 Report: Department Assignment Puzzle Analysis

## 1. Value of N for Clues 1 to 8
Evaluating `count_solutions([1, 2, 3, 4, 5, 6, 7, 8], N)` yields:
$$\mathbf{N = 3}$$

## 2. Puzzle Analysis

### What N = 3 Tells Us About the Puzzle
The search space contains $4! \times 4! \times 4! = 13,824$ total possible assignments. Clues 1 through 8 narrow down the search space significantly, but **they do not uniquely determine a single solution**. The puzzle is **underconstrained**.

### The 3 Remaining Solutions:

1. **Solution 1:**
   - Alex: `[design, java, 'AI']`
   - Ben: `[development, javascript, web]`
   - Carla: `[research, 'c++', data]`
   - Dana: `[testing, python, embedded]`

2. **Solution 2:**
   - Alex: `[design, java, embedded]`
   - Ben: `[development, javascript, web]`
   - Carla: `[testing, python, 'AI']`
   - Dana: `[research, 'c++', data]`

3. **Solution 3:**
   - Alex: `[testing, python, embedded]`
   - Ben: `[development, javascript, web]`
   - Carla: `[design, java, 'AI']`
   - Dana: `[research, 'c++', data]`

### Observations on Attribute Distribution
- Notice that in **Solution 1** and **Solution 3**, the sets of 3-attribute combinations assigned to people are identical:
  $$\{(design, java, 'AI'), (dev, js, web), (research, 'c++', data), (testing, python, embedded)\}$$
  Only the assignment of these packages to individuals (Alex, Carla, Dana) differs.
- In **Solution 2**, however, the attribute pairings are distinct:
  - Java is paired with `embedded` (and `design`).
  - Python is paired with `'AI'` (and `testing`).

Because the assignment rules strictly mandate:
> *"Your clue must not mention any friend by name; it may refer to friends only through attribute values, as clue 5 does. It must be true in the one solution you keep and false in every other solution of clues 1 to 8."*

Any clue structured like Clue 5 (relating two attributes of a single person without names) has identical truth values on Solution 1 and Solution 3. Thus, the only solution among the three that can be uniquely isolated via an attribute-only rule is **Solution 2**.

---

## 3. Repair Clue (Clue 9)

### English Sentence
```text
% CLUE 9: The friend whose favorite language is Java prefers the embedded project.
```

### Prolog Implementation
```prolog
% CLUE 9: The friend whose favorite language is Java prefers the embedded project.
clue(9, Solution) :-
    member(p(_Name, _Dept, java, embedded), Solution).
```

### Verification
- **Solution 2:** The Java enthusiast (Alex) prefers `embedded` $\rightarrow$ **True**.
- **Solution 1:** The Java enthusiast (Alex) prefers `'AI'` $\rightarrow$ **False**.
- **Solution 3:** The Java enthusiast (Carla) prefers `'AI'` $\rightarrow$ **False**.

When we evaluate:
```prolog
?- count_solutions([1, 2, 3, 4, 5, 6, 7, 8, 9], N).
N = 1.
```
This reduces the count of valid solutions to exactly **1**, uniquely solving the puzzle.
