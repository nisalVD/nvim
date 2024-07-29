vim.opt_local.conceallevel = 2

-- set keybinding to ctrl-enter to follow link with Obsidian Link
-- vim.api.nvim_buf_set_keymap(0, 'n', '<C-Enter>', '<Cmd>lua require("obsidian").follow_link()<CR>', { noremap = true, silent = true })
local opts = { noremap = true, silent = true }
