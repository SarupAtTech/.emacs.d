;;; 30-japanese-holidays.el --- japanese holidays  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:14:13
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
