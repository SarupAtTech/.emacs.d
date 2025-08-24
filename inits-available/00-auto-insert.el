;;; 00-auto-insert --- auto-insert
;;; Commentary:
;; LAST UPDATE : 2023/08/15 19:05:09

;;; Code:

(add-hook 'find-file-hook 'auto-insert)
(defvar auto-insert-directory "~/.emacs.d/template/")
(define-auto-insert "\\.c$" "c-template.c")
(define-auto-insert "\\.html$" "html-template.html")
(define-auto-insert "\\.pl$" "perl-template.pl")
(define-auto-insert "\\.py$" "python-template.py")
(define-auto-insert "\\.sh$" "sh-template.sh")
(define-auto-insert "\\.go$" "go-template.go")
(define-auto-insert "\\.el$" "el-template.el")
;;; 00-auto-insert.el ends here
