% CS F301 Assignment 2 - Problem 1: Department Assignment Puzzle, Reloaded
% Only definitions in this file. No initialization directives, no halt/0.

:- use_module(library(lists)).

% valid_solution(Solution):
% Solution is a list of four terms p(Name, Dept, Lang, Proj) in fixed order:
% 'Alex', 'Ben', 'Carla', 'Dana'.
% Each attribute is a permutation of the 4 allowed values so that
% each attribute value is used exactly once across the four friends.
valid_solution([
    p('Alex', DeptA, LangA, ProjA),
    p('Ben',   DeptB, LangB, ProjB),
    p('Carla', DeptC, LangC, ProjC),
    p('Dana',  DeptD, LangD, ProjD)
]) :-
    permutation([research, development, design, testing], [DeptA, DeptB, DeptC, DeptD]),
    permutation([python, java, 'c++', javascript], [LangA, LangB, LangC, LangD]),
    permutation(['AI', web, embedded, data], [ProjA, ProjB, ProjC, ProjD]).

% =============================================================================
% Clues 1 to 8
% clue(N, Solution) succeeds exactly when clue N holds in a fully filled-in Solution.
% =============================================================================

% 1. The friend who prefers the AI project does not work in research and is not Dana.
clue(1, Solution) :-
    member(p(Name, Dept, _Lang, 'AI'), Solution),
    Dept \= research,
    Name \= 'Dana'.

% 2. Alex does not work in development and does not prefer C++.
clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _Proj), Solution),
    Dept \= development,
    Lang \= 'c++'.

% 3. The friend working in the testing department likes Python.
clue(3, Solution) :-
    member(p(_Name, testing, python, _Proj), Solution).

% 4. Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    member(p('Ben', Dept, _Lang, web), Solution),
    Dept \= testing.

% 5. The friend whose favorite language is Java works in the design department.
clue(5, Solution) :-
    member(p(_Name, design, java, _Proj), Solution).

% 6. Carla's project preference is not embedded, and her department is not development.
clue(6, Solution) :-
    member(p('Carla', Dept, _Lang, Proj), Solution),
    Proj \= embedded,
    Dept \= development.

% 7. Dana's favorite language is not Java, and she works in research or testing.
clue(7, Solution) :-
    member(p('Dana', Dept, Lang, _Proj), Solution),
    Lang \= java,
    (Dept = research ; Dept = testing).

% 8. The friend who prefers data projects works in research and does not use JavaScript.
clue(8, Solution) :-
    member(p(_Name, research, Lang, data), Solution),
    Lang \= javascript.
