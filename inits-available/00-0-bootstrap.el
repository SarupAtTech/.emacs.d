;;; 00-0-bootstrap.el --- bootstrap
;;; LAST UPDATE : 2025/07/03 02:27:33
;;; Commentary:

;;; Code:

(if (fboundp 'labels)
  (defalias 'labels (symbol-function 'cl-labels))
  ())

;; buffer search with i-search
(ido-mode 1)
(setq-default ido-save-directory-list-file (concat user-emacs-directory "private/" "ido.last"))

;; yas/no -> y/n
;; (require 'cl)
(fset 'yes-or-no-p 'y-or-n-p)

;; some color
(set-face-background 'default "#111111")
(set-face-foreground 'default "#00FF00")
(set-background-color "#000000")        ; black
(set-foreground-color "#00FF00")        ; green
(set-cursor-color "#00FF00")            ; green

;; Don't display
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; no upcase and downcase
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; stop cursor
(blink-cursor-mode 0)

;; save cursor potision
(require 'saveplace)
(setq-default save-place t)

;; show time
(display-time-mode t)

;; show line and column
(line-number-mode t)
(column-number-mode t)

;; display function name
(which-function-mode t)

;; hidden some bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(set-scroll-bar-mode nil)

;; suggest keybind
(setq suggest-key-bindings t)

;; (add-to-list 'default-frame-alist '(alpha . (0.75 0.75))) ; emacsの透明度

;; don't make backup file
(setq backup-inhibited t)

;; if quit,remove auto-save
(setq delete-auto-save-files t)

;; auto chmod + x
(add-hook 'after-save-hook
  'executable-make-buffer-file-executable-if-script-p)

;; font
;; rictyを使わない方の設定
;; http://d.hatena.ne.jp/tomoya/20090807/1249641049 参考
;; http://stickydiary.blog88.fc2.com/blog-entry-107.html 参考
;; http://dukeiizu.blogspot.jp/2011/07/emacs-ricty.html 参考
(cond ((>= (display-pixel-width) 1920)
        (set-face-attribute 'default nil
          :family "Inconsolata"
          :height 168))
  ((>= (display-pixel-width) 1330)
    (set-face-attribute 'default nil
      :family "Inconsolata"
      ;; :height 123))
      :height 150))
  (t
    (set-face-attribute 'default nil
      :family "Inconsolata"
      :height 150))
  )

(set-fontset-font (frame-parameter nil 'font)
  'japanese-jisx0208
  (cons "Migu 1M" "iso10646-1"))

;; don't show startup-message
(setq inhibit-startup-message t)

;; init cfw:open-howm-calendar
;; 起動時 に カレンダー を 表示 する
;; (add-hook 'after-init-hook
;;     '(lambda ()
;;          (cfw:open-howm-calendar)
;;          ))

(show-paren-mode 1)
(defvar show-paren-style 'mixed)

;; current row
(when (>= emacs-major-version 21)
  (require 'hl-line)
  (global-hl-line-mode)

  (defvar hl-line-face "")
  (set-face-background hl-line-face "#4B0082") ; indigo
  )

(setq-default show-trailing-whitespace t)
;; http://q.hatena.ne.jp/1243223599 参照
(set-face-background 'trailing-whitespace "#FFFF00")

;; 全角スペース,タブを可視化する.
;; http://yamashita.dyndns.org/blog/emacs-shows-double-space-and-tab 参照
;; http://triplepulu.blogspot.jp/2013/03/emacs_2752.html 参照

(defface zenkaku-space-face '((t (:background "#DC143C"))) nil) ; 全角スペース (orangered)
(defface tab-face '((t (:background "#2E2E2E"))) nil) ; タブ (dimgray)
(defface end-line-space-face '((t (:background "#FFFF00"))) nil) ; 行末空白 (yellow)
(defvar zenkaku-space-face 'zenkaku-space-face)
(defvar tab-face 'tab-face)
(defvar end-line-space-face 'end-line-space-face)

(defadvice font-lock-mode (before my-font-lock-mode ())
  "."
  (font-lock-add-keywords
    major-mode
    '(("\t" 0 tab-face append)
       ("　" 0 zenkaku-space-face append)
       ("[ \t]+$" 0 end-line-space-face append)
       )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;; no beep
(setq visible-bell t)
(setq ring-bell-function 'ignore)


;; http://www.clear-code.com/blog/2012/3/20.html 参考
;; history size
(setq history-length 10000)
;; save minibuffer history
(savehist-mode t)
(setq-default savehist-file (concat user-emacs-directory "private/" "history"))

(setq-default save-place t)


(defvar shell-history-file "~/.zsh.d/zsh_history")


(require 'server)
(unless (server-running-p)
  (server-start)
  )


;; use timestamp
;; ファイル に タイムスタンプ を 付ける
(require 'time-stamp)
(add-hook 'before-save-hook 'time-stamp)
(setq time-stamp-active t)
(setq time-stamp-start "LAST UPDATE : ")
(setq time-stamp-format "%04Y/%02m/%02d %02H:%02M:%02S")
(setq time-stamp-end "$")

;; upcase [(C x)(C u)]
;; リージョン の 選択範囲 を 大文字 に する
(put 'upcase-region 'disabled nil)
;; downcase [(C x)(C l)]
;; リージョン の 選択範囲 を 小文字 に する
(put 'downcase-region 'disabled nil)

(setq undo-limit 80000)
(setq undo-strong-limit 120000)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(add-hook 'doc-view-mode-hook
  #'(lambda()
      (local-set-key (kbd "C-t") 'other-window-horizontally)
      ))

(defvar HOME (expand-file-name "~/"))
(defvar user-emacs-directory (concat HOME ".emacs.d"))

(require 'tramp)
;;; 00-0-bootstrap.el ends here
