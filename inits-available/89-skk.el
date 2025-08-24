;;; 89-skk.el --- SKK
;;; LAST UPDATE : 2023/08/16 03:54:58
;;; Commentary:

;;; Code:

(defun japanese-input-on ()
  (interactive)
  (skk-mode 1))

(defun japanese-input-off ()
  (interactive)
  (skk-mode-off))

(add-hook 'skk-load-hook
    (lambda ()
        ;; コード中では自動的に英字にする。
        (require 'context-skk)

        ;; 半角で入力したい文字
        (defvar skk-rom-kana-rule-list
            (nconc skk-rom-kana-rule-list
                '((";" nil nil)
                     (":" nil nil)
                     ("?" nil nil)
                     ("!" nil nil)
                     ;; ("," nil nil)
                     ;; ("." nil nil)
                     ("\"" nil nil))))))

(setq-default skk-kutouten-type 'jp)

(defvar skk-jisyo-code 'utf-8)
(defvar skk-large-jisyo "~/local/share/skk/SKK-JISYO.L")
(defvar skk-auto-insert-paren t)
(defvar skk-sticky-key ";")
(setq skk-preload t)
(define-key global-map [(C x)(C j)] 'skk-mode)

;; インライン候補表示
(defvar skk-show-inline 'vertical)
;; アノテーション表示
(defvar skk-show-annotation t)

;; (require 'facemenu)
(defvar skk-use-color-cursor t)
(when skk-use-color-cursor
  (defvar skk-cursor-hiragana-color       "#FF00FF")
  (defvar skk-cursor-katakana-color       "#FFFF00")
  (defvar skk-cursor-abbrev-color         "#FF0000")
  (defvar skk-cursor-jisx0208-latin-color "#FF0000")
  (defvar skk-cursor-jisx201-color        "#8B52A1")
  (defvar skk-cursor-latin-color          "#00FF00")
  )


;; skkの自動起動
;; lisp-interaction-mode
(add-hook 'lisp-interaction-mode-hook
    #'(lambda ()
         (progn
             ;; (eval-expression (auto-complete-mode) nil)
             (eval-expression (skk-mode) nil))))


;; find-fileでskk-modeになる
(add-hook 'find-file-hook
    #'(lambda ()
         (progn
             ;; (eval-expression (auto-complete-mode) nil)
             (eval-expression (skk-mode) nil)
             ;; ミニバッファ上に「nil」と表示させないために、空文字をミニバッファに表示
             (minibuffer-message ""))))


;; ミニバッファ上でもskk-modeにする
;; skk-latin-modeでアルファベット入力にしておく
(add-hook 'minibuffer-setup-hook
    #'(lambda ()
          (progn
              (eval-expression (skk-mode) nil)
              (skk-latin-mode (point))
              ;; ミニバッファ上に「nil」と表示させないために、空文字をミニバッファに表示
              (minibuffer-message ""))))
;;; 89-skk.el ends here
