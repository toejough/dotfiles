# Plan: disable unused language providers

## Change
Add four global disables near the top of `.config/nvim/init.lua` (after lazypath setup, before `require("lazy").setup`):

```lua
-- disable unused language providers (we don't write nvim plugins in these languages)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
```

This tells neovim to skip provider initialization, which clears the 6 missing-host warnings from `:checkhealth vim.provider`.

## Verification
- Pre: `:checkhealth vim.provider` shows 6 ⚠️ WARNINGs (node missing npm pkg, perl missing module, perl missing exec, python3 missing module, python3 unloadable, ruby missing host).
- Post: `:checkhealth vim.provider` shows 0 ⚠️ WARNINGs (each provider section reports "disabled (g:loaded_*_provider=0)").

## Risk
None. These providers are only used by nvim plugins implemented in those languages (rare). Joe doesn't write such plugins. Re-enabling is a one-line revert if ever needed.
