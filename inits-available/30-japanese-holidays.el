;;; 30-japanese-holidays.el --- japanese holidays
;;; LAST UPDATE : 2023/08/15 18:36:38
;;; Commentary:

;;; Code:

(if (> emacs-major-version 24)
    (setq local-holidays nil
        other-holidays nil
        )
    )

(require 'japanese-holidays)
(setq calendar-holidays
    (append japanese-holidays local-holidays other-holidays))
;;; 30-japanese-holidays ends here
