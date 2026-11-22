# P1 Report: Department Assignment Puzzle Analysis

## 1. Value of N for Clues 1 to 8
Evaluating `count_solutions([1, 2, 3, 4, 5, 6, 7, 8], N)` yields:
$$\mathbf{N = 3}$$

## 2. Puzzle Analysis

### What N = 3 Tells Us About the Puzzle
The domain has $4! \times 4! \times 4! = 13,824$ total possible assignments. Clues 1 through 8 dramatically reduce the search space, but **they do not uniquely specify a single solution**. The puzzle is **underconstrained**.

### Comparison of the 3 Solutions

| Friend | Solution 1 | Solution 2 | Solution 3 |
| :--- | :--- | :--- | :--- |
| **Alex** | `[design, java, 'AI']` | `[design, java, embedded]` | `[testing, python, embedded]` |
| **Ben** | `[development, javascript, web]` | `[development, javascript, web]` | `[development, javascript, web]` |
| **Carla** | `[research, 'c++', data]` | `[testing, python, 'AI']` | `[design, java, 'AI']` |
| **Dana** | `[testing, python, embedded]` | `[research, 'c++', data]` | `[research, 'c++', data]` |

### Key Observations:
1. **Ben is fully fixed in all 3 solutions:**
   - Department: `development`
   - Favorite Language: `javascript`
   - Project: `web`
2. **Dana and Carla swap roles between Solution 1 and Solutions 2 & 3:**
   - In Solution 1: Carla is at `[research, 'c++', data]` and Dana is at `[testing, python, embedded]`.
   - In Solutions 2 and 3: Dana is at `[research, 'c++', data]`, while Carla and Alex permute between `[design, java, ...]` and `[testing, python, ...]`.
3. **The 3 solutions form an underconstrained branch:**
   - Because Clue 7 permits Dana to work in either `research` or `testing` (`(Dept = research ; Dept = testing)`), it opens multiple valid assignments.
   - An additional constraint (Clue 9) is strictly required to eliminate 2 of the solutions and produce a unique assignment ($N = 1$).
