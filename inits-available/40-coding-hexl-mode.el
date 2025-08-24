;; LAST UPDATE : 2016/03/31
;; 

;; hexl-mode
(add-hook 'hexl-mode-hook
	  '(lambda()
	     (local-set-key (kbd "M-q") 'delete-window)
	     (local-set-key (kbd "C-t") 'other-window-horizontally)
	     (local-set-key (kbd "M-t") 'other-window-vertically)
	     ))
