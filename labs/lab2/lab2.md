<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 2</b><br/>
"Рекурсія"<br/>
дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент</b>: Шандиба Андрій Андрійович група КВ-13</p>
<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання

Реалізувати дві рекурсивні функції, що виконують деякі дії з вхідним(и) списком(-ами), за можливості/необхідності використовуючи різні види рекурсії.

## Варіант 6

1. Написати функцію `merge-lists-spinning-pairs`, яка групує відповідні елементи двох списків, почергово змінюючи їх взаємне розташування в групі:
   ```lisp
   CL-USER> (merge-lists-spinning-pairs '(1 2 3 4 5) '(a b c d))
   ((1 A) (B 2) (3 C) (D 4) (5))
   
2. Написати предикат list-set-intersect-p, який визначає чи перетинаються дві множини, задані списками атомів, чи ні:
   ```lisp
   CL-USER> (list-set-intersect-p '(1 2 3) '(4 5 6))
   NIL
   CL-USER> (list-set-intersect-p '(1 2 3) '(3 4 5))
   T
   
## Лістинг реалізованих завдань

1. Лістинг функції merge-lists-spinning-pairs:
   ```lisp
   (defun merge-lists-spinning-pairs (list1 list2)
	  (cond ((and (null list1) (null list2)) nil)
			((null list1) (cons (list (car list2)) 
								(merge-lists-spinning-pairs nil (cdr list2))))
			((null list2) (cons (list (car list1)) 
								(merge-lists-spinning-pairs (cdr list1) nil)))
			(t (cons (list (car list1) (car list2))
					 (merge-lists-spinning-pairs (cdr list2) (cdr list1))))))
					 
2. Лістинг функції list-set-intersect-p:
   ```lisp
   (defun list-set-intersect-p (set1 set2)
	  (cond ((or (null set1) (null set2)) nil)
			((equal (car set1) (car set2)) t)
			((null (cdr set2)) (list-set-intersect-p (cdr set1) set2))
			(t (or (list-set-intersect-p (list (car set1)) (cdr set2))
				   (list-set-intersect-p (cdr set1) set2)))))

## Лістинг реалізації тестових наборів

   ```lisp
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

## Результат виконання тестових наборів

   ```lisp
	Testing merge-lists-spinning-pairs:
	passed... test 1
	passed... test 2
	passed... test 3

	Testing list-set-intersect-p:
	passed... test 1
	passed... test 2
	passed... test 3
	NIL


