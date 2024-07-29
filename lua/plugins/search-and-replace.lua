return {
  "nvim-pack/nvim-spectre",
  keys = {
    {
      "<leader>S",
      function()
        require("spectre").toggle()
      end,
      desc = "Search and Replace",
    },
  },
  config = function()
    require("spectre").setup()
  end,
}
