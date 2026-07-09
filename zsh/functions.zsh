# Small shell functions.

# mkcd <dir> — create a directory (and parents) and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# up [n] — go up n directories (default 1)
up() {
  local n="${1:-1}" dir=""
  while (( n-- > 0 )); do dir+="../"; done
  cd "${dir:-.}"
}

# yy — yazi that leaves the shell in yazi's last directory
yy() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  cwd="$(<"$tmp")"
  rm -f -- "$tmp"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd -- "$cwd"
}

# extract <archive> — unpack common archive formats
extract() {
  [[ -f "$1" ]] || { print -u2 "extract: '$1' is not a file"; return 1 }
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz)         tar xJf "$1" ;;
    *.tar.zst)        tar --zstd -xf "$1" ;;
    *.tar)            tar xf "$1" ;;
    *.zip)            unzip "$1" ;;
    *.gz)             gunzip -k "$1" ;;
    *.bz2)            bunzip2 -k "$1" ;;
    *.7z)             7z x "$1" ;;
    *)                print -u2 "extract: don't know how to extract '$1'"; return 1 ;;
  esac
}

# fkill — fuzzy-pick a process and terminate it
fkill() {
  local pid
  pid="$(ps -eo pid,pcpu,pmem,comm | sed 1d | fzf --header='select process to kill' | awk '{print $1}')"
  [[ -n "$pid" ]] && kill "$pid"
}
