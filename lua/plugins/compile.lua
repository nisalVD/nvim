local keymap = require("config.utils").keymap

return {
  "ej-shafran/compile-mode.nvim",
  -- you can just use the latest version:
  -- branch = "latest",
  -- or the most up-to-date updates:
  -- branch = "nightly",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- if you want to enable coloring of ANSI escape codes in
    -- compilation output, add:
    { "m00qek/baleia.nvim", tag = "v1.3.0" },
  },
  keys = {
    { "<c-c>", "<cmd>Recompile<cr>", desc = "recompile" },
    { "<leader>cr", "<cmd>Compile<cr>", desc = "compile" },
  },
  cmd = {
    "Compile",
    "Recompile",
  },
  config = function()
    ---@type CompileModeOpts
    vim.g.compile_mode = {
      -- to add ANSI escape code support, add:
      default_command = "odin run src -out:build/program",
      baleia_setup = true,
      error_regexp_table = {
        typescript = {
          -- TypeScript errors take the form
          -- "path/to/error-file.ts(13,23): error TS22: etc."
          regex = "^\\(.\\+\\)(\\([1-9][0-9]*\\),\\([1-9][0-9]*\\)): error TS[1-9][0-9]*:",
          filename = 1,
          row = 2,
          col = 3,
        },
        odin = {

          -- /Users/nisaldon/apps/odin-starter/hellope.odin(8:3) Error: Undeclared name: sadas
          regex = "^\\(.\\+\\)(\\([1-9][0-9]*\\):\\([1-9][0-9]*\\)) Error:",
          filename = 1,
          row = 2,
          col = 3,
        },
        rust = {
          -- --> src/main.rs:6:8
          regex = "^\\s*--> \\(.\\+\\):\\([1-9][0-9]*\\):\\([1-9][0-9]*\\)",
          filename = 1,
          row = 2,
          col = 3,
        },
      },
    }

    vim.api.nvim_create_augroup("CompileMode", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      pattern = "CompilationFinished",
      group = "CompileMode",
      callback = function(event)
        local code = event.data.code
        if code ~= 0 then
          vim.cmd("QuickfixErrors")
        else
          vim.cmd("cclose")
        end
      end,
    })
  end,
}
