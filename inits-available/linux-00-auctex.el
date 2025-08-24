;; LAST UPDATE : 2016/03/31
;; linux-auctex.el


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; latexMk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(auctex-latexmk-setup)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AUCTeX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'tex-site)
;; (load "auctex.el" nil t t)
;; (load "preview-latex.el" nil t t)

(with-eval-after-load "tex-jp"
  (setq TeX-engine-alist '((pdfuptex "pdfupTeX"
                                     "ptex2pdf -u -e -ot '%S %(mode)'"
                                     "ptex2pdf -u -l -ot '%S %(mode)'"
                                     "euptex")))
  (setq japanese-TeX-engine-default 'pdfuptex)
  ;(setq japanese-TeX-engine-default 'luatex)
  ;(setq japanese-TeX-engine-default 'xetex)
  (setq TeX-view-program-selection '((output-dvi "Evince")
                                     (output-pdf "Evince")))
  ;(setq TeX-view-program-selection '((output-dvi "Okular")
  ;                                   (output-pdf "Okular")))
  ;; (setq japanese-LaTeX-default-style "bxjsarticle")
  (setq japanese-LaTeX-default-style "jsarticle")
  (dolist (command '("pTeX" "pLaTeX" "pBibTeX" "jTeX" "jLaTeX" "jBibTeX" "Mendex"))
    (delq (assoc command TeX-command-list) TeX-command-list)))
(setq preview-image-type 'dvipng)
(setq TeX-source-correlate-method 'synctex)
(setq TeX-source-correlate-start-server t)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook
          (function (lambda ()
                      (add-to-list 'TeX-command-list
                                   '("Latexmk"
                                     "latexmk %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-upLaTeX-pdfdvi"
                                     "latexmk -e '$latex=q/uplatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -e '$dvipdf=q/dvipdfmx %%O -o %%D %%S/' -norc -gg -pdfdvi %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-upLaTeX-pdfdvi"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-upLaTeX-pdfps"
                                     "latexmk -e '$latex=q/uplatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -e '$dvips=q/dvips %%O -z -f %%S | convbkmk -u > %%D/' -e '$ps2pdf=q/ps2pdf %%O %%S %%D/' -norc -gg -pdfps %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-upLaTeX-pdfps"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-pdfLaTeX"
                                     "latexmk -e '$pdflatex=q/pdflatex %%O %S %(mode) %%S/' -e '$bibtex=q/bibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/makeindex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-pdfLaTeX"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-LuaLaTeX"
                                     "latexmk -e '$pdflatex=q/lualatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-LuaLaTeX"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-LuaJITLaTeX"
                                     "latexmk -e '$pdflatex=q/luajitlatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-LuaJITLaTeX"))
                      (add-to-list 'TeX-command-list
                                   '("Latexmk-XeLaTeX"
                                     "latexmk -e '$pdflatex=q/xelatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                     TeX-run-TeX nil (latex-mode) :help "Run Latexmk-XeLaTeX"))
                      (add-to-list 'TeX-command-list
                                   '("xdg-open"
                                     "xdg-open %s.pdf"
                                     TeX-run-discard-or-function t t :help "Run xdg-open"))
                      (add-to-list 'TeX-command-list
                                   '("Evince"
                                     "evince %s.pdf"
                                     TeX-run-discard-or-function t t :help "Run Evince"))
                      (add-to-list 'TeX-command-list
                                   '("fwdevince"
                                     "fwdevince %s.pdf %n \"%b\""
                                     TeX-run-discard-or-function t t :help "Forward search with Evince"))
                      (add-to-list 'TeX-command-list
                                   '("Okular"
                                     "okular --unique \"file:\"%s.pdf\"#src:%n %a\""
                                     TeX-run-discard-or-function t t :help "Forward search with Okular"))
                      (add-to-list 'TeX-command-list
                                   '("zathura"
                                     "zathura -s -x \"emacsclient --no-wait +%%{line} %%{input}\" %s.pdf"
                                     TeX-run-discard-or-function t t :help "Run zathura"))
                      (add-to-list 'TeX-command-list
                                   '("fwdzathura"
                                     "zathura --synctex-forward %n:0:%b %s.pdf"
                                     TeX-run-discard-or-function t t :help "Forward search with zathura"))
                      (add-to-list 'TeX-command-list
                                   '("qpdfview"
                                     "qpdfview --unique \"\"%s.pdf\"#src:%b:%n:0\""
                                     TeX-run-discard-or-function t t :help "Forward search with qpdfview"))
                      (add-to-list 'TeX-command-list
                                   '("TeXworks"
                                     "synctex view -i \"%n:0:%b\" -o %s.pdf -x \"texworks --position=%%{page+1} %%{output}\""
                                     TeX-run-discard-or-function t t :help "Run TeXworks"))
                      (add-to-list 'TeX-command-list
                                   '("TeXstudio"
                                     "synctex view -i \"%n:0:%b\" -o %s.pdf -x \"texstudio --pdf-viewer-only --page %%{page+1} %%{output}\""
                                     TeX-run-discard-or-function t t :help "Run TeXstudio"))
                      (add-to-list 'TeX-command-list
                                   '("MuPDF"
                                     "mupdf %s.pdf"
                                     TeX-run-discard-or-function t t :help "Run MuPDF"))
                      (add-to-list 'TeX-command-list
                                   '("Firefox"
                                     "firefox -new-window %s.pdf"
                                     TeX-run-discard-or-function t t :help "Run Mozilla Firefox"))
                      (add-to-list 'TeX-command-list
                                   '("Chromium"
                                     "chromium --new-window %s.pdf"
                                     TeX-run-discard-or-function t t :help "Run Chromium")))))

;;
;; RefTeX with AUCTeX
;;
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;;
;; kinsoku.el
;;
(setq kinsoku-limit 10)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq auto-mode-alist
      (append '(
		("\\.tex$" . japanese-latex-mode)
		("\\.ltx$" . japanese-latex-mode)
		)
	      auto-mode-alist))
(setq tex-default-mode 'japanese-latex-mode)

;; latex-mode
(add-hook 'LaTeX-mode-hook
	  '(lambda()
	     (flymake-mode-off)
	     (local-unset-key (kbd "\C-w"))
	     (setq tex-default-mode 'japanese-latex-mode)
	     (setq japanese-LaTeX-default-style "jsarticle")
	     ))
