return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "rcarriga/cmp-dap",
      "L3MON4D3/LuaSnip",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local compare = require("cmp.config.compare")
      vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#7AA2F7" })

      local source_names = {
        nvim_lsp = "(LSP)",
        luasnip = "(Snippet)",
        buffer = "(Buffer)",
        path = "(Path)",
        crates = "(Crates)",
        ["vim-dadbod-completion"] = "[DB]",
      }

      -- dedup
      local dupes = {
        buffer = 1,
        path = 1,
        luasnip = 1,
        nvim_lsp = nil,
        crates = 1,
      }

      local function check_back_space()
        local col = vim.fn.col(".") - 1
        if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
          return true
        else
          return false
        end
      end

      local select_opts = { behavior = cmp.SelectBehavior.Select }

      --
      vim.keymap.set("i", "<C-x><C-o>", function()
        require("cmp").complete()
      end)

      local types = require("cmp.types")
      ---@type table<integer, integer>
      local modified_priority = {
        [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
        [types.lsp.CompletionItemKind.Snippet] = 100, -- top
        [types.lsp.CompletionItemKind.Keyword] = 0, -- top
        [types.lsp.CompletionItemKind.Text] = 100, -- bottom
      }
      ---@param kind integer: kind of completion entry
      local function modified_kind(kind)
        return modified_priority[kind] or kind
      end

      cmp.setup({
        enabled = function()
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
        sorting = {
          -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
          comparators = {
            function(entry1, entry2) -- sort by length ignoring "=~"
            end,
            compare.offset,
            compare.exact,
            function(entry1, entry2) -- sort by length ignoring "=~"
              local len1 = string.len(string.gsub(entry1.completion_item.label, "[=~()_]", ""))
              local len2 = string.len(string.gsub(entry2.completion_item.label, "[=~()_]", ""))
              if len1 ~= len2 then
                return len1 - len2 < 0
              end
            end,
            compare.recently_used, ---@diagnostic disable-line
            function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
              local kind1 = modified_kind(entry1:get_kind())
              local kind2 = modified_kind(entry2:get_kind())
              if kind1 ~= kind2 then
                return kind1 - kind2 < 0
              end
            end,
            function(entry1, entry2) -- score by lsp, if available
              local t1 = entry1.completion_item.sortText
              local t2 = entry2.completion_item.sortText
              if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
                return t1 < t2
              end
            end,
            compare.score,
            compare.order,
          },
          priority_weight = 2,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          -- ["<C-Space>"] = cmp.mapping.complete(), -- show completion
          ["<C-e>"] = cmp.mapping.abort(), -- abort completion
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item(select_opts)
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_back_space() then
              fallback()
            else
              cmp.complete()
            end
          end, { "i", "s" }),
          -- when menu is visible, navigate to previous item on list
          -- else, revert to default behavior
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item(select_opts)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "crates" },
        }),
        formatting = {
          fields = { "abbr", "kind", "menu" },
          expandable_indicator = true,
          format = function(entry, item)
            local prev_kind = item.kind
            -- local max_width = 80
            local duplicates_default = nil
            -- if max_width ~= 0 and #item.abbr > max_width then
            --   item.abbr = string.sub(item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
            -- end
            -- item.kind = icons.kind[item.kind]
            item.menu = source_names[entry.source.name]
            item.dup = dupes[entry.source.name] or duplicates_default

            local vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "")
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            kind.kind = kind.kind .. " " .. prev_kind .. " "

            return kind
          end,
        },
      })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })

      -- cmp.setup.cmdline("/", {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     { name = "buffer" },
      --   },
      -- })

      -- cmp.setup.cmdline(":", {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources({
      --     { name = "path" },
      --   }, {
      --     {
      --       name = "cmdline",
      --       option = {
      --         ignore_cmds = { "Man", "!" },
      --       },
      --     },
      --   }),
      -- })
      --
      -- cmp.setup.cmdline("@", {
      --   sources = cmp.config.sources({
      --     { name = "path" },
      --     { name = "cmdline" },
      --   }),
      -- })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets/" })
        end,
      },
    },
  },
}
