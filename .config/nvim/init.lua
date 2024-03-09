-- Set up Lazy.nvim as my package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Install some packages
require("lazy").setup(
	{
		{
			"ishan9299/nvim-solarized-lua",
			lazy = false, -- make sure we load this during startup if it is your main colorscheme
			priority = 1000, -- make sure to load this before all the other start plugins
			config = function()
				-- load the colorscheme here
				vim.opt.termguicolors = true
				vim.cmd([[colorscheme solarized-high]])
			end,
		},
		{ "folke/which-key.nvim", lazy = true },
	},
	-- try to load one of these colorschemes when starting an installation during startup
	{install = {colorscheme = { "solarized" }}}
)

-- Set up some keymaps
local wk = require("which-key")
wk.register({["<"] = { "<gv", "unindent"}}, {mode="v"})
wk.register({[">"] = { ">gv", "indent"}}, {mode="v"})

-- make all tabs and indents 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
