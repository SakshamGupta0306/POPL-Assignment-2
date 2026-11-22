#lang racket/base
;; CS F301 Assignment 2 - Problem S2: Conditionally Insert into a Nested List
;; Only definitions in this file. Do not call functions at top level.

;; my-length : list -> non-negative integer
;; Number of top-level elements of lst (a sublist counts as 1).
;; Recursive reading: the length of () is 0; the length of (a . rest)
;; is 1 + the length of rest.
;; Tail-recursive: the count is carried in the accumulator acc,
;; so stack use stays constant even for 10,000+ elements.
(define (my-length lst)
  (let loop ((rest lst) (acc 0))
    (if (null? rest)
        acc
        (loop (cdr rest) (+ acc 1)))))

;; my-map : (any -> any) list -> list
;; Applies f to every top-level element of lst and returns the new
;; list of results, in the same order.
;; Recursive reading: mapping f over () gives (); mapping f over
;; (a . rest) gives (f a) consed onto the mapping of f over rest.
;; Only one level deep: f decides what to do with sublists.
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))

(define (insert-if-short x lst n)
  (let ((processed
         (my-map (lambda (e)
                   (if (or (pair? e) (null? e))
                       (insert-if-short x e n)
                       e))
                 lst)))
    (if (< (my-length lst) n)
        (cons x processed)
        processed))) 

;; print-insert-result : -> void
;; Reads x, lst and n from standard input (in that order) with read,
;; then displays (insert-if-short x lst n) followed by a newline.
;; let* forces the three reads to happen one after another, in order.
;; read returns lst as a list datum directly, so no quoting is needed.
;; Prints nothing else: no prompt, no labels.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))