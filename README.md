# mac-shell-settings

Single source of truth for my macOS shell and terminal environment:
**zsh + Ghostty + Starship + Homebrew**, plus micro, tmux, atuin, yazi, git
and a set of modern CLI tools.

Remote: `git@github.com:kuneberg/mac-shell-settings.git`
Local: `~/.dotfiles`

## Installation

```sh
git clone git@github.com:kuneberg/mac-shell-settings.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The installer is **idempotent** — run it as many times as you like. It:

1. installs Homebrew if missing, then updates it
2. installs all packages and casks from the `Brewfile` (`brew bundle`)
3. installs JetBrains Mono Nerd Font
4. creates the required `~/.config` directories
5. symlinks all repo-owned configuration into place
6. adds one managed block to `~/.zprofile` and `~/.zshrc` (never replaces them)
7. registers `git/gitconfig` via `git config --global include.path`
8. prints a summary

Anything already at a destination is **moved to a timestamped backup**
(`~/.dotfiles-backup/<timestamp>/`) before being replaced. Nothing is ever
deleted, and `user.name`/`user.email` in `~/.gitconfig` are never touched.

## Repository structure

```
~/.dotfiles/
├── install.sh              # single entry point, safe to re-run
├── Brewfile                # all CLI tools and casks
├── scripts/
│   ├── utils.sh            # shared helpers: logging, backups, symlinks, managed blocks
│   ├── install-homebrew.sh # install/update Homebrew
│   ├── install-tools.sh    # brew bundle
│   ├── install-fonts.sh    # nerd font
│   ├── setup-links.sh      # symlinks + ~/.config dirs
│   ├── setup-zsh.sh        # managed blocks in ~/.zprofile / ~/.zshrc
│   └── backup.sh           # snapshot all managed files on demand
├── zsh/
│   ├── zprofile            # Homebrew shellenv, PATH (login shells)
│   ├── zshrc               # options, completion, plugins, tool init
│   ├── aliases.zsh
│   ├── exports.zsh
│   └── functions.zsh
├── starship/starship.toml  # amethyst prompt
├── ghostty/config
├── git/gitconfig           # delta, micro as editor, aliases — no identity
├── micro/                  # default $EDITOR — see micro/README.md
│   ├── settings.json
│   ├── bindings.json
│   └── colorschemes/
├── tmux/tmux.conf
├── atuin/config.toml
├── yazi/                   # yazi.toml, theme, keymap, smart-enter plugin
├── iterm2/amethyst.json    # iTerm2 dynamic profile (amethyst colors)
└── docs/setup.md           # new-Mac walkthrough
```

## How it is wired

| In home directory | Points to |
| --- | --- |
| `~/.config/ghostty/config` | `~/.dotfiles/ghostty/config` |
| `~/.config/starship.toml` | `~/.dotfiles/starship/starship.toml` |
| `~/.config/atuin/config.toml` | `~/.dotfiles/atuin/config.toml` |
| `~/.config/yazi/yazi.toml` | `~/.dotfiles/yazi/yazi.toml` |
| `~/.config/micro` | `~/.dotfiles/micro` (whole directory) |
| `~/Library/Application Support/iTerm2/DynamicProfiles/amethyst.json` | `~/.dotfiles/iterm2/amethyst.json` |
| `~/.tmux.conf` | `~/.dotfiles/tmux/tmux.conf` |

`~/.zprofile` and `~/.zshrc` are *not* symlinked. Each gets exactly one
managed block, so anything else you keep in them survives:

```sh
# >>> dotfiles >>>
source "$HOME/.dotfiles/zsh/zshrc"
# <<< dotfiles <<<
```

Git config is pulled in through an include, so your identity stays local:

```sh
git config --global include.path ~/.dotfiles/git/gitconfig
```

## Editor

[Micro](https://micro-editor.github.io/) is the default terminal editor:
`EDITOR`/`VISUAL` are set in `zsh/exports.zsh` and git uses it via
`core.editor`. Launch with `micro <file>`; configuration lives in
`micro/` and is documented in [micro/README.md](micro/README.md).

## File manager

Launch [Yazi](https://yazi-rs.github.io/) with `y`:

- **Enter on a directory** — quit yazi and `cd` the shell into it
  (Enter on a file opens it as usual)
- **q** — quit and leave the shell where it was

Implemented by the `y` wrapper in `zsh/functions.zsh` (`--cwd-file`)
plus `yazi/keymap.toml` and the tiny `yazi/plugins/smart-enter.yazi`
plugin. Theme (amethyst) and options live in `yazi/theme.toml` and
`yazi/yazi.toml`.

## Updating

Edit files in `~/.dotfiles` — changes apply immediately (configs are
symlinked; for zsh run `reload`). Then commit:

```sh
cd ~/.dotfiles
git add -A
git commit -m "describe the change"
git push
```

To pull changes made on another machine:

```sh
cd ~/.dotfiles
git pull
./install.sh   # re-link / install anything new
```

## Adding new tools

1. Add the formula or cask to `Brewfile`.
2. Run `./install.sh` (or `brew bundle install --file=~/.dotfiles/Brewfile`).
3. If the tool has config, add a directory for it in the repo, link it in
   `scripts/setup-links.sh`, and list it in `scripts/backup.sh`.
4. Commit and push.

## Restoring backups

Every install run that had to move or edit a file creates
`~/.dotfiles-backup/<timestamp>/`, mirroring paths relative to `~`.
To restore, copy the file back, e.g.:

```sh
cp ~/.dotfiles-backup/20260710-120000/.zshrc ~/.zshrc
```

`./scripts/backup.sh` snapshots all managed files on demand without
changing anything.

## Uninstalling

```sh
# 1. Remove the symlinks
rm ~/.config/ghostty/config ~/.config/starship.toml \
   ~/.config/atuin/config.toml ~/.config/yazi/yazi.toml \
   ~/.config/micro ~/.tmux.conf

# 2. Delete the managed blocks (between the >>> dotfiles >>> markers)
#    from ~/.zprofile and ~/.zshrc

# 3. Remove the git include
git config --global --unset-all include.path ~/.dotfiles/git/gitconfig

# 4. Optionally restore originals from ~/.dotfiles-backup/<timestamp>/
#    and delete the repo
rm -rf ~/.dotfiles
```

Installed Homebrew packages are unaffected; remove them with
`brew bundle cleanup --file=~/.dotfiles/Brewfile --force` if wanted.

## New Mac

See [docs/setup.md](docs/setup.md) for the full walkthrough (SSH keys,
clone, install, first-run steps).
