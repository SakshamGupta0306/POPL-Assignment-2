% tests/p2_tests.pl
% Plain test file for code/id_q2.pl. No halt/0, no initialization directive.
%
% Run with:
%   swipl -q -f code/id_q2.pl -g "consult('tests/p2_tests.pl'), run_tests" -t halt
%
% Every line should start with "ok". The last line is a summary.

% test(+Name, :Goal): Goal must succeed (negate inside Goal to test failure).
test(assignment_4253_exact_seven,
     ( all_equations([4,2,5,3], Es),
       Es == ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
              "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"] )).
test(assignment_4253_count,
     count_equations([4,2,5,3], 7)).
test(assignment_4253_generate_is_one_of_seven,
     ( generate_equation([4,2,5,3], E),
       memberchk(E, ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                     "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]),
       string(E) )).
test(assignment_234_generate_fails,
     \+ generate_equation([2,3,4], _)).
test(assignment_234_all_empty,
     ( all_equations([2,3,4], Es), Es == [] )).
test(assignment_248_all,
     ( all_equations([2,4,8], Es), Es == ["2*4=8"] )).
test(assignment_248_generate,
     ( generate_equation([2,4,8], E), E == "2*4=8" )).

% Lists of length 0 and 1: fail cleanly, no error, no loop.
test(empty_generate_fails,   \+ generate_equation([], _)).
test(empty_all,              ( all_equations([], Es), Es == [] )).
test(empty_count,            count_equations([], 0)).
test(single_generate_fails,  \+ generate_equation([1], _)).
test(single_all,             ( all_equations([1], Es), Es == [] )).
test(single_count,           count_equations([1], 0)).

% Zeros: only 0=0 (0+0 etc. need two numbers per side, and none exist here).
test(zero_zero,              ( all_equations([0,0], Es), Es == ["0=0"] )).

% Inexact division: 3/2 is not exact, so "3/2=1" must not appear.
test(inexact_division_excluded,
     ( all_equations([3,2,1], Es), Es == ["3-2=1", "3=2+1"] )).
% Inexact division nested inside a larger expression is also pruned.
test(inexact_nested_excluded,
     ( all_equations([7,2,3,0], Es),
       \+ ( member(E, Es), sub_string(E, _, _, _, "7/2") ) )).

% Division by zero: 5/0 must never be formed (no error, no equation).
test(div_by_zero_excluded,
     ( all_equations([5,0,0], Es), Es == ["5*0=0"] )).
% 0/0 is also invalid, so no "/" appears for [0,0,0].
test(zero_over_zero_excluded,
     ( all_equations([0,0,0], Es),
       length(Es, 6),
       \+ ( member(E, Es), sub_string(E, _, _, _, "/") ) )).

% Negative intermediate values are allowed (no unary minus in the output).
test(negative_both_sides,
     ( all_equations([1,3,2,4], Es), memberchk("1-3=2-4", Es) )).
test(negative_intermediate_then_zero,
     ( all_equations([3,5,2,0], Es), memberchk("3-5+2=0", Es) )).

% 1+(2+3) and 1+2+3 are different trees, so both appear as separate strings.
test(assoc_both_counted,
     ( all_equations([1,2,3,6], Es),
       memberchk("1+(2+3)=6", Es),
       memberchk("1+2+3=6", Es) )).
test(assoc_no_duplicates,
     ( all_equations([1,2,3,6], Es),
       sort(Es, Sorted),
       Es == Sorted,
       length(Es, N),
       count_equations([1,2,3,6], N) )).

% Output type: every result is a string, not an atom or code list.
test(results_are_strings,
     ( all_equations([4,2,5,3], Es), maplist(string, Es) )).

% Sorted by standard order and duplicate-free for a larger input.
test(sorted_and_unique_larger,
     ( all_equations([1,2,3,4,5], Es),
       sort(Es, S), Es == S )).

% ---- runner ----
run_one(Name, Goal) :-
    (   catch(\+ \+ Goal, Err, ( format("FAIL ~w (exception: ~q)~n", [Name, Err]), fail ))
    ->  format("ok   ~w~n", [Name])
    ;   (   var(Err) -> format("FAIL ~w~n", [Name]) ; true ),
        fail
    ).

run_tests :-
    findall(Name-Goal, test(Name, Goal), Tests),
    length(Tests, Total),
    findall(Name, ( member(Name-Goal, Tests), \+ run_one(Name, Goal) ), Failed),
    length(Failed, NF),
    Passed is Total - NF,
    format("~w/~w passed~n", [Passed, Total]).