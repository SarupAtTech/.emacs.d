;;; 00-windows.el --- windows
;;; LAST UPDATE : 2025/06/29 22:37:49
;;; Commentary:

;;; Code:

(require 'windows)
(setq win:use-frame nil)
(define-key global-map "\C-xC" 'see-you-again)
(win:startup-with-window)
;;; 00-windows.el ends here
