-- options

-- make all tabs and indents 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- no swapfile or backup files, please. these are clutter.
vim.opt.swapfile = false
vim.opt.backup = false

-- put a nice color column at column 120 (the maxlen I generally want my lines to be)
vim.opt.colorcolumn = "120"

-- 50ms updatetime. fast responses to the cursor stopping.
vim.opt.updatetime = 50

-- set undofile & directory
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- Configure LazyVim to load solarized
    {
      "LazyVim/LazyVim",
      dependencies = { "maxmx03/solarized.nvim" },
      opts = {
        colorscheme = "solarized",
      },
    },
    -- Add fzy native
    {
      "telescope.nvim",
      dependencies = {
        "nvim-telescope/telescope-fzy-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzy_native")
        end,
      },
    },
    -- add symbols-outline
    {
      "simrat39/symbols-outline.nvim",
      cmd = "SymbolsOutline",
      keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
      config = true,
    },
    -- fish
    { "dag/vim-fish" },
    -- undotree
    {
      "mbbill/undotree",
      -- config = function()
      --   vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Undotree" })
      -- end,
      keys = { { "<leader>U", vim.cmd.UndotreeToggle, desc = "Undotree" } },
    },
    -- shows the context of your current place (what function are you in)
    { "nvim-treesitter/nvim-treesitter-context" },
    -- lolol fun cellular automaton stuff - rain & game of life
    {
      "eandrju/cellular-automaton.nvim",
      keys = {
        -- lolol make all the characters fall.
        { "<leader>mir", "<cmd>CellularAutomaton make_it_rain<CR>" },
        -- lolol make all the characters do conway's game of life.
        { "<leader>gol", "<cmd>CellularAutomaton game_of_life<CR>" },
      },
    },
    -- smoother scrolling
    { "yuttie/comfortable-motion.vim" },
    -- autosave
    {
      "907th/vim-auto-save",
      config = function()
        vim.g.auto_save = 1
      end,
    },
    -- set cwd to the git root
    {
      "airblade/vim-rooter",
      config = function()
        vim.g.rooter_manual_only = 0
      end,
    },
    -- better git conflict resolution
    { "christoomey/vim-conflicted" },
    -- rainbow parens
    {
      "luochen1990/rainbow",
      config = function()
        vim.g.rainbow_active = 1
      end,
    },
    -- distraction free mode
    { "junegunn/goyo.vim" },
    -- color names & color codes
    { "chrisbra/Colorizer" },
    -- I don't like these for movement - I'd rather use hop
    { "ggandor/flit.nvim", enabled = false },
    { "ggandor/leap.nvim", enabled = false },
    -- faster/fuzzier searching in buffers
    {
      "phaazon/hop.nvim",
      branch = "v2", -- optional but strongly recommended
      config = function()
        -- you can configure Hop the way you like here; see :h hop-config
        require("hop").setup()
      end,
      keys = {
        {
          "s",
          function()
            require("hop").hint_patterns()
          end,
        },
        {
          "S",
          function()
            require("hop").hint_words()
          end,
        },
      },
    },
    -- git blame info
    { "f-person/git-blame.nvim" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Other autocmds

-- change current working directory for the local file when you switch buffers
-- http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
-- autocmd BufEnter * silent! lcd %:p:h
vim.api.nvim_create_autocmd("BufEnter", { command = "silent! lcd %:p:h" })

-- Other keymaps

-- in visual mode, paste and push the pasted value back into the _ register.
-- the [[ ]] are just lua syntax for a string literal: https://www.lua.org/pil/2.4.html#:~:text=Strings%20have%20the%20usual%20meaning,in%20Lua%20are%20immutable%20values.
-- "_dP is explained here: https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text
-- basically it deletes to the blackhole register, rather than the normal one. This leaves the normal one alone.
vim.keymap.set({ "n", "v" }, "<leader>p", [["_dP]], { desc = "Repeatable paste" })

-- delete to the black hole register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole" })
