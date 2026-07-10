# CLAUDE.md — instructions for Claude Code in this repo

## Color palette (Amethyst)

Every tool in this repo is themed with one palette, anchored to the
starship prompt (`starship/starship.toml`, `[palettes.amethyst]`).
When adding or restyling any tool, use these colors — do not invent new ones.

### Core amethyst

| Hex | Role | Examples |
| --- | --- | --- |
| `#6e43c4` | primary accent | hovered row bg (yazi), active tab, tmux session badge, fzf pointer |
| `#5a359e` | deep accent | tmux current window, yazi parent/preview hover, gdu marked |
| `#a78bfa` | light amethyst | cursor color, cwd/path text, match highlights, current line number |
| `#372a5e` | selection bg | fzf selected row, terminal selection, tmux message |
| `#26203d` | subtle raised surface | cursor-line (micro), cursor guide |
| `#201c30` | surface | tmux status bar bg, inactive tab bg |
| `#2e2a44` | border, dark | fzf border, tmux pane border, indent guides |
| `#4a4463` | border, light | yazi pane borders |

### Text

| Hex | Role |
| --- | --- |
| `#f2ebff` | bright text — always on accent backgrounds |
| `#cdd6f4` | body text |
| `#8a84a8` | muted text (dates, inactive items) |
| `#6c6685` | faint (autosuggestion ghost text, line numbers) |

### Semantic accents (Catppuccin Mocha)

red `#f38ba8` · green `#a6e3a1` · yellow `#f9e2af` · orange `#fab387` ·
pink `#f5c2e7` · teal `#94e2d5` · blue `#89b4fa` · mauve `#cba6f7` ·
comment grey `#6c7086`

### Backgrounds

- Ghostty: `#14171c` (cool dark), opacity 0.80, blur
- iTerm2: `#1c1a24` (warm plum), transparency 0.2, blur
- Both terminals use the Catppuccin Mocha ANSI-16 palette
- TUI backgrounds should stay transparent (`bg:-1` / unset) so the
  terminal's translucent background shows through

## Theming rules

- Use **ANSI color names** (`blue`, `red`) when the goal is matching
  `ls`/terminal-wide conventions — e.g. yazi directories are `blue` so
  they always match eza via the terminal palette. Use **hex** for
  chrome and accents.
- Text on any amethyst background is `#f2ebff`; never body-grey on accent.
- The starship palette file is the source of truth for the gradient
  (first–eighth); its `error` red `#c1121f` is starship-only.

## Verifying TUI colors

Run the tool in a detached tmux session and grep decoded RGB triplets
(`#6e43c4` → `110;67;196`):

```sh
tmux -L t new-session -d -x 100 -y 25 "<tool>" && sleep 2
tmux -L t capture-pane -e -p | grep -c "48;2;110;67;196"   # bg match
tmux -L t send-keys q; tmux -L t kill-server
```

Check the row that is actually styled (yazi hovers the first item —
sorting is case-insensitive), not just any match on screen.

## Known schema gotchas

- yazi 26.x: hover styling lives in `[indicator]` (`current`/`parent`/
  `preview`), NOT `[mgr] hovered`; `[filetype]` rules use `url =` (not
  `name =`) and REPLACE the defaults — always end with fallbacks.
  Unknown keys are silently ignored; validate with `yazi --debug`.
- micro: hex colorschemes need `MICRO_TRUECOLOR=1` (set in exports.zsh).
- gdu: only `style.selected-row` and `style.marked` are themeable; the
  brew binary is `gdu-go` (aliased to `gdu`).
- iTerm2: colors live in the dynamic profile `iterm2/amethyst.json`
  (sRGB components 0–1); it hot-reloads on save. The default-profile
  choice is a user pref, not repo-managed.
- Powerline glyphs (``, U+E0B0) can get mangled by text edits — verify
  with `hexdump` (bytes `ee 82 b0`) after editing starship/tmux configs.

## Repo conventions

New tool configs: add the config under `<tool>/` in this repo, link it
in `scripts/setup-links.sh` (backup-then-symlink, idempotent), list it
in `scripts/backup.sh`, add the package to `Brewfile`, document in
README. Never delete user files — `link_file` backs up before linking.
