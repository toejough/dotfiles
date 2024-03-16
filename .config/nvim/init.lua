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
			priority = 1000, -- make sure to load this before all the other start plugins
			config = function()
				-- load the colorscheme here
				vim.opt.termguicolors = true
				vim.cmd([[colorscheme solarized-flat]])
			end,
		},

		-- nice keymapping UI/system
		"folke/which-key.nvim",

		-- file state interactions
		-- autosave when you change the file
		{ "907th/vim-auto-save",               config = function() vim.g.auto_save = 1 end },
		-- auotoload when the file changes you
		"djoshea/vim-autoread",
		-- open a file to the last position you were at
		"farmergreg/vim-lastplace",
		-- like git, but for undo!
		{
			"mbbill/undotree",
			config = function()
				-- set undofile & directory
				vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
				vim.opt.undofile = true
			end
		},

		-- lsp's & such
		-- manage the installed LSP's
		{ "williamboman/mason.nvim",           config = true },
		-- bridge between mason & nvim-lspconfig
		{ "williamboman/mason-lspconfig.nvim", config = true },
		-- neovim's lsp config management
		"neovim/nvim-lspconfig",
		-- custom bits for neovim's lua API that the lua LSP doesn't cover
		{ "folke/neodev.nvim",               config = true },
		-- fish niceties, because there's no fish LSP in mason
		"dag/vim-fish",

		-- completion
		"hrsh7th/nvim-cmp",   -- core completion plugin
		"hrsh7th/cmp-nvim-lsp", -- complete from lsp
		"hrsh7th/cmp-buffer", -- complete from buffer contents
		"hrsh7th/cmp-path",   -- complete from filestystem
		"hrsh7th/cmp-cmdline", -- complete from vim's commands
		"saadparwaiz1/cmp_luasnip", -- complete from snippets

		-- snippets
		-- provides snippet framework
		{
			"L3MON4D3/LuaSnip",
			-- provides a bunch of actual snippets
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},

		-- movement
		-- move the screen: smooth scrolling instead of just jumping the screen
		"yuttie/comfortable-motion.vim",
		-- move things on the screen: visually selected blocks & retain selection
		{ "echasnovski/mini.move",           config = true },
		-- move around the screen: hop around with just a few keys
		{ "smoka7/hop.nvim",                 config = true },

		-- treesitter for parsing/querying/highlighting/folding/indenting/selecting
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

		-- UI
		-- nicer UI for borders & stuff
		"stevearc/dressing.nvim",
		-- nicer UI for notifications, messages, and commandline
		{
			"folke/noice.nvim",
			config = true,
			dependencies = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			}
		},
		-- keeps your function header from scrolling off-screen
		"nvim-treesitter/nvim-treesitter-context",
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
		-- relative numbers in the sidebar while in normal mode
		"myusuf3/numbers.vim",

		-- commenting
		{ "numToStr/Comment.nvim",   opts = { mappings = false } },

		-- file tree explorer
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim", -- plugin utils
				"nvim-tree/nvim-web-devicons", -- cool icons
				"MunifTanjim/nui.nvim", -- nice UI utils
				"3rd/image.nvim",  -- image support in preview window
			}
		},

		-- git
		-- git blame on each line
		"f-person/git-blame.nvim",
		-- git signs for code state along the left sidebar
		{ "lewis6991/gitsigns.nvim", config = true },
		-- git UI in vim
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim", -- plugin utils
				"sindrets/diffview.nvim", -- Diff integration
				"nvim-telescope/telescope.nvim", -- telescope menus
			},
			config = true
		},

		-- fuzzy find
		{
			'nvim-telescope/telescope.nvim',
			branch = '0.1.x',
			dependencies = {
				'nvim-lua/plenary.nvim',
				'sharkdp/fd',
				{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
				{ "stevearc/aerial.nvim",                     config = true },
				"benfowler/telescope-luasnip.nvim",
			},
			config = function()
				require('telescope').load_extension('fzf') -- fzf fuzzy search
				require("telescope").load_extension("aerial") -- file symbols
				require('telescope').load_extension('luasnip') -- snippets
			end,
		},
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
wk.register({ -- normal mode
	["H"] = {
		name = "+hunk",
		s = { ":Gitsigns preview_hunk_inline<cr>", "show" },
		r = { ":Gitsigns reset_hunk<cr>", "reset" },
	},
	["C"] = { '<plug>(comment_toggle_linewise_current)', "toggle comment" },
	["<leader>"] = {
		name = "+interfaces",
		t = { ":Neotree toggle<cr>", "fileTree" },
		u = { vim.cmd.UndotreeToggle, "undotree" },
		f = {
			name = "+find",
			a = { ":Telescope builtin include_extensions=true<cr>", "all" },
			b = { ":Telescope builtin include_extensions=true<cr>", "builtin" },
			s = {
				name = "+s[ymbols|nippets]",
				y = { ":Telescope aerial<cr>", "symbols" },
				n = { ":Telescope luasnip<cr>", "snippets" },
			},
			f = { ":Telescope current_buffer_fuzzy_find<cr>", "fuzzy find" },
			g = { ":Telescope git_files<cr>", "git files" },
			l = { ":Telescope live_grep<cr>", "live grep" },
			h = { ":Telescope help_tags<cr>", "help" },
		},
		l = { ":Mason<cr>", "lsp packages" },
		p = { ":Lazy<cr>", "plugins" },
	},
})
wk.register({ -- visual mode
	["C"] = { '<plug>(comment_toggle_linewise_visual)', "toggle comment" },
}, {
	mode = { "v" },
})
local hop = require("hop")
local tsHop = require("hop-treesitter")
wk.register({  -- normal AND visual mode
	["m"] = {
		name = "+move",
		w = { hop.hint_words, "words" },
		p = { hop.hint_patterns, "pattern" },
		v = { hop.hint_vertical, "vertical" },
		a = { hop.hint_anywhere, "anywhere" },
		n = { tsHop.hint_nodes, "nodes" },
		h = { function() hop.hint_words({ current_line_only = true }) end, "horizontal" }
	},
}, {
	mode = { "n", "v" },
})

-- set up completion
local cmp = require('cmp')

cmp.setup({
	snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
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
	sources = { { name = 'buffer' } }
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})

-- set up each LSP with completion by cmp_nvim_lsp	
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("mason-lspconfig").setup_handlers {
	-- default lsp handler.
	function(server_name)
		require("lspconfig")[server_name].setup {
			capabilities = capabilities,
		}
	end,
	-- dedicated handlers for specific servers.
	["gopls"] = function()
		require('lspconfig').gopls.setup {
			on_attach = function(_, b)
				if vim.lsp.inlay_hint then
					vim.lsp.inlay_hint.enable(b, true)
				end
			end,
			-- hint = { enabled = true },
			capabilities = capabilities,
			settings = {
				gopls = {
					allExperiments         = true,
					["ui.inlayhint.hints"] = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				}
			}
		}
	end
}

-- Global lsp mappings.
wk.register({
	["g"] = {
		name = "+Goto",
		p = { vim.diagnostic.goto_prev, "Previous error" },
		n = { vim.diagnostic.goto_next, "Next error" },
	},
	["s"] = {
		name = "+Show",
		e = { vim.diagnostic.open_float, "Error" },
		l = { vim.diagnostic.setloclist, "show errors in Location list" },
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
			["L"] = {
				name = "+lsp",
				r = { vim.lsp.buf.rename, "rename" },
				f = { vim.lsp.buf.format, "format" },
			},
		}, { buffer = ev.buf })
		wk.register({
			["L"] = {
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
