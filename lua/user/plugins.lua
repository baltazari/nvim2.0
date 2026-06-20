-- ~/.config/nvim/lua/user/plugins.lua
-- Plugins via the native vim.pack manager (built into Neovim 0.12).
-- First launch clones these automatically; give it a few seconds, then
-- restart Neovim once so everything is on the runtime path.
vim.pack.add({
  -- LSP server configurations
  { src = "https://github.com/neovim/nvim-lspconfig" },

  -- Mason: installs and manages LSP servers from inside Neovim
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },

  -- Treesitter (use the "main" branch for Neovim 0.12)
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

  -- Atom One Dark colorscheme
  { src = "https://github.com/navarasu/onedark.nvim" },

  -- File-type icons (used across the UI)
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },

  -- Statusline
  { src = "https://github.com/nvim-lualine/lualine.nvim" },

  -- Fuzzy finder (file search, buffer search)
  { src = "https://github.com/ibhagwan/fzf-lua" },

  -- File explorer sidebar (needs plenary + nui)
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },

  -- VSCode-style snippet collection
  { src = "https://github.com/rafamadriz/friendly-snippets" },

  -- Completion engine (blink.cmp v2 needs blink.lib too)
  { src = "https://github.com/saghen/blink.lib" },
  { src = "https://github.com/saghen/blink.cmp" },
})
