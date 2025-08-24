;; LAST UPDATE : 2017/04/19
;;
(require 'ctags nil t)
(setq ctags-auto-update-mode nil)

(setq ctags-updai-command "/usr/bin/ctags-exuberant")

;; (setq my-ctags-hook-name '(c-mode-hook c-mode-common-hook emacs-lisp-mode-hook
;;        lisp-interaction-mode-hook lisp-mode-hook
;;        java-mode-hook python-mode-hook
;;        sh-mode-hook perl-mode-hook
;;        tex-mode-hook TeX-mode-hook
;;        LaTeX-mode-hook latex-mode-hook
;;        go-mode-hook web-mode-hook
;;        css-mode-hook
;;        html-mode-hook
;;        fortran-mode-hook
;;        js-mode-hook js2-mode-hook
;;        hack-mode
;;        ))
(setq my-ctags-hook-name '(c-mode-hook
                              c-mode-common-hook perl-mode-hook
                              java-mode-hook python-mode-hook
                              go-mode-hook fortran-mode-hook
                              js-mode-hook js2-mode-hook
                              hack-mode
                              ))

;; (mapc (lambda (hook-name)
;; (add-hook hook-name 'turn-on-ctags-auto-update-mode))
;;       my-ctags-hook-name)
