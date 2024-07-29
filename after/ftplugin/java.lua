local options = {
  tabstop = 4, -- insert 4 spaces for a tab
  shiftwidth = 4, -- the number of spaces inserted for each indentation
}

for k, v in pairs(options) do
  vim.opt_local[k] = v
end
