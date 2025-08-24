;;; 30-browse-kill-ring.el --- browse kill ring
;;; LAST UPDATE : 2023/08/15 18:32:46
;;; Commentary:

;;; Code:

(require 'browse-kill-ring)
(define-key global-map [(C c)(k)] 'browse-kill-ring)
(define-key global-map [(M y)] 'browse-kill-ring)
;;; 30-browse-kill-ring.el ends here
