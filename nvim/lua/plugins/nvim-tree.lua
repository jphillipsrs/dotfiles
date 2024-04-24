function navigate_nvim_tree(direction)
    -- Save the current window ID
    local current_win = vim.api.nvim_get_current_win()

    -- Find the nvim-tree window
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if string.find(buf_name, 'NvimTree') then
            -- Switch to the nvim-tree window
            vim.api.nvim_set_current_win(win)

            -- Send the navigation command
            vim.cmd('normal ' .. direction)

            -- Return to the previously focused window
            vim.api.nvim_set_current_win(current_win)
            return
        end
    end
end

function select_and_focus_file_in_nvim_tree()
    local tree_win = nil

    -- Find the nvim-tree window
    for _, win in pairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)):find('NvimTree') then
            tree_win = win
            break
        end
    end

    if not tree_win then return end

    -- Focus the nvim-tree window and open the file
    vim.api.nvim_set_current_win(tree_win)
    vim.api.nvim_input('<CR>')

    -- Wait briefly for nvim-tree to open the file, then switch to that window
    vim.defer_fn(function()
        for _, win in pairs(vim.api.nvim_list_wins()) do
            if win ~= tree_win and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'buftype') == '' then
                vim.api.nvim_set_current_win(win)
                break
            end
        end
    end, 100) -- Delay in milliseconds, adjust as needed
end

-- Global variable to store the last active window ID
_G.last_active_win_id = nil

function toggle_nvim_tree_focus()
    local nvim_tree_view = require('nvim-tree.view')

    -- Get the current window ID
    local current_win_id = vim.api.nvim_get_current_win()

    -- Check if nvim-tree is focused
    if nvim_tree_view.is_visible() and current_win_id == nvim_tree_view.get_winnr() then
        -- If nvim-tree is focused, switch back to the last active window
        if _G.last_active_win_id and vim.api.nvim_win_is_valid(_G.last_active_win_id) then
            vim.api.nvim_set_current_win(_G.last_active_win_id)
        end
    else
        -- Store the current window ID
        _G.last_active_win_id = current_win_id
        -- Focus nvim-tree
        nvim_tree_view.focus()
    end
end

return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}

            update_focused_file = {
                enabled = true,
                update_cwd = true,
            }

            local keymap = vim.keymap

            keymap.set("n", "<leader>tr", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
            keymap.set("n", "<leader>ft", "<cmd>lua toggle_nvim_tree_focus()<CR>", { desc = "Toggle file tree" })
            keymap.set("n", "<leader>fl", ":NvimTreeFindFile<CR>", {noremap = true, silent = true})


            -- Move between nvim-tree windows
            keymap.set("n", "<C-w>", "<cmd>lua navigate_nvim_tree('k')<CR>", { noremap = true, silent = true })
            keymap.set("n", "<C-s>", "<cmd>lua navigate_nvim_tree('j')<CR>", { noremap = true, silent = true })
            keymap.set("n", "<C-e>", "<cmd>lua select_and_focus_file_in_nvim_tree()<CR>", { noremap = true, silent = true })
        end,
    },
    {
        -- Ensure that any deleted buffers are done so without deleting nvim-tree
        "famiu/bufdelete.nvim",
        config = function()
            vim.keymap.set("n", "<leader>q", "<cmd>lua require('bufdelete').bufdelete(0, true)<CR>", { noremap = true, silent = true })
        end
    },
    {
        "nvim-tree/nvim-web-devicons",
    }
}
