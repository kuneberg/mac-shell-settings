# Environment variables for interactive shells.

export EDITOR="micro"
export VISUAL="micro"

# Claude Code rewrites the terminal title while it runs; keep the
# "dir | claude" title from zsh/zshrc instead.
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1

# micro — enable true color so the srcery colorscheme is exact
export MICRO_TRUECOLOR=1
export PAGER="less"
export LESS="-RFX"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

# bat — srcery is a gruvbox derivative, so gruvbox-dark is the closest built-in theme
export BAT_STYLE="numbers,changes,header"
export BAT_THEME="gruvbox-dark"

# eza
export EZA_ICONS_AUTO=1
# README/Makefile ("build files") bold yellow without eza's default underline,
# matching lf's colors file
export EZA_COLORS="bu=1;33"

# fzf — use fd, follow symlinks, respect .gitignore; Srcery colors
# (accents from the starship srcery palette, bg transparent -> terminal)
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="\
--height=60% --layout=reverse --border --info=inline \
--color=bg:-1,bg+:#3a3a3a,fg:#fce8c3,fg+:#fce8c3 \
--color=hl:#ff5f00,hl+:#ff5f00,border:#3a3a3a \
--color=prompt:#68a8e4,pointer:#fbb829,marker:#fbb829 \
--color=spinner:#fbb829,info:#918175,header:#918175"
