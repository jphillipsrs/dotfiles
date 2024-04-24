return {
	{ 'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-path',
			'saadparwaiz1/cmp_luasnip',
			'L3MON4D3/LuaSnip',
			'rafamadriz/friendly-snippets',
			'hrsh7th/cmp-buffer',
			'onsails/lspkind-nvim',
		},

		config = function()
			local cmp = require('cmp')
			local lspkind = require('lspkind')
			local luasnip = require('luasnip')
			require('luasnip/loaders/from_vscode').lazy_load()

			cmp.setup({
				window = {
					documentation = {
						border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
					},
					completion = {
						border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
						winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
					},
				},
				formatting = {
					fields = { 'abbr', 'kind' },
					format = lspkind.cmp_format({
						with_text = true,
						maxwidth = 50,
						menu = {
							luasnip = '[LuaSnip]',
							nvim_lsp = '[LSP]',
							buffer = '[BUFFER]',
							nvim_lua = '[Lua]',
							path = '[PATH]',
						},
					}),
				},

				sources = cmp.config.sources({
					{ name = 'luasnip' },
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
					{ name = 'nvim_lua' },
					{ name = 'path' },
				}),

				mapping = {
					['<Enter>'] = cmp.mapping.confirm({ select = true }),

					['<C-j>'] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback() -- This is where the regular Tab action occurs if cmp is not visible
						end
					end,

					['<C-k>'] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback() -- Similar to <Tab>, but for Shift+Tab, adjust as needed
						end
					end,
				},
				snippet = {
					expand = function(args)
						if not luasnip then
							return
						end
						luasnip.lsp_expand(args.body)
					end,
				},
			})
		end,
		init = function()
			vim.opt.pumheight = 10
			vim.opt.completeopt = 'menu,menuone,noselect'
		end,
	}
}

