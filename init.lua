require("config.base")
require("config.autocmd")
require("config.lazy")
require("config.gui")
require("config.windows")
require("config.keymaps")
require("config.commands")
-- sqlite location NOTE: remove this once we have proper nix with nvim
vim.g.sqlite_clib_path = os.getenv("SQLITE_LUA_LIB")
