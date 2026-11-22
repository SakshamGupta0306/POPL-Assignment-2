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



(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (car tree)
            (preorder-acc
             (cadr tree)
             (preorder-acc (caddr tree) acc)))))

(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc
       (cadr tree)
       (postorder-acc
        (caddr tree)
        (cons (car tree) acc)))))

(define (print-all-traversals tree)
  (display (inorder-acc tree '()))
  (newline)
  (display (preorder-acc tree '()))
  (newline)
  (display (postorder-acc tree '()))
  (newline))
