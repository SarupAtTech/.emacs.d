;;; 30-aspell.el --- aspell
;;; LAST UPDATE : 2023/08/15 18:31:46
;;; Commentary:

;;; Code:

(require 'flyspell)
;; http://keisanbutsuriya.hateblo.jp/entry/2015/02/10/152543 参考

(setq-default ispell-program-name "aspell")
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

(define-key flyspell-mode-map (kbd "C-;") #'flyspell-popup-correct)
(add-hook 'flyspell-mode-hook #'flyspell-popup-auto-correct-mode)


;; flyspell-mode
(add-hook 'flyspell-mode-hook
  '(lambda ()
     (local-set-key (kbd "C-;") 'flyspell-popup-correct)
     ))

(mapc
 (lambda (hook)
   (add-hook hook 'flyspell-prog-mode))
 '(
   ;; ここに書いたモードではコメント領域のところだけ
   ;; flyspell-mode が有効になる
   c-mode-common-hook
   go-mode-hook
   emacs-lisp-mode-hook
   python-mode-hook
   php-mode-hook
   ))

(mapc
 (lambda (hook)
   (add-hook hook
     '(lambda () (flyspell-mode 1))))
 '(
   ;; ここに書いたモードでは
   ;; flyspell-mode が常に有効になる
   tex-mode-hook
   TeX-mode-hook
   japanese-latex-mode-hook
   org-mode-hook
   text-mode-hook
   ))
;;; 30-aspell.el ends here
