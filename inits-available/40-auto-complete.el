;;; 40-auto-complete.el --- auto complete
;;; LAST UPDATE : 2023/08/15 20:27:49
;;; Commentary:

;;; Code:

(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(define-key ac-completing-map [(M n)] 'ac-next)
(define-key ac-completing-map [(M p)] 'ac-previous)

(setq ac-dictionary-directories (concat user-emacs-directory "ac-dict/"))
;; (add-to-list 'ac-user-dictionary "~/.emacs.d/private/ac-dict")
(ac-config-default)
(setq ac-auto-start 3)
(setq ac-use-menu-map t)
(define-key ac-menu-map [(C n)] 'ac-next)
(define-key ac-menu-map [(C p)] 'ac-previous)
(setq ac-auto-show-menu 0.0)
(define-key ac-completing-map "\M-/" 'ac-stop)
;; (setq ac-ignore-case 'smart)
(setq ac-ignore-case 't)
(ac-set-trigger-key "TAB")
;; (ac-set-trigger-key "<tab>")
(setq ac-use-fuzzy t)
(setq popup-use-optimized-column-computation nil)

(setq ac-source-yasnippet nil)

;; ac-modes を 利用する モード の 追加
;; (add-to-list 'ac-modes 'arduino-mode)
;; (add-to-list 'ac-modes 'conf-mode)
;; (add-to-list 'ac-modes 'html-mode)
;; (add-to-list 'ac-modes 'fundamental-mode)
;; (add-to-list 'ac-modes 'Fundemental-mode)
;; (add-to-list 'ac-modes 'latex-mode)
;; (add-to-list 'ac-modes 'LaTeX-mode)
;; (add-to-list 'ac-modes 'howm-mode)
;; (add-to-list 'ac-modes 'text-mode)
;; (add-to-list 'ac-modes 'haskell-mode)
(add-to-list 'ac-modes 'sql-interactive-mode)

(defun load-auto-complete-dictionary (file)
    "FILE."
    (let (dict)
        (with-temp-buffer (insert-file-contents file)
            (goto-char (point-min))
            (while (not (eobp))
                (push (buffer-substring (line-beginning-position)
                          (line-end-position))
                    dict)
                (forward-line 1)))
        (nreverse dict)))

(add-hook 'auto-complete-mode-hook
    #'(lambda()
          (make-variable-buffer-local 'smartchr)
          (setq smartchr t)
          (yas-minor-mode t)
          (add-to-list 'ac-sources 'ac-source-filename)))

;;; 40-auto-complete.el ends here
