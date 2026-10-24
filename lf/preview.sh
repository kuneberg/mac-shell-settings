#!/bin/sh
# lf previewer: bat for text (Nord theme from exports.zsh), archive listings,
# a one-line description for everything else. Args: file width height x y.
f="$1"; w="${2:-80}"

case "$f" in
  *.tar|*.tar.gz|*.tgz|*.tar.bz2|*.tbz2|*.tar.xz|*.tar.zst)
    tar tf "$f" 2>/dev/null | head -200; exit 0 ;;
  *.zip)
    unzip -l "$f" 2>/dev/null | head -200; exit 0 ;;
esac

case "$(file -Lb --mime-type -- "$f")" in
  text/*|application/json|application/javascript|application/xml|application/x-sh|application/x-shellscript|inode/x-empty)
    bat --color=always --style=numbers --paging=never --wrap=never --terminal-width="$w" -- "$f" ;;
  *)
    file -Lb -- "$f" ;;
esac
