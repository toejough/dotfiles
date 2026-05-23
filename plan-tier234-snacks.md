# Plan: enable snacks Tier 2/3/4 modules

## Goal
Enable the three modules marked "enable" in triage.md Part 2 Tiers 2–4
(after conflict resolution):

- `statuscolumn` (Tier 2) — alongside numbers.vim
- `dashboard` (Tier 3) — no conflict
- `image` (Tier 4) — enable despite Ghostty incompatibility; module loads but image rendering won't work

Skip: `lazygit` (existing kdheepak/lazygit.nvim is fine).

## Changes

### 1. Update snacks opts
File: `.config/nvim/init.lua` — the snacks spec block.

From:
```lua
opts = {
  picker = { enabled = true, ui_select = true },
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  words = { enabled = true },
},
```

To:
```lua
opts = {
  picker = { enabled = true, ui_select = true },
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  words = { enabled = true },
  statuscolumn = { enabled = true },
  dashboard = { enabled = true },
  image = { enabled = true },
},
```

## Verification (RED → GREEN)
1. Pre-state: `nvim --headless "+doautocmd UIEnter" "+checkhealth snacks" "+w! /tmp/snacks-pre-t234.txt" "+qa!"`. Expect statuscolumn/dashboard/image with `setup {disabled}`.
2. Apply changes.
3. Post-state same command → `/tmp/snacks-post-t234.txt`. Expect:
   - `Snacks.statuscolumn ~ ✅ OK setup {enabled}`
   - `Snacks.dashboard ~ ✅ OK setup {enabled}`
   - `Snacks.image ~ ✅ OK setup {enabled}` (image will still throw the magick/gs/kitty errors — those are environmental, not regressions)
   - No new errors elsewhere.
4. Smoke test: no Lua startup errors.

## Risk
- `statuscolumn` could visually surprise — adds sign + number + fold marks to the gutter. Rollback by removing the entry from opts.
- `dashboard` only triggers on `nvim` with no args. Won't interfere with `nvim <file>` workflows.
- `image` enabling on Ghostty just means it loads but can't render — no harm.

Rollback for any: `git checkout init.lua`.
