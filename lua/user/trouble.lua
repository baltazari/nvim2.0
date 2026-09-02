-- ~/.config/nvim/lua/user/trouble.lua
-- Diagnostics / "Problems" panel (trouble.nvim).
require("trouble").setup({
  focus = true,            -- move the cursor into the panel when it opens
  warn_no_results = false, -- stay quiet when there's nothing to show
})

local map = vim.keymap.set

-- All project diagnostics (like VSCode's Problems tab).
map("n", "<F5>", "<cmd>Trouble diagnostics toggle<cr>",
  { desc = "Diagnostics (all)" })

-- Only the current file's diagnostics.
map("n", "<F6>", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { desc = "Diagnostics (current file)" })

-- Symbols outline of the current file (jumps INTO the panel).
map("n", "<F7>", "<cmd>Trouble symbols toggle focus=true<cr>",
  { desc = "Symbols outline" })

-- LSP references / definitions of the item under the cursor.
map("n", "<leader><F8>", "<cmd>Trouble lsp toggle<cr>",
  { desc = "LSP references/defs" })

-- Quickfix list in the Trouble UI (moved to <leader>Q to avoid clashing with <leader>x).
map("n", "<leader><F9>", "<cmd>Trouble qflist toggle<cr>",
  { desc = "Quickfix list" })
