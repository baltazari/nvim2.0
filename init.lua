-- ~/.config/nvim/init.lua
-- Load order matters:
--   options/keymaps/autocmds  -> basic settings
--   plugins                   -> clone/register all plugins first
--   colorscheme               -> theme (after plugins)
--   completion                -> BEFORE mason/lsp (registers LSP capabilities)
--   mason                     -> installs + enables servers
--   lsp                       -> server settings, keymaps, diagnostics
require("user.options")
require("user.keymaps")
require("user.autocmds")
require("user.plugins")
require("user.colorscheme")
require("user.statusline")
require("user.explorer")
require("user.finder")
require("user.floatterm")
require("user.autopairs")
require("user.trouble")
require("user.bufswitch")
require("user.treesitter")
require("user.completion")  -- before mason + lsp
require("user.mason")
require("user.lsp")
