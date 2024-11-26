---@diagnostic disable: inject-field
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
    {
      -- Customize or remove this keymap to your liking
      "<leader>tf",
      function()
        if vim.b.disable_autoformat == true then
          vim.b.disable_autoformat = false
          vim.notify("enabled on save for buffer")
          return
        end
        vim.b.disable_autoformat = true
        vim.notify("disabled format on save for buffer")
      end,
      mode = "",
      desc = "Toggle format buffer",
    },
    {
      -- Customize or remove this keymap to your liking
      "<leader>tF",
      function()
        if vim.g.disable_autoformat == true then
          vim.g.disable_autoformat = false
          vim.notify("enabled format on save")
          return
        end
        vim.g.disable_autoformat = true
        vim.notify("disabled format on save")
      end,
      mode = "",
      desc = "Toggle format global",
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      svelte = { "prettierd", "prettier", stop_after_first = true },
      astro = { "prettierd", "prettier", stop_after_first = true },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      graphql = { "prettierd", "prettier", stop_after_first = true },
      java = { "google-java-format" },
      kotlin = { "ktlint" },
      ruby = { "standardrb" },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      erb = { "htmlbeautifier" },
      html = { "htmlbeautifier" },
      bash = { "beautysh" },
      proto = { "buf" },
      rust = { "rustfmt" },
      yaml = { "yamlfix" },
      toml = { "taplo" },
      css = { "prettierd", "prettier", stop_after_first = true },
      scss = { "prettierd", "prettier", stop_after_first = true },
      sh = { "shellcheck" },
      go = { "gofmt" },
      sql = { "sql-formatter" },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      local ignore_filetypes = {}
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match("/node_modules/") then
        return
      end
      -- ...additional logic...
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    -- Customize formatters
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
