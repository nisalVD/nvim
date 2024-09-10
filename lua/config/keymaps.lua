local keymap = vim.keymap.set
local utils = require("config.utils")

-- rebind alternate file key to alt enter
-- keymap("n", "<leader>f", ":Ex<cr>", { noremap = true })

local function toggle_qf()
  local res = vim.fn.getqflist({ winid = 1 })["winid"]
  if res == 0 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end

-- quick fix
keymap("n", "<C-q>", toggle_qf)
vim.cmd([[
  xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
]])
