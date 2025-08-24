;; LAST UPDATE : 2016/02/09
;; mmm-mode.el

;; use mmm-mode
(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
(mmm-add-mode-ext-class nil "\\.php?\\'" 'html-php)
(mmm-add-classes
'((html-php
   :submode php-mode
   :front "<\\?\\(php\\)?"
   :back "\\?>")))
(add-to-list 'auto-mode-alist '("\\.php?\\'" . html-mode))
