# Setting up a new Mac

Complete walkthrough for bootstrapping the terminal environment on a fresh
machine.

## 1. Prerequisites

Install Apple's Command Line Tools (provides `git`):

```sh
xcode-select --install
```

Set up an SSH key for GitHub (needed to clone over SSH):

```sh
ssh-keygen -t ed25519 -C "your@email"
pbcopy < ~/.ssh/id_ed25519.pub
# paste at https://github.com/settings/keys
```

## 2. Clone and install

```sh
git clone git@github.com:kuneberg/mac-shell-settings.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The installer handles Homebrew, all packages, fonts, symlinks and shell
wiring. It is safe to re-run if anything fails midway (e.g. network).

## 3. First-run steps (manual)

- **Restart the terminal** or run `exec zsh` so the new config loads.
- **Launch Ghostty** once from `/Applications` (macOS Gatekeeper prompt).
- **Git identity** — stored locally, never in the repo:

  ```sh
  git config --global user.name  "Your Name"
  git config --global user.email "you@example.com"
  ```

- **GitHub CLI**: `gh auth login`
- **Atuin history sync** (optional): `atuin register` (first machine) or
  `atuin login` (additional machines), then set `auto_sync = true` in
  `atuin/config.toml` and run `atuin sync`.
- **tmux**: if a session was already running during install, press
  `prefix + r` (default prefix `Ctrl-b`) to reload the config.

## 4. Verify

```sh
# prompt renders with powerline segments and icons
starship --version

# links point into the repo
ls -l ~/.config/starship.toml ~/.config/ghostty/config ~/.tmux.conf

# managed blocks are present exactly once
grep -c '>>> dotfiles >>>' ~/.zshrc ~/.zprofile

# delta is the git pager
git config --get core.pager
```

If prompt icons render as boxes, make sure Ghostty is using
**JetBrainsMono Nerd Font** (it is set in `ghostty/config`).
