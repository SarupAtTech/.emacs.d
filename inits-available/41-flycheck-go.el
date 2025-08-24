;; LAST UPDATE : 2017/04/18
;; flycheck-go

(require 's)

(add-to-list 'load-path "~/gocode/src/github.com/dougm/goflymake")
(require 'go-flycheck)

(add-hook 'go-mode-hook
	  '(lambda ()
	     (flycheck-mode 1)
	     (local-set-key (kbd "M-p") 'flycheck-previous-error)
	     (local-set-key (kbd "M-n") 'flycheck-next-error)
	     ))
