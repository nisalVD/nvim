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
        "<leader>os",
        "<cmd>ObsidianSearch<cr>",
        desc = "Obsidian Search",
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
      mappings = {},
      dir = "/Users/nisaldon/notes-obsidian/personal/", -- no need to call 'vim.fn.expand' here
      daily_notes = {
        folder = "daily-notes",
      },

      -- see below for full list of options 👇
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
    end,
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>op",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = { theme = "dark", filetype = { "markdown", "vimwiki" } },
  },
}
