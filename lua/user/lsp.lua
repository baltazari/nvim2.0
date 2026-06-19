-- ~/.config/nvim/lua/user/lsp.lua
-- LSP. Server *definitions* come from nvim-lspconfig; per-server *settings*
-- live in ~/.config/nvim/lsp/<name>.lua (Neovim reads that folder itself).
-- Completion is handled by blink.cmp (see lua/user/completion.lua), which
-- must be required BEFORE this file in init.lua.
-- The server *binaries* must be installed separately (see the instructions).

vim.lsp.enable({
  "rust_analyzer", -- Rust
  "clangd",        -- C and C++
  "basedpyright",  -- Python
  "csharp_ls",     -- C#
  "zls",           -- Zig
})

-- When a server attaches to a buffer: set up keymaps.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
    end
    -- Note: grn, gra, grr, gri, K are built-in defaults on Neovim 0.11+.
    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gi", vim.lsp.buf.implementation, "Go to implementation")
    map("K", vim.lsp.buf.hover, "Hover docs")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>fm", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
    map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")
    map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
    map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
  end,
})

-- How diagnostics are displayed.
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
