;;; 31-mew.el --- mew
;;; LAST UPDATE : 2025/07/04 01:38:45
;;; Commentary:

;; http://www.mew.org/ja/inforelease/mew_1.html 参考

;;; Code:

(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

;; Optional setup (Read Mail menu):
(setq read-mail-command 'mew)

;; Optional setup(e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
  (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
  (define-mail-user-agent
    'mew-user-agent
    'mew-user-agent-compose
    'mew-draft-send-message
    'mew-draft-kill
    'mew-send-hook))

(setq mew-imap-size 0)

;; http://suzuki.tdiary.net/20140813.html#c04 参考
;; (when (and (fboundp 'shr-render-region)
;;            ;; \\[shr-render-region] requires Emacs to be compiled with libxml2.
;;            (fboundp 'libxml-parse-html-region))
;;   (setq mew-prog-text/html 'shr-render-region)) ;; 'mew-mime-text/html-w3m

;; http://qwik.jp/takotlog/MeadowMewHTMLMail.html 参考
;; (require 'mew-w3m)

(setq mew-mime-multipart-alternative-list
  '("Text/Html" "Text/Plain" "*."))

(setq mew-w3m-auto-insert-image t)
;; (define-key mew-summary-mode-map "T" 'mew-w3m-view-inline-image)

(setq mew-use-text/html t)
(setq mew-use-text/xml t)

(add-hook 'mew-message-mode-hook
  '(lambda()
     (setq-default show-trailing-whitespace nil)
     ))

(setq mew-prog-ssl "/usr/bin/stunnel")
;; パスワードをメモリに一時的に蓄える. ファイルには書き出さない.
(setq mew-use-cached-passwd t)
;; パスワードをメモリに Mew が起動している間中蓄える. Mew/Emacs の終了時に,
;; パスワードを暗号化しファイルに書き出す.
;; (setq mew-use-master-passwd t)

;; http://www.sie.ics.saitama-u.ac.jp/install/c-sig.html 参考

;; mew でシグネチャを対話的に選択する設定
(add-hook 'mew-draft-mode-hook
  (function (lambda ()
              (define-key mew-draft-mode-map "\C-c\C-i" 'insert-signature-eref))))

;; http://www.cozmixng.org/~kou/emacs/mew 参考
;; 自動でメール確認
(setq mew-use-biff t)
;; メールをチェックする間隔(分)
(setq mew-biff-interval 2)

;; メールのチェックにより, Windows8.1 がスリープしてなさそう
;; ある特定の時間(使ってない時間が15分くらい)が来たら着信確認を止める.
;; もしかして普通に run-with-idle-timer だけでよさげな気がする
;; (run-with-idle-timer 9000 t
;;      (lambda ()
;;        (setq mew-use-biff nil)))
;; 動き出したら再開する機能(これはsyncのときでよさげ)とても欲しい

;; メールの着信をポップアップで
(defun mew-biff-popup (n)
  (if (> n 0)
    (start-process "mew-notify" nil "notify-send"
      "-i" (concat HOME ".emacs.d/" "private/" "mew/" "Mew02.png")
      (format "Mail detected!")
      ;; (format "directive %s" directive)
      (format "You not watched %d new mail%s"
        n (if (> n 1) "s" "")))
    )
  )

(fset 'mew-biff-bark (symbol-function 'mew-biff-popup))

;; 新しいメールの表示
(add-hook 'mew-imap-sentinel-hook
  (lambda ()
    (cond ((string-equal directive "scan")
            (setq mew-use-biff t)
            (setq mew-passwd-lifetime 1440)
            (if (> rttl 0)
              (start-process "mew-notify" nil "notify-send"
                "-i" (concat HOME ".emacs.d/" "private/" "mew/" "Mew01.png")
                ;; (format "directive %s" directive)
                (format "Mail received!")
                (format "You have %d new mail%s"
                  rttl (if (> rttl 1) "s" "")))
              )
            )
      (t
        ))))

;; 証明書の変換あたりは http://www.ma.is.saga-u.ac.jp/minamoto/unix/mew51/info/mew_85.html.ja 参考
;; cp TARGET-to-path ~/.emacs.d/private/certs/`openssl x509 -hash -noout -in TARGET-to-path`.0
(setq mew-ssl-cert-directory (concat HOME ".emacs.d/" "private/" "certs/"))

;; ssl-verify-level について
;; http://blogs.yahoo.co.jp/alpha3166/4560697.html 参考
;; 0 : サーバの証明書があっても無くても検証せずにSSL接続
;; 1 : サーバの証明書が「無し」か「ありで検証OK」のときだけSSL接続
;; 2 : サーバの証明書が「ありで検証OK」のときだけSSL接続
;; 3 : サーバが送ってきたものではなくローカルの証明書で検証OKのときだけSSL接続

;; メール自身の設定
(load-file (concat HOME ".emacs.d/" "private/" "mew/" "address.el"))

;; mew-summary-mode
(add-hook 'mew-summary-mode-hook
  '(lambda ()
     (local-set-key (kbd "M-t") 'other-window-vertically)
     ))
;;; 31-mew.el ends here
