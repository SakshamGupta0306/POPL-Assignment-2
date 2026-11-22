
(define t1
  '(4
    (2 (1 () ()) (3 () ()))
    (6 (5 () ()) (7 () ()))))

(display "Test 1: Complete binary tree")
(newline)
(print-inorder t1)

(display "Test 2: Empty tree")
(newline)
(print-inorder '())

(display "Test 3: Single node")
(newline)
(print-inorder '(1 () ()))

(display "Test 4: Right-skewed tree")
(newline)
(print-inorder '(1 () (2 () (3 () ()))))

(display "Test 5: Left-skewed tree")
(newline)
(print-inorder '(3 (2 (1 () ()) ()) ()))


(display "Test 6: All traversals of complete tree")
(newline)
(print-all-traversals t1)

(define t2 '(1 () (2 () (3 () ()))))

(display "Test 7: Right-skewed tree")
(newline)
(print-all-traversals t2)

(define t3 '(a (b () ()) (c () ())))

(display "Test 8: Tree with symbols")
(newline)
(print-all-traversals t3)

(display "Test 9: Empty tree")
(newline)
(print-all-traversals '())



(display "Test 10: Complete binary tree")
(newline)
(print-height-and-leaves t1)

(define t2-height '(1 () (2 () (3 () ()))))

(display "Test 11: Right-skewed tree")
(newline)
(print-height-and-leaves t2-height)

(define t3-height '(a (b () ()) (c () ())))

(display "Test 12: Tree with two leaves")
(newline)
(print-height-and-leaves t3-height)

(display "Test 13: Empty tree")
(newline)
(print-height-and-leaves '())

(display "Test 14: Single-node tree")
(newline)
(print-height-and-leaves '(1 () ()))

(display "Test 15: Left-skewed tree")
(newline)
(print-height-and-leaves '(3 (2 (1 () ()) ()) ()))
