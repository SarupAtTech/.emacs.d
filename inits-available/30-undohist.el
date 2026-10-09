;;; 30-undohist.el --- undohist  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:14:57
;;; Commentary:

;;; Code:

(require 'undohist)
(setq-default undohist-directory (concat user-emacs-directory "private/" "undohist"))
(setq undohist-ignored-files
  (append '("COMMIT_EDITMSG" "NOTES_EDITMSG" "MERGE_MSG" "TAG_EDITMSG" "/tmp/")
    undohist-ignored-files))
;;; 30-undohist.el ends here
