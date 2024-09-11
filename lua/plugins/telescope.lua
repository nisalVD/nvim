return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      {
        "ʫ",
        function()
          require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({ previewer = false }))
        end,
        desc = "find files no-preview",
      },
      {
        "<a-p>",
        function()
          require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({ previewer = false }))
        end,
        desc = "find files no-preview",
      },
      {
        "<leader>b",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "find buffers",
      },
      {
        "<leader>pa",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "live grep with args",
      },
      {
        "<leader>pf",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "find files",
      },
      {
        "<leader>pg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "live grep",
      },
      {
        "<leader>pG",
        function()
          require("telescope.builtin").live_grep({
            additional_args = function(args)
              return vim.list_extend(args, { "--case-sensitive" })
            end,
          })
        end,
        desc = "Telescope live grep (case sensitive)",
      },
      {
        "<leader>pr",
        function()
          require("telescope.builtin").resume()
        end,
        desc = "live grep",
      },
      {
        "<leader>p?",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "help tags",
      },
      {
        "<leader>pb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "buffers",
      },
      {
        "<leader>pc",
        function()
          require("telescope.builtin").command_history()
        end,
        desc = "command history",
      },
      {
        "<leader>ph",
        function()
          require("telescope.builtin").pickers()
        end,
        desc = "command history",
      },
      {
        "<leader>gp",
        function()
          require("telescope").extensions.git_worktree.git_worktrees()
        end,
        desc = "git worktrees pick",
      },
      {
        "<leader>gc",
        function()
          require("telescope").extensions.git_worktree.create_git_worktree()
        end,
        desc = "git worktrees create",
      },
      {
        "<leader>ps",
        function()
          require("telescope.builtin").search_history()
        end,
        desc = "search history",
      },
      { "<leader>pp", "<cmd>Telescope projects<cr>", desc = "projects" },
      {
        "ý",
        "<cmd>Telescope find_files search_dirs=~/.config/nvim/lua/<cr>",
        desc = "dotfiles",
      },
      { "<A-d>", "<cmd>Telescope find_files search_dirs=~/AppData/Local/nvim/lua<cr>", desc = "dotfiles" },
    },
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "ahmedkhalf/project.nvim",
      "tsakirist/telescope-lazy.nvim",
      "ahmedkhalf/project.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
      "nvim-telescope/telescope-live-grep-args.nvim",
      {
        "danielfalk/smart-open.nvim",
        branch = "0.2.x",
        dependencies = {
          "kkharji/sqlite.lua",
          { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
          { "nvim-telescope/telescope-fzy-native.nvim" },
        },
      },
      "ThePrimeagen/git-worktree.nvim",
      "ecthelionvi/NeoComposer.nvim",
    },
    config = function(_, _)
      local actions = require("telescope.actions")
      local lga_actions = require("telescope-live-grep-args.actions")
      local open_with_trouble = require("trouble.sources.telescope").open -- here

      local opts = {
        defaults = {
          cache_picker = { num_pickers = 20 },
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
            },
            n = { ["<c-t>"] = open_with_trouble },
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = { -- extend mappings
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          },
        },
      }

      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("projects")
      telescope.load_extension("fzf")
      telescope.load_extension("smart_open")
      telescope.load_extension("git_worktree")
      telescope.load_extension("macros")
      telescope.load_extension("live_grep_args")
    end,
  },
  {
    "folke/trouble.nvim",
    config = true,
    keys = {
      {
        "<leader>Tt",
        "<cmd>TroubleToggle<cr>",
        desc = "Toggle Trouble",
      },
      {
        "<leader>Td",
        "<cmd>Trouble workspace_diagnostics<cr>",
        desc = "Toggle Trouble",
      },
    },
  },
  {
    "AckslD/nvim-neoclip.lua",
    event = "VeryLazy",
    keys = {
      {
        "<leader>cc",
        "<cmd>Telescope neoclip<cr>",
        desc = "Clipboard",
      },
    },
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("neoclip").setup()
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    event = "BufRead",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", ".luarc.json" },
        ignore_lsp = { "null-ls" },
      })
    end,
  },
}
