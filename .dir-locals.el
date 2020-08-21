;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((gap-mode
  (eval . (setq gap-executable (getenv "GAP_EXECUTABLE"))))
 (idris-mode
  (idris-interpreter-flags "-p" "contrib")
  (idris-interpreter-path . "idris")))
