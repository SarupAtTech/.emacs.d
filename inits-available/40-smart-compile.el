;; LAST UPDATE : 2015/05/01
;; smart-compile.el

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; smart-compile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key "\C-cc" 'smart-compile)
(require 'smart-compile)

(define-key menu-bar-tools-menu [compile] '("Compile..." . smart-compile))

;; c言語用の設定
(setq smart-compile-alist
      (append
       '(("\\.c" . "gcc -g -O2 %f -lm -o %n"))))
