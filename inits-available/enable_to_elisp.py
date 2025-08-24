#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# LAST UPDATE : 2025/08/25 07:08:16
import getpass
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
            dst = enabled_dir / filename
            src = available_dir / filename
            if not dst.exists():
                dst.symlink_to(src)
                print(f"{filename} link created.", end="\n")
            else:
                print(f"{filename} existed, skipped.", end="\n")

    except Exception as e:
        print(e, end="\n")
