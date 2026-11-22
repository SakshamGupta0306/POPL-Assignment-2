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


% -----------------------------------------------------------------------------
% Category B: Individual Clue Verification (Clues 1 to 9)
% -----------------------------------------------------------------------------

% Test B1: Clue 1
% Clue 1: AI project friend does not work in research and is not Dana.
test_b1_clue1 :-
    % Valid: Alex has AI in design
    SolGood = [p('Alex', design, java, 'AI'), p('Ben', dev, js, web), p('Carla', research, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(clue(1, SolGood), 'Test B1.1: Clue 1 accepts valid AI friend in design'),
    % Invalid: AI friend is Dana
    SolBadDana = [p('Alex', design, java, embedded), p('Ben', dev, js, web), p('Carla', research, 'c++', data), p('Dana', testing, python, 'AI')],
    assert_true(\+ clue(1, SolBadDana), 'Test B1.2: Clue 1 rejects AI friend being Dana'),
    % Invalid: AI friend works in research
    SolBadDept = [p('Alex', research, java, 'AI'), p('Ben', dev, js, web), p('Carla', design, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(\+ clue(1, SolBadDept), 'Test B1.3: Clue 1 rejects AI friend working in research').

% Test B2: Clue 2
% Clue 2: Alex does not work in development and does not prefer C++.
test_b2_clue2 :-
    SolGood = [p('Alex', design, java, 'AI'), p('Ben', dev, js, web), p('Carla', research, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(clue(2, SolGood), 'Test B2.1: Clue 2 accepts Alex not in dev and not liking c++'),
    SolBadDev = [p('Alex', development, java, 'AI'), p('Ben', design, js, web), p('Carla', research, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(\+ clue(2, SolBadDev), 'Test B2.2: Clue 2 rejects Alex in development'),
    SolBadLang = [p('Alex', design, 'c++', 'AI'), p('Ben', dev, js, web), p('Carla', research, java, data), p('Dana', testing, python, embedded)],
    assert_true(\+ clue(2, SolBadLang), 'Test B2.3: Clue 2 rejects Alex liking c++').

% Test B3: Clue 3
% Clue 3: Testing department friend likes Python.
test_b3_clue3 :-
    SolGood = [p('Alex', design, java, 'AI'), p('Ben', dev, js, web), p('Carla', research, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(clue(3, SolGood), 'Test B3.1: Clue 3 accepts testing department friend liking Python'),
    SolBad = [p('Alex', design, java, 'AI'), p('Ben', dev, js, web), p('Carla', research, python, data), p('Dana', testing, 'c++', embedded)],
    assert_true(\+ clue(3, SolBad), 'Test B3.2: Clue 3 rejects testing department friend with non-Python language').

% Test B4: Clue 4
% Clue 4: Ben prefers web projects and does not work in testing.
test_b4_clue4 :-
    SolGood = [p('Alex', design, java, 'AI'), p('Ben', development, js, web), p('Carla', research, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(clue(4, SolGood), 'Test B4.1: Clue 4 accepts Ben with web and not in testing'),
    SolBadProj = [p('Alex', design, java, web), p('Ben', development, js, 'AI'), p('Carla', research, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(\+ clue(4, SolBadProj), 'Test B4.2: Clue 4 rejects Ben not preferring web'),
    SolBadTesting = [p('Alex', design, java, 'AI'), p('Ben', testing, js, web), p('Carla', research, 'c++', data), p('Dana', development, python, embedded)],
    assert_true(\+ clue(4, SolBadTesting), 'Test B4.3: Clue 4 rejects Ben working in testing').

% Test B5: Clue 5
% Clue 5: Java lover works in design department.
test_b5_clue5 :-
    SolGood = [p('Alex', design, java, 'AI'), p('Ben', dev, js, web), p('Carla', research, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(clue(5, SolGood), 'Test B5.1: Clue 5 accepts Java friend in design department'),
    SolBad = [p('Alex', research, java, 'AI'), p('Ben', dev, js, web), p('Carla', design, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(\+ clue(5, SolBad), 'Test B5.2: Clue 5 rejects Java friend in non-design department').

% Test B6: Clue 6
% Clue 6: Carla's project is not embedded, and her dept is not development.
test_b6_clue6 :-
    SolGood = [p('Alex', design, java, 'AI'), p('Ben', dev, js, web), p('Carla', research, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(clue(6, SolGood), 'Test B6.1: Clue 6 accepts Carla with data and in research'),
    SolBadEmb = [p('Alex', design, java, 'AI'), p('Ben', dev, js, web), p('Carla', research, 'c++', embedded), p('Dana', testing, python, data)],
    assert_true(\+ clue(6, SolBadEmb), 'Test B6.2: Clue 6 rejects Carla preferring embedded'),
    SolBadDev = [p('Alex', design, java, 'AI'), p('Ben', research, js, web), p('Carla', development, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(\+ clue(6, SolBadDev), 'Test B6.3: Clue 6 rejects Carla in development').

% Test B7: Clue 7
% Clue 7: Dana's favorite language is not Java, and she works in research or testing.
test_b7_clue7 :-
    SolGood1 = [p('Alex', design, java, 'AI'), p('Ben', dev, js, web), p('Carla', research, 'c++', data), p('Dana', testing, python, embedded)],
    SolGood2 = [p('Alex', design, java, embedded), p('Ben', dev, js, web), p('Carla', testing, python, 'AI'), p('Dana', research, 'c++', data)],
    assert_true(clue(7, SolGood1), 'Test B7.1: Clue 7 accepts Dana in testing with python'),
    assert_true(clue(7, SolGood2), 'Test B7.2: Clue 7 accepts Dana in research with c++'),
    SolBadJava = [p('Alex', design, python, 'AI'), p('Ben', dev, js, web), p('Carla', research, 'c++', data), p('Dana', testing, java, embedded)],
    assert_true(\+ clue(7, SolBadJava), 'Test B7.3: Clue 7 rejects Dana with java'),
    SolBadDept = [p('Alex', research, java, 'AI'), p('Ben', dev, js, web), p('Carla', testing, 'c++', data), p('Dana', design, python, embedded)],
    assert_true(\+ clue(7, SolBadDept), 'Test B7.4: Clue 7 rejects Dana in design department').

% Test B8: Clue 8
% Clue 8: Data project works in research and does not use JavaScript.
test_b8_clue8 :-
    SolGood = [p('Alex', design, java, 'AI'), p('Ben', dev, js, web), p('Carla', research, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(clue(8, SolGood), 'Test B8.1: Clue 8 accepts data project in research with c++'),
    SolBadDept = [p('Alex', design, java, 'AI'), p('Ben', dev, js, web), p('Carla', testing, 'c++', data), p('Dana', research, python, embedded)],
    assert_true(\+ clue(8, SolBadDept), 'Test B8.2: Clue 8 rejects data project in non-research dept'),
    SolBadJS = [p('Alex', design, java, 'AI'), p('Ben', dev, 'c++', web), p('Carla', research, javascript, data), p('Dana', testing, python, embedded)],
    assert_true(\+ clue(8, SolBadJS), 'Test B8.3: Clue 8 rejects data project using JavaScript').

% Test B9: Clue 9
% Clue 9: The friend whose favorite language is Java prefers the embedded project.
test_b9_clue9 :-
    SolGood = [p('Alex', design, java, embedded), p('Ben', dev, js, web), p('Carla', testing, python, 'AI'), p('Dana', research, 'c++', data)],
    assert_true(clue(9, SolGood), 'Test B9.1: Clue 9 accepts Java friend preferring embedded'),
    SolBad = [p('Alex', design, java, 'AI'), p('Ben', dev, js, web), p('Carla', research, 'c++', data), p('Dana', testing, python, embedded)],
    assert_true(\+ clue(9, SolBad), 'Test B9.2: Clue 9 rejects Java friend preferring AI').

% Runner for Category B
run_category_b :-
    format('--- Running Category B Tests ---~n'),
    test_b1_clue1,
    test_b2_clue2,
    test_b3_clue3,
    test_b4_clue4,
    test_b5_clue5,
    test_b6_clue6,
    test_b7_clue7,
    test_b8_clue8,
    test_b9_clue9,
    format('--- Category B Tests Completed Successfully ---~n').
