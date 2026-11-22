#lang racket/base

(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc
       (cadr tree)
       (cons (car tree)
             (inorder-acc (caddr tree) acc)))))

(define (print-inorder tree)
  (display (inorder-acc tree '()))
  (newline))
