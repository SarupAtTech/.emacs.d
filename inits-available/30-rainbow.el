;;; 30-rainbor.el --- rainbow
;;; Commentary:
;; LAST UPDATE : 2023/08/16 03:50:16

;;; Code:

(require 'rainbow-mode)
(add-hook 'css-mode-hook 'rainbow-mode)
(add-hook 'web-mode-hook 'rainbow-mode)
(add-hook 'emacs-lisp-mode 'rainbow-mode)
(add-hook 'elisp-mode 'rainbow-mode)
;;; 30-rainbow.el ends here
