vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- open explorer
keymap.set("n", "<leader>fe", vim.cmd.Ex)

-- window mappings
vim.keymap.set('n', '<C-[>', function() vim.cmd('wincmd h') end, { silent = true })
vim.keymap.set('n', '<C-]>', function() vim.cmd('wincmd l') end, { silent = true })

-- split mappings
vim.api.nvim_set_keymap('n', '<C-n>', ':vsplit<CR>', { noremap = true, silent = true })

-- write 
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })

-- remap ctrl-c to escape to fix `InsertLeave` not being triggered (https://github.com/orgs/community/discussions/77719)
vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>', { noremap = true, silent = true })

-- float error messages
vim.api.nvim_set_keymap('n', '<leader>ef', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

-- go to definition
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
