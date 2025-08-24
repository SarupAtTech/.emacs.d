;;; 30-undo-tree --- undo tree
;;; Commentary:
;;; LAST UPDATE : 2023/08/16 03:42:51

;;; http://qiita.com/takc923/items/c3d64b55fc4f3a3b0838 参考
;;; ref https://emacs.stackexchange.com/questions/26993/saving-persistent-undo-to-a-single-directory-alist-format

;;; Code:

(global-undo-tree-mode)
(define-key global-map [(C z)] 'undo-tree-undo)
;; (setq-default undo-tree-history-directory-alist '(("." . (concat user-emacs-directory "private/" "undo-tree"))))
;; (setq-default undo-tree-history-directory-alist (concat user-emacs-directory "private/" "undo-tree"))
(setq-default undo-tree-history-directory-alist '(("." . "~/.emacs.d/private/undo-tree/")))
;;; 30-undo-tree.el ends here
