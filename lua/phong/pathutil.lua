local function get_paths()
    local absolute_path = vim.fn.expand("%:p")
    local relative_path = vim.fn.expand("%:.")
    local relative_to_web_root = get_relative_to_root("web")
    local relative_to_web_src_root = get_relative_to_root("src", "web")
    return {
        { label = "Absolute path: " .. absolute_path, value = absolute_path },
        { label = "Relative path: " .. relative_path, value = relative_path },
        { label = "Web root path: " .. relative_to_web_root, value = relative_to_web_root },
        { label = "Web src path: " .. relative_to_web_src_root, value = relative_to_web_src_root },
    }
end

local function copyPath()
    vim.ui.select(get_paths(), {
        prompt = "Select path to copy:",
        format_item = function(item)
            return item.label
        end
    }, function(choice)
        if choice then
            vim.fn.setreg("+", choice.value)
            vim.notify("Copied to clipboard: " .. choice.value)
        end
    end)
end

-- Create the command
vim.api.nvim_create_user_command('CopyPath', copyPath, { desc = 'Copy current file path to clipboard' })

-- Set up the keymap
require("phong.keymaps").set({
    { "<leader><leader>", group = "Copy stuffs" },
    { "n", "<leader><leader>cp", ":CopyPath<CR>", "Select and copy path" },
}) 

-- Helper function to get path relative to a root directory
local function get_relative_to_root(root_dir, parent_dir)
    local file_path = vim.fn.expand("%:p")
    local search_path = parent_dir and (vim.fn.finddir(parent_dir, vim.fn.expand("%:p:h") .. ";") .. ";") or (vim.fn.expand("%:p:h") .. ";")
    local root = vim.fn.finddir(root_dir, search_path)
    
    if root ~= "" then
        root = vim.fn.fnamemodify(root, ":p")
        if file_path:find(root, 1, true) == 1 then
            return file_path:sub(#root + 1)
        end
    end
    return vim.fn.expand("%:.")
end 