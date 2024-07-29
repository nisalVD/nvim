local options = {
  completeopt = { "menu", "noselect" }, -- mostly just for cmp
  fileencoding = "utf-8", -- the encoding written to a file
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  wrap = false, -- display lines as one long line
  expandtab = true, -- convert tabs to spaces
  tabstop = 2, -- insert 2 spaces for a tab
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  swapfile = false, -- creates a swapfile
  smartindent = true, -- make indenting smarter again
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  mouse = "a", -- allow the mouse to be used in neovim
  undofile = true, -- enable persistent undo
  updatetime = 300, -- faster completion (4000ms default)
  scrolloff = 8, -- display 8 lines on top
  sidescrolloff = 8, -- display additional 8 lines on bottom
  autoread = true, -- automatically read files when they are written to
  foldcolumn = "1", -- '0' is not bad
  foldenable = true,
  foldlevel = 99, -- Using ufo provider need a large value, feel free to decrease the value
  foldlevelstart = 99,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- leader
vim.g.mapleader = ","
vim.g.maplocalleader = " "
vim.g.skip_ts_context_commentstring_module = true
vim.cmd("set whichwrap+=<,>,[,],h,l")
