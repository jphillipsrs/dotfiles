return {
    {
        -- Use for Go debugging
        "leoluz/nvim-dap-go",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            local dapgo = require("dap-go")
            dapgo.setup()
            require('dap').adapters.go.executable.detached = false

            -- Keybindings
            vim.keymap.set('n', '<leader>dgot', dapgo.debug_test, { silent = true })
        end
    },
    {
        -- Use for building, testing 
        "fatih/vim-go",
        config = function()
            -- Unmap all keybindings for vim-go as they fuck with nvim-tree
            vim.g.go_def_mapping_enabled = 0

            local keymap = vim.keymap

            keymap.set("n", "<leader>got", "<cmd>GoTest<CR>", { desc = "Run go tests" })
            keymap.set("n", "<leader>gotf", "<cmd>GoTestFunc<CR>", { desc = "Run go test function" })
            keymap.set("n", "<leader>gob", "<cmd>GoBuild<CR>", { desc = "Build go code" })
            keymap.set("n", "<leader>gor", "<cmd>GoRun<CR>", { desc = "Run go code" })
            keymap.set("n", "<leader>goi", "<cmd>GoInstall<CR>", { desc = "Install go code" })
        end
    }
}

