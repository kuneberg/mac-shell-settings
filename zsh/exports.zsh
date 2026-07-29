# Environment variables for interactive shells.

export EDITOR="micro"
export VISUAL="micro"

# micro — enable true color so the terra colorscheme is exact
export MICRO_TRUECOLOR=1
export PAGER="less"
export LESS="-RFX"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

# bat — gruvbox-dark is the closest built-in theme to the terra palette
export BAT_STYLE="numbers,changes,header"
export BAT_THEME="gruvbox-dark"

# eza
export EZA_ICONS_AUTO=1
# README/Makefile ("build files") bold yellow without eza's default underline,
# matching yazi's filetype rules
export EZA_COLORS="bu=1;33"

# fzf — use fd, follow symlinks, respect .gitignore; Terra colors
# (accents from the starship terra palette, bg transparent -> terminal)
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="\
--height=60% --layout=reverse --border --info=inline \
--color=bg:-1,bg+:#3c4a3e,fg:#e8d7d0,fg+:#f5ede4 \
--color=hl:#edc27a,hl+:#f4d49a,border:#303a31 \
--color=prompt:#859e89,pointer:#f77d5b,marker:#f77d5b \
--color=spinner:#f77d5b,info:#a89a8f,header:#a89a8f"
