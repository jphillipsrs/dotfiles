return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            -- Keybindings for dap
            vim.keymap.set('n', '<leader>dab', dap.toggle_breakpoint, { silent = true })
            vim.keymap.set('n', '<leader>dacb', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { silent = true })
            vim.keymap.set('n', '<leader>dp', dap.continue, { silent = true })
            vim.keymap.set('n', '<leader>dso', dap.step_over, { silent = true })
            vim.keymap.set('n', '<leader>dsi', dap.step_into, { silent = true })
            vim.keymap.set('n', '<leader>dip', dap.repl.open, { silent = true })
            vim.keymap.set('n', '<leader>drl', dap.run_last, { silent = true })
        end
    },
    {
        "andythigpen/nvim-coverage",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("coverage").setup({
                commands = true,
                highlights = {
                    covered = { fg = "#C3E88D" },
                    uncovered = { fg = "#F07178" },
                },
                signs = {
                    covered = { hl = "CoverageCovered", text = "▎" },
                    uncovered = { hl = "CoverageUncovered", text = "▎" },
                },
                summary = {
                    min_coverage = 80.0,
                },
            })

            -- Define the function within the config scope
            local function runGoTestAndShowCoverage()
                vim.fn.system("go test ./... -coverprofile=coverage.out")
                local function checkCoverageFile()
                    if vim.loop.fs_stat("coverage.out") then
                        vim.cmd("Coverage")
                        vim.cmd("CoverageSummary")
                    else
                        vim.defer_fn(checkCoverageFile, 2000)  -- Check 2 every second
                    end
                end
                checkCoverageFile()
            end

            -- Set the keymap to run the function
            vim.keymap.set("n", "<leader>gotc", runGoTestAndShowCoverage, { noremap = true, silent = true })
        end
    }
}

