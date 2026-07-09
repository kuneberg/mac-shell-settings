# Environment variables for interactive shells.

export EDITOR="${EDITOR:-vim}"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-RFX"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

# bat
export BAT_STYLE="numbers,changes,header"
export BAT_THEME="gruvbox-dark"

# eza
export EZA_ICONS_AUTO=1

# fzf — use fd, follow symlinks, respect .gitignore; Gruvbox Dark colors
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="\
--height=60% --layout=reverse --border --info=inline \
--color=bg+:#3c3836,bg:#282828,spinner:#fb4934,hl:#928374 \
--color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934 \
--color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"
