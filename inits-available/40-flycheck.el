;;; 40-flycheck.el --- flycheck
;;; LAST UPDATE : 2023/08/16 06:17:50
;;; Commentary:

;;; Code:

(add-hook 'after-init-hook #'global-flycheck-mode)
(with-eval-after-load 'flycheck

  (require 'flycheck-posframe)
  (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode)
  (setq-default flycheck-posframe-border-width 1)
  (set-face-foreground 'flycheck-posframe-border-face "#555555")
  )

(define-key global-map [(M p)] 'flycheck-previous-error)
(define-key global-map [(M n)] 'flycheck-next-error)
;;; 40-flycheck.el ends here
