;; LAST UPDATE : 2023/08/14 04:47:58
;; yasnippet.el

(require 'yasnippet)

;; yas-snippet-dirsを自分で設定したもののみにする
;; (setq yas-snippet-dirs
;;       "~/.emacs.d/snippets")

(yas-global-mode 1)

;; 単語展開キーバインド
(custom-set-variables '(yas-trigger-key "TAB"))
(custom-set-variables '(yas-trigger-key "I"))

;; 既存スニペットを挿入する
(define-key yas-minor-mode-map (kbd "C-x y i") 'yas-insert-snippet)
;; 新規スニペットを作成するバッファを用意する
(define-key yas-minor-mode-map (kbd "C-x y n") 'yas-new-snippet)
;; 既存スニペットを閲覧・編集する
;; (define-key yas-minor-mode-map (kbd "C-x y e") 'yas-visit-snippet-file)
(define-key yas-minor-mode-map (kbd "C-x y e") 'yas-describe-tables)

(setq yas/ignore-filenames-as-triggers t)
(setq yas/prompt-functions '(yas/dropdown-prompt))

