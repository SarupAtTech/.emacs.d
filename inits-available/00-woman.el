;;; 00-woman.el --- woman
;;; LAST UPDATE : 2023/08/15 20:44:11
;;; Commentary:

;; http://blog.shibayu36.org/entry/20100503/1272851013
;; http://d.hatena.ne.jp/mooz/20090312/p1
;; ↑参考

;;; Code:

(setq-default woman-cache-filename (expand-file-name (concat user-emacs-directory "private/" "woman_cache.el")))
(setq-default woman-use-own-frame nil)

(setq-default woman-path '("~/local/share/man"
                      "/usr/local/man"
                      "/usr/local/share/man"
                      "/usr/share/man"))
(setq woman-manpath woman-path)
;;; 00-woman.el ends here
