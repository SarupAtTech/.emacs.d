;;; 30-undohist.el --- undohist
;;; LAST UPDATE : 2023/08/15 20:25:02
;;; Commentary:

;;; Code:

(require 'undohist)
(setq-default undohist-directory (concat user-emacs-directory "private/" "undohist"))
(setq undohist-ignored-files
  (append '("COMMIT_EDITMSG" "NOTES_EDITMSG" "MERGE_MSG" "TAG_EDITMSG" "/tmp/")
    undohist-ignored-files))
;;; 30-undohist.el ends here
