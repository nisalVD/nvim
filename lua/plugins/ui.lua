local noice = {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  event = "VeryLazy",
  opts = {
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
      progress = {
        enabled = false,
      },
    },
    cmdline = {
      enabled = true,
    },
    popupmenu = {
      enabled = true,
    },
    messages = {
      enabled = false, -- enables the Noice messages UI
      view = "mini", -- default view for messages
      view_error = "mini", -- view for errors
      view_warn = "mini", -- view for warnings
      view_history = "messages", -- view for :messages
      view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
    },
    notify = {
      enabled = false,
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover ocs an signature help
    },
    views = {
      mini = {
        backend = "mini",
        relative = "editor",
        align = "message-left",
        timeout = 2000,
        reverse = true,
        focusable = false,
        position = {
          row = -1,
          col = 0,
        },
      },
    },
  },
}

if require("config.utils").is_windows() then
  noice = {}
end

return {
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   opts = {
  --     sections = {
  --       lualine_x = {
  --         {
  --           require("lazy.status").updates,
  --           cond = require("lazy.status").has_updates,
  --           color = { fg = "#ff9e64" },
  --         },
  --       },
  --     },
  --     extensions = { "nvim-tree" },
  --   },
  -- },
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
  {
    "m-demare/hlargs.nvim",
    event = "VeryLazy",
    opts = {
      color = "#ef9062",
      use_colorpalette = false,
      disable = function(_, bufnr)
        if vim.b.semantic_tokens then
          return true
        end
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        for _, c in pairs(clients) do
          local caps = c.server_capabilities
          if c.name ~= "null-ls" and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            vim.b.semantic_tokens = true
            return vim.b.semantic_tokens
          end
        end
      end,
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = false,
      },
    },
  },
}
