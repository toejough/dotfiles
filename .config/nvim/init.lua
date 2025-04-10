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
				vim.cmd([[colorscheme solarized]])
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

		-- surround
		{ "tpope/vim-surround" },
		{ "windwp/nvim-ts-autotag" },

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
		{ "numToStr/Comment.nvim",  opts = { mappings = false } },

		-- file tree explorer
		{ 'echasnovski/mini.files', version = '*',              config = true },
		{ 'echasnovski/mini.icons', version = '*',              config = true },

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
local hop = require("hop")
local tsHop = require("hop-treesitter")
wk.add({
	{ "<leader>", group = "Interfaces" },
	{
		{ "<leader>f",  group = "Find" },
		{
			{ "<leader>fa", ":Telescope builtin include_extensions=true<cr>", desc = "all" },
			{ "<leader>fb", ":Telescope builtin include_extensions=true<cr>", desc = "builtin" },
			{ "<leader>ff", ":Telescope current_buffer_fuzzy_find<cr>",       desc = "fuzzy find" },
			{ "<leader>fg", ":Telescope git_files<cr>",                       desc = "git files" },
			{ "<leader>fh", ":Telescope help_tags<cr>",                       desc = "help" },
			{ "<leader>fl", ":Telescope live_grep<cr>",                       desc = "live grep" },
			{ "<leader>fs", group = "S[ymbols|nippets]" },
			{
				{ "<leader>fsn", ":Telescope luasnip<cr>", desc = "snippets" },
				{ "<leader>fsy", ":Telescope aerial<cr>",  desc = "symbols" },
			},
		},
		{ "<leader>g",  ":Neogit<cr>",               desc = "git" },
		{ "<leader>l",  ":Mason<cr>",                desc = "lsp packages" },
		{ "<leader>p",  ":Lazy<cr>",                 desc = "plugins" },
		{ "<leader>t", ":lua MiniFiles.open()<cr>", desc = "fileMiniTree" },
		{ "<leader>u",  vim.cmd.UndotreeToggle,      desc = "undotree" },
	},
	{ "C",        "<plug>(comment_toggle_linewise_current)", desc = "toggle comment" },
	{ "C",        "<plug>(comment_toggle_linewise_visual)",  desc = "toggle comment", mode = "v" },
	{ "H",        group = "Hunk" },
	{
		{ "HS", ":Gitsigns stage_hunk<cr>",          desc = "stage" },
		{ "Hn", ":Gitsigns next_hunk<cr>",           desc = "next" },
		{ "Hp", ":Gitsigns prev_hunk<cr>",           desc = "previous" },
		{ "Hr", ":Gitsigns reset_hunk<cr>",          desc = "reset" },
		{ "Hs", ":Gitsigns preview_hunk_inline<cr>", desc = "show" },
		{ "Hu", ":Gitsigns undo_stage_hunk<cr>",     desc = "unstage last" },
	},
	{ "g", group = "Goto" },
	{
		{ "gn", vim.diagnostic.goto_next, desc = "Next error" },
		{ "gp", vim.diagnostic.goto_prev, desc = "Previous error" },
	},
	{ "s", group = "Show" },
	{
		{ "se", vim.diagnostic.open_float, desc = "Error" },
		{ "sl", vim.diagnostic.setloclist, desc = "show errors in Location list" },
	},
	{
		mode = { "n", "v" },
		{ "m",  group = "move" },
		{ "ma", hop.hint_anywhere,                                           desc = "anywhere" },
		{ "mh", function() hop.hint_words({ current_line_only = true }) end, desc = "horizontal" },
		{ "mn", tsHop.hint_nodes,                                            desc = "nodes" },
		{ "mp", hop.hint_patterns,                                           desc = "pattern" },
		{ "mv", hop.hint_vertical,                                           desc = "vertical" },
		{ "mw", hop.hint_words,                                              desc = "words" },
	},
})

-- set up completion
local cmp = require('cmp')
local cmptypes = require('cmp.types')
-- overall setup
cmp.setup({
	snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
	mapping = cmp.mapping.preset.insert({
		['<tab>'] = cmp.mapping.select_next_item({ behavior = cmptypes.cmp.SelectBehavior.Insert }),
		['<s-tab>'] = cmp.mapping.select_prev_item({ behavior = cmptypes.cmp.SelectBehavior.Insert }),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
		['<C-Space>'] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' }, -- use if lsp/snip sources are empty
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

-- LSP setup
require("mason-lspconfig").setup_handlers {
	-- default lsp handler.
	function(server_name) require("lspconfig")[server_name].setup({}) end,
	-- dedicated handlers for specific servers.
	["gopls"] = function()
		require('lspconfig').gopls.setup {
			settings = {
				gopls = {
					allExperiments = true,
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
	end,
	["golangci_lint_ls"] = function()
		require('lspconfig').golangci_lint_ls.setup {
			filetypes = { 'go', 'gomod' },
			cmd = { 'golangci-lint-langserver' },
			root_dir = require('lspconfig').util.root_pattern('.git', 'go.mod'),
			init_options = {
				command = { "golangci-lint", "run", "-c", "dev/golangci.toml", "--out-format", "json", "--issues-exit-code=1" },
			}
		}
	end,
	["lua_ls"] = function()
		require('lspconfig').lua_ls.setup {
			settings = {
				Lua = {
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						-- This was bonkers hard to figure out. Found the right config snippet
						-- here, for a different server that uses the same config structure
						-- https://neovim.discourse.group/t/how-to-suppress-warning-undefined-global-vim/1882/3
						globals = { 'vim' },
					},
				},
			},
		}
	end,
	-- the volar & TS stuff came from https://github.com/williamboman/mason-lspconfig.nvim/issues/371#issuecomment-2249935162
	["volar"] = function()
		require("lspconfig").volar.setup({
			-- NOTE: Uncomment to enable volar in file types other than vue.
			-- (Similar to Takeover Mode)

			-- filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },

			-- NOTE: Uncomment to restrict Volar to only Vue/Nuxt projects. This will enable Volar to work alongside other language servers (tsserver).

			-- root_dir = require("lspconfig").util.root_pattern(
			--   "vue.config.js",
			--   "vue.config.ts",
			--   "nuxt.config.js",
			--   "nuxt.config.ts"
			-- ),
			init_options = {
				vue = {
					hybridMode = false,
				},
				-- NOTE: This might not be needed. Uncomment if you encounter issues.

				-- typescript = {
				--   tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
				-- },
			},
			settings = {
				typescript = {
					inlayHints = {
						enumMemberValues = {
							enabled = true,
						},
						functionLikeReturnTypes = {
							enabled = true,
						},
						propertyDeclarationTypes = {
							enabled = true,
						},
						parameterTypes = {
							enabled = true,
							suppressWhenArgumentMatchesName = true,
						},
						variableTypes = {
							enabled = true,
						},
					},
				},
			},
		})
	end,

	["ts_ls"] = function()
		local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
		local volar_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"

		require("lspconfig").ts_ls.setup({
			-- NOTE: To enable hybridMode, change HybrideMode to true above and uncomment the following filetypes block.
			-- WARN: THIS MAY CAUSE HIGHLIGHTING ISSUES WITHIN THE TEMPLATE SCOPE WHEN TSSERVER ATTACHES TO VUE FILES

			-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = volar_path,
						languages = { "vue" },
					},
				},
			},
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		})
	end,
}

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- set up inlay hints (https://neovim.io/doc/user/lsp.html#lsp-inlay_hint)
		if vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(true)
			-- set up colors I like better
			vim.api.nvim_set_hl(0, 'LspInlayHint', {
				italic = true,
				fg = vim.g.terminal_color_10, -- comment grey
				underdotted = true, -- indicate this thing is different
				sp = vim.g.terminal_color_4, -- blue for some subtle standout
			})
		end
		-- format on save with configured LSP's
		local client = vim.lsp.get_active_clients()[1]

		-- Client may be nil
		if client then
			-- Check if the server supports formatting
			if client.supports_method("textDocument/formatting") then
				vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
			end
		end
		-- key mappings
		wk.add({
			{ "L", group = "lsp", mode = { "n", "v" } },
			{
				{ "Lf", vim.lsp.buf.format,      buffer = ev.buf, desc = "format" },
				{
					"Li",
					function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end,
					buffer = ev.buf,
					desc = "toggle inlay hints"
				},
				{ "Lr", vim.lsp.buf.rename,      buffer = ev.buf, desc = "rename" },
				{ "La", vim.lsp.buf.code_action, buffer = ev.buf,      desc = "code Action", mode = { "n", "v" } },
			},
			-- { "g", group = "goto" }, --this group should already exist
			{
				{ "gd", ":Telescope lsp_definitions<cr>",      buffer = ev.buf, desc = "definition" },
				{ "gi", ":Telescope lsp_implementations<cr>",  buffer = ev.buf, desc = "implementation" },
				{ "gr", ":Telescope lsp_references<cr>",       buffer = ev.buf, desc = "references" },
				{ "gt", ":Telescope lsp_type_definitions<cr>", buffer = ev.buf, desc = "Type definition" },
			},
			-- { "s", group = "Show" }, -- this group should already exist
			{
				{ "sd", vim.lsp.buf.hover,          buffer = ev.buf, desc = "documentation" },
				{ "ss", vim.lsp.buf.signature_help, buffer = ev.buf, desc = "Signature help" },
			},
		})
	end,
})

-- treesitter
-- overall config
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
	indent = { enable = false }, -- this was not working well for me with go.
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

-- set textwidth
vim.cmd [[set textwidth=120]]
