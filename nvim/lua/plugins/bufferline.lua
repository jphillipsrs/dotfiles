return {
    {
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('bufferline').setup({
                options = {
                    mode = 'buffers',
                    options = {
                        close_command = require('bufdelete').bufdelete
                    },
                    offsets = {
                        {
                            filetype = 'NvimTree',
                            text = 'File Explorer',
                            highlight = 'Directory',
                            separator = true,
                        }
                    },
                },
            })
            vim.api.nvim_set_keymap('n', '<C-d>', '<cmd>BufferLineCycleNext<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<C-a>', '<cmd>BufferLineCyclePrev<CR>', { noremap = true })
        end
    },
    {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup()
    end
  },
  {
    'famiu/bufdelete.nvim',
  }
}
