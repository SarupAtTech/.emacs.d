;;; 40-coding-emacs-lisp-mode.el --- emacs-lisp-mode
;;; LAST UPDATE : 2023/08/15 19:03:29
;;; Commentary:

;;; Code:

(add-hook 'emacs-lisp-mode-hook
    #'(lambda()
          (local-set-key (kbd "\'") (smartchr '("\'" "\'`!!'\'")))
          (local-set-key [(M j)] 'eval-print-last-sexp)))
;;; 40-coding-emacs-lisp-mode.el ends here
