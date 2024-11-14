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
vim.opt.breakindent = true    -- Maintain indent when wrapping indented lines
vim.opt.tabstop = 2           -- Number of spaces tabs count for
vim.opt.shiftwidth = 2        -- Size of an indent
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.termguicolors = true  -- True color support
vim.opt.cursorline = true     -- highlight the current line
vim.opt.signcolumn = "yes"    -- always show signcolumn
vim.opt.scrolloff = 8
vim.opt.incsearch = true      -- highlight search term incrementally
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"


-- Package manager setup (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

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
      vim.keymap.set('n', '<leader>t', ':Neotree toggle<cr>')
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
  'cohama/lexima.vim',         -- Autopair
  'rhysd/conflict-marker.vim', -- "highlight conflicts
  "github/copilot.vim",
  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function() require('plugins.comment') end
  },
  {
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup() end
  },
  'lukas-reineke/indent-blankline.nvim', -- " Show horizontal back line
    -- Git
  "tpope/vim-fugitive", -- !git with improvement
  "tpope/vim-rhubarb",  -- hub in github
  "tpope/vim-dispatch",
})

-- Function for showing documentation
function _G.show_docs()
  local cw = vim.fn.expand('<cword>')
  if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
    vim.api.nvim_command('h ' .. cw)
  elseif vim.api.nvim_eval('coc#rpc#ready()') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
  end
end

-- Set colorscheme
vim.cmd [[colorscheme ofirkai-darkblue]]
require('phong.keymaps')
require('phong.term')
