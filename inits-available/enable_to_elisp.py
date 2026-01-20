#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# LAST UPDATE : 2026/01/20 16:59:58
import getpass
import platform
from pathlib import Path

if __name__ == "__main__":
    try:
        user_name = getpass.getuser()
        emacs_dir = Path("/home") / user_name / ".emacs.d"
        available_dir = emacs_dir / "inits-available"
        enabled_dir = emacs_dir / "inits-enabled"
        enable_list = available_dir / "enable_list.txt"

        with open(enable_list) as f:
            filenames = [filename.strip() for filename in f.readlines()]

        for filename in filenames:
            if filename.lower().startswith("linux") and platform.system() != "Linux":
                print(f"{filename} different system, skipped.", end="\n")
                continue
            dst = enabled_dir / filename
            src = available_dir / filename
            if not dst.exists():
                dst.symlink_to(src)
                print(f"{filename} link created.", end="\n")
            else:
                print(f"{filename} existed, skipped.", end="\n")
                continue

            if "auctex" in filename:
                latexmkrc_filename = ".latexmkrc"
                latexmkrc = Path("/home") / user_name / latexmkrc_filename

                if not latexmkrc.exists():
                    contents = "\n".join(
                        [
                            r'$kanji    = "-kanji=$ENV{\"LATEXENC\"}" if defined $ENV{"LATEXENC"};',
                            '$latex    = "platex $kanji";',
                            '$bibtex   = "pbibtex $kanji";',
                            '$dvipdf   = "dvipdfmx -o %D %S";',
                            "$pdf_mode = 3;",
                            "",
                        ]
                    )
                    latexmkrc.write_text(contents)
                    print(f"{latexmkrc} created.", end="\n")

    except Exception as e:
        print(e, end="\n")
