;;; 40-coding-go-mode.el --- setting go mode
;;; Commentary:
;; LAST UPDATE : 2017/04/30


;; go-mode
;;; Code:
(add-hook 'go-mode-hook
	  '(lambda()
	     (setq c-basic-offset 4)
	     (setq tab-width 4)
	     (setq indent-tabs-mode t)
	     (setq skk-auto-insert-paren t)
	     (subword-mode 1)
	     (local-set-key (kbd "{") (smartchr '( go-indent-braces "{`!!'}" "{")))
	     (local-set-key (kbd "=") (smartchr '("=" " = " " == " " != " " += " " -= ")))
	     (local-set-key (kbd ":") (smartchr '( " := " ":")))
	     (local-set-key (kbd "<") (smartchr '(" < " " <= " " <- " "<")))
	     (local-set-key (kbd ",") (smartchr '(", " ",")))
	     (local-set-key (kbd "[") (smartchr '("[`!!']" "[`!!':]" "[")))
	     (local-set-key  "\C-c\M-a" 'go-remove-unused-imports)
	     (local-set-key (kbd "M-.") 'godef-jump)
	     (add-hook 'before-save-hook 'gofmt-before-save)
	     (go-eldoc-setup)
	     ))

;;; 40-coding-go-mode.el ends here
