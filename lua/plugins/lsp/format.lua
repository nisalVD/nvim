local M = {}
local disabled_filetypes_autosave = { "markdown" }

M.autoformat = true

function M.toggle()
  M.autoformat = not M.autoformat
  vim.notify(M.autoformat and "Enabled format on save" or "Disabled format on save")
end

local function is_ignore_filetype()
  local current_filetype = vim.bo.filetype

  for _, ignored_filetype in ipairs(disabled_filetypes_autosave) do
    if current_filetype == ignored_filetype then
      return true
    end
  end
  return false
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = package.loaded["null-ls"]
    and (#require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0)

  -- use go format for go files
  if ft == "go" then
    require("go.format").goimport()
    return
  end

  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      if have_nls then
        return client.name == "null-ls"
      end
      return client.name ~= "null-ls"
    end,
  })
end

function M.on_attach(client, buf)
  if
    client.config
    and client.config.capabilities
    and client.config.capabilities.documentFormattingProvider == false
  then
    return
  end
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
      buffer = buf,
      callback = function()
        if M.autoformat and not is_ignore_filetype() then
          M.format()
        end
      end,
    })
  end
end

return M
