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



(define (tree-stats tree)
  (if (null? tree)
      (list 0 0)
      (let* ((left-stats (tree-stats (cadr tree)))
             (right-stats (tree-stats (caddr tree)))
             (height (+ 1
                        (max (car left-stats)
                             (car right-stats))))
             (leaves
              (if (and (null? (cadr tree))
                       (null? (caddr tree)))
                  1
                  (+ (cadr left-stats)
                     (cadr right-stats)))))
        (list height leaves))))

(define (print-height-and-leaves tree)
  (display (tree-stats tree))
  (newline))
