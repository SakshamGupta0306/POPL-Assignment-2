#!/usr/bin/env bash
# Tests for S2 (code/id_q4.rkt): conditionally insert into a nested list.
#
# Usage (from the repo root):
#   bash tests/test_q4.sh                      # tests code/id_q4.rkt
#   bash tests/test_q4.sh code/G12_q4.rkt      # or pass your file explicitly
#
# How it works: for every test, the solution file is copied to a temp
# file, a call is appended at the end (exactly as the autograder does),
# the copy is run with racket and its output is compared byte-for-byte
# with the expected output. The solution file itself is never modified.

DIR="$(cd "$(dirname "$0")" && pwd)"
SOL="${1:-$DIR/../code/id_q4.rkt}"

if ! command -v racket >/dev/null 2>&1; then
  echo "racket not found on PATH"; exit 2
fi
if [ ! -f "$SOL" ]; then
  echo "solution file not found: $SOL"; exit 2
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass=0
fail=0

report() { # name expected actual
  if [ "$3" == "$2" ]; then
    pass=$((pass + 1)); echo "PASS  $1"
  else
    fail=$((fail + 1)); echo "FAIL  $1"
    echo "      expected: $(printf '%s' "$2" | cat -A)"
    echo "      actual:   $(printf '%s' "$3" | cat -A)"
  fi
}

# --- Test kind 1: S2.a through standard input ------------------------------
# Feeds "x lst n" to (print-insert-result). The trailing newline is kept
# in the comparison, so this also checks "display, then one newline,
# and no other text".
cp "$SOL" "$TMP/stdin.rkt"
printf '\n(print-insert-result)\n' >> "$TMP/stdin.rkt"

stdin_test() { # name input expected-line
  local out
  out="$(printf '%s\n' "$2" | racket "$TMP/stdin.rkt" 2>&1; echo x)"
  report "$1" "$3"$'\n' "${out%x}"
}

# --- Test kind 2: a single expression --------------------------------------
# Appends (display EXPR) (newline) and compares the printed line.
expr_test() { # name expr expected
  cp "$SOL" "$TMP/expr.rkt"
  printf '\n(display %s)\n(newline)\n' "$2" >> "$TMP/expr.rkt"
  report "$1" "$3" "$(racket "$TMP/expr.rkt" < /dev/null 2>&1)"
}

echo "Testing: $SOL"
echo

echo "== Loading the file prints nothing =="
report "load: no output" "" "$(racket "$SOL" < /dev/null 2>&1)"

echo
echo "== Examples from the assignment (stdin) =="
stdin_test "ex1" "42 ((1 2) (3 4 5) (6) ()) 3" "((42 1 2) (3 4 5) (42 6) (42))"
stdin_test "ex2" "0 (((1) 2) (3) ((4 5 6) ())) 3" "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))"
stdin_test "ex3: empty list, n=3" "7 () 3" "(7)"
stdin_test "ex4: empty list, n=0" "7 () 0" "()"

echo
echo "== Edge cases (stdin) =="
stdin_test "n=0: nothing changes" "a (1 (2) ()) 0" "(1 (2) ())"
stdin_test "length == n is NOT short" "q (1 2 3) 3" "(1 2 3)"
stdin_test "length == n-1 is short" "z (1 2 3) 4" "(z 1 2 3)"
stdin_test "big n: every list" "k ((1 2 3 4) (5)) 10" "(k (k 1 2 3 4) (k 5))"
stdin_test "only empty sublists, n=1" "9 (() ()) 1" "((9) (9))"
stdin_test "nested empties" "5 (((()))) 2" "(5 (5 (5 (5))))"
stdin_test "symbol atoms" "hello (a (b c) d) 3" "(a (hello b c) d)"
stdin_test "mixed nesting" "x ((a b) () (c (d))) 2" "((a b) (x) (c (x d)))"
stdin_test "length uses ORIGINAL list" "x ((1) (2 3)) 2" "((x 1) (2 3))"
stdin_test "multi-line stdin" $'w\n((1)\n (2 3))\n2' "((w 1) (2 3))"

echo
echo "== Helper functions (S2.b / S2.c) =="
expr_test "my-length ()" "(my-length '())" "0"
expr_test "my-length counts top level only" "(my-length '(1 (2 3) () ((4))))" "4"
expr_test "my-map doubles" "(my-map (lambda (v) (* v 2)) '(1 2 3))" "(2 4 6)"
expr_test "my-map on ()" "(my-map (lambda (v) v) '())" "()"
expr_test "my-map keeps order" "(my-map car '((a) (b) (c)))" "(a b c)"
expr_test "make-inserter: len = 2" \
  "((make-inserter 'z (lambda (len) (= len 2))) '(1 (2 3) (4)))" "(1 (z 2 3) (4))"
expr_test "make-inserter: len = 0" \
  "((make-inserter 'e (lambda (len) (= len 0))) '(() (1) (())))" "((e) (1) ((e)))"
expr_test "make-inserter: never" \
  "((make-inserter 'n (lambda (len) #f)) '(1 (2) ()))" "(1 (2) ())"
expr_test "insert-if-short called directly" "(insert-if-short 'x '() 1)" "(x)"

echo
echo "== Scale (hidden tests use depth 100 and 10,000 elements) =="
expr_test "depth 100, n=2: every level" "(let* ((d (let b ((k 0) (a '())) (if (= k 100) a (b (+ k 1) (list a))))) (e (let b ((k 0) (a '(x))) (if (= k 100) a (b (+ k 1) (list 'x a)))))) (equal? (insert-if-short 'x d 2) e))" "#t"
expr_test "depth 100, n=1: innermost only" "(let* ((d (let b ((k 0) (a '())) (if (= k 100) a (b (+ k 1) (list a))))) (e (let b ((k 0) (a '(x))) (if (= k 100) a (b (+ k 1) (list a)))))) (equal? (insert-if-short 'x d 1) e))" "#t"
expr_test "10,000 flat, n=10001: insert" "(let* ((l (let b ((i 9999) (a '())) (if (< i 0) a (b (- i 1) (cons i a))))) (r (insert-if-short 'x l 10001))) (and (eq? (car r) 'x) (equal? (cdr r) l) (= (my-length r) 10001)))" "#t"
expr_test "10,000 flat, n=10000: unchanged" "(let ((l (let b ((i 9999) (a '())) (if (< i 0) a (b (- i 1) (cons i a)))))) (equal? (insert-if-short 'x l 10000) l))" "#t"
expr_test "10,000 sublists, n=2: each one" "(let* ((l (let b ((i 0) (a '())) (if (= i 10000) a (b (+ i 1) (cons (list i) a))))) (r (insert-if-short 'x l 2))) (and (= (my-length r) 10000) (andmap (lambda (s) (eq? (car s) 'x)) r)))" "#t"
expr_test "my-length of 100,000" "(my-length (let b ((i 0) (a '())) (if (= i 100000) a (b (+ i 1) (cons i a)))))" "100000"

echo
echo "Passed: $pass   Failed: $fail"
[ "$fail" -eq 0 ]