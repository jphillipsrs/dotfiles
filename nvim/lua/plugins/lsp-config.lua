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
				ensure_installed = { "lua_ls", "gopls", "rust_analyzer", "tsserver"}
			})
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
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.formatting.prettier,
                }
            })

            -- Format on save
            on_attach = on_attach
        end
    },
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
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
                root_dir = lspconfig.util.root_pattern("package.json"),
            })

        end
    }
}
