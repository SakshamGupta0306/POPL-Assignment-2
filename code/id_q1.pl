% CS F301 Assignment 2 - Problem 1: Department Assignment Puzzle, Reloaded
% Only definitions in this file. No initialization directives, no halt/0.

:- use_module(library(lists)).

% =============================================================================
% Domain and Candidate Generation
% =============================================================================

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
% Clues 1 to 9
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

% Task P1.c: Clue 9
% CLUE 9: The friend whose favorite language is Java prefers the embedded project.
clue(9, Solution) :-
    member(p(_Name, _Dept, java, embedded), Solution).

% =============================================================================
% Task P1.a: solve and main/0
% =============================================================================

% solve(Solution):
% Generates a valid assignment satisfying all clues 1 through 8.
solve(Solution) :-
    valid_solution(Solution),
    clue(1, Solution),
    clue(2, Solution),
    clue(3, Solution),
    clue(4, Solution),
    clue(5, Solution),
    clue(6, Solution),
    clue(7, Solution),
    clue(8, Solution).

% print_solution(Solution):
% Prints the solution in the exact required layout:
% Name = [Dept, Lang, Proj]
print_solution([
    p('Alex', DeptA, LangA, ProjA),
    p('Ben',   DeptB, LangB, ProjB),
    p('Carla', DeptC, LangC, ProjC),
    p('Dana',  DeptD, LangD, ProjD)
]) :-
    format('Alex = [~w, ~w, ~w]~n', [DeptA, LangA, ProjA]),
    format('Ben = [~w, ~w, ~w]~n', [DeptB, LangB, ProjB]),
    format('Carla = [~w, ~w, ~w]~n', [DeptC, LangC, ProjC]),
    format('Dana = [~w, ~w, ~w]~n', [DeptD, LangD, ProjD]).

% main/0:
% Finds one solution satisfying clues 1 to 8 and prints it.
main :-
    solve(Solution),
    !,
    print_solution(Solution).

% =============================================================================
% Task P1.b: count_solutions/2
% =============================================================================

% all_clues_hold(ClueNumbers, Solution):
% True if every clue number in ClueNumbers holds for Solution.
all_clues_hold([], _Solution).
all_clues_hold([C|Cs], Solution) :-
    clue(C, Solution),
    all_clues_hold(Cs, Solution).

% satisfies_active(Active, Solution):
% Generates a valid solution and verifies only the clues in Active.
satisfies_active(Active, Solution) :-
    valid_solution(Solution),
    all_clues_hold(Active, Solution).

% count_solutions(Active, N):
% Active is a list of clue numbers (for example [1,2,3,4,5,6,7,8]).
% N is unified with the number of distinct solutions satisfying exactly
% the clues in Active and ignoring all others.
count_solutions(Active, N) :-
    findall(Sol, satisfies_active(Active, Sol), Solutions),
    length(Solutions, N).
