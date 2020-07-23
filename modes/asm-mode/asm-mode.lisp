(defpackage :lem-asm-mode
  (:use :cl :lem :lem.language-mode)
  (:export :*asm-mode-hook*)
  #+sbcl
  (:lock t))
(in-package :lem-asm-mode)

(defun make-tmlanguage-asm ()
  (let ((patterns (make-tm-patterns
                   (make-tm-region "\"" "\"" :name 'syntax-string-attribute)
                   (make-tm-match "[ \\t]*(;.*)"
                                  :captures (vector nil
                                                    (make-tm-name 'syntax-comment-attribute)))
                   (make-tm-match "^(\\.?[\\S]+):"
                                  :captures (vector nil
                                                    (make-tm-name 'syntax-keyword-attribute)))
                   (make-tm-match "^\\t(\\.?\\S+)[ \\t]*"
                                  :captures (vector nil
                                                    (make-tm-name 'syntax-function-name-attribute)))
                   (make-tm-match "^\\S+" :name 'syntax-function-name-attribute)
                   (make-tm-match "^\\S+" :name 'syntax-function-name-attribute)
                   (make-tm-match "\\$[0-9a-fA-F]+" :name 'syntax-constant-attribute)
                   (make-tm-match "#\\S+" :name 'syntax-constant-attribute)
                   (make-tm-match "=(\\S+)"
                                  :captures (vector nil
                                                    (make-tm-name 'syntax-function-name-attribute))))))
    (make-tmlanguage :patterns patterns)))

(defparameter *asm-syntax-table*
  (let ((table (make-syntax-table
                :space-chars '(#\space #\tab)
                :string-quote-chars '(#\")
                :line-comment-string ";"))
        (tmlanguage (make-tmlanguage-asm)))
    (set-syntax-parser table tmlanguage)
    table))

(define-major-mode asm-mode language-mode
  (:name "asm"
   :keymap *asm-mode-keymap*
   :syntax-table *asm-syntax-table*
   :mode-hook *asm-mode-hook*)
  (setf (variable-value 'enable-syntax-highlight) t
        (variable-value 'indent-tabs-mode) t
        (variable-value 'tab-width) 8
        (variable-value 'line-comment) ";"))

(pushnew (cons "\\.asm" 'asm-mode)
         *auto-mode-alist* :test #'equal)

(pushnew (cons "\\.s" 'asm-mode)
         *auto-mode-alist* :test #'equal)