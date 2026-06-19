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
