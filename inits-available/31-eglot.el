;;; 31-eglot.el --- eglot
;;; LAST UPDATE : 2023/08/16 06:29:23
;;; Commentary:

;;; Code:

(require 'eglot)
;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)

;; (add-to-list 'eglot-stay-out-of 'company)
;; (add-to-list 'eglot-stay-out-of 'flycheck)

(add-hook 'python-mode 'eglot-ensure)
(add-to-list 'eglot-server-programs
  `(python-mode . ("pyright-langserver" "--stdio")))

(add-hook 'php-mode-hook
  #'eglot-ensure)
(add-to-list 'eglot-server-programs
  `(php-mode . ("intelephense" "--stdio")))

(require 'flycheck-eglot)
(global-flycheck-eglot-mode t)
;;; 31-eglot.el ends here
