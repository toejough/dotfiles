# Plan: fix conform.nvim deprecated config-as-table

## Change
File: `.config/nvim/init.lua` line 233. Rename `config = { ... }` → `opts = { ... }` on the `stevearc/conform.nvim` spec. lazy.nvim then passes the table to `require("conform").setup(opts)`, which is the correct path.

## Verification
- Pre: `:checkhealth lazy` shows `⚠️ WARNING {conform.nvim}: setting a table to Plugin.config is deprecated`.
- Post: that warning is gone.
- Format-on-save behavior unchanged (formatters_by_ft and format_on_save options are passed identically).

## Risk
None — `Plugin.opts` is the documented modern API; conform.nvim's `setup()` accepts the same shape.
