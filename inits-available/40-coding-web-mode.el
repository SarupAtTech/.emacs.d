;;; 40-coding-web-mode.el --- web-mode
;;; Commentary:
;;; LAST UPDATE : 2023/08/14 06:58:01

;;; Code:

(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ctp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.blade.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-engines-alist
  '(("php" . "\\.phtml\\'")
     ("blade" . "\\.blade\\.")))

(setq web-mode-engines-snippets
  '(("ejs" . (("for"     . "<% for (|) { %>\n\n<% } %>")
               ("if"      . "<% if (|) { %>\n\n<% } %>")))
     ("erb" . (("each"    . "<% |.each do  %>\n\n<% end %>")
                ("if"      . "<% if | %>\n\n<% end %>")
                ("when"    . "<% when | %>\n\n<% end %>")
                ("unless"  . "<% unless | %>\n\n<% end %>")))
     ("php" . (("if"      . "<?php if (|): ?>\n\n<?php endif; ?>")
                ("while"   . "<?php while (|): ?>\n\n<?php endwhile; ?>")
                ("for"     . "<?php for (| ; ; ): ?>\n\n<?php endfor; ?>")
                ("foreach" . "<?php foreach (| as ): ?>\n\n<?php endforeach; ?>")
                ("each"    . "<?php foreach (| as ): ?>\n\n<?php endforeach; ?>")
                ("switch"  . "<?php switch (|): ?>\n<?php case 1: ?>\n\n<?php break ;?>\n<?php case 2: ?>\n\n<?php break ;?>\n<?php endswitch;?>")))
     ("django" . (("block"      . "{% block | %}\n\n{% endblock %}")
                   ("comment"    . "{% comment | %}\n\n{% endcomment %}")
                   ("cycle"      . "{% cycle | as  %}\n\n{% endcycle  %}")
                   ("filter"     . "{% filter | %}\n\n{% endfilter %}")
                   ("for"        . "{% for | in  %}\n\n{% endfor %}")
                   ("if"         . "{% if | %}\n\n{% endif %}")
                   ("ifequal"    . "{% ifequal | %}\n\n{% endifequal %}")
                   ("ifnotequal" . "{% ifnotequal | %}\n\n{% endifnotequal %}")
                   ("safe"       . "{% safe | %}\n\n{% endsafe %}")))
     ("template-toolkit" . (("if"      . "[% IF | %]\n\n[% END %]")))
     (nil . (("html5" . "<!DOCTYPE html>\n<html lang=\"ja\">\n<head>\n<title></title>\n<meta charset=\"utf-8\" />\n</head>\n<body>\n|\n</body>\n</html>")
              ("table" . "<table><tbody>\n<tr>\n<td>|</td>\n<td></td>\n</tr>\n</tbody></table>")
              ("ul"    . "<ul>\n<li>|</li>\n<li></li>\n</ul>")))))


(add-hook 'web-mode-hook
  #'(lambda ()
      (local-set-key (kbd "<") (smartchr '("<`!!'>" html-braces "<")))
      (local-set-key (kbd "-") (smartchr '("-" "->")))

      ;; Auto-pairing
      (setq web-mode-enable-auto-pairing t)

      ;; CSS colorization
      (setq web-mode-enable-css-colorization t)))
;;; 40-coding-web-mode.el ends here
