;;; 40-coding-js2-mode.el --- js2-mode setting  -*- lexical-binding: t; -*-
;;; Commentary:
;;; LAST UPDATE : 2026/10/09 10:25:30

;;; Code:

(add-hook 'js-mode-hook 'js2-minor-mode)

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(add-hook 'js2-mode-hook
  (lambda ()
    ;; (tern-mode t)
    ;; (local-set-key (kbd "-") (smartchr '("-" " - " " => ")))
    ))
;;; 40-coding-js2-mode.el ends here
