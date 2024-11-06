local keymap = require("config.utils").keymap

local function toggle_qf()
  local res = vim.fn.getqflist({ winid = 1 })["winid"]
  if res == 0 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end

-- quick fix
vim.keymap.set("n", "<C-q>", toggle_qf)
vim.cmd([[
  xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
]])
