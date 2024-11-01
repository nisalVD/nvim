return {
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = {
      "kevinhwang91/promise-async",
      -- {
      --   "luukvbaal/statuscol.nvim",
      --   config = function()
      --     local builtin = require("statuscol.builtin")
      --     require("statuscol").setup({
      --       relculright = true,
      --       segments = {
      --         { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
      --         { text = { "%s" }, click = "v:lua.ScSa" },
      --         { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
      --       },
      --     })
      --   end,
      -- },
    },
    keys = {
      { "zc" },
      { "zo" },
      { "zC" },
      { "zO" },
      { "za" },
      { "zA" },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        desc = "Open Folds Except Kinds",
      },
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open All Folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close All Folds",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        desc = "Close Folds With",
      },
      {
        "zp",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek Fold",
      },
    },
    opts = {},
    config = function(_, opts)
      require("ufo").setup(opts)
    end,
  },
}
