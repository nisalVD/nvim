local M = {}
M.source = function()
  local cwd = vim.fn.getcwd(-1, -1)

  if cwd == "c:\\Users\\nisal\\code\\opengl\\learnopengl" then
    local function run_code()
      local compile_and_run = "bin\\build.bat && bin\\run.bat"
      local run_cmd = ":20 sp | :terminal " .. compile_and_run
      vim.cmd(run_cmd)
    end

    -- local opts = { noremap = true, silent = true, prefix = "<leader>" }
    require("which-key").add({
      {
        "<leader>cr",
        run_code,
        remap = false,
        silent = true,
      },
    })
    --   c = {
    --     r = { run_code, "build and run" },
    --   },
    -- }, opts)
  elseif cwd == "c:\\Users\\nisal\\code\\cpp\\cpp_test" then
    local function run_code()
      local compile_and_run = "bin\\build.bat && bin\\run.bat"
      local run_cmd = ":20 sp | :terminal " .. compile_and_run
      vim.cmd(run_cmd)
    end

    require("which-key").add({
      {
        "<leader>cr",
        run_code,
        remap = false,
        silent = true,
      },
    })
  elseif cwd == "/Users/nisaldon/apps/cpp/learnopengl" then
    local function run_code()
      local compile_and_run = "bin/build.sh && bin/run.sh"
      local run_cmd = ":20 sp | :terminal " .. compile_and_run
      vim.cmd(run_cmd)
    end

    require("which-key").add({
      {
        "<leader>cr",
        run_code,
        remap = false,
        silent = true,
      },
    })
  end
end

return M
