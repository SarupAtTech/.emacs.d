;;; 40-coding-fundamental-mode.el --- coding style for fundamental-mode  -*- lexical-binding: t; -*-
;;; Commentary:
;;; LAST UPDATE : 2026/10/09 10:18:18

;;; Code:
(add-hook 'Fundamental-mode
    #'(lambda()
          (c-set-style "cc-mode")))
(add-hook 'fundamental-mode
    #'(lambda()
          (c-set-style "cc-mode")))
;;; 40-coding-fundamental-mode.el ends here
