; 1
(defun one-pass (seq key test)
  (if (<= (length seq) 1)
      seq
      (let ((current-list 
             (if (funcall test (funcall key (elt seq 0)) (funcall key (elt seq 1)))
                 (concatenate 'list
                    (subseq seq 1 2)
                    (bubble-sort-functional (concatenate 'list
                                                (subseq seq 0 1)
                                                (subseq seq 2))
                                                :key key :test test))
                  (concatenate 'list
                    (subseq seq 0 1)
                    (bubble-sort-functional (subseq seq 1)
                    :key key :test test)))))
        (if (equalp current-list seq)
            (values current-list nil)
            (values current-list t)))))

(defun bubble-sort-functional (seq &key (flag t) (key #'identity) (test #'>))
  (let ((seq-type (type-of seq)))
    (if flag
        (multiple-value-bind (new-seq new-flag) (one-pass seq key test)
          (coerce (bubble-sort-functional new-seq :flag new-flag :key key :test test) seq-type))
        seq)))


(defun run-bubble-sort-test (input expected-result test-description &key (key #'identity) (test #'>))
  "Test function specifically for bubble-sort-functional with key and test parameters."
  (let ((result (bubble-sort-functional input :key key :test test)))
    (if (equalp result expected-result)
        (format t "~A: successfully.~%" test-description)
        (format t "~A: failed! ~%Expected: ~A~%Got: ~A~%" test-description expected-result result))))

(defun test-sorting-bubble ()
  "Testing bubble-sort-functional with various cases."
  (format t "~%~%Testing bubble sort...~%")
  
  ;; Standard cases
  (run-bubble-sort-test '(3 1 4 1 5 9 2 6 5 3 5) '(1 1 2 3 3 4 5 5 5 6 9) "Bubble: Standard list")
  (run-bubble-sort-test '(1 2 3 4 5) '(1 2 3 4 5) "Bubble: Already sorted list")
  (run-bubble-sort-test '(5 4 3 2 1) '(1 2 3 4 5) "Bubble: Reverse order list")
  (run-bubble-sort-test '() '() "Bubble: Empty list")
  (run-bubble-sort-test '(1) '(1) "Bubble: Single element list")
  (run-bubble-sort-test '(1 2 2 1) '(1 1 2 2) "Bubble: List with duplicates")
  
  ;; Key function tests
  (run-bubble-sort-test '(3 -1 -4 1 -5 9 -2 6 -5 3 -5) '(-1 1 -2 3 3 -4 -5 -5 -5 6 9)
                        "Bubble: Sorting with key as abs"
                        :key #'abs)
  (run-bubble-sort-test '(3 -1 -4 1 -5 9 -2 6 -5 3 -5) '(9 6 -5 -5 -5 -4 3 3 -2 -1 1)
                        "Bubble: Sorting with key as abs in descending order"
                        :key #'abs :test #'<)

  ;; Custom test functions
  (run-bubble-sort-test '(3 2 5 4 1) '(1 2 3 4 5) "Bubble: Default test function (<)" :test #'>)
  (run-bubble-sort-test '(3 2 5 4 1) '(5 4 3 2 1) "Bubble: Descending order" :test #'<)
  (run-bubble-sort-test '((2 . 3) (1 . 2) (4 . 5) (3 . 1))
                        '((1 . 2) (2 . 3) (3 . 1) (4 . 5))
                        "Bubble: Custom sorting by car"
                        :key #'car)
  (run-bubble-sort-test '((2 . 3) (1 . 2) (4 . 5) (3 . 1))
                        '((3 . 1) (1 . 2) (2 . 3) (4 . 5))
                        "Bubble: Custom sorting by cdr"
                        :key #'cdr)

   ;; Vector tests
  (run-bubble-sort-test #(9 5 2 4 1) #(1 2 4 5 9) "Bubble: Vector sorting")
  (run-bubble-sort-test #(1 2 3 4 5) #(1 2 3 4 5) "Bubble: Already sorted vector")
  (run-bubble-sort-test #(5 4 3 2 1) #(1 2 3 4 5) "Bubble: Reverse order vector")

  ;; String tests
  (run-bubble-sort-test "bdfac" "abcdf" "Bubble: String sorting in ascending order" :test #'char>)
  (run-bubble-sort-test "bdfac" "fdcba" "Bubble: String sorting in descending order" :test #'char<)

  (format t "Testing completed.~%"))



; 2
(defun duplicate-elements-fn (n &key (duplicate-p #'(lambda (x) t)))
  #'(lambda (x)
      (if (funcall duplicate-p x)
          (mapcar #'(lambda (y) x) (make-list n))
          (list x))))
          

(defun run-duplicate-elements-test (n input expected-result test-description &key (duplicate-p #'(lambda (x) t)))
  "Test function for duplicate-elements-fn."
  (let* ((dup-fn (duplicate-elements-fn n :duplicate-p duplicate-p))
         (result (mapcan dup-fn input)))
    (if (equal result expected-result)
        (format t "~A: successfully.~%" test-description)
        (format t "~A: failed! ~%Expected: ~A~%Got: ~A~%" test-description expected-result result))))

(defun test-duplicate-elements ()
  "Testing duplicate-elements-fn with various cases."
  (format t "~%~%Testing duplicate-elements-fn...~%")
  
  ;; Basic cases
  (run-duplicate-elements-test 2 '(1 2 3) '(1 1 2 2 3 3) "Duplicate all elements (n=2)")
  (run-duplicate-elements-test 3 '(1 2 3) '(1 1 1 2 2 2 3 3 3) "Duplicate all elements (n=3)")
  (run-duplicate-elements-test 1 '(1 2 3) '(1 2 3) "Duplicate all elements (n=1)")
  (run-duplicate-elements-test 2 '() '() "Duplicate in empty list")
  
  ;; Cases with custom duplicate-p
  (run-duplicate-elements-test 2 '(1 2 3 4 5) '(1 2 2 3 4 4 5) 
                               "Duplicate only even elements (n=2)" :duplicate-p #'evenp)
  (run-duplicate-elements-test 3 '(1 2 3 4 5) '(1 2 2 2 3 4 4 4 5) 
                               "Duplicate only even elements (n=3)" :duplicate-p #'evenp)
  (run-duplicate-elements-test 2 '(1 2 3 4 5) '(1 1 2 3 3 4 5 5) 
                               "Duplicate only odd elements (n=2)" :duplicate-p #'oddp)

  ;; Edge case with large n
  (run-duplicate-elements-test 10 '(1 2) 
                               '(1 1 1 1 1 1 1 1 1 1 
                                 2 2 2 2 2 2 2 2 2 2) 
                               "Duplicate all elements (n=10)")

  (format t "Testing completed.~%"))

;;;;;;;;;;;;;;;;;
(defun run-all-tests ()
  (test-sorting-bubble)
  (test-duplicate-elements)
)

;;;;;;;;;;;;;;;;;
(run-all-tests)
