;;; 00-windows.el --- windows  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:12:58
;;; Commentary:

;;; Code:

(require 'windows)
(setq win:use-frame nil)
(define-key global-map "\C-xC" 'see-you-again)
(win:startup-with-window)
;;; 00-windows.el ends here
