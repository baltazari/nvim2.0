-- ~/.config/nvim/lua/user/bufswitch.lua
-- VSCode-style buffer switcher: Alt-Tab (normal mode) opens a floating list
-- of open files (icon + filename). Tab cycles down (circular), Shift-Tab up,
-- Enter jumps to the selected file and closes the window, Esc/q cancels.

local M = {}

local ns = vim.api.nvim_create_namespace("bufswitch")
local state = { buf = nil, win = nil, items = {}, sel = 1 }

local function set_hl()
  vim.api.nvim_set_hl(0, "BufSwitchSel", { link = "Visual", default = true })
end

local function devicons()
  local ok, di = pcall(require, "nvim-web-devicons")
  return ok and di or nil
end

-- Gather normal, listed file buffers (skips terminals and the switcher itself).
local function collect()
  local items = {}
  local di = devicons()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b)
      and vim.bo[b].buflisted
      and vim.bo[b].buftype == "" then
      local full = vim.api.nvim_buf_get_name(b)
      local name = (full ~= "") and vim.fn.fnamemodify(full, ":t") or "[No Name]"
      local icon, icon_hl = " ", "Normal"
      if di then
        local ext = vim.fn.fnamemodify(name, ":e")
        local i, h = di.get_icon(name, ext, { default = true })
        if i then icon, icon_hl = i, h end
      end
      table.insert(items, { buf = b, name = name, icon = icon, icon_hl = icon_hl })
    end
  end
  return items
end

local function line_text(it)
  return "  " .. it.icon .. "  " .. it.name .. " "
end

local function render()
  local lines = {}
  for _, it in ipairs(state.items) do
    table.insert(lines, line_text(it))
  end
  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false

  vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)
  for i, it in ipairs(state.items) do
    local row = i - 1
    if i == state.sel then
      vim.api.nvim_buf_set_extmark(state.buf, ns, row, 0,
        { line_hl_group = "BufSwitchSel" })
    end
    local icon_start = 2 -- after the two leading spaces
    vim.api.nvim_buf_set_extmark(state.buf, ns, row, icon_start,
      { end_col = icon_start + #it.icon, hl_group = it.icon_hl })
  end

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_cursor(state.win, { state.sel, 0 })
  end
end

local function close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
end

-- Move selection by delta, wrapping around (circular).
local function move(delta)
  local n = #state.items
  if n == 0 then return end
  state.sel = (state.sel - 1 + delta) % n + 1
  render()
end

local function choose()
  local it = state.items[state.sel]
  close()
  if it and vim.api.nvim_buf_is_valid(it.buf) then
    vim.api.nvim_set_current_buf(it.buf)
  end
end

function M.open()
  state.items = collect()
  if #state.items == 0 then
    vim.notify("No open buffers", vim.log.levels.INFO)
    return
  end

  -- Start on the current buffer's row.
  local cur = vim.api.nvim_get_current_buf()
  state.sel = 1
  for i, it in ipairs(state.items) do
    if it.buf == cur then state.sel = i break end
  end

  state.buf = vim.api.nvim_create_buf(false, true)
  vim.bo[state.buf].bufhidden = "wipe"

  -- Width = longest line, height = number of buffers.
  local width = 24
  for _, it in ipairs(state.items) do
    local w = vim.fn.strdisplaywidth(line_text(it))
    if w > width then width = w end
  end
  local height = #state.items
  local cols, lines = vim.o.columns, vim.o.lines

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((lines - height) / 2),
    col = math.floor((cols - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " buffers ",
    title_pos = "center",
  })

  render()

  local o = { buffer = state.buf, nowait = true, silent = true }
  vim.keymap.set("n", "<Tab>", function() move(1) end, o)
  vim.keymap.set("n", "<M-Tab>", function() move(1) end, o) -- tap Alt-Tab again to advance
  vim.keymap.set("n", "<S-Tab>", function() move(-1) end, o)
  vim.keymap.set("n", "<CR>", choose, o)
  vim.keymap.set("n", "<Esc>", close, o)
  vim.keymap.set("n", "q", close, o)
end

set_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })

-- Alt-Tab in normal mode opens the switcher.
vim.keymap.set("n", "<M-Tab>", function() M.open() end, { desc = "Buffer switcher" })

return M
