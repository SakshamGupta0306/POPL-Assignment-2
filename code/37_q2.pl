% eval_expr(+Expr, -Value)
%
% Declarative meaning:
%   Value is the integer value of the arithmetic expression tree Expr.
%   Expr is either an integer, or a term A+B, A-B, A*B or A/B whose
%   arguments are themselves expressions. A/B holds only when the value of B
%   is non-zero and the value of A is exactly divisible by it. The check applies
%   to every division nested anywhere in Expr. Intermediate values may be
%   negative.
%
% Procedural meaning:
%   Evaluate both subtrees recursively, then combine their values. Because the
%   subtrees are evaluated first, a failing nested division makes the whole
%   evaluation fail. The predicate never raises an exception on a division by
%   zero, since the divisor is tested before the division is performed. The
%   cut in the integer clause only removes the choice point for integers; the
%   other clauses are exclusive on the principal functor.
eval_expr(Expr, Value) :-
    integer(Expr),
    !,
    Value = Expr.
eval_expr(A+B, Value) :-
    eval_expr(A, VA),
    eval_expr(B, VB),
    Value is VA + VB.
eval_expr(A-B, Value) :-
    eval_expr(A, VA),
    eval_expr(B, VB),
    Value is VA - VB.
eval_expr(A*B, Value) :-
    eval_expr(A, VA),
    eval_expr(B, VB),
    Value is VA * VB.
eval_expr(A/B, Value) :-
    eval_expr(A, VA),
    eval_expr(B, VB),
    VB =\= 0,
    VA mod VB =:= 0,
    Value is VA // VB.

% expr_over(+List, -Expr, -Value)
%
% Declarative meaning:
%   Expr is an expression tree whose leaves are exactly the elements of List,
%   in order, each used once, and whose inner nodes are +, -, * or /.
%   Value is the integer value of Expr. A division node is allowed only
%   when its divisor is non-zero and divides the dividend exactly, so
%   Expr never contains an invalid division at any depth.
%
% Procedural meaning:
%   A one-element list gives a leaf. A longer list is split with append/3
%   into a non-empty Prefix and a non-empty Suffix. Both parts are built
%   recursively, and their values are combined by one of the four
%   operators. Because the values are computed bottom-up while the tree is
%   built, an invalid division fails immediately and prunes that whole
%   subtree of the search. Each tree is produced exactly once: its root
%   operator and its split point determine the children uniquely.
expr_over([N], N, N).
expr_over(List, Expr, Value) :-
    List = [_,_|_],
    Prefix = [_|_],
    append(Prefix, Suffix, List),
    Suffix = [_|_],
    expr_over(Prefix, L, VL),
    expr_over(Suffix, R, VR),
    member(Op, [+, -, *, /]),
    apply_op(Op, VL, VR, Value),
    Expr =.. [Op, L, R].

% apply_op(+Op, +A, +B, -Value)
% Value is A Op B. Division succeeds only when B is non-zero and A is
% exactly divisible by B.
apply_op(+, A, B, V) :- V is A + B.
apply_op(-, A, B, V) :- V is A - B.
apply_op(*, A, B, V) :- V is A * B.
apply_op(/, A, B, V) :- B =\= 0, A mod B =:= 0, V is A // B.

% expr_string(+Expr, -String)
%
% Declarative meaning:
%   String is the canonical SWI-Prolog string for the expression tree Expr:
%   no spaces, numbers in decimal, and parentheses only where the rules
%   require them. * and / bind tighter than + and -, and operators are
%   left-associative. A left operand is parenthesised only if its top
%   operator has lower precedence than its parent's. A right operand is
%   parenthesised if its top operator has the same or lower precedence
%   than its parent's. A single number is never parenthesised. Different
%   trees therefore give different strings.
%
% Procedural meaning:
%   A number becomes its decimal text. A node is rendered by rendering both
%   children, wrapping each in parentheses when the rules say so, and
%   concatenating left, operator, right.
expr_string(N, String) :-
    integer(N),
    !,
    number_string(N, String).
expr_string(Expr, String) :-
    Expr =.. [Op, L, R],
    prec(Op, P),
    operand_string(left, P, L, LS),
    operand_string(right, P, R, RS),
    atom_string(Op, OpS),
    string_concat(LS, OpS, S1),
    string_concat(S1, RS, String).

% operand_string(+Side, +ParentPrec, +Operand, -String)
% String is the rendering of Operand, parenthesised when its position
% (left or right of a parent with precedence ParentPrec) requires it.
operand_string(Side, ParentPrec, Operand, String) :-
    expr_string(Operand, S0),
    (   needs_parens(Side, ParentPrec, Operand)
    ->  string_concat("(", S0, S1),
        string_concat(S1, ")", String)
    ;   String = S0
    ).

% needs_parens(+Side, +ParentPrec, +Operand)
% Succeeds when Operand must be parenthesised. Numbers never are.
needs_parens(left, ParentPrec, Operand) :-
    \+ integer(Operand),
    functor(Operand, Op, 2),
    prec(Op, P),
    P < ParentPrec.
needs_parens(right, ParentPrec, Operand) :-
    \+ integer(Operand),
    functor(Operand, Op, 2),
    prec(Op, P),
    P =< ParentPrec.

% prec(+Op, -Precedence): higher number binds tighter.
prec(+, 1).
prec(-, 1).
prec(*, 2).
prec(/, 2).

% generate_equation(+List, -Equation)
%
% Declarative meaning:
%   Equation is a string "L=R" where L is the canonical string of an
%   expression over a non-empty prefix of List and R is the canonical
%   string of an expression over the remaining non-empty suffix. Every
%   number of List is used once, in order, and both sides have the same
%   integer value. It fails if no such equation exists, including for
%   lists with fewer than two elements.
%
% Procedural meaning:
%   List is split with append/3 into a non-empty Left and Right list.
%   expr_over/3 builds an expression and its value for each side. The
%   shared variable Value forces the two values to be equal, so
%   unequal pairs fail at once. The two trees are then rendered with
%   expr_string/2 and joined around "=".
generate_equation(List, Equation) :-
    List = [_,_|_],
    Left = [_|_],
    append(Left, Right, List),
    Right = [_|_],
    expr_over(Left, LExpr, Value),
    expr_over(Right, RExpr, Value),
    expr_string(LExpr, LS),
    expr_string(RExpr, RS),
    string_concat(LS, "=", S1),
    string_concat(S1, RS, Equation).

% all_equations(+List, -Equations)
%
% Declarative meaning:
%   Equations is the sorted, duplicate-free list of all strings "L=R" such
%   that, for some split of List into a non-empty prefix and a non-empty
%   suffix, L is the canonical string of an expression over the prefix, R
%   is the canonical string of an expression over the suffix, and both
%   expressions have the same value. It is [] when none exist, including
%   for lists with fewer than two elements.
%
% Procedural meaning:
%   For each split point, split_equations/3 builds the equations of that
%   split by joining the two sides on equal value. The per-split results
%   are concatenated and passed to sort/2 for ordering and de-duplication.
%   findall/3 yields [] when split_list/3 fails, so short lists give [].
all_equations(List, Equations) :-
    findall(Es,
            ( split_list(List, Left, Right),
              split_equations(Left, Right, Es) ),
            Groups),
    append(Groups, Es0),
    sort(Es0, Equations).

% split_list(+List, -Left, -Right)
% Left and Right are a non-empty prefix and suffix with Left+Right = List.
% Fails for lists with fewer than two elements.
split_list(List, Left, Right) :-
    List = [_,_|_],
    Left = [_|_],
    append(Left, Right, List),
    Right = [_|_].

% split_equations(+Left, +Right, -Equations)
%
% Declarative meaning:
%   Equations holds the strings "L=R" for every pair of an expression over
%   Left and an expression over Right that have the same value.
%
% Procedural meaning:
%   Each side is computed once as Value-Expr pairs and sorted by value with
%   keysort/2. join_sorted/3 then walks both sorted lists in step, so no
%   side is regenerated, and only matching pairs are rendered to strings.
split_equations(Left, Right, Equations) :-
    findall(V-E, expr_over(Left, E, V), LP0),
    findall(V-E, expr_over(Right, E, V), RP0),
    keysort(LP0, LP),
    keysort(RP0, RP),
    join_sorted(LP, RP, Equations).

% join_sorted(+LeftPairs, +RightPairs, -Equations)
% Both inputs are Value-Expr lists sorted by Value. Equations is the list
% of "L=R" strings for every left and right expression with equal value.
join_sorted([], _, []).
join_sorted([_|_], [], []).
join_sorted([K1-X1|LT], [K2-X2|RT], Es) :-
    compare(Ord, K1, K2),
    join_step(Ord, K1-X1, LT, K2-X2, RT, Es).

% join_step(+Order, +LeftHead, +LeftTail, +RightHead, +RightTail, -Es)
% Advance the side with the smaller value; on equal values, join the groups.
join_step(<, _, LT, RH, RT, Es) :-
    join_sorted(LT, [RH|RT], Es).
join_step(>, LH, LT, _, RT, Es) :-
    join_sorted([LH|LT], RT, Es).
join_step(=, K-X1, LT, _-X2, RT, Es) :-
    take_group(K, LT, LXs, LRest),
    take_group(K, RT, RXs, RRest),
    maplist(expr_string, [X1|LXs], LSs),
    maplist(expr_string, [X2|RXs], RSs),
    findall(S,
            ( member(LS, LSs),
              member(RS, RSs),
              string_concat(LS, "=", S1),
              string_concat(S1, RS, S) ),
            Here),
    join_sorted(LRest, RRest, More),
    append(Here, More, Es).

% take_group(+Key, +Pairs, -Exprs, -Rest)
% Exprs are the expressions at the front of Pairs whose value is Key;
% Rest is the remaining pairs.
take_group(K, [K2-X|T], Xs, Rest) :-
    (   K2 == K
    ->  Xs = [X|Xs1],
        take_group(K, T, Xs1, Rest)
    ;   Xs = [],
        Rest = [K2-X|T]
    ).
take_group(_, [], [], []).

% count_equations(+List, -N)
%
% Declarative meaning:
%   N is the number of distinct valid equations for List, that is, the
%   length of the list given by all_equations/2.
%
% Procedural meaning:
%   Compute all_equations/2, then take its length.
count_equations(List, N) :-
    all_equations(List, Equations),
    length(Equations, N).