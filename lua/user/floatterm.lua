-- ~/.config/nvim/lua/user/floatterm.lua
-- Floating terminal manager: up to 6 terminals shown in one floating window
-- with a numbered bar across the top and an underline under the active one.
-- Background is transparent (uses the terminal's background).
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

-- Transparent panel: no background, colored border + tabs only.
local function set_highlights()
  vim.api.nvim_set_hl(0, "FloatTermNormal",   { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatTermBorder",   { fg = "#61afef", bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatTermActive",   { fg = "#e5c07b", bold = true, underline = true })
  vim.api.nvim_set_hl(0, "FloatTermInactive", { fg = "#5c6370" })
  vim.api.nvim_set_hl(0, "FloatTermSep",      { fg = "#3e4452" })
  -- Make sure the generic float background is clear too (colorscheme may set it).
  vim.api.nvim_set_hl(0, "NormalFloat",       { bg = "NONE" })
end

-- Title: terminal icon + "1 | 2 | 3", active one highlighted.
local function build_title()
  local chunks = { { " \u{f489} ", "FloatTermBorder" } }
  for i = 1, #terms do
    local hl = (i == current) and "FloatTermActive" or "FloatTermInactive"
    table.insert(chunks, { " " .. i .. " ", hl })
    if i < #terms then
      table.insert(chunks, { "\u{2502}", "FloatTermSep" })
    end
  end
  if #terms == 0 then
    table.insert(chunks, { " terminal ", "FloatTermInactive" })
  end
  return chunks
end

-- Footer: key hints.
local function build_footer()
  return {
    { "  new ", "FloatTermInactive" }, { "Ctrl-`", "FloatTermActive" },
    { "  \u{2502}  next ", "FloatTermInactive" }, { "Alt-Tab", "FloatTermActive" },
    { "  \u{2502}  close ", "FloatTermInactive" }, { "Ctrl-\\", "FloatTermActive" },
    { "  \u{2502}  hide ", "FloatTermInactive" }, { "Esc ", "FloatTermActive" },
  }
end

local function win_config()
  local cols, lines = vim.o.columns, vim.o.lines
  local width = math.floor(cols * 0.8)
  local height = math.floor(lines * 0.8)
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
    footer = build_footer(),
    footer_pos = "center",
  }
end

local function apply_win_style()
  if win and vim.api.nvim_win_is_valid(win) then
    -- Point the window's Normal at a cleared float group so the terminal
    -- buffer doesn't paint a solid background.
    vim.wo[win].winhighlight =
      "Normal:NormalFloat,NormalNC:NormalFloat,FloatBorder:FloatTermBorder,FloatTitle:FloatTermBorder,FloatFooter:FloatTermSep"
    vim.wo[win].winblend = 0 -- raise to ~15 for a frosted look instead of clear
  end
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
    apply_win_style()
  else
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_set_current_win(win)
    apply_win_style()
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
    apply_win_style()
  else
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_set_current_win(win)
    apply_win_style()
  end
  vim.fn.jobstart(vim.o.shell, { term = true })
  setup_buf_keys(buf)
  refresh_title()
  vim.cmd("startinsert")
end

function M.hide()
  if is_open() then
    vim.api.nvim_win_close(win, false)
    win = nil
  end
  vim.cmd("stopinsert")
end

function M.cycle()
  if #terms == 0 then return end
  show(current % #terms + 1)
end

function M.cycle_prev()
  if #terms == 0 then return end
  show((current - 2) % #terms + 1)
end

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

function M.new()
  if #terms >= MAX then
    if not is_open() then show(current) end
    return
  end
  create()
end

function M.toggle()
  if is_open() then
    M.hide()
  elseif #terms == 0 then
    create()
  else
    show(current)
  end
end

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
-- Re-clear the backgrounds whenever the colorscheme reloads (so it stays transparent).
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })

vim.keymap.set("n", "<C-`>", function() M.toggle() end, { desc = "Float terminal" })

return M
