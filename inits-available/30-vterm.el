;;; 30-vterm.el --- Summary
;;; LAST UPDATE : 2026/02/15 22:18:44
;;; Commentary:

;;; Code:

(defgroup my-vterm-autosave nil
  "Auto-save libvterm (vterm) sessions on exit."
  :group 'applications)

(defcustom my/vterm-save-directory (expand-file-name "~/.emacs.d/private/vterm_sessions/")
  "Directory to save vterm session dumps."
  :type 'directory
  :group 'my-vterm-autosave)

(defcustom my/vterm-save-strip-ansi t
  "If non-nil, strip common ANSI escape sequences from saved output."
  :type 'boolean
  :group 'my-vterm-autosave)

(defcustom my/vterm-save-max-bytes 5000000
  "If session content is larger than this, keep only the tail (bytes)."
  :type 'integer
  :group 'my-vterm-autosave)

(defcustom my/vterm-save-redact-regexp
  "\\(password\\|passwd\\|secret\\|api[_-]?key\\|token\\|aws_secret\\|private_key\\)"
  "Regexp matching sensitive tokens/keywords to redact (case-insensitive).
Set to nil to disable redaction."
  :type '(choice (const :tag "disabled" nil) regexp)
  :group 'my-vterm-autosave)

(defcustom my/vterm-save-compress t
  "If non-nil, gzip the saved file after writing."
  :type 'boolean
  :group 'my-vterm-autosave)

(defun my/vterm--ensure-save-dir ()
  "Ensure save directory exists with restrictive permissions."
  (let ((dir (file-name-as-directory my/vterm-save-directory)))
    (unless (file-directory-p dir)
      (make-directory dir t))
    ;; set to 700 to reduce casual exposure
    (ignore-errors (set-file-modes dir #o700))
    dir))

(defun my/vterm--get-content ()
  "Return textual content of current vterm buffer.
Prefer vterm--get-screen-lines if available; fallback to buffer substring."
  (if (and (fboundp 'vterm--get-screen-lines))
      (mapconcat #'identity (vterm--get-screen-lines) "\n")
    (buffer-substring-no-properties (point-min) (point-max))))

(defun my/vterm--strip-ansi (s)
  "Remove common ANSI escape sequences from string S."
  (replace-regexp-in-string
   "\x1b\\[[0-9;?]*[ -/]*[@-~]" "" s))

(defun my/vterm--sanitize (s)
  "Sanitize string S: normalize CR, remove C0 chars, optionally strip ANSI, and redact safely."
  (let ((s (replace-regexp-in-string "\r" "" s)))
    (setq s (replace-regexp-in-string "[\000-\010\013-\031]" "" s))
    (when my/vterm-save-strip-ansi
      (setq s (my/vterm--strip-ansi s)))
    (setq s (my/vterm--redact-by-regexp s))
    s))

(defun my/vterm-validate-redact-regexp ()
  "Interactive check: validate `my/vterm-save-redact-regexp'."
  (interactive)
  (if (or (null my/vterm-save-redact-regexp)
          (string-empty-p my/vterm-save-redact-regexp))
      (message "my/vterm: redact regexp is empty/nil (no redaction).")
    (condition-case err
        (progn
          (string-match-p my/vterm-save-redact-regexp "")
          (message "my/vterm: redact regexp appears valid."))
      (invalid-regexp
       (message "my/vterm: INVALID redact regexp: %S" err)))))

(defun my/vterm--redact-by-regexp (s)
  "Redact matches of `my/vterm-save-redact-regexp' from S (case-insensitive).
If the regexp is invalid, log a message and return S unchanged."
  (if (and my/vterm-save-redact-regexp
           (not (string-empty-p my/vterm-save-redact-regexp)))
      (condition-case err
          ;; Wrap user's regexp in a case-insensitive group.
          (replace-regexp-in-string
           (concat "\\(?i:" my/vterm-save-redact-regexp "\\)")
           "<REDACTED>" s)
        (invalid-regexp
         (message "my/vterm: invalid redact regexp %S — skipping redaction: %S"
                  my/vterm-save-redact-regexp err)
         s))
    s))

(defun my/vterm--make-filename (&optional buf)
  "Make a timestamped filename for BUF (or current buffer)."
  (let* ((bname (or (and buf (buffer-name buf)) (buffer-name)))
         (time (format-time-string "%Y%m%d_%H%M%S"))
         (clean (replace-regexp-in-string "[/: ]" "_" bname))
         (dir (my/vterm--ensure-save-dir)))
    (expand-file-name (format "%s_%s.txt" clean time) dir)))

(defun my/vterm-save-buffer-to-file (&optional buf)
  "Save vterm content of BUF (or current buffer) to a timestamped file.
Returns the path written (string) or nil on error."
  (when (buffer-live-p (or buf (current-buffer)))
    (with-current-buffer (or buf (current-buffer))
      (unless (derived-mode-p 'vterm-mode)
        (user-error "Not a vterm buffer"))
      (let* ((content (my/vterm--get-content))
             ;; redact first using case-insensitive regexp
             (content (my/vterm--redact-by-regexp content))
             (content (my/vterm--sanitize content))
             (file (my/vterm--make-filename (current-buffer))))
        ;; enforce max bytes: keep tail
        (when (> (string-bytes content) my/vterm-save-max-bytes)
          (setq content (substring content (- (length content) my/vterm-save-max-bytes))))
        (condition-case err
            (progn
              (with-temp-file file
                (insert content))
              (ignore-errors (set-file-modes file #o600))
              (when my/vterm-save-compress
                (when (executable-find "gzip")
                  (call-process "gzip" nil nil nil "--" file)
                  (setq file (concat file ".gz"))))
              (message "vterm: saved session to %s" file)
              file)
          (error
           (message "vterm: failed to save session: %S" err)
           nil))))))

(defun my/vterm--proc-sentinel (proc _event)
  "Process sentinel to save buffer when PROC exits or is signaled."
  (when (memq (process-status proc) '(exit signal))
    (let ((buf (process-buffer proc)))
      (when (buffer-live-p buf)
        (condition-case err
            (my/vterm-save-buffer-to-file buf)
          (error (message "vterm-save: error saving %s: %S" buf err)))))))

(defun my/vterm-enable-auto-save ()
  "Enable auto-save-on-exit for the current vterm buffer.
Installs a process sentinel and a buffer-local kill-buffer-hook."
  (interactive)
  (when (derived-mode-p 'vterm-mode)
    (let ((proc (get-buffer-process (current-buffer))))
      (when (processp proc)
        (set-process-sentinel proc #'my/vterm--proc-sentinel)))
    (add-hook 'kill-buffer-hook
              (lambda ()
                (when (derived-mode-p 'vterm-mode)
                  (my/vterm-save-buffer-to-file (current-buffer))))
              nil t)))

;; Enable for all vterm buffers by default
(add-hook 'vterm-mode-hook #'my/vterm-enable-auto-save)
(add-hook 'vterm-mode-hook
  #'(lambda ()
      (display-line-numbers-mode 0)
      (setq-local display-line-numbers nil)
      (define-key vterm-mode-map [(C t)] 'other-window-horizontally)
      (define-key vterm-mode-map [(M t)] 'other-window-vertically)
      (define-key vterm-mode-map [(M q)] 'delete-window)
      (define-key vterm-mode-map [(C h)] 'vterm-send-backspace)
      (define-key vterm-mode-map [(C u)] 'vterm--self-insert)
      ))

(provide 'my-vterm-autosave)

;;; 30-vterm.el ends here
