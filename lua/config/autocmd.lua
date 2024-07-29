local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
-- persistent folds

local save_fold = augroup("Persistent Folds", { clear = true })
autocmd("BufWinLeave", {
  pattern = "*.*",
  callback = function()
    vim.cmd.mkview()
  end,
  group = save_fold,
})
autocmd("BufWinEnter", {
  pattern = "*.*",
  callback = function()
    vim.cmd.loadview({ mods = { emsg_silent = true } })
  end,
  group = save_fold,
})

vim.api.nvim_exec(
  [[
augroup SetMarkdownFileType
  autocmd!
  autocmd BufRead,BufNewFile /Users/nisaldon/Library/Containers/co.noteplan.NotePlan3/Data/Library/Application\ Support/co.noteplan.NotePlan3/Notes/** setfiletype markdown
augroup END
]],
  false
)
-- vim.cmd([[
--     augroup projectconfig
--     autocmd!
--
--
--     autocmd DirChanged * if v:event.scope ==# "global" | call v:lua.require('config.projectconfig').source() | endif
--
--     if v:vim_did_enter
--     lua require("config.projectconfig").source()
--     else
--     autocmd VimEnter * lua require("config.projectconfig").source()
--     endif
--     augroup END
-- ]])
