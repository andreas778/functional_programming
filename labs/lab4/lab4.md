<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 4</b><br/>
"Функції вищого порядку та замикання"<br/>
з дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент</b>: Шандиба Андрій Андрійович група КВ-13</p>
<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання

Завдання складається з двох частин:

1. Переписати функціональну реалізацію алгоритму сортування з лабораторної роботи 3 з такими змінами:
використати функції вищого порядку для роботи з послідовностями (де це доречно);
додати до інтерфейсу функції (та використання в реалізації) два ключових параметра: key та test , що працюють аналогічно до того, як працюють параметри з такими назвами в функціях, що працюють з послідовностями. При цьому key має виконатись мінімальну кількість разів.
2. Реалізувати функцію, що створює замикання, яке працює згідно із завданням за варіантом (див. п 4.1.2). Використання псевдо-функцій не забороняється, але, за можливості, має бути мінімізоване.

## Варіант 5 першої частини

Алгоритм сортування обміном №2 (із використанням прапорця) за незменшенням.
   
## Лістинг реалізації першої частини завдання

   ```lisp
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
```


## Лістинг реалізації тестових наборів першої частини

   ```lisp
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
  ```

## Результат виконання тестових наборів першої частини

   ```lisp
	Testing bubble sort...
    Bubble: Standard list: successfully.
    Bubble: Already sorted list: successfully.
    Bubble: Reverse order list: successfully.
    Bubble: Empty list: successfully.
    Bubble: Single element list: successfully.
    Bubble: List with duplicates: successfully.
    Bubble: Sorting with key as abs: successfully.
    Bubble: Sorting with key as abs in descending order: successfully.
    Bubble: Default test function (<): successfully.
    Bubble: Descending order: successfully.
    Bubble: Custom sorting by car: successfully.
    Bubble: Custom sorting by cdr: successfully.
    Bubble: Vector sorting: successfully.
    Bubble: Already sorted vector: successfully.
    Bubble: Reverse order vector: successfully.
    Bubble: String sorting in ascending order: successfully.
    Bubble: String sorting in descending order: successfully.
    Testing completed.
```

## Варіант 9 другої частини

Написати функцію duplicate-elements-fn , яка має один основний параметр n та
один ключовий параметр — функцію duplicate-p . duplicate-elements-fn має
повернути функцію, яка при застосуванні в якості першого аргументу mapcan робить
наступне: кожен елемент списка-аргумента mapcan , для якого функція duplicate-p
повертає значення t (або не nil ), дублюється n разів. Якщо користувач не передав
функцію duplicate-p у duplicate-elements-fn , тоді дублюються всі елементи вхідного
списку.
   
## Лістинг реалізації другої частини завдання

   ```lisp
   (defun duplicate-elements-fn (n &key (duplicate-p #'(lambda (x) t)))
    #'(lambda (x)
        (if (funcall duplicate-p x)
            (mapcar #'(lambda (y) x) (make-list n))
            (list x))))
```


## Лістинг реалізації тестових наборів другої частини

   ```lisp
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
  ```

## Результат виконання тестових наборів другої частини

   ```lisp
	Testing duplicate-elements-fn...
    Duplicate all elements (n=2): successfully.
    Duplicate all elements (n=3): successfully.
    Duplicate all elements (n=1): successfully.
    Duplicate in empty list: successfully.
    Duplicate only even elements (n=2): successfully.
    Duplicate only even elements (n=3): successfully.
    Duplicate only odd elements (n=2): successfully.
    Duplicate all elements (n=10): successfully.
    Testing completed.

