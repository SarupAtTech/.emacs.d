;;; 30-w3m.el --- w3m
;;; Commentary:
;;; LAST UPDATE : 2025/12/22 16:36:45

;;; Code:
(define-key global-map [(C x)(M f)] 'w3m-find-file)
(require 'w3m-search)

(defvar w3m-default-display-inline-images t)
(defvar w3m-use-cookies t)
(defvar w3m-async-exec t)
(setq-default w3m-profile-directory (concat user-emacs-directory "private/" "w3m"))
(setq-default w3m-search-default-engine "duckduckgo")
(add-to-list 'w3m-search-engine-alist
             '("duckduckgo" "https://duckduckgo.com/?q=%s" nil))

(add-hook 'w3m-mode-hook
    #'(lambda ()
          ;; (linum-mode -1)
          (local-set-key (kbd "\C-t") 'other-window-horizontally)
          (local-set-key (kbd "\M-t") 'other-window-vertically)))
;;; 30-w3m.el ends here
