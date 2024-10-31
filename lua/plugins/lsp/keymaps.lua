local formatter = require("plugins.lsp.format")
local keymap = require('config.utils').keymap

local M = {}

function M.on_attach(_, buffnr)
  -- keymaps
  keymap("n", "K", function() vim.lsp.buf.hover() end, {desc = "lsp hover"})
  keymap("n", "<C-k>", vim.lsp.buf.signature_help, {desc = "lsp signature help"})
  keymap("n", "gd", function() vim.lsp.buf.definition() end, {desc = "go to definition"})
  keymap("n", "gD", function() vim.lsp.buf.declaration() end, {desc = "go to declaration"})
  keymap("n", "gi", function() vim.lsp.buf.implementation() end, {desc = "go to implementation"})
  keymap("n", "go", function() vim.lsp.buf.type_definition() end, {desc = "go to type definition"})
  keymap("n", "gr", function() vim.lsp.buf.references() end, {desc = "find references"})

  keymap("n", "gr", function() vim.lsp.buf.references() end, {desc = "find references"})

  -- formatting
  keymap("n", "<leader>tf", function()
    formatter.toggle()
  end, { desc = "toggle format", buffer = buffnr })
  keymap("n", "<leader>ti", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = "toggle inlay hints", buffer = buffnr })


  keymap("n", "<leader>cf", function()
    formatter.format()
  end, { desc = "format file", buffer = buffnr })

  keymap(
    "n",
    "<leader>ca",
    function() vim.lsp.buf.code_action() end,
    { desc = "code action", silent = true, buffer = buffnr }
  )

  -- diagnostics
  keymap("n", "gl", function() vim.diagnostic.open_float() end, {desc = "open diagnostic float"})
  keymap("n", "gL", function() vim.diagnostic.open_float({ scope = "line" }) end, {desc = "open line diagnostics"})
  keymap("n", "[d", function() vim.diagnostic.goto_prev() end, {desc = "go to previous diagnostic"})
  keymap("n", "]d", function() vim.diagnostic.goto_next() end, {desc = "go to next diagnostic"})
end

return M
