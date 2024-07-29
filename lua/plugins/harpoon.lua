return {
  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Add File",
      },
      {
        "<leader>hm",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "File Menu",
      },
      {
        "<leader>hc",
        function()
          require("harpoon.cmd-ui").toggle_quick_menu()
        end,
        desc = "Command Menu",
      },
      {
        "<leader>1",
        function()
          require("harpoon.ui").nav_file(1)
        end,
        desc = "File 1",
      },
      {
        "<leader>2",
        function()
          require("harpoon.ui").nav_file(2)
        end,
        desc = "File 2",
      },
      {
        "<leader>3",
        function()
          require("harpoon.ui").nav_file(3)
        end,
        desc = "File 3",
      },
      {
        "<leader>4",
        function()
          require("harpoon.ui").nav_file(4)
        end,
        desc = "File 4",
      },
      {
        "<leader>q",
        function()
          require("harpoon.term").gotoTerminal(1)
        end,
        desc = "Terminal 1",
      },
      {
        "<localleader>j",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "Nav Next",
      },
      {
        "<localleader>k",
        function()
          require("harpoon.ui").nav_prev()
        end,
        desc = "Nav Prev",
      },
    },
    opts = {
      global_settings = {
        save_on_toggle = true,
        enter_on_sendcmd = true,
      },
    },
  },
}
