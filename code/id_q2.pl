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