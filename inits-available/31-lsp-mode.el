;;; 41-lsp-mode.el ---                               -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2025/08/25 06:35:51
;;; Commentary:

;;; Code:

(require 'lsp-mode)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(setq lsp-completion-provider :capf)
(setq lsp-idle-delay 0.500)

(require 'lsp-ui)
(setq lsp-ui-imenu-enable t)
(setq lsp-headerline-breadcrumb-enable t)
(setq lsp-ui-sideline-enable nil)

(add-hook 'vue-mode-hook #'lsp)

;;; 31-lsp-mode.el ends here
