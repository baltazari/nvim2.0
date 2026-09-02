-- ~/.config/nvim/lua/user/finder.lua
-- Fuzzy finder (fzf-lua) + basic buffer navigation.
-- Transparent background to match the floating terminal.

require("fzf-lua").setup({
  winopts = {
    height = 0.85,
    width = 0.80,
    border = "rounded",
    backdrop = false,          -- don't dim the editor behind the popup
    winblend = 0,
    preview = { winblend = 0 },
    on_create = function()
      -- Clear the finder window's background so the terminal shows through.
      vim.wo.winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"
    end,
  },
  -- Clear fzf's OWN background (fzf paints independently of Neovim highlights).
  -- "-1" means "use the terminal's background" = transparent.
  fzf_colors = {
    ["bg"]     = "-1",
    ["bg+"]    = "-1",
    ["gutter"] = "-1",
    ["preview-bg"] = "-1",
  },
})

local map = vim.keymap.set
map("n", "<C-Space>", function() require("fzf-lua").files() end, { desc = "Find files" })
map("n", "<leader>b", function() require("fzf-lua").buffers() end, { desc = "Find buffers" })
map("n", "<leader>g", function() require("fzf-lua").live_grep() end, { desc = "Find text" })

-- Move between open buffers.
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Close the current buffer without closing the window.
map("n", "<C-x>", function()
  local cur = vim.api.nvim_get_current_buf()
  vim.cmd("bnext")
  vim.cmd("bdelete " .. cur)
end, { desc = "Close buffer" })
