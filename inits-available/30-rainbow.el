;;; 30-rainbor.el --- rainbow  -*- lexical-binding: t; -*-
;;; Commentary:
;; LAST UPDATE : 2026/10/09 10:14:45

;;; Code:

(require 'rainbow-mode)
(add-hook 'css-mode-hook 'rainbow-mode)
(add-hook 'web-mode-hook 'rainbow-mode)
(add-hook 'emacs-lisp-mode 'rainbow-mode)
(add-hook 'elisp-mode 'rainbow-mode)
;;; 30-rainbow.el ends here
