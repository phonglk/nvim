-- https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.lua
local setkeys = require("phong.keymaps").set
local wkadd = require("which-key").add

-- Basic vim options remain the same
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"

-- Keep the check_back_space function
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end


-- Define all mappings
setkeys({
    -- Completion navigation
    { "i", "<TAB>", [[coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()]], "Next completion item" },
    { "i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "<C-h>"]], "Previous completion item" },
    { "i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], "Confirm completion" },
    { "i", "<c-space>", "coc#refresh()", "Trigger completion" },
    -- Diagnostic navigation
    { "n", "[g", "<Plug>(coc-diagnostic-prev)", "Previous diagnostic" },
    { "n", "]g", "<Plug>(coc-diagnostic-next)", "Next diagnostic" },
    -- GoTo code navigation
    { "n", "gd", "<Plug>(coc-definition)", "Go to definition" },
    { "n", "gy", "<Plug>(coc-type-definition)", "Go to type definition" },
    { "n", "gi", "<Plug>(coc-implementation)", "Go to implementation" },
    { "n", "gr", "<Plug>(coc-references)", "Go to references" },
    -- Documentation and symbol actions
    { "n", "K", '<CMD>lua _G.show_docs()<CR>', "Show documentation" },
    { "n", "<leader>rn", "<Plug>(coc-rename)", "Rename symbol" },
    -- Code actions
    { "<leader>a", group = "Code Actions" },
    { {"x", "n"}, "<leader>aa", "<Plug>(coc-codeaction-selected)", "Code action on selected" },
    { "n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", "Code action at cursor" },
    { "n", "<leader>as", "<Plug>(coc-codeaction-source)", "Source code action" },
    { "n", "<leader>aq", "<Plug>(coc-fix-current)", "Quick fix current" },
    { "n", "<leader>ar", "<Plug>(coc-codeaction-refactor)", "Refactor code" },
    { "x", "<leader>ar", "<Plug>(coc-codeaction-refactor-selected)", "Refactor selected" },
    { "n", "<leader>al", "<Plug>(coc-codelens-action)", "Code lens action" },
    -- Formatting
    { { "x", "n" }, "<leader>af", "<Plug>(coc-format-selected)", "Format selected code" },
    -- Text objects
    { "x", "if", "<Plug>(coc-funcobj-i)", "Inner function text object" },
    { "o", "if", "<Plug>(coc-funcobj-i)", "Inner function text object" },
    { "x", "af", "<Plug>(coc-funcobj-a)", "Outer function text object" },
    { "o", "af", "<Plug>(coc-funcobj-a)", "Outer function text object" },
    { "x", "ic", "<Plug>(coc-classobj-i)", "Inner class text object" },
    { "o", "ic", "<Plug>(coc-classobj-i)", "Inner class text object" },
    { "x", "ac", "<Plug>(coc-classobj-a)", "Outer class text object" },
    { "o", "ac", "<Plug>(coc-classobj-a)", "Outer class text object" },
    -- Scrolling float windows
    { "n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', "Scroll float forward" },
    { "n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', "Scroll float backward" },
    { "i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', "Scroll float forward" },
    { "i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', "Scroll float backward" },
    { "v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', "Scroll float forward" },
    { "v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', "Scroll float backward" },

    -- Selection ranges
    { "n", "<C-s>", "<Plug>(coc-range-select)", "Select range" },
    { "x", "<C-s>", "<Plug>(coc-range-select)", "Select range" },
    -- CoCList mappings
    { "<leader>l", group = "CoC List mappings" },
    { "n", "<space>ld", ":<C-u>CocList diagnostics<cr>", "Show diagnostics" },
    { "n", "<space>le", ":<C-u>CocList extensions<cr>", "Show extensions" },
    { "n", "<space>lc", ":<C-u>CocList commands<cr>", "Show commands" },
    { "n", "<space>lo", ":<C-u>CocList outline<cr>", "Show outline" },
    { "n", "<space>ls", ":<C-u>CocList -I symbols<cr>", "Search symbols" },
    -- { "n", "<space>lj", ":<C-u>CocNext<cr>", "Next item" },
    -- { "n", "<space>lk", ":<C-u>CocPrev<cr>", "Previous item" },
    { "n", "<space>lp", ":<C-u>CocListResume<cr>", "Resume list" },
})

-- Keep the show_docs function
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end

-- Autocommands remain the same
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})

-- Commands remain the same
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
vim.api.nvim_create_user_command('Prettier', [[CocCommand prettier.forceFormatDocument]], { nargs = 0 })

-- Statusline configuration remains the same
vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")
