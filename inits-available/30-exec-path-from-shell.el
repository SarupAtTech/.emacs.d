;;; 30-exec-path-from-shell.el --- exec path from shell  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:14:05
;;; Commentary:

;;; Code:

(exec-path-from-shell-copy-envs '("GOPATH" "GOROOT"
                                     "PYTHONPATH" "PYTHONSTARTUP"))
(exec-path-from-shell-initialize)
;;; 30-exec-path-from-shell.el ends here
