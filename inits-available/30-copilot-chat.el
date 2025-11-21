;;; 30-copilot-chat.el --- Summary
;;; LAST UPDATE : 2025/07/31 11:08:39
;;; Commentary:

;;; Code:
(setq copilot-chat-default-model "gpt-4.1")

(add-hook 'copilot-chat-org-prompt-mode-hook
  #'(lambda()
      (skk-mode 1)
      (defun copilot-chat--org-create-req (prompt no-context)
        "Create a request with `org-mode' syntax reminder.
PROMPT is the input text. If NO-CONTEXT is t, do nothing because we are
asking for a commit message."
        (if no-context
          prompt
          (format
            "%s\n\n日本語で"
            prompt)))
      ))
;;; 30-copilot-chat.el ends here
