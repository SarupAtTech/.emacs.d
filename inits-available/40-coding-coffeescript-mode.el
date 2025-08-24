;; LAST UPDATE : 2016/03/31
;; coffeescript-mode.el


;; coffeescript-mode
(add-hook 'coffee-mode-hook
	  '(lambda()
	     (set (make-local-variable 'tab-width) 2)
	     (set (make-local-variable 'coffee-tab-width) 2)
	     ))
