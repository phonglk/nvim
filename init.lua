-- Set leader key to space
vim.g.mapleader = " "

-- Basic settings
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.mouse = 'a'           -- Enable mouse support
vim.opt.ignorecase = true     -- Case insensitive search
vim.opt.smartcase = true      -- But case sensitive when uppercase present
vim.opt.hlsearch = false      -- Don't highlight search results
vim.opt.wrap = false          -- Don't wrap lines
vim.opt.termguicolors = true  -- True color support
vim.opt.cursorline = true     -- highlight the current line
vim.opt.signcolumn = "yes"    -- always show signcolumn
vim.opt.scrolloff = 8
vim.opt.incsearch = true      -- highlight search term incrementally
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Indentation settings
vim.opt.tabstop = 2           -- Number of spaces tabs count for
vim.opt.shiftwidth = 2        -- Size of an indent
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.smartindent = true    -- Enable smart indenting
vim.opt.autoindent = true     -- Copy indent from current line when starting a new line
vim.opt.breakindent = true    -- Maintain indent when wrapping lines
vim.opt.preserveindent = true -- Preserve indent structure when reindenting


-- Package manager setup (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

local function get_git_root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if handle then
    local result = handle:read("*l")
    handle:close()
    return result
  end
end

local git_root = get_git_root()
if git_root then
  local dprint_dir = git_root .. "/tools/dprint"
  if vim.fn.isdirectory(dprint_dir) == 1 then
    vim.g.dprint_dir = dprint_dir
    vim.g.dprint_format_on_save = 1 
    vim.g.dprint_system_command = 'Dispatch'
    vim.g.dprint_debug = 0
  end
end


-- Plugin specifications
require("lazy").setup({ -- Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000
  }, -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim"
    },
    config = function()
      vim.keymap.set('n', '<leader>t', ':Neotree toggle<cr>', { desc= 'Toggle tree' })
      vim.keymap.set('n', '<leader>T', ':Neotree reveal<cr>')
    end
  }, -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function() require('plugins.treesitter') end
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function() require('plugins.treesitter-context') end
  },
  {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function() require('plugins.coc') end
  },
  {
    "sourcegraph/sg.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- If you have a recent version of lazy.nvim, you don't need to add this!
    build = "nvim -l build/init.lua",
    config = function() require("sg").setup() end
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.fzf") end
  },
  'ofirgall/ofirkai.nvim', -- better monokai
  'machakann/vim-sandwich',
  { 'beloglazov/vim-textobj-quotes', dependencies = { 'kana/vim-textobj-user' } },
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" } }
  },
  {
    'David-Kunz/jester',
    config = function()
      local jester = require('jester')
      jester.setup({ path_to_jest_run = "yarn jest" })
      vim.keymap.set("n", "<leader>jr", function() jester.run() end)
      vim.keymap.set("n", "<leader>jf", function()
        jester.run_file()
      end)
    end
  },
  {
    'phaazon/hop.nvim',
    config = function()
      local hop = require('hop')
      hop.setup({ key = 'etovxpqdgfblzhckisuran' })
      vim.keymap.set('', '<leader>hw', ':HopWordAC<CR>', { remap = true })
      vim.keymap.set('', '<leader>hW', ':HopWordBC<CR>', { remap = true })
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() require('plugins.lualine') end
  },
  'rhysd/conflict-marker.vim', -- "highlight conflicts
  "github/copilot.vim",
  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function() require('plugins.comment') end
  },
  {
    "folke/which-key.nvim",
    dependencies = { 'echasnovski/mini.icons' },
    event = "VeryLazy",
    config = function() require('phong.whichkey') end,
  },
  {
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup() end
  },
  {
    'lukas-reineke/indent-blankline.nvim', -- " Show horizontal back line
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    config = function()
      require('ibl').setup()
    end
  },
  -- Git
  "tpope/vim-fugitive",                  -- !git with improvement
  "tpope/vim-rhubarb",                   -- hub in github
  "tpope/vim-dispatch",
  {
    url = "org-2562356@github.com:Canva/dprint-vim-plugin.git",
    lazy = false,
  }

  -- {
  --   "ldelossa/gh.nvim",
  --   dependencies = {
  --     {
  --       "ldelossa/litee.nvim",
  --       config = function()
  --         require("litee.lib").setup()
  --       end,
  --     },
  --   },
  --   config = function()
  --     require("litee.gh").setup()
  --   end,
  -- }

})



-- Set colorscheme
vim.cmd [[colorscheme ofirkai-darkblue]]

-- Add reload config command
vim.api.nvim_create_user_command('ReloadVimConfig', function()
  vim.cmd('source $MYVIMRC')
  vim.notify('Neovim config reloaded!', vim.log.levels.INFO)
end, { desc = 'Reload Neovim configuration' })

require('phong.keymaps')
require('phong.term')
require('phong.checkoutpr')
require('phong.pathutil')
