;;; 40-coding-python-mode.el --- setting python mode  -*- lexical-binding: t; -*-
;;; Commentary:
;;; LAST UPDATE : 2026/10/09 10:23:54

;;; Code:

;; (setenv "PYTHONPATH" "/usr/lib/python3/dist-packages")
(add-hook 'python-mode-hook 'blacken-mode)

(setq-default py-isort-options '("-ls"))

(add-hook 'python-mode-hook
  #'(lambda()
      (add-hook 'before-save-hook 'py-isort-before-save)
      (eglot-ensure)
      ))
;;; 40-coding-python-mode.el ends here
