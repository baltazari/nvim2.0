-- Plugins via the native vim.pack manager (built into Neovim 0.12).
-- First launch clones these automatically.
vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/navarasu/onedark.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },  -- icons
  { src = "https://github.com/ibhagwan/fzf-lua" },             -- fuzzy finder
})

vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/navarasu/onedark.nvim" },
})
