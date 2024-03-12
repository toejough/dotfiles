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
		-- solarized is the one true colorscheme
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
		-- nice keymapping UI!
		"folke/which-key.nvim",
		-- autosave when you change the file
		{
			"907th/vim-auto-save",
			config = function()
				vim.g.auto_save = 1
			end,
		},
		-- auotoload when the file changes you
		"djoshea/vim-autoread",
		-- lsp's & such
		{ "williamboman/mason.nvim",           config = true }, -- manage the installed LSP's
		{ "williamboman/mason-lspconfig.nvim", config = true }, -- bridge between mason & nvim-lspconfig
		"neovim/nvim-lspconfig",                          -- neovim's lsp config management
		{ "folke/neodev.nvim",     config = true },       -- custom bits for neovim's lua API that the lua LSP doesn't cover
		-- completion & snippets
		"hrsh7th/cmp-nvim-lsp",                           -- complete from lsp
		"hrsh7th/cmp-buffer",                             -- complete from buffer contents
		"hrsh7th/cmp-path",                               -- complete from filestystem
		"hrsh7th/cmp-cmdline",                            -- complete from vim's commands
		"hrsh7th/nvim-cmp",                               -- completion core plugin
		-- snippets
		{
			"L3MON4D3/LuaSnip",
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end
		},
		"saadparwaiz1/cmp_luasnip",   -- completion from snippets
		"benfowler/telescope-luasnip.nvim", -- telescope snippet picker
		-- smooth scrolling instead of just jumping the screen
		"yuttie/comfortable-motion.vim",
		-- move visually selected blocks & retain selection
		{ "echasnovski/mini.move", config = true },
		-- treesitter for parsing/querying/highlighting/folding/indenting/selecting
		{
			"nvim-treesitter/nvim-treesitter",
			version = nil,
			build = ":TSUpdate",
		},
		-- nicer UI for borders & stuff
		"stevearc/dressing.nvim",
		{
			-- nicer UI for notifications, messages, and commandline
			"folke/noice.nvim",
			config = true,
			dependencies = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			}
		},
		-- fish niceties, because there's no fish LSP in mason
		"dag/vim-fish",
		-- keeps your function header on-screen if you're in a function but the header would be scrolled
		-- off the top.
		"nvim-treesitter/nvim-treesitter-context",
		-- move anywhere on-screen with just a few keys
		{ "smoka7/hop.nvim",       config = true },
		-- git blame on each line
		"f-person/git-blame.nvim",
		-- nice statusline
		{
			'nvim-lualine/lualine.nvim',
			config = true,
			dependencies = { 'nvim-tree/nvim-web-devicons' },
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
		-- commenting
		{ "numToStr/Comment.nvim", opts = { mappings = false } },
		-- relative numbers in the sidebar while in normal mode
		"myusuf3/numbers.vim",
		-- file tree explorer
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
				"3rd/image.nvim",  -- Optional image support in preview window: See `# Preview Mode` for more information
			}
		},
		-- like git, but for undo!
		{
			"mbbill/undotree",
			config = function()
				-- set undofile & directory
				vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
				vim.opt.undofile = true
			end
		},
		-- jump around the functions in a file
		{ "stevearc/aerial.nvim", config = true },
		-- fuzzy find
		{
			'nvim-telescope/telescope.nvim',
			branch = '0.1.x',
			dependencies = {
				'nvim-lua/plenary.nvim',
				'sharkdp/fd',
				{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
			},
			config = function()
				require('telescope').load_extension('fzf')
				require("telescope").load_extension("aerial")
				require('telescope').load_extension('luasnip')
			end,
		},
		-- open a file to the last position you were at
		"farmergreg/vim-lastplace",
	},
	-- try to load one solarized when starting an installation during startup
	{ install = { colorscheme = { "solarized" } } }
)

-- Set up leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- make all tabs and indents 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- use the system clipboard for nice copy/paste between other apps & vim
vim.opt.clipboard = "unnamed"

-- how many lines to leave if possible at top/bottom when scrolling
vim.opt.scrolloff = 13

-- Set up some keymaps
local wk = require("which-key")
wk.register({
	["m"] = {
		name = "+move",
		w = { ":HopWord<cr>", "words" },
		p = { ":HopPattern<cr>", "pattern" },
		v = { ":HopVertical<cr>", "vertical" },
		h = { ":HopWordCurrentLine<cr>", "horizontal" }
	},
	["<leader>t"] = { ":Neotree toggle<cr>", "fileTree" },
	["<leader>u"] = { vim.cmd.UndotreeToggle, "undotree" },
	["<leader>s"] = { ":Telescope aerial<cr>", "symbols" },
	["<leader>f"] = { ":Telescope<cr>", "find" },
	["<leader>S"] = { ":Telescope luasnip<cr>", "snippets" },
})
wk.register({
	["<leader><space>"] = { '<plug>(comment_toggle_linewise_current)', "toggle comment" },
})
wk.register({
	["<leader><space>"] = { '<plug>(comment_toggle_linewise_visual)', "toggle comment" },
}, {
	mode = { "v" },
})

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
	-- default lsp handler.
	function(server_name)
		require("lspconfig")[server_name].setup {
			capabilities = capabilities
		}
	end,
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
		-- format on save with configured LSP's
		vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

		-- Buffer local mappings.
		local opts = { buffer = ev.buf }
		wk.register({
			["g"] = {
				name = "+goto",
				d = { ":Telescope lsp_definitions<cr>", "definition" },
				i = { ":Telescope lsp_implementations<cr>", "implementation" },
				t = { ":Telescope lsp_type_definitions<cr>", "Type definition" },
				r = { ":Telescope lsp_references<cr>", "references" },
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
			node_incremental = "+",
			scope_incremental = false,
			node_decremental = "-",
		},
	},
})

-- use treesitter folding
vim.cmd [[set foldmethod=expr]]
vim.cmd [[set foldexpr=nvim_treesitter#foldexpr()]]
vim.cmd [[set nofoldenable]]
