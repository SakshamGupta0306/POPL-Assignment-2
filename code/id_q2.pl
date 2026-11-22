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
%   zero, since the divisor is tested before the division is performed. No cut
%   is needed, as the clauses are mutually exclusive on the principal functor.
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
    Prefix = [_|_],                 % fixed before append/3, so no useless generation
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