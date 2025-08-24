;;; 00-keybind.el --- keybind
;;; LAST UPDATE : 2025/06/29 22:30:55
;;; Commentary:

;;; Code:

(define-key global-map [(C t)] 'other-window-horizontally)
(define-key global-map [(M t)] 'other-window-vertically)

(define-key global-map [(C c)(r)] 'revert-buffer)

(define-key global-map [(C c)(g)] 'goto-line)

(define-key global-map [(C z)] 'undo)

(define-key global-map [(M z)] 'suspend-emacs)

;; delete-backward-char
(define-key global-map [(C h)] 'delete-backward-char)
;; http://d.hatena.ne.jp/kitokitoki/20090717/p1 参照
(define-key isearch-mode-map [(C h)] 'isearch-delete-char)

;; delete-window (standard keybind [(C x) (0)])
(define-key global-map [(M q)] 'delete-window)
(define-key prog-mode-map [(M q)] 'delete-window)

(define-key global-map [henkan] 'japanese-input-on)
(define-key global-map [muhenkan] 'japanese-input-off)

;; help-command
(define-key global-map [(M \?)] 'help-command)
;;(define-key global-map "\M-s" 'help-for-help)

;; kill-buffer (standard keybind [(C-x) (k)])
(define-key global-map [(M k)] 'kill-buffer)

;; comment-or-uncomment-region
(define-key global-map [(M :)] 'comment-or-uncomment-region)

;; comment-dwim
(define-key global-map [(M \;)] 'comment-dwim)

;; change-fullscreen (same M-x f10)
(global-set-key [f11] 'toggle-frame-maximized)

(electric-pair-mode 1)
;;; 00-keybind.el ends here
