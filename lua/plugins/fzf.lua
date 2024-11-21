local status_ok, fzflua = pcall(require, "fzf-lua")
if not status_ok then
  return
end

fzflua.setup({
  "fzf-vim",
  winopts = {
    preview = { hidden = "nohidden" },
  },
  files = {
    -- disable previewer for file search only
    previewer = false,
    git_icons = false,
  },
  buffers = {
    previewer = false,
    git_icons = false,
  },
  oldfiles = {
    previewer = false,
  },
})

-- Replace the individual keymap.set calls with phong.keymaps utils
local keymaps = require("phong.keymaps")

keymaps.set({
  { "<leader>f", group = "Fzf" },
  { "n",         "<leader>fa", function() fzflua.builtin() end,     "FZF builtin commands" },
  -- fd reserved for current directory
  { "n",         "<leader>fr", function() fzflua.grep_cword() end,  "Grep word under cursor" },
  { "n",         "<leader>fR", function() fzflua.grep_cWORD() end,  "Grep WORD under cursor" },
  { "v",         "<leader>fr", function() fzflua.grep_visual() end, "Grep visual selection" },
  { "n",         "<leader>fb", function() fzflua.buffers() end,     "Buffers" },
  { "n",         "<leader>fs", function() fzflua.live_grep() end,   "Search in files (live grep)" },
  { "n",         "<leader>fo", function() fzflua.oldfiles() end,    "Old files" },
  { "n",         "<leader>ft", function() fzflua.treesitter() end,  "Treesitter symbols" },
  { "n",         "<leader>fc", function() fzflua.commands() end,    "Commands" },
  { "n",         "<C-p>",      function() fzflua.files() end,       "Find files" },
  { "n",         "<leader>fi", function()
    fzflua.live_grep({
      cmd =
      'git grep --ignore-case -h -e "^import[\\"\'[:space:]]*\\([[:alnum:]_*,{}\\n ]\\+\\)from[[:space:]]*[\\"\'[:space:]]*\\(.*\\)[\\"\'[:space:]]*" --and -e',
      git_icons = false,
      file_icons = false,
      previewer = false,
      actions = {
        ["default"] = function(selected)
          vim.fn.setreg("+", selected[1])
          vim.api.nvim_buf_set_lines(0, 1, 1, false, { selected[1] })
        end,
      },
    })
  end, "Imports" }
})

vim.cmd("FzfLua register_ui_select")

-- todo: grep selected word/word under cursor within current folder
