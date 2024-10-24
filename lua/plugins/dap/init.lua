local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text" },
      { "nvim-telescope/telescope-dap.nvim" },
      { "jbyuki/one-small-step-for-vimkind" },
      { "jay-babu/mason-nvim-dap.nvim" },
      { "nvim-neotest/nvim-nio" },
      -- { "LiadOz/nvim-dap-repl-highlights", opts = {} },
      {
        "microsoft/vscode-js-debug",
        build = "npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out",
        version = "1.91.0",
      },
      {
        "mxsdev/nvim-dap-vscode-js",
        opts = {
          debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
          adapters = { "chrome", "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
        },
      },
    },
    -- stylua: ignore
    keys = {
      {
        "<leader>dR",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dE",
        function()
          require("dapui").eval(vim.fn.input("[Expression] > "))
        end,
        desc = "Evaluate Input",
      },
      {
        "<leader>dC",
        function()
          require("dap").set_breakpoint(vim.fn.input("[Condition] > "))
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dU",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle UI",
      },
      {
        "<leader>db",
        function()
          require("dap").step_back()
        end,
        desc = "Step Back",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dd",
        function()
          require("dap").disconnect()
        end,
        desc = "Disconnect",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        mode = { "n", "v" },
        desc = "Evaluate",
      },
      {
        "<leader>dg",
        function()
          require("dap").session()
        end,
        desc = "Get Session",
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Hover Variables",
      },
      {
        "<leader>dS",
        function()
          require("dap.ui.widgets").scopes()
        end,
        desc = "Scopes",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause.toggle()
        end,
        desc = "Pause",
      },
      {
        "<leader>dq",
        function()
          require("dap").close()
        end,
        desc = "Quit",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").continue()
        end,
        desc = "Start",
      },
      {
        "<leader>dt",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dx",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>du",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
    },
    config = function()
      local icons = require("config.icons")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      require("nvim-dap-virtual-text").setup({
        commented = true,
      })

      local dap, dapui = require("dap"), require("dapui")
      dapui.setup({})

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- set up debugger
      if not dap.adapters["node"] then
        dap.adapters["node"] = function(cb, config)
          if config.type == "node" then
            config.type = "pwa-node"
          end
          local nativeAdapter = dap.adapters["pwa-node"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      if not dap.adapters["chrome"] then
        dap.adapters["chrome"] = function(cb, config)
          if config.type == "chrome" then
            config.type = "pwa-chrome"
          end
          local nativeAdapter = dap.adapters["pwa-chrome"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      local dap_vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      ---@diagnostic disable-next-line: duplicate-set-field
      dap_vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str, {}))
      end

      -- Extends dap.configurations with entries read from .vscode/launch.json
      if vim.fn.filereadable(".vscode/launch.json") then
        dap_vscode.load_launchjs()
      end

      dap_vscode.type_to_filetypes["node"] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        dap.configurations[language] = {
          -- Debug single nodejs files
          {
            name = "Launch file",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
            cwd = "${workspaceFolder}",
            args = { "${file}" },
            sourceMaps = true,
            sourceMapPathOverrides = {
              ["./*"] = "${workspaceFolder}/src/*",
            },
          },
          -- Debug nodejs processes (make sure to add --inspect when you run the process)
          {
            name = "Attach",
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            name = "Debug Jest Tests",
            type = "pwa-node",
            request = "launch",
            runtimeExecutable = "node",
            runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest", "--runInBand" },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            -- args = {'${file}', '--coverage', 'false'},
            -- sourceMaps = true,
            -- skipFiles = {'<node_internals>/**', 'node_modules/**'},
          },
          {
            name = "Debug Vitest Tests",
            type = "pwa-node",
            request = "launch",
            cwd = vim.fn.getcwd(),
            program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
            args = { "run", "${file}" },
            autoAttachChildProcesses = true,
            smartStep = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          -- Debug web applications (client side)
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
          },
          {
            name = "----- ↑ launch.json configs (if available) ↑ -----",
            type = "",
            request = "launch",
          },
        }
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "williamboman/mason.nvim",
    },
    event = "VeryLazy",
    opts = {
      automatic_setup = true,
      handlers = {},
    },
  },
}
