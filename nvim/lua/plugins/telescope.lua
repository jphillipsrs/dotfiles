return {
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local actions = require('telescope.actions')
			local builtin = require('telescope.builtin')

			-- Add function to highlight tabs in Telescope results (https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1873229658)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "TelescopeResults",
				callback = function(ctx)
					vim.api.nvim_buf_call(ctx.buf, function()
						vim.fn.matchadd("TelescopeParent", "\t\t.*$")
						vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
					end)
				end,
			})
			local function filenameFirst(_, path)
				local tail = vim.fs.basename(path)
				local parent = vim.fs.dirname(path)
				if parent == "." then return tail end
				return string.format("%s\t\t%s", tail, parent)
			end

			require('telescope').setup({
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						}
					},
					path_display = filenameFirst,
				},
				pickers = {
					find_files = {
						path_display = filenameFirst,
					}
				}
			})

			vim.keymap.set("n", "<leader>tt", function() builtin.find_files({ no_ignore = true }) end)
			vim.keymap.set("n", "<leader>fu", function() builtin.lsp_references({ wrap_results = true }) end)
			vim.keymap.set("n", "<leader>fi", function() builtin.lsp_implementations() end)
		end

	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown {
						}
					}
				},
			})
			require("telescope").load_extension("ui-select")
		end
	}
}
