;;; 40-coding-c-mode.el --- c-mode
;;; Commentary:
;;; LAST UPDATE : 2023/04/14 17:43:20

;;; Code:
(add-hook 'c-mode-common-hook
    #'(lambda()
          (setq comment-start "// ")
          (setq comment-end "")
          (local-set-key (kbd "M-q") 'delete-window)
          (local-set-key (kbd "(") (smartchr '("(`!!')" "(`!!');" "((`!!'))"  "(")))
          (local-set-key (kbd "{") (smartchr '(indent-braces "{")))
          (local-set-key (kbd "-") (smartchr '("-" "->")))
          (local-set-key (kbd "L") (smartchr '("\\" "L")))
          (local-set-key (kbd ",") (smartchr '(", " ",")))
          ;; (flymake-mode t)
          (set (make-local-variable 'eldoc-idle-delay) 0.20)
          (c-turn-on-eldoc-mode)))
;;; 40-coding-c-mode.el ends here
