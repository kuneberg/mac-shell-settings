# CLAUDE.md — instructions for Claude Code in this repo

## Color palette (Gotham)

Every tool in this repo is themed with one palette: Gotham
(terminalcolors.com/themes/gotham/default, the vim-gotham colors),
anchored to the starship prompt (`starship/starship.toml`,
`[palettes.gotham]`). When adding or restyling any tool, use these
colors — do not invent new ones.

### Core gotham

| Hex | Role | Examples |
| --- | --- | --- |
| `#33859e` | primary accent (cyan) | hovered row bg (yazi), active tab, tmux session badge, fzf pointer, prompt `❯` |
| `#245361` | deep accent (base4) | tmux current window, yazi parent/preview hover, gdu marked, borders (light) |
| `#599cab` | light accent (base5) | cwd/path text, current line number, fzf prompt |
| `#edb443` | highlight (yellow) | match/search highlights, selected markers, todo |
| `#0a3749` | selection bg (base3) | fzf selected row, terminal selection, tmux message, borders (dark) |
| `#11151c` | subtle raised surface (base1) | cursor-line (micro), cursor guide, cursor text |
| `#091f2e` | surface (base2) | tmux status bar bg, inactive tab bg, gdu header/footer |

### Text

| Hex | Role |
| --- | --- |
| `#d3ebe9` | bright text (base7) — on deep/dark accent backgrounds |
| `#0c1014` | ink text (base0) — on light accents (cyan, yellow, green, orange) |
| `#99d1ce` | body text (base6), also the terminal cursor |
| `#599cab` | muted text (dates, inactive items) |
| `#245361` | faint (autosuggestion ghost text, line numbers, comments) |

### Semantic accents

red `#c23127` · green `#2aa889` · yellow `#edb443` · orange `#d26937` ·
magenta `#888ca6` · violet `#4e5166` · cyan `#33859e` · blue `#195466`

### Backgrounds

- Ghostty: `#0c1014`, opacity 0.70, blur
- Alacritty: same as Ghostty — `alacritty/alacritty.toml`
- iTerm2: same as Ghostty (transparency 0.30 = opacity 0.70, blur) —
  `iterm2/gotham.json`
- All terminals use the Gotham ANSI-16 palette exactly as published,
  defined in `ghostty/config` and mirrored in `alacritty/alacritty.toml`
  and `iterm2/gotham.json`. Bright colors equal the normal ones:
  0/8 `#0c1014` · 1/9 `#c23127` · 2/10 `#2aa889` · 3/11 `#edb443` ·
  4/12 `#195466` · 5/13 `#4e5166` · 6/14 `#33859e` · 7/15 `#99d1ce`.
  ANSI black/bright-black equal the background, so never use them (or
  ANSI names that resolve to them) for text — use hex `#245361` instead.
- TUI backgrounds should stay transparent (`bg:-1` / unset) so the
  terminal's translucent background shows through

## Theming rules

- Use **ANSI color names** (`blue`, `red`) when the goal is matching
  `ls`/terminal-wide conventions — e.g. yazi's whole `[filetype]` list
  uses ANSI names so it always matches eza via the terminal palette
  (eza emits plain ANSI-16 codes). Use **hex** for chrome and accents.
- Light accents (cyan/yellow/green/orange) take ink text `#0c1014`;
  deep and dark surfaces (base3/base4, red) take bright `#d3ebe9`.
- The starship palette file is the source of truth for the prompt
  gradient (first–eighth, base4 `#245361` → base3 `#0a3749`). The
  gradient is dark, so segment text is body `#99d1ce`; the prompt
  character uses the per-palette `accent` key (eighth is too dark).
  Other palettes (opal/amethyst/terra/ruby) are kept for switching.
- bat uses the built-in `Nord` theme (closest to gotham).

## Verifying TUI colors

Run the tool in a detached tmux session and grep decoded RGB triplets
(`#33859e` → `51;133;158`):

```sh
tmux -L t new-session -d -x 100 -y 25 "<tool>" && sleep 2
tmux -L t capture-pane -e -p | grep -c "48;2;51;133;158"   # bg match
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
  terminal ANSI palette), so to match `ls` use the gotham hex values of
  the ANSI colors. The brew binary is `gdu-go` (aliased to `gdu`).
- iTerm2: colors live in the dynamic profile `iterm2/gotham.json`
  (sRGB components 0–1); it hot-reloads on save. The default-profile
  choice is a user pref, not repo-managed. The profile `Guid` is
  intentionally still `dotfiles-amethyst` (its original value) — iTerm2
  keys the default-profile pref on the Guid, so changing it would reset
  the user's choice (it survived amethyst → terra → gotham). Don't "fix" it
  when renaming palettes.
  Non-color keys mirror ghostty/alacritty: `Transparency` is
  1 − opacity, `Option Key Sends`/`Right Option Key Sends` 2 = Esc+,
  `Cursor Type` 2 = block, `Brighten Bold Text` false = ghostty's
  `bold-is-bright` default (else bold+ANSI color renders as the bright
  slot and `ls`/eza directories look different), `Keyboard Map` keys are
  `"0x<char>-0x<modifiers>"` (Return 0xd, Shift 0x20000) with
  `Action` 11 = send hex codes (10 = ESC + text). Window padding is a
  global advanced pref (`TerminalMargin`/`TerminalVMargin`), not
  per-profile, so it is not managed here.
  `iterm2/Gotham.itermcolors` is the same palette as an importable color
  preset (Settings → Profiles → Colors → Color Presets → Import) for
  applying gotham to a non-dynamic profile (downloaded verbatim from
  terminalcolors.com); regenerate it from `ghostty/config` when the
  palette changes.
- Terminal title: zsh emits OSC 0 (`\e]0;`), not OSC 2 — iTerm2 shows
  the icon title in tabs and only renames the window on OSC 2; Ghostty
  and Alacritty treat 0 and 2 identically.
- Powerline glyphs (``, U+E0B0) can get mangled by text edits — verify
  with `hexdump` (bytes `ee 82 b0`) after editing starship/tmux configs.

## Repo conventions

New tool configs: add the config under `<tool>/` in this repo, link it
in `scripts/setup-links.sh` (backup-then-symlink, idempotent), list it
in `scripts/backup.sh`, add the package to `Brewfile`, document in
README. Never delete user files — `link_file` backs up before linking.

Exception — root-owned system files (`sudo/sudo_local` →
`/etc/pam.d/sudo_local`) are *copied* by their own explicit script
(`scripts/setup-sudo-touchid.sh`), never symlinked and never run from
`install.sh`; the script backs up, merges into existing content, and
validates before writing. Don't add `sudo` steps to `install.sh`.
