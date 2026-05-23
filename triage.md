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

- [x] Changed `config = { ... }` → `opts = { ... }`
- [x] Re-ran `:checkhealth lazy` — deprecation warning + spec-load error gone (4 warnings → 2)

### C. Disable unused language providers
Clears 6 warnings in one shot. Add to init:

```lua
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
```

- [x] Added the four lines (near top of init.lua, after lazypath setup)
- [x] Re-ran `:checkhealth vim.provider` — all 6 warnings cleared

### D. Fix tmux `$TERM`
Inside tmux, `$TERM` is `xterm-ghostty` but should be `tmux-256color`. Likely causing subtle color drift you may not have noticed.

In `~/.tmux.conf`:

```tmux
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-ghostty:Tc"
```

- [x] Updated tmux config (replaced `"$TERM"` with explicit `"tmux-256color"`; kept truecolor passthrough via `xterm-ghostty:Tc`)
- [x] Reloaded tmux (`tmux source-file ~/.tmux.conf`); fresh panes now report `TERM=tmux-256color`
- [x] `:checkhealth vim.health` from a fresh tmux pane no longer reports the `$TERM should be ...` ERROR
- ⚠️ Existing panes keep their old TERM until restarted — tmux limitation, not a regression. Open new panes for the change to take effect in current work.

### E. Truncate LSP log
106 MB log. Either delete or lower log level.

- [x] `rm ~/.local/state/nvim/lsp.log`
- [ ] (optional) lower log level: `vim.lsp.set_log_level("ERROR")` in init

### F. Resolve unknown filetypes (`gotmpl`, `markdown.mdx`)
Two options per filetype:

- (a) Register the filetype: `vim.filetype.add({ extension = { gotmpl = "gotmpl", mdx = "markdown.mdx" } })`
- (b) Remove the filetype from the relevant LSP's `filetypes` list if you don't use it

- [x] Decided: drop both (option b)
- [x] Applied — `vim.lsp.config("gopls", { filetypes = {"go","gomod","gowork"} })` drops gotmpl; new `vim.lsp.config("marksman", { filetypes = {"markdown"} })` drops markdown.mdx
- [x] Re-ran `:checkhealth vim.lsp` — both `Unknown filetype` warnings gone

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
- [x] Current setup: none
- [x] Decision: enabled (defaults: 1.5MB threshold, notification on detect)
- [x] Notes: `bigfile = { enabled = true }` in snacks opts.

#### quickfile
Renders the file *before* plugins finish loading — perceptibly faster file open.
- [x] Current setup: none
- [x] Decision: enabled (defaults; latex excluded from treesitter)
- [x] Notes: `quickfile = { enabled = true }` in snacks opts.

#### words
Highlights other instances of the word under the cursor (like many IDEs do).
- [x] Current setup: none
- [x] Decision: enabled (defaults: 200ms debounce, modes n/i/c)
- [x] Notes: `words = { enabled = true }` in snacks opts. Uses LSP textDocument/documentHighlight when available.

#### scroll
Smooth scrolling animation.
- [x] Current setup: `yuttie/comfortable-motion.vim` (kept)
- [x] Decision: skip — comfortable-motion already does what's wanted with no config
- [x] Notes: Briefly enabled snacks.scroll on 2026-05-22 then reverted; comfortable-motion was satisfactory and didn't need replacing.

### Tier 2: replaces or competes with something you likely have

#### picker
Fuzzy finder. You currently use **telescope** (init.lua references it). Snacks.picker is the modern folke alternative — faster, less config, integrated with the rest of snacks.
- [x] Current setup: was telescope.nvim — migrated 2026-05-22
- [x] Decision: migrated fully
- [x] Notes: Removed telescope, telescope-fzf-native, telescope-luasnip. Kept aerial.nvim as standalone. 11 keymaps ported (`<leader>f*` group + `gd`/`gi`/`gr`/`gt`). Dropped `<leader>fsn` snippet picker (no snacks equivalent). `ui_select=true` so code-action menus / picker selects also use snacks.

#### explorer
File tree (picker-based, not a sidebar tree).
- [ ] Current setup: _______________
- [x] Decision:  skip
- [ ] Notes:

#### notifier
Replaces `vim.notify` with floating notifications. You may have **noice.nvim** (saw it in checkhealth) which already handles this.
- [ ] Current setup: noice.nvim (?)
- [x] Decision:  skip
- [ ] Notes:

#### input
Replaces `vim.ui.input` with a floating prompt. Also potentially overlaps with noice/dressing.
- [ ] Current setup: dressing.nvim (?)
- [x] Decision:  skip
- [ ] Notes:

#### statuscolumn
Better sign/number/fold column.
- [x] Current setup: default nvim statuscolumn + numbers.vim (relative numbers in normal mode)
- [x] Decision: enabled alongside numbers.vim
- [x] Notes: `statuscolumn = { enabled = true }` in snacks opts. May want to tune if it overrides numbers.vim's relative-number behavior.

#### indent
Indent guides + current-scope highlight. Overlaps with indent-blankline if you have it.
- [ ] Current setup: _______________
- [x] Decision: skip
- [ ] Notes:

#### scope
Current-scope highlighting (text objects, motions for scope). Different from `indent`'s scope viz.
- [ ] Current setup: _______________
- [x] Decision: skip
- [ ] Notes:

### Tier 3: standalone utilities (enable on demand)

#### lazygit
Floating lazygit popup. You have lazygit installed (checkhealth confirmed).
- [x] Current setup: `kdheepak/lazygit.nvim` mapped to `<leader>g`
- [x] Decision: skip — existing plugin is sufficient
- [x] Notes: Decided 2026-05-23 during the Tier 2/3/4 pass; no need to add a second lazygit integration.

#### terminal
Toggleable floating terminal.
- [ ] Current setup: _______________
- [x] Decision: skip
- [ ] Notes:

#### dashboard
Startup splash screen with recent files / shortcuts.
- [x] Current setup: none
- [x] Decision: enabled (defaults)
- [x] Notes: `dashboard = { enabled = true }` in snacks opts. Only shows when nvim is launched with no args.

### Tier 4: skip unless specifically wanted

#### image
Inline image/PDF/LaTeX/Mermaid preview. Requires imagemagick, ghostscript, tectonic, mmdc, and a terminal supporting kitty graphics protocol. **Ghostty doesn't support kitty graphics**, so this won't work for you regardless.
- [x] Decision: enabled — module loads but image rendering won't actually work on Ghostty
- [x] Notes: `image = { enabled = true }` in snacks opts. The checkhealth ❌ ERRORs for magick/gs/tectonic/mmdc/kitty-graphics are expected and won't go away unless you install those tools and switch terminals.

---

## Part 3 — Won't fix / ignore

For reference; no action needed:

- `mason`: missing `wget`, `cargo`, `composer`, `php`, `javac`, `julia`, `java` — only matters if you install mason packages needing those toolchains
- `luasnip`: jsregexp missing — only matters for LSP snippet transformations
- `nvim-treesitter`: missing `tree-sitter` CLI — only needed for `:TSInstallFromGrammar`
- `snacks.image`: kitty graphics + magick/gs/tectonic/mmdc missing — see Tier 4
- snacks "missing treesitter parsers" (css/latex/norg/scss/svelte/tsx/typst/vue) — only relevant if you enable `snacks.image`
