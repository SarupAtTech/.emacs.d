;; LAST UPDATE : 2023/08/14 04:08:09
;; perl-mode
(add-hook 'perl-mode-hook
  '(lambda()
     (local-set-key (kbd ">") (smartchr '(">" " => " " => '`!!''" " => \"`!!'\"")))
     (local-set-key (kbd "D") (smartchr '("$" "$_" "$_->" "@$" "D")))
     (local-set-key (kbd "M") (smartchr '("M" "my $`!!' = "
                                           "my %`!!' = "
                                           "my ($self, $`!!') = @_;"
                                           "my @`!!' = ")))
     (local-set-key (kbd "P") (smartchr '("print \"`!!'\"" "print \'`!!'\'" "P")))
     (local-set-key (kbd "S") (smartchr '("S" perl-smartchr:sub
                                           "sub { `!!' }")))
     ))
