local M = {}
local wk = require("which-key")

local function run_current_file()
  local current_file = vim.fn.expand("%:h") .. "/" .. vim.fn.expand("%:t")
  local jar_file = "/Users/nisaldon/JavaJars/algs4.jar"
  local current_working_folder_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

  local out_dir = "out/production/" .. current_working_folder_name

  local compile_cmd = "javac -cp "
    .. jar_file
    .. " "
    .. vim.fn.expand("%:h")
    .. "/*"
    .. " "
    .. current_file
    .. " "
    .. "-d "
    .. out_dir

  local run_java = "java -cp " .. vim.fn.getcwd() .. "/" .. out_dir .. ":" .. jar_file .. " " .. vim.fn.expand("%:t:r")
  print(run_java)

  local run_cmd = ":20 sp | :terminal " .. compile_cmd .. " && " .. run_java

  vim.cmd(run_cmd)
end

function M.register_java_keymaps(buffnr)
  local opts = { noremap = true, silent = true, buffer = buffnr, prefix = "<leader>" }
  wk.register({
    c = {
      r = {
        function()
          run_current_file()
        end,
        "Run Current File",
      },
      o = {
        function()
          require("jdtls").organize_imports()
        end,
        "Organize Imports",
      },
      t = {
        c = {
          function()
            require("jdtls").test_class()
          end,
          "Test Nearest Class",
        },
        m = {
          function()
            require("jdtls").test_nearest_method()
          end,
          "Test Method",
        },
      },
    },
  }, opts)
end

return M
