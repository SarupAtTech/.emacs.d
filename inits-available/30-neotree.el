;;; 30-neotree.el --- neo tree  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:14:23
;;; Commentary:

;;; Code:

(require 'neotree)

;; http://kiririmode.hatenablog.jp/entry/20150806/1438786800 参考

(define-key global-map (kbd "C-x n t") 'neotree-toggle)

(setq neo-show-hidden-files t)
(setq neo-persst-show t)
;;; 30-neotree.el ends here
