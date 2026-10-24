# CLAUDE.md — instructions for Claude Code in this repo

## Color palette (Srcery)

Every tool in this repo is themed with one palette: Srcery
(terminalcolors.com/themes/srcery/default, the srcery-colors project —
a warm gruvbox derivative), anchored to the starship prompt
(`starship/starship.toml`, `[palettes.srcery]`). When adding or
restyling any tool, use these colors — do not invent new ones.

### Core srcery

| Hex | Role | Examples |
| --- | --- | --- |
| `#fbb829` | primary accent (yellow) | hovered row bg (lf), tmux session badge, active pane border, fzf pointer, prompt `❯`, current line number |
| `#444444` | deep accent (xgray4) | tmux current window, lf parent/preview hover, gdu marked, borders (light), starship `third` |
| `#68a8e4` | light accent (bright blue) | cwd/path text (lf prompt), fzf prompt, links, identifiers |
| `#ff5f00` | highlight (orange) | match/search highlights (fzf `hl`, micro hlsearch), specials |
| `#3a3a3a` | selection bg (xgray3) | fzf selected row, gdu selected row, tmux message, micro statusline, borders (dark) |
| `#262626` | subtle raised surface (xgray1) | cursor-line (micro), iTerm2 cursor guide |
| `#303030` | surface (xgray2) | tmux status bar bg, micro tabbar, gdu header/footer |

### Text

| Hex | Role |
| --- | --- |
| `#fce8c3` | body text (bright white = terminal fg), also bright text on deep/dark surfaces |
| `#1c1b19` | ink text (black = terminal bg) — on light accents (yellow, orange, green) |
| `#918175` | muted text (bright black): dates, inactive windows, comments, autosuggestion ghost text, fzf info |
| `#585858` | faint (xgray6): line numbers |
| `#baa67f` | ANSI 7 (tan) — only reached via ANSI codes, never as a hex text color |

### Semantic accents

red `#ef2f27` · green `#519f50` · yellow `#fbb829` · blue `#2c78bf` ·
magenta `#e02c6d` · cyan `#0aaeb3` · orange `#ff5f00` ·
bright: red `#f75341` · green `#98bc37` · yellow `#fed06e` · blue `#68a8e4` ·
magenta `#ff5c8f` · cyan `#2be4d0` · orange `#ff8700`

### Backgrounds

- Ghostty: `#1c1b19`, opacity 0.70, blur, plus `ghostty/orange-glow.png`
  as `background-image` (1280×800 RGBA, srcery orange `#ff5f00` radial
  alpha ≤0.42 from the bottom-right; generated with a stdlib-only Python
  PNG writer — regenerate the same way if the glow color changes). Ghostty
  expands `~` in `background-image`; the file is linked into
  `~/.config/ghostty/` by `setup-links.sh`.
- Alacritty: same as Ghostty — `alacritty/alacritty.toml`
- iTerm2: same as Ghostty (transparency 0.30 = opacity 0.70, blur) —
  `iterm2/srcery.json`
- All terminals use the Srcery ANSI-16 palette exactly as published,
  defined in `ghostty/config` and mirrored in `alacritty/alacritty.toml`
  and `iterm2/srcery.json`:
  0 `#1c1b19` · 1 `#ef2f27` · 2 `#519f50` · 3 `#fbb829` · 4 `#2c78bf` ·
  5 `#e02c6d` · 6 `#0aaeb3` · 7 `#baa67f` · 8 `#918175` · 9 `#f75341` ·
  10 `#98bc37` · 11 `#fed06e` · 12 `#68a8e4` · 13 `#ff5c8f` · 14 `#2be4d0` ·
  15 `#fce8c3`.
  ANSI black equals the background, so never use it (or ANSI names that
  resolve to it) for text — use hex `#918175` instead. ANSI 7 (`#baa67f`)
  is darker than the foreground (`#fce8c3`), so plain text must be the
  default/foreground color, not `white`.
  Cursor is yellow `#fbb829` with ink text; terminal selection is the
  published inverse (fg bg, ink text).
- TUI backgrounds should stay transparent (`bg:-1` / unset) so the
  terminal's translucent background shows through

## Theming rules

- Use **ANSI color names** (`blue`, `red`) when the goal is matching
  `ls`/terminal-wide conventions — e.g. lf's whole `colors` file
  uses ANSI codes so it always matches eza via the terminal palette
  (eza emits plain ANSI-16 codes). Use **hex** for chrome and accents.
- Light accents (yellow/orange/green/bright blue) take ink text `#1c1b19`;
  deep and dark surfaces (xgray3/xgray4, red) take body `#fce8c3`.
- The starship palette file is the source of truth for the prompt
  gradient (first–eighth, xgray5 `#4e4e4e` → `#2b2b2b`). The
  gradient is dark, so segment text is body `#fce8c3`; the prompt
  character uses the per-palette `accent` key (eighth is too dark).
  The directory segment uses `path`/`path_text` (srcery: yellow
  `#fbb829` with ink text; gotham: orange; other palettes: their third +
  text).
  It ends with a solid `path` arrow whose bg is the next segment's:
  `repo_root_format` (used inside git repos, needs `repo_root_style`)
  targets git (`third`), `format` targets time (`seventh`). So git must
  directly follow `$directory`, and the git/langs group owns the
  third→seventh arrow before `$time`.
  Other palettes (opal/amethyst/terra/gotham/ruby) are kept for switching.
- bat uses the built-in `gruvbox-dark` theme (srcery is a gruvbox
  derivative; `Nord` was the gotham pick).

## Verifying TUI colors

Run the tool in a detached tmux session and grep decoded RGB triplets
(`#fbb829` → `251;184;41`):

```sh
tmux -L t new-session -d -x 100 -y 25 "<tool>" && sleep 2
tmux -L t capture-pane -e -p | grep -c "48;2;251;184;41"   # bg match
tmux -L t send-keys q; tmux -L t kill-server
```

Check the row that is actually styled (lf hovers the first item —
dirs first, natural sort), not just any match on screen.

## Known schema gotchas

- lf: hover/chrome colors are options in `lfrc` (`cursoractivefmt`,
  `cursorparentfmt`, `cursorpreviewfmt`, `borderfmt`, `promptfmt`,
  `errorfmt`; `statfmt` is deprecated and prints a warning) holding raw
  SGR escapes; truecolor needs `COLORTERM=truecolor`
  (all three terminals set it). File colors live in the `colors` file:
  one `pattern code` pair per line, NO brace expansion, matched full path >
  dir name (`.git/`) > file type (`di`, `ex`…) > name > basename >
  extension > `fi`. Unknown options abort startup with the error on the
  bottom line — test in detached tmux (above). `lf -doc` is the manual.
- lf icons: the `icons` file uses two columns only (pattern, glyph); a
  third column would hardcode a color, so leaving it off makes every
  icon inherit the file's color from `colors` (and so from `ls`).
- eza's README/Makefile underline is disabled via `EZA_COLORS="bu=1;33"`
  in exports.zsh, matching lf's colors file.
- micro: hex colorschemes need `MICRO_TRUECOLOR=1` (set in exports.zsh).
- gdu: themeable keys are `style.selected-row`, `style.marked`,
  `style.result-row` (`number-color`, `directory-color`), `style.header`
  and `style.footer` (`text-color`, `background-color`, footer also
  `number-color`). Color names go through tcell's W3C table (NOT the
  terminal ANSI palette), so to match `ls` use the srcery hex values of
  the ANSI colors. The brew binary is `gdu-go` (aliased to `gdu`).
- iTerm2: colors live in the dynamic profile `iterm2/srcery.json`
  (sRGB components 0–1); it hot-reloads on save. The default-profile
  choice is a user pref, not repo-managed. The profile `Guid` is
  intentionally still `dotfiles-amethyst` (its original value) — iTerm2
  keys the default-profile pref on the Guid, so changing it would reset
  the user's choice (it survived amethyst → terra → gotham → srcery).
  Don't "fix" it when renaming palettes.
  Non-color keys mirror ghostty/alacritty: `Transparency` is
  1 − opacity, `Option Key Sends`/`Right Option Key Sends` 2 = Esc+,
  `Cursor Type` 2 = block, `Brighten Bold Text` false = ghostty's
  `bold-is-bright` default (else bold+ANSI color renders as the bright
  slot and `ls`/eza directories look different), `Keyboard Map` keys are
  `"0x<char>-0x<modifiers>"` (Return 0xd, Shift 0x20000) with
  `Action` 11 = send hex codes (10 = ESC + text). Window padding is a
  global advanced pref (`TerminalMargin`/`TerminalVMargin`), not
  per-profile, so it is not managed here.
  `iterm2/Srcery.itermcolors` is the same palette as an importable color
  preset (Settings → Profiles → Colors → Color Presets → Import) for
  applying srcery to a non-dynamic profile (downloaded verbatim from
  terminalcolors.com/downloads/iterm2/srcery-default.itermcolors);
  re-download or regenerate it from `ghostty/config` when the palette
  changes.
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
