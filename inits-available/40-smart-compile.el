;;; 40-smart-compile.el --- smart-compile  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:10:16
;;; Commentary:

;;; Code :

(global-set-key "\C-cc" 'smart-compile)
(require 'smart-compile)

(define-key menu-bar-tools-menu [compile] '("Compile..." . smart-compile))

;; c言語用の設定
(setq smart-compile-alist
      (append
       '(("\\.c" . "gcc -g -O2 %f -lm -o %n"))))
;;; 40-smart-compile.el ends here
