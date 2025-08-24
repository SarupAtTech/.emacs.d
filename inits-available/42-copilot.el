;;; 42-copilot.el --- useing GitHub Copilot          -*- lexical-binding: t; -*-

;;; Commentary:

;;

;;; Code:

(add-to-list 'load-path "~/.emacs.d/elisp/copilot.el")
(require 'copilot)
;; (add-hook 'prog-mode-hook 'copilot-mode)

(defun auto-complete-accept-copilot-completion ()
    "Use copilot-accept-completion for auto complete."
    (interactive)
    (or (copilot-accept-completion)
        (ac-expand nil)))

(define-key copilot-completion-map [(C x)(c)] 'copilot-accept-completion)
;;; 42-copilot.el ends here
