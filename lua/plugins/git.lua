return {
  {
    "tpope/vim-fugitive",
    keys = {
      { "<leader>gdd", "<cmd>Gvdiffsplit!<cr>", desc = "Show git diff" },
      { "<leader>gs", "<cmd>Git<cr>", desc = "Status" },
    },
    cmd = {
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
      "Gsplit",
      "Gvsplit",
      "Gtabedit",
      "Gdiff",
      "Gblame",
      "Ggrep",
      "Glog",
      "Gedit",
      "Gsplit",
      "Gvsplit",
      "Gtabedit",
      "Gdiff",
      "Gblame",
      "Ggrep",
      "Glog",
      "Gedit",
      "Gsplit",
      "Gvsplit",
      "Gtabedit",
      "Gdiff",
      "Gblame",
      "Ggrep",
      "Glog",
      "Gedit",
      "Gsplit",
      "Gvsplit",
      "Gtabedit",
      "Gdiff",
      "Gblame",
      "Ggrep",
      "Glog",
      "Gedit",
      "Gsplit",
      "Gvsplit",
      "Gtabedit",
      "Gdiff",
      "Gblame",
      "Ggrep",
      "Glog",
      "Gedit",
      "Gsplit",
      "Gvsplit",
      "Gtabedit",
      "Gdiff",
      "Gblame",
      "Ggrep",
      "Glog",
      "Gedit",
      "Gsplit",
      "Gvsplit",
      "Gtabedit",
      "Gdiff",
      "Gblame",
      "Ggrep",
      "Glog",
      "Gedit",
      "Gsplit",
      "Gvsplit",
      "Gtabedit",
      "Gdiff",
      "Gblame",
      "Ggrep",
      "Glog",
      "Gedit",
      "Gsplit",
      "Gvsplit",
      "Gtabedit",
      "Gdiff",
      "Gblame",
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Open Git Diff View" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Open Git Diff View" },
    },
    config = function(_, opts)
      local actions = require("diffview.actions")

      require("diffview").setup({
        hooks = { -- disable file panel by default
          view_opened = function()
            require("diffview.actions").toggle_files()
          end,
        },
        keymaps = {
          view = {
            {
              "n",
              "<leader>gco",
              actions.conflict_choose("ours"),
              { desc = "Choose the OURS version of a conflict" },
            },
            {
              "n",
              "<leader>gct",
              actions.conflict_choose("theirs"),
              { desc = "Choose the THEIRS version of a conflict" },
            },
            {
              "n",
              "<leader>gcO",
              actions.conflict_choose_all("ours"),
              { desc = "Choose the OURS version of a conflict for the whole file" },
            },
            {
              "n",
              "<leader>gcT",
              actions.conflict_choose_all("theirs"),
              { desc = "Choose the THEIRS version of a conflict for the whole file" },
            },
          },
        },
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
      })
    end,
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    dependencies = {
      "sindrets/diffview.nvim",
    },
    opts = {
      integrations = { diffview = true },
      disable_commit_confirmation = true,
    },
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    --     vim.api.nvim_set_keymap('n', '<leader>gb', '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', {silent = true})
    -- vim.api.nvim_set_keymap('v', '<leader>gb', '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', {})

    keys = {
      {
        "<leader>gb",
        '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        desc = "open git link in browser",
      },
      {
        "<leader>gb",
        '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        desc = "open git link in browser",
        mode = "v",
      },
    },
    config = function()
      require("gitlinker").setup()
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      { "<leader>gtb", "<cmd>:Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Line Blame" },
      { "<leader>gts", "<cmd>:Gitsigns toggle_signs<cr>", desc = "Toggle Git Signs" },
      { "<leader>gdh", "<cmd>:Gitsigns preview_hunk_inline<cr>", desc = "Toggle Git Signs" },
    },
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end)

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end)

          -- Actions
          map("n", "<leader>hs", gitsigns.stage_hunk)
          map("n", "<leader>hr", gitsigns.reset_hunk)
          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("n", "<leader>hS", gitsigns.stage_buffer)
          map("n", "<leader>hu", gitsigns.undo_stage_hunk)
          map("n", "<leader>hR", gitsigns.reset_buffer)
          map("n", "<leader>hp", gitsigns.preview_hunk)
          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end)
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
          map("n", "<leader>hd", gitsigns.diffthis)
          map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
          end)
          map("n", "<leader>td", gitsigns.toggle_deleted)

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      })
    end,
  },
}
