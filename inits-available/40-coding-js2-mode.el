;;; 40-coding-js2-mode.el --- js2-mode setting
;;; Commentary:
;;; LAST UPDATE : 2025/06/29 23:41:30

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
