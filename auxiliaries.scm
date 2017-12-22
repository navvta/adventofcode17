(define (rotate-list list n)
  "Rotates a list by taking the first n elements and appending them to the rest.
If a negative argument is given the last n elements are prepended to the rest"
  (let* ((l (modulo n (length list)))
	 (front (sublist list 0 l))
	 (back (sublist list l (length list))))
    (append back front)))

(define (digits n)
  (define (help n)
    (if (< n 10) (cons n '())
      (let* ((qr (integer-divide n 10))
	     (q (integer-divide-quotient qr))
	     (r (integer-divide-remainder qr)))
	(cons r (help q)))))
  (reverse (help n)))

(define (divides n x)
  (and (exact? n) (exact? x)
       (= (remainder x n) 0)))

(define (filter p seq)
  (cond ((null? seq) '())
	((p (car seq)) (cons (car seq) (filter p (cdr seq))))
	(else (filter p (cdr seq)))))
	 
(define (enumerate-interval n m)
  (if (>= n m) '()
      (cons n (enumerate-interval (+ n 1) m))))

(define (flatmap proc list)
  (fold-right append '() (map proc list)))

(define (cross-product list1 list2)
  (flatmap (lambda (e1)
	 (map (lambda (e2)
		(cons e1 e2))
	      list2))
	   list1))

(define (cross-product-wo-reflexive list1 list2)
  (remove-step 0 (+ (length list2) 1)
	       (cross-product list1 list2)))

(define (remove-step start step list)
  (cond ((null? list) '())
	((= start 0) (remove-step (- step 1) step (cdr list)))
	(else (cons (car list)
		    (remove-step (- start 1) step (cdr list))))))

(define (find-index x list)
  (define (help n list)
    (cond ((null? list) #f)
	  ((equal? x (car list)) n)
	  (else (help (+ n 1) (cdr list)))))
  (help 0 list))

(define (remove-duplicates list)
  (define (help l result)
    (cond ((null? l) result)
	  ((member (car l) result) (help (cdr l) result))
	  (else (help (cdr l) (cons (car l)
				    result)))))
  (help list '()))

(define (tabulate n f)
  (map f (enumerate-interval 0 n)))

(define (make-circular list)
  (define (help l)
    (if (null? (cdr l))
	(set-cdr! l list)
	(help (cdr l))))
  (help list))

(define (remove list n)
  (if (= 0 n) list (remove (cdr list) (- n 1))))
(define (split list s)
  (cons (take list s) (remove list s)))
(define (split-per list s)
  (if (null? list)
      '()
      (let ((sp (split list s)))
	(cons (car sp) (split-per (cdr sp) s)))))

(define (assert b err)
  (if b #t (error err)))

(define (iter n initial proc)
  (if (<= n 0) initial
      (iter (- n 1) (proc initial) proc)))

;; maybe add general conversion procedure
;; this only works for 0 <= n <= 255 and outputs the byte as a string of two hex numbers
(define (byte->hex n)
  (let ((f (integer-divide n 16)))
    (string-append (char->string (digit->char (car f) 16))
		   (char->string (digit->char (cdr f) 16)))))
