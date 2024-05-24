return {
	"goolord/alpha-nvim",
	opts = function()
		local header = { opts = { hl = "Type", position = "center" }, type = "text", val = {} }
		header.val = {
			"",
			"",                                                                                
			[[                               .               . ............... .             ]], 
			[[                          ......         ....... ....... ....... ..            ]], 
			[[                      .........   ***    ....... ............... ..            ]], 
			[[                    ........    *****.   ... ... ... ... ... ... ...           ]], 
			[[                  .........    *******    ...... ............... ...           ]], 
			[[                 .........   .*********   ...... ....            ....          ]], 
			[[               ..........     *********    ..... ..    /////////   ...         ]], 
			[[              ...........     ,*********     . . .   ////////////  . .         ]], 
			[[             .............     *********.   .... .   ///////////   ....        ]], 
			[[            ...............     *********    ... ...             .......       ]], 
			[[           .................    **********   ... ............... .......       ]], 
			[[          ..................     *********    .. ... ... ... ... ... ...       ]], 
			[[         ........ .........      **********    . ............... .........     ]], 
			[[       .......    .......         *********.   . ....... ....... ....... .     ]], 
			[[      .....     .....         ,(   *********     ............... ..........    ]], 
			[[    ....      ....          ####   **********                                  ]], 
			[[  .         ..            #######   *********    ...                           ]], 
			[[                        ########(   **********                 ***********     ]], 
			[[                      ########%%%%   ********     **********************       ]], 
			[[                ./// #######%%%%%%   ,*****     **********************         ]], 
			[[               /////  ###%%%%%%%      ***     *********************,           ]], 
			[[                ////// .%%%%%               .***.                              ]], 
			[[         ///  (  ///////                                 ..........            ]], 
			[[        ///// ((  *////////                   ....................             ]], 
			[[        ////// ((((   ////               ........................              ]], 
			[[     ##  ///////                      ..........................               ]], 
			[[    ##### */////////                .........  ...............                 ]], 
			[[     ######  //////                .....    ...............                    ]], 
			[[        *##(                             ...............                       ]], 
			[[                                     ............                              ]], 
  		[[                                   ...                                         ]],
      [[                       __  _      _   __             __  ___                   ]],                        
      [[                      /__)/_| /  /_| /  )//| ) __  //  )(_                     ]],
      [[                     /   (  |(__(  |/(_/(/ |/     (/(_/ /__                    ]],
		}
		local footer = { opts = { hl = "Special", position = "center" }, type = "text", val = {} }
		local lazystats = { opts = { spacing = 1 }, type = "group", val = {} }

		return {
			layout = {
				header,
				{ type = "padding", val = 1 },
				footer,
				{ type = "padding", val = 1 },
				lazystats,
			},
			section = {
				header = header,
				footer = footer,
				lazystats = lazystats,
			},
		}
	end,
	config = function(_, opts)
		require("alpha").setup(opts)

		vim.api.nvim_create_autocmd("User", {
			group = vim.api.nvim_create_augroup("TuoGroup", { clear = false }),
			pattern = "LazyVimStarted",
			callback = function()
				local stats = require("lazy").stats()
				local footer_val = string.format(
					"󱐋 %d/%d plugins loaded in %.3f ms",
					stats.loaded,
					stats.count,
					stats.startuptime
				)
				opts.section.footer.val = footer_val
				for _, s in ipairs({ "LazyStart", "LazyDone", "UIEnter" }) do
					table.insert(opts.section.lazystats.val, {
						opts = {
							hl = "Special",
							position = "center",
						},
						type = "text",
						val = string.format("%s %.3f ms", s, stats.times[s]),
					})
				end
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}
