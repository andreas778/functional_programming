<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 3</b><br/>
"Функціональний і імперативний підходи до роботи зі списками"<br/>
з дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент</b>: Шандиба Андрій Андрійович група КВ-13</p>
<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання

Реалізуйте алгоритм сортування чисел у списку двома способами: функціонально і
імперативно.

## Варіант 5

Алгоритм сортування обміном №2 (із використанням прапорця) за незменшенням.
   
## Лістинг реалізованих завдань

1. Лістинг функціонального варіанту:
   ```lisp
	(defun one-pass (lst)
	  (if (null (cdr lst))
	      lst
	      (let ((current-list 
	             (if (> (car lst) (cadr lst))
	                 (cons (cadr lst)
	                      (bubble-sort-functional (cons (car lst) (cddr lst))))
	                 (cons (car lst)
	                       (bubble-sort-functional (cdr lst))))))
	        (if (equal current-list lst)
	            (values current-list nil)
	            (values current-list t)))))
	
	(defun bubble-sort-functional (lst &optional (flag t))
	  (if flag
	      (multiple-value-bind (new-list new-flag) (one-pass lst)
	        (bubble-sort-functional new-list new-flag))
	      lst))

					 
2. Лістинг імперативного варіанту:
   ```lisp
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


## Лістинг реалізації тестових наборів

   ```lisp
   (defun run-tests ()
    (format t "~%Functional:~%")
    (let ((test-cases '((5 3 8 4 2)          
                        ()                    
                        (1)                  
                        (1 2 3 4 5)           
                        (5 4 3 2 1)           
                        (2 2 2 2 2))))       
        
        (dolist (test test-cases)
        (format t "Input: ~A~%" test)
        (format t "Result: ~A~%~%" (bubble-sort-functional test))))
    
    (format t "~%Imperative:~%")
    (let ((test-cases '((5 3 8 4 2)
                        ()
                        (1)
                        (1 2 3 4 5)
                        (5 4 3 2 1)
                        (2 2 2 2 2))))
        
        (dolist (test test-cases)
        (format t "Input: ~A~%" test)
        (format t "Result: ~A~%~%" (bubble-sort-imperative test)))))
```

## Результат виконання тестових наборів

   ```lisp
	Functional:
    Input: (5 3 8 4 2)
    Result: (2 3 4 5 8)

    Input: NIL
    Result: NIL

    Input: (1)
    Result: (1)

    Input: (1 2 3 4 5)
    Result: (1 2 3 4 5)

    Input: (5 4 3 2 1)
    Result: (1 2 3 4 5)

    Input: (2 2 2 2 2)
    Result: (2 2 2 2 2)


    Imperative:
    Input: (5 3 8 4 2)
    Result: (2 3 4 5 8)

    Input: NIL
    Result: NIL

    Input: (1)
    Result: (1)

    Input: (1 2 3 4 5)
    Result: (1 2 3 4 5)

    Input: (5 4 3 2 1)
    Result: (1 2 3 4 5)

    Input: (2 2 2 2 2)
    Result: (2 2 2 2 2)


