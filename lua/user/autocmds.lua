-- General autocommands.

-- Briefly highlight text when you yank (copy) it.
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})
