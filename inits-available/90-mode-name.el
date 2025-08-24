;;; 90-mode-name.el --- mode name
;;; LAST UPDATE : 2024/08/12 01:05:10
;;; Commentary:

;; http://www.masteringemacs.org/article/hiding-replacing-modeline-strings 参考

;;; Code:

(defvar mode-line-cleaner-alist
  `(
    (yas/minor-mode . " Y")
    (undo-tree-mode . " Ut")
    (anzu-mode . "")
    ;; major-mode
    (python-mode . "Py")
    (emacs-lisp-mode . "ELisp")
    (cfw:calendar-mode . "Cal")
    (calendar-mode . "Cal")
    )
  "Alist for `clean-mode-line'.

When you add a new element to the alist, keep in mind that you
must pass the correct minor/major mode symbol and a string you
want to use in the modeline *in lieu of* the original.")

(defun clean-mode-line ()
  "Clean mode line."
  (interactive)
  (cl-loop for cleaner in mode-line-cleaner-alist
    do (let* ((mode (car cleaner))
               (mode-str (cdr cleaner))
               (old-mode-str (cdr (assq mode minor-mode-alist))))
         (when old-mode-str
           (setcar old-mode-str mode-str))
         ;; major mode
         (when (eq mode major-mode)
           (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)
;;; 90-mode-name.el ends here
