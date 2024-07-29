local M = {}
local wk = require("which-key")

local function run_code()
  local compile_and_run = "make && build\\debug\\play.exe"
  local run_cmd = ":20 sp | :terminal " .. compile_and_run
  vim.cmd(run_cmd)
end

function M.register_cpp_binds(buffnr)
  local opts = { noremap = true, silent = true, buffer = buffnr, prefix = "<leader>" }
  wk.register({
    c = {
      r = {
        function()
          vim.cmd(":OverseerRun build_and_run")
          vim.cmd(":OverseerOpen bottom")
        end,
        "Overseer run and build",
      },
    },
  }, opts)
end

return M
