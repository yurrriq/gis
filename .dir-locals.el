;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((gap-mode
  (gap-executable . "gap"))
 (idris-mode
  (eval
   let ((project-dir
         (concat (getenv "HOME") "/src/github.com/yurrriq/gis")))
   (setq idris-interpreter-flags
         (list "-i" (concat project-dir "/src")
               "-i" (concat project-dir "/test")
               "-p" "contrib"
               "-p" "specdris")))
  (idris-interpreter-path . "idris")))
