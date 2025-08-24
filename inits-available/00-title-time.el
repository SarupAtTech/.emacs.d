;;; 00-title-time.el --- title time
;;; LAST UPDATE : 2023/08/15 18:28:18
;;; Commentary:

;; http://valvallow.blogspot.jp/2011/01/emacs.html 参考
;;; Code:

(when (not (fboundp 'make-variable-frame-local))
  (defun make-variable-frame-local (variable) variable))

(defadvice title-time-set (around title-time-set-around)
  (setq frame-title-format
    (concat "%b" " - " display-time-string)))

(ad-activate 'title-time-set)
(setq display-time-interval 30)

(setq display-time-string-forms
  '((format " [ %s/%02d/%02d (%s) - %s:%s ]"
      year (string-to-number month)(string-to-number day)
      dayname 24-hours minutes)))

(require 'title-time)
(display-time)
;;; 00-title-time.el ends here
