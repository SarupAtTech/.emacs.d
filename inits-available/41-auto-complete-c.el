;; LAST UPDATE : 2015/12/07
;; auto-complete-c.el

;; http://fukuyama.co/emacs-auto-complete
;; http://dev.ariel-networks.com/wp/documents/aritcles/emacs/part9
;; http://dev.ariel-networks.com/wp/documents/aritcles/emacs/part10
;; 辺りを参考


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; /usr/include setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun list-system-header-files ()
    (directory-files "/usr/include" nil "^.*\\.h$"))

(defvar system-header-files-cache (list-system-header-files))

(defvar ac-source-system-header-files
    '(
         (candidates . system-header-files-cache)
         ;; (candidates . list-system-header-files)
         (prefix . "#include *<\\([^>]*\\)"))
    )

(defun list-system-network-header-files ()
    (directory-files "/usr/include/linux" nil "^.*\\.h$"))

(defvar system-network-header-files-cache (list-system-network-header-files))

(defvar ac-source-system-network-header-files
    '(
         (candidates . system-network-header-files-cache)
         ;; (candidates . list-system-header-files)
         (prefix . "#include *<\\([^>]*\\)"))
    )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; header file setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ファイル名を渡すといい感じに辞書にしてくれる
(defun create-call-auto-complete-dictionary (filename)
    (let ((fullpath (concat "~/.emacs.d/private/ac-dict/" filename)))
        (load-auto-complete-dictionary fullpath)
        ))

;; ヘッダ名(stdioなど)を渡す
;; 1:スペースがある場合
;; 2:先頭から始まる場合
;; if文の条件は正直微妙．
;; せめてヘッダファイルが自作?のヘッダファイルだった場合，
;; 同じディレクトリのそのヘッダファイルを見るぐらいはするべきだと思う
;; ↑ 見るようにした．

(defun ac-c-library-prefix (mode libname)
    (cond ((string= mode "space")
              (if (string-match (concat "^#include <" libname "\\.h>") (buffer-string))
                  ;; (if (ac-c-library-prefix-search-header libname)
                  (cond ((re-search-backward "\\s-\\(.*\\)" nil t)
                            (match-beginning 1)))
                  )
              )
        ((string= mode "head")
            (if (string-match (concat "^#include <" libname "\\.h>") (buffer-string))
                ;; (if (ac-c-library-prefix-search-header libname)
                (cond ((re-search-backward "^\\(.*\\)" nil t)
                          (match-beginning 1)))
                )
            )
        )
    )


;; 条件的には以下の条件のとき真を返す(はず)
;; #include< libname >
;; #include"自作ヘッダ" 内に #include < libname >
;; ↑2015/12/06
;; バグを発見(error out-of-range がでる)

(defun ac-c-library-prefix-search-header (libname)
    ;; (let* ((target_data (buffer-substring-no-properties (point-min) (point-max)))
    (let* ((target_data (buffer-substring-no-properties (point-min) (point-max)))
              (start_num_list (list (string-match "^#include \".*\"" target_data)))
              (end_num_list
                  (list (string-match "^#include \".*\".*\n" target_data (match-end 0))))
              (tmp_num (match-end 0))
              (filename_list)
              (retval)
              )
        (cond ((string-match (concat "^#include <" libname "\\.h>") (buffer-string))
                  (setq retval t))

            ((car start_num_list)
                ;; #include "header.h" となる 開始点と終点を取得する
                (while tmp_num
                    (if (string-match "^#include \".*\"" target_data tmp_num)
                        (progn
                            (add-to-list 'start_num_list
                                (string-match "^#include \".*\"" target_data tmp_num))
                            (add-to-list 'end_num_list
                                (string-match "\n" target_data tmp_num))
                            )
                        )
                    (setq tmp_num (string-match "^#include \".*\""
                                      target_data (match-end 0)))
                    )

                ;; ヘッダファイル名の取得
                (while start_num_list
                    (add-to-list 'filename_list
                        (car (cdr (split-string
                                      (substring target_data
                                          (car start_num_list)
                                          (car end_num_list)) "\""))))
                    (setq start_num_list (cdr start_num_list))
                    (setq end_num_list (cdr end_num_list))
                    )

                ;; ファイル内にあるか確認
                (while filename_list
                    (if (file-exists-p (car filename_list))
                        (progn
                            (with-temp-buffer
                                (insert-file-contents (car filename_list))
                                (buffer-substring-no-properties (point-min) (point-max))
                                (setq retval (buffer-string))
                                )
                            (if (string-match
                                    (concat "^#include <" libname "\\.h>") retval)
                                (setq retval t)
                                (setq retval nil))
                            ))
                    (setq filename_list (cdr filename_list))
                    )
                ))
        retval
        )
    )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; each library setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar ac-source-c-stdio-space
    '((candidates . (create-call-auto-complete-dictionary "c-stdio-dict"))
         (prefix . (ac-c-library-prefix "space" "stdio"))
         (symbol . "stdio.h")
         ))

(defvar ac-source-c-stdio-head
    '((candidates . (create-call-auto-complete-dictionary "c-stdio-dict"))
         (prefix . (ac-c-library-prefix "head" "stdio"))
         (symbol . "stdio.h")
         ))

(defvar ac-source-c-stdlib-space
    '((candidates . (create-call-auto-complete-dictionary "c-stdlib-dict"))
         (prefix . (ac-c-library-prefix "space" "stdlib"))
         (symbol . "stdlib.h")
         ))

(defvar ac-source-c-stdlib-head
    '((candidates . (create-call-auto-complete-dictionary "c-stdlib-dict"))
         (prefix . (ac-c-library-prefix "head" "stdlib"))
         (symbol . "stdlib.h")
         ))

(defvar ac-source-c-math-space
    '((candidates . (create-call-auto-complete-dictionary "c-math-dict"))
         (prefix . (ac-c-library-prefix "space" "math"))
         (symbol . "math.h")
         ))

(defvar ac-source-c-math-head
    '((candidates . (create-call-auto-complete-dictionary "c-math-dict"))
         (prefix . (ac-c-library-prefix "head" "math"))
         (symbol . "math.h")
         ))

(defvar ac-source-c-tgmath-space
    '((candidates . (create-call-auto-complete-dictionary "c-tgmath-dict"))
         (prefix . (ac-c-library-prefix "space" "math"))
         (symbol . "math.h")
         ))

(defvar ac-source-c-tgmath-head
    '((candidates . (create-call-auto-complete-dictionary "c-tgmath-dict"))
         (prefix . (ac-c-library-prefix "head" "math"))
         (symbol . "math.h")
         ))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hook setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'c-mode-common-hook
    '(lambda()
         (add-to-list 'ac-sources ac-source-system-header-files)
         (add-to-list 'ac-sources ac-source-c-stdio-space)
         (add-to-list 'ac-sources ac-source-c-stdio-head)
         (add-to-list 'ac-sources ac-source-c-stdlib-space)
         (add-to-list 'ac-sources ac-source-c-stdlib-head)
         (add-to-list 'ac-sources ac-source-c-math-space)
         (add-to-list 'ac-sources ac-source-c-math-head)
         (add-to-list 'ac-sources ac-source-c-tgmath-space)
         (add-to-list 'ac-sources ac-source-c-tgmath-head)

         ))
