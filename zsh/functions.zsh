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

# lf — file manager that can leave the shell in the directory you picked.
# Enter on a directory quits into it (lfrc's enter-or-open writes the path
# to $LF_CD_FILE); q / Esc quit and the shell stays where it was.
lf() {
	local tmp dir
	tmp="$(mktemp -t "lf-cd.XXXXXX")"
	LF_CD_FILE="$tmp" command lf "$@"
	dir="$(<"$tmp")"
	[ -n "$dir" ] && [ -d "$dir" ] && [ "$dir" != "$PWD" ] && builtin cd -- "$dir"
	command rm -f -- "$tmp"
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
