
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
