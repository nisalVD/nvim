local M = {}
local wk = require("which-key")

local function run_code()
  local compile_and_run = "make && build\\debug\\play.exe"
  local run_cmd = ":20 sp | :terminal " .. compile_and_run
  vim.cmd(run_cmd)
end

function M.register_cpp_binds(buffnr)
  wk.add({
    {
      "<leader>cr",
      function()
        vim.cmd(":OverseerRun build_and_run")
        vim.cmd(":OverseerOpen bottom")
      end,
      desc = "Overseer run and build",
      remap = false,
      silent = true,
      buffer = buffnr,
    },
  })
end

return M
