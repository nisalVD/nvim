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
  {
    "anuvyklack/hydra.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
    event = "VeryLazy",
    config = function()
      local Hydra = require("hydra")
      local gitsigns = require("gitsigns")

      local hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
]]

      Hydra({
        name = "Git",
        hint = hint,
        config = {
          buffer = bufnr,
          color = "red",
          invoke_on_body = true,
          hint = {
            border = "rounded",
          },
          on_key = function()
            vim.wait(50)
          end,
          on_enter = function()
            vim.cmd("mkview")
            vim.cmd("silent! %foldopen!")
            gitsigns.toggle_signs(true)
            gitsigns.toggle_linehl(true)
          end,
          on_exit = function()
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            vim.cmd("loadview")
            vim.api.nvim_win_set_cursor(0, cursor_pos)
            vim.cmd("normal zv")
            gitsigns.toggle_signs(false)
            gitsigns.toggle_linehl(false)
            gitsigns.toggle_deleted(false)
          end,
        },
        mode = { "n", "x" },
        body = "<leader>gdh",
        heads = {
          {
            "J",
            function()
              if vim.wo.diff then
                return "]c"
              end
              vim.schedule(function()
                gitsigns.next_hunk()
              end)
              return "<Ignore>"
            end,
            { expr = true, desc = "next hunk" },
          },
          {
            "K",
            function()
              if vim.wo.diff then
                return "[c"
              end
              vim.schedule(function()
                gitsigns.prev_hunk()
              end)
              return "<Ignore>"
            end,
            { expr = true, desc = "prev hunk" },
          },
          {
            "s",
            function()
              local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
              if mode == "V" then -- visual-line mode
                local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
                vim.api.nvim_feedkeys(esc, "x", false) -- exit visual mode
                vim.cmd("'<,'>Gitsigns stage_hunk")
              else
                vim.cmd("Gitsigns stage_hunk")
              end
            end,
            { desc = "stage hunk" },
          },
          { "u", gitsigns.undo_stage_hunk, { desc = "undo last stage" } },
          { "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
          { "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
          { "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
          { "b", gitsigns.blame_line, { desc = "blame" } },
          {
            "B",
            function()
              gitsigns.blame_line({ full = true })
            end,
            { desc = "blame show full" },
          },
          { "/", gitsigns.show, { exit = true, desc = "show base file" } }, -- show the base of the file
          {
            "<Enter>",
            function()
              vim.cmd("Neogit")
            end,
            { exit = true, desc = "Neogit" },
          },
          { "q", nil, { exit = true, nowait = true, desc = "exit" } },
        },
      })
    end,
  },
}
