local default_opts = { noremap = true, silent = true, nowait = true }

-- Enhanced keymap function with description support
local function keymap(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    local options = vim.tbl_extend("force", default_opts, opts, { desc = desc })
    -- If the rhs is a string and contains a Vim expression (contains '?' or ':')
    if type(rhs) == "string" and (rhs:match("?") or rhs:match("coc#") or rhs:match("copilot#")) then
        options.expr = true
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Batch keymap setter
-- example input
-- {
-- { "<leader>a", group = "Code Action" }, -- which-key.add 
-- { "x", "<leader>aa", "<Plug>(coc-codeaction-selected)", "Code action on selected" }, -- keymap
-- { "n", "<leader>aa", "<Plug>(coc-codeaction-selected)", "Code action on selected" },
-- }
local function set(mappings)
    for _, mapping in ipairs(mappings) do
        -- Check if this is a which-key group definition
        if mapping.group then
            -- Assuming which-key is already setup and has an .add method
            require("which-key").add({
                mapping
            })
        else
            -- Regular keymap
            local mode, lhs, rhs, desc = unpack(mapping)
            keymap(mode, lhs, rhs, desc)
        end
    end
end

-- leader key
vim.g.mapleader = ' '

-- Define all keymaps in a table
local mappings = {
    -- Visual
    { "v", "<", "<gv", "Indent left" },
    { "v", ">", ">gv", "Indent right" },
    -- Move text up and down
    { "v", "<M-j>", ":m .+1<CR>==", "Move selected text down" },
    { "v", "<M-k>", ":m .-2<CR>==", "Move selected text up" },
    -- Replace without yank
    { "v", "p", '"_dP', "Paste without yanking replaced text" },
    -- Visual Block
    { "x", "J", ":move '>+1<CR>gv-gv", "Move block down" },
    { "x", "K", ":move '<-2<CR>gv-gv", "Move block up" },
    { "x", "<M-j>", ":move '>+1<CR>gv-gv", "Move block down (Alt)" },
    { "x", "<M-k>", ":move '<-2<CR>gv-gv", "Move block up (Alt)" },
    
    -- clipboard
    { { "n", "v" }, "<leader>y", '"+y', "Copy to system clipboard" },
    { { "n", "v" }, "<leader>p", '"+p', "Paste from system clipboard after cursor" },
    { { "n", "v" }, "<leader>P", '"+P', "Paste from system clipboard before cursor" },
    
    -- git-fugitive keymaps
    { "n", "<leader>ds", vim.cmd.Gvdiffsplit, "Git: Open vertical diff split" },
    { "n", "<leader>dt", ':G difftool --name-only<CR>', "Git: Show files with differences" },
    { "n", "<leader>mt", ':G mergetool <CR>', "Git: Open merge tool" },
    
    -- terminal
    { 't', '<Esc>', '<C-\\><C-n>', "Exit terminal mode" },
    
    -- window
    -- { 'n', '<c-Tab>', '<C-^>', "Toggle between current and last buffer" },
    { 't', '<c-r>', function()
        local next_char_code = vim.fn.getchar()
        local next_char = vim.fn.nr2char(next_char_code)
        return '<C-\\><C-N>"' .. next_char .. 'pi'
    end, "Paste from register in terminal mode" },
    
    -- buffer
    { 'n', '<leader>x', ':bn|bd#<CR>', "Close current buffer" },
    { 'n', '<leader>X', ':bn|bd#!<CR>', "Force close current buffer" },
    
    -- Copilot
    -- { 'i', '<C-J>', 'copilot#Accept("\\<CR>")', "Accept Copilot suggestion", { replace_keycodes = false, expr = true } },
}
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})


-- Apply all mappings
set(mappings)
vim.g.copilot_no_tab_map = true

-- Export the keymap utilities
return {
    keymap = keymap,
    set = set
}
