;;; 00-function.el --- function
;;; LAST UPDATE : 2023/08/15 18:24:36
;;; Commentary:

;; http://d.hatena.ne.jp/khiker/20090711/emacsfullscreen 参考

;;; Code:

(defun change-fullscreen ()
  (interactive)
  (let ((fullscreen (frame-parameter (selected-frame) 'fullscreen)))
    (cond
      ((null fullscreen)
        (set-frame-parameter (selected-frame) 'fullscreen 'fullboth))
      (t
        (set-frame-parameter (selected-frame) 'fullscreen 'nil))))
  (redisplay))

;; http://d.hatena.ne.jp/rubikitch/20100210/emacs 参考

;; other-window
(defun other-window-horizontally ()
  (interactive)
  (if (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(defun other-window-vertically ()
  (interactive)
  (if (one-window-p)
    (split-window-vertically))
  (other-window -1))

(defun non-linum-open-calfw ()
  (interactive)
  (let ((cp (cfw:create-calendar-component-buffer
              :custom-map cfw:howm-schedule-map
              :view 'month
              :contents-sources (append (list (cfw:howm-create-source))
                                  cfw:howm-schedule-contents)
              :annotation-sources cfw:howm-annotation-contents))
         (linum-mode -1))
    (switch-to-buffer (cfw:cp-get-buffer cp)))
  )

;; http://d.hatena.ne.jp/kitokitoki/20101205/p1 を参考
(defun init-loader-re-load (re dir &optional sort)
  (let ((load-path (cons dir load-path)))
    (dolist (el (init-loader--re-load-files re dir sort))
      (condition-case e
        (let ((time (car (benchmark-run (load (file-name-sans-extension el))))))
          (init-loader-log (format "loaded %s. %s" (locate-library el) time)))
        (error
          ;; (init-loader-error-log (error-message-string e))
          (init-loader-error-log (format "%s. %s"(locate-library el)
                                   (error-message-string e))))
        ))))
;;; 00-function.el ends here
