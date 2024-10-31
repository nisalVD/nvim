return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "j-hui/fidget.nvim",
      "echasnovski/mini.icons",
      { "smjonas/inc-rename.nvim", config = true },
      -- code actions
      { "Chaitanyabsprip/fastaction.nvim", config = true },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP keybindings",
        callback = function(client, bufnr)
          require("plugins.lsp.keymaps").on_attach(client, bufnr)
          -- extra binding that requires a depedency
          vim.keymap.set("n", "ce", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
          end, { expr = true, desc = "rename" })
          -- code actions
          vim.keymap.set("n", "<leader>ca", '<cmd>lua require("fastaction").code_action()<CR>', { buffer = bufnr })
          vim.keymap.set(
            "v",
            "<leader>ca",
            "<esc><cmd>lua require('fastaction').range_code_action()<CR>",
            { buffer = bufnr }
          )
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local lspconfig = require("lspconfig")

      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          "tsserver",
          "lua_ls",
          "rust_analyzer",
          "harper_ls",
          "lemminx",
          "svelte",
          "ols",
          "jsonls",
          "marksman",
          "tailwindcss",
          "taplo",
          "tsserver",
          "gopls",
          "emmet_language_server",
          "zls",
          "lua_ls",
          "html",
          "jdtls",
          "cssls",
          "rnix",
          "clangd",
          "dockerls",
          "emmet_ls",
        },
        handlers = {
          function(server)
            lspconfig[server].setup({
              capabilities = capabilities,
            })
          end,
          rust_analyzer = function()
            -- don't initalise this, as it's handled by rust-tools
            return false
          end,
          -- custom configurations
          harper_ls = function()
            lspconfig["harper_ls"].setup({
              capabilities = capabilities,
              filetypes = { "markdown" },
            })
          end,
        },
      })

      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
      end
    end,
  },
  -- formatters
  { import = "plugins.lsp.formatter" },
  -- linter
  { import = "plugins.lsp.linter" },
  -- extra langs
  { import = "plugins.extras.lang.rust" },
}

-- return {
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--       {
--         "j-hui/fidget.nvim",
--         tag = "legacy",
--         opts = {
--           text = {
--             spinner = "pipe", -- animation shown when tasks are ongoing
--             done = "✔", -- character shown when all tasks are complete
--             commenced = "Started", -- message shown when task starts
--             completed = "Completed", -- message shown when task completes
--           },
--           align = {
--             bottom = true, -- align fidgets along bottom edge of buffer
--             right = true, -- align fidgets along right edge of buffer
--           },
--           timer = {
--             spinner_rate = 250, -- frame rate of spinner animation, in ms
--             fidget_decay = 2000, -- how long to keep around empty fidget, in ms
--             task_decay = 3000, -- how long to keep around completed task, in ms
--           },
--           window = {
--             relative = "win", -- where to anchor, either "win" or "editor"
--             blend = 100, -- &winblend for the window
--             zindex = nil, -- the zindex value for the window
--             border = "none", -- style of border for the fidget window
--           },
--           fmt = {
--             leftpad = true, -- right-justify text in fidget box
--             stack_upwards = true, -- list of tasks grows upwards
--             max_width = 0, -- maximum width of the fidget box
--             -- function to format fidget title
--             fidget = function(fidget_name, spinner)
--               return string.format("%s %s", spinner, fidget_name)
--             end,
--             -- function to format each task line
--             task = function(task_name, message, percentage)
--               local fidget_formatter = require("plugins.lsp.fidget-formatter")
--
--               fidget_formatter.add_fidget_ignore("java", "Publish Diagnostics")
--               fidget_formatter.add_fidget_ignore("java", "Building")
--               fidget_formatter.add_fidget_ignore("java", "Validating documents")
--
--               fidget_formatter.add_fidget_ignore("*", "Validate documents")
--
--               if fidget_formatter.is_format_ignore(task_name) then
--                 return nil
--               end
--
--               return string.format(
--                 "%s%s [%s]",
--                 message,
--                 percentage and string.format(" (%s%%)", percentage) or "",
--                 task_name
--               )
--             end,
--           },
--           debug = {
--             logging = false, -- whether to enable logging, for debugging
--             strict = false, -- whether to interpret LSP strictly
--           },
--         },
--       }, -- loading status for lsp
--       "ray-x/lsp_signature.nvim",
--       "hrsh7th/cmp-nvim-lsp",
--       "williamboman/mason-lspconfig.nvim",
--       { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
--       { "folke/neodev.nvim", opts = {} },
--       {
--         "smjonas/inc-rename.nvim",
--         config = function()
--           require("inc_rename").setup()
--         end,
--       },
--     },
--     opts = {
--       setup = {},
--       -- items here that want to be auto-installed and configured by lsp
--       servers = {
--         taplo = {},
--         zls = {},
--         svelte = {},
--         clangd = {},
--         html = {},
--         marksman = {},
--         cssls = {},
--         tailwindcss = {},
--         emmet_ls = {},
--         lemminx = {},
--         dockerls = {},
--         rnix = {},
--         ols = {},
--         lua_ls = {
--           single_file_support = false,
--           settings = {
--             -- custom settings for lua
--             Lua = {
--               completion = {
--                 callSnippet = "Replace",
--               },
--             },
--           },
--         },
--       },
--     },
--     config = function(_, opts)
--       require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp" } })
--       local utils = require("plugins.lsp.utils")
--
--       utils.on_attach(function(client, buffnr)
--         if client.name ~= "glslls" and client.name ~= "copilot" then
--           require("lsp_signature").on_attach({
--             floating_window = false,
--             hint_enable = false,
--             handler_opts = {
--               border = "single",
--             },
--             bind = true, -- This is mandatory, otherwise border config won't get registered.
--             toggle_key = require("config.utils").is_windows() and "<M-k>" or "˚",
--             select_signature_key = "<M-n>",
--           }, buffnr) -- Note: add in lsp client on-attach
--         end
--         require("plugins.lsp.format").on_attach(client, buffnr)
--         require("plugins.lsp.keymaps").on_attach(client, buffnr)
--       end)
--       -- signs
--       local icons = require("config.icons")
--
--       local signs = {
--         { name = "DiagnosticSignError", text = icons.diagnostics.Error },
--         { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
--         { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
--         { name = "DiagnosticSignInfo", text = icons.diagnostics.Info },
--       }
--
--       for _, sign in ipairs(signs) do
--         vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
--       end
--
--       local capabilities = require("cmp_nvim_lsp").default_capabilities()
--       capabilities.textDocument.foldingRange = {
--         dynamicRegistration = false,
--         lineFoldingOnly = true,
--       }
--
--       local servers = opts.servers
--
--       local function setup(server)
--         local server_opts = vim.tbl_deep_extend("force", {
--           capabilities = vim.deepcopy(capabilities),
--         }, servers[server] or {})
--
--         if opts.setup[server] then
--           if opts.setup[server](server, server_opts) then
--             return
--           end
--         elseif opts.setup["*"] then
--           if opts.setup["*"](server, server_opts) then
--             return
--           end
--         end
--
--         require("lspconfig")[server].setup(server_opts)
--       end
--
--       local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
--
--       local ensure_installed = {} ---@type string[]
--
--       for server, server_opts in pairs(servers) do
--         if server_opts then
--           server_opts = server_opts == true and {} or server_opts
--           -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
--           if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
--             setup(server)
--           else
--             ensure_installed[#ensure_installed + 1] = server
--           end
--         end
--       end
--
--       local mlsp = require("mason-lspconfig")
--
--       mlsp.setup({ ensure_installed = ensure_installed })
--       mlsp.setup_handlers({ setup })
--     end,
--   },
--   -- enable langs
--   { import = "plugins.extras.lang.rust" },
--   { import = "plugins.extras.lang.cpp" },
--   { import = "plugins.extras.lang.java" },
--   { import = "plugins.extras.lang.typescript" },
--   { import = "plugins.extras.lang.deno" },
--   { import = "plugins.extras.lang.go" },
--   { import = "plugins.extras.lang.json" },
--   { import = "plugins.extras.lang.harper" },
--   -- { import = "plugins.extras.lang.glslls" },
--   -- { import = "plugins.extras.lang.gleam" },
--   {
--     "glepnir/lspsaga.nvim",
--     event = "VeryLazy",
--     opts = {
--       ui = {
--         title = false,
--       },
--       symbol_in_winbar = {
--         enable = false,
--       },
--       lightbulb = {
--         enable = false,
--       },
--       diagnostics = {
--         max_height = 0.8,
--         on_insert = false,
--         on_insert_follow = false,
--       },
--       code_action = {
--         keys = {
--           quit = "<ESC>",
--         },
--       },
--     },
--     dependencies = {
--       { "nvim-tree/nvim-web-devicons" },
--       --Please make sure you install markdown and markdown_inline parser
--       { "nvim-treesitter/nvim-treesitter" },
--     },
--   },
--   {
--     "williamboman/mason.nvim",
--     build = ":MasonUpdate",
--     cmd = "Mason",
--     opts = {},
--   },
--   {
--     "jay-babu/mason-null-ls.nvim",
--     event = { "BufReadPre", "BufNewFile" },
--     dependencies = {
--       "williamboman/mason.nvim",
--       "jose-elias-alvarez/null-ls.nvim",
--     },
--     config = function()
--       local mason_null_ls = require("mason-null-ls")
--       local null_ls = require("null-ls")
--
--       mason_null_ls.setup({
--         automatic_installation = true,
--         ensure_installed = {
--           "prettierd",
--           "stylua",
--           "eslint_d",
--           "google-java-format",
--         },
--       })
--
--       local formatting = null_ls.builtins.formatting
--       local diagnostics = null_ls.builtins.diagnostics
--
--       null_ls.setup({
--         debug = true,
--         sources = {
--           formatting.prettierd,
--           formatting.stylua,
--           -- read formatting from cargo.toml
--           formatting.google_java_format.with({ extra_args = { "--aosp" } }),
--           -- diagnostics.eslint_d.with({
--           --   condition = function(utils)
--           --     return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc.cjs" })
--           --   end,
--           -- }),
--           -- Anything not supported by mason.
--         },
--       })
--     end,
--   },
--   {
--     "mrcjkb/haskell-tools.nvim",
--     version = "^4", -- Recommended
--     ft = { "haskell", "cabal" },
--
--     config = function(_, opts)
--       local keymap_opts = { noremap = true, silent = true }
--       local ht = require("haskell-tools")
--
--       vim.keymap.set("n", "<leader>hrt", function()
--         ht.repl.toggle()
--       end, keymap_opts)
--
--       vim.keymap.set("n", "<leader>hrf", function()
--         local current_file = vim.fn.expand("%:h") .. "/" .. vim.fn.expand("%:t")
--         ht.repl.toggle(current_file)
--       end, keymap_opts)
--
--       vim.g.haskell_tools = {
--         hls = {
--           settings = {
--             haskell = {
--               plugin = {
--                 class = { -- missing class methods
--                   codeLensOn = false,
--                 },
--                 importLens = { -- make import lists fully explicit
--                   codeLensOn = false,
--                 },
--                 refineImports = { -- refine imports
--                   codeLensOn = false,
--                 },
--                 tactics = { -- wingman
--                   codeLensOn = false,
--                 },
--                 moduleName = { -- fix module names
--                   globalOn = false,
--                 },
--                 eval = { -- evaluate code snippets
--                   globalOn = false,
--                 },
--                 ["ghcide-type-lenses"] = { -- show/add missing type signatures
--                   globalOn = false,
--                 },
--               },
--             },
--           },
--         },
--       }
--     end,
--   },
--   {
--     {
--       "folke/todo-comments.nvim",
--       cmd = { "TodoTrouble", "TodoTelescope" },
--       event = "BufReadPost",
--       config = true,
--       -- stylua: ignore
--       keys = {
--         {
--           "]t",
--           function()
--             require("todo-comments").jump_next()
--           end,
--           desc = "Next ToDo",
--         },
--         {
--           "[t",
--           function()
--             require("todo-comments").jump_prev()
--           end,
--           desc = "Previous ToDo",
--         },
--         { "<leader>Tl", "<cmd>TodoTrouble<cr>",   desc = "ToDo (Trouble)" },
--         { "<leader>pt", "<cmd>TodoTelescope<cr>", desc = "ToDo" },
--       },
--     },
--   },
-- }
