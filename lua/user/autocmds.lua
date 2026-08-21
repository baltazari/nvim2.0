-- Python: on save, run Ruff's import-sort code action, then format.
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    -- 1. Organize imports (equivalent to: ruff check --select I --fix)
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports.ruff" }, diagnostics = {} },
      apply = true,
    })
    -- 2. Format the file (equivalent to: ruff format)
    vim.lsp.buf.format({ async = false })
  end,
})
