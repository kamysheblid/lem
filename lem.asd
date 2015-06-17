(defpackage :lem
  (:use :cl)
  (:export :lem)
  (:shadow :y-or-n-p :read-char))

(defsystem lem
  :serial t
  :components ((:file "wrappers")
	       (:file "key")
	       (:file "globals")
	       (:file "util")
	       (:file "minibuf")
	       (:file "command")
	       (:file "keymap")
	       (:file "kill")
	       (:file "point")
	       (:file "region")
	       (:file "buffer")
	       (:file "buffers")
	       (:file "bufed")
	       (:file "window")
	       (:file "file")
	       (:file "lem"))
  :depends-on (:cl-ncurses :sb-posix))
