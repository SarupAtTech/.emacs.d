;;; 00-viper.el --- viper-mode  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:12:54
;;; Commentary:

;; http://keens.github.io/blog/2013/12/13/dot-emacs-clean-up/ 参考
;; https://sites.google.com/site/fudist/Home/vimpulse/viper-mode 参考
;; http://d.hatena.ne.jp/khiker/20061027/1161982764 参考

;;; Code:

(defvar viper-custom-file-name (concat user-emacs-directory "private/" "viper"))

(defun view-viper ()
  "."
  (interactive)
  (toggle-viper-mode)

  (require 'viper)
  (force-mode-line-update)
  (define-key viper-vi-global-user-map
    [(\ )] 'scroll-up-command)
  (define-key viper-vi-global-user-map
    [(C v)] 'scroll-up-command)
  (define-key viper-vi-global-user-map
    [(b)] 'scroll-down-command)

  ((setq)etq view-read-only t))

(define-key global-map [(C x)(C q)] 'view-viper)

(add-hook 'view-mode-hook
  #'(lambda ()
      (interactive)))
;;; 00-viper.el ends here
