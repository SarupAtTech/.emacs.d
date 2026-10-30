;; 40-coding-coffeescript-mode.el --- coffeescript-mode  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:17:56
;;; Commentary:

;;; Code:



;; coffeescript-mode
(add-hook 'coffee-mode-hook
	  '(lambda()
	     (set (make-local-variable 'tab-width) 2)
	     (set (make-local-variable 'coffee-tab-width) 2)
	     ))
;;; 40-coding-coffeescript-mode.el ends here
