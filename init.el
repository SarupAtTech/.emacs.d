;;; initl.el --- init.el
;;; Commentary:
;; LAST UPDATE : 2025/07/08 11:26:03

;;; Code:
(add-to-list 'load-path "~/.emacs.d/elisp/")

;; straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(straight-use-package
  '(anzu
     :type git
     :host github
     :repo "emacsorphanage/anzu"
     :tag "0.67"))

(straight-use-package
  '(blacken
     :type git
     :host github
     :repo "pythonic-emacs/blacken"
     :tag "v0.2.0"))

(straight-use-package
  '(browse-kill-ring
     :type git
     :host github
     :repo "browse-kill-ring/browse-kill-ring"
     :tag "2.0.0"))

(straight-use-package
  '(calfw
     :type git
     :host github
     :repo "kiwanami/emacs-calfw"
     :tag "v1.6"))

(straight-use-package
  '(calfw-howm
     :type git
     :host github
     :repo "kiwanami/emacs-calfw"
     :tag "bcfc0c546c3c58e1f635a9a29efdf56c9421a3ce"))

(straight-use-package
  '(company
     :type git
     :host github
     :repo "company-mode/company-mode"
     :tag "1.0.2"))

(straight-use-package
  '(copilot-chat
     :type git
     :host github
     :repo "chep/copilot-chat.el"
     :tag "v3.0.0"))

(straight-use-package
  '(ddskk
     :type git
     :host github
     :repo "skk-dev/ddskk"
     :tag "ddskk-16.3_Kutomatsunai"))

(straight-use-package
  '(dotenv-mode
     :type git
     :host github
     :repo "preetpalS/emacs-dotenv-mode"
     :tag "v0.2.5"))

(straight-use-package
  '(e2wm
     :type git
     :host github
     :repo "kiwanami/emacs-window-manager"
     :tag "v1.4"))

(straight-use-package
  '(emojify
     :type git
     :host github
     :repo "iqbalansari/emacs-emojify"
     :tag "v1.2"))

(straight-use-package
  '(flycheck
     :type git
     :host github
     :repo "flycheck/flycheck"
     :tag "v35.0"))

(straight-use-package
  '(flycheck-eglot
     :type git
     :host github
     :repo "flycheck/flycheck-eglot"
     :commit "0d7f0afc9bf08fce4a3ee225ec6540a91f8cfd76"))

(straight-use-package
  '(flycheck-posframe
     :type git
     :host github
     :repo "alexmurray/flycheck-posframe"
     :commit "19896b922c76a0f460bf3fe8d8ebc2f9ac9028d8"))

(straight-use-package
  '(howm
     :type git
     :host github
     :repo "kaorahi/howm"
     :tag "1.5.4"))

(straight-use-package
  '(init-loader
     :type git
     :host github
     :repo "emacs-jp/init-loader"
     :tag "0.02"))

(straight-use-package
  '(japanese-holidays
     :type git
     :host github
     :repo "komem3/japanese-holidays"
     :commit "b2fe3aec4f114d1c12ced6a9d53da18332b21416"))

(straight-use-package
  '(js2-mode
     :type git
     :host github
     :repo "mooz/js2-mode"
     :commit "e0c302872de4d26a9c1614fac8d6b94112b96307"))

(straight-use-package
  '(json-mode
     :type git
     :host github
     :repo "json-emacs/json-mode"
     :tag "v1.9.2"))

(straight-use-package
  '(magit
     :type git
     :host github
     :repo "magit/magit"
     :tag "v4.3.6"))

(straight-use-package
  '(markdown-mode
     :type git
     :host github
     :repo "jrblevin/markdown-mode"
     :tag "v2.7"))

(straight-use-package
  '(mew
     :type git
     :host github
     :repo "kazu-yamamoto/Mew"
     :tag "c46d8ee784d098244abaf162660073d1d4787b60"))

(straight-use-package
  '(migemo
     :type git
     :host github
     :repo "emacs-jp/migemo"
     :commit "c0d84b4092ddade01110ba875559bfd454862ac2"))

(straight-use-package
  '(mmm
     :type git
     :host github
     :repo "dgutov/mmm-mode"
     :tag "0.5.11"))

(straight-use-package
  '(multi-term
     :type git
     :host github
     :repo "manateelazycat/multi-term"
     :commit "017c77c550115936860e2ea71b88e585371475d5"))

(straight-use-package
  '(neotree
     :type git
     :host github
     :repo "jaypei/emacs-neotree"
     :tag "0.6.0"))

(straight-use-package
  '(php-mode
     :type git
     :host github
     :repo "emacs-php/php-mode"
     :tag "v1.27.0"))

(straight-use-package
  '(pinentry
     :type git
     :host github
     :repo "ueno/pinentry-el"
     :commit "0079964a1dde954ccb2ce8a28613d8020c549a36"))

(straight-use-package
  '(py-isort
     :type git
     :host github
     :repo "paetzke/py-isort.el"
     :tag "v2016.1"))

(straight-use-package
  '(rainbow-mode
     :type git
     :host github
     :repo "emacsmirror/rainbow-mode"
     :commit "f7db3b5919f70420a91eb199f8663468de3033f3"))

(straight-use-package
  '(roguel-ike
     :type git
     :host github
     :repo "stevenremot/roguel-ike"
     :tag "0.1.3"))

(straight-use-package
  '(smartchr
     :type git
     :host github
     :repo "imakado/emacs-smartchr"
     :commit "658f6ff3527aa364abc87c426fe1984e376f385d"))

(straight-use-package
  '(smart-compile
     :type git
     :host github
     :repo "zenitani/elisp"
     :commit "614407246d71924d3156a337d0879f04691060d5"))

(straight-use-package
  '(undo-tree
     :type git
     :host gitlab
     :repo "tsc25/undo-tree"
     :tag "0.8.1"))

(straight-use-package
  '(undohist
     :type git
     :host github
     :repo "emacsorphanage/undohist"
     :tag "0.3.0"))

(straight-use-package
  '(w3m
     :type git
     :host github
     :repo "emacs-w3m/emacs-w3m"
     :commit "fc0f30f96a69bae4d4c92f42bceafb8ccf2a72ec"))

(straight-use-package
  '(web-mode
     :type git
     :host github
     :repo "fxbois/web-mode"
     :tag "v17.3.20"))

(straight-use-package
  '(windows
     :type git
     :host github
     :repo "conao3/emacs-windows.el"
     :commit "15e2d3ed888c173369b1d6bfc9868961cdeecb35"))

(straight-use-package
  '(yasnippet
     :type git
     :host github
     :repo "joaotavora/yasnippet"
     :tag "0.14.0"))

(straight-use-package
  '(yaml-mode
     :type git
     :host github
     :repo "yoshiki/yaml-mode"
     :tag "0.0.16"))

(init-loader-load "~/.emacs.d/inits-enabled")

;;; init.el ends here
