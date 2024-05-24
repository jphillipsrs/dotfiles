return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            -- Configure DAP for Go
            dap.adapters.go = function(callback, config)
                local handle
                local pid_or_err
                local port = 38697
                handle, pid_or_err = vim.loop.spawn("dlv", {
                    args = {"dap", "-l", "127.0.0.1:" .. port},
                    detached = true
                }, function(code)
                    handle:close()
                    print("Delve exited with exit code: " .. code)
                end)
                vim.defer_fn(
                    function()
                        callback({type = "server", host = "127.0.0.1", port = port})
                    end,
                    1000)
            end
            dap.configurations.go = {
                {
                    type = "go",
                    name = "Debug",
                    request = "launch",
                    program = "${file}"
                },
            }

            -- Configure DAP for TypeScript (using Jest)
            dap.adapters.node2 = {
                type = 'executable',
                command = 'node',
                args = { os.getenv('HOME') .. '/.vscode/extensions/ms-vscode.node-debug2-1.42.5/out/src/nodeDebug.js' },
            }
            dap.configurations.typescript = {
                {
                    type = 'node2',
                    request = 'launch',
                    name = 'Jest Tests',
                    program = '${workspaceFolder}/node_modules/jest/bin/jest',
                    args = { '--runInBand' },
                    sourceMaps = true,
                    protocol = 'inspector',
                    console = 'integratedTerminal',
                },
            }

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

            -- Function to run Go tests and show coverage
            local function runGoTestAndShowCoverage()
                vim.fn.system("go test ./... -coverprofile=coverage.out")
                local function checkCoverageFile()
                    if vim.loop.fs_stat("coverage.out") then
                        vim.cmd("Coverage")
                        vim.cmd("CoverageSummary")
                    else
                        vim.defer_fn(checkCoverageFile, 2000)  -- Check every 2 seconds
                    end
                end
                checkCoverageFile()
            end

            -- Function to run Jest tests and show coverage
            local function runJestTestAndShowCoverage()
                vim.fn.system("jest --coverage --coverageReporters=text-lcov > coverage/lcov.info")
                local function checkCoverageFile()
                    if vim.loop.fs_stat("coverage/lcov.info") then
                        vim.cmd("Coverage")
                        vim.cmd("CoverageSummary")
                    else
                        vim.defer_fn(checkCoverageFile, 2000)  -- Check every 2 seconds
                    end
                end
                checkCoverageFile()
            end

            -- Set keymaps for running tests and showing coverage
            vim.keymap.set("n", "<leader>gotc", runGoTestAndShowCoverage, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>tstc", runJestTestAndShowCoverage, { noremap = true, silent = true })
        end
    }
}

