# Neovim Health Triage

Source: `:checkhealth` output at `/tmp/nvim-health.txt` (2121 lines).

## Part 1 — Healthcheck actions

Work top-to-bottom; ordered by impact and how many warnings each clears.

### A. Silence/configure snacks.nvim
Clears ~30 messages. See **Part 2** to decide *how* — minimal `opts = {}` vs. opting into specific modules.

- [x] Decided approach: opt-in, started with `picker`
- [x] Updated lazy spec in `.config/nvim/init.lua` (`lazy = false`, `priority = 1000`, `opts = { picker = { enabled = true, ui_select = true } }`)
- [x] Re-ran `:checkhealth snacks` — root warnings cleared

### B. Fix conform.nvim deprecation
`Plugin.config` table is deprecated — use `Plugin.opts`. File: `.config/nvim/init.lua` around line 232.

- [ ] Changed `config = { ... }` → `opts = { ... }`
- [ ] Re-ran `:checkhealth lazy`

### C. Disable unused language providers
Clears 6 warnings in one shot. Add to init:

```lua
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
```

- [ ] Added the four lines
- [ ] Re-ran `:checkhealth vim.provider`

### D. Fix tmux `$TERM`
Inside tmux, `$TERM` is `xterm-ghostty` but should be `tmux-256color`. Likely causing subtle color drift you may not have noticed.

In `~/.config/tmux/tmux.conf` (or wherever your tmux config lives):

```tmux
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-ghostty:RGB"
```

- [ ] Updated tmux config
- [ ] Reloaded tmux (`tmux source ~/.config/tmux/tmux.conf` + restart sessions)
- [ ] Confirmed `echo $TERM` inside tmux now prints `tmux-256color`

### E. Truncate LSP log
106 MB log. Either delete or lower log level.

- [ ] `rm ~/.local/state/nvim/lsp.log`
- [ ] (optional) lower log level: `vim.lsp.set_log_level("ERROR")` in init

### F. Resolve unknown filetypes (`gotmpl`, `markdown.mdx`)
Two options per filetype:

- (a) Register the filetype: `vim.filetype.add({ extension = { gotmpl = "gotmpl", mdx = "markdown.mdx" } })`
- (b) Remove the filetype from the relevant LSP's `filetypes` list if you don't use it

- [ ] Decided per filetype (use vs. drop)
- [ ] Applied fix
- [ ] Re-ran `:checkhealth vim.lsp`

### G. Install `fd`
Used by snacks.picker.explorer and gives telescope extended capabilities.

- [ ] `brew install fd`

### H. Decide on `lazyjj`
`lazyjj` executable not found, but the plugin is loaded (init.lua:211).

- [ ] Decision: install (`brew install lazyjj`) OR remove the plugin block

### I. Update mason.nvim
v2.2.1 → v2.3.0. Cosmetic.

- [x] Done as a side-effect of `:Lazy sync` during snacks migration

---

## Part 2 — snacks.nvim module evaluation

snacks.nvim is currently a transitive dep of `claudecode.nvim`. You can either:

- **Minimal**: `opts = {}` — clears warnings, no new behavior. Done.
- **Opt-in**: pick modules below.

For each module: read the description, compare to what you have, decide enable/skip.

Enable modules via `opts` table:
```lua
opts = {
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  -- ...
}
```

### Tier 1: candidates with no current equivalent (easy wins)

#### bigfile
Auto-disables expensive features (treesitter, LSP, syntax) in huge files so nvim doesn't choke. Pure performance safety net.
- [ ] Current setup: _______________
- [x] Decision: enable
- [ ] Notes:

#### quickfile
Renders the file *before* plugins finish loading — perceptibly faster file open.
- [ ] Current setup: _______________
- [x] Decision: enable
- [ ] Notes:

#### words
Highlights other instances of the word under the cursor (like many IDEs do).
- [ ] Current setup: _______________
- [x] Decision: enable
- [ ] Notes:

#### scroll
Smooth scrolling animation.
- [ ] Current setup: _______________
- [x] Decision: enable
- [ ] Notes:

### Tier 2: replaces or competes with something you likely have

#### picker
Fuzzy finder. You currently use **telescope** (init.lua references it). Snacks.picker is the modern folke alternative — faster, less config, integrated with the rest of snacks.
- [x] Current setup: was telescope.nvim — migrated 2026-05-22
- [x] Decision: migrated fully
- [x] Notes: Removed telescope, telescope-fzf-native, telescope-luasnip. Kept aerial.nvim as standalone. 11 keymaps ported (`<leader>f*` group + `gd`/`gi`/`gr`/`gt`). Dropped `<leader>fsn` snippet picker (no snacks equivalent). `ui_select=true` so code-action menus / picker selects also use snacks.

#### explorer
File tree (picker-based, not a sidebar tree).
- [ ] Current setup: _______________
- [ ] Decision: enable / skip
- [ ] Notes:

#### notifier
Replaces `vim.notify` with floating notifications. You may have **noice.nvim** (saw it in checkhealth) which already handles this.
- [ ] Current setup: noice.nvim (?)
- [ ] Decision: enable / skip
- [ ] Notes:

#### input
Replaces `vim.ui.input` with a floating prompt. Also potentially overlaps with noice/dressing.
- [ ] Current setup: dressing.nvim (?)
- [ ] Decision: enable / skip
- [ ] Notes:

#### statuscolumn
Better sign/number/fold column.
- [ ] Current setup: default nvim statuscolumn?
- [ ] Decision: enable / skip
- [ ] Notes:

#### indent
Indent guides + current-scope highlight. Overlaps with indent-blankline if you have it.
- [ ] Current setup: _______________
- [ ] Decision: enable / skip
- [ ] Notes:

#### scope
Current-scope highlighting (text objects, motions for scope). Different from `indent`'s scope viz.
- [ ] Current setup: _______________
- [ ] Decision: enable / skip
- [ ] Notes:

### Tier 3: standalone utilities (enable on demand)

#### lazygit
Floating lazygit popup. You have lazygit installed (checkhealth confirmed).
- [ ] Current setup: _______________
- [ ] Decision: enable / skip
- [ ] Notes:

#### terminal
Toggleable floating terminal.
- [ ] Current setup: _______________
- [ ] Decision: enable / skip
- [ ] Notes:

#### dashboard
Startup splash screen with recent files / shortcuts.
- [ ] Current setup: _______________
- [ ] Decision: enable / skip
- [ ] Notes:

### Tier 4: skip unless specifically wanted

#### image
Inline image/PDF/LaTeX/Mermaid preview. Requires imagemagick, ghostscript, tectonic, mmdc, and a terminal supporting kitty graphics protocol. **Ghostty doesn't support kitty graphics**, so this won't work for you regardless.
- [ ] Decision: skip (terminal incompatible)

---

## Part 3 — Won't fix / ignore

For reference; no action needed:

- `mason`: missing `wget`, `cargo`, `composer`, `php`, `javac`, `julia`, `java` — only matters if you install mason packages needing those toolchains
- `luasnip`: jsregexp missing — only matters for LSP snippet transformations
- `nvim-treesitter`: missing `tree-sitter` CLI — only needed for `:TSInstallFromGrammar`
- `snacks.image`: kitty graphics + magick/gs/tectonic/mmdc missing — see Tier 4
- snacks "missing treesitter parsers" (css/latex/norg/scss/svelte/tsx/typst/vue) — only relevant if you enable `snacks.image`
