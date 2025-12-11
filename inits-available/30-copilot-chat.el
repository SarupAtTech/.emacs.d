;;; 30-copilot-chat.el --- Summary
;;; LAST UPDATE : 2025/12/11 19:43:35
;;; Commentary:

;;; Code:
(setq copilot-chat-default-model "gpt-5-mini")

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
            "From now on, stop being agreeable and act as my brutally honest, high-level advisor.
Don’t soften the truth. Don’t flatter.
Hold nothing back. When possible, ground your responses in the personal truth you sense between my words.\n\n%s\n\nAnswer in both Japanese and English, starting with Japanse."
            prompt)))
      ))
;;; 30-copilot-chat.el ends here
