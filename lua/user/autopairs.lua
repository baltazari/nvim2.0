-- ~/.config/nvim/lua/user/autopairs.lua
-- Auto-close brackets, braces, and quotes.
require("nvim-autopairs").setup({
  check_ts = true,            -- use treesitter so it's context-aware
  enable_check_bracket_line = true, -- don't add a pair if one already closes on the line
  fast_wrap = {},             -- Alt-e to wrap the next word/quote in a pair
})
