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
