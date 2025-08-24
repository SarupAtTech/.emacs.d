;; LAST UPDATE : 2016/05/24
;; other-mode.el

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MODE LIST
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; use arduino-mode
;; (load "arduino-mode")
;; (setq auto-mode-alist (cons '("\\.pde$" . arduino-mode) auto-mode-alist))

;; use dummy-h-mode
(add-to-list 'auto-mode-alist '("\\.h$" . dummy-h-mode))
(autoload 'dummy-h-mode "dummy-h-mode" "Dummy H mode" t)

;; use Haskell-mode
(require 'haskell-mode)
(require 'haskell-cabal)
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
;; (add-to-list 'auto-mode-alist '("\\.cabal\\" . haskell-cabal-mode))

;; mode list
;; (add-to-list 'auto-mode-alist '("\\.pde\\'" . java-mode))
(add-to-list 'auto-mode-alist '("\\.ino\\'" . arduino-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
