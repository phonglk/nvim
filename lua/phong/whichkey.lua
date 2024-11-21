local wk = require("which-key")

wk.setup({
  preset = "helix",
  show_help = true,
  show_keys = true,
  disable = {
    bt = {},
    ft = {},
  },
  win = {
    wo = {
      winblend = 10,
    }
  }
})

wk.add({
  {
    "<leader>?",
    function()
      require("which-key").show({ global = false })
    end,
    desc = "Buffer Local Keymaps (which-key)",
  },
})
