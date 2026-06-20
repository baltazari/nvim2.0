-- General (non-LSP) keymaps. LSP keymaps live in lua/user/lsp.lua.
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

-- Ctrl+S: format (via LSP) then save. Works in normal, insert, and visual.
vim.keymap.set({ "n", "i", "v" }, "<C-s>", function()
-- F12: go to definition (jump to where the function/variable is defined).
vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, { desc = "Go to definition" })
  -- Leave insert mode first so the cursor lands sensibly after saving.
  vim.cmd("stopinsert")
  -- Format with the attached LSP if there is one, then write.
  vim.lsp.buf.format({ async = false })
  vim.cmd("write")
end, { desc = "Format and save" })
