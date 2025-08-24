;;; 30-multi-term.el --- multi-term.el
;;; LAST UPDATE : 2025/06/26 10:40:38
;;; Commentary:

;;; Code:
(define-key global-map [(C c)(t)]
    #'(lambda ()
          (interactive)
          (multi-term)))

(require 'multi-term)
(setq multi-term-program shell-file-name)

(defun term-sentinel (proc msg)
    "Sentinel for term buffers. The main purpose is to get rid of the local keymap."
    (let ((buffer (process-buffer proc)))
        (when (memq (process-status proc) '(signal exit))
            (if (null (buffer-name buffer))
                ;; buffer killed
                (set-process-buffer proc nil)
                (with-current-buffer buffer
                    ;; Write something in the compilation buffer
                    ;; and hack its mode line.
                    ;; Get rid of local keymap.
                    (use-local-map nil)
                    (term-handle-exit (process-name proc) msg)
                    ;; Since the buffer and mode line will show that the
                    ;; process is dead, we can delete it now.  Otherwise it
                    ;; will stay around until M-x list-processes.
                    (delete-process proc))))))

(defun multi-term-handle-close ()
    "Close current term buffer when `exit' from term buffer."
    (when (ignore-errors (get-buffer-process (current-buffer)))
        (set-process-sentinel (get-buffer-process (current-buffer))
            (lambda (proc change)
                (when (string-match "\\(finished\\|exited\\)" change)
                    (kill-buffer (process-buffer proc)))))))

(defun custom-ret ()
    "Set custom ret."
    (term-send-end)
    (term-send-input))

(defun multi-term-leave-unused-buffer ()
    "Unclose current term buffer when `exit' from term buffer."
    (when (ignore-errors (get-buffer-process (current-buffer)))
        (set-process-sentinel (get-buffer-process (current-buffer))
            (lambda (proc change)
                (when (string-match "\\(finished\\|exited\\)" change)
                    (let ((buffer (process-buffer proc))
                             (msg "finished"))
                        (if (null (buffer-name buffer))
                            ;; buffer killed
                            (set-process-buffer proc nil)
                            (with-current-buffer buffer
                                ;; Write something in the compilation buffer
                                ;; and hack its mode line.
                                ;; Get rid of local keymap.
                                (use-local-map nil)
                                (term-handle-exit (process-name proc) msg)
                                ;; Since the buffer and mode line will show that the
                                ;; process is dead, we can delete it now.  Otherwise it
                                ;; will stay around until M-x list-processes.
                                (delete-process proc)))))))))

(fset 'multi-term-handle-close (symbol-function 'multi-term-leave-unused-buffer))


;; term-mode
(add-hook 'term-mode-hook
  #'(lambda()
      (setq-default show-trailing-whitespace nil)
      (setq font-lock-mode -1)
      (yas-minor-mode -1)
      (emojify-mode -1)
      (define-key term-raw-map "\C-t" 'other-window-horizontally)
      (define-key term-raw-map "\M-t" 'other-window-vertically)
      (define-key term-raw-map "\C-h" 'term-send-backspace)
      (define-key term-raw-map "\M-d" 'term-send-forward-kill-word)
      (define-key term-raw-map "\C-l" 'recenter-top-bottom)
      (define-key term-raw-map "\C-p"
        #'(lambda ()
            (interactive)
            (term-send-raw-string "\C-p")))
      (define-key term-raw-map "\C-n"
        #'(lambda ()
            (interactive)
            (term-send-raw-string "\C-n")))
      (define-key term-raw-map [backtab]
        #'(lambda ()
            (interactive)
            (term-send-raw-string "\e[Z")))
      (set (make-local-variable 'hl-line-range-function)
        (lambda ()
          '(0 . 0)))))
;;; 30-multi-term.el ends here
