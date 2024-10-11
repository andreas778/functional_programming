(defun merge-lists-spinning-pairs (list1 list2)
  (cond ((and (null list1) (null list2)) nil)
        ((null list1) (cons (list (car list2)) 
                            (merge-lists-spinning-pairs nil (cdr list2))))
        ((null list2) (cons (list (car list1)) 
                            (merge-lists-spinning-pairs (cdr list1) nil)))
        (t (cons (list (car list1) (car list2))
                 (merge-lists-spinning-pairs (cdr list2) (cdr list1))))))


(defun list-set-intersect-p (set1 set2)
  (cond ((or (null set1) (null set2)) nil)
        ((equal (car set1) (car set2)) t)
        ((null (cdr set2)) (list-set-intersect-p (cdr set1) set2))
        (t (or (list-set-intersect-p (list (car set1)) (cdr set2))
               (list-set-intersect-p (cdr set1) set2)))))


(defun check-result (name function input expected)
  (format t "~:[FAILED~;passed~]... ~a~%" 
          (equal (apply function input) expected) 
          name))


(defun test-merge-lists-spinning-pairs ()
  (check-result "test 1" #'merge-lists-spinning-pairs 
                '((1 2 3 4 5) (a b c d))
                '((1 A) (B 2) (3 C) (D 4) (5)))
  (check-result "test 2" #'merge-lists-spinning-pairs 
                '((1 2) (a b c))
                '((1 A) (B 2) (C)))
  (check-result "test 3" #'merge-lists-spinning-pairs 
                '((1 2 3) (a))
                '((1 A) (2) (3))))


(defun test-list-set-intersect-p ()
  (check-result "test 1" #'list-set-intersect-p 
                '((1 2 3) (4 5 6))
                nil)
  (check-result "test 2" #'list-set-intersect-p 
                '((1 2 3) (3 4 5))
                t)
  (check-result "test 3" #'list-set-intersect-p 
                '((1 2 3) (4 5 1))
                t))


(defun run-all-tests ()
  (format t "Testing merge-lists-spinning-pairs:~%")
  (test-merge-lists-spinning-pairs)
  (format t "~%Testing list-set-intersect-p:~%")
  (test-list-set-intersect-p))
