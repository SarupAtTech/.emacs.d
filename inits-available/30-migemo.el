;;; 30-migemo.el --- migemo
;;; LAST UPDATE : 2023/08/15 18:37:05
;;; Commentary:

;;; Code:

(when (and (executable-find "cmigemo")
           (require 'migemo nil t))
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--emacs"))
  (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (load-library "migemo")
  (migemo-init)
  (set-process-query-on-exit-flag (get-process "migemo") nil)
  (setq skk-isearch-start-mode nil)
  (setq skk-isearch-use-previous-mode nil))
;;; 30-migemo.el ends here
