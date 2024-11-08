; Функціональний варіант
 (defun bubble-sort-functional (lst &optional (flag nil))
   (if (null (cdr lst))
       lst
       (let ((current-list 
              (if (> (car lst) (cadr lst))
                  (progn
                    (setf flag t)
                    (cons (cadr lst) (bubble-sort-functional (cons (car lst) (cddr lst)) t)))
                  (cons (car lst) (bubble-sort-functional (cdr lst) flag)))))
         (if flag
             (bubble-sort-functional current-list)
             current-list))))


; Імперативний варіант
(defun bubble-sort-imperative (lst)
  (let ((arr (copy-list lst))
        (r (- (length lst) 1))
        (flag 1))
    
    (loop while (= flag 1) do
          (setf flag 0)
          (dotimes (i r)
                (when (> (nth i arr) (nth (+ i 1) arr))
                  (let ((tmp (nth i arr)))
                    (setf (nth i arr) (nth (+ i 1) arr))
                    (setf (nth (+ i 1) arr) tmp)
                    (setf flag 1))))
          (setf r (1- r)))
    arr))

; Тести
(defun run-tests ()
  (format t "~%Functional:~%")
  (let ((test-cases '((6 2 9 3 1)          
                      ()                    
                      (1)                  
                      (1 2 3 4 5)           
                      (5 4 3 2 1)           
                      (1 1 1 1 1))))       
    
    (dolist (test test-cases)
      (format t "Input: ~A~%" test)
      (format t "Result: ~A~%~%" (bubble-sort-functional test))))
  
  (format t "~%Imperative:~%")
  (let ((test-cases '((6 2 9 3 1)
                      ()
                      (1)
                      (1 2 3 4 5)
                      (5 4 3 2 1)
                      (1 1 1 1 1))))
    
    (dolist (test test-cases)
      (format t "Input: ~A~%" test)
      (format t "Result: ~A~%~%" (bubble-sort-imperative test)))))

;;;;;;;;
(run-tests)
