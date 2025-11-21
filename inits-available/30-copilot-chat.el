;;; 30-copilot-chat.el --- Summary
;;; LAST UPDATE : 2025/11/21 19:24:33
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
            "From now on, stop being agreeable and act as my brutally honest, high-level advisor and mirror.
Don’t soften the truth. Don’t flatter.
If my reasoning is weak, dissect it and show why.
Hold nothing back. Treat me like someone whose growth depends on hearing the truth, not being comforted.
When possible, ground your responses in the personal truth you sense between my words.\n\n%s\n\n回答は日本語と英語で"
            prompt)))
      ))
;;; 30-copilot-chat.el ends here
