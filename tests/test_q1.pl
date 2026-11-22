% =============================================================================
% Tests for Problem 1 (id_q1.pl)
% =============================================================================

:- consult('../code/id_q1.pl').
:- use_module(library(lists)).

% -----------------------------------------------------------------------------
% Helper assertion
% -----------------------------------------------------------------------------
assert_true(Goal, TestName) :-
    (   call(Goal)
    ->  format('[PASS] ~w~n', [TestName])
    ;   format('[FAIL] ~w~n', [TestName]), fail
    ).

assert_equal(Actual, Expected, TestName) :-
    (   Actual == Expected
    ->  format('[PASS] ~w (Value = ~w)~n', [TestName, Actual])
    ;   format('[FAIL] ~w (Expected ~w, got ~w)~n', [TestName, Expected, Actual]), fail
    ).

% -----------------------------------------------------------------------------
% Category A: Domain & Search Space Integrity
% -----------------------------------------------------------------------------

% Test A1: Total Permutations should be 4! * 4! * 4! = 13824
test_a1_total_permutations :-
    findall(1, valid_solution(_), Solutions),
    length(Solutions, Count),
    assert_equal(Count, 13824, 'Test A1: Total permutations without clues == 13824').

% Test A2: Structure, fixed order of names, and allowed domain values
test_a2_names_and_structure :-
    valid_solution(Sol),
    !, % check the first generated solution
    length(Sol, 4),
    Sol = [
        p('Alex', DeptA, LangA, ProjA),
        p('Ben',   DeptB, LangB, ProjB),
        p('Carla', DeptC, LangC, ProjC),
        p('Dana',  DeptD, LangD, ProjD)
    ],
    AllowedDepts = [research, development, design, testing],
    AllowedLangs = [python, java, 'c++', javascript],
    AllowedProjs = ['AI', web, embedded, data],
    member(DeptA, AllowedDepts), member(DeptB, AllowedDepts),
    member(DeptC, AllowedDepts), member(DeptD, AllowedDepts),
    member(LangA, AllowedLangs), member(LangB, AllowedLangs),
    member(LangC, AllowedLangs), member(LangD, AllowedLangs),
    member(ProjA, AllowedProjs), member(ProjB, AllowedProjs),
    member(ProjC, AllowedProjs), member(ProjD, AllowedProjs),
    assert_true(true, 'Test A2: Fixed friend order and valid attribute domain values').

% Test A3: Attribute Uniqueness within any candidate
test_a3_attribute_uniqueness :-
    valid_solution([
        p('Alex', D1, L1, P1),
        p('Ben',   D2, L2, P2),
        p('Carla', D3, L3, P3),
        p('Dana',  D4, L4, P4)
    ]),
    !,
    sort([D1, D2, D3, D4], SortedDepts), length(SortedDepts, 4),
    sort([L1, L2, L3, L4], SortedLangs), length(SortedLangs, 4),
    sort([P1, P2, P3, P4], SortedProjs), length(SortedProjs, 4),
    assert_true(true, 'Test A3: Attribute uniqueness across all four friends').

% Runner for Category A
run_category_a :-
    format('--- Running Category A Tests ---~n'),
    test_a1_total_permutations,
    test_a2_names_and_structure,
    test_a3_attribute_uniqueness,
    format('--- Category A Tests Completed Successfully ---~n').
