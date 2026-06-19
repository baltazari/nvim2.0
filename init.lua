-- ~/.config/nvim/init.lua
-- Entry point. Order matters: plugins must load before treesitter/lsp.
require("user.options")
require("user.keymaps")
require("user.autocmds")
require("user.plugins")
require("user.finder")
require("user.floatterm")
require("user.colorscheme")
require("user.treesitter")
require("user.completion")
require("user.lsp")
