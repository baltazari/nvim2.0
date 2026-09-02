require("onedark").setup({
  style = "dark", -- classic Atom One Dark
  transparent = true,
})
require("onedark").load()


-- Clear backgrounds on floating windows and borders so they're transparent.
local function clear_floats()
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatTitle",  { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatFooter", { bg = "NONE" })
end
clear_floats()
vim.api.nvim_create_autocmd("ColorScheme", { callback = clear_floats })
