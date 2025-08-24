;;; 30-howm.el --- hitori otegaru wiki modoki
;;; LAST UPDATE : 2024/08/12 01:07:33
;;; Commentary:

;;; Code:

(require 'calfw-howm)
(setq-default howm-menu-lang 'ja)
(setq-default howm-directory (concat user-emacs-directory "private/" "howm-data/"))
(setq-default howm-view-keep-one-window t)
(setq-default howm-view-use-grep t)

;; use howm and calendar freamework
;; (defvar my-howm-schedule-page "2012_schedule")
;; (add-to-list 'my-howm-schedule-page "2013_schedule")
;; (add-to-list 'my-howm-schedule-page "2014_schedule")
;; (add-to-list 'my-howm-schedule-page "2015_schedule")

;; open-howm-calendar
(define-key global-map [(C c)(/)] 'cfw:open-howm-calendar)

(defun my-cfw-open-schedule-buffer ()
  (interactive)
  (let*
    ((date (cfw:cursor-to-nearest-date))
      (howm-items
        (howm-folder-grep
          howm-directory
          (regexp-quote (car my-howm-schedule-page)))))
    (cond
      ((null howm-items) ; create
        (howm-create-file-with-title (car my-howm-schedule-page) nil nil nil nil))
      (t
        (howm-view-open-item (car howm-items))))
    (goto-char (point-max))
    (unless (bolp) (insert "\n"))
    (insert
      (format "[%04d-%02d-%02d]@1 "
        (calendar-extract-year date)
        (calendar-extract-month date)
        (calendar-extract-day date)))))

;; うまい具合にいい感じのファイルを開く関数が欲しい
;; iを押したときの日付を見る
;; その日が x年04月01日~x+1年3月31日の範囲以内
;; Hxx_scheduleを返す

;; use calfw-howm
(eval-after-load "howm-menu"
  '(progn
     (require 'calfw-howm)
     (cfw:install-howm-schedules)
     (define-key howm-mode-map (kbd "M-C") 'cfw:open-howm-calendar)
     (define-key cfw:howm-schedule-map (kbd "i") 'my-cfw-open-schedule-buffer)
     (define-key cfw:howm-schedule-inline-keymap (kbd "i") 'my-cfw-open-schedule-buffer)
     ))

(setq cfw:howm-schedule-summary-transformer
  (lambda (line) (split-string (replace-regexp-in-string "^[^@!]+[@!] " "" line) " / ")))

;; (set-face-foreground howm-mode-title-face "#FFD700") ; gold


;; howm-mode
(add-hook 'howm-mode-hook
  #'(lambda()
     (local-set-key (kbd "[") (smartchr '("[`!!']" "[`!!']@" "[`!!']+" "[`!!']!")))
     (local-set-key (kbd "<") (smartchr '(" <<< " " < ")))
     (local-set-key (kbd ">") (smartchr '(" >>> " " > ")))
     ))
;;; 30-howm.el ends here
