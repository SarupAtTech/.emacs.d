;;; 00-dired.el --- dired
;;; LAST UPDATE : 2023/08/15 18:23:56
;;; Commentary:


;; http://qiita.com/l3msh0@github/items/8665122e01f6f5ef502f 参考
;;; Code:

(defvar dired-dwim-target t)
(setq dired-listing-switches (purecopy "-Ahl"))

;; put r inline edit to filename
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; http://qiita.com/l3msh0/items/8665122e01f6f5ef502f 参考
;; diredバッファでファイル名のみを検索対象とする
(defvar dired-isearch-filenames t)

;; http://nishikawasasaki.hatenablog.com/entry/20120222/1329932699 参考
(put 'dired-find-alterjnate-file 'disabled nil)

;; ファイルなら別バッファで, ディレクトリなら同じバッファで開く
(defun dired-open-in-accordance-with-situation()
  "Select buffer."
  (interactive)
  (let ((file (dired-get-filename)))
    (if (file-directory-p file)
      (dired-find-alternate-file)
      (dired-find-file))))

;; RET 標準の dired-find-file では dired バッファが複数作られるので,
;; dired-open-in-accordance-with-situation を代わりに使う
(define-key dired-mode-map (kbd "RET") 'dired-open-in-accordance-with-situation)
(define-key dired-mode-map (kbd "a") 'dired-find-file)
(define-key dired-mode-map (kbd "b") 'dired-up-directory)


;; dired-load
;; http://d.hatena.ne.jp/kakurasan/20070702/p1 参考
(add-hook 'with-eval-after-load
  #'(lambda ()
      (setq dired-recursive-copies 'always) ; ディレクトリの再帰的コピー
      (setq dired-listing-switches "-FlhA")))
(add-hook 'dired-mode-hook
  #'(lambda ()
      (local-set-key (kbd "C-t") 'other-window-horizontally)
      (local-set-key (kbd "M-t") 'other-window-vertically)))

(defvar dired-bind-jump nil)
;;; 00-dired.el ends here
