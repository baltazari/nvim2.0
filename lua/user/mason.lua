-- ~/.config/nvim/lua/user/mason.lua
-- Mason manages LSP server binaries for you (LazyVim-style).
-- It installs them into ~/.local/share/nvim/mason/ and adds that to
-- Neovim's PATH automatically, so you don't touch your system PATH.
--
-- This file must be required AFTER user.completion (so blink's capabilities
-- are registered) and it auto-enables every server it installs.

require("mason").setup()

require("mason-lspconfig").setup({
  -- Servers to install automatically on first launch.
  -- (Use the lspconfig names; Mason maps them to its package names.)
  ensure_installed = {
    "rust_analyzer", -- Rust
    "clangd",        -- C and C++
    "basedpyright",  -- Python
    --"csharp_ls",     -- C#  (also needs the .NET SDK on your system)
    "zls",           -- Zig
    "gopls",         --go
  },
  -- Automatically run vim.lsp.enable() for installed servers.
  automatic_enable = true,
})
