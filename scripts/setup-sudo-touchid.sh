#!/usr/bin/env bash
#
# setup-sudo-touchid.sh — let sudo authenticate with Touch ID (pam_tid).
#
# Installs sudo/sudo_local as the root-owned /etc/pam.d/sudo_local, which
# macOS (Sonoma and newer) includes from /etc/pam.d/sudo and preserves
# across OS updates. /etc/pam.d/sudo itself is never edited. The file is
# copied, not symlinked: PAM config must be owned by root, and a link into
# $HOME would let anything running as you change how sudo authenticates.
#
# Not run by install.sh — it asks for your password once (for sudo), so
# run it explicitly:
#   ./scripts/setup-sudo-touchid.sh           install or update
#   ./scripts/setup-sudo-touchid.sh --check   report status only, no sudo
#
# Idempotent and preserving: an existing sudo_local is backed up, then the
# template's commented "#auth ... pam_tid.so" line is uncommented or the
# line is appended — every other line (e.g. pam_reattach) is kept. New
# content is validated before it is installed, so a typo can never leave
# sudo with a broken PAM file.

set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

SRC="$DOTFILES_DIR/sudo/sudo_local"
# Overridable so the logic can be exercised against scratch files in tests.
SUDO_LOCAL="${DOTFILES_SUDO_LOCAL:-/etc/pam.d/sudo_local}"
PAM_SUDO="${DOTFILES_PAM_SUDO:-/etc/pam.d/sudo}"
PAM_MODULE_DIR="/usr/lib/pam"

TID_LINE='auth       sufficient     pam_tid.so'
# Any active pam_tid rule counts as enabled, whatever its control flag.
TID_RE='^[[:space:]]*auth[[:space:]]+(sufficient|required|requisite|optional|binding|\[[^]]+\])[[:space:]]+pam_tid\.so([[:space:]]|$)'
TID_COMMENTED_RE='^[[:space:]]*#[[:space:]]*auth[[:space:]]+sufficient[[:space:]]+pam_tid\.so([[:space:]]|$)'
# One PAM rule: type, control (keyword or [value=action] form), module, args
PAM_RULE_RE='^[[:space:]]*(auth|account|password|session)[[:space:]]+(required|requisite|sufficient|optional|binding|include|\[[^]]+\])[[:space:]]+[^[:space:]]+'

check_only=false
case "${1:-}" in
  --check) check_only=true ;;
  "") ;;
  *) error "usage: $0 [--check]"; exit 2 ;;
esac

# Root is only needed for the real /etc/pam.d; a writable test dir skips sudo.
need_root=true
[[ $EUID -eq 0 || -w "$(dirname "$SUDO_LOCAL")" ]] && need_root=false
as_root() { if $need_root; then sudo "$@"; else "$@"; fi; }

# validate_pam <file> — every non-comment line must be a well-formed rule
validate_pam() {
  local bad
  bad="$(grep -Ev '^[[:space:]]*(#|$)' "$1" | grep -Ev "$PAM_RULE_RE" || true)"
  if [[ -n "$bad" ]]; then
    error "malformed PAM line(s) in $1:"
    printf '      %s\n' "$bad" >&2
    return 1
  fi
  return 0
}

# ------------------------------------------------------------ preconditions --
[[ "$(uname -s)" == "Darwin" ]] || { error "macOS only"; exit 1; }
if [[ ! -e "$PAM_MODULE_DIR/pam_tid.so" && ! -e "$PAM_MODULE_DIR/pam_tid.so.2" ]]; then
  error "pam_tid module not found in $PAM_MODULE_DIR — this Mac has no Touch ID support"
  exit 1
fi
if ! grep -Eqs '^[[:space:]]*auth[[:space:]]+include[[:space:]]+sudo_local' "$PAM_SUDO"; then
  error "$PAM_SUDO does not include sudo_local (needs macOS 14 Sonoma or newer)."
  error "Not editing $PAM_SUDO: macOS overwrites it on every update."
  exit 1
fi
validate_pam "$SRC" || exit 1

# ---------------------------------------------------------------- status --
state=missing   # missing | enabled | commented | present
current=""
if [[ -e "$SUDO_LOCAL" ]]; then
  if [[ -r "$SUDO_LOCAL" ]]; then
    current="$(cat "$SUDO_LOCAL")"
  elif $check_only; then
    error "$SUDO_LOCAL exists but is not readable — rerun without --check"; exit 1
  else
    current="$(as_root cat "$SUDO_LOCAL")"
  fi
  if   grep -Eq "$TID_RE"           <<<"$current"; then state=enabled
  elif grep -Eq "$TID_COMMENTED_RE" <<<"$current"; then state=commented
  else                                                   state=present
  fi
fi

case "$state" in
  enabled)   success "Touch ID for sudo already enabled: $SUDO_LOCAL" ;;
  missing)   info "$SUDO_LOCAL does not exist yet" ;;
  commented) info "$SUDO_LOCAL has pam_tid commented out (template copy)" ;;
  present)   info "$SUDO_LOCAL exists without pam_tid — line will be appended" ;;
esac

if $check_only; then
  [[ "$state" == enabled ]] && exit 0
  info "run ./scripts/setup-sudo-touchid.sh to enable it"
  exit 1
fi
[[ "$state" == enabled ]] && exit 0

# --------------------------------------------------- build the new content --
tmp="$(mktemp -t sudo_local)"
trap 'rm -f "$tmp"' EXIT
case "$state" in
  missing)
    cp "$SRC" "$tmp" ;;
  commented)
    # Uncomment the template line in place; everything else is untouched.
    # "~" delimiter: the pattern itself contains "|" and "#".
    sed -E "s~${TID_COMMENTED_RE}.*~${TID_LINE}~" <<<"$current" > "$tmp" ;;
  present)
    {
      printf '%s\n' "$current"
      printf '\n# Touch ID for sudo — added by ~/.dotfiles/scripts/setup-sudo-touchid.sh\n'
      printf '%s\n' "$TID_LINE"
    } > "$tmp" ;;
esac
validate_pam "$tmp" || { error "refusing to install — $SUDO_LOCAL left untouched"; exit 1; }

# ---------------------------------------------------------------- install --
[[ "$state" == missing ]] || backup_copy "$SUDO_LOCAL"
if $need_root; then
  info "Installing $SUDO_LOCAL (sudo will ask for your password)"
  as_root install -m 0444 -o root -g wheel "$tmp" "$SUDO_LOCAL"
else
  install -m 0444 "$tmp" "$SUDO_LOCAL"
fi

# ----------------------------------------------------------------- verify --
installed="$(as_root cat "$SUDO_LOCAL")"
grep -Eq "$TID_RE" <<<"$installed" || { error "pam_tid line missing after install"; exit 1; }
validate_pam <(printf '%s\n' "$installed") || exit 1
success "Touch ID for sudo enabled: $SUDO_LOCAL"
info "Test it:  sudo -k && sudo true   (expect the macOS Touch ID prompt)"
info "Inside tmux the sensor is not reachable without pam_reattach (brew install pam-reattach)."
