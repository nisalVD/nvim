return {
  {
    "epwalsh/obsidian.nvim",
    cmd = {
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianFollowLink",
      "ObsidianBacklinks",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTemplate",
      "ObsidianSearch",
      "ObsidianLink",
      "ObsidianLinkNew",
    },
    keys = {
      {
        "<leader>ot",
        "<cmd>ObsidianToday<cr>",
        desc = "Obsidian Today",
      },
      {
        "<leader>og",
        "<cmd>ObsidianSearch<cr>",
        desc = "Obsidian Grep",
      },
      {
        "<leader>op",
        "<cmd>ObsidianQuickSwitch<cr>",
        desc = "Obsidian Find",
      },
      {
        "<leader>oi",
        "<cmd>ObsidianPasteImg<cr>",
        desc = "Obsidian Paste Image",
      },
    },
    event = { "BufReadPre   /Users/nisaldon/notes-obsidian/personal/**.md" },
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
    -- event = { "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      dir = "/Users/nisaldon/notes-obsidian/personal/", -- no need to call 'vim.fn.expand' here
      daily_notes = {
        folder = "daily-notes",
      },
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },

      -- see below for full list of options 👇
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "norg", "rmd", "org" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
    },
    keys = {
      { "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown toggle" },
    },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- vim.keymap.set("n", "gf", function()
      --   if require("obsidian").util.cursor_on_markdown_link() then
      --     return "<cmd>ObsidianFollowLink<CR>"
      --   else
      --     return "gf"
      --   end
      -- end, { noremap = false, expr = true })
      -- LazyVim.toggle.map("<leader>um", {
      --   name = "Render Markdown",
      --   get = function()
      --     return require("render-markdown.state").enabled
      --   end,
      --   set = function(enabled)
      --     local m = require("render-markdown")
      --     if enabled then
      --       m.enable()
      --     else
      --       m.disable()
      --     end
      --   end,
      -- })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "preservim/vim-pencil",
    cmd = {
      "Pencil",
      "TogglePencil",
      "SoftPencil",
      "HardPencil",
    },
    init = function()
      vim.g["pencil#wrapModeDefault"] = "soft"
      vim.g["pencil#autoformat"] = 1
      vim.g["pencil#textwidth"] = 50
    end,
  },
}
