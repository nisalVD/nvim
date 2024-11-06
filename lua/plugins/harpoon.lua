local keymap = require("config.utils").keymap

return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list("file"):add()
        end,
        desc = "Add File",
      },
      {
        "<leader>hm",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list("file"))
        end,
        desc = "File Menu",
      },
      {
        "<leader>1",
        function()
          require("harpoon"):list("file"):select(1)
        end,
        desc = "File 1",
      },
      {
        "<leader>2",
        function()
          require("harpoon"):list("file"):select(2)
        end,
        desc = "File 2",
      },
      {
        "<leader>3",
        function()
          require("harpoon"):list("file"):select(3)
        end,
        desc = "File 3",
      },
      {
        "<leader>4",
        function()
          require("harpoon"):list("file"):select(4)
        end,
        desc = "File 4",
      },
      {
        "<leader>j",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Nav Next",
      },
      {
        "<leader>k",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Nav Prev",
      },
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          enter_on_sendcmd = true,
        },
      })

      ---@return string name of the created terminal
      local function create_terminal()
        vim.cmd("terminal")
        local buf_id = vim.api.nvim_get_current_buf()
        return vim.api.nvim_buf_get_name(buf_id)
      end

      ---@param index number: The index of the terminal to select.
      ---@param term_list HarpoonList: harpoon terminal list
      local function select_term(index, term_list)
        if index > term_list:length() then
          create_terminal()
          print("Creating terminal", index)
          -- just append the newly open terminal
          term_list:append()
        else
          -- find in list
          print("selecting terminal", index)
          term_list:select(index)
        end
      end

      ---@param term_list HarpoonList: harpoon terminal list
      local function remove_closed_terms(term_list)
        for _, term in ipairs(term_list.items) do
          local bufnr = vim.fn.bufnr(term.value)
          if bufnr == -1 then
            print("Removing:" .. term.value)
            term_list:remove(term)
          end
          -- can get id here with nvim_buf_get_name because buffer is already deleted
          --term_list:remove(term_name)
          --
        end
      end

      -- Autocommand to remove closed terminal from the list

      ---@type HarpoonList
      local main_term_list = harpoon:list("main_terms")
      keymap("n", "<leader>q", function()
        select_term(1, main_term_list)
      end)

      keymap("n", "<leader>w", function()
        select_term(2, main_term_list)
      end)

      -- "VimEnter" cleans terminals that were saved when you closed vim for the last time but were not removed
      vim.api.nvim_create_autocmd({ "TermClose", "VimEnter" }, {
        pattern = "*",
        callback = function()
          remove_closed_terms(main_term_list)
          remove_closed_terms(harpoon:list("sub_term1"))
          remove_closed_terms(harpoon:list("sub_term2"))
          remove_closed_terms(harpoon:list("sub_term3"))
        end,
      })

      -- This is needed because closing term with bd! won't trigger "TermClose"
      vim.api.nvim_create_autocmd({ "BufDelete", "BufUnload" }, {
        pattern = "term://*",
        callback = function()
          remove_closed_terms(main_term_list)
          remove_closed_terms(harpoon:list("sub_term1"))
          remove_closed_terms(harpoon:list("sub_term2"))
          remove_closed_terms(harpoon:list("sub_term3"))
        end,
      })

      -- terminal
      keymap("n", "<leader>ts", function()
        vim.cmd("belowright 12split")
        vim.cmd("set winfixheight")
        select_term(1, harpoon:list("sub_term1"))
        vim.cmd.startinsert()
      end, { desc = "terminal split" })

      keymap("n", "<leader>tT", function()
        vim.cmd.tabnew()
        select_term(1, harpoon:list("sub_term2"))
        vim.cmd.startinsert()
      end, { desc = "terminal tab" })

      keymap("n", "<leader>tv", function()
        vim.cmd.vsplit()
        select_term(1, harpoon:list("sub_term3"))
        vim.cmd.startinsert()
      end, { desc = "terminal vsplit" })

      -- Command that I use for debugging
      vim.api.nvim_create_user_command("HarpoonShowMainTermList", function()
        harpoon.ui:toggle_quick_menu(main_term_list)
      end, {})

      vim.api.nvim_create_user_command("HarpoonShowSubTermList", function()
        harpoon.ui:toggle_quick_menu(sub_term_list)
      end, {})
    end,
  },
}
