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