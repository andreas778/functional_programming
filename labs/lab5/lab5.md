<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 5</b><br/>
"Робота з базою даних"<br/>
з дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент</b>: Шандиба Андрій Андрійович група КВ-13</p>
<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання

В роботі необхідно реалізувати утиліти для роботи з базою даних, заданою за варіантом (п. 5.1.1). База даних складається з кількох таблиць. Таблиці представлені у вигляді CSV файлів. При зчитуванні записів з таблиць, кожен запис має бути представлений певним типом в залежності від варіанту: структурою, асоціативним списком або геш-таблицею.
1. Визначити структури або утиліти для створення записів з таблиць (в залежності від типу записів, заданого варіантом).
2. Розробити утиліту(-и) для зчитування таблиць з файлів.
3. Розробити функцію select , яка отримує на вхід шлях до файлу з таблицею, а також якийсь об'єкт, який дасть змогу зчитати записи конкретного типу або структури. Це може бути ключ, список з якоюсь допоміжною інформацією, функція і
т. і. За потреби параметрів може бути кілька. select повертає лямбда-вираз, який, в разі виклику, виконує "вибірку" записів з таблиці, шлях до якої було передано у select . При цьому лямбда-вираз в якості ключових параметрів може
отримати на вхід значення полів записів таблиці, для того щоб обмежити вибірку лише заданими значеннями (виконати фільтрування). Вибірка повертається у вигляді списку записів.
4. Написати утиліту(-и) для запису вибірки (списку записів) у файл.
5. Написати функції для конвертування записів у інший тип (в залежності від варіанту):
- структури у геш-таблиці
- геш-таблиці у асоціативні списки
- асоціативні списки у геш-таблиці
6. Написати функцію(-ї) для "красивого" виводу записів таблиці

## Варіант 9 (21)

База даних - Наукові статті 
Тип записів - Асоціативний список
Таблиці - Спеціальності, Наукові статті
Опис - База даних наукових статей за спеціальностями
   
## Лістинг реалізації завдання

   ```lisp
   (defun split-csv-line (line)
    (let ((result '())
            (buffer "")
            (inside-quote nil))
        (loop for char across line
            do (cond
                ((char= char #\")
                    (setf inside-quote (not inside-quote)))
                ((and (char= char #\,) (not inside-quote))
                    (push (string-trim '(#\Space #\Tab #\Newline #\Return) buffer) result)
                    (setf buffer ""))
                (t
                    (setf buffer (concatenate 'string buffer (string char)))))
            finally
                (push (string-trim '(#\Space #\Tab #\Newline #\Return) buffer) result))
        (nreverse result)))

    ;; Утиліта для зчитування таблиць з файлів
    (defun read-csv (file-path)
    (with-open-file (stream file-path :direction :input)
        (let* ((header (mapcar #'string (split-csv-line (read-line stream))))
            (rows '()))
        (loop for line = (read-line stream nil)
                while line do
                (let ((values (split-csv-line line))
                        (row '()))
                    (when (< (length values) (length header))
                    (setf values (append values (make-list (- (length header) (length values)) :initial-element ""))))
                    (loop for key in header
                        for value in values
                        do (setf row (append row (list (cons key value)))))
                    (setf rows (append rows (list row)))))
        rows)))

    ;; Функція вибору
    (defun select (file-path filter-criteria)
    (let ((records (read-csv file-path)))
        (lambda ()
        (remove-if-not
        (lambda (record)
            (every
            (lambda (filter-pair)
                (equalp (cdr (assoc (car filter-pair) record :test #'equalp))
                    (cdr filter-pair)))
            filter-criteria))
        records))))


    ;; Утиліта для запису вибірки у CSV
    (defun write-csv (file-path records)
    (with-open-file (stream file-path :direction :output :if-exists :supersede)
        (let ((keys (mapcar #'car (first records))))
        (format stream "~{~A~^,~}~%" keys)
        (dolist (record records)
            (format stream "~{~A~^,~}~%" (mapcar (lambda (key) (cdr (assoc key record))) keys))))))


    ;; Конвертація типів
    (defun assoc-to-hash (assoc-list)
    (let ((hash (make-hash-table :test 'equal)))
        (dolist (pair assoc-list hash)
        (setf (gethash (car pair) hash) (cdr pair)))))

    (defun hash-to-assoc (hash-table)
    (loop for key being the hash-keys of hash-table
            collect (cons key (gethash key hash-table))))

    ;; Красивий вивід записів
    (defun pretty-print-records (records)
    (dolist (record records)
        (dolist (pair record)
        (format t "~A: ~A~%" (car pair) (format nil "~A" (cdr pair))))
        (format t "~%")))


```


## Тестові набори та утиліти

   ```lisp
   (defun test-read-csv ()
    (let ((data (read-csv "articles.csv")))
        (format t "Зчитані дані: ~a~%" data)))

    (defun test-select ()
    (let* ((selector (funcall (select "articles.csv" '(("SpecialtyID" . "1"))))))
        (format t "Вибірка для SpecialtyID=1: ~a~%" selector)))

    (defun test-write-csv ()
    (let ((data (read-csv "specialties.csv")))
        (write-csv "test-output.csv" data)
        (format t "Дані записані у файл test-output.csv.~%")))

    (defun test-conversions ()
    (let* ((records (read-csv "specialties.csv"))
            (hash (assoc-to-hash records))
            (assoc (hash-to-assoc hash)))
        (format t "Асоціативний список: ~a~%" records)
        (format t "Геш-таблиця: ~a~%" hash)
        (format t "Конвертовано назад до асоціативного списку: ~a~%" assoc)))

    (defun test-pretty-print ()
    (let ((data (read-csv "articles.csv")))
        (pretty-print-records data)))


    (defun run-all-tests ()
    (test-read-csv)
    (test-select)
    (test-write-csv)
    (test-conversions)
    (test-pretty-print)
    )

    (run-all-tests)
   
  ```

## Вміст тестових файлів №1 (articles.csv)

```
ArticleID,Title,SpecialtyID,Author,Year
1,AI Revolution,1,John Doe,2020
2,Quantum Mechanics,2,Jane Smith,2018
3,Organic Synthesis,3,Alice Brown,2019
4,Genetic Engineering,4,Bob Johnson,2021
5,Number Theory,5,Charlie White,2020
6,Machine Learning,1,Emily Davis,2021
7,Astrophysics,2,Frank Wilson,2019
```

## Вміст тестових файлів №2 (specialties.csv)

```
SpecialtyID,SpecialtyName
1,Computer Science
2,Physics
3,Chemistry
4,Biology
5,Mathematics
```



## Результат виконання тестових наборів

   ```lisp
	Зчитані дані: (((ArticleID . 1) (Title . AI Revolution) (SpecialtyID . 1)
                    (Author . John Doe) (Year . 2020))
                ((ArticleID . 2) (Title . Quantum Mechanics) (SpecialtyID . 2)
                    (Author . Jane Smith) (Year . 2018))
                ((ArticleID . 3) (Title . Organic Synthesis) (SpecialtyID . 3)
                    (Author . Alice Brown) (Year . 2019))
                ((ArticleID . 4) (Title . Genetic Engineering) (SpecialtyID . 4)
                    (Author . Bob Johnson) (Year . 2021))
                ((ArticleID . 5) (Title . Number Theory) (SpecialtyID . 5)
                    (Author . Charlie White) (Year . 2020))
                ((ArticleID . 6) (Title . Machine Learning) (SpecialtyID . 1)
                    (Author . Emily Davis) (Year . 2021))
                ((ArticleID . 7) (Title . Astrophysics) (SpecialtyID . 2)
                    (Author . Frank Wilson) (Year . 2019)))
    Вибірка для SpecialtyID=1: (((ArticleID . 1) (Title . AI Revolution)
                                (SpecialtyID . 1) (Author . John Doe)
                                (Year . 2020))
                                ((ArticleID . 6) (Title . Machine Learning)
                                (SpecialtyID . 1) (Author . Emily Davis)
                                (Year . 2021)))
    Дані записані у файл test-output.csv.
    Асоціативний список: (((SpecialtyID . 1) (SpecialtyName . Computer Science))
                        ((SpecialtyID . 2) (SpecialtyName . Physics))
                        ((SpecialtyID . 3) (SpecialtyName . Chemistry))
                        ((SpecialtyID . 4) (SpecialtyName . Biology))
                        ((SpecialtyID . 5) (SpecialtyName . Mathematics)))
    Геш-таблиця: #<HASH-TABLE :TEST EQUAL :COUNT 5 {2398E659}>
    Конвертовано назад до асоціативного списку: (((SpecialtyID . 1)
                                                (SpecialtyName
                                                . Computer Science))
                                                ((SpecialtyID . 2)
                                                (SpecialtyName . Physics))
                                                ((SpecialtyID . 3)
                                                (SpecialtyName . Chemistry))
                                                ((SpecialtyID . 4)
                                                (SpecialtyName . Biology))
                                                ((SpecialtyID . 5)
                                                (SpecialtyName . Mathematics)))
    ArticleID: 1
    Title: AI Revolution
    SpecialtyID: 1
    Author: John Doe
    Year: 2020

    ArticleID: 2
    Title: Quantum Mechanics
    SpecialtyID: 2
    Author: Jane Smith
    Year: 2018

    ArticleID: 3
    Title: Organic Synthesis
    SpecialtyID: 3
    Author: Alice Brown
    Year: 2019

    ArticleID: 4
    Title: Genetic Engineering
    SpecialtyID: 4
    Author: Bob Johnson
    Year: 2021

    ArticleID: 5
    Title: Number Theory
    SpecialtyID: 5
    Author: Charlie White
    Year: 2020

    ArticleID: 6
    Title: Machine Learning
    SpecialtyID: 1
    Author: Emily Davis
    Year: 2021

    ArticleID: 7
    Title: Astrophysics
    SpecialtyID: 2
    Author: Frank Wilson
    Year: 2019
```

