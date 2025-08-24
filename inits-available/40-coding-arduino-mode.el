;; LAST UPDATE : 2016/03/31
;; arduino-mode.el


;; arduino-mode
(add-hook 'arduino-mode-hook
	  '(lambda()
	     (local-set-key (kbd "M-q") 'delete-window)
	     ))
