return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
      {
        "LiadOz/nvim-dap-repl-highlights",
        config = function()
          require("nvim-dap-repl-highlights").setup()
        end,
      },
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "glsl",
        "c",
        "comment",
        "cpp",
        "css",
        "go",
        "html",
        "java",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "markdown",
        "lua",
        "python",
        "yaml",
        "svelte",
        "tsx",
        "typescript",
        "markdown_inline",
        "zig",
        "rust",
      },
      sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
      ignore_install = { "" }, -- List of parsers to ignore installing
      matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        disable_virtual_text = true,
      },
      highlight = {
        -- use_languagetree = true,
        enable = true, -- false will disable the whole extension
      },
      autopairs = {
        enable = true,
      },
      indent = { enable = true },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      autotag = {
        enable = true,
      },
      playground = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            -- ["at"] = "@class.outer",
            -- ["it"] = "@class.inner",
            ["ac"] = "@call.outer",
            ["ic"] = "@call.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["a/"] = "@comment.outer",
            ["i/"] = "@comment.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["as"] = "@statement.outer",
            ["is"] = "@scopename.inner",
            ["aA"] = "@attribute.outer",
            ["iA"] = "@attribute.inner",
            ["aF"] = "@frame.outer",
            ["iF"] = "@frame.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]]"] = "@function.outer",
            ["]M"] = "@class.outer",
          },
          goto_next_end = {
            ["]["] = "@function.outer",
            ["]M"] = "@class.outer",
          },
          goto_previous_start = {
            ["[["] = "@function.outer",
            ["[M"] = "@class.outer",
          },
          goto_previous_end = {
            ["[]"] = "@function.outer",
            ["[M"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>."] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>,"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- rust highlight groups
      require("vim.treesitter.query").set(
        "rust",
        "injections",
        [[
          (macro_invocation
            macro: (scoped_identifier
              path: (identifier) @_sqlx (#eq? @_sqlx "sqlx")
              name: (identifier) @_query_as (#match? @_query_as "^query_as(_unchecked)?$"))
            (token_tree
              ; Only the second argument is SQL
              .
              ; Allow anything as the first argument in case the user has lower case type
              ; names for some reason
              (_)
              [(string_literal) (raw_string_literal)] @injection.content
            )
            (#set! injection.language "sql"))
          ]]
      )

      require("vim.treesitter.query").set(
        "rust",
        "injections",
        [[
			     (macro_invocation
			       macro: (scoped_identifier
			         path: (identifier) @_sqlx (#eq? @_sqlx "sqlx")
			         name: (identifier) @_query (#match? @_query "^query(_scalar|_scalar_unchecked)?$"))
			       (token_tree
			         ; Only the first argument is SQL
			         .
			         [(string_literal) (raw_string_literal)] @injection.content
			       )
			       (#set! injection.language "sql"))
			     ]]
      )
    end,
  },
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>m", "<cmd>TSJToggle<cr>", desc = "Toggle Treesitter Join" },
    },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = { use_default_keymaps = false },
  },
  {
    -- Rainbow parentheses
    "HiPhish/rainbow-delimiters.nvim",
    name = "rainbow",
    event = { "BufRead", "BufNewFile" },
  },
}
