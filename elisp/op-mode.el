;;; op-mode.el --- 1Password CLI (op) interface for Emacs -*- lexical-binding: t; -*-

;; Author: SARUWATARI
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: tools, convenience, password

;;; Commentary:

;; 1Password CLI v2 (`op') を Emacs から操作するためのパッケージ。
;;
;; 主な機能:
;;   M-x op-list-items     アイテム一覧バッファ (tabulated-list)
;;   M-x op-copy-password  補完でアイテムを選んでパスワードをコピー
;;   M-x op-copy-username  同ユーザー名
;;   M-x op-copy-otp       同ワンタイムパスワード (TOTP)
;;   M-x op-read           op://vault/item/field 参照を読んでコピー
;;   M-x op-create-login   パスワードを生成してログインアイテムを作成
;;   M-x op-signin / op-signout
;;   M-x op-mode           グローバルマイナーモード (プレフィックスキー C-c P)
;;
;; コピーしたシークレットは `op-clipboard-clear-seconds' 秒後に
;; kill-ring とクリップボードから消去される (M-x op-clear-clipboard で即時消去)。
;; コピー時に識別用マーカーを直前に積み、消去時はマーカーとその次の値だけを
;; 削除するので、その間にユーザーがコピーした別の内容は消さない。
;;
;; サインイン方式 (`op-signin-method'):
;;   app      1Password デスクトップアプリ連携 (生体認証/システム認証)。推奨。
;;   password マスターパスワードを read-passwd で入力し、stdin 経由で op に渡す。
;;            取得したセッショントークンは Emacs 内の環境変数としてのみ保持する。
;;
;; 設定例:
;;   (require 'op-mode)
;;   ;; op-account はアカウントが複数ある場合のみ設定する (1つなら nil のままでよい)。
;;   ;; 値は `op account list' に出る URL (例: "example.1password.com")、
;;   ;; メールアドレス、またはアカウント ID。M-x op-select-account でも選べる。
;;   (setq op-account nil
;;         op-default-vault "Private")
;;   (op-mode 1)

;;; Code:

(require 'json)
(require 'seq)
(require 'subr-x)
(require 'tabulated-list)
(require 'browse-url)

;;;; Customization

(defgroup op nil
  "Interface to the 1Password CLI."
  :group 'tools
  :prefix "op-")

(defcustom op-executable "op"
  "Path to the 1Password CLI executable."
  :type 'string)

(defcustom op-account nil
  "Account passed to `--account' (shorthand, sign-in address or ID).
nil means op's default account."
  :type '(choice (const :tag "Default" nil) string))

(defcustom op-default-vault nil
  "Vault to show by default.  nil means all vaults."
  :type '(choice (const :tag "All vaults" nil) string))

(defcustom op-list-categories nil
  "Categories to list, e.g. (\"Login\" \"Password\").  nil means all."
  :type '(repeat string))

(defcustom op-signin-method 'app
  "How to sign in.
`app' uses 1Password desktop app integration.
`password' prompts for the account password."
  :type '(choice (const :tag "Desktop app integration" app)
                 (const :tag "Account password" password)))

(defcustom op-clipboard-clear-seconds 45
  "Seconds after which copied secrets are cleared.  nil disables clearing."
  :type '(choice (const :tag "Never" nil) integer))

(defcustom op-auto-signin t
  "When non-nil, sign in automatically when op reports no session."
  :type 'boolean)

(defcustom op-generate-password-recipe "letters,digits,symbols,32"
  "Recipe passed to `--generate-password' by `op-create-login'."
  :type 'string)

(defcustom op-mode-prefix-key "C-c P"
  "Prefix key for `op-command-map' in `op-mode'.
Set this before loading op-mode.el."
  :type 'string)

(defface op-label-face '((t :inherit font-lock-keyword-face))
  "Face for field labels in item buffers.")

(defface op-section-face '((t :inherit font-lock-function-name-face :weight bold))
  "Face for section headings in item buffers.")

(defface op-concealed-face '((t :inherit shadow))
  "Face for concealed values.")

;;;; Internal state

(define-error 'op-error "1Password CLI error")

(defvar op--session-env nil
  "List of \"OP_SESSION_xxx=TOKEN\" strings obtained by `op-signin'.")

(defvar op--items-cache nil
  "Cached item list used for completion.")

(defvar op--pending-markers nil
  "Alist of (MARKER . TIMER) for copied secrets waiting to be cleared.")

(defconst op--marker-prefix "op-mode-marker:"
  "Prefix of the marker string pushed before each secret.")

(defconst op--auth-error-regexp
  (regexp-opt '("not currently signed in" "session expired" "not signed in"
                "authorization prompt dismissed" "You are not currently"
                "account is not signed in" "no active session"))
  "Regexp matching op errors that indicate a missing session.")

;;;; Process helpers

(defun op--global-args ()
  (when op-account (list "--account" op-account)))

(defun op--call-raw (args &optional input)
  "Run op with ARGS and return stdout.  Feed INPUT to stdin if non-nil.
Signal `op-error' with stderr content on failure."
  (let ((process-environment (append op--session-env process-environment))
        (stderr-file (make-temp-file "op-stderr"))
        (all-args (append args (op--global-args))))
    (unwind-protect
        (with-temp-buffer
          (let ((status
                 (if input
                     (progn
                       (insert input)
                       (apply #'call-process-region (point-min) (point-max)
                              op-executable t (list t stderr-file) nil all-args))
                   (apply #'call-process op-executable nil
                          (list t stderr-file) nil all-args))))
            (if (eq status 0)
                (buffer-string)
              (signal 'op-error
                      (list (string-trim
                             (with-temp-buffer
                               (insert-file-contents stderr-file)
                               (buffer-string))))))))
      (delete-file stderr-file))))

(defun op--call (&rest args)
  "Run op with ARGS, signing in and retrying once if needed."
  (condition-case err
      (op--call-raw args)
    (op-error
     (let ((msg (or (cadr err) "")))
       (cond
        ((string-match-p "found no accounts for filter" msg)
         (user-error "1Password: `op-account' (%S) に一致するアカウントがありません。\
M-x op-select-account で選び直すか、nil にしてください" op-account))
        ((and op-auto-signin (string-match-p op--auth-error-regexp msg))
         (op-signin)
         (op--call-raw args))
        (t (signal (car err) (cdr err))))))))

(defun op--accounts ()
  "Return accounts known to op (ignores `op-account')."
  (let* ((op-account nil)
         (out (op--call-raw '("account" "list" "--format" "json"))))
    (unless (string-empty-p (string-trim out))
      (json-parse-string out :object-type 'alist :array-type 'list
                         :null-object nil :false-object nil))))

;;;###autoload
(defun op-select-account ()
  "Choose the account used by op-mode and set `op-account'.
With a prefix argument, also save it with Customize."
  (interactive)
  (let* ((accounts (op--accounts))
         (cands (mapcar (lambda (a)
                          (cons (format "%s  <%s>" (op--get a 'url) (op--get a 'email))
                                (op--get a 'url)))
                        accounts)))
    (unless cands
      (user-error "1Password: アカウントが見つかりません。1Password アプリの CLI 連携か `op account add' を確認してください"))
    (let ((url (cdr (assoc (completing-read "1Password account: " cands nil t) cands))))
      (setq op-account url
            op--items-cache nil)
      (when current-prefix-arg
        (customize-save-variable 'op-account url))
      (message "1Password: op-account = %s" url))))

(defun op--json (&rest args)
  "Run op with ARGS plus `--format json' and parse the result."
  (let ((out (apply #'op--call (append args '("--format" "json")))))
    (if (string-empty-p (string-trim out))
        nil
      (json-parse-string out :object-type 'alist :array-type 'list
                         :null-object nil :false-object nil))))

(defun op--get (alist &rest keys)
  "Follow KEYS (symbols) through nested ALIST."
  (let ((v alist))
    (dolist (k keys v)
      (setq v (alist-get k v)))))

;;;; Sign in / out

;;;###autoload
(defun op-signin ()
  "Sign in to 1Password."
  (interactive)
  (pcase op-signin-method
    ('app
     (op--call-raw '("signin"))
     (message "1Password: signed in (app integration)"))
    ('password
     (let ((pw (read-passwd (format "1Password password%s: "
                                    (if op-account (format " (%s)" op-account) "")))))
       (unwind-protect
           (let ((out (op--call-raw '("signin") pw)))
             (if (string-match
                  "\\(OP_SESSION_[[:alnum:]_]+\\) *= *\"\\([^\"]+\\)\"" out)
                 (let* ((var (match-string 1 out))
                        (entry (concat var "=" (match-string 2 out))))
                   (setq op--session-env
                         (cons entry
                               (seq-remove (lambda (e) (string-prefix-p (concat var "=") e))
                                           op--session-env)))
                   (clear-string out)
                   (message "1Password: signed in"))
               (message "1Password: signin returned no session token")))
         (clear-string pw))))))

;;;###autoload
(defun op-signout ()
  "Sign out of 1Password and forget session tokens."
  (interactive)
  (ignore-errors (op--call-raw '("signout")))
  (mapc #'clear-string op--session-env)
  (setq op--session-env nil
        op--items-cache nil)
  (message "1Password: signed out"))

;;;###autoload
(defun op-whoami ()
  "Show the signed-in account."
  (interactive)
  (let ((info (op--json "whoami")))
    (message "1Password: %s (%s)"
             (op--get info 'email) (op--get info 'url))))

;;;; Clipboard
;;
;; シークレットのコピー時には次の 2 つを順に kill-ring (およびクリップボード) へ積む:
;;   1. 識別用のランダムなマーカー文字列 ("op-mode-marker:<uuid>")
;;   2. 実際のシークレット
;; 消去時は kill-ring からマーカーを探し、マーカーとその「次に」積まれた値
;; (= シークレット) だけを削除する。シークレット自体は Emacs 側で保持しない。
;; システムのクリップボードは、中身がそのシークレットかマーカーの場合のみ空にする。

(defun op--make-marker ()
  "Return a unique marker string (prefix + random UUIDv4)."
  (concat op--marker-prefix
          (format "%08x-%04x-4%03x-%04x-%012x"
                  (random #x100000000) (random #x10000) (random #x1000)
                  (logior #x8000 (random #x4000)) (random #x1000000000000))))

(defun op--system-clipboard ()
  "Return the system clipboard text, or `:unknown' if it cannot be read."
  (if (display-graphic-p)
      (condition-case nil
          (or (gui-get-selection 'CLIPBOARD 'UTF8_STRING) "")
        (error :unknown))
    :unknown))

(defun op--clear-marker (marker &optional quiet)
  "Remove MARKER and the value copied right after it from the kill ring.
Clear the system clipboard if it still holds either of them.
Non-nil QUIET suppresses the message.  Return non-nil if a secret was removed."
  (let ((entry (assoc marker op--pending-markers)))
    (when (timerp (cdr entry)) (cancel-timer (cdr entry)))
    (setq op--pending-markers (delq entry op--pending-markers)))
  (let ((pos (seq-position kill-ring marker)))
    (when pos
      (let* ((marker-obj (nth pos kill-ring))
             ;; kill-ring は新しい順なので、マーカーの「次の値」は 1 つ前の位置。
             (secret (and (> pos 0) (nth (1- pos) kill-ring)))
             (secret-latest (= pos 1))
             (clip (op--system-clipboard)))
        (setq kill-ring (delq marker-obj (if secret (delq secret kill-ring) kill-ring))
              kill-ring-yank-pointer kill-ring)
        (when interprogram-cut-function
          (cond
           ((stringp clip)
            (when (or (equal clip marker-obj) (and secret (equal clip secret)))
              (funcall interprogram-cut-function "")))
           ;; 読めない環境 (端末等) では、Emacs で最後にコピーしたのが
           ;; このシークレットだった場合のみ空にする。
           ((or secret-latest (= pos 0))
            (funcall interprogram-cut-function ""))))
        (when secret (clear-string secret))
        (unless quiet (message "1Password: clipboard cleared"))
        secret))))

;;;###autoload
(defun op-clear-clipboard ()
  "Clear all secrets copied by op-mode that are still pending."
  (interactive)
  (let ((n 0))
    (dolist (m (mapcar #'car op--pending-markers))
      (when (op--clear-marker m t) (setq n (1+ n))))
    (when (called-interactively-p 'interactive)
      (message "1Password: cleared %d secret(s)" n))))

(defun op--copy (secret what)
  "Copy SECRET to the kill ring, describing it as WHAT.
A marker is pushed first so the secret can be found and removed later."
  (unless (and secret (not (string-empty-p secret)))
    (user-error "1Password: %s is empty" what))
  (let ((marker (op--make-marker))
        (kill-do-not-save-duplicates nil))
    (kill-new marker)
    (kill-new (copy-sequence secret))
    (push (cons marker
                (when op-clipboard-clear-seconds
                  (run-at-time op-clipboard-clear-seconds nil
                               #'op--clear-marker marker)))
          op--pending-markers)
    (if op-clipboard-clear-seconds
        (message "1Password: copied %s (clears in %ds)" what op-clipboard-clear-seconds)
      (message "1Password: copied %s" what))))

;;;; Data access

(defun op--vaults ()
  (op--json "vault" "list"))

(defun op--list-items (&optional vault)
  (apply #'op--json "item" "list"
         (append (when vault (list "--vault" vault))
                 (when op-list-categories
                   (list "--categories" (string-join op-list-categories ","))))))

(defun op--item-get (item)
  "Fetch full ITEM (alist with id and vault) as JSON."
  (apply #'op--json "item" "get" (op--get item 'id)
         (when-let ((v (op--get item 'vault 'id))) (list "--vault" v))))

(defun op--item-otp (item)
  (string-trim
   (apply #'op--call "item" "get" (op--get item 'id) "--otp"
          (when-let ((v (op--get item 'vault 'id))) (list "--vault" v)))))

(defun op--field-by-purpose (full purpose)
  (seq-find (lambda (f) (equal (op--get f 'purpose) purpose))
            (op--get full 'fields)))

(defun op--field-by-label (full label)
  (seq-find (lambda (f) (equal (op--get f 'label) label))
            (op--get full 'fields)))

(defun op--password (full)
  (op--get (or (op--field-by-purpose full "PASSWORD")
               (op--field-by-label full "password")
               (seq-find (lambda (f) (equal (op--get f 'type) "CONCEALED"))
                         (op--get full 'fields)))
           'value))

(defun op--username (full)
  (op--get (or (op--field-by-purpose full "USERNAME")
               (op--field-by-label full "username"))
           'value))

(defun op--primary-url (item)
  (let ((urls (op--get item 'urls)))
    (op--get (or (seq-find (lambda (u) (op--get u 'primary)) urls) (car urls))
             'href)))

;;;; Completion

(defun op--item-candidates (&optional refresh)
  (when (or refresh (null op--items-cache))
    (setq op--items-cache (op--list-items op-default-vault)))
  (mapcar (lambda (it)
            (cons (format "%s  (%s%s)"
                          (op--get it 'title)
                          (op--get it 'vault 'name)
                          (let ((info (op--get it 'additional_information)))
                            (if (and info (not (string-empty-p info)))
                                (concat " / " info) "")))
                  it))
          op--items-cache))

(defun op--read-item (prompt)
  (let* ((cands (op--item-candidates))
         (choice (completing-read prompt cands nil t)))
    (cdr (assoc choice cands))))

;;;; Global commands

;;;###autoload
(defun op-copy-password (item)
  "Copy the password of ITEM."
  (interactive (list (op--read-item "Password for: ")))
  (op--copy (op--password (op--item-get item))
            (format "password of %s" (op--get item 'title))))

;;;###autoload
(defun op-copy-username (item)
  "Copy the username of ITEM."
  (interactive (list (op--read-item "Username for: ")))
  (op--copy (op--username (op--item-get item))
            (format "username of %s" (op--get item 'title))))

;;;###autoload
(defun op-copy-otp (item)
  "Copy the current one-time password of ITEM."
  (interactive (list (op--read-item "OTP for: ")))
  (op--copy (op--item-otp item) (format "OTP of %s" (op--get item 'title))))

;;;###autoload
(defun op-read (reference)
  "Read secret REFERENCE (op://vault/item/field) and copy it."
  (interactive (list (read-string "Secret reference: " "op://")))
  (op--copy (string-trim-right (op--call "read" "--no-newline" reference) "\n")
            reference))

;;;###autoload
(defun op-insert-reference (item)
  "Insert an op:// reference to ITEM's password at point (no secret inserted)."
  (interactive (list (op--read-item "Reference to: ")))
  (insert (format "op://%s/%s/password"
                  (op--get item 'vault 'name) (op--get item 'title))))

;;;###autoload
(defun op-create-login (title username url vault)
  "Create a Login item TITLE with USERNAME, URL in VAULT and a generated password."
  (interactive
   (list (read-string "Title: ")
         (read-string "Username: ")
         (read-string "URL: ")
         (completing-read "Vault: " (mapcar (lambda (v) (op--get v 'name)) (op--vaults))
                          nil t op-default-vault)))
  (let* ((args (append (list "item" "create" "--category" "login"
                             "--title" title "--vault" vault
                             (concat "--generate-password=" op-generate-password-recipe))
                       (unless (string-empty-p url) (list "--url" url))
                       (unless (string-empty-p username)
                         (list (concat "username=" username)))))
         (created (apply #'op--json args)))
    (setq op--items-cache nil)
    (message "1Password: created %s" title)
    (when (y-or-n-p "Copy generated password? ")
      (op--copy (op--password created) (format "password of %s" title)))))

;;;; Item list mode

(defvar-local op-list--vault nil "Vault shown in this buffer (nil = all).")
(defvar-local op-list--items nil "Items fetched for this buffer.")
(defvar-local op-list--filter nil "Regexp filter for this buffer.")

(defvar op-list-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") #'op-list-show-item)
    (define-key map "w" #'op-list-copy-password)
    (define-key map "u" #'op-list-copy-username)
    (define-key map "o" #'op-list-copy-otp)
    (define-key map "l" #'op-list-copy-url)
    (define-key map "b" #'op-list-browse-url)
    (define-key map "r" #'op-list-copy-reference)
    (define-key map "v" #'op-list-select-vault)
    (define-key map "/" #'op-list-filter)
    (define-key map "c" #'op-create-login)
    (define-key map "D" #'op-list-archive-item)
    (define-key map "s" #'op-signin)
    (define-key map "n" #'next-line)
    (define-key map "p" #'previous-line)
    map)
  "Keymap for `op-list-mode'.")

(define-derived-mode op-list-mode tabulated-list-mode "1Password"
  "Major mode listing 1Password items.

\\{op-list-mode-map}"
  (setq tabulated-list-format
        [("Title" 36 op-list--title<) ("Category" 14 t) ("Vault" 16 op-list--vault-title<)
         ("Info" 32 t) ("Updated" 19 t)])
  (setq tabulated-list-sort-key '("Title" . nil))
  (setq tabulated-list-padding 1)
  (add-hook 'tabulated-list-revert-hook #'op-list--refresh nil t)
  (tabulated-list-init-header))

(defun op-list--vault-title< (a b)
  "Sort predicate for tabulated-list entries A and B: vault, then title."
  (let ((va (downcase (aref (cadr a) 2))) (vb (downcase (aref (cadr b) 2)))
        (ta (downcase (aref (cadr a) 0))) (tb (downcase (aref (cadr b) 0))))
    (if (string= va vb) (string< ta tb) (string< va vb))))

(defun op-list--title< (a b)
  "Case-insensitive sort predicate on title for entries A and B."
  (string< (downcase (aref (cadr a) 0)) (downcase (aref (cadr b) 0))))

(defun op-list--set-default-sort ()
  "All vaults: sort by vault then title.  Single vault: sort by title."
  (setq tabulated-list-sort-key
        (if op-list--vault '("Title" . nil) '("Vault" . nil)))
  (tabulated-list-init-header))

(defun op-list--format-time (s)
  (if (and s (>= (length s) 16))
      (replace-regexp-in-string "T" " " (substring s 0 16))
    (or s "")))

(defun op-list--render ()
  (setq tabulated-list-entries
        (delq nil
              (mapcar
               (lambda (it)
                 (let ((title (or (op--get it 'title) ""))
                       (info (or (op--get it 'additional_information) "")))
                   (when (or (null op-list--filter)
                             (string-match-p op-list--filter title)
                             (string-match-p op-list--filter info))
                     (list it
                           (vector title
                                   (or (op--get it 'category) "")
                                   (or (op--get it 'vault 'name) "")
                                   info
                                   (op-list--format-time (op--get it 'updated_at)))))))
               op-list--items)))
  (setq mode-line-process
        (format " [%s%s]" (or op-list--vault "all vaults")
                (if op-list--filter (format " /%s/" op-list--filter) ""))))

(defun op-list--refresh ()
  (setq op-list--items (op--list-items op-list--vault))
  (setq op--items-cache op-list--items)
  (op-list--render))

;;;###autoload
(defun op-list-items (&optional vault)
  "Show 1Password items, optionally restricted to VAULT."
  (interactive)
  (let ((buf (get-buffer-create "*1Password*")))
    (with-current-buffer buf
      (op-list-mode)
      (setq op-list--vault (or vault op-default-vault))
      (op-list--set-default-sort)
      (op-list--refresh)
      (tabulated-list-print))
    (pop-to-buffer-same-window buf)))

;;;###autoload
(defalias 'op #'op-list-items)

(defun op-list--item-at-point ()
  (or (tabulated-list-get-id) (user-error "No item at point")))

(defun op-list-show-item ()
  "Show the item at point."
  (interactive)
  (op-item-show (op-list--item-at-point)))

(defun op-list-copy-password ()
  "Copy password of the item at point."
  (interactive)
  (op-copy-password (op-list--item-at-point)))

(defun op-list-copy-username ()
  "Copy username of the item at point."
  (interactive)
  (op-copy-username (op-list--item-at-point)))

(defun op-list-copy-otp ()
  "Copy OTP of the item at point."
  (interactive)
  (op-copy-otp (op-list--item-at-point)))

(defun op-list-copy-url ()
  "Copy primary URL of the item at point."
  (interactive)
  (let ((url (op--primary-url (op-list--item-at-point))))
    (unless url (user-error "No URL"))
    (kill-new url)
    (message "Copied %s" url)))

(defun op-list-browse-url ()
  "Open primary URL of the item at point."
  (interactive)
  (let ((url (op--primary-url (op-list--item-at-point))))
    (unless url (user-error "No URL"))
    (browse-url url)))

(defun op-list-copy-reference ()
  "Copy an op:// reference to the password of the item at point."
  (interactive)
  (let* ((it (op-list--item-at-point))
         (ref (format "op://%s/%s/password"
                      (op--get it 'vault 'name) (op--get it 'title))))
    (kill-new ref)
    (message "Copied %s" ref)))

(defun op-list-select-vault ()
  "Switch the vault shown in this buffer."
  (interactive)
  (let* ((names (mapcar (lambda (v) (op--get v 'name)) (op--vaults)))
         (choice (completing-read "Vault (empty = all): " names nil t)))
    (setq op-list--vault (unless (string-empty-p choice) choice))
    (op-list--set-default-sort)
    (revert-buffer)))

(defun op-list-filter (regexp)
  "Filter the list by REGEXP on title/info.  Empty clears the filter."
  (interactive (list (read-regexp "Filter (empty = clear): ")))
  (setq op-list--filter (unless (string-empty-p regexp) regexp))
  (op-list--render)
  (tabulated-list-print t))

(defun op-list-archive-item ()
  "Move the item at point to the archive."
  (interactive)
  (let ((it (op-list--item-at-point)))
    (when (yes-or-no-p (format "Archive \"%s\"? " (op--get it 'title)))
      (op--call "item" "delete" (op--get it 'id)
                "--vault" (op--get it 'vault 'id) "--archive")
      (revert-buffer)
      (message "1Password: archived %s" (op--get it 'title)))))

;;;; Item detail mode

(defvar-local op-item--item nil "Summary alist of the shown item.")
(defvar-local op-item--full nil "Full JSON of the shown item.")
(defvar-local op-item--reveal nil "Whether concealed values are shown.")

(defvar op-item-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map special-mode-map)
    (define-key map (kbd "RET") #'op-item-copy-field)
    (define-key map "w" #'op-item-copy-field)
    (define-key map (kbd "TAB") #'op-item-toggle-reveal)
    (define-key map "o" #'op-item-copy-otp)
    (define-key map "b" #'op-item-browse-url)
    (define-key map "n" #'op-item-next-field)
    (define-key map "p" #'op-item-previous-field)
    map)
  "Keymap for `op-item-mode'.")

(define-derived-mode op-item-mode special-mode "1Password-Item"
  "Major mode showing a 1Password item.

\\{op-item-mode-map}"
  (setq-local revert-buffer-function #'op-item--revert))

(defun op-item--concealed-p (field)
  (member (op--get field 'type) '("CONCEALED" "OTP")))

(defun op-item--insert-field (field)
  (let* ((label (or (op--get field 'label) (op--get field 'id) "?"))
         (value (or (op--get field 'value) ""))
         (otp (equal (op--get field 'type) "OTP"))
         (start (point)))
    (insert (propertize (format "  %-20s " label) 'face 'op-label-face))
    (cond
     ((and (op-item--concealed-p field) (not op-item--reveal))
      (insert (propertize (if otp "•••••• (o: copy code)" "••••••••••••")
                          'face 'op-concealed-face)))
     ((string-match-p "\n" value)
      (insert "\n" (replace-regexp-in-string "^" "      " value)))
     (t (insert value)))
    (insert "\n")
    (put-text-property start (point) 'op-field field)))

(defun op-item--render ()
  (let ((inhibit-read-only t)
        (full op-item--full)
        (pos (point)))
    (erase-buffer)
    (insert (propertize (or (op--get full 'title) "") 'face '(:height 1.3 :weight bold))
            "\n"
            (propertize (format "%s  /  %s  /  updated %s\n\n"
                                (op--get full 'category)
                                (op--get full 'vault 'name)
                                (op-list--format-time (op--get full 'updated_at)))
                        'face 'shadow))
    (let ((fields (op--get full 'fields))
          (sections (op--get full 'sections)))
      ;; Fields without a section first.
      (dolist (f fields)
        (unless (op--get f 'section 'id)
          (unless (and (equal (op--get f 'purpose) "NOTES")
                       (string-empty-p (or (op--get f 'value) "")))
            (op-item--insert-field f))))
      (dolist (s sections)
        (let ((sfields (seq-filter (lambda (f) (equal (op--get f 'section 'id)
                                                      (op--get s 'id)))
                                   fields)))
          (when sfields
            (insert "\n" (propertize (or (op--get s 'label) (op--get s 'id) "")
                                     'face 'op-section-face)
                    "\n")
            (mapc #'op-item--insert-field sfields)))))
    (when-let ((urls (op--get full 'urls)))
      (insert "\n" (propertize "URLs" 'face 'op-section-face) "\n")
      (dolist (u urls)
        (let ((start (point)))
          (insert (propertize (format "  %-20s " (or (op--get u 'label) "website"))
                              'face 'op-label-face)
                  (op--get u 'href) "\n")
          (put-text-property start (point) 'op-field
                             `((label . "url") (type . "URL")
                               (value . ,(op--get u 'href)))))))
    (insert "\n" (propertize "RET/w: copy  TAB: reveal  o: OTP  b: browse  g: refresh  q: quit"
                             'face 'shadow))
    (goto-char (min pos (point-max)))))

(defun op-item--revert (&rest _)
  (setq op-item--full (op--item-get op-item--item))
  (op-item--render))

(defun op-item-show (item)
  "Display ITEM in a dedicated buffer."
  (let ((buf (get-buffer-create (format "*1Password: %s*" (op--get item 'title)))))
    (with-current-buffer buf
      (op-item-mode)
      (setq op-item--item item)
      (op-item--revert)
      (goto-char (point-min))
      (op-item-next-field))
    (pop-to-buffer buf)))

(defun op-item--field-at-point ()
  (or (get-text-property (point) 'op-field)
      (user-error "No field at point")))

(defun op-item-copy-field ()
  "Copy the value of the field at point (OTP fields copy the current code)."
  (interactive)
  (let ((f (op-item--field-at-point)))
    (if (equal (op--get f 'type) "OTP")
        (op-item-copy-otp)
      (op--copy (op--get f 'value) (or (op--get f 'label) "field")))))

(defun op-item-copy-otp ()
  "Copy the current OTP code of this item."
  (interactive)
  (op-copy-otp op-item--item))

(defun op-item-toggle-reveal ()
  "Toggle display of concealed values."
  (interactive)
  (setq op-item--reveal (not op-item--reveal))
  (op-item--render))

(defun op-item-browse-url ()
  "Open the item's primary URL."
  (interactive)
  (let ((url (op--primary-url op-item--full)))
    (unless url (user-error "No URL"))
    (browse-url url)))

(defun op-item-next-field ()
  "Move to the next field."
  (interactive)
  (let ((cur (get-text-property (point) 'op-field))
        (pos (point)))
    (while (and (< pos (point-max))
                (or (null (get-text-property pos 'op-field))
                    (eq (get-text-property pos 'op-field) cur)))
      (setq pos (1+ pos)))
    (when (get-text-property pos 'op-field)
      (goto-char pos))))

(defun op-item-previous-field ()
  "Move to the previous field."
  (interactive)
  (let ((cur (get-text-property (point) 'op-field))
        target)
    (save-excursion
      (beginning-of-line)
      (while (and (not target) (zerop (forward-line -1)))
        (let ((f (get-text-property (point) 'op-field)))
          (when (and f (not (eq f cur)))
            (setq target (point))))))
    (when target
      (goto-char (or (previous-single-property-change (1+ target) 'op-field)
                     (point-min))))))

;;;; Global minor mode

(defvar op-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map "l" #'op-list-items)
    (define-key map "w" #'op-copy-password)
    (define-key map "u" #'op-copy-username)
    (define-key map "o" #'op-copy-otp)
    (define-key map "r" #'op-read)
    (define-key map "i" #'op-insert-reference)
    (define-key map "c" #'op-create-login)
    (define-key map "s" #'op-signin)
    (define-key map "S" #'op-signout)
    (define-key map "x" #'op-clear-clipboard)
    (define-key map "a" #'op-select-account)
    (define-key map "?" #'op-whoami)
    map)
  "Command map for 1Password.")
(fset 'op-command-map op-command-map)

(defvar op-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd op-mode-prefix-key) 'op-command-map)
    map)
  "Keymap for `op-mode'.")

;;;###autoload
(define-minor-mode op-mode
  "Global minor mode providing 1Password commands under `op-mode-prefix-key'.

\\{op-command-map}"
  :global t
  :lighter " 1P"
  :keymap op-mode-map
  (unless op-mode
    (op-clear-clipboard)))

(provide 'op-mode)
;;; op-mode.el ends here
