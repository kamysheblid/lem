(defpackage :lem-tests/utilities
  (:use :cl :lem-tests/conditions)
  (:import-from :lem-lisp-syntax)
  (:import-from :lem
                :run-hooks)
  (:export :*before-test-hook*
           :define-test
           :test
           :run-test
           :run-all-tests
           :clear-all-tests))
(in-package :lem-tests/utilities)

(defvar *tests* '())
(defvar *before-test-hook* '())

(defmacro define-test (name &body body)
  `(progn
     (unless (member ',name *tests*)
       (setf *tests* (nconc *tests* (list ',name))))
     (defun ,name () ,@body)))

(defun test (value description)
  (unless value
    (cerror "skip" 'test-error :description description)))

(defun default-test-handler (e)
  (warn "~A" e)
  (invoke-restart 'continue))

(defun run-test (test-fn)
  (handler-bind ((test-error #'default-test-handler))
    (funcall test-fn)))

(defun run-all-tests ()
  (run-hooks *before-test-hook*)
  (let ((success t))
    (handler-bind ((test-error (lambda (e)
                                 (setq success nil)
                                 (default-test-handler e))))
      (dolist (test *tests*)
        (funcall test)))
    success))

(defun clear-all-tests ()
  (dolist (test *tests*)
    (fmakunbound test))
  (setq *tests* '()))
