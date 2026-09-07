-- ~/.config/nvim/lua/user/bufswitch.lua
--
-- VSCode-style buffer switcher:
--   Alt-Tab       Open the buffer list
--   Tab           Move down
--   Shift-Tab     Move up
--   Stop pressing Automatically open selected file after 600 ms
--   Enter         Open selected file immediately
--   Esc / q       Close without switching

local M = {}

local ns = vim.api.nvim_create_namespace("bufswitch")

local state = {
  buf = nil,
  win = nil,
  items = {},
  sel = 1,
  timer = nil,
}

local function set_hl()
  vim.api.nvim_set_hl(0, "BufSwitchSel", {
    link = "Visual",
    default = true,
  })
end

local function devicons()
  local ok, icons = pcall(require, "nvim-web-devicons")

  if ok then
    return icons
  end

  return nil
end

-- Stop and delete the automatic selection timer.
local function cancel_timer()
  if not state.timer then
    return
  end

  local timer = state.timer
  state.timer = nil

  timer:stop()

  if not timer:is_closing() then
    timer:close()
  end
end

-- Gather all normal, listed file buffers.
local function collect()
  local items = {}
  local icons = devicons()

  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    local is_valid_file_buffer =
      vim.api.nvim_buf_is_loaded(buffer)
      and vim.bo[buffer].buflisted
      and vim.bo[buffer].buftype == ""

    if is_valid_file_buffer then
      local full_path = vim.api.nvim_buf_get_name(buffer)

      -- Display the path relative to the current working directory.
      -- Example: src/system/cpu_info.cpp
      local display_name

      if full_path ~= "" then
        display_name = vim.fn.fnamemodify(full_path, ":~:.")
      else
        display_name = "[No Name]"
      end

      local icon = " "
      local icon_hl = "Normal"

      if icons and full_path ~= "" then
        local filename = vim.fn.fnamemodify(full_path, ":t")
        local extension = vim.fn.fnamemodify(full_path, ":e")

        local found_icon, found_hl = icons.get_icon(
          filename,
          extension,
          { default = true }
        )

        if found_icon then
          icon = found_icon
          icon_hl = found_hl
        end
      end

      table.insert(items, {
        buf = buffer,
        name = display_name,
        icon = icon,
        icon_hl = icon_hl,
      })
    end
  end

  return items
end

local function line_text(item)
  return "  " .. item.icon .. "  " .. item.name .. " "
end

local function render()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end

  local lines = {}

  for _, item in ipairs(state.items) do
    table.insert(lines, line_text(item))
  end

  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false

  vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)

  for index, item in ipairs(state.items) do
    local row = index - 1

    -- Highlight the selected row.
    if index == state.sel then
      vim.api.nvim_buf_set_extmark(state.buf, ns, row, 0, {
        line_hl_group = "BufSwitchSel",
      })
    end

    -- Apply the file-type color to the icon.
    local icon_start = 2

    vim.api.nvim_buf_set_extmark(
      state.buf,
      ns,
      row,
      icon_start,
      {
        end_col = icon_start + #item.icon,
        hl_group = item.icon_hl,
      }
    )
  end

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_cursor(state.win, { state.sel, 0 })
  end
end

local function close()
  cancel_timer()

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end

  state.win = nil
  state.buf = nil
end

-- Move selection and wrap around at the beginning/end.
local function move(delta)
  local item_count = #state.items

  if item_count == 0 then
    return
  end

  state.sel = (state.sel - 1 + delta) % item_count + 1
  render()
end

local function choose()
  local item = state.items[state.sel]

  close()

  if item and vim.api.nvim_buf_is_valid(item.buf) then
    vim.api.nvim_set_current_buf(item.buf)
  end
end

-- Neovim terminals cannot reliably detect when Alt is released.
-- This timer selects the file 600 ms after you stop pressing Tab.
local function schedule_choose()
  cancel_timer()

  local uv = vim.uv or vim.loop
  local timer = uv.new_timer()

  state.timer = timer

  timer:start(
    600,
    0,
    vim.schedule_wrap(function()
      if state.timer == timer then
        state.timer = nil
      end

      timer:stop()

      if not timer:is_closing() then
        timer:close()
      end

      if state.win and vim.api.nvim_win_is_valid(state.win) then
        choose()
      end
    end)
  )
end

function M.open()
  -- If the switcher is already open, move to the next buffer.
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    move(1)
    schedule_choose()
    return
  end

  state.items = collect()

  if #state.items == 0 then
    vim.notify("No open buffers", vim.log.levels.INFO)
    return
  end

  -- Start selection on the current buffer.
  local current_buffer = vim.api.nvim_get_current_buf()
  state.sel = 1

  for index, item in ipairs(state.items) do
    if item.buf == current_buffer then
      state.sel = index
      break
    end
  end

  state.buf = vim.api.nvim_create_buf(false, true)

  vim.bo[state.buf].bufhidden = "wipe"
  vim.bo[state.buf].buftype = "nofile"
  vim.bo[state.buf].swapfile = false
  vim.bo[state.buf].filetype = "bufswitch"

  -- Calculate window width from the longest displayed path.
  local width = 24

  for _, item in ipairs(state.items) do
    local item_width = vim.fn.strdisplaywidth(line_text(item))

    if item_width > width then
      width = item_width
    end
  end

  -- Prevent the window from becoming larger than the editor.
  width = math.min(width, math.max(vim.o.columns - 4, 1))

  local height = math.min(
    #state.items,
    math.max(vim.o.lines - 4, 1)
  )

  local row = math.max(
    math.floor((vim.o.lines - height) / 2),
    0
  )

  local col = math.max(
    math.floor((vim.o.columns - width) / 2),
    0
  )

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " buffers ",
    title_pos = "center",
  })

  vim.wo[state.win].cursorline = false
  vim.wo[state.win].wrap = false

  render()

  local options = {
    buffer = state.buf,
    nowait = true,
    silent = true,
  }

  vim.keymap.set("n", "<Tab>", function()
    move(1)
    schedule_choose()
  end, options)

  vim.keymap.set("n", "<M-Tab>", function()
    move(1)
    schedule_choose()
  end, options)

  vim.keymap.set("n", "<S-Tab>", function()
    move(-1)
    schedule_choose()
  end, options)

  vim.keymap.set("n", "<CR>", choose, options)
  vim.keymap.set("n", "<Esc>", close, options)
  vim.keymap.set("n", "q", close, options)

  schedule_choose()
end

set_hl()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_hl,
})

-- Alt-Tab opens the buffer switcher.
vim.keymap.set("n", "<M-Tab>", function()
  M.open()
end, {
  desc = "Buffer switcher",
})

return M
