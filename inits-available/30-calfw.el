;;; 30-calfw.el --- calfw
;;; LAST UPDATE : 2023/08/15 18:33:30
;;; Commentary:

;;; Code:

(require 'calfw)

;; Setting alias because, change function name for Emacs23
;; エイリアス の 設定 (Emacs23 で 名前 が 変わった ため)
(unless (fboundp 'calendar-extract-day)
  (defalias 'calendar-extract-day (symbol-function 'extract-calendar-day))
  (defalias 'calendar-extract-month (symbol-function 'extract-calendar-month))
  (defalias 'calendar-extract-year (symbol-function 'extract-calendar-year)))

(set-face-foreground 'cfw:face-holiday "#FFA500") ; orange

(define-key global-map [(C c)(/)] 'cfw:open-howm-calendar)
;;; 30-calfw.el ends here
