;;; #lang racket/base

(define t1
  '(4
    (2 (1 () ()) (3 () ()))
    (6 (5 () ()) (7 () ()))))

(print-inorder t1)

(print-inorder '())

(print-inorder '(1 () ()))

(print-inorder '(1 () (2 () (3 () ()))))

(print-inorder '(3 (2 (1 () ()) ()) ()))

(print-all-traversals t1)

(define t2 '(1 () (2 () (3 () ()))))

(print-all-traversals t2)

(define t3 '(a (b () ()) (c () ())))

(print-all-traversals t3)

(print-all-traversals '())

(print-height-and-leaves t1)

(define t2-height '(1 () (2 () (3 () ()))))

(print-height-and-leaves t2-height)

(define t3-height '(a (b () ()) (c () ())))

(print-height-and-leaves t3-height)

(print-height-and-leaves '())

(print-height-and-leaves '(1 () ()))

(print-height-and-leaves '(3 (2 (1 () ()) ()) ()))
