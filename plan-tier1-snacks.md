# Plan: enable snacks.nvim Tier 1 modules

## Goal
Enable the 4 Tier 1 snacks modules (bigfile, quickfile, words, scroll) marked decided in triage.md Part 2. Resolve the scroll conflict by removing `comfortable-motion.vim`.

## Changes

### 1. Update snacks opts
File: `.config/nvim/init.lua` — the snacks spec block.

From:
```lua
opts = {
  picker = { enabled = true, ui_select = true },
},
```

To:
```lua
opts = {
  picker = { enabled = true, ui_select = true },
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  words = { enabled = true },
  scroll = { enabled = true },
},
```

All four use sensible defaults — no extra config needed.

### 2. Remove comfortable-motion.vim
File: `.config/nvim/init.lua` — line 101.

Remove the entry:
```lua
"yuttie/comfortable-motion.vim",
```

And the surrounding comment if it becomes orphaned.

## Verification (RED → GREEN)
1. Pre-state: `nvim --headless "+doautocmd UIEnter" "+checkhealth snacks" "+w! /tmp/snacks-pre-tier1.txt" "+qa!"`. Expect 4 modules with `setup {disabled}` warnings.
2. Apply changes.
3. `nvim --headless "+Lazy! sync" "+qa!"` to uninstall comfortable-motion.
4. Post-state: `nvim --headless "+doautocmd UIEnter" "+checkhealth snacks" "+w! /tmp/snacks-post-tier1.txt" "+qa!"`. Expect:
   - `Snacks.bigfile ~ ✅ OK setup {enabled}` (not disabled)
   - `Snacks.quickfile ~ ✅ OK setup {enabled}`
   - `Snacks.words ~ ✅ OK setup {enabled}`
   - `Snacks.scroll ~ ✅ OK setup {enabled}`
   - No new errors elsewhere.
5. Smoke test: `nvim --headless "+messages" "+qa!"` produces no errors.
6. Confirm `comfortable-motion` is gone from `~/.local/share/nvim/lazy/`.

## Risk
Minimal — module enables only. Rollback = `git checkout init.lua`. The scroll replacement may feel slightly different from comfortable-motion; if Joe dislikes it he can re-add comfortable-motion or tune `opts.scroll.animate.duration`.
