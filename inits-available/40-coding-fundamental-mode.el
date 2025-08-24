;;; 40-coding-fundamental-mode.el --- coding style for fundamental-mode
;;; Commentary:
;;; LAST UPDATE : 2023/04/14 16:16:40

;;; Code:
(add-hook 'Fundamental-mode
    #'(lambda()
          (c-set-style "cc-mode")))
(add-hook 'fundamental-mode
    #'(lambda()
          (c-set-style "cc-mode")))
;;; 40-coding-fundamental-mode.el ends here
