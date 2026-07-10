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
export BAT_THEME="Dracula"

# eza
export EZA_ICONS_AUTO=1

# fzf — use fd, follow symlinks, respect .gitignore; Amethyst colors
# (accents from the starship amethyst palette, bg transparent -> terminal)
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="\
--height=60% --layout=reverse --border --info=inline \
--color=bg:-1,bg+:#372a5e,fg:#cdd6f4,fg+:#f2ebff \
--color=hl:#a78bfa,hl+:#c4b1fa,border:#2e2a44 \
--color=prompt:#a78bfa,pointer:#6e43c4,marker:#6e43c4 \
--color=spinner:#6e43c4,info:#8a84a8,header:#8a84a8"
