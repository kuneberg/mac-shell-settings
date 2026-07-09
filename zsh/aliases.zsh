# Aliases. Only active in interactive shells — scripts are unaffected.

# eza — modern ls
alias ls='eza'
alias ll='eza -la --git'
alias la='eza -la'
alias lt='eza --tree --level=2'
alias tree='eza --tree'

# Modern replacements
alias cat='bat'
alias find='fd'
alias grep='rg'
alias du='dust'
alias df='duf'
alias top='btop'
alias dig='doggo'

# git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate -20'
alias lg='lazygit'

# docker
alias lzd='lazydocker'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Quality of life
alias reload='exec zsh'
alias dotfiles='cd "$HOME/.dotfiles"'
alias brewup='brew update && brew upgrade && brew cleanup'
