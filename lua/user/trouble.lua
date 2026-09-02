-- ~/.config/nvim/lua/user/trouble.lua
-- Diagnostics / "Problems" panel (trouble.nvim).
require("trouble").setup({
  focus = true,            -- move the cursor into the panel when it opens
  warn_no_results = false, -- stay quiet when there's nothing to show
})

local trouble = require("trouble")
local map = vim.keymap.set
-- ~/.config/nvim/lua/user/trouble.lua
-- Diagnostics / "Problems" panel (trouble.nvim).
require("trouble").setup({
  focus = true,            -- move the cursor into the panel when it opens
  warn_no_results = false, -- stay quiet when there's nothing to show
})

local trouble = require("trouble")
local map = vim.keymap.set

-- Smart toggle: if you're already IN this Trouble panel, close it.
-- Otherwise open it and jump in. (Never closes it just because you're
-- in the editor -- it focuses instead.)
local function smart(mode)
  return function()
    if trouble.is_open(mode) and vim.bo.filetype == "trouble" then
      trouble.close(mode)
    else
      trouble.open(mode)      -- setup has focus = true, so this jumps in
    end
  end
end

map("n", "<F5>", smart({ mode = "diagnostics" }),
  { desc = "Diagnostics (all)" })

map("n", "<F6>", smart({ mode = "diagnostics", filter = { buf = 0 } }),
  { desc = "Diagnostics (current file)" })

map("n", "<F7>", function()
  local trouble = require("trouble")
  if vim.bo.filetype == "trouble" then
    -- I'm inside the panel -> close it.
    trouble.close({ mode = "symbols" })
  elseif trouble.is_open({ mode = "symbols" }) then
    -- Panel is open but I'm in the editor -> jump into it.
    trouble.focus({ mode = "symbols" })
  else
    -- Not open yet -> open it and focus in.
    trouble.open({ mode = "symbols" })
    vim.defer_fn(function() trouble.focus({ mode = "symbols" }) end, 50)
  end
end, { desc = "Symbols outline" })

map("n", "<F8>", smart({ mode = "lsp" }),
  { desc = "LSP references/defs" })

map("n", "<F9>", smart({ mode = "qflist" }),
  { desc = "Quickfix list" })
