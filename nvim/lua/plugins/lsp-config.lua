-- Define a common on_attach function for all LSPs
local function on_attach(client, bufnr)
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end

return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "gopls", "rust_analyzer", "tsserver", "eslint", "jdtls" }
            })
        end
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
        config = function()
            local jdtls = require("jdtls")
            local home = os.getenv("HOME")
            local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

            local config = {
                cmd = {
                    home .. "/.config/nvim/scripts/java-lsp.sh", workspace_folder
                },
                root_dir = require("jdtls.setup").find_root({".git", "mvnw", "gradlew"}),
                settings = {
                    java = {
                        eclipse = {
                            downloadSources = true,
                        },
                        configuration = {
                            updateBuildConfiguration = "interactive",
                        },
                        maven = {
                            downloadSources = true,
                        },
                        implementationsCodeLens = {
                            enabled = true,
                        },
                        referencesCodeLens = {
                            enabled = true,
                        },
                        references = {
                            includeDecompiledSources = true,
                        },
                        format = {
                            enabled = true,
                        },
                    },
                },
                on_attach = on_attach,
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            }

            jdtls.start_or_attach(config)
        end
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    -- Go
                    null_ls.builtins.formatting.gofumpt,
                    null_ls.builtins.formatting.goimports_reviser,
                    null_ls.builtins.formatting.golines,

                    -- JavaScript
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.diagnostics.eslint.with({
                        filetypes = {"javascript", "typescript"}
                    }),
                    null_ls.builtins.code_actions.eslint.with({
                        filetypes = {"javascript", "typescript"}
                    }),
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require('lspconfig.ui.windows').default_options.border = 'rounded'
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', '<leader>fd', vim.lsp.buf.definition, {})
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})

            -- Lua
            lspconfig.lua_ls.setup({})

            -- Go 
            lspconfig.gopls.setup {
                cmd = { "gopls", "serve" },
                on_attach = on_attach,
                settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        analyses = {
                            unusedparams = true,
                        },
                    },
                },
            }

            -- Rust
            lspconfig.rust_analyzer.setup({})

            -- JavaScript
            lspconfig.tsserver.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern("package.json"),
            })

            -- Java
            lspconfig.jdtls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end
    }
}

