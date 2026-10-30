;;; 40-coding-php-mode.el --- setting php mode  -*- lexical-binding: t; -*-
;;; Commentary:
;;; LAST UPDATE : 2026/10/09 10:25:16

;; ref http://blog.fusic.co.jp/archives/94

;;; Code:

(load-library "php-mode")
(require 'php-mode)

;; (autoload 'php-mode "php-mode" "Major mode for editing php code." t)
;; (add-to-list 'auto-mode-alist '("\\.php$" . php-mode))

(add-hook 'php-mode-hook
    #'(lambda()
        (local-set-key (kbd "-") (smartchr '("-" "->" " => ")))
        ))
;;; 40-coding-php-mode.el ends here
