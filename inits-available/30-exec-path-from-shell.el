;;; 30-exec-path-from-shell.el --- exec path from shell
;;; LAST UPDATE : 2023/08/15 18:34:59
;;; Commentary:

;;; Code:

(exec-path-from-shell-copy-envs '("GOPATH" "GOROOT"
                                     "PYTHONPATH" "PYTHONSTARTUP"))
(exec-path-from-shell-initialize)
;;; 30-exec-path-from-shell.el ends here
