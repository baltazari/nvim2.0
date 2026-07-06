-- ~/.config/nvim/lua/user/lsp.lua
-- LSP. Server *definitions* come from nvim-lspconfig; per-server *settings*
-- live in ~/.config/nvim/lsp/<name>.lua (Neovim reads that folder itself).
-- Servers are installed/enabled by Mason (see lua/user/mason.lua).
-- Completion is handled by blink.cmp (see lua/user/completion.lua), which
-- must be required BEFORE this file in init.lua.

vim.lsp.enable({
  "rust_analyzer", -- Rust
  "clangd",        -- C and C++
  "basedpyright",  -- Python
  "zls",  -- Zig
  "gopls", --go
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

-- Ctrl+S: format (via LSP) then save. Works in normal, insert, and visual.
vim.keymap.set({ "n", "i", "v" }, "<C-s>", function()
  vim.cmd("stopinsert")
  vim.lsp.buf.format({ async = false })
  vim.cmd("write")
end, { desc = "Format and save" })

-- How diagnostics are displayed, with VSCode-style gutter icons.
-- (Icons are Nerd Font glyphs: error circle-x, warning triangle, etc.)
vim.diagnostic.config({
  virtual_text = { prefix = "●" },  -- shows the error message at end of line
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f057}", -- circle with x
      [vim.diagnostic.severity.WARN]  = "\u{f071}", -- warning triangle
      [vim.diagnostic.severity.INFO]  = "\u{f05a}", -- info circle
      [vim.diagnostic.severity.HINT]  = "\u{f0eb}", -- lightbulb
    },
  },
})
