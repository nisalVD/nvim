local M = {}
local wk = require("which-key")
local rt = require("rust-tools")

local function run_code()
  local current_file = vim.fn.expand("%:h") .. "/" .. vim.fn.expand("%:t")
  local deno_run = "deno run " .. current_file
  local run_cmd = ":20 sp | :terminal " .. deno_run
  vim.cmd(run_cmd)
end

function M.register_rust_keymaps(buffnr)
  local opts = { noremap = true, silent = true, buffer = buffnr, prefix = "<leader>" }
  wk.register({
    c = {
      r = { run_code, "run deno" },
    },
  }, opts)
end

return M
