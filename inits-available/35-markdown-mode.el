;;; 35-markdown-mode.el --- Summary  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/14 15:42:58
;;; Commentary:

;;; Code:

(with-eval-after-load 'markdown-mode
  (add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
  (setq markdown-command "pandoc -f gfm -t html5 -s"
        markdown-fontify-code-blocks-natively t))

;;; 35-markdown-mode.el ends here
