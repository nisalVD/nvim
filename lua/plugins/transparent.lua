return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup({
        extra_groups = {
          "NvimTreeNormal",
          "NvimTreeStatuslineNc",
          "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
          "NvimTreeNormal", -- NvimTree
          "SagaBorder",
          "SagaNormal",
        },
      })
    end,
  },
}
