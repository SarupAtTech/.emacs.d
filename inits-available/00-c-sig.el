;;; 00-c-sig.el --- c-sig
;;; LAST UPDATE : 2023/08/15 20:28:47
;;; Commentary:

;; http://www.sie.ics.saitama-u.ac.jp/install/c-sig.html 参考

;;; Code:

(defvar sig-alist-file (concat user-emacs-directory "private/" "c-sig.alist"))

(load-library "c-sig")
;; (autoload 'add-signature "c-sig" "c-sig" t)
;; (autoload 'delete-signature "c-sig" "c-sig" t)
;; (autoload 'insert-signature-eref "c-sig" "c-sig" t) ; 対話的に選択する
;; (autoload 'insert-signature-automatically "c-sig" "c-sig" t)	    ; データベースからの検索結果に従って自動的に挿入する
;; (autoload 'insert-signature-randomly "c-sig" "c-sig" t)		    ; ランダムに挿入する.
;;; 00-c-sig.el ends here
