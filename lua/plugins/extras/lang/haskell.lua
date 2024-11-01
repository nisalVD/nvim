return {
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^4", -- Recommended
    ft = { "haskell", "cabal" },

    config = function(_)
      local keymap_opts = { noremap = true, silent = true }
      local ht = require("haskell-tools")

      vim.keymap.set("n", "<leader>hrt", function()
        ht.repl.toggle()
      end, keymap_opts)

      vim.keymap.set("n", "<leader>hrf", function()
        local current_file = vim.fn.expand("%:h") .. "/" .. vim.fn.expand("%:t")
        ht.repl.toggle(current_file)
      end, keymap_opts)

      vim.g.haskell_tools = {
        hls = {
          settings = {
            haskell = {
              plugin = {
                class = { -- missing class methods
                  codeLensOn = false,
                },
                importLens = { -- make import lists fully explicit
                  codeLensOn = false,
                },
                refineImports = { -- refine imports
                  codeLensOn = false,
                },
                tactics = { -- wingman
                  codeLensOn = false,
                },
                moduleName = { -- fix module names
                  globalOn = false,
                },
                eval = { -- evaluate code snippets
                  globalOn = false,
                },
                ["ghcide-type-lenses"] = { -- show/add missing type signatures
                  globalOn = false,
                },
              },
            },
          },
        },
      }
    end,
  },
}
