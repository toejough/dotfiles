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
				vim.cmd([[colorscheme solarized]])
			end,
		},
		{ "folke/which-key.nvim", lazy = true },
		-- autosave
		{
			"907th/vim-auto-save",
			config = function()
				vim.g.auto_save = 1
			end,
		},
		-- auotoread
		"djoshea/vim-autoread",
		-- lsp's & such
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"folke/neodev.nvim",
		-- completion
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		-- animated movement / scroll
		"yuttie/comfortable-motion.vim",
		-- move things around
		"echasnovski/mini.move",
		-- treesitter for parsing/querying/highlighting/folding/indenting/selecting
		{
			"nvim-treesitter/nvim-treesitter",
			version = nil,
			build = ":TSUpdate",
		},
		-- nicer UI
		"stevearc/dressing.nvim",
		-- fish niceties
		"dag/vim-fish",
		-- shows the context of your current place (what function are you in)
		"nvim-treesitter/nvim-treesitter-context",
		-- hop around the screen
		"smoka7/hop.nvim",
		-- git blame
		"f-person/git-blame.nvim",
		-- only highlight where you are
		"folke/twilight.nvim",
		-- nice statusline
		-- TODO: where else can we get the default setup called via config = true?
		{
			'nvim-lualine/lualine.nvim',
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			config = true,
		},
		-- rainbow delimiters
		"HiPhish/rainbow-delimiters.nvim",
		-- indent animation
		{
			"echasnovski/mini.indentscope",
			opts = {
				symbol = "│",
				options = { try_as_border = true },
			},
		},
		-- numbers.vim
		"myusuf3/numbers.vim",
	},
	-- try to load one of these colorschemes when starting an installation during startup
	{ install = { colorscheme = { "solarized" } } }
)

-- Set up leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- make all tabs and indents 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- how many lines to leave if possible at top/bottom when scrolling
vim.opt.scrolloff = 13

-- format on save with configured LSP's
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Set up some keymaps
local wk = require("which-key")

-- hop around the screen
require("hop").setup()
wk.register({
	["<leader>h"] = {
		name = "+hop",
		w = { ":HopWord<cr>", "words" },
		p = { ":HopPattern<cr>", "pattern" },
		v = { ":HopVertical<cr>", "vertical" },
		h = { ":HopWordCurrentLine<cr>", "horizontal" }
	}
})
-- not necessary with mini-move?
-- wk.register({
--	["<"] = { "<gv", "unindent" },
--	[">"] = { ">gv", "indent" },
-- }, { mode = "v" })

-- mason setup for installing lsp servers
require("neodev").setup()          -- allows neovim autocompletion
require("mason").setup()           -- lsp server management
require("mason-lspconfig").setup() -- lsp config help

-- set up completion
local cmp = require('cmp')

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	-- TODO: use which_key?
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?`
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- set up each LSP with completion by cmp_nvim_lsp	
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("mason-lspconfig").setup_handlers {
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {
			capabilities = capabilities
		}
	end,
	-- Next, you can provide a dedicated handler for specific servers.
	-- For example, a handler override for the `rust_analyzer`:
	--["rust_analyzer"] = function ()
	--    require("rust-tools").setup {}
	--end
}

-- Global lsp mappings.
wk.register({
	["<leader>e"] = {
		name = "+Error",
		s = { vim.diagnostic.open_float, "Show error" },
		p = { vim.diagnostic.goto_prev, "goto Previous error" },
		n = { vim.diagnostic.goto_next, "goto Next error" },
		l = { vim.diagnostic.setloclist, "set errors in Location list" },
	},
	["g"] = {
		name = "+Goto",
		p = { vim.diagnostic.goto_prev, "Previous error" },
		n = { vim.diagnostic.goto_next, "Next error" },
	},
	["s"] = {
		name = "+Show",
		e = { vim.diagnostic.open_float, "Error" },
	}
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		wk.register({
			["g"] = {
				name = "+goto",
				D = { vim.lsp.buf.declaration, "declaration" },
				d = { vim.lsp.buf.definition, "definition" },
				i = { vim.lsp.buf.implementation, "implementation" },
				t = { vim.lsp.buf.type_definition, "Type definition" },
				r = { vim.lsp.buf.references, "references" },
			},
			["s"] = {
				name = "+Show",
				d = { vim.lsp.buf.hover, "documentation" },
				s = { vim.lsp.buf.signature_help, "Signature help" },
			},
		}, opts)
		wk.register({
			["<leader>l"] = {
				name = "+lsp",
				r = { vim.lsp.buf.rename, "rename" },
				f = { vim.lsp.buf.format, "format" },
			},
		}, opts)
		wk.register({
			["<leader>l"] = {
				name = "+lsp",
				a = { vim.lsp.buf.code_action, "code Action" },
			},
		}, {
			mode = { "n", "v" },
			buffer = ev.buf
		})
	end,
})

-- mini move to move blocks of text and keep them selected
require("mini.move").setup()

-- treesitter config
require('nvim-treesitter.configs').setup({
	ensure_installed = {
		"bash",
		"c",
		"diff",
		"fish",
		"go",
		"html",
		"javascript",
		"jsdoc",
		"json",
		"jsonc",
		"lua",
		"luadoc",
		"luap",
		"markdown",
		"markdown_inline",
		"python",
		"query",
		"regex",
		"toml",
		"vim",
		"vimdoc",
		"xml",
		"yaml",
	},
	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = false, -- set to `false` to disable one of the mappings
			node_incremental = "m",
			scope_incremental = false,
			node_decremental = "l",
		},
	},
})

-- use treesitter folding
vim.cmd [[set foldmethod=expr]]
vim.cmd [[set foldexpr=nvim_treesitter#foldexpr()]]
vim.cmd [[set nofoldenable]]
