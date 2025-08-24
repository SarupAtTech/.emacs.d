;;; 30-twittering-mode.el --- twittering mode
;;; LAST UPDATE : 2023/08/15 20:45:50
;;; Commentary:

;;; Code:

;; twittering-mode の 読み込み
(require 'twittering-mode)

;; 認証済み access token を GnuPG で 暗号化 して 保存
(setq twittering-use-master-password t)
(setq twittering-use-ssl t)
(setq twittering-private-info-file "~/.emacs.d/private/twitter/twittering-mode.gpg")

;; アイコン の 表示
(setq twittering-icon-mode t)
;; アイコン の 画像 を 残す
(setq twittering-use-icon-storage t)
(setq twittering-icon-storage-file "~/.emacs.d/private/twitter/twittering-mode-icons.gz")

;; browse html via w3m (new tab)
(defun my-w3m-goto-url-new-session ()
    (interactive)
    (let ((uri (get-text-property (point) 'uri)))
        (if uri
            (w3m-goto-url-new-session uri))))
(define-key twittering-mode-map (kbd "H")
    'my-w3m-goto-url-new-session)

;; 新しいツイートの表示
(add-hook 'twittering-new-tweets-hook
    (lambda ()
        (let ((n twittering-new-tweets-count))
            (start-process "twittering-notify" nil "notify-send"
                "-i" (concat HOME ".emacs.d/private/twitter/logo.png")
                "New tweets"
                (format "You have %d new tweet%s"
                    n (if (> n 1) "s" ""))))))


;; twittering-mode
(add-hook 'twittering-mode-hook
    '(lambda ()
         (local-set-key (kbd "F") 'twittering-favorite)
         ))
;;; 30-twittering-mode.el ends here
