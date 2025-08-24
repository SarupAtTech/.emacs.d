;;; 00-docview.el --- doc view
;;; LAST UPDATE : 2023/08/15 18:24:10
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
