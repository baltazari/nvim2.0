-- Fuzzy finder (fzf-lua) + buffer navigation.
require("fzf-lua").setup({
  winopts = {
    height = 0.85,
    width = 0.80,
    border = "rounded",
  },
})

local map = vim.keymap.set

-- Ctrl+Space (normal mode): floating file finder with icons (like VSCode Ctrl+P).
map("n", "<C-Space>", function() require("fzf-lua").files() end, { desc = "Find files" })

-- Bonus: pick from open buffers (like VSCode's open editors list).
map("n", "<leader>b", function() require("fzf-lua").buffers() end, { desc = "Find buffers" })

-- Tab / Shift+Tab (normal mode): move between open buffers.
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Ctrl+X (normal mode): close the current buffer, keep the window open.
map("n", "<C-x>", function()
  local cur = vim.api.nvim_get_current_buf()
  vim.cmd("bnext")
  vim.cmd("bdelete " .. cur)
end, { desc = "Close buffer" })
