# Plan: telescope.nvim → snacks.picker migration

## Goal
Replace telescope.nvim with snacks.picker as the fuzzy-finder backend in `.config/nvim/init.lua`. Preserve every user-facing keymap behavior (drop only the snippet picker, which has no snacks equivalent).

## Verification (RED before GREEN)
A clean migration means:
1. `nvim --headless "+checkhealth lazy" "+qa!" 2>&1` reports **0 errors** for telescope removal (no broken specs).
2. `nvim --headless "+checkhealth snacks" "+qa!" 2>&1` reports **0 ❌ ERROR** under `Snacks ~` and **no** `setup not called` / `lazy-loaded` / `priority` warnings.
3. `grep -rn -i "telescope" /Users/joe/dotfiles/.config/nvim/` returns **no live references** (only commented-out lines from prior history are tolerable, but we'll remove those too).
4. `nvim --headless "+messages" "+qa!" 2>&1` produces no Lua errors on startup.
5. All keymaps either resolve to a `Snacks.picker.*` callable or are deliberately removed (snippet picker).

## Changes

### 1. Plugin block — remove telescope, restructure deps
**File**: `.config/nvim/init.lua` lines 191–207.

**Remove**:
```lua
{
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sharkdp/fd",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "stevearc/aerial.nvim", config = true },
    "benfowler/telescope-luasnip.nvim",
  },
  config = function()
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("aerial")
    require("telescope").load_extension("luasnip")
  end,
},
```

**Replace with**:
```lua
-- code symbol outline (was previously a telescope dep)
{ "stevearc/aerial.nvim", config = true },
-- fuzzy finder (replaces telescope)
{
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    picker = { enabled = true },
  },
},
```

Notes:
- `plenary.nvim` is no longer needed as a top-level dep here — it's still pulled in by `lazygit.nvim` (line 188) and `lazyjj.nvim` (line 213).
- `sharkdp/fd` was a lazy-managed dep — we'll rely on the system-installed `fd` binary (covered in triage.md item G).
- `aerial.nvim` becomes its own top-level entry so `:AerialToggle` still works as a sidebar.
- snacks moves from a transitive dep of `claudecode.nvim` to a top-level managed plugin; the dep declaration in claudecode's spec can stay (harmless redundancy).

### 2. Keymaps — finder mappings (lines 289–298)
Replace the `<leader>f*` group:

```lua
{
  { "<leader>fa", function() Snacks.picker() end, desc = "all pickers" },
  { "<leader>fb", function() Snacks.picker() end, desc = "builtin" },
  { "<leader>ff", function() Snacks.picker.lines() end, desc = "fuzzy find" },
  { "<leader>fg", function() Snacks.picker.git_files() end, desc = "git files" },
  { "<leader>fh", function() Snacks.picker.help() end, desc = "help" },
  { "<leader>fl", function() Snacks.picker.grep() end, desc = "live grep" },
  { "<leader>fs", group = "S[ymbols]" },
  {
    { "<leader>fsy", function() Snacks.picker.lsp_symbols() end, desc = "symbols" },
  },
},
```

Drops: `<leader>fsn` (snippet picker — no snacks equivalent).

### 3. Keymaps — LSP goto mappings (lines 505–508)
Replace inside the LspAttach autocmd:

```lua
{
  { "gd", function() Snacks.picker.lsp_definitions() end, buffer = ev.buf, desc = "definition" },
  { "gi", function() Snacks.picker.lsp_implementations() end, buffer = ev.buf, desc = "implementation" },
  { "gr", function() Snacks.picker.lsp_references() end, buffer = ev.buf, desc = "references" },
  { "gt", function() Snacks.picker.lsp_type_definitions() end, buffer = ev.buf, desc = "Type definition" },
},
```

### 4. Remove commented-out telescope reference
Line 169 (`"nvim-telescope/telescope.nvim", -- telescope menus`) is inside a commented-out neogit block. Leave it as-is — it's already inactive and removing it would touch unrelated code.

## Sequence
1. Capture current `:checkhealth` baseline for snacks (`/tmp/nvim-health-pre.txt`).
2. Apply Change 1 (plugin block).
3. Apply Change 2 (finder keymaps).
4. Apply Change 3 (LSP keymaps).
5. Run `nvim --headless "+Lazy sync" "+qa!"` to let lazy.nvim uninstall telescope and install/sync snacks.
6. Run verification commands. Iterate on failures.
7. Update `triage.md` Part 2 picker entry.
8. Commit.

## Risk / rollback
Single commit, single file (`init.lua`) — rollback is `git checkout init.lua`. The plan file itself is temporary and gets deleted in step 6.
