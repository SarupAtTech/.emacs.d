;;; 29-smart-chr.el --- smartchr.el
;;; LAST UPDATE : 2025/06/30 00:18:54
;;; Commentary:

;;; Code:

(require 'smartchr)

;; (global-set-key (kbd "|") (smartchr '(" | " " || " "|")))
(global-set-key (kbd "\　") (smartchr '(" ")))
(global-set-key (kbd "=") (smartchr '("=" " = " " == " " != " " += " " -= ")))
(global-set-key (kbd "<") (smartchr '(" < " " <= " "<`!!'>" "<")))
(global-set-key (kbd ">") (smartchr '(" > " " >= " ">")))
(global-set-key (kbd ",") (smartchr '(", " ",")))

(defun indent-braces ()
"Indent braces."
"{`!!'
}")

(defun go-indent-braces ()
"Go lang indent braces."
"{
`!!'
}"
)

(defun c-arrow ()
"C lang arrow."
"->`!!'")

(defun c-define ()
"C lang define."
"#define `!!'")

(defun c-include-01 ()
"C lang include pattern 1."
"#include <`!!'>")

(defun c-include-02 ()
"C lang include pattern 2."
"#include \"`!!'\"")

(defun perl-smartchr:sub ()
"Perl lang sub."
"sub `!!' {
    my ($self) = @_;


}")

(defun html-braces ()
"HTML braces."
"&lt;`!!'&gt;")

(defun latex-parbox ()
"LaTex parbox."
"\\parbox{`!!'zw}{}")
;;; 29-smart-chr.el ends here
