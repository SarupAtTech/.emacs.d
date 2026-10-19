;;; 40-coding-emacs-lisp-mode.el --- emacs-lisp-mode  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:18:12
;;; Commentary:

;;; Code:

(add-hook 'emacs-lisp-mode-hook
    #'(lambda()
          (local-set-key (kbd "\'") (smartchr '("\'" "\'`!!'\'")))
          (local-set-key [(M j)] 'eval-print-last-sexp)))
;;; 40-coding-emacs-lisp-mode.el ends here
