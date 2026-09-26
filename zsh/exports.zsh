# Environment variables for interactive shells.

export EDITOR="micro"
export VISUAL="micro"

# Claude Code rewrites the terminal title while it runs; keep the
# "dir | claude" title from zsh/zshrc instead.
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1

# micro — enable true color so the gotham colorscheme is exact
export MICRO_TRUECOLOR=1
export PAGER="less"
export LESS="-RFX"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

# bat — Nord is the closest built-in theme to the gotham palette
export BAT_STYLE="numbers,changes,header"
export BAT_THEME="Nord"

# eza
export EZA_ICONS_AUTO=1
# README/Makefile ("build files") bold yellow without eza's default underline,
# matching yazi's filetype rules
export EZA_COLORS="bu=1;33"

# fzf — use fd, follow symlinks, respect .gitignore; Gotham colors
# (accents from the starship gotham palette, bg transparent -> terminal)
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="\
--height=60% --layout=reverse --border --info=inline \
--color=bg:-1,bg+:#0a3749,fg:#99d1ce,fg+:#d3ebe9 \
--color=hl:#edb443,hl+:#edb443,border:#0a3749 \
--color=prompt:#599cab,pointer:#33859e,marker:#33859e \
--color=spinner:#33859e,info:#599cab,header:#599cab"
