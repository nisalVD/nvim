local formatter = require("plugins.lsp.format")

local M = {}

function M.on_attach(_, buffnr)
  local wk = require("which-key")
  local opts = { noremap = true, silent = true, buffer = buffnr }
  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<cr>", opts)
  vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
  vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
  vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
  vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)

  wk.register({
    c = {
      e = { ":IncRename ", "Code Rename" },
      f = {
        function()
          formatter.format()
        end,
        "format file",
      },
      a = { "<cmd>Lspsaga code_action<CR>", "code actions" },
      t = {
        f = {
          function()
            formatter.toggle()
          end,
          "toggle formatter",
        },
      },
    },
  }, vim.tbl_extend("keep", { prefix = "<leader>" }, opts))

  vim.keymap.set("n", "gl", function()
    vim.diagnostic.open_float()
  end, opts)
  vim.keymap.set("n", "gL", function()
    vim.diagnostic.open_float({ scope = "line" })
  end, opts)
  vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
  vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
end

return M
