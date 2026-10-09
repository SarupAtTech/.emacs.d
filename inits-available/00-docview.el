;;; 00-docview.el --- doc view  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:08:42
;;; Commentary:

;; http://d.hatena.ne.jp/kitokitoki/20101123/p2
;;; Code:

(add-hook 'view-mode-hook
    (lambda ()
        (when (eql major-mode 'doc-view-mode)
            (define-key view-mode-map "n" nil)
            (define-key view-mode-map "p" nil)
            (define-key view-mode-map "\ " nil)
            (define-key view-mode-map [(C v)] nil)
            (define-key view-mode-map "b" nil)
            )))
;;; 00-docview.el ends here
