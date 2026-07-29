# CLAUDE.md — instructions for Claude Code in this repo

## Color palette (Terra)

Every tool in this repo is themed with one palette, anchored to the
starship prompt (`starship/starship.toml`, `[palettes.terra]`).
When adding or restyling any tool, use these colors — do not invent new ones.

### Core terra

| Hex | Role | Examples |
| --- | --- | --- |
| `#f77d5b` | primary accent (coral) | hovered row bg (yazi), active tab, tmux session badge, fzf pointer, cursor |
| `#556f5a` | deep accent (forest) | tmux current window, yazi parent/preview hover, gdu marked |
| `#859e89` | light accent (sage) | cwd/path text, current line number, fzf prompt |
| `#edc27a` | highlight (gold) | match/search highlights, selected markers, todo |
| `#3c4a3e` | selection bg | fzf selected row, terminal selection, tmux message |
| `#262b25` | subtle raised surface | cursor-line (micro), cursor guide |
| `#20241f` | surface | tmux status bar bg, inactive tab bg |
| `#303a31` | border, dark | fzf border, tmux pane border, indent guides |
| `#556052` | border, light | yazi pane borders |

### Text

| Hex | Role |
| --- | --- |
| `#f5ede4` | bright text — on forest/dark accent backgrounds |
| `#2b211b` | ink text — on light accent backgrounds (coral, gold, sage, rose, pink, teal) |
| `#e8d7d0` | body text |
| `#a89a8f` | muted text (dates, inactive items) |
| `#736a5f` | faint (autosuggestion ghost text, line numbers) |

### Semantic accents

red `#d0686e` · green `#859e89` · yellow `#edc27a` · orange `#f77d5b` ·
pink `#e09b9f` · teal `#84a89a` · blue `#7e9ca8` · mauve `#b48ea3` ·
comment grey `#7d8578`

### Backgrounds

- Ghostty: `#161a16` (green-black), opacity 0.80, blur
- iTerm2: `#1f1a16` (warm bark), transparency 0.2, blur
- Both terminals use the custom terra ANSI-16 palette, defined in
  `ghostty/config` and mirrored in `iterm2/terra.json`:
  0 `#414a42` · 1 `#d0686e` · 2 `#859e89` · 3 `#edc27a` · 4 `#7e9ca8` ·
  5 `#b48ea3` · 6 `#84a89a` · 7 `#d6c8bd` · 8 `#5f695c` · 9 `#dd8288` ·
  10 `#9ab3a0` · 11 `#f4d49a` · 12 `#94b2bd` · 13 `#c9a5b8` ·
  14 `#9dc0b0` · 15 `#a89a8f`
- TUI backgrounds should stay transparent (`bg:-1` / unset) so the
  terminal's translucent background shows through

## Theming rules

- Use **ANSI color names** (`blue`, `red`) when the goal is matching
  `ls`/terminal-wide conventions — e.g. yazi's whole `[filetype]` list
  uses ANSI names so it always matches eza via the terminal palette
  (eza emits plain ANSI-16 codes). Use **hex** for chrome and accents.
- Light accents (coral/gold/sage/rose/pink/teal) take ink text `#2b211b`;
  forest and dark surfaces take bright cream `#f5ede4`. Never body-grey
  on accent.
- The starship palette file is the source of truth for the gradient
  (first–eighth, coral → rose). The gradient is light, so starship
  segment text is ink (`text = "#2B211B"`); its `error` red `#c1121f`
  is starship-only.

## Verifying TUI colors

Run the tool in a detached tmux session and grep decoded RGB triplets
(`#f77d5b` → `247;125;91`):

```sh
tmux -L t new-session -d -x 100 -y 25 "<tool>" && sleep 2
tmux -L t capture-pane -e -p | grep -c "48;2;247;125;91"   # bg match
tmux -L t send-keys q; tmux -L t kill-server
```

Check the row that is actually styled (yazi hovers the first item —
sorting is case-insensitive), not just any match on screen.

## Known schema gotchas

- yazi 26.x: hover styling lives in `[indicator]` (`current`/`parent`/
  `preview`), NOT `[mgr] hovered`; `[filetype]` rules use `url =` (not
  `name =`) and REPLACE the defaults — always end with fallbacks.
  Unknown keys are silently ignored; validate with `yazi --debug`.
- yazi icons: an `[icon]` rule without `fg` inherits the file's own
  color, so the theme's icon tables are yazi's default glyphs with every
  hardcoded fg stripped (regeneration note in `yazi/theme.toml`). Url
  globs in `[filetype]` match the full path — basename patterns need a
  `**/` prefix (`**/README*`), and `*` alone can't nest inside braces.
- eza's README/Makefile underline is disabled via `EZA_COLORS="bu=1;33"`
  in exports.zsh, matching yazi's filetype rules.
- micro: hex colorschemes need `MICRO_TRUECOLOR=1` (set in exports.zsh).
- gdu: themeable keys are `style.selected-row`, `style.marked`,
  `style.result-row` (`number-color`, `directory-color`), `style.header`
  and `style.footer` (`text-color`, `background-color`, footer also
  `number-color`). Color names go through tcell's W3C table (NOT the
  terminal ANSI palette), so to match `ls` use the terra hex values of
  the ANSI colors. The brew binary is `gdu-go` (aliased to `gdu`).
- iTerm2: colors live in the dynamic profile `iterm2/terra.json`
  (sRGB components 0–1); it hot-reloads on save. The default-profile
  choice is a user pref, not repo-managed. The profile `Guid` is
  intentionally still `dotfiles-amethyst` (its original value) — iTerm2
  keys the default-profile pref on the Guid, so changing it would reset
  the user's choice. Don't "fix" it when renaming palettes.
- Powerline glyphs (``, U+E0B0) can get mangled by text edits — verify
  with `hexdump` (bytes `ee 82 b0`) after editing starship/tmux configs.

## Repo conventions

New tool configs: add the config under `<tool>/` in this repo, link it
in `scripts/setup-links.sh` (backup-then-symlink, idempotent), list it
in `scripts/backup.sh`, add the package to `Brewfile`, document in
README. Never delete user files — `link_file` backs up before linking.
