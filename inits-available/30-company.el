;;; 30-company.el --- company  -*- lexical-binding: t; -*-
;; LAST UPDATE : 2026/10/09 10:13:52
;;; Commentary:

;;; Code:

(require 'company)
(global-company-mode)

(with-eval-after-load 'company
  (define-key company-active-map [(M n)] nil)
  (define-key company-active-map [(M p)] nil)
  (define-key company-active-map [(C n)] #'company-select-next)
  (define-key company-active-map [(C p)] #'company-select-previous)
  (define-key company-active-map [(C h)] #'delete-backward-char))

(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)
(setq company-selection-wrap-around t)
(setq company-dabbrev-ignore-case t)
(setq company-dabbrev-downcase nil)
;;; 30-company.el ends here
