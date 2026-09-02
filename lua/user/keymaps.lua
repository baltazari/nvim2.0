-- ~/.config/nvim/lua/user/keymaps.lua
-- General (non-LSP) keymaps.
local map = vim.keymap.set

-- Clear search highlight with Esc.
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Move between split windows with Ctrl + h/j/k/l.
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Save and quit.
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })

-- F12: go to definition (jump to where the function/variable is defined).
map("n", "<F12>", vim.lsp.buf.definition, { desc = "Go to definition" })
-- Backup key in case the terminal swallows F12.
map("n", "<leader>d", vim.lsp.buf.definition, { desc = "Go to definition" })

-- Ctrl+S: format (via LSP) then save. Works in normal, insert, and visual.
vim.keymap.set({ "n", "i", "v" }, "<C-s>", function()
  vim.cmd("stopinsert")               -- leave insert mode first
  vim.lsp.buf.format({ async = false }) -- format with the attached LSP
  vim.cmd("write")                    -- save
end, { desc = "Format and save" })
