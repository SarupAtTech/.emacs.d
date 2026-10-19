;;; 30-browse-kill-ring.el --- browse kill ring  -*- lexical-binding: t; -*-
;;; LAST UPDATE : 2026/10/09 10:13:29
;;; Commentary:

;;; Code:

(require 'browse-kill-ring)
(define-key global-map [(C c)(k)] 'browse-kill-ring)
(define-key global-map [(M y)] 'browse-kill-ring)
;;; 30-browse-kill-ring.el ends here
