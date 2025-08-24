;;; 00-linum-mode.el --- linum mode
;;; LAST UPDATE : 2025/06/29 07:27:59
;;; Commentary:

;;; Code:

;; http://d.hatena.ne.jp/kitokitoki/20100714/p1 参考
(defvar my-linum-hook-name '(c-mode-hook c-mode-common-hook emacs-lisp-mode-hook
                              lisp-interaction-mode-hook lisp-mode-hook
                              java-mode-hook python-mode-hook
                              sh-mode-hook perl-mode-hook
                              tex-mode-hook TeX-mode-hook
                              LaTeX-mode-hook latex-mode-hook
                              go-mode-hook web-mode-hook
                              css-mode-hook
                              html-mode-hook
                              fortran-mode-hook
                              js-mode-hook js2-mode-hook
                              hack-mode yaml-mode))
(mapc (lambda (hook-name)
        (add-hook hook-name (lambda () (linum-mode t))))
  my-linum-hook-name)
;;; 00-linum-mode.el ends here
