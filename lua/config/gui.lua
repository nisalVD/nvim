if vim.g.neovide then
  vim.o.guifont = "Hack Nerd Font:h12"
  vim.g.neovide_cursor_animation_length = 0
  vim.keymap.set("n", "<A-v>", '"+p', { noremap = true })
  -- remap <c-v> to paste from clipboard in insert mode insert mode key is <c-r>+
  vim.keymap.set("i", "<A-v>", "<C-r>+", { noremap = true })
  -- codeium
  vim.g.codeium_disable_bindings = 1
end
