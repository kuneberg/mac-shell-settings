# Micro — default terminal editor

[Micro](https://micro-editor.github.io/) is the default `$EDITOR` for this
setup: a modern terminal editor with sane keybindings (Ctrl+S saves,
Ctrl+Q quits, Ctrl+C/X/V work as expected), mouse support and syntax
highlighting — no modal editing to learn.

## Launch

```sh
micro file.txt        # open a file
micro                 # empty buffer
git commit            # git uses micro too (core.editor)
```

`EDITOR` and `VISUAL` are set to `micro` in `zsh/exports.zsh`, so anything
that respects those variables (git, crontab, ...) opens Micro.

## Where the configuration lives

`~/.config/micro` is a symlink to this directory (created by
`scripts/setup-links.sh`):

| File | Purpose |
| --- | --- |
| `settings.json` | editor options (soft wrap, 4-space tabs, scrollbar, ...) |
| `bindings.json` | extra keybindings on top of Micro's defaults |
| `colorschemes/terra.micro` | colorscheme matching the repo-wide terra palette |

Runtime files Micro writes itself (`buffers/`, `backups/`, history) land in
this directory too and are ignored via `.gitignore`.

## Keybindings

Micro's defaults already cover the familiar shortcuts (Ctrl+S save,
Ctrl+Q quit, Ctrl+F find, Ctrl+Z/Y undo/redo). The only addition:

| Key | Action |
| --- | --- |
| Ctrl+H | opens the `replace` command pre-filled |

Press Ctrl+G inside Micro for the full help.

## Updating the configuration

Edit the files here (or inside Micro: Ctrl+E, then `set option value` —
it writes through the symlink into this repo), then commit:

```sh
cd ~/.dotfiles && git add micro && git commit
```

The colorscheme uses true color; `MICRO_TRUECOLOR=1` is exported in
`zsh/exports.zsh`. If the colors ever look wrong in another terminal,
switch with `set colorscheme one-dark`.
