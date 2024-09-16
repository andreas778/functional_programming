<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>

<p align="center">
<b>Звіт з лабораторної роботи 1</b><br/>
"Обробка списків з використанням базових функцій"<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right">**Студент**: Шандиба Андрій Андрійович<p>
<p align="right">**Рік**: 2024<p>

## Загальне завдання

```lisp
;; Пункт 1: Створення списку
(setq my-list (cons 'a (cons 1 (cons (list 'b 2) (cons nil (list '(c 3)))))))

;; Пункт 2: Отримання голови списку
(car my-list)
; A

;; Пункт 3: Отримання хвоста списку
(cdr my-list)
; (1 (B 2) NIL (C 3))

;; Пункт 4: Отримання третього елементу списку
(third my-list)
; (B 2)

;; Пункт 5: Отримання останнього елементу списку
(car (last my-list))
; (C 3)

;; Пункт 6: Використання предикатів ATOM та LISTP
(atom (car my-list))  ; T
(atom (caddr my-list))  ; NIL
(listp (car my-list))  ; NIL
(listp (caddr my-list))  ; T

;; Пункт 7: Використання інших предикатів
(numberp (cadr my-list))  ; T
(symbolp (car my-list))  ; T
(null (cadddr my-list))  ; T

;; Пункт 8: Об'єднання списку з його непустим підсписком
(append my-list (caddr my-list))
; (A 1 (B 2) NIL (C 3) B 2)
```

## Варіант 5

<p align="center">
<img src="lab1.png">
</p>

```lisp
;; Створення допоміжної змінної для підсписку
(setq sublist '(4 E 5))

;; Створення основного списку
(setq main-list 
  (list 'D 
        (cons (car sublist) 
              (cons (cadr sublist) 
                    (list (caddr sublist))))
        'F))

;; Перевірка структури
(print main-list)
; (D (4 E 5) F)

(print (second main-list))
; (4 E 5)

(print (cadadr main-list))
; E
```

