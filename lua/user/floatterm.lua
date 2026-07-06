-- ~/.config/nvim/lua/user/floatterm.lua
-- Floating terminal manager: up to 6 terminals shown in one floating window
-- with a numbered bar across the top and an underline under the active one.
--
-- Keys:
--   Ctrl-`      (normal mode)   open the terminal panel (existing, or make #1)
--   Ctrl-`      (in terminal)   create a NEW terminal (up to 6)
--   Alt-Tab     (in terminal)   move to the NEXT terminal (circular)
--   Alt-p       (in terminal)   move to the PREVIOUS terminal (circular)
--   Ctrl-\      (in terminal)   close the current terminal (kills that one)
--   Esc         (in terminal)   hide the panel (does NOT kill the terminal)

local M = {}

local MAX = 6
local terms = {}   -- list of terminal buffer numbers
local current = 0  -- index into `terms`
local win = nil    -- floating window handle (nil when hidden)

-- Colors for the top bar. Active number is bold + underlined.
local function set_highlights()
  vim.api.nvim_set_hl(0, "FloatTermActive", { bold = true, underline = true })
  vim.api.nvim_set_hl(0, "FloatTermInactive", { fg = "#7f848e" })
  vim.api.nvim_set_hl(0, "FloatTermSep", { fg = "#5c6370" })
end

-- Build the "1 | 2 | 3" title, highlighting the active terminal.
local function build_title()
  local chunks = {}
  for i = 1, #terms do
    local hl = (i == current) and "FloatTermActive" or "FloatTermInactive"
    table.insert(chunks, { " " .. i .. " ", hl })
    if i < #terms then
      table.insert(chunks, { "\u{2502}", "FloatTermSep" })
    end
  end
  if #chunks == 0 then
    chunks = { { " terminal ", "FloatTermInactive" } }
  end
  return chunks
end

local function win_config()
  local cols, lines = vim.o.columns, vim.o.lines
  local width = math.floor(cols * 0.6)
  local height = math.floor(lines * 0.6)
  return {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((lines - height) / 2),
    col = math.floor((cols - width) / 2),
    style = "minimal",
    border = "rounded",
    title = build_title(),
    title_pos = "center",
  }
end

local function is_open()
  return win ~= nil and vim.api.nvim_win_is_valid(win)
end

local function refresh_title()
  if is_open() then
    vim.api.nvim_win_set_config(win, win_config())
  end
end

-- Buffer-local keymaps active only inside our terminals.
local function setup_buf_keys(buf)
  local o = { buffer = buf }
  vim.keymap.set("t", "<Esc>", function() M.hide() end, o)
  vim.keymap.set("t", "<M-Tab>", function() M.cycle() end, o)
  vim.keymap.set("t", "<M-p>", function() M.cycle_prev() end, o)
  vim.keymap.set("t", "<C-\\>", function() M.close_current() end, o)
  vim.keymap.set("t", "<C-`>", function() M.new() end, o)
end

-- Show terminal at index `i` (open the window if needed).
local function show(i)
  if #terms == 0 then return end
  current = i
  local buf = terms[current]
  if not is_open() then
    win = vim.api.nvim_open_win(buf, true, win_config())
  else
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_set_current_win(win)
    refresh_title()
  end
  vim.cmd("startinsert")
end

-- Make a brand-new terminal and show it.
local function create()
  local buf = vim.api.nvim_create_buf(false, true)
  table.insert(terms, buf)
  current = #terms
  if not is_open() then
    win = vim.api.nvim_open_win(buf, true, win_config())
  else
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_set_current_win(win)
  end
  -- Start the shell as a terminal in this buffer (Neovim 0.12 API).
  vim.fn.jobstart(vim.o.shell, { term = true })
  setup_buf_keys(buf)
  refresh_title()
  vim.cmd("startinsert")
end

-- Hide the panel without killing anything.
function M.hide()
  if is_open() then
    vim.api.nvim_win_close(win, false)
    win = nil
  end
  vim.cmd("stopinsert")
end

-- Next terminal (wraps around: last -> first).
function M.cycle()
  if #terms == 0 then return end
  show(current % #terms + 1)
end

-- Previous terminal (wraps around: first -> last).
function M.cycle_prev()
  if #terms == 0 then return end
  show((current - 2) % #terms + 1)
end

-- Close the terminal you're currently in.
function M.close_current()
  if #terms == 0 then return end
  local buf = terms[current]
  table.remove(terms, current)
  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  if #terms == 0 then
    current = 0
    M.hide()
    return
  end
  if current > #terms then current = #terms end
  show(current)
end

-- Create a new terminal, up to MAX. At the limit it just shows the current one.
function M.new()
  if #terms >= MAX then
    if not is_open() then show(current) end
    return
  end
  create()
end

-- Ctrl-` from outside: open existing terminals (or make the first one).
-- Never adds a new terminal when ones already exist.
function M.toggle()
  if is_open() then
    M.hide()
  elseif #terms == 0 then
    create()
  else
    show(current)
  end
end

-- If a shell exits on its own (you type `exit`), drop it from the list.
vim.api.nvim_create_autocmd("TermClose", {
  callback = function(args)
    for i, b in ipairs(terms) do
      if b == args.buf then
        table.remove(terms, i)
        if current > #terms then current = #terms end
        break
      end
    end
    if #terms == 0 then M.hide() else refresh_title() end
  end,
})

set_highlights()
-- Re-apply bar colors if you change colorscheme later.
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })

-- Ctrl-` in normal mode opens/closes the panel.
vim.keymap.set("n", "<C-`>", function() M.toggle() end, { desc = "Float terminal" })

return M
