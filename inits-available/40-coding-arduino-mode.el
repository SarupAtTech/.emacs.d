;;; 40-coding-arduino-mode.el --- arduino-mode  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:16:55
;;; Commentary:

;;; Code:

(add-hook 'arduino-mode-hook
  '(lambda()
     (local-set-key (kbd "M-q") 'delete-window)
     ))
;;; 40-coding-arduino-mode.el ends here
